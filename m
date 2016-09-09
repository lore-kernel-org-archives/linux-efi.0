From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 28/29] x86/efi: Optimize away setup_gop32/64 if unused
Date: Fri,  9 Sep 2016 16:18:50 +0100
Message-ID: <20160909151851.27577-29-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160909151851.27577-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>

Commit 2c23b73c2d02 ("x86/efi: Prepare GOP handling code for reuse
as generic code") introduced an efi_is_64bit() macro to x86 which
previously only existed for arm arches.  The macro is used to
choose between the 64 bit or 32 bit code path in gop.c at runtime.

However the code path that's going to be taken is known at compile
time when compiling for x86_32 or for x86_64 with mixed mode disabled.
Amend the macro to eliminate the unused code path in those cases.

Size of gop.o text section:
CONFIG_X86_32:                         1758 before, 1299 after
CONFIG_X86_64 && !CONFIG_EFI_MIXED:    2201 before, 1406 after
CONFIG_X86_64 &&  CONFIG_EFI_MIXED:    2201 before and after

Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/include/asm/efi.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 4630e2bfa8fb..f14655e7726a 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -206,14 +206,23 @@ struct efi_config {
 
 __pure const struct efi_config *__efi_early(void);
 
+static inline bool efi_is_64bit(void)
+{
+	if (!IS_ENABLED(CONFIG_X86_64))
+		return false;
+
+	if (!IS_ENABLED(CONFIG_EFI_MIXED))
+		return true;
+
+	return __efi_early()->is64;
+}
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
2.9.3
