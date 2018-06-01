From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 5/5] platform/x86: touchscreen_dmi: Add info for the Chuwi Vi8 Plus tablet
Date: Fri,  1 Jun 2018 14:53:30 +0200
Message-ID: <20180601125330.25054-6-hdegoede@redhat.com>
References: <20180601125330.25054-1-hdegoede@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601125330.25054-1-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org, Torsten Duwe <duwe@suse.de>, Kees Cook <keescook@chromium.org>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Add touchscreen info for the Chuwi Vi8 Plus tablet. This tablet uses a
Chipone ICN8505 touchscreen controller, with the firmware used by the
touchscreen embedded in the EFI firmware.

Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v6:
-Switch from crc sums to SHA256 hashes for the firmware hash
---
 drivers/platform/x86/touchscreen_dmi.c | 28 ++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 8eb88bfcacbe..99eb73bbd1a0 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -359,6 +359,25 @@ static const struct ts_dmi_data onda_v891w_v1_data = {
 	.properties	= onda_v891w_v1_props,
 };
 
+static const struct property_entry efi_embedded_fw_props[] = {
+	PROPERTY_ENTRY_BOOL("efi-embedded-firmware"),
+	{ }
+};
+
+static const struct ts_dmi_data chuwi_vi8_plus_data = {
+	.embedded_fw = {
+		.name	= "chipone/icn8505-HAMP0002.fw",
+		.prefix = { 0xb0, 0x07, 0x00, 0x00, 0xe4, 0x07, 0x00, 0x00 },
+		.length	= 35012,
+		.sha256	= { 0x93, 0xe5, 0x49, 0xe0, 0xb6, 0xa2, 0xb4, 0xb3,
+			    0x88, 0x96, 0x34, 0x97, 0x5e, 0xa8, 0x13, 0x78,
+			    0x72, 0x98, 0xb8, 0x29, 0xeb, 0x5c, 0xa7, 0xf1,
+			    0x25, 0x13, 0x43, 0xf4, 0x30, 0x7c, 0xfc, 0x7c },
+	},
+	.acpi_name	= "CHPN0001:00",
+	.properties	= efi_embedded_fw_props,
+};
+
 const struct dmi_system_id touchscreen_dmi_table[] = {
 	{
 		/* CUBE iwork8 Air */
@@ -587,6 +606,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "ONDA.W89EBBN08"),
 		},
 	},
+	{
+		/* Chuwi Vi8 Plus (CWI506) */
+		.driver_data = (void *)&chuwi_vi8_plus_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hampoo"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "D2D3_Vi8A1"),
+			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+		},
+	},
 	{ },
 };
 
-- 
2.17.0
