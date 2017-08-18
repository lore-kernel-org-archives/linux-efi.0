From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/14] efi/reboot: Fall back to original power-off method if EFI_RESET_SHUTDOWN returns
Date: Fri, 18 Aug 2017 20:49:39 +0100
Message-ID: <20170818194947.19347-7-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Commit 44be28e9dd98 ("x86/reboot: Add EFI reboot quirk for ACPI Hardware
Reduced flag") sets pm_power_off to efi_power_off() when the
acpi_gbl_reduced_hardware flag is set.

According to its commit message this is necessary because: "BayTrail-T
class of hardware requires EFI in order to powerdown and reboot and no
other reliable method exists"

But I have a Bay Trail CR tablet where the EFI_RESET_SHUTDOWN call does
not work, it simply returns without doing anything (AFAICT).

So it seems that some Bay Trail devices must use EFI for power-off, while
for others only ACPI works.

Note that efi_power_off() only gets used if the platform code defines
efi_poweroff_required() and that returns true, this currently only ever
happens on x86.

Since on the devices which need ACPI for power-off the EFI_RESET_SHUTDOWN
call simply returns, this patch makes the efi-reboot code remember the
old pm_power_off handler and if EFI_RESET_SHUTDOWN returns it falls back
to calling that.

This seems preferable to dmi-quirking our way out of this, since there
are likely quite a few devices suffering from this.

Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/reboot.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 62ead9b9d871..7117e2d0c7f9 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -5,6 +5,8 @@
 #include <linux/efi.h>
 #include <linux/reboot.h>
 
+void (*orig_pm_power_off)(void);
+
 int efi_reboot_quirk_mode = -1;
 
 void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
@@ -51,6 +53,12 @@ bool __weak efi_poweroff_required(void)
 static void efi_power_off(void)
 {
 	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
+	/*
+	 * The above call should not return, if it does fall back to
+	 * the original power off method (typically ACPI poweroff).
+	 */
+	if (orig_pm_power_off)
+		orig_pm_power_off();
 }
 
 static int __init efi_shutdown_init(void)
@@ -58,8 +66,10 @@ static int __init efi_shutdown_init(void)
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return -ENODEV;
 
-	if (efi_poweroff_required())
+	if (efi_poweroff_required()) {
+		orig_pm_power_off = pm_power_off;
 		pm_power_off = efi_power_off;
+	}
 
 	return 0;
 }
-- 
2.11.0
