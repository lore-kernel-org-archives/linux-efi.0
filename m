From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: [PATCH 1/2] efi: register efivars with efi or gsmi from module_init
Date: Mon, 18 Feb 2013 02:01:16 +0100
Message-ID: <1361149277-1026-1-git-send-email-teg@jklm.no>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The generic efi code or the gsmi code used to request efivars to register itself
with them. That would only work if efivars was compiled into the kernel, and not
when built as a module.

I.e., CONFIG_EFI_VARS_GENERIC_OPS=y and CONFIG_EFI_VARS_SYSFS=m gives:

drivers/built-in.o: In function `generic_register':
drivers/firmware/efi/generic-ops.c:41: undefined reference
to `efivars_sysfs_init'.

This patch reverses the logic and does the registration from
efivars_sysfs_init().

Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
---

Hi Matt,

This and the following patch applies on top of the chainsaw branch. Feel free
to squash them into your other patches, or to consider them as glorified
bug-reporst if you prefer to solve the problems differently.

Cheers,

Tom

drivers/firmware/efi/generic-ops.c |  6 ------
 drivers/firmware/efi/sysfs.c       | 14 ++++++++++----
 drivers/firmware/google/gsmi.c     | 11 +++--------
 include/linux/efi.h                |  6 +++++-
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/firmware/efi/generic-ops.c b/drivers/firmware/efi/generic-ops.c
index b474800..df1251e 100644
--- a/drivers/firmware/efi/generic-ops.c
+++ b/drivers/firmware/efi/generic-ops.c
@@ -17,9 +17,6 @@
  */
 
 #include <linux/efi.h>
-#include <linux/kconfig.h>
-
-extern struct kobject *efi_kobj;
 
 static struct efivars generic_efivars;
 static struct efivar_operations generic_ops;
@@ -37,9 +34,6 @@ int generic_register(void)
 	if (error)
 		return error;
 
-#if defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE)
-	efivars_sysfs_init(efi_kobj);
-#endif
 	return 0;
 }
 
diff --git a/drivers/firmware/efi/sysfs.c b/drivers/firmware/efi/sysfs.c
index d066eb5..d61ab95 100644
--- a/drivers/firmware/efi/sysfs.c
+++ b/drivers/firmware/efi/sysfs.c
@@ -76,6 +76,7 @@ MODULE_DESCRIPTION("sysfs interface to EFI Variables");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EFIVARS_VERSION);
 
+
 static struct kset *efivars_kset;
 
 static struct bin_attribute *efivars_new_var;
@@ -525,16 +526,20 @@ void efivars_sysfs_exit(void)
 	kset_unregister(efivars_kset);
 }
 
-int efivars_sysfs_init(struct kobject *parent_kobj)
+int efivars_sysfs_init(void)
 {
 	int error = 0;
 
 	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
 	       EFIVARS_DATE);
 
-	efivars_kset = kset_create_and_add("vars", NULL, parent_kobj);
+#if defined(CONFIG_EFI_VARS_GENERIC_OPS)
+	efivars_kset = kset_create_and_add("vars", NULL, efi_kobj);
+#elif defined(CONFIG_GOOGLE_SMI) || defined(CONFIG_GOOGLE_SMI_MODULE)
+	efivars_kset = kset_create_and_add("vars", NULL, gsmi_kobj);
+#endif
 	if (!efivars_kset) {
-		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
+		pr_err("efivars: Subsystem registration failed.\n");
 		return -ENOMEM;
 	}
 
@@ -546,4 +551,5 @@ int efivars_sysfs_init(struct kobject *parent_kobj)
 
 	return error;
 }
-EXPORT_SYMBOL_GPL(efivars_sysfs_init);
+
+module_init(efivars_sysfs_init);
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index e902f21..e084486 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -760,7 +760,9 @@ static __init int gsmi_system_valid(void)
 	return 0;
 }
 
-static struct kobject *gsmi_kobj;
+struct kobject *gsmi_kobj;
+EXPORT_SYMBOL_GPL(gsmi_kobj);
+
 static struct efivars efivars;
 
 static __init int gsmi_init(void)
@@ -888,13 +890,6 @@ static __init int gsmi_init(void)
 		goto out_remove_sysfs_files;
 	}
 
-	ret = efivars_sysfs_init(gsmi_kobj);
-	if (ret) {
-		printk(KERN_INFO "gsmi: Failed to create efivars files\n");
-		efivars_unregister(&efivars);
-		goto out_remove_sysfs_files;
-	}
-
 	register_reboot_notifier(&gsmi_reboot_notifier);
 	register_die_notifier(&gsmi_die_notifier);
 	atomic_notifier_chain_register(&panic_notifier_list,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 58b3cae..008d345 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -744,6 +744,11 @@ utf16_strlen(efi_char16_t *s)
 
 extern struct kobject *efi_kobj;
 
+#ifdef CONFIG_GOOGLE_SMI
+extern struct kobject *gsmi_kobj;
+#endif /* CONFIG_EFI_VARS */
+
+
 #ifdef CONFIG_EFI_VARS
 /*
  * Return the number of bytes is the length of this string
@@ -863,7 +868,6 @@ int efivar_query_info(u32 attributes, u64 *storage_size,
 		      u64 *remaining_size, u64 *max_size);
 
 #if defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE)
-int efivars_sysfs_init(struct kobject *parent);
 int efivar_create_sysfs_entry(struct efivar_entry *new_var);
 #endif
 
-- 
1.8.1.3
