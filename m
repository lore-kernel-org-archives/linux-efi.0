From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH] arm64/efi: efistub: reuse EFI mapping for Image if it is lower
Date: Tue, 15 Jul 2014 18:50:30 +0200
Message-ID: <1405443030-4202-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The EFI loader may load Image at any available offset. This means Image may
reside very close to or at the base of DRAM, in which case the relocation
done by efi_entry() results in Image being moved up in memory, which is
undesirable (memory below the kernel is currently not usable).

To work around this, we check in the stub whether the relocated offset is higher
than the original offset. If this is the case, the original and relocated Images
switch roles, and we move the original Image inside its original lower mapping
while executing from the relocated Image.

To ensure the original mapping has sufficient size, we add 2 megs + TEXT_OFFSET
of padding to the PE/COFF .text section, this should be sufficient to cover
rounding and adding TEXT_OFFSET.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

This was tested on a Foundation Model using the patch below, which forces the
Image to be loaded at 0x80000000 (base of DRAM).

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 2b7bd5eff776..eeadc073bad3 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -138,12 +138,12 @@ pe_header:
 	.short 	0
 coff_header:
 	.short	0xaa64				// AArch64
-	.short	2				// nr_sections
+	.short	1				// nr_sections
 	.long	0 				// TimeDateStamp
 	.long	0				// PointerToSymbolTable
 	.long	1				// NumberOfSymbols
 	.short	section_table - optional_header	// SizeOfOptionalHeader
-	.short	0x206				// Characteristics.
+	.short	0x207				// Characteristics.
 						// IMAGE_FILE_DEBUG_STRIPPED |
 						// IMAGE_FILE_EXECUTABLE_IMAGE |
 						// IMAGE_FILE_LINE_NUMS_STRIPPED
@@ -158,7 +158,7 @@ optional_header:
 	.long	stext_offset			// BaseOfCode
 
 extra_header_fields:
-	.quad	0				// ImageBase
+	.quad	0x80000000			// ImageBase
 	.long	0x20				// SectionAlignment
 	.long	0x8				// FileAlignment
 	.short	0				// MajorOperatingSystemVersion
@@ -193,6 +193,7 @@ extra_header_fields:
 	// Section table
 section_table:
 
+#if 0
 	/*
 	 * The EFI application loader requires a relocation section
 	 * because EFI applications must be relocatable.  This is a
@@ -212,6 +213,7 @@ section_table:
 	.long	0x42100040		// Characteristics (section flags)
 
 
+#endif
 	.ascii	".text"
 	.byte	0
 	.byte	0


 arch/arm64/kernel/Makefile    |  1 +
 arch/arm64/kernel/efi-entry.S | 48 +++++++++++++++++++++++++++++++++----------
 arch/arm64/kernel/head.S      |  7 ++++---
 3 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index cdaedad3afe5..d55da3cd8a97 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -6,6 +6,7 @@ CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET) \
 			   -I$(src)/../../../scripts/dtc/libfdt
+AFLAGS_efi-entry.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_insn.o = -pg
diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index a0016d3a17da..d154f3c73937 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -11,6 +11,7 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <linux/sizes.h>
 
 #include <asm/assembler.h>
 
@@ -45,10 +46,13 @@ ENTRY(efi_stub_entry)
 	 *                         efi_system_table_t *sys_table,
 	 *                         unsigned long *image_addr) ;
 	 */
-	adrp	x8, _text
-	add	x8, x8, #:lo12:_text
+	adrp	x22, _text
+	add	x22, x22, #:lo12:_text		// x22: base of Image
+	adrp	x24, _edata
+	add	x24, x24, #:lo12:_edata
+	sub	x24, x24, x22			// x24: size of Image
 	add	x2, sp, 16
-	str	x8, [x2]
+	str	x22, [x2]
 	bl	efi_entry
 	cmn	x0, #1
 	b.eq	efi_load_fail
@@ -61,19 +65,41 @@ ENTRY(efi_stub_entry)
 	 */
 	mov	x20, x0		// DTB address
 	ldr	x0, [sp, #16]	// relocated _text address
-	ldr	x21, =stext_offset
-	add	x21, x0, x21
+	ldr	x23, =stext_offset
+	add	x21, x0, x23
 
 	/*
+	 * Check whether the original allocation done by the EFI loader is more
+	 * favorable (i.e., closer to the base of DRAM) than the new one created
+	 * by efi_entry(). If so, reuse the original one.
+	 */
+	adr	x3, 0f
+	cmp	x3, x0
+	bgt	1f	// this image is loaded higher, so just proceed normally
+
+	/*
+	 * Jump into the relocated image so we can move the original Image to
+	 * a 2 MB boundary + TEXT_OFFSET inside the original mapping without
+	 * overwriting ourselves.
+	 */
+	sub	x3, x3, x22	// subtract current base offset
+	add	x3, x3, x0	// add base offset of relocated image
+	br	x3		// jump to next line, but in relocated image
+
+0:	mov	x1, x0			// copy from relocated Image
+	sub	x0, x22, #1		// copy to base of original Image
+	orr	x0, x0, #(SZ_2M - 1)	// .. rounded up to 2 MB
+	ldr	x3, =(TEXT_OFFSET + 1)	// .. plus TEXT_OFFSET
+	add	x0, x0, x3
+	mov	x2, x24			// copy 'size of Image' bytes
+	bl	memcpy
+	add	x21, x0, x23		// add stext_offset to entry point
+1:
+	/*
 	 * Flush dcache covering current runtime addresses
 	 * of kernel text/data. Then flush all of icache.
 	 */
-	adrp	x1, _text
-	add	x1, x1, #:lo12:_text
-	adrp	x2, _edata
-	add	x2, x2, #:lo12:_edata
-	sub	x1, x2, x1
-
+	mov	x1, x24                 // size of Image
 	bl	__flush_dcache_area
 	ic	ialluis
 
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 5cd1f3491df5..2b7bd5eff776 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -129,6 +129,7 @@ efi_head:
 #endif
 
 #ifdef CONFIG_EFI
+#define PE_TEXT_PAD		SZ_2M + TEXT_OFFSET
 	.globl	stext_offset
 	.set	stext_offset, stext - efi_head
 	.align 3
@@ -150,7 +151,7 @@ optional_header:
 	.short	0x20b				// PE32+ format
 	.byte	0x02				// MajorLinkerVersion
 	.byte	0x14				// MinorLinkerVersion
-	.long	_edata - stext			// SizeOfCode
+	.long	_edata - stext + PE_TEXT_PAD	// SizeOfCode
 	.long	0				// SizeOfInitializedData
 	.long	0				// SizeOfUninitializedData
 	.long	efi_stub_entry - efi_head	// AddressOfEntryPoint
@@ -168,7 +169,7 @@ extra_header_fields:
 	.short	0				// MinorSubsystemVersion
 	.long	0				// Win32VersionValue
 
-	.long	_edata - efi_head		// SizeOfImage
+	.long	_edata - efi_head + PE_TEXT_PAD	// SizeOfImage
 
 	// Everything before the kernel image is considered part of the header
 	.long	stext_offset			// SizeOfHeaders
@@ -215,7 +216,7 @@ section_table:
 	.byte	0
 	.byte	0
 	.byte	0        		// end of 0 padding of section name
-	.long	_edata - stext		// VirtualSize
+	.long	_edata - stext + PE_TEXT_PAD	// VirtualSize
 	.long	stext_offset		// VirtualAddress
 	.long	_edata - stext		// SizeOfRawData
 	.long	stext_offset		// PointerToRawData
-- 
1.8.3.2
