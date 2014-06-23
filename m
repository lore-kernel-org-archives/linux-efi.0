From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] efi/arm64: preserve NEON registers on UEFI runtime services calls
Date: Mon, 23 Jun 2014 16:18:15 +0200
Message-ID: <1403533095-2611-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1403533095-2611-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403533095-2611-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marksalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

UEFI Runtime Services function calls may clobber the contents of the NEON
register file, so we need to make sure that we preserve/restore them when
performing such a function call.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h | 21 +++++++++++++++++++++
 arch/arm64/kernel/efi.c      | 14 +-------------
 2 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 5a46c4e7f539..375ba342dca6 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -2,6 +2,7 @@
 #define _ASM_EFI_H
 
 #include <asm/io.h>
+#include <asm/neon.h>
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
@@ -11,4 +12,24 @@ extern void efi_idmap_init(void);
 #define efi_idmap_init()
 #endif
 
+#define efi_call_virt(f, ...)						\
+({									\
+	efi_##f##_t *__f = efi.systab->runtime->f;			\
+	efi_status_t __s;						\
+									\
+	kernel_neon_begin();						\
+	__s = __f(__VA_ARGS__);						\
+	kernel_neon_end();						\
+	__s;								\
+})
+
+#define __efi_call_virt(f, ...)						\
+({									\
+	efi_##f##_t *__f = efi.systab->runtime->f;			\
+									\
+	kernel_neon_begin();						\
+	__f(__VA_ARGS__);						\
+	kernel_neon_end();						\
+})
+
 #endif /* _ASM_EFI_H */
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 14db1f6e8d7f..56c3327bbf79 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -449,19 +449,7 @@ static int __init arm64_enter_virtual_mode(void)
 
 	/* Set up runtime services function pointers */
 	runtime = efi.systab->runtime;
-	efi.get_time = runtime->get_time;
-	efi.set_time = runtime->set_time;
-	efi.get_wakeup_time = runtime->get_wakeup_time;
-	efi.set_wakeup_time = runtime->set_wakeup_time;
-	efi.get_variable = runtime->get_variable;
-	efi.get_next_variable = runtime->get_next_variable;
-	efi.set_variable = runtime->set_variable;
-	efi.query_variable_info = runtime->query_variable_info;
-	efi.update_capsule = runtime->update_capsule;
-	efi.query_capsule_caps = runtime->query_capsule_caps;
-	efi.get_next_high_mono_count = runtime->get_next_high_mono_count;
-	efi.reset_system = runtime->reset_system;
-
+	efi_native_runtime_setup();
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
 	return 0;
-- 
1.8.3.2
