From: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Subject: Multiple Acer laptops hang on ACPI poweroff
Date: Fri,  3 Mar 2017 14:15:24 -0600
Message-ID: <20170303201524.8150-1-drake@endlessm.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-6IF/jdPJHihWk0Htik3J/w@public.gmane.org, chiu-6IF/jdPJHihWk0Htik3J/w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Some particular Acer/Packard Bell machines hang during shutdown.
The system completely hangs while doing bit operations for turning on SLP_EN
bit in ACPI PM1A control address and Sleep Control Register. Thus the
normal acpi_power_off path can never complete the shutdown process.

We have found a workaround to force these systems to use EFI for poweroff,
included below, but I wonder if anything better can be done. It is especially
not ideal because the system hangs the same way when going into suspend and
we don't have a workaround for that.

Any debugging tips for how to diagnose such problems?

Thanks
Daniel

---
 drivers/firmware/efi/reboot.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 62ead9b..6d1496d 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -4,6 +4,7 @@
  */
 #include <linux/efi.h>
 #include <linux/reboot.h>
+#include <linux/dmi.h>
 
 int efi_reboot_quirk_mode = -1;
 
@@ -43,6 +44,45 @@ void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
 	efi.reset_system(efi_mode, EFI_SUCCESS, 0, NULL);
 }
 
+static const struct dmi_system_id force_efi_poweroff[] = {
+        {
+                .ident = "Packard Bell Easynote ENLG81AP",
+                .matches = {
+                        DMI_MATCH(DMI_SYS_VENDOR, "Packard Bell"),
+                        DMI_MATCH(DMI_PRODUCT_NAME, "Easynote ENLG81AP"),
+                },
+        },
+        {
+                .ident = "Packard Bell Easynote ENTE69AP",
+                .matches = {
+                        DMI_MATCH(DMI_SYS_VENDOR, "Packard Bell"),
+                        DMI_MATCH(DMI_PRODUCT_NAME, "Easynote ENTE69AP"),
+                },
+        },
+        {
+                .ident = "Acer Aspire ES1-533",
+                .matches = {
+                        DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+                        DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-533"),
+                },
+        },
+        {
+                .ident = "Acer Aspire ES1-732",
+                .matches = {
+                        DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+                        DMI_MATCH(DMI_PRODUCT_NAME, "Aspire ES1-732"),
+                },
+        },
+        {}
+};
+
+bool efi_poweroff_forced(void)
+{
+	if (dmi_check_system(force_efi_poweroff))
+		return true;
+	return false;
+}
+
 bool __weak efi_poweroff_required(void)
 {
 	return false;
@@ -58,7 +98,7 @@ static int __init efi_shutdown_init(void)
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return -ENODEV;
 
-	if (efi_poweroff_required())
+	if (efi_poweroff_required() || efi_poweroff_forced())
 		pm_power_off = efi_power_off;
 
 	return 0;
-- 
2.9.3
