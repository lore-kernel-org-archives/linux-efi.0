From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: arm64: Check whether x18 is preserved by runtime services calls
Date: Thu, 18 Jan 2018 16:37:36 +0000
Message-ID: <20180118163736.1253-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Whether or not we will ever decide to start using x18 as a platform
register in Linux is uncertain, but by that time, we will need to
ensure that UEFI runtime services calls don't corrupt it. So let's
start issuing warnings now for this, and increase the likelihood that
these firmware images have all been replaced by that time.

This has been fixed on the EDK2 side in commit 6d73863b5464
("BaseTools/tools_def AARCH64: mark register x18 as reserved").,
dated July 13, 2017.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h            |  4 +++-
 drivers/firmware/efi/Makefile           |  2 +-
 drivers/firmware/efi/arm-runtime.c      | 10 +++++++++
 drivers/firmware/efi/arm64-rt-wrapper.S | 40 +++++++++++++++++++++++++++++++++
 4 files changed, 54 insertions(+), 2 deletions(-)
 create mode 100644 drivers/firmware/efi/arm64-rt-wrapper.S

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8389050328bb..2278e4bf270a 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -31,7 +31,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 ({									\
 	efi_##f##_t *__f;						\
 	__f = p->f;							\
-	__f(args);							\
+	__efi_rt_asm_wrapper(__f, args);				\
 })
 
 #define arch_efi_call_virt_teardown()					\
@@ -40,6 +40,8 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 	efi_virtmap_unload();						\
 })
 
+efi_status_t __efi_rt_asm_wrapper(void *, ...);
+
 #define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
 
 /* arch specific definitions used by the stub code */
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 269501dfba53..eb8be0a00931 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -28,5 +28,5 @@ obj-$(CONFIG_APPLE_PROPERTIES)		+= apple-properties.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
-obj-$(CONFIG_ARM64)			+= $(arm-obj-y)
+obj-$(CONFIG_ARM64)			+= $(arm-obj-y) arm64-rt-wrapper.o
 obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= capsule-loader.o
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 1cc41c3d6315..de84b490a844 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -11,6 +11,8 @@
  *
  */
 
+#define pr_fmt(fmt)	"efi: " fmt
+
 #include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/io.h>
@@ -182,3 +184,11 @@ static int __init arm_dmi_init(void)
 	return 0;
 }
 core_initcall(arm_dmi_init);
+
+#ifdef CONFIG_ARM64
+efi_status_t efi_handle_corrupted_x18(efi_status_t s)
+{
+	pr_warn_ratelimited(FW_BUG "x18 corrupted by EFI firmware!");
+	return s;
+}
+#endif
diff --git a/drivers/firmware/efi/arm64-rt-wrapper.S b/drivers/firmware/efi/arm64-rt-wrapper.S
new file mode 100644
index 000000000000..a6a2b64134c9
--- /dev/null
+++ b/drivers/firmware/efi/arm64-rt-wrapper.S
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+
+ENTRY(__efi_rt_asm_wrapper)
+	stp	x29, x30, [sp, #-32]!
+	mov	x29, sp
+
+	/*
+	 * Register x18 is designated as the 'platform' register by the AAPCS,
+	 * which means firmware running at the same exception level as the OS
+	 * (such as UEFI) should never touch it.
+	 */
+	str	x18, [sp, #16]
+
+	/*
+	 * We are lucky enough that no EFI runtime services take more than
+	 * 5 arguments, so all are passed in registers rather than via the
+	 * stack.
+	 */
+	mov	x8, x0
+	mov	x0, x1
+	mov	x1, x2
+	mov	x2, x3
+	mov	x3, x4
+	mov	x4, x5
+	blr	x8
+
+	ldr	x1, [sp, #16]
+	cmp	x1, x18
+	ldp	x29, x30, [sp], #32
+	b.ne	efi_handle_corrupted_x18	// tail call
+	ret
+ENDPROC(__efi_rt_asm_wrapper)
-- 
2.11.0
