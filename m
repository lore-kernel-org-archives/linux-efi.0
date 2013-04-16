From: Sergey Vlasov <vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/2] x86/Kconfig: Make EFI select UCS2_STRING
Date: Tue, 16 Apr 2013 18:31:08 +0400
Message-ID: <1366122669-20898-1-git-send-email-vsu@altlinux.ru>
References: <1366056587-24414-4-git-send-email-matthew.garrett@nebula.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366056587-24414-4-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Vlasov <vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The commit "efi: Distinguish between "remaining space" and actually used
space" added usage of ucs2_*() functions to arch/x86/platform/efi/efi.c,
but the only thing which selected UCS2_STRING was EFI_VARS, which is
technically optional and can be built as a module.

Signed-off-by: Sergey Vlasov <vsu-u2l5PoMzF/Uox3rIn2DAYQ@public.gmane.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a4f24f5..01af853 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1549,6 +1549,7 @@ config X86_SMAP
 config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
+	select UCS2_STRING
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
-- 
1.8.1.1
