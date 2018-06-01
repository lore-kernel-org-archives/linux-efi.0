From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v6 4/5] platform/x86: touchscreen_dmi: Add EFI embedded firmware info support
Date: Fri,  1 Jun 2018 14:53:29 +0200
Message-ID: <20180601125330.25054-5-hdegoede@redhat.com>
References: <20180601125330.25054-1-hdegoede@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601125330.25054-1-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org, Torsten Duwe <duwe@suse.de>, Kees Cook <keescook@chromium.org>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Sofar we have been unable to get permission from the vendors to put the
firmware for touchscreens listed in touchscreen_dmi in linux-firmware.

Some of the tablets with such a touchscreen have a touchscreen driver, and
thus a copy of the firmware, as part of their EFI code.

This commit adds the necessary info for the new EFI embedded-firmware code
to extract these firmwares, making the touchscreen work OOTB without the
user needing to manually add the firmware.

Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v6:
-Switch from crc sums to SHA256 hashes for the firmware hashes
---
 drivers/firmware/efi/embedded-firmware.c |  3 ++
 drivers/platform/x86/Kconfig             |  1 +
 drivers/platform/x86/touchscreen_dmi.c   | 35 +++++++++++++++++++++++-
 include/linux/efi_embedded_fw.h          |  2 ++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/embedded-firmware.c b/drivers/firmware/efi/embedded-firmware.c
index 244465a162c5..19168b83cd06 100644
--- a/drivers/firmware/efi/embedded-firmware.c
+++ b/drivers/firmware/efi/embedded-firmware.c
@@ -23,6 +23,9 @@ struct embedded_fw {
 static LIST_HEAD(found_fw_list);
 
 static const struct dmi_system_id * const embedded_fw_table[] = {
+#ifdef CONFIG_TOUCHSCREEN_DMI
+	touchscreen_dmi_table,
+#endif
 	NULL
 };
 
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index d4e9670ee8cc..8c2082c8a7fd 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -1199,6 +1199,7 @@ config INTEL_TURBO_MAX_3
 config TOUCHSCREEN_DMI
 	bool "DMI based touchscreen configuration info"
 	depends on ACPI && DMI && I2C=y && TOUCHSCREEN_SILEAD
+	select EFI_EMBEDDED_FIRMWARE if EFI
 	---help---
 	  Certain ACPI based tablets with e.g. Silead or Chipone touchscreens
 	  do not have enough data in ACPI tables for the touchscreen driver to
diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 8fb489e1e16c..8eb88bfcacbe 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -15,12 +15,15 @@
 #include <linux/acpi.h>
 #include <linux/device.h>
 #include <linux/dmi.h>
+#include <linux/efi_embedded_fw.h>
 #include <linux/i2c.h>
 #include <linux/notifier.h>
 #include <linux/property.h>
 #include <linux/string.h>
 
 struct ts_dmi_data {
+	/* The EFI embedded-fw code expects this to be the first member! */
+	struct efi_embedded_fw_desc embedded_fw;
 	const char *acpi_name;
 	const struct property_entry *properties;
 };
@@ -31,10 +34,20 @@ static const struct property_entry cube_iwork8_air_props[] = {
 	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
 	PROPERTY_ENTRY_STRING("firmware-name", "gsl3670-cube-iwork8-air.fw"),
 	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	PROPERTY_ENTRY_BOOL("efi-embedded-firmware"),
 	{ }
 };
 
 static const struct ts_dmi_data cube_iwork8_air_data = {
+	.embedded_fw = {
+		.name	= "silead/gsl3670-cube-iwork8-air.fw",
+		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
+		.length	= 38808,
+		.sha256	= { 0xff, 0x62, 0x2d, 0xd1, 0x8a, 0x78, 0x04, 0x7b,
+			    0x33, 0x06, 0xb0, 0x4f, 0x7f, 0x02, 0x08, 0x9c,
+			    0x96, 0xd4, 0x9f, 0x04, 0xe1, 0x47, 0x25, 0x25,
+			    0x60, 0x77, 0x41, 0x33, 0xeb, 0x12, 0x82, 0xfc },
+	},
 	.acpi_name	= "MSSL1680:00",
 	.properties	= cube_iwork8_air_props,
 };
@@ -133,10 +146,20 @@ static const struct property_entry pipo_w2s_props[] = {
 	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
 	PROPERTY_ENTRY_STRING("firmware-name",
 			      "gsl1680-pipo-w2s.fw"),
+	PROPERTY_ENTRY_BOOL("efi-embedded-firmware"),
 	{ }
 };
 
 static const struct ts_dmi_data pipo_w2s_data = {
+	.embedded_fw = {
+		.name	= "silead/gsl1680-pipo-w2s.fw",
+		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
+		.length	= 39072,
+		.sha256	= { 0xd0, 0x58, 0xc4, 0x7d, 0x55, 0x2d, 0x62, 0x18,
+			    0xd1, 0x6a, 0x71, 0x73, 0x0b, 0x3f, 0xbe, 0x60,
+			    0xbb, 0x45, 0x8c, 0x52, 0x27, 0xb7, 0x18, 0xf4,
+			    0x31, 0x00, 0x6a, 0x49, 0x76, 0xd8, 0x7c, 0xd3 },
+	},
 	.acpi_name	= "MSSL1680:00",
 	.properties	= pipo_w2s_props,
 };
@@ -194,10 +217,20 @@ static const struct property_entry chuwi_hi8_pro_props[] = {
 	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
 	PROPERTY_ENTRY_STRING("firmware-name", "gsl3680-chuwi-hi8-pro.fw"),
 	PROPERTY_ENTRY_BOOL("silead,home-button"),
+	PROPERTY_ENTRY_BOOL("efi-embedded-firmware"),
 	{ }
 };
 
 static const struct ts_dmi_data chuwi_hi8_pro_data = {
+	.embedded_fw = {
+		.name	= "silead/gsl3680-chuwi-hi8-pro.fw",
+		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
+		.length	= 39864,
+		.sha256	= { 0xc0, 0x88, 0xc5, 0xef, 0xd1, 0x70, 0x77, 0x59,
+			    0x4e, 0xe9, 0xc4, 0xd8, 0x2e, 0xcd, 0xbf, 0x95,
+			    0x32, 0xd9, 0x03, 0x28, 0x0d, 0x48, 0x9f, 0x92,
+			    0x35, 0x37, 0xf6, 0x8b, 0x2a, 0xe4, 0x73, 0xff },
+	},
 	.acpi_name	= "MSSL1680:00",
 	.properties	= chuwi_hi8_pro_props,
 };
@@ -326,7 +359,7 @@ static const struct ts_dmi_data onda_v891w_v1_data = {
 	.properties	= onda_v891w_v1_props,
 };
 
-static const struct dmi_system_id touchscreen_dmi_table[] = {
+const struct dmi_system_id touchscreen_dmi_table[] = {
 	{
 		/* CUBE iwork8 Air */
 		.driver_data = (void *)&cube_iwork8_air_data,
diff --git a/include/linux/efi_embedded_fw.h b/include/linux/efi_embedded_fw.h
index 6c8b04246fc3..04a74578aaf0 100644
--- a/include/linux/efi_embedded_fw.h
+++ b/include/linux/efi_embedded_fw.h
@@ -20,6 +20,8 @@ struct efi_embedded_fw_desc {
 	u8 sha256[32];
 };
 
+extern const struct dmi_system_id touchscreen_dmi_table[];
+
 int efi_get_embedded_fw(const char *name, void **dat, size_t *sz, size_t msize);
 
 #endif
-- 
2.17.0
