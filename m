From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v6 47/48] efi: Register power-off handler with kernel power-off handler
Date: Sun,  9 Nov 2014 17:43:04 -0800
Message-ID: <1415583785-6980-48-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>, Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Register with kernel power-off handler instead of setting pm_power_off
directly. Register with low priority since the efi code states that
this is a power-off handler of last resort.

Cc: Matt Fleming <matt.fleming@intel.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v6:
- This patch: No change.
  Global: Replaced priority defines with enum.
v5:
- Rebase to v3.18-rc3
v4:
- Do not use notifiers but internal functions and data structures to manage
  the list of power-off handlers. Drop unused parameters from callbacks, and
  make the power-off function type void
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Use define to specify poweroff handler priority

 drivers/firmware/efi/reboot.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 9c59d1c..0ddec8f 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2014 Red Hat, Inc., Mark Salter <msalter@redhat.com>
  */
 #include <linux/efi.h>
+#include <linux/pm.h>
 #include <linux/reboot.h>
 
 int efi_reboot_quirk_mode = -1;
@@ -38,19 +39,29 @@ bool __weak efi_poweroff_required(void)
 	return false;
 }
 
-static void efi_power_off(void)
+static void efi_power_off(struct power_off_handler_block *this)
 {
 	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
 }
 
+static struct power_off_handler_block efi_power_off_hb = {
+	.handler = efi_power_off,
+	.priority = POWER_OFF_PRIORITY_LOW,
+};
+
 static int __init efi_shutdown_init(void)
 {
+	int ret = 0;
+
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return -ENODEV;
 
-	if (efi_poweroff_required())
-		pm_power_off = efi_power_off;
+	if (efi_poweroff_required()) {
+		ret = register_power_off_handler(&efi_power_off_hb);
+		if (ret)
+			pr_err("efi: Failed to register power-off handler\n");
+	}
 
-	return 0;
+	return ret;
 }
 late_initcall(efi_shutdown_init);
-- 
1.9.1
