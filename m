From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 08/14] arm: efi: remove forbidden values from the PE/COFF header
Date: Fri, 18 Aug 2017 20:49:41 +0100
Message-ID: <20170818194947.19347-9-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Bring the PE/COFF header in line with the PE/COFF spec, by setting
NumberOfSymbols to 0, and removing the section alignment flags.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/boot/compressed/efi-header.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index a17ca8d78656..4169b900d9d4 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -44,7 +44,7 @@ coff_header:
 		.short	2			@ nr_sections
 		.long	0 			@ TimeDateStamp
 		.long	0			@ PointerToSymbolTable
-		.long	1			@ NumberOfSymbols
+		.long	0			@ NumberOfSymbols
 		.short	section_table - optional_header
 						@ SizeOfOptionalHeader
 		.short	0x306			@ Characteristics.
@@ -110,7 +110,7 @@ section_table:
 		.long	0			@ PointerToLineNumbers
 		.short	0			@ NumberOfRelocations
 		.short	0			@ NumberOfLineNumbers
-		.long	0x42100040		@ Characteristics
+		.long	0x42000040		@ Characteristics
 
 		.ascii	".text\0\0\0"
 		.long	_end - __efi_start	@ VirtualSize
@@ -121,7 +121,7 @@ section_table:
 		.long	0			@ PointerToLineNumbers
 		.short	0			@ NumberOfRelocations
 		.short	0			@ NumberOfLineNumbers
-		.long	0xe0500020		@ Characteristics
+		.long	0xe0000020		@ Characteristics
 
 		.align	9
 __efi_start:
-- 
2.11.0
