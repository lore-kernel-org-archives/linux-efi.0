From: Gary Lin <glin@suse.com>
Subject: [RFC v3 PATCH 1/2] x86/efi: Introduce Security Version to x86
Date: Tue,  5 Dec 2017 18:01:47 +0800
Message-ID: <20171205100148.5757-2-glin@suse.com>
References: <20171205100148.5757-1-glin@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205100148.5757-1-glin@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, Joey Lee <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

Security Version is a mechanism based on UEFI Secure Boot to keep the
user from loading an insecure kernel accidentally. It's a monotonically
increasing number representing how "secure" the kernel is. The distro
kernel maintainer has to specify the distro name (signer) and the distro
version to distinguish the distro kernel among other kernel images. When
a critical vulnerability is fixed, the maintainer bumps Security Version,
and the bootloader (e.g. shim) records the Security Version in a UEFI
BootService variable. If the user tries to load a kernel with a lower
Security Version, the bootloader shows a warning prompt, and the user
decides whether to boot the kernel or not.

For the better portability, Security Version utilizes the resource
section(*) of PE/COFF to locate the struct of Security Version. The
resource section is a read-only section to index data in a binary-sorted
tree structure. The Windows images stores the resource data in a three
levels struture. For simplicity, we only use one level for Security
Version. A directory called "LinuxSV" is created and it contains the
offset to the struct of Security Version. The bootloader just follows
the resource table to fetch the details.

The struct of Security Version can be presented as the following:

struct sv_hdr {
	__u16 header_length;
	__u16 security_version;
	__u32 distro_version;
} __attribute__((packed));
char *signer;

It consists of a fixed size structure and a null-terminated string.
"header_length" is the size of "struct sv_hdr". It's also used as a
kind of the "header version" in case a new member is introduced later.

(*) PE Format: The .rsrc Section
    https://msdn.microsoft.com/zh-tw/library/windows/desktop/ms680547(v=vs.85).aspx#the_.rsrc_section

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Joey Lee <jlee@suse.com>
Signed-off-by: Gary Lin <glin@suse.com>
---
 arch/x86/boot/header.S       | 55 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/Kconfig | 40 ++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 850b8762e889..dc1b80b29478 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -188,7 +188,12 @@ extra_header_fields:
 
 	.quad	0				# ExportTable
 	.quad	0				# ImportTable
+#ifdef CONFIG_SECURITY_VERSION_SUPPORT
+	.long	rsrc_table			# ResourceTable
+	.long	rsrc_table_size
+#else
 	.quad	0				# ResourceTable
+#endif
 	.quad	0				# ExceptionTable
 	.quad	0				# CertificationTable
 	.quad	0				# BaseRelocationTable
@@ -634,3 +639,53 @@ die:
 setup_corrupt:
 	.byte	7
 	.string	"No setup signature found...\n"
+
+#ifdef CONFIG_SECURITY_VERSION_SUPPORT
+# Resource Table
+	.section ".rodata", "a", @progbits
+	.align	2
+rsrc_table:
+	# Resource Directory
+	.long	0				# Characteristics
+	.long	0				# TimeDateStamp
+	.short	0				# MajorVersion
+	.short	0				# MinorVersion
+	.short	1				# NumberOfNamedEntries
+	.short	0				# NumberOfIdEntries
+
+	# Resource Directory Entry
+	.long	name_offset | 0x80000000	# NameOffset:31
+						# NameIsString:1
+	.long	rsrc_data_entry - rsrc_table	# OffsetToData
+
+	.set	name_offset, . - rsrc_table
+	# Resource Directory String
+	.short	7				# Length
+	.short	0x4C00				# 'L'
+	.short	0x6900				# 'i'
+	.short	0x6E00				# 'n'
+	.short	0x7500				# 'u'
+	.short	0x7800				# 'x'
+	.short	0x5300				# 'S'
+	.short	0x5600				# 'V'
+
+	.set	svdata_entry_offset, . - rsrc_table
+	# Resource Data Entry
+rsrc_data_entry:
+	.long	svdata_begin			# OffsetToData
+	.long	svdata_end - svdata_begin	# Size
+	.long	0				# CodePage
+	.long	0				# Reserved
+
+	.set	rsrc_table_size, . - rsrc_table
+
+	# Security Version
+svdata_begin:
+	.short	sv_signer - svdata_begin
+	.short	CONFIG_SECURITY_VERSION
+	.long	CONFIG_DISTRO_VERSION
+sv_signer:
+	.string	CONFIG_SIGNER_NAME
+svdata_end:
+
+#endif /* CONFIG_SECURITY_VERSION_SUPPORT */
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2b4c39fdfa91..1dd82f1dd094 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -161,6 +161,46 @@ config RESET_ATTACK_MITIGATION
 	  still contains secrets in RAM, booting another OS and extracting the
 	  secrets.
 
+menuconfig SECURITY_VERSION_SUPPORT
+	bool "Security Version Support" if EFI_STUB
+	help
+	   The security version is the number defined by the distribution
+	   to indicate the critical security fixes. The bootloader could
+	   maintain a list of the security versions of the current kernels.
+	   After fixing a severe vulnerability in the kernel, the distribution
+	   bumps the security version to notify the bootloader to update
+	   the list. If the user tries to load a kernel with a smaller security
+	   version, the bootloadr could show a warning to the user to avoid
+	   a vulnerable kernel from being loaded accidentally.
+
+	   This is mainly designed for the distribution kernel maintainer.
+	   Say N if you don't know what it is.
+
+
+config SIGNER_NAME
+	string "Signer Name" if SECURITY_VERSION_SUPPORT
+	depends on EFI && X86
+	default ""
+	help
+	   This option specifies who signs or releases this kernel.
+
+config DISTRO_VERSION
+	int "Distribution Version" if SECURITY_VERSION_SUPPORT
+	depends on EFI && X86
+	default 0
+	range 0 4294967295
+	help
+	  This option specifies the distribution version which this
+	  kernel belongs to.
+
+config SECURITY_VERSION
+	int "Security Version" if SECURITY_VERSION_SUPPORT
+	depends on EFI && X86
+	default 0
+	range 0 65535
+	help
+	   This option specifies the security version of this kernel.
+
 endmenu
 
 config UEFI_CPER
-- 
2.15.0
