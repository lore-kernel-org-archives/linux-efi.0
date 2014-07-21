From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 01/10] arm64/efi: efistub: jump to 'stext' directly, not through the header
Date: Mon, 21 Jul 2014 17:16:16 +0200
Message-ID: <1405955785-13477-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405955785-13477-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

After the EFI stub has done its business, it jumps into the kernel by branching
to offset #0 of the loaded Image, which is where it expects to find the header
containing a 'branch to stext' instruction.

However, the header is not covered by any PE/COFF section, so the header may
not actually be loaded at the expected offset. So instead, jump to 'stext'
directly, which is at the base of the PE/COFF .text section, by supplying a
symbol 'stext_offset' to efi-entry.o which contains the relative offset of
stext into the Image. Also replace other open coded calculations of the same
value with a reference to 'stext_offset'

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi-entry.S |  3 ++-
 arch/arm64/kernel/head.S      | 10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index 619b1dd7bcde..a0016d3a17da 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -61,7 +61,8 @@ ENTRY(efi_stub_entry)
 	 */
 	mov	x20, x0		// DTB address
 	ldr	x0, [sp, #16]	// relocated _text address
-	mov	x21, x0
+	ldr	x21, =stext_offset
+	add	x21, x0, x21
 
 	/*
 	 * Flush dcache covering current runtime addresses
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 69dafe9621fd..5cd1f3491df5 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -129,6 +129,8 @@ efi_head:
 #endif
 
 #ifdef CONFIG_EFI
+	.globl	stext_offset
+	.set	stext_offset, stext - efi_head
 	.align 3
 pe_header:
 	.ascii	"PE"
@@ -152,7 +154,7 @@ optional_header:
 	.long	0				// SizeOfInitializedData
 	.long	0				// SizeOfUninitializedData
 	.long	efi_stub_entry - efi_head	// AddressOfEntryPoint
-	.long	stext - efi_head		// BaseOfCode
+	.long	stext_offset			// BaseOfCode
 
 extra_header_fields:
 	.quad	0				// ImageBase
@@ -169,7 +171,7 @@ extra_header_fields:
 	.long	_edata - efi_head		// SizeOfImage
 
 	// Everything before the kernel image is considered part of the header
-	.long	stext - efi_head		// SizeOfHeaders
+	.long	stext_offset			// SizeOfHeaders
 	.long	0				// CheckSum
 	.short	0xa				// Subsystem (EFI application)
 	.short	0				// DllCharacteristics
@@ -214,9 +216,9 @@ section_table:
 	.byte	0
 	.byte	0        		// end of 0 padding of section name
 	.long	_edata - stext		// VirtualSize
-	.long	stext - efi_head	// VirtualAddress
+	.long	stext_offset		// VirtualAddress
 	.long	_edata - stext		// SizeOfRawData
-	.long	stext - efi_head	// PointerToRawData
+	.long	stext_offset		// PointerToRawData
 
 	.long	0		// PointerToRelocations (0 for executables)
 	.long	0		// PointerToLineNumbers (0 for executables)
-- 
1.8.3.2
