From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH v3 46/47] efi: Register power-off handler with kernel power-off handler
Date: Mon, 27 Oct 2014 08:55:53 -0700
Message-ID: <1414425354-10359-47-git-send-email-linux@roeck-us.net>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414425354-10359-1-git-send-email-linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Register with kernel power-off handler instead of setting pm_power_off
directly. Register with low priority since the efi code states that
this is a power-off handler of last resort.

Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
---
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Use define to specify poweroff handler priority

 drivers/firmware/efi/reboot.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 9c59d1c..df0ceb9 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -3,6 +3,8 @@
  * Copyright (c) 2014 Red Hat, Inc., Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
 
+static struct notifier_block efi_power_off_nb = {
+	.notifier_call = efi_power_off,
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
+		ret = register_power_off_handler(&efi_power_off_nb);
+		if (ret)
+			pr_err("efi: Failed to register power-off handler\n");
+	}
 
-	return 0;
+	return ret;
 }
 late_initcall(efi_shutdown_init);
-- 
1.9.1
