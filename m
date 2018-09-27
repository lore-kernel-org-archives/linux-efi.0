From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 10/11] efi/x86: Call efi_parse_options() from efi_main()
Date: Thu, 27 Sep 2018 10:50:37 +0200
Message-ID: <20180927085039.8391-11-ard.biesheuvel@linaro.org>
References: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

Before this commit we were only calling efi_parse_options() from
make_boot_params(), but make_boot_params() only gets called if the
kernel gets booted directly as an EFI executable. So when booted through
e.g. grub we ended up not parsing the commandline in the boot code.

This makes the drivers/firmware/efi/libstub code ignore the "quiet"
commandline argument resulting in the following message being printed:
"EFI stub: UEFI Secure Boot is enabled."

Despite the quiet request. This commits adds an extra call to
efi_parse_options() to efi_main() to make sure that the options are
always processed. This fixes quiet not working.

This also fixes the libstub code ignoring nokaslr and efi=nochunk.

Reported-by: Peter Robinson <pbrobinson@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/boot/compressed/eboot.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 1458b1700fc7..8b4c5e001157 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -738,6 +738,7 @@ efi_main(struct efi_config *c, struct boot_params *boot_params)
 	struct desc_struct *desc;
 	void *handle;
 	efi_system_table_t *_table;
+	unsigned long cmdline_paddr;
 
 	efi_early = c;
 
@@ -755,6 +756,15 @@ efi_main(struct efi_config *c, struct boot_params *boot_params)
 	else
 		setup_boot_services32(efi_early);
 
+	/*
+	 * make_boot_params() may have been called before efi_main(), in which
+	 * case this is the second time we parse the cmdline. This is ok,
+	 * parsing the cmdline multiple times does not have side-effects.
+	 */
+	cmdline_paddr = ((u64)hdr->cmd_line_ptr |
+			 ((u64)boot_params->ext_cmd_line_ptr << 32));
+	efi_parse_options((char *)cmdline_paddr);
+
 	/*
 	 * If the boot loader gave us a value for secure_boot then we use that,
 	 * otherwise we ask the BIOS.
-- 
2.18.0
