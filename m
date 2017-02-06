From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 6/7] efi: Print the secure boot status in x86 setup_arch()
Date: Mon,  6 Feb 2017 11:22:45 +0000
Message-ID: <1486380166-31868-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1486380166-31868-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486380166-31868-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Print the secure boot status in the x86 setup_arch() but otherwise do
nothing more for now. More functionality will be added later, but this at
least allows for testing.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
[ardb: use efi_enabled() instead of IS_ENABLED(CONFIG_EFI)]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/kernel/setup.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4cfba947d774..69780edf0dde 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1176,6 +1176,20 @@ void __init setup_arch(char **cmdline_p)
 	/* Allocate bigger log buffer */
 	setup_log_buf(1);
 
+	if (efi_enabled(EFI_BOOT)) {
+		switch (boot_params.secure_boot) {
+		case efi_secureboot_mode_disabled:
+			pr_info("Secure boot disabled\n");
+			break;
+		case efi_secureboot_mode_enabled:
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
-- 
2.7.4
