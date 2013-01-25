From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: [PATCH] efi: split efisubsystem from efivars
Date: Fri, 25 Jan 2013 16:36:55 +0100
Message-ID: <1359128215-1331-1-git-send-email-teg@jklm.no>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This registers /sys/firmware/efi{,/efivars} whenever EFI is enabled
and the system supports it.

This allows
 *) userspace to check for the existence of /sys/firmware/efi as a way
    to determine whether or it is running on an EFI system.
 *) 'mount -t efivarfs none /sys/firmware/efi/efivars' without manually
    loading any modules.

Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Chun-Yi Lee <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 drivers/firmware/Makefile    |  1 +
 drivers/firmware/efisubsys.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efivars.c   | 30 +++++--------------------
 3 files changed, 59 insertions(+), 24 deletions(-)
 create mode 100644 drivers/firmware/efisubsys.c

diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 5a7e273..e89c5da 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -4,6 +4,7 @@
 obj-$(CONFIG_DMI)		+= dmi_scan.o
 obj-$(CONFIG_DMI_SYSFS)		+= dmi-sysfs.o
 obj-$(CONFIG_EDD)		+= edd.o
+obj-$(CONFIG_EFI)		+= efisubsys.o
 obj-$(CONFIG_EFI_VARS)		+= efivars.o
 obj-$(CONFIG_EFI_PCDP)		+= pcdp.o
 obj-$(CONFIG_DELL_RBU)          += dell_rbu.o
diff --git a/drivers/firmware/efisubsys.c b/drivers/firmware/efisubsys.c
new file mode 100644
index 0000000..e09c333
--- /dev/null
+++ b/drivers/firmware/efisubsys.c
@@ -0,0 +1,52 @@
+/*
+ * efi.c - EFI subsystem
+ *
+ * Copyright (C) 2013 Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
+ *
+ * This code registers /sys/firmware/efi{,/efivars} when EFI is supported,
+ * allowing the efivarfs to be mounted or the efivars module to be loaded.
+ * The existance of /sys/firmware/efi may also be used by userspace to
+ * determine that the system supports EFI.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/efi.h>
+
+struct kobject *efi_kobj;
+EXPORT_SYMBOL_GPL(efi_kobj);
+struct kobject *efivars_kobj;
+EXPORT_SYMBOL_GPL(efivars_kobj);
+
+/*
+ * We register the efi subsystem with the firmware subsystem and the
+ * efivars subsystem with the efi subsystem.
+ */
+static int __init efisubsys_init(void)
+{
+	if (!efi_enabled)
+		return 0;
+
+	/* We register the efi directory at /sys/firmware/efi */
+	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
+	if (!efi_kobj) {
+		pr_err("efivars: Firmware registration failed.\n");
+		return -ENOMEM;
+	}
+
+	/* and the mountpoint for efivarfs at /sys/firmware/efi/efivars */
+        efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
+	if (!efivars_kobj) {
+		pr_err("efivars: Subsystem registration failed.\n");
+	        kobject_put(efi_kobj);
+		return -ENOMEM;
+	}
+
+        return 0;
+}
+
+subsys_initcall(efisubsys_init);
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index b7cff5c..9a929d4 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1528,7 +1528,8 @@ static struct attribute_group efi_subsys_attr_group = {
 	.attrs = efi_subsys_attrs,
 };
 
-static struct kobject *efi_kobj;
+extern struct kobject *efi_kobj;
+extern struct kobject *efivars_kobj;
 
 /*
  * efivar_create_sysfs_entry()
@@ -1708,13 +1709,7 @@ int register_efivars(struct efivars *efivars,
 		goto out;
 	}
 
-	efivars->kobject = kobject_create_and_add("efivars", parent_kobj);
-	if (!efivars->kobject) {
-		pr_err("efivars: Subsystem registration failed.\n");
-		error = -ENOMEM;
-		kset_unregister(efivars->kset);
-		goto out;
-	}
+	efivars->kobject = efivars_kobj;
 
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
@@ -1768,11 +1763,7 @@ out:
 EXPORT_SYMBOL_GPL(register_efivars);
 
 /*
- * For now we register the efi subsystem with the firmware subsystem
- * and the vars subsystem with the efi subsystem.  In the future, it
- * might make sense to split off the efi subsystem into its own
- * driver, but for now only efivars will register with it, so just
- * include it here.
+ * We register the vars subsystem with the efi subsystem.
  */
 
 static int __init
@@ -1786,21 +1777,15 @@ efivars_init(void)
 	if (!efi_enabled)
 		return 0;
 
-	/* For now we'll register the efi directory at /sys/firmware/efi */
-	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
-	if (!efi_kobj) {
-		printk(KERN_ERR "efivars: Firmware registration failed.\n");
-		return -ENOMEM;
-	}
-
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
 	ops.query_variable_info = efi.query_variable_info;
 
 	error = register_efivars(&__efivars, &ops, efi_kobj);
+
 	if (error)
-		goto err_put;
+		goto err_unregister;
 
 	/* Don't forget the systab entry */
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
@@ -1815,8 +1800,6 @@ efivars_init(void)
 
 err_unregister:
 	unregister_efivars(&__efivars);
-err_put:
-	kobject_put(efi_kobj);
 	return error;
 }
 
@@ -1825,7 +1808,6 @@ efivars_exit(void)
 {
 	if (efi_enabled) {
 		unregister_efivars(&__efivars);
-		kobject_put(efi_kobj);
 	}
 }
 
-- 
1.8.1.1
