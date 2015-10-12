From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 01/11] drivers/firmware: Make efi/esrt.c driver explicitly non-modular
Date: Mon, 12 Oct 2015 14:56:04 +0100
Message-ID: <1444658174-23378-2-git-send-email-matt@codeblueprint.co.uk>
References: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444658174-23378-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

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

Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/esrt.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

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
2.1.0
