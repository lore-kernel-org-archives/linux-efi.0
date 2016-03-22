From: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][v6] ACPI / PM: Introduce efi poweroff for HW-full platforms without _S5
Date: Tue, 22 Mar 2016 08:51:10 +0800
Message-ID: <1458607870-22522-1-git-send-email-yu.c.chen@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The problem is Linux registers pm_power_off = efi_power_off only if
we are in hardware reduced mode. Actually, what we also want is to do
this when ACPI S5 is simply not supported on non-legacy platforms.
Since some future Intel platforms are HW-full mode where the DSDT
fails to supply an _S5 object(without SLP_TYP), we should let such
kind of platform to leverage efi runtime service to poweroff.

This patch uses efi power off as first choice when S5 is unavailable,
even if there is a customized poweroff(driver provided, eg).
Meanwhile, the legacy platforms will not be affected because there is
no path for them to overwrite the pm_power_off to efi power off.

Suggested-by: Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v6:
 - Some modifications in the commit message.
v5:
 - Revert to version 2, enforce EFI poweroff for such kind
   of platforms.
v4:
 - Since in v3 efi_poweroff_required() is not guaranteed to run
   after all of the other code that may register alternative
   power off handling, add the pm_power_off_default that would
   be used by pm_power_off if nothing else is available.
v3:
 - Only assign pm_power_off to efi_power_off when there are no
   other pm_power_off registered at that time, in case other
   commponents would like to customize their own implementation.
---
v2:
 - Convert the acpi_no_s5 to a global bool variable in sleep.c and
   add a declaration to include/linux/acpi.h.
---
 arch/x86/platform/efi/quirks.c | 2 +-
 drivers/acpi/sleep.c           | 7 +++++++
 include/linux/acpi.h           | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index ed30e79..7e5ec62 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -340,5 +340,5 @@ bool efi_reboot_required(void)
 
 bool efi_poweroff_required(void)
 {
-	return !!acpi_gbl_reduced_hardware;
+	return acpi_gbl_reduced_hardware || acpi_no_s5;
 }
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 9cb9752..a33859c 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -25,6 +25,11 @@
 #include "internal.h"
 #include "sleep.h"
 
+/*
+ * Some HW-full platforms do not have _S5, so they may need
+ * to leverage efi power off for a shutdown.
+ */
+bool acpi_no_s5;
 static u8 sleep_states[ACPI_S_STATE_COUNT];
 
 static void acpi_sleep_tts_switch(u32 acpi_state)
@@ -846,6 +851,8 @@ int __init acpi_sleep_init(void)
 		sleep_states[ACPI_STATE_S5] = 1;
 		pm_power_off_prepare = acpi_power_off_prepare;
 		pm_power_off = acpi_power_off;
+	} else {
+		acpi_no_s5 = true;
 	}
 
 	supported[0] = 0;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 06ed7e5..4d2e67f 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -278,6 +278,7 @@ void acpi_irq_stats_init(void);
 extern u32 acpi_irq_handled;
 extern u32 acpi_irq_not_handled;
 extern unsigned int acpi_sci_irq;
+extern bool acpi_no_s5;
 #define INVALID_ACPI_IRQ	((unsigned)-1)
 static inline bool acpi_sci_irq_valid(void)
 {
-- 
1.8.4.2
