From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v5 3/5] platform/x86: Rename silead_dmi to touchscreen_dmi
Date: Sun, 29 Apr 2018 11:35:56 +0200
Message-ID: <20180429093558.5411-4-hdegoede@redhat.com>
References: <20180429093558.5411-1-hdegoede@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180429093558.5411-1-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org, Torsten Duwe <duwe@suse.de>, Kees Cook <keescook@chromium.org>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Not only silead touchscreens need some extra info not available in the
ACPI tables to work properly. X86 devices with a Chipone ICN8505 chip also
need some DMI based extra configuration.

There is no reason to have separate dmi config code per touchscreen
controller vendor. This commit renames silead_dmi to a more generic
touchscreen_dmi name (and Kconfig option) in preparation of adding
info for tablets with an ICN8505 based touchscreen.

Note there are no functional changes all code changes are limited to
removing references to silead where these are no longer applicable.

Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 MAINTAINERS                                   |  2 +-
 drivers/platform/x86/Kconfig                  | 16 ++---
 drivers/platform/x86/Makefile                 |  2 +-
 .../x86/{silead_dmi.c => touchscreen_dmi.c}   | 66 +++++++++----------
 4 files changed, 43 insertions(+), 43 deletions(-)
 rename drivers/platform/x86/{silead_dmi.c => touchscreen_dmi.c} (87%)

diff --git a/MAINTAINERS b/MAINTAINERS
index bee29977a3bd..5a215bcd6660 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12795,7 +12795,7 @@ L:	linux-input@vger.kernel.org
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/input/touchscreen/silead.c
-F:	drivers/platform/x86/silead_dmi.c
+F:	drivers/platform/x86/touchscreen_dmi.c
 
 SILICON MOTION SM712 FRAME BUFFER DRIVER
 M:	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 39d06dd1f63a..7ff206e5edfe 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -1196,16 +1196,16 @@ config INTEL_TURBO_MAX_3
 	  This driver is only required when the system is not using Hardware
 	  P-States (HWP). In HWP mode, priority can be read from ACPI tables.
 
-config SILEAD_DMI
-	bool "Tablets with Silead touchscreens"
+config TOUCHSCREEN_DMI
+	bool "DMI based touchscreen configuration info"
 	depends on ACPI && DMI && I2C=y && TOUCHSCREEN_SILEAD
 	---help---
-	  Certain ACPI based tablets with Silead touchscreens do not have
-	  enough data in ACPI tables for the touchscreen driver to handle
-	  the touchscreen properly, as OEMs expected the data to be baked
-	  into the tablet model specific version of the driver shipped
-	  with the OS-image for the device. This option supplies the missing
-	  information. Enable this for x86 tablets with Silead touchscreens.
+	  Certain ACPI based tablets with e.g. Silead or Chipone touchscreens
+	  do not have enough data in ACPI tables for the touchscreen driver to
+	  handle the touchscreen properly, as OEMs expect the data to be baked
+	  into the tablet model specific version of the driver shipped with the
+	  the OS-image for the device. This option supplies the missing info.
+	  Enable this for x86 tablets with Silead or Chipone touchscreens.
 
 config INTEL_CHTDC_TI_PWRBTN
 	tristate "Intel Cherry Trail Dollar Cove TI power button driver"
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 2ba6cb795338..8d9477114fb5 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -78,7 +78,7 @@ obj-$(CONFIG_INTEL_SMARTCONNECT)	+= intel-smartconnect.o
 obj-$(CONFIG_PVPANIC)           += pvpanic.o
 obj-$(CONFIG_ALIENWARE_WMI)	+= alienware-wmi.o
 obj-$(CONFIG_INTEL_PMC_IPC)	+= intel_pmc_ipc.o
-obj-$(CONFIG_SILEAD_DMI)	+= silead_dmi.o
+obj-$(CONFIG_TOUCHSCREEN_DMI)	+= touchscreen_dmi.o
 obj-$(CONFIG_SURFACE_PRO3_BUTTON)	+= surfacepro3_button.o
 obj-$(CONFIG_SURFACE_3_BUTTON)	+= surface3_button.o
 obj-$(CONFIG_INTEL_PUNIT_IPC)  += intel_punit_ipc.o
diff --git a/drivers/platform/x86/silead_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
similarity index 87%
rename from drivers/platform/x86/silead_dmi.c
rename to drivers/platform/x86/touchscreen_dmi.c
index 452aacabaa8e..87fc839b28f7 100644
--- a/drivers/platform/x86/silead_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1,5 +1,5 @@
 /*
- * Silead touchscreen driver DMI based configuration code
+ * Touchscreen driver DMI based configuration code
  *
  * Copyright (c) 2017 Red Hat Inc.
  *
@@ -20,7 +20,7 @@
 #include <linux/property.h>
 #include <linux/string.h>
 
-struct silead_ts_dmi_data {
+struct ts_dmi_data {
 	const char *acpi_name;
 	const struct property_entry *properties;
 };
@@ -34,7 +34,7 @@ static const struct property_entry cube_iwork8_air_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data cube_iwork8_air_data = {
+static const struct ts_dmi_data cube_iwork8_air_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= cube_iwork8_air_props,
 };
@@ -48,7 +48,7 @@ static const struct property_entry jumper_ezpad_mini3_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data jumper_ezpad_mini3_data = {
+static const struct ts_dmi_data jumper_ezpad_mini3_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= jumper_ezpad_mini3_props,
 };
@@ -62,7 +62,7 @@ static const struct property_entry dexp_ursus_7w_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data dexp_ursus_7w_data = {
+static const struct ts_dmi_data dexp_ursus_7w_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= dexp_ursus_7w_props,
 };
@@ -77,7 +77,7 @@ static const struct property_entry surftab_twin_10_1_st10432_8_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data surftab_twin_10_1_st10432_8_data = {
+static const struct ts_dmi_data surftab_twin_10_1_st10432_8_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= surftab_twin_10_1_st10432_8_props,
 };
@@ -92,7 +92,7 @@ static const struct property_entry surftab_wintron70_st70416_6_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data surftab_wintron70_st70416_6_data = {
+static const struct ts_dmi_data surftab_wintron70_st70416_6_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= surftab_wintron70_st70416_6_props,
 };
@@ -107,7 +107,7 @@ static const struct property_entry gp_electronic_t701_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data gp_electronic_t701_data = {
+static const struct ts_dmi_data gp_electronic_t701_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= gp_electronic_t701_props,
 };
@@ -122,7 +122,7 @@ static const struct property_entry pipo_w2s_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data pipo_w2s_data = {
+static const struct ts_dmi_data pipo_w2s_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= pipo_w2s_props,
 };
@@ -137,7 +137,7 @@ static const struct property_entry pov_mobii_wintab_p800w_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data pov_mobii_wintab_p800w_data = {
+static const struct ts_dmi_data pov_mobii_wintab_p800w_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= pov_mobii_wintab_p800w_props,
 };
@@ -151,7 +151,7 @@ static const struct property_entry itworks_tw891_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data itworks_tw891_data = {
+static const struct ts_dmi_data itworks_tw891_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= itworks_tw891_props,
 };
@@ -165,7 +165,7 @@ static const struct property_entry chuwi_hi8_pro_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data chuwi_hi8_pro_data = {
+static const struct ts_dmi_data chuwi_hi8_pro_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= chuwi_hi8_pro_props,
 };
@@ -181,7 +181,7 @@ static const struct property_entry digma_citi_e200_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data digma_citi_e200_data = {
+static const struct ts_dmi_data digma_citi_e200_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= digma_citi_e200_props,
 };
@@ -198,7 +198,7 @@ static const struct property_entry onda_obook_20_plus_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data onda_obook_20_plus_data = {
+static const struct ts_dmi_data onda_obook_20_plus_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= onda_obook_20_plus_props,
 };
@@ -212,7 +212,7 @@ static const struct property_entry chuwi_hi8_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data chuwi_hi8_data = {
+static const struct ts_dmi_data chuwi_hi8_data = {
 	.acpi_name      = "MSSL0001:00",
 	.properties     = chuwi_hi8_props,
 };
@@ -227,7 +227,7 @@ static const struct property_entry chuwi_vi8_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data chuwi_vi8_data = {
+static const struct ts_dmi_data chuwi_vi8_data = {
 	.acpi_name      = "MSSL1680:00",
 	.properties     = chuwi_vi8_props,
 };
@@ -242,7 +242,7 @@ static const struct property_entry trekstor_primebook_c13_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data trekstor_primebook_c13_data = {
+static const struct ts_dmi_data trekstor_primebook_c13_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= trekstor_primebook_c13_props,
 };
@@ -258,7 +258,7 @@ static const struct property_entry teclast_x98plus2_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data teclast_x98plus2_data = {
+static const struct ts_dmi_data teclast_x98plus2_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= teclast_x98plus2_props,
 };
@@ -272,12 +272,12 @@ static const struct property_entry teclast_x3_plus_props[] = {
 	{ }
 };
 
-static const struct silead_ts_dmi_data teclast_x3_plus_data = {
+static const struct ts_dmi_data teclast_x3_plus_data = {
 	.acpi_name	= "MSSL1680:00",
 	.properties	= teclast_x3_plus_props,
 };
 
-static const struct dmi_system_id silead_ts_dmi_table[] = {
+static const struct dmi_system_id touchscreen_dmi_table[] = {
 	{
 		/* CUBE iwork8 Air */
 		.driver_data = (void *)&cube_iwork8_air_data,
@@ -466,22 +466,22 @@ static const struct dmi_system_id silead_ts_dmi_table[] = {
 	{ },
 };
 
-static const struct silead_ts_dmi_data *silead_ts_data;
+static const struct ts_dmi_data *ts_data;
 
-static void silead_ts_dmi_add_props(struct i2c_client *client)
+static void ts_dmi_add_props(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	int error;
 
 	if (has_acpi_companion(dev) &&
-	    !strncmp(silead_ts_data->acpi_name, client->name, I2C_NAME_SIZE)) {
-		error = device_add_properties(dev, silead_ts_data->properties);
+	    !strncmp(ts_data->acpi_name, client->name, I2C_NAME_SIZE)) {
+		error = device_add_properties(dev, ts_data->properties);
 		if (error)
 			dev_err(dev, "failed to add properties: %d\n", error);
 	}
 }
 
-static int silead_ts_dmi_notifier_call(struct notifier_block *nb,
+static int ts_dmi_notifier_call(struct notifier_block *nb,
 				       unsigned long action, void *data)
 {
 	struct device *dev = data;
@@ -491,7 +491,7 @@ static int silead_ts_dmi_notifier_call(struct notifier_block *nb,
 	case BUS_NOTIFY_ADD_DEVICE:
 		client = i2c_verify_client(dev);
 		if (client)
-			silead_ts_dmi_add_props(client);
+			ts_dmi_add_props(client);
 		break;
 
 	default:
@@ -501,22 +501,22 @@ static int silead_ts_dmi_notifier_call(struct notifier_block *nb,
 	return 0;
 }
 
-static struct notifier_block silead_ts_dmi_notifier = {
-	.notifier_call = silead_ts_dmi_notifier_call,
+static struct notifier_block ts_dmi_notifier = {
+	.notifier_call = ts_dmi_notifier_call,
 };
 
-static int __init silead_ts_dmi_init(void)
+static int __init ts_dmi_init(void)
 {
 	const struct dmi_system_id *dmi_id;
 	int error;
 
-	dmi_id = dmi_first_match(silead_ts_dmi_table);
+	dmi_id = dmi_first_match(touchscreen_dmi_table);
 	if (!dmi_id)
 		return 0; /* Not an error */
 
-	silead_ts_data = dmi_id->driver_data;
+	ts_data = dmi_id->driver_data;
 
-	error = bus_register_notifier(&i2c_bus_type, &silead_ts_dmi_notifier);
+	error = bus_register_notifier(&i2c_bus_type, &ts_dmi_notifier);
 	if (error)
 		pr_err("%s: failed to register i2c bus notifier: %d\n",
 			__func__, error);
@@ -529,4 +529,4 @@ static int __init silead_ts_dmi_init(void)
  * itself is ready (which happens at postcore initcall level), but before
  * ACPI starts enumerating devices (at subsys initcall level).
  */
-arch_initcall(silead_ts_dmi_init);
+arch_initcall(ts_dmi_init);
-- 
2.17.0
