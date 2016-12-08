From: David Howells <dhowells@redhat.com>
Subject: [PATCH 8/8] efi: Add EFI_SECURE_BOOT bit [ver #6]
Date: Thu, 08 Dec 2016 12:31:08 +0000
Message-ID: <148120026820.5854.13036556358308461345.stgit@warthog.procyon.org.uk>
References: <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>

UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
that can be passed to efi_enabled() to find out whether secure boot is
enabled.

This will be used by the SysRq+x handler, registered by the x86 arch, to find
out whether secure boot mode is enabled so that it can be disabled.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/kernel/setup.c |   15 +++++++++++++++
 include/linux/efi.h     |    1 +
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9c337b0e8ba7..d8972ec6257d 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1152,6 +1152,21 @@ void __init setup_arch(char **cmdline_p)
 	/* Allocate bigger log buffer */
 	setup_log_buf(1);
 
+	if (IS_ENABLED(CONFIG_EFI)) {
+		switch (boot_params.secure_boot) {
+		case efi_secureboot_mode_disabled:
+			pr_info("Secure boot disabled\n");
+			break;
+		case efi_secureboot_mode_enabled:
+			set_bit(EFI_SECURE_BOOT, &efi.flags);
+			pr_info("Secure boot enabled\n");
+			break;
+		default:
+			pr_info("Secure boot could not be determined\n");
+			break;
+		}
+	}
+
 	reserve_initrd();
 
 	acpi_table_upgrade();
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c894ed5bfa1c..e1893f5002c3 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1070,6 +1070,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_ARCH_1		7	/* First arch-specific bit */
 #define EFI_DBG			8	/* Print additional debug info at runtime */
 #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
+#define EFI_SECURE_BOOT		10	/* Are we in Secure Boot mode? */
 
 #ifdef CONFIG_EFI
 /*
