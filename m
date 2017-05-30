From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/7] arm: efi: remove forbidden values from the PE/COFF header
Date: Tue, 30 May 2017 18:36:41 +0000
Message-ID: <20170530183647.28557-2-ard.biesheuvel@linaro.org>
References: <20170530183647.28557-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530183647.28557-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Bring the PE/COFF header in line with the PE/COFF spec, by setting
NumberOfSymbols to 0, and removing the section alignment flags.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/boot/compressed/efi-header.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index 3f7d1b74c5e0..f9e91ba4d0b1 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -43,7 +43,7 @@ coff_header:
 		.short	2			@ nr_sections
 		.long	0 			@ TimeDateStamp
 		.long	0			@ PointerToSymbolTable
-		.long	1			@ NumberOfSymbols
+		.long	0			@ NumberOfSymbols
 		.short	section_table - optional_header
 						@ SizeOfOptionalHeader
 		.short	0x306			@ Characteristics.
@@ -109,7 +109,7 @@ section_table:
 		.long	0			@ PointerToLineNumbers
 		.short	0			@ NumberOfRelocations
 		.short	0			@ NumberOfLineNumbers
-		.long	0x42100040		@ Characteristics
+		.long	0x42000040		@ Characteristics
 
 		.ascii	".text\0\0\0"
 		.long	_end - __efi_start	@ VirtualSize
@@ -120,7 +120,7 @@ section_table:
 		.long	0			@ PointerToLineNumbers
 		.short	0			@ NumberOfRelocations
 		.short	0			@ NumberOfLineNumbers
-		.long	0xe0500020		@ Characteristics
+		.long	0xe0000020		@ Characteristics
 
 		.align	9
 __efi_start:
-- 
2.9.3
