From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 7/7] arm: efi: add PE/COFF debug table to EFI header
Date: Tue, 30 May 2017 18:36:47 +0000
Message-ID: <20170530183647.28557-8-ard.biesheuvel@linaro.org>
References: <20170530183647.28557-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530183647.28557-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This updates the PE/COFF header to emit the absolute path to the
decompressor vmlinux ELF file into a so-called NB10 Codeview entry.
This is hugely helpful when debugging the firmware->stub handover.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/boot/compressed/Makefile     |  4 ++
 arch/arm/boot/compressed/efi-header.S | 40 ++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index d50430c40045..6b978bdbac3e 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -196,3 +196,7 @@ AFLAGS_hyp-stub.o := -Wa,-march=armv7-a
 
 $(obj)/hyp-stub.S: $(srctree)/arch/$(SRCARCH)/kernel/hyp-stub.S
 	$(call cmd,shipped)
+
+ifeq ($(CONFIG_EFI)$(CONFIG_DEBUG_INFO),yy)
+AFLAGS_head.o += -DVMLINUX_PATH="\"$(realpath $(obj)/vmlinux)\""
+endif
diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index a0567ed366c6..3dedaab49cb8 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -124,6 +124,46 @@ section_table:
 
 	.set	section_count, (. - section_table) / 40
 
+#ifdef CONFIG_DEBUG_INFO
+	/*
+	 * The debug table is referenced via its Relative Virtual Address (RVA),
+	 * which is only defined for those parts of the image that are covered
+	 * by a section declaration. Since this header is not covered by any
+	 * section, the debug table must be emitted elsewhere. So stick it in
+	 * the .init.rodata section instead.
+	 *
+	 * Note that the EFI debug entry itself may legally have a zero RVA,
+	 * which means we can simply put it right after the section headers.
+	 */
+	.section	".rodata", #alloc
+
+	.align	2
+efi_debug_table:
+	// EFI_IMAGE_DEBUG_DIRECTORY_ENTRY
+	.long	0					@ Characteristics
+	.long	0					@ TimeDateStamp
+	.short	0					@ MajorVersion
+	.short	0					@ MinorVersion
+	.long	IMAGE_DEBUG_TYPE_CODEVIEW		@ Type
+	.long	efi_debug_entry_size			@ SizeOfData
+	.long	0					@ RVA
+	.long	efi_debug_entry - start			@ FileOffset
+
+	.set	efi_debug_table_size, . - efi_debug_table
+	.previous
+
+efi_debug_entry:
+	// EFI_IMAGE_DEBUG_CODEVIEW_NB10_ENTRY
+	.ascii	"NB10"					@ Signature
+	.long	0					@ Unknown
+	.long	0					@ Unknown2
+	.long	0					@ Unknown3
+
+	.asciz	VMLINUX_PATH
+
+	.set	efi_debug_entry_size, . - efi_debug_entry
+#endif
+
 	.align	12
 __efi_start:
 	.text
-- 
2.9.3
