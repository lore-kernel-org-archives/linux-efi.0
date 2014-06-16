From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 2/4] efi/arm64: efistub: move shared dependencies to <asm/efi.h>
Date: Mon, 16 Jun 2014 17:14:46 +0200
Message-ID: <1402931688-23597-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1402931688-23597-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402931688-23597-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This moves definitions depended upon both by code under arch/arm64/boot and
under drivers/firmware/efi to <asm/efi.h>. This is in preparation of turning
the stub code under drivers/firmware/efi into a static library.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h | 13 +++++++++++++
 arch/arm64/kernel/efi-stub.c | 11 +----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 5a46c4e7f539..9eac34a2725a 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -11,4 +11,17 @@ extern void efi_idmap_init(void);
 #define efi_idmap_init()
 #endif
 
+
+/* arch specific definitions used by the stub code */
+
+/*
+ * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
+ * start of kernel and may not cross a 2MiB boundary. We set alignment to
+ * 2MiB so we know it won't cross a 2MiB boundary.
+ */
+#define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
+#define MAX_FDT_OFFSET	SZ_512M
+
+#define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
+
 #endif /* _ASM_EFI_H */
diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 7aa7155a9740..23cbde4324b1 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -10,19 +10,10 @@
  *
  */
 #include <linux/efi.h>
+#include <asm/efi.h>
 #include <linux/libfdt.h>
 #include <asm/sections.h>
 
-/*
- * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
- * start of kernel and may not cross a 2MiB boundary. We set alignment to
- * 2MiB so we know it won't cross a 2MiB boundary.
- */
-#define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
-#define MAX_FDT_OFFSET	SZ_512M
-
-#define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
-
 static void efi_char16_printk(efi_system_table_t *sys_table_arg,
 			      efi_char16_t *str);
 
-- 
1.8.3.2
