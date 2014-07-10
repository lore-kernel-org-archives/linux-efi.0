From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: [PATCH v3] efi: Request desired alignment via the PE/COFF headers
Date: Thu, 10 Jul 2014 16:59:23 +0100
Message-ID: <1405007963-520-1-git-send-email-mbrown@fensystems.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The kernel will align itself to the nearest boundary specified by the
kernel_alignment field in the bzImage header.  If the kernel is loaded
to an address which is not sufficiently aligned, it will therefore use
memory beyond that indicated solely by the init_size field.

The PE/COFF headers now include a .bss section to describe the
requirements of the init_size field, but do not currently expose the
alignment requirement.  Consequently, a kernel loaded via the PE entry
point may still end up overwriting unexpected areas of memory.

Fix by exposing the desired alignment via the SectionAlignment field
in the PE/COFF headers.  Despite its name, this field provides an
overall alignment requirement for the loaded file.  (Naturally, the
FileAlignment field describes the alignment for individual sections.)

There is no way in the PE/COFF headers to express the concept of
min_alignment; we therefore do not expose the minimum (as opposed to
preferred) alignment.

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
