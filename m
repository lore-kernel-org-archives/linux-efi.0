From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] efi: efivar_create_sysfs_entry() should return negative
 error codes
Date: Tue, 21 Apr 2015 12:21:53 +0300
Message-ID: <20150421092153.GA12098@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

It's not very normal to return 1 on failure and 0 on success.  There
isn't a reason for it here, the callers don't care so long as it's
non-zero on failure.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 7b2e049..756eca8 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -535,7 +535,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
  * efivar_create_sysfs_entry - create a new entry in sysfs
  * @new_var: efivar entry to create
  *
- * Returns 1 on failure, 0 on success
+ * Returns 0 on success, negative error code on failure
  */
 static int
 efivar_create_sysfs_entry(struct efivar_entry *new_var)
@@ -544,6 +544,7 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 	char *short_name;
 	unsigned long variable_name_size;
 	efi_char16_t *variable_name;
+	int ret;
 
 	variable_name = new_var->var.VariableName;
 	variable_name_size = ucs2_strlen(variable_name) * sizeof(efi_char16_t);
@@ -558,7 +559,7 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 	short_name = kzalloc(short_name_size, GFP_KERNEL);
 
 	if (!short_name)
-		return 1;
+		return -ENOMEM;
 
 	/* Convert Unicode to normal chars (assume top bits are 0),
 	   ala UTF-8 */
@@ -574,11 +575,11 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 
 	new_var->kobj.kset = efivars_kset;
 
-	i = kobject_init_and_add(&new_var->kobj, &efivar_ktype,
+	ret = kobject_init_and_add(&new_var->kobj, &efivar_ktype,
 				   NULL, "%s", short_name);
 	kfree(short_name);
-	if (i)
-		return 1;
+	if (ret)
+		return ret;
 
 	kobject_uevent(&new_var->kobj, KOBJ_ADD);
 	efivar_entry_add(new_var, &efivar_sysfs_list);
