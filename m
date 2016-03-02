From: Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH][RFC] ACPI / PM: Fix poweroff issue on HW-full platforms without _S5
Date: Wed,  2 Mar 2016 21:29:17 +0800
Message-ID: <1456925357-2899-1-git-send-email-yu.c.chen@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
Sender: linux-pm-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
Cc: linux-pm@vger.kernel.org, rjw@sisk.pl, lenb@kernel.org, matt.fleming@intel.com, tglx@linutronix.de, x86@kernel.org, rui.zhang@intel.com, lv.zheng@intel.com, Chen Yu <yu.c.chen@intel.com>
List-Id: linux-efi@vger.kernel.org

The problem is Linux registers pm_power_off = efi_power_off
only if we are in hardware reduced mode. Actually, what we also
want is to do this when ACPI S5 is simply not supported.
That should handle both the HW reduced mode, and the HW-full
mode where the DSDT fails to supply an _S5 object.

This patch fixes this issue by introducing a new flag acpi_no_s5 which
indicates the non-existence of _S5. The initial state of acpi_no_s5 is
false and probed in acpi_sleep_init, then we'll later see the updated
value in efi_poweroff_required, according to which we can set pm_power_off
to efi_power_off in efi_shutdown_init.

Suggested-by: Len Brown <len.brown@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
 arch/x86/platform/efi/quirks.c | 3 ++-
 drivers/acpi/sleep.c           | 2 ++
 include/acpi/acpixf.h          | 6 ++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 2d66db8..8ec43bc 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -295,5 +295,6 @@ bool efi_reboot_required(void)
 
 bool efi_poweroff_required(void)
 {
-	return !!acpi_gbl_reduced_hardware;
+	return (!!acpi_gbl_reduced_hardware)
+		|| (!!acpi_no_s5);
 }
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 9cb9752..6f75e54 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -846,6 +846,8 @@ int __init acpi_sleep_init(void)
 		sleep_states[ACPI_STATE_S5] = 1;
 		pm_power_off_prepare = acpi_power_off_prepare;
 		pm_power_off = acpi_power_off;
+	} else {
+		acpi_no_s5 = TRUE;
 	}
 
 	supported[0] = 0;
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index c96621e..2b4d7f7 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -252,6 +252,12 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_osi_data, 0);
 ACPI_INIT_GLOBAL(u8, acpi_gbl_reduced_hardware, FALSE);
 
 /*
+ * Some HW-full platforms do not have S5, so they may need
+ * to leverage efi power off for a shutdown.
+ */
+ACPI_INIT_GLOBAL(u8, acpi_no_s5, FALSE);
+
+/*
  * This mechanism is used to trace a specified AML method. The method is
  * traced each time it is executed.
  */
-- 
1.8.4.2

