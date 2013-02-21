From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: register efivars with efi or gsmi from
 module_init
Date: Thu, 21 Feb 2013 13:58:14 +0000
Message-ID: <1361455094.2842.15.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1361149277-1026-1-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361149277-1026-1-git-send-email-teg-B22kvLQNl6c@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2013-02-18 at 02:01 +0100, Tom Gundersen wrote:
> The generic efi code or the gsmi code used to request efivars to register itself
> with them. That would only work if efivars was compiled into the kernel, and not
> when built as a module.
> 
> I.e., CONFIG_EFI_VARS_GENERIC_OPS=y and CONFIG_EFI_VARS_SYSFS=m gives:
> 
> drivers/built-in.o: In function `generic_register':
> drivers/firmware/efi/generic-ops.c:41: undefined reference
> to `efivars_sysfs_init'.
> 
> This patch reverses the logic and does the registration from
> efivars_sysfs_init().
> 
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
> ---

Guh, yes. The way I implemented this is rather silly. Thanks for the
report! I was trying to avoid having a struct kobject * in struct
efivars, because that inherently ties the efivar_entry API to the sysfs
code, and the whole point of this series is that you can have EFI
variable support without the sysfs stuff.

Instead of doing the #ifdef-ery how does this look? It keeps everything
contained within struct efivars just like the old code. Unfortunately
it's applied against some changes I've got locally, so the context might
look a bit weird, but you can still get the idea.

---

diff --git a/drivers/firmware/efi/generic-ops.c b/drivers/firmware/efi/generic-ops.c
index 7f51ebd..1a0fc96 100644
--- a/drivers/firmware/efi/generic-ops.c
+++ b/drivers/firmware/efi/generic-ops.c
@@ -26,8 +26,6 @@ static struct efivar_operations generic_ops;
 
 int generic_register(void)
 {
-	int error;
-
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return 0;
 
@@ -36,14 +34,7 @@ int generic_register(void)
 	generic_ops.get_next_variable = efi.get_next_variable;
 	generic_ops.query_variable_info = efi.query_variable_info;
 
-	error = efivars_register(&generic_efivars, &generic_ops);
-	if (error)
-		return error;
-
-#if defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE)
-	efivars_sysfs_init(efi_kobj);
-#endif
-	return 0;
+	return efivars_register(&generic_efivars, &generic_ops, efi_kobj);
 }
 
 void generic_unregister(void)
diff --git a/drivers/firmware/efi/sysfs.c b/drivers/firmware/efi/sysfs.c
index 797e451..8a42d08 100644
--- a/drivers/firmware/efi/sysfs.c
+++ b/drivers/firmware/efi/sysfs.c
@@ -525,8 +525,9 @@ void efivars_sysfs_exit(void)
 	kset_unregister(efivars_kset);
 }
 
-int efivars_sysfs_init(struct kobject *parent_kobj)
+int efivars_sysfs_init(void)
 {
+	struct kobject *parent_kobj;
 	int error = 0;
 
 	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
@@ -535,6 +536,12 @@ int efivars_sysfs_init(struct kobject *parent_kobj)
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return 0;
 
+	parent_kobj = efivars_kobject();
+	if (!parent_kobj) {
+		printk(KERN_ERR "efivars: No kobject registered.\n");
+		return -EINVAL;
+	}
+
 	efivars_kset = kset_create_and_add("vars", NULL, parent_kobj);
 	if (!efivars_kset) {
 		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ef216b4..81f70db 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -855,17 +855,28 @@ int efivar_entry_iter(int (*func)(struct efivar_entry *, void *), void *data)
 }
 EXPORT_SYMBOL_GPL(efivar_entry_iter);
 
+/**
+ * efivars_kobject - get the kobject for the registered efivars
+ */
+struct kobject *efivars_kobject(void)
+{
+	return __efivars->kobject;
+}
+EXPORT_SYMBOL_GPL(efivars_kobject);
+
 static DEFINE_MUTEX(efivars_mutex);
 
 /**
  * efivars_register - register an efivars
  * @efivars: efivars to register
  * @ops: efivars operations
+ * @kobject: @efivars-specific kobject
  *
  * Only a single efivars can be registered at any time.
  */
 int efivars_register(struct efivars *efivars,
-		     const struct efivar_operations *ops)
+		     const struct efivar_operations *ops,
+		     struct kobject *kobject)
 {
 	int rv;
 
@@ -877,6 +888,7 @@ int efivars_register(struct efivars *efivars,
 
 	spin_lock_init(&efivars->lock);
 	INIT_LIST_HEAD(&efivars->list);
+	efivars->kobject = kobject;
 	efivars->ops = ops;
 
 	__efivars = efivars;
@@ -926,7 +938,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(efivars_unregister);
 
-static struct kobject *efivars_kobject;
+static struct kobject *efivars_kobj;
 
 static int __init
 efivars_init(void)
@@ -943,8 +955,8 @@ efivars_init(void)
 		return -ENOMEM;
 	}
 
-	efivars_kobject = kobject_create_and_add("efivars", efi_kobj);
-	if (!efivars_kobject) {
+	efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
+	if (!efivars_kobj) {
 		pr_err("efivars: Subsystem registration failed.\n");
 		kobject_put(efi_kobj);
 		return -ENOMEM;
@@ -965,7 +977,7 @@ static void __exit
 efivars_exit(void)
 {
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
-		kobject_put(efivars_kobject);
+		kobject_put(efivars_kobj);
 		kobject_put(efi_kobj);
 	}
 }
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index e902f21..d5ac00c 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -882,7 +882,7 @@ static __init int gsmi_init(void)
 		goto out_remove_bin_file;
 	}
 
-	ret = efivars_register(&efivars, &efivar_ops);
+	ret = efivars_register(&efivars, &efivar_ops, gsmi_kobj);
 	if (ret) {
 		printk(KERN_INFO "gsmi: Failed to register efivars\n");
 		goto out_remove_sysfs_files;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index b81928b..ab3934d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -825,8 +825,10 @@ struct efivar_entry {
 };
 
 int efivars_register(struct efivars *efivars,
-		     const struct efivar_operations *ops);
+		     const struct efivar_operations *ops,
+		     struct kobject *kobject);
 int efivars_unregister(struct efivars *efivars);
+struct kobject *efivars_kobject(void);
 
 int efivar_init(int (*func)(struct efivar_entry *, void *), void *data);
 
@@ -861,7 +863,7 @@ int efivar_query_info(u32 attributes, u64 *storage_size,
 		      u64 *remaining_size, u64 *max_size);
 
 #if defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE)
-int efivars_sysfs_init(struct kobject *parent);
+int efivars_sysfs_init(void);
 int efivar_create_sysfs_entry(struct efivar_entry *new_var);
 #endif
 
