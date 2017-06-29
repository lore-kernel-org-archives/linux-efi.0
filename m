From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 3/7] arm: efi: replace open coded constants with symbolic ones
Date: Thu, 29 Jun 2017 08:18:45 +0000
Message-ID: <20170629081849.15081-4-ard.biesheuvel@linaro.org>
References: <20170629081849.15081-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170629081849.15081-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Replace the various open coded constants in the EFI PE/COFF header with
definitions from pe.h, or expressions based on local symbols.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/boot/compressed/efi-header.S | 128 ++++++++++----------
 1 file changed, 67 insertions(+), 61 deletions(-)

diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index 309d6198d335..542e1ad432ae 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013-2015 Linaro Ltd
+ * Copyright (C) 2013-2017 Linaro Ltd
  * Authors: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
  *          Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
  *
@@ -8,6 +8,9 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/pe.h>
+#include <linux/sizes.h>
+
 		.macro	__nop
 #ifdef CONFIG_EFI_STUB
 		@ This is almost but not quite a NOP, since it does clobber the
@@ -15,7 +18,7 @@
 		@ PE/COFF expects the magic string "MZ" at offset 0, while the
 		@ ARM/Linux boot protocol expects an executable instruction
 		@ there.
-		.inst	'M' | ('Z' << 8) | (0x1310 << 16)   @ tstne r0, #0x4d000
+		.inst	MZ_MAGIC | (0x1310 << 16)	@ tstne r0, #0x4d000
 #else
  AR_CLASS(	mov	r0, r0		)
   M_CLASS(	nop.w			)
@@ -34,78 +37,81 @@
 		@ The only 2 fields of the MSDOS header that are used are this
 		@ PE/COFF offset, and the "MZ" bytes at offset 0x0.
 		@
-		.long	pe_header - start	@ Offset to the PE header.
+		.long	pe_header - start		@ Offset to the PE header.
 
 pe_header:
-		.ascii	"PE\0\0"
+		.long	PE_MAGIC
 
 coff_header:
-		.short	0x01c2			@ ARM or Thumb
-		.short	1			@ nr_sections
-		.long	0 			@ TimeDateStamp
-		.long	0			@ PointerToSymbolTable
-		.long	0			@ NumberOfSymbols
-		.short	section_table - optional_header
-						@ SizeOfOptionalHeader
-		.short	0x306			@ Characteristics.
-						@ IMAGE_FILE_32BIT_MACHINE |
-						@ IMAGE_FILE_DEBUG_STRIPPED |
-						@ IMAGE_FILE_EXECUTABLE_IMAGE |
-						@ IMAGE_FILE_LINE_NUMS_STRIPPED
+		.short	IMAGE_FILE_MACHINE_THUMB	@ Machine
+		.short	section_count			@ NumberOfSections
+		.long	0 				@ TimeDateStamp
+		.long	0				@ PointerToSymbolTable
+		.long	0				@ NumberOfSymbols
+		.short	section_table - optional_header	@ SizeOfOptionalHeader
+		.short	IMAGE_FILE_32BIT_MACHINE | \
+			IMAGE_FILE_DEBUG_STRIPPED | \
+			IMAGE_FILE_EXECUTABLE_IMAGE | \
+			IMAGE_FILE_LINE_NUMS_STRIPPED	@ Characteristics
 
 optional_header:
-		.short	0x10b			@ PE32 format
-		.byte	0x02			@ MajorLinkerVersion
-		.byte	0x14			@ MinorLinkerVersion
-		.long	_end - __efi_start	@ SizeOfCode
-		.long	0			@ SizeOfInitializedData
-		.long	0			@ SizeOfUninitializedData
-		.long	efi_stub_entry - start	@ AddressOfEntryPoint
-		.long	start_offset		@ BaseOfCode
-		.long	0			@ data
+		.short	PE_OPT_MAGIC_PE32		@ PE32 format
+		.byte	0x02				@ MajorLinkerVersion
+		.byte	0x14				@ MinorLinkerVersion
+		.long	_end - __efi_start		@ SizeOfCode
+		.long	0				@ SizeOfInitializedData
+		.long	0				@ SizeOfUninitializedData
+		.long	efi_stub_entry - start		@ AddressOfEntryPoint
+		.long	start_offset			@ BaseOfCode
+		.long	0				@ BaseOfData
 
 extra_header_fields:
-		.long	0			@ ImageBase
-		.long	0x200			@ SectionAlignment
-		.long	0x200			@ FileAlignment
-		.short	0			@ MajorOperatingSystemVersion
-		.short	0			@ MinorOperatingSystemVersion
-		.short	0			@ MajorImageVersion
-		.short	0			@ MinorImageVersion
-		.short	0			@ MajorSubsystemVersion
-		.short	0			@ MinorSubsystemVersion
-		.long	0			@ Win32VersionValue
+		.long	0				@ ImageBase
+		.long	SZ_512				@ SectionAlignment
+		.long	SZ_512				@ FileAlignment
+		.short	0				@ MajorOsVersion
+		.short	0				@ MinorOsVersion
+		.short	0				@ MajorImageVersion
+		.short	0				@ MinorImageVersion
+		.short	0				@ MajorSubsystemVersion
+		.short	0				@ MinorSubsystemVersion
+		.long	0				@ Win32VersionValue
 
-		.long	_end - start		@ SizeOfImage
-		.long	start_offset		@ SizeOfHeaders
-		.long	0			@ CheckSum
-		.short	0xa			@ Subsystem (EFI application)
-		.short	0			@ DllCharacteristics
-		.long	0			@ SizeOfStackReserve
-		.long	0			@ SizeOfStackCommit
-		.long	0			@ SizeOfHeapReserve
-		.long	0			@ SizeOfHeapCommit
-		.long	0			@ LoaderFlags
-		.long	0x6			@ NumberOfRvaAndSizes
+		.long	_end - start			@ SizeOfImage
+		.long	start_offset			@ SizeOfHeaders
+		.long	0				@ CheckSum
+		.short	IMAGE_SUBSYSTEM_EFI_APPLICATION	@ Subsystem
+		.short	0				@ DllCharacteristics
+		.long	0				@ SizeOfStackReserve
+		.long	0				@ SizeOfStackCommit
+		.long	0				@ SizeOfHeapReserve
+		.long	0				@ SizeOfHeapCommit
+		.long	0				@ LoaderFlags
+		.long	(section_table - .) / 8		@ NumberOfRvaAndSizes
 
-		.quad	0			@ ExportTable
-		.quad	0			@ ImportTable
-		.quad	0			@ ResourceTable
-		.quad	0			@ ExceptionTable
-		.quad	0			@ CertificationTable
-		.quad	0			@ BaseRelocationTable
+		.quad	0				@ ExportTable
+		.quad	0				@ ImportTable
+		.quad	0				@ ResourceTable
+		.quad	0				@ ExceptionTable
+		.quad	0				@ CertificationTable
+		.quad	0				@ BaseRelocationTable
 
 section_table:
 		.ascii	".text\0\0\0"
-		.long	_end - __efi_start	@ VirtualSize
-		.long	__efi_start		@ VirtualAddress
-		.long	_edata - __efi_start	@ SizeOfRawData
-		.long	__efi_start		@ PointerToRawData
-		.long	0			@ PointerToRelocations
-		.long	0			@ PointerToLineNumbers
-		.short	0			@ NumberOfRelocations
-		.short	0			@ NumberOfLineNumbers
-		.long	0xe0000020		@ Characteristics
+		.long	_end - __efi_start		@ VirtualSize
+		.long	__efi_start			@ VirtualAddress
+		.long	_edata - __efi_start		@ SizeOfRawData
+		.long	__efi_start			@ PointerToRawData
+		.long	0				@ PointerToRelocations
+		.long	0				@ PointerToLineNumbers
+		.short	0				@ NumberOfRelocations
+		.short	0				@ NumberOfLineNumbers
+		.long	IMAGE_SCN_CNT_CODE | \
+			IMAGE_SCN_MEM_READ | \
+			IMAGE_SCN_MEM_WRITE | \
+			IMAGE_SCN_MEM_EXECUTE		@ Characteristics
+
+		.set	section_count, (. - section_table) / 40
 
 		.align	9
 __efi_start:
-- 
2.9.3
