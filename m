From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/6] efi: Add EFI_SECURE_BOOT bit
Date: Tue, 22 Nov 2016 00:32:15 +0000
Message-ID: <147977473590.6360.6303661595805578599.stgit@warthog.procyon.org.uk>
References: <20161117123731.GA11573@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161117123731.GA11573@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: lukas@wunner.de
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>

UEFI machines can be booted in Secure Boot mode.  Add a EFI_SECURE_BOOT bit
for use with efi_enabled.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/kernel/setup.c |    5 +++++
 include/linux/efi.h     |    1 +
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9c337b0e8ba7..a197221a451b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1160,6 +1160,11 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
+	if (boot_params.secure_boot) {
+		set_bit(EFI_SECURE_BOOT, &efi.flags);
+		pr_info("Secure boot enabled\n");
+	}
+
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 615d8704f048..3864de3b40ad 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1066,6 +1066,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_ARCH_1		7	/* First arch-specific bit */
 #define EFI_DBG			8	/* Print additional debug info at runtime */
 #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
+#define EFI_SECURE_BOOT		10	/* Are we in Secure Boot mode? */
 
 #ifdef CONFIG_EFI
 /*
