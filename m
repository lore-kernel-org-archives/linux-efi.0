From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 05/12] efi: arm64: Check whether x18 is preserved by runtime services calls
Date: Thu,  8 Mar 2018 08:00:13 +0000
Message-ID: <20180308080020.22828-6-ard.biesheuvel@linaro.org>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Whether or not we will ever decide to start using x18 as a platform
register in Linux is uncertain, but by that time, we will need to
ensure that UEFI runtime services calls don't corrupt it. So let's
start issuing warnings now for this, and increase the likelihood that
these firmware images have all been replaced by that time.

This has been fixed on the EDK2 side in commit 6d73863b5464
("BaseTools/tools_def AARCH64: mark register x18 as reserved").,
dated July 13, 2017.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/efi.h       |  4 +++-
 arch/arm64/kernel/Makefile         |  3 ++-
 arch/arm64/kernel/efi-rt-wrapper.S | 41 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/efi.c            |  6 ++++++
 4 files changed, 52 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kernel/efi-rt-wrapper.S

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8389050328bb..192d791f1103 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -31,7 +31,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 ({									\
 	efi_##f##_t *__f;						\
 	__f = p->f;							\
-	__f(args);							\
+	__efi_rt_asm_wrapper(__f, #f, args);				\
 })
 
 #define arch_efi_call_virt_teardown()					\
@@ -40,6 +40,8 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 	efi_virtmap_unload();						\
 })
 
+efi_status_t __efi_rt_asm_wrapper(void *, const char *, ...);
+
 #define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
 
 /* arch specific definitions used by the stub code */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index b87541360f43..6a4bd80c75bd 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -38,7 +38,8 @@ arm64-obj-$(CONFIG_CPU_PM)		+= sleep.o suspend.o
 arm64-obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
-arm64-obj-$(CONFIG_EFI)			+= efi.o efi-entry.stub.o
+arm64-obj-$(CONFIG_EFI)			+= efi.o efi-entry.stub.o		\
+					   efi-rt-wrapper.o
 arm64-obj-$(CONFIG_PCI)			+= pci.o
 arm64-obj-$(CONFIG_ARMV8_DEPRECATED)	+= armv8_deprecated.o
 arm64-obj-$(CONFIG_ACPI)		+= acpi.o
diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
new file mode 100644
index 000000000000..05235ebb336d
--- /dev/null
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
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
+	stp	x1, x18, [sp, #16]
+
+	/*
+	 * We are lucky enough that no EFI runtime services take more than
+	 * 5 arguments, so all are passed in registers rather than via the
+	 * stack.
+	 */
+	mov	x8, x0
+	mov	x0, x2
+	mov	x1, x3
+	mov	x2, x4
+	mov	x3, x5
+	mov	x4, x6
+	blr	x8
+
+	ldp	x1, x2, [sp, #16]
+	cmp	x2, x18
+	ldp	x29, x30, [sp], #32
+	b.ne	0f
+	ret
+0:	b	efi_handle_corrupted_x18	// tail call
+ENDPROC(__efi_rt_asm_wrapper)
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index f85ac58d08a3..fb5b3cd3a1c7 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -126,3 +126,9 @@ bool efi_poweroff_required(void)
 {
 	return efi_enabled(EFI_RUNTIME_SERVICES);
 }
+
+asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
+{
+	pr_err_ratelimited(FW_BUG "register x18 corrupted by EFI %s\n", f);
+	return s;
+}
-- 
2.15.1
