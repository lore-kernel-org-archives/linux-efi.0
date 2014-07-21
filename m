From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 05/10] arm64/efi: update the PE/COFF header to be endian agnostic
Date: Mon, 21 Jul 2014 17:16:20 +0200
Message-ID: <1405955785-13477-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405955785-13477-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Update the PE/COFF header to use explicit little endian constants and use
explicit little endian linker symbols so that the PE/COFF header is always
emitted in little endian regardless of the endiannes of the kernel.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/head.S | 48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index c63f44f20ae3..5179d3df1024 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -123,7 +123,10 @@ efi_head:
 	.byte	0x4d
 	.byte	0x64
 #ifdef CONFIG_EFI
-	.long	pe_header - efi_head		// Offset to the PE header.
+	.byte	pe_header - efi_head		// Offset to the PE header.
+	.byte	0
+	.byte	0
+	.byte	0
 #else
 	.word	0				// reserved
 #endif
@@ -136,30 +139,31 @@ pe_header:
 	.ascii	"PE"
 	.short 	0
 coff_header:
-	.short	0xaa64				// AArch64
-	.short	2				// nr_sections
+	le16	0xaa64				// AArch64
+	le16	2				// nr_sections
 	.long	0 				// TimeDateStamp
 	.long	0				// PointerToSymbolTable
-	.long	1				// NumberOfSymbols
-	.short	section_table - optional_header	// SizeOfOptionalHeader
-	.short	0x206				// Characteristics.
+	le32	1				// NumberOfSymbols
+	.byte	section_table - optional_header	// SizeOfOptionalHeader
+	.byte	0
+	le16	0x206				// Characteristics.
 						// IMAGE_FILE_DEBUG_STRIPPED |
 						// IMAGE_FILE_EXECUTABLE_IMAGE |
 						// IMAGE_FILE_LINE_NUMS_STRIPPED
 optional_header:
-	.short	0x20b				// PE32+ format
+	le16	0x20b				// PE32+ format
 	.byte	0x02				// MajorLinkerVersion
 	.byte	0x14				// MinorLinkerVersion
-	.long	_end - stext			// SizeOfCode
+	.long	_efi_code_virtsize_le		// SizeOfCode
 	.long	0				// SizeOfInitializedData
 	.long	0				// SizeOfUninitializedData
-	.long	efi_stub_entry - efi_head	// AddressOfEntryPoint
-	.long	stext_offset			// BaseOfCode
+	.long	_efi_entry_point_le		// AddressOfEntryPoint
+	.long	_efi_stext_offset_le		// BaseOfCode
 
 extra_header_fields:
 	.quad	0				// ImageBase
-	.long	0x20				// SectionAlignment
-	.long	0x8				// FileAlignment
+	le32	0x20				// SectionAlignment
+	le32	0x8				// FileAlignment
 	.short	0				// MajorOperatingSystemVersion
 	.short	0				// MinorOperatingSystemVersion
 	.short	0				// MajorImageVersion
@@ -168,19 +172,19 @@ extra_header_fields:
 	.short	0				// MinorSubsystemVersion
 	.long	0				// Win32VersionValue
 
-	.long	_end - efi_head			// SizeOfImage
+	.long	_efi_image_size_le		// SizeOfImage
 
 	// Everything before the kernel image is considered part of the header
-	.long	stext_offset			// SizeOfHeaders
+	.long	_efi_stext_offset_le		// SizeOfHeaders
 	.long	0				// CheckSum
-	.short	0xa				// Subsystem (EFI application)
+	le16	0xa				// Subsystem (EFI application)
 	.short	0				// DllCharacteristics
 	.quad	0				// SizeOfStackReserve
 	.quad	0				// SizeOfStackCommit
 	.quad	0				// SizeOfHeapReserve
 	.quad	0				// SizeOfHeapCommit
 	.long	0				// LoaderFlags
-	.long	0x6				// NumberOfRvaAndSizes
+	le32	0x6				// NumberOfRvaAndSizes
 
 	.quad	0				// ExportTable
 	.quad	0				// ImportTable
@@ -208,23 +212,23 @@ section_table:
 	.long	0			// PointerToLineNumbers
 	.short	0			// NumberOfRelocations
 	.short	0			// NumberOfLineNumbers
-	.long	0x42100040		// Characteristics (section flags)
+	le32	0x42100040		// Characteristics (section flags)
 
 
 	.ascii	".text"
 	.byte	0
 	.byte	0
 	.byte	0        		// end of 0 padding of section name
-	.long	_end - stext		// VirtualSize
-	.long	stext_offset		// VirtualAddress
-	.long	_edata - stext		// SizeOfRawData
-	.long	stext_offset		// PointerToRawData
+	.long	_efi_code_virtsize_le	// VirtualSize
+	.long	_efi_stext_offset_le	// VirtualAddress
+	.long	_efi_code_rawsize_le	// SizeOfRawData
+	.long	_efi_stext_offset_le	// PointerToRawData
 
 	.long	0		// PointerToRelocations (0 for executables)
 	.long	0		// PointerToLineNumbers (0 for executables)
 	.short	0		// NumberOfRelocations  (0 for executables)
 	.short	0		// NumberOfLineNumbers  (0 for executables)
-	.long	0xe0500020	// Characteristics (section flags)
+	le32	0xe0500020	// Characteristics (section flags)
 	.align 5
 #endif
 
-- 
1.8.3.2
