From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4] efi: arm64: Add vmlinux debug link to the Image binary
Date: Thu,  2 Feb 2017 17:33:19 +0000
Message-ID: <1486056799-4825-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When building with debugging symbols, take the absolute path to the
vmlinux binary and add it to the special PE/COFF debug table entry.
This allows a debug EFI build to find the vmlinux binary, which is
very helpful in debugging, given that the offset where the Image is
first loaded by EFI is highly unpredictable.

On implementations of UEFI that choose to implement it, this
information is exposed via the EFI debug support table, which is a UEFI
configuration table that is accessible both by the firmware at boot time
and by the OS at runtime, and lists all PE/COFF images loaded by the
system.

The format of the NB10 Codeview entry is based on the definition used
by EDK2, which is our primary reference when it comes to the use of
PE/COFF in the context of UEFI firmware.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
v4: add a separate DEBUG_EFI debug option so that this feature is disabled
    by default
    dropped 1/2 which has been queued already in the EFI tree
    use ASCII rather than an opaque constant for "NB10" signature

 arch/arm64/Kconfig.debug   |  8 ++++
 arch/arm64/kernel/Makefile |  4 ++
 arch/arm64/kernel/head.S   | 47 +++++++++++++++++++-
 3 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index d1ebd46872fd..f7f38b1aab14 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -95,6 +95,14 @@ config DEBUG_ALIGN_RODATA
 
 	  If in doubt, say N.
 
+config DEBUG_EFI
+	depends on EFI && DEBUG_INFO
+	bool "UEFI debugging"
+	help
+	  Enable this option to include EFI specific debugging features into
+	  the kernel that are only useful when using a debug build of the
+	  UEFI firmware
+
 source "drivers/hwtracing/coresight/Kconfig"
 
 endmenu
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 7d66bbaafc0c..2600c60337ac 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -55,3 +55,7 @@ obj-y					+= $(arm64-obj-y) vdso/ probes/
 obj-m					+= $(arm64-obj-m)
 head-y					:= head.o
 extra-y					+= $(head-y) vmlinux.lds
+
+ifeq ($(CONFIG_DEBUG_EFI),y)
+AFLAGS_head.o += -DVMLINUX_PATH="\"$(shell readlink -f $(objtree)/vmlinux)\""
+endif
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 4b1abac3485a..d9faf09f6401 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -149,7 +149,7 @@ extra_header_fields:
 	.quad	0				// SizeOfHeapReserve
 	.quad	0				// SizeOfHeapCommit
 	.long	0				// LoaderFlags
-	.long	0x6				// NumberOfRvaAndSizes
+	.long	(section_table - .) / 8		// NumberOfRvaAndSizes
 
 	.quad	0				// ExportTable
 	.quad	0				// ImportTable
@@ -158,6 +158,11 @@ extra_header_fields:
 	.quad	0				// CertificationTable
 	.quad	0				// BaseRelocationTable
 
+#ifdef CONFIG_DEBUG_EFI
+	.long	efi_debug_table - _head		// DebugTable
+	.long	efi_debug_table_size
+#endif
+
 	// Section table
 section_table:
 
@@ -195,6 +200,46 @@ section_table:
 	.short	0		// NumberOfLineNumbers  (0 for executables)
 	.long	0xe0500020	// Characteristics (section flags)
 
+#ifdef CONFIG_DEBUG_EFI
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
+	__INITRODATA
+
+	.align	2
+efi_debug_table:
+	// EFI_IMAGE_DEBUG_DIRECTORY_ENTRY
+	.long	0			// Characteristics
+	.long	0			// TimeDateStamp
+	.short	0			// MajorVersion
+	.short	0			// MinorVersion
+	.long	2			// Type == EFI_IMAGE_DEBUG_TYPE_CODEVIEW
+	.long	efi_debug_entry_size	// SizeOfData
+	.long	0			// RVA
+	.long	efi_debug_entry - _head	// FileOffset
+
+	.set	efi_debug_table_size, . - efi_debug_table
+	.previous
+
+efi_debug_entry:
+	// EFI_IMAGE_DEBUG_CODEVIEW_NB10_ENTRY
+	.ascii	"NB10"			// Signature
+	.long	0			// Unknown
+	.long	0			// Unknown2
+	.long	0			// Unknown3
+
+	.asciz	VMLINUX_PATH
+
+	.set	efi_debug_entry_size, . - efi_debug_entry
+#endif
+
 	/*
 	 * EFI will load .text onwards at the 4k section alignment
 	 * described in the PE/COFF header. To ensure that instruction
-- 
2.7.4
