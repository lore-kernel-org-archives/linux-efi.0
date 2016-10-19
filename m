From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/2] efi: arm64: add vmlinux debug link to the Image binary
Date: Wed, 19 Oct 2016 12:40:32 +0100
Message-ID: <1476877232-24308-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1476877232-24308-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1476877232-24308-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: mark.rutland@arm.com, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>, leif.lindholm@linaro.org, eugene@hp.com
List-Id: linux-efi@vger.kernel.org

When building with debugging symbols, take the absolute path to the
vmlinux binary and add it to the special PE/COFF debug table entry.
This allows a debug EFI build to find the vmlinux binary, which is
very helpful in debugging, given that the offset where the Image is
first loaded by EFI is highly unpredictable.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/Makefile |  4 +++
 arch/arm64/kernel/head.S   | 34 +++++++++++++++++++-
 arch/arm64/kernel/image.h  |  3 ++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 7d66bbaafc0c..1def85599fdb 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -55,3 +55,7 @@ obj-y					+= $(arm64-obj-y) vdso/ probes/
 obj-m					+= $(arm64-obj-m)
 head-y					:= head.o
 extra-y					+= $(head-y) vmlinux.lds
+
+ifneq ($(CONFIG_DEBUG_INFO),)
+AFLAGS_head.o += -DVMLINUX_PATH="\"$(shell readlink -f $(objtree)/vmlinux)\""
+endif
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 427f6d3f084c..2f3fbd966de7 100644
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
 
+#ifdef CONFIG_DEBUG_INFO
+	.long	efi_debug_table - _head		// DebugTable
+	.long	efi_debug_table_size
+#endif
+
 	// Section table
 section_table:
 
@@ -206,6 +211,33 @@ section_table:
 efi_header_end:
 #endif
 
+#ifdef CONFIG_DEBUG_INFO
+	__INITDATA
+
+efi_debug_table:
+	// EFI_IMAGE_DEBUG_DIRECTORY_ENTRY
+	.long	0			// Characteristics
+	.long	0			// TimeDateStamp
+	.short	0			// MajorVersion
+	.short	0			// MinorVersion
+	.long	2			// Type == EFI_IMAGE_DEBUG_TYPE_CODEVIEW
+	.long	efi_debug_entry_size	// SizeOfData
+	.long	efi_debug_entry_offset	// RVA
+	.long	efi_debug_entry_offset	// FileOffset
+
+ENTRY(efi_debug_entry)
+	// EFI_IMAGE_DEBUG_CODEVIEW_NB10_ENTRY
+	.long	0x3031424E		// Signature
+	.long	0			// Unknown
+	.long	0			// Unknown2
+	.long	0			// Unknown3
+
+	.asciz	VMLINUX_PATH
+
+	.set	efi_debug_entry_size, . - efi_debug_entry
+	.set	efi_debug_table_size, . - efi_debug_table
+#endif
+
 	__INIT
 
 	/*
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index c7fcb232fe47..ad5406f011c2 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -116,6 +116,9 @@ __efistub__end			= KALLSYMS_HIDE(_end);
 __efistub__edata		= KALLSYMS_HIDE(_edata);
 __efistub_screen_info		= KALLSYMS_HIDE(screen_info);
 
+#ifdef CONFIG_DEBUG_INFO
+efi_debug_entry_offset = efi_debug_entry - _text;
+#endif
 #endif
 
 #endif /* __ASM_IMAGE_H */
-- 
2.7.4
