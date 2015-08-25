From: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Subject: [PATCH] drivers/firmware: make efi/esrt.c driver explicitly non-modular
Date: Tue, 25 Aug 2015 19:00:48 -0400
Message-ID: <1440543648-27328-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The Kconfig for this driver is currently hidden with:

config EFI_ESRT
        bool

...meaning that it currently is not being built as a module by anyone.
Lets remove the modular code that is essentially orphaned, so that
when reading the driver there is no doubt it is builtin-only.

Since module_init translates to device_initcall in the non-modular
case, the init ordering remains unchanged with this commit.

We leave some tags like MODULE_AUTHOR for documentation purposes.

We don't replace module.h with init.h since the file already has that.

Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index a5b95d61ae71..22c5285f7705 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -20,7 +20,6 @@
 #include <linux/kobject.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
-#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 
@@ -450,22 +449,10 @@ err:
 	esrt = NULL;
 	return error;
 }
+device_initcall(esrt_sysfs_init);
 
-static void __exit esrt_sysfs_exit(void)
-{
-	pr_debug("esrt-sysfs: unloading.\n");
-	cleanup_entry_list();
-	kset_unregister(esrt_kset);
-	sysfs_remove_group(esrt_kobj, &esrt_attr_group);
-	kfree(esrt);
-	esrt = NULL;
-	kobject_del(esrt_kobj);
-	kobject_put(esrt_kobj);
-}
-
-module_init(esrt_sysfs_init);
-module_exit(esrt_sysfs_exit);
-
+/*
 MODULE_AUTHOR("Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>");
 MODULE_DESCRIPTION("EFI System Resource Table support");
 MODULE_LICENSE("GPL");
+*/
-- 
2.2.1
