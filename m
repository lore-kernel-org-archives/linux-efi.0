From: Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH][RFC v3] ACPI / PM: Fix poweroff issue on HW-full platforms without _S5
Date: Mon,  7 Mar 2016 10:50:45 +0800
Message-ID: <1457319045-25434-1-git-send-email-yu.c.chen@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org
Cc: x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Zhang Rui <rui.zhang@intel.com>, Chen Yu <yu.c.chen@intel.com>
List-Id: linux-efi@vger.kernel.org

The problem is Linux registers pm_power_off = efi_power_off
only if we are in hardware reduced mode. Actually, what we also
want is to do this when ACPI S5 is simply not supported on
non-legacy platforms. That should handle both the HW reduced mode,
and the HW-full mode where the DSDT fails to supply an _S5 object.

This patch fixes this issue by introducing a new flag acpi_no_s5 which
indicates the non-existence of _S5. The initial state of acpi_no_s5 is
false and probed in acpi_sleep_init, then we'll later see the updated
value in efi_poweroff_required, according to which we can set pm_power_off
to efi_power_off in efi_shutdown_init, if no other pm_power_off available.

Suggested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
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
 drivers/acpi/sleep.c           | 8 ++++++++
 include/linux/acpi.h           | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 2d66db8..0d4186b 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -295,5 +295,5 @@ bool efi_reboot_required(void)
 
 bool efi_poweroff_required(void)
 {
-	return !!acpi_gbl_reduced_hardware;
+	return acpi_gbl_reduced_hardware || (acpi_no_s5 && !pm_power_off);
 }
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 9cb9752..94099a4 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -25,6 +25,12 @@
 #include "internal.h"
 #include "sleep.h"
 
+/*
+ * Some HW-full platforms do not have _S5, they may have
+ * to leverage efi rather than acpi for a shutdown, if no
+ * other pm_power_off available.
+ */
+bool acpi_no_s5;
 static u8 sleep_states[ACPI_S_STATE_COUNT];
 
 static void acpi_sleep_tts_switch(u32 acpi_state)
@@ -846,6 +852,8 @@ int __init acpi_sleep_init(void)
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

