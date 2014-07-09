From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: [PATCH] efi: Request desired alignment via the PE/COFF headers
Date: Wed,  9 Jul 2014 23:44:50 +0100
Message-ID: <1404945890-10754-1-git-send-email-mbrown@fensystems.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
---
 arch/x86/boot/header.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 7a6d43a..16ef025 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -154,7 +154,7 @@ extra_header_fields:
 #else
 	.quad	0				# ImageBase
 #endif
-	.long	0x20				# SectionAlignment
+	.long	CONFIG_PHYSICAL_ALIGN		# SectionAlignment
 	.long	0x20				# FileAlignment
 	.word	0				# MajorOperatingSystemVersion
 	.word	0				# MinorOperatingSystemVersion
-- 
1.8.4.5
