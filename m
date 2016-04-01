From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 5/9] efi/arm64: libstub: make screen_info accessible to the UEFI stub
Date: Fri,  1 Apr 2016 18:05:31 +0200
Message-ID: <1459526735-24936-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1459526735-24936-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459526735-24936-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Unlike on 32-bit ARM, where we need to pass the stub's version of struct
screen_info to the kernel proper via a configuration table, on 64-bit ARM
it simply involves making the core kernel's copy of struct screen_info
visible to the stub by exposing an __efistub_ alias for it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h | 3 +++
 arch/arm64/kernel/efi.c      | 3 +++
 arch/arm64/kernel/image.h    | 1 +
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index bb26f2205973..ed6c85d3a583 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -54,6 +54,9 @@ int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
 #define efi_is_64bit()			(true)
 
+#define alloc_screen_info(x...)		&screen_info
+#define free_screen_info(x...)
+
 #define EFI_ALLOC_ALIGN		SZ_64K
 
 /*
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index b6abc852f2a1..6f4b3ea359db 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -17,6 +17,9 @@
 
 #include <asm/efi.h>
 
+/* we will fill this structure from the stub, so don't put it in .bss */
+struct screen_info screen_info __section(.data);
+
 int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 {
 	pteval_t prot_val;
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index 5e360ce88f10..1428849aece8 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -112,6 +112,7 @@ __efistub___memset		= KALLSYMS_HIDE(__pi_memset);
 __efistub__text			= KALLSYMS_HIDE(_text);
 __efistub__end			= KALLSYMS_HIDE(_end);
 __efistub__edata		= KALLSYMS_HIDE(_edata);
+__efistub_screen_info		= KALLSYMS_HIDE(screen_info);
 
 #endif
 
-- 
2.5.0
