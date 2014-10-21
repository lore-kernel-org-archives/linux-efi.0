From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 46/47] efi: Register poweroff handler with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:13:02 -0700
Message-ID: <1413864783-3271-47-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
Sender: linux-pm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>, Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Register with kernel poweroff handler instead of setting pm_power_off
directly. Register with low priority since the efi code states that
this is a poweroff handler of last resort.

Cc: Matt Fleming <matt.fleming@intel.com>
Acked-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
- Use define to specify poweroff handler priority

 drivers/firmware/efi/reboot.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 9c59d1c..e1c4f7a 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -3,6 +3,8 @@
  * Copyright (c) 2014 Red Hat, Inc., Mark Salter <msalter@redhat.com>
  */
 #include <linux/efi.h>
+#include <linux/notifier.h>
+#include <linux/pm.h>
 #include <linux/reboot.h>
 
 int efi_reboot_quirk_mode = -1;
@@ -38,19 +40,32 @@ bool __weak efi_poweroff_required(void)
 	return false;
 }
 
-static void efi_power_off(void)
+static int efi_power_off(struct notifier_block *this,
+			 unsigned long unused1, void *unused2)
 {
 	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block efi_poweroff_nb = {
+	.notifier_call = efi_power_off,
+	.priority = POWEROFF_PRIORITY_LOW,
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
+		ret = register_power_off_handler(&efi_poweroff_nb);
+		if (ret)
+			pr_err("efi: Failed to register poweroff handler\n");
+	}
 
-	return 0;
+	return ret;
 }
 late_initcall(efi_shutdown_init);
-- 
1.9.1

