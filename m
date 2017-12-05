From: Gary Lin <glin@suse.com>
Subject: [RFC v3 PATCH 2/2] arm64/efi: Introduce Security Version to ARM64
Date: Tue,  5 Dec 2017 18:01:48 +0800
Message-ID: <20171205100148.5757-3-glin@suse.com>
References: <20171205100148.5757-1-glin@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20171205100148.5757-1-glin@suse.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Joey Lee <jlee@suse.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

This commit introduces Security Version for ARM64. As in x86, it
utilizes the resource section defined in the PE/COFF format(*) to locate
the struct of Security Version.

Similar to the debug table, the resource table is stored in .init.rodata
section while the struct of Security Version is in the 4K padding area of
the EFI header.

(*) PE Format: The .rsrc Section
    https://msdn.microsoft.com/zh-tw/library/windows/desktop/ms680547(v=vs.85).aspx#the_.rsrc_section

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Joey Lee <jlee@suse.com>
Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/arm64/kernel/efi-header.S | 57 ++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/Kconfig   |  6 ++---
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index 613fc3000677..f4404db6ca5c 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -61,7 +61,12 @@ extra_header_fields:
 
 	.quad	0					// ExportTable
 	.quad	0					// ImportTable
+#ifdef CONFIG_SECURITY_VERSION_SUPPORT
+	.long	rsrc_table - _head			// ResourceTable
+	.long	rsrc_table_size
+#else
 	.quad	0					// ResourceTable
+#endif
 	.quad	0					// ExceptionTable
 	.quad	0					// CertificationTable
 	.quad	0					// BaseRelocationTable
@@ -103,6 +108,58 @@ section_table:
 
 	.set	section_count, (. - section_table) / 40
 
+#ifdef CONFIG_SECURITY_VERSION_SUPPORT
+	/*
+	 * Resource Table
+	 */
+	__INITRODATA
+
+	.align	2
+rsrc_table:
+	// Resource Directory
+	.long	0					// Characteristics
+	.long	0					// TimeDateStamp
+	.short	0					// MajorVersion
+	.short	0					// MinorVersion
+	.short	1					// NumberOfNamedEntries
+	.short	0					// NumberOfIdEntries
+
+	// Resource Directory Entry
+	.long	name_offset | 0x80000000		// NameOffset:31
+							// NameIsString:1
+	.long	rsrc_data_entry - rsrc_table		// OffsetToData
+
+	.set	name_offset, . - rsrc_table
+	// Resource Directory String
+	.short	7					// Length
+	.short	0x4C00					// 'L'
+	.short	0x6900					// 'i'
+	.short	0x6E00					// 'n'
+	.short	0x7500					// 'u'
+	.short	0x7800					// 'x'
+	.short	0x5300					// 'S'
+	.short	0x5600					// 'V'
+
+	// Resource Data Entry
+rsrc_data_entry:
+	.long	svdata_begin - _head			// OffsetToData
+	.long	svdata_end - svdata_begin		// Size
+	.long	0					// CodePage
+	.long	0					// Reserved
+
+	.set	rsrc_table_size, . - rsrc_table
+	.previous
+
+	// Security Version
+svdata_begin:
+	.short	sv_signer - svdata_begin
+	.short	CONFIG_SECURITY_VERSION
+	.long	CONFIG_DISTRO_VERSION
+sv_signer:
+	.string	CONFIG_SIGNER_NAME
+svdata_end:
+#endif
+
 #ifdef CONFIG_DEBUG_EFI
 	/*
 	 * The debug table is referenced via its Relative Virtual Address (RVA),
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 1dd82f1dd094..3cad8d63897e 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -179,14 +179,14 @@ menuconfig SECURITY_VERSION_SUPPORT
 
 config SIGNER_NAME
 	string "Signer Name" if SECURITY_VERSION_SUPPORT
-	depends on EFI && X86
+	depends on EFI && (X86 || ARM64)
 	default ""
 	help
 	   This option specifies who signs or releases this kernel.
 
 config DISTRO_VERSION
 	int "Distribution Version" if SECURITY_VERSION_SUPPORT
-	depends on EFI && X86
+	depends on EFI && (X86 || ARM64)
 	default 0
 	range 0 4294967295
 	help
@@ -195,7 +195,7 @@ config DISTRO_VERSION
 
 config SECURITY_VERSION
 	int "Security Version" if SECURITY_VERSION_SUPPORT
-	depends on EFI && X86
+	depends on EFI && (X86 || ARM64)
 	default 0
 	range 0 65535
 	help
-- 
2.15.0
