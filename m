From: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][RFC,v4] ACPI / PM: Introduce efi poweroff for HW-full platforms without _S5
Date: Fri, 11 Mar 2016 17:05:33 +0800
Message-ID: <1457687133-3730-1-git-send-email-yu.c.chen@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, rui.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The problem is Linux registers pm_power_off = efi_power_off
only if we are in hardware reduced mode. Actually, what we also
want is to do this when ACPI S5 is simply not supported on
non-legacy platforms. That should handle both the HW reduced mode,
and the HW-full mode where the DSDT fails to supply an _S5 object.

This patch introduces pm_power_off_default which would be used by
pm_power_off if nothing else is available. And in this case we
leverage efi power off to be this role. However since efi power off
may not be stable enough thus in order not to interfere with other
poweroff path, we only make a minimum enhancement for x86 in
native_machine_power_off.

Suggested-by: Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
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
 arch/x86/kernel/reboot.c       | 3 +++
 arch/x86/platform/efi/quirks.c | 5 +++++
 drivers/acpi/sleep.c           | 7 +++++++
 drivers/firmware/efi/reboot.c  | 8 ++++++++
 include/linux/acpi.h           | 1 +
 include/linux/efi.h            | 1 +
 include/linux/pm.h             | 1 +
 kernel/reboot.c                | 1 +
 8 files changed, 27 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index ab0adc0..bec3047 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -666,6 +666,9 @@ static void native_machine_halt(void)
 
 static void native_machine_power_off(void)
 {
+	if (!pm_power_off)
+		pm_power_off = pm_power_off_default;
+
 	if (pm_power_off) {
 		if (!reboot_force)
 			machine_shutdown();
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 2d66db8..8c8e3c9 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -297,3 +297,8 @@ bool efi_poweroff_required(void)
 {
 	return !!acpi_gbl_reduced_hardware;
 }
+
+bool efi_poweroff_default(void)
+{
+	return (!pm_power_off_default && acpi_no_s5);
+}
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 9cb9752..a244f15 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -25,6 +25,11 @@
 #include "internal.h"
 #include "sleep.h"
 
+/*
+ * Some HW-full platforms do not have _S5, they may have
+ * to leverage other methods rather than acpi for a shutdown.
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
diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 9c59d1c..b3345e2 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -38,6 +38,11 @@ bool __weak efi_poweroff_required(void)
 	return false;
 }
 
+bool __weak efi_poweroff_default(void)
+{
+	return false;
+}
+
 static void efi_power_off(void)
 {
 	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
@@ -51,6 +56,9 @@ static int __init efi_shutdown_init(void)
 	if (efi_poweroff_required())
 		pm_power_off = efi_power_off;
 
+	if (efi_poweroff_default())
+		pm_power_off_default = efi_power_off;
+
 	return 0;
 }
 late_initcall(efi_shutdown_init);
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
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 47be3ad..5aad9be 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -921,6 +921,7 @@ extern struct kobject *efi_kobj;
 
 extern int efi_reboot_quirk_mode;
 extern bool efi_poweroff_required(void);
+extern bool efi_poweroff_default(void);
 
 #ifdef CONFIG_EFI_FAKE_MEMMAP
 extern void __init efi_fake_memmap(void);
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 6a5d654..b58719f 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -33,6 +33,7 @@
  */
 extern void (*pm_power_off)(void);
 extern void (*pm_power_off_prepare)(void);
+extern void (*pm_power_off_default)(void);
 
 struct device; /* we have a circular dep with device.h */
 #ifdef CONFIG_VT_CONSOLE_SLEEP
diff --git a/kernel/reboot.c b/kernel/reboot.c
index bd30a97..b9a0f36 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -49,6 +49,7 @@ int reboot_force;
  */
 
 void (*pm_power_off_prepare)(void);
+void (*pm_power_off_default)(void);
 
 /**
  *	emergency_restart - reboot the system
-- 
1.8.4.2
