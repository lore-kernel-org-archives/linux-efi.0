From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 1/2] x86/efi: Optimize away setup_gop32/64 if unused
Date: Mon, 22 Aug 2016 12:01:21 +0200
Message-ID: <188ea850c957034d482576dfdcf8c8a2536460cf.1471823100.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Eliminate the 64 bit code path when compiling for x86_32, and vice-versa
the 32 bit code path when compiling for x86_64 with mixed mode disabled.

Size of gop.o text section:
CONFIG_X86_32:                         1758 before, 1299 after
CONFIG_X86_64 && !CONFIG_EFI_MIXED:    2201 before, 1406 after
CONFIG_X86_64 &&  CONFIG_EFI_MIXED:    2201 before and after

Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/include/asm/efi.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 6b06939..1bda245 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -207,14 +207,16 @@ struct efi_config {
 
 __pure const struct efi_config *__efi_early(void);
 
+#define efi_is_64bit()							\
+	(IS_ENABLED(CONFIG_X86_64) && (!IS_ENABLED(CONFIG_EFI_MIXED)	\
+				       || __efi_early()->is64))
+
 #define efi_call_early(f, ...)						\
 	__efi_early()->call(__efi_early()->f, __VA_ARGS__);
 
 #define __efi_call_early(f, ...)					\
 	__efi_early()->call((unsigned long)f, __VA_ARGS__);
 
-#define efi_is_64bit()		__efi_early()->is64
-
 extern bool efi_reboot_required(void);
 
 #else
-- 
2.8.1
