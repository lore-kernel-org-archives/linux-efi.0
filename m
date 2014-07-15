From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] arm64/efi: efistub: cover entire static mem footprint in PE/COFF .text
Date: Tue, 15 Jul 2014 12:58:20 +0200
Message-ID: <1405421900-11733-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The static memory footprint of a kernel Image at boot is larger than the
Image file itself. Things like .bss data and initial page tables are allocated
statically but populated dynamically so their content is not contained in the
Image file.

However, if EFI has loaded the Image at precisely the desired offset of
base of DRAM + TEXT_OFFSET, the Image will be booted in place, and we have
to make sure that the allocation done by the EFI loader is large enough.

Fix this by growing the PE/COFF .text section to cover the entire static
memory footprint. The part of the section that is not covered by the payload
will be zero initialised by the EFI loader.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/head.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 78ddae28b090..bbf2489939c2 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -158,7 +158,7 @@ optional_header:
 	.short	0x20b				// PE32+ format
 	.byte	0x02				// MajorLinkerVersion
 	.byte	0x14				// MinorLinkerVersion
-	.long	_edata - stext			// SizeOfCode
+	.long	_end - stext			// SizeOfCode
 	.long	0				// SizeOfInitializedData
 	.long	0				// SizeOfUninitializedData
 	.long	efi_stub_entry - efi_head	// AddressOfEntryPoint
@@ -176,7 +176,7 @@ extra_header_fields:
 	.short	0				// MinorSubsystemVersion
 	.long	0				// Win32VersionValue
 
-	.long	_edata - efi_head		// SizeOfImage
+	.long	_end - efi_head			// SizeOfImage
 
 	// Everything before the kernel image is considered part of the header
 	.long	stext_offset			// SizeOfHeaders
@@ -223,7 +223,7 @@ section_table:
 	.byte	0
 	.byte	0
 	.byte	0        		// end of 0 padding of section name
-	.long	_edata - stext		// VirtualSize
+	.long	_end - stext		// VirtualSize
 	.long	stext_offset		// VirtualAddress
 	.long	_edata - stext		// SizeOfRawData
 	.long	stext_offset		// PointerToRawData
-- 
1.8.3.2
