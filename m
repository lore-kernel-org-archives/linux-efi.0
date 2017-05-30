From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/7] arm: efi: remove pointless dummy .reloc section
Date: Tue, 30 May 2017 18:36:42 +0000
Message-ID: <20170530183647.28557-3-ard.biesheuvel@linaro.org>
References: <20170530183647.28557-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530183647.28557-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The kernel's EFI PE/COFF header contains a dummy .reloc section, and
an explanatory comment that claims that this is required for the EFI
application loader to accept the Image as a relocatable image (i.e.,
one that can be loaded at any offset and fixed up in place)

This was inherited from the x86 implementation, which has elaborate host
tooling to mangle the PE/COFF header post-link time, and which populates
the .reloc section with a single dummy base relocation. On ARM, no such
tooling exists, and the .reloc section remains empty, and is never even
exposed via the BaseRelocationTable directory entry, which is where the
PE/COFF loader looks for it.

The PE/COFF spec is unclear about relocatable images that do not require
any fixups, but the EDK2 implementation, which is the de facto reference
for PE/COFF in the UEFI space, clearly does not care, and explicitly
mentions (in a comment) that relocatable images with no base relocations
are perfectly fine, as long as they don't have the RELOCS_STRIPPED
attribute set (which is not the case for our PE/COFF image)

So simply remove the .reloc section altogether.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/boot/compressed/efi-header.S | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index f9e91ba4d0b1..97f595970916 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -40,7 +40,7 @@ pe_header:
 
 coff_header:
 		.short	0x01c2			@ ARM or Thumb
-		.short	2			@ nr_sections
+		.short	1			@ nr_sections
 		.long	0 			@ TimeDateStamp
 		.long	0			@ PointerToSymbolTable
 		.long	0			@ NumberOfSymbols
@@ -95,22 +95,6 @@ extra_header_fields:
 		.quad	0			@ BaseRelocationTable
 
 section_table:
-		@
-		@ The EFI application loader requires a relocation section
-		@ because EFI applications must be relocatable. This is a
-		@ dummy section as far as we are concerned.
-		@
-		.ascii	".reloc\0\0"
-		.long	0			@ VirtualSize
-		.long	0			@ VirtualAddress
-		.long	0			@ SizeOfRawData
-		.long	0			@ PointerToRawData
-		.long	0			@ PointerToRelocations
-		.long	0			@ PointerToLineNumbers
-		.short	0			@ NumberOfRelocations
-		.short	0			@ NumberOfLineNumbers
-		.long	0x42000040		@ Characteristics
-
 		.ascii	".text\0\0\0"
 		.long	_end - __efi_start	@ VirtualSize
 		.long	__efi_start		@ VirtualAddress
-- 
2.9.3
