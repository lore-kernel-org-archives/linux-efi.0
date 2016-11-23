From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/6] efi: Add EFI_SECURE_BOOT bit [ver #2]
Date: Wed, 23 Nov 2016 00:23:12 +0000
Message-ID: <147986059202.13790.3471243422582131819.stgit@warthog.procyon.org.uk>
References: <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: lukas@wunner.de
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, keyrings@vger.kernel.org
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

 arch/x86/kernel/setup.c |    7 +++++++
 include/linux/efi.h     |    1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9c337b0e8ba7..522915d6de1f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1160,6 +1160,13 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
+#ifdef CONFIG_EFI
+	if (boot_params.secure_boot) {
+		set_bit(EFI_SECURE_BOOT, &efi.flags);
+		pr_info("Secure boot enabled\n");
+	}
+#endif
+
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ff01ad6f2823..d95bb9e69974 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1066,6 +1066,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_ARCH_1		7	/* First arch-specific bit */
 #define EFI_DBG			8	/* Print additional debug info at runtime */
 #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
+#define EFI_SECURE_BOOT		10	/* Are we in Secure Boot mode? */
 
 #ifdef CONFIG_EFI
 /*
