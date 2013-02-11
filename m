From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 3/7 v2] efivars: New efivar_entry API
Date: Mon, 11 Feb 2013 14:41:50 +0000
Message-ID: <20130211144150.GI6197@console-pimps.org>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
 <1360357158-8168-4-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360357158-8168-4-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There isn't really a formalised interface for dealing with EFI
variables or struct efivar_entry. This has led to the efivarfs code
directly accessing '__efivars'.

Encapsulate everything that needs to access '__efivars' inside an
efivar_entry_* API and use the new API in the pstore, sysfs and
efivarfs code.

Much of the efivars code had to be rewritten to use this new API. For
instance, it's now up to the users of the API to build the initial
list of EFI variables in their efivar_init() callback function. This
greatly benefits the efivarfs code which needs to allocate inodes and
dentries for every variable, which it previously did in a racy way
because the code ran without holding the variable spinlock.

Now, the core EFI variable code creates /sys/firmware/efi/ and the
separated sysfs code creates /sys/firmware/efi/vars (or whatever
parent_obj points at for CONFIG_GOOGLE_SMI).

A nice side effect of this change is that efivarfs is now usable with
CONFIG_GOOGLE_SMI, because it no longer accesses '__efivars' directly.

Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

v2: Add efivar_entry_set_safe() which performs QueryVariableInfo() and
    SetVariable() atomically under __efivars->lock, and is required
    for the pstore code.

 drivers/firmware/efivars.c     | 1586 ++++++++++++++++++++++++----------------
 drivers/firmware/google/gsmi.c |   11 +-
 include/linux/efi.h            |   74 +-
 3 files changed, 1013 insertions(+), 658 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 029a5fe..97f9ac9 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -97,35 +97,6 @@ MODULE_VERSION(EFIVARS_VERSION);
 
 #define DUMP_NAME_LEN 52
 
-/*
- * Length of a GUID string (strlen("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
- * not including trailing NUL
- */
-#define GUID_LEN 36
-
-/*
- * The maximum size of VariableName + Data = 1024
- * Therefore, it's reasonable to save that much
- * space in each part of the structure,
- * and we use a page for reading/writing.
- */
-
-struct efi_variable {
-	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
-	efi_guid_t    VendorGuid;
-	unsigned long DataSize;
-	__u8          Data[1024];
-	efi_status_t  Status;
-	__u32         Attributes;
-} __attribute__((packed));
-
-struct efivar_entry {
-	struct efivars *efivars;
-	struct efi_variable var;
-	struct list_head list;
-	struct kobject kobj;
-};
-
 struct efivar_attribute {
 	struct attribute attr;
 	ssize_t (*show) (struct efivar_entry *entry, char *buf);
@@ -143,6 +114,11 @@ static struct efivars *__efivars;
 	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
 	 EFI_VARIABLE_RUNTIME_ACCESS)
 
+static struct kset *efivars_kset;
+
+static struct bin_attribute *efivars_new_var;
+static struct bin_attribute *efivars_del_var;
+
 #define EFIVAR_ATTR(_name, _mode, _show, _store) \
 struct efivar_attribute efivar_attr_##_name = { \
 	.attr = {.name = __stringify(_name), .mode = _mode}, \
@@ -154,15 +130,6 @@ struct efivar_attribute efivar_attr_##_name = { \
 #define to_efivar_entry(obj)  container_of(obj, struct efivar_entry, kobj)
 
 /*
- * Prototype for sysfs creation function
- */
-static int
-efivar_create_sysfs_entry(struct efivars *efivars,
-			  unsigned long variable_name_size,
-			  efi_char16_t *variable_name,
-			  efi_guid_t *vendor_guid);
-
-/*
  * Return the number of bytes is the length of this string
  * Note: this is NOT the same as the number of unicode characters
  */
@@ -337,8 +304,8 @@ static const struct variable_validate variable_validate[] = {
 	{ "", NULL },
 };
 
-static bool
-validate_var(struct efi_variable *var, u8 *data, unsigned long len)
+bool
+efivar_validate(struct efi_variable *var, u8 *data, unsigned long len)
 {
 	int i;
 	u16 *unicode_name = var->VariableName;
@@ -373,36 +340,7 @@ validate_var(struct efi_variable *var, u8 *data, unsigned long len)
 
 	return true;
 }
-
-static efi_status_t
-get_var_data_locked(struct efivars *efivars, struct efi_variable *var)
-{
-	efi_status_t status;
-
-	var->DataSize = 1024;
-	status = efivars->ops->get_variable(var->VariableName,
-					    &var->VendorGuid,
-					    &var->Attributes,
-					    &var->DataSize,
-					    var->Data);
-	return status;
-}
-
-static efi_status_t
-get_var_data(struct efivars *efivars, struct efi_variable *var)
-{
-	efi_status_t status;
-
-	spin_lock(&efivars->lock);
-	status = get_var_data_locked(efivars, var);
-	spin_unlock(&efivars->lock);
-
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
-			status);
-	}
-	return status;
-}
+EXPORT_SYMBOL_GPL(efivar_validate);
 
 static ssize_t
 efivar_guid_read(struct efivar_entry *entry, char *buf)
@@ -425,13 +363,12 @@ efivar_attr_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
 	char *str = buf;
-	efi_status_t status;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(entry->efivars, var);
-	if (status != EFI_SUCCESS)
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
 		return -EIO;
 
 	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
@@ -459,13 +396,12 @@ efivar_size_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
 	char *str = buf;
-	efi_status_t status;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(entry->efivars, var);
-	if (status != EFI_SUCCESS)
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
 		return -EIO;
 
 	str += sprintf(str, "0x%lx\n", var->DataSize);
@@ -476,13 +412,12 @@ static ssize_t
 efivar_data_read(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
-	efi_status_t status;
 
 	if (!entry || !buf)
 		return -EINVAL;
 
-	status = get_var_data(entry->efivars, var);
-	if (status != EFI_SUCCESS)
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
 		return -EIO;
 
 	memcpy(buf, var->Data, var->DataSize);
@@ -496,8 +431,7 @@ static ssize_t
 efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 {
 	struct efi_variable *new_var, *var = &entry->var;
-	struct efivars *efivars = entry->efivars;
-	efi_status_t status = EFI_NOT_FOUND;
+	int err;
 
 	if (count != sizeof(struct efi_variable))
 		return -EINVAL;
@@ -519,27 +453,20 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	}
 
 	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    validate_var(new_var, new_var->Data, new_var->DataSize) == false) {
+	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
-	status = efivars->ops->set_variable(new_var->VariableName,
-					    &new_var->VendorGuid,
-					    new_var->Attributes,
-					    new_var->DataSize,
-					    new_var->Data);
-
-	spin_unlock(&efivars->lock);
+	memcpy(&entry->var, new_var, count);
 
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
+	err = efivar_entry_set(entry, new_var->Attributes,
+			       new_var->DataSize, new_var->Data, false);
+	if (err) {
+		printk(KERN_WARNING "efivars: set_variable() failed: status=%d\n", err);
 		return -EIO;
 	}
 
-	memcpy(&entry->var, new_var, count);
 	return count;
 }
 
@@ -547,16 +474,16 @@ static ssize_t
 efivar_show_raw(struct efivar_entry *entry, char *buf)
 {
 	struct efi_variable *var = &entry->var;
-	efi_status_t status;
 
 	if (!entry || !buf)
 		return 0;
 
-	status = get_var_data(entry->efivars, var);
-	if (status != EFI_SUCCESS)
+	memcpy(buf, var, sizeof(*var));
+
+	if (efivar_entry_get(entry, &entry->var.Attributes,
+			     &entry->var.DataSize, entry->var.Data))
 		return -EIO;
 
-	memcpy(buf, var, sizeof(*var));
 	return sizeof(*var);
 }
 
@@ -645,6 +572,9 @@ static int efi_status_to_err(efi_status_t status)
 	int err;
 
 	switch (status) {
+	case EFI_SUCCESS:
+		err = 0;
+		break;
 	case EFI_INVALID_PARAMETER:
 		err = -EINVAL;
 		break;
@@ -661,7 +591,7 @@ static int efi_status_to_err(efi_status_t status)
 		err = -EACCES;
 		break;
 	case EFI_NOT_FOUND:
-		err = -EIO;
+		err = -ENOENT;
 		break;
 	default:
 		err = -EINVAL;
@@ -674,15 +604,14 @@ static ssize_t efivarfs_file_write(struct file *file,
 		const char __user *userbuf, size_t count, loff_t *ppos)
 {
 	struct efivar_entry *var = file->private_data;
-	struct efivars *efivars;
-	efi_status_t status;
 	void *data;
 	u32 attributes;
 	struct inode *inode = file->f_mapping->host;
 	unsigned long datasize = count - sizeof(attributes);
-	unsigned long newdatasize;
 	u64 storage_size, remaining_size, max_size;
 	ssize_t bytes = 0;
+	bool set = false;
+	int err;
 
 	if (count < sizeof(attributes))
 		return -EINVAL;
@@ -693,28 +622,16 @@ static ssize_t efivarfs_file_write(struct file *file,
 	if (attributes & ~(EFI_VARIABLE_MASK))
 		return -EINVAL;
 
-	efivars = var->efivars;
-
 	/*
 	 * Ensure that the user can't allocate arbitrarily large
 	 * amounts of memory. Pick a default size of 64K if
 	 * QueryVariableInfo() isn't supported by the firmware.
 	 */
-	spin_lock(&efivars->lock);
-
-	if (!efivars->ops->query_variable_info)
-		status = EFI_UNSUPPORTED;
-	else {
-		const struct efivar_operations *fops = efivars->ops;
-		status = fops->query_variable_info(attributes, &storage_size,
-						   &remaining_size, &max_size);
-	}
-
-	spin_unlock(&efivars->lock);
-
-	if (status != EFI_SUCCESS) {
-		if (status != EFI_UNSUPPORTED)
-			return efi_status_to_err(status);
+	err = efivar_query_info(attributes, &storage_size,
+			       &remaining_size, &max_size);
+	if (err) {
+		if (err != -ENOSYS)
+			return err;
 
 		remaining_size = 65536;
 	}
@@ -731,64 +648,23 @@ static ssize_t efivarfs_file_write(struct file *file,
 		goto out;
 	}
 
-	if (validate_var(&var->var, data, datasize) == false) {
-		bytes = -EINVAL;
+	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
+					  data, &set);
+	if (!set && bytes)
 		goto out;
-	}
-
-	/*
-	 * The lock here protects the get_variable call, the conditional
-	 * set_variable call, and removal of the variable from the efivars
-	 * list (in the case of an authenticated delete).
-	 */
-	spin_lock(&efivars->lock);
-
-	status = efivars->ops->set_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    attributes, datasize,
-					    data);
-
-	if (status != EFI_SUCCESS) {
-		spin_unlock(&efivars->lock);
-		kfree(data);
-
-		return efi_status_to_err(status);
-	}
-
-	bytes = count;
-
-	/*
-	 * Writing to the variable may have caused a change in size (which
-	 * could either be an append or an overwrite), or the variable to be
-	 * deleted. Perform a GetVariable() so we can tell what actually
-	 * happened.
-	 */
-	newdatasize = 0;
-	status = efivars->ops->get_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    NULL, &newdatasize,
-					    NULL);
-
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		spin_unlock(&efivars->lock);
-		mutex_lock(&inode->i_mutex);
-		i_size_write(inode, newdatasize + sizeof(attributes));
-		mutex_unlock(&inode->i_mutex);
 
-	} else if (status == EFI_NOT_FOUND) {
-		list_del(&var->list);
-		spin_unlock(&efivars->lock);
-		efivar_unregister(var);
+	if (bytes == -ENOENT) {
 		drop_nlink(inode);
 		d_delete(file->f_dentry);
 		dput(file->f_dentry);
-
 	} else {
-		spin_unlock(&efivars->lock);
-		pr_warn("efivarfs: inconsistent EFI variable implementation? "
-				"status = %lx\n", status);
+		mutex_lock(&inode->i_mutex);
+		i_size_write(inode, datasize + sizeof(attributes));
+		mutex_unlock(&inode->i_mutex);
 	}
 
+	bytes = count;
+
 out:
 	kfree(data);
 
@@ -799,38 +675,25 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 		size_t count, loff_t *ppos)
 {
 	struct efivar_entry *var = file->private_data;
-	struct efivars *efivars = var->efivars;
-	efi_status_t status;
 	unsigned long datasize = 0;
 	u32 attributes;
 	void *data;
 	ssize_t size = 0;
+	int err;
 
-	spin_lock(&efivars->lock);
-	status = efivars->ops->get_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    &attributes, &datasize, NULL);
-	spin_unlock(&efivars->lock);
-
-	if (status != EFI_BUFFER_TOO_SMALL)
-		return efi_status_to_err(status);
+	err = efivar_entry_size(var, &datasize);
+	if (err)
+		return err;
 
 	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
 
 	if (!data)
 		return -ENOMEM;
 
-	spin_lock(&efivars->lock);
-	status = efivars->ops->get_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    &attributes, &datasize,
-					    (data + sizeof(attributes)));
-	spin_unlock(&efivars->lock);
-
-	if (status != EFI_SUCCESS) {
-		size = efi_status_to_err(status);
+	size = efivar_entry_get(var, &attributes, &datasize,
+				data + sizeof(attributes));
+	if (size)
 		goto out_free;
-	}
 
 	memcpy(data, &attributes, sizeof(attributes));
 	size = simple_read_from_buffer(userbuf, count, ppos,
@@ -905,7 +768,7 @@ static bool efivarfs_valid_name(const char *str, int len)
 	 * We need a GUID, plus at least one letter for the variable name,
 	 * plus the '-' separator
 	 */
-	if (len < GUID_LEN + 2)
+	if (len < EFI_VARIABLE_GUID_LEN + 2)
 		return false;
 
 	s = strchr(str, '-');
@@ -915,7 +778,7 @@ static bool efivarfs_valid_name(const char *str, int len)
 	s++;			/* Skip '-' */
 
 	/* Ensure we have enough characters for a GUID */
-	if (len - (s - str) != GUID_LEN)
+	if (len - (s - str) != EFI_VARIABLE_GUID_LEN)
 		return false;
 
 	/*
@@ -929,7 +792,7 @@ static bool efivarfs_valid_name(const char *str, int len)
 				return false;
 		}
 
-		if (j < GUID_LEN && s[j] != '-')
+		if (j < EFI_VARIABLE_GUID_LEN && s[j] != '-')
 			return false;
 	}
 
@@ -960,7 +823,6 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 			  umode_t mode, bool excl)
 {
 	struct inode *inode;
-	struct efivars *efivars = __efivars;
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
 
@@ -978,7 +840,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	}
 
 	/* length of the variable name itself: remove GUID and separator */
-	namelen = dentry->d_name.len - GUID_LEN - 1;
+	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
 
 	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
 			&var->var.VendorGuid);
@@ -989,18 +851,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	var->var.VariableName[i] = '\0';
 
 	inode->i_private = var;
-	var->efivars = efivars;
-	var->kobj.kset = efivars->kset;
-
-	err = kobject_init_and_add(&var->kobj, &efivar_ktype, NULL, "%s",
-			     dentry->d_name.name);
-	if (err)
-		goto out;
 
-	kobject_uevent(&var->kobj, KOBJ_ADD);
-	spin_lock(&efivars->lock);
-	list_add(&var->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	efivar_entry_add(var);
 	d_instantiate(dentry, inode);
 	dget(dentry);
 out:
@@ -1014,26 +866,13 @@ out:
 static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct efivar_entry *var = dentry->d_inode->i_private;
-	struct efivars *efivars = var->efivars;
-	efi_status_t status;
-
-	spin_lock(&efivars->lock);
 
-	status = efivars->ops->set_variable(var->var.VariableName,
-					    &var->var.VendorGuid,
-					    0, 0, NULL);
-
-	if (status == EFI_SUCCESS || status == EFI_NOT_FOUND) {
-		list_del(&var->list);
-		spin_unlock(&efivars->lock);
-		efivar_unregister(var);
-		drop_nlink(dentry->d_inode);
-		dput(dentry);
-		return 0;
-	}
+	if (efivar_entry_delete(var))
+		return -EINVAL;
 
-	spin_unlock(&efivars->lock);
-	return -EINVAL;
+	drop_nlink(dentry->d_inode);
+	dput(dentry);
+	return 0;
 };
 
 /*
@@ -1121,13 +960,65 @@ static struct dentry_operations efivarfs_d_ops = {
 	.d_delete = efivarfs_delete_dentry,
 };
 
+static int efivarfs_callback(struct efivar_entry *entry, void *data)
+{
+	struct super_block *sb = (struct super_block *)data;
+	struct inode *inode = NULL;
+	struct dentry *dentry, *root = sb->s_root;
+	unsigned long size = 0;
+	char *name;
+	int len, i;
+
+	len = utf16_strlen(entry->var.VariableName);
+
+	/* name, plus '-', plus GUID, plus NUL*/
+	name = kmalloc(len + 1 + EFI_VARIABLE_GUID_LEN + 1, GFP_KERNEL);
+	if (!name)
+		goto fail;
+
+	for (i = 0; i < len; i++)
+		name[i] = entry->var.VariableName[i] & 0xFF;
+
+	name[len] = '-';
+
+	efi_guid_unparse(&entry->var.VendorGuid, name + len + 1);
+
+	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
+
+	inode = efivarfs_get_inode(sb, root->d_inode, S_IFREG | 0644, 0);
+	if (!inode)
+		goto fail_name;
+
+	dentry = d_alloc_name(root, name);
+	if (!dentry)
+		goto fail_inode;
+
+	/* copied by the above to local storage in the dentry. */
+	kfree(name);
+
+	efivar_entry_size(entry, &size);
+	efivar_entry_add(entry);
+
+	mutex_lock(&inode->i_mutex);
+	inode->i_private = entry;
+	i_size_write(inode, size + sizeof(entry->var.Attributes));
+	mutex_unlock(&inode->i_mutex);
+	d_add(dentry, inode);
+
+	return 0;
+
+fail_inode:
+	iput(inode);
+fail_name:
+	kfree(name);
+fail:
+	return -ENOMEM;
+}
+
 static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode = NULL;
 	struct dentry *root;
-	struct efivar_entry *entry, *n;
-	struct efivars *efivars = __efivars;
-	char *name;
 
 	efivarfs_sb = sb;
 
@@ -1149,64 +1040,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root)
 		return -ENOMEM;
 
-	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		struct dentry *dentry, *root = efivarfs_sb->s_root;
-		unsigned long size = 0;
-		int len, i;
-
-		inode = NULL;
-
-		len = utf16_strlen(entry->var.VariableName);
-
-		/* name, plus '-', plus GUID, plus NUL*/
-		name = kmalloc(len + 1 + GUID_LEN + 1, GFP_ATOMIC);
-		if (!name)
-			goto fail;
-
-		for (i = 0; i < len; i++)
-			name[i] = entry->var.VariableName[i] & 0xFF;
-
-		name[len] = '-';
-
-		efi_guid_unparse(&entry->var.VendorGuid, name + len + 1);
-
-		name[len+GUID_LEN+1] = '\0';
-
-		inode = efivarfs_get_inode(efivarfs_sb, root->d_inode,
-					  S_IFREG | 0644, 0);
-		if (!inode)
-			goto fail_name;
-
-		dentry = d_alloc_name(root, name);
-		if (!dentry)
-			goto fail_inode;
-
-		/* copied by the above to local storage in the dentry. */
-		kfree(name);
-
-		spin_lock(&efivars->lock);
-		efivars->ops->get_variable(entry->var.VariableName,
-					   &entry->var.VendorGuid,
-					   &entry->var.Attributes,
-					   &size,
-					   NULL);
-		spin_unlock(&efivars->lock);
-
-		mutex_lock(&inode->i_mutex);
-		inode->i_private = entry;
-		i_size_write(inode, size + sizeof(entry->var.Attributes));
-		mutex_unlock(&inode->i_mutex);
-		d_add(dentry, inode);
-	}
-
-	return 0;
-
-fail_inode:
-	iput(inode);
-fail_name:
-	kfree(name);
-fail:
-	return -ENOMEM;
+	return efivar_init(efivarfs_callback, (void *)sb);
 }
 
 static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
@@ -1251,80 +1085,84 @@ static struct pstore_info efi_pstore_info;
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
-	struct efivars *efivars = psi->data;
-
-	spin_lock(&efivars->lock);
-	efivars->walk_entry = list_first_entry(&efivars->list,
-					       struct efivar_entry, list);
+	efivar_entry_iter_begin();
+	psi->data = NULL;
 	return 0;
 }
 
 static int efi_pstore_close(struct pstore_info *psi)
 {
-	struct efivars *efivars = psi->data;
-
-	spin_unlock(&efivars->lock);
+	efivar_entry_iter_end();
+	psi->data = NULL;
 	return 0;
 }
 
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       int *count, struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
+struct pstore_read_data {
+	u64 *id;
+	enum pstore_type_id *type;
+	int *count;
+	struct timespec *timespec;
+	char **buf;
+};
+
+static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 {
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct efivars *efivars = psi->data;
+	struct pstore_read_data *cb_data = data;
 	char name[DUMP_NAME_LEN];
 	int i;
 	int cnt;
-	unsigned int part, size;
-	unsigned long time;
-
-	while (&efivars->walk_entry->list != &efivars->list) {
-		if (!efi_guidcmp(efivars->walk_entry->var.VendorGuid,
-				 vendor)) {
-			for (i = 0; i < DUMP_NAME_LEN; i++) {
-				name[i] = efivars->walk_entry->var.VariableName[i];
-			}
-			if (sscanf(name, "dump-type%u-%u-%d-%lu",
-				   type, &part, &cnt, &time) == 4) {
-				*id = part;
-				*count = cnt;
-				timespec->tv_sec = time;
-				timespec->tv_nsec = 0;
-			} else if (sscanf(name, "dump-type%u-%u-%lu",
-				   type, &part, &time) == 3) {
-				/*
-				 * Check if an old format,
-				 * which doesn't support holding
-				 * multiple logs, remains.
-				 */
-				*id = part;
-				*count = 0;
-				timespec->tv_sec = time;
-				timespec->tv_nsec = 0;
-			} else {
-				efivars->walk_entry = list_entry(
-						efivars->walk_entry->list.next,
-						struct efivar_entry, list);
-				continue;
-			}
-
-			get_var_data_locked(efivars, &efivars->walk_entry->var);
-			size = efivars->walk_entry->var.DataSize;
-			*buf = kmalloc(size, GFP_KERNEL);
-			if (*buf == NULL)
-				return -ENOMEM;
-			memcpy(*buf, efivars->walk_entry->var.Data,
-			       size);
-			efivars->walk_entry = list_entry(
-					efivars->walk_entry->list.next,
-					struct efivar_entry, list);
-			return size;
-		}
-		efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
-						 struct efivar_entry, list);
-	}
-	return 0;
+	unsigned int part;
+	unsigned long time, size;
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+
+	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+		return 0;
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		name[i] = entry->var.VariableName[i];
+
+	if (sscanf(name, "dump-type%u-%u-%d-%lu",
+		   cb_data->type, &part, &cnt, &time) == 4) {
+		*cb_data->id = part;
+		*cb_data->count = cnt;
+		cb_data->timespec->tv_sec = time;
+		cb_data->timespec->tv_nsec = 0;
+	} else if (sscanf(name, "dump-type%u-%u-%lu",
+			  cb_data->type, &part, &time) == 3) {
+		/*
+		 * Check if an old format,
+		 * which doesn't support holding
+		 * multiple logs, remains.
+		 */
+		*cb_data->id = part;
+		*cb_data->count = 0;
+		cb_data->timespec->tv_sec = time;
+		cb_data->timespec->tv_nsec = 0;
+	} else
+		return 0;
+
+	efivar_entry_size(entry, &size);
+	*cb_data->buf = kmalloc(size, GFP_KERNEL);
+	if (*cb_data->buf == NULL)
+		return -ENOMEM;
+	memcpy(*cb_data->buf, entry->var.Data, size);
+	return size;
+}
+
+static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
+			       int *count, struct timespec *timespec,
+			       char **buf, struct pstore_info *psi)
+{
+	struct pstore_read_data data;
+
+	data.id = id;
+	data.type = type;
+	data.count = count;
+	data.timespec = timespec;
+	data.buf = buf;
+
+	return __efivar_entry_iter(efi_pstore_read_func, &data,
+				   (struct efivar_entry **)&psi->data);
 }
 
 static int efi_pstore_write(enum pstore_type_id type,
@@ -1332,30 +1170,11 @@ static int efi_pstore_write(enum pstore_type_id type,
 		unsigned int part, int count, size_t size,
 		struct pstore_info *psi)
 {
+	struct efivar_entry *entry;
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct efivars *efivars = psi->data;
 	int i, ret = 0;
-	u64 storage_space, remaining_space, max_variable_size;
-	efi_status_t status = EFI_NOT_FOUND;
-
-	spin_lock(&efivars->lock);
-
-	/*
-	 * Check if there is a space enough to log.
-	 * size: a size of logging data
-	 * DUMP_NAME_LEN * 2: a maximum size of variable name
-	 */
-	status = efivars->ops->query_variable_info(PSTORE_EFI_ATTRIBUTES,
-						   &storage_space,
-						   &remaining_space,
-						   &max_variable_size);
-	if (status || remaining_space < size + DUMP_NAME_LEN * 2) {
-		spin_unlock(&efivars->lock);
-		*id = part;
-		return -ENOSPC;
-	}
 
 	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
 		get_seconds());
@@ -1363,86 +1182,91 @@ static int efi_pstore_write(enum pstore_type_id type,
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
-				   size, psi->buf);
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
 
-	spin_unlock(&efivars->lock);
+	memcpy(entry->var.VariableName, efi_name,
+	       utf16_strsize(efi_name, DUMP_NAME_LEN * 2));
+	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(vendor));
 
-	if (size)
-		ret = efivar_create_sysfs_entry(efivars,
-					  utf16_strsize(efi_name,
-							DUMP_NAME_LEN * 2),
-					  efi_name, &vendor);
+	ret = efivar_entry_set_safe(entry, PSTORE_EFI_ATTRIBUTES,
+				    size, psi->buf);
+
+	if (size && !ret)
+		ret = efivar_create_sysfs_entry(entry);
 
 	*id = part;
 	return ret;
 };
 
+struct pstore_erase_data {
+	u64 id;
+	enum pstore_type_id type;
+	int count;
+	struct timespec time;
+	efi_char16_t *name;
+};
+
+/*
+ * Clean up an entry with the same name
+ */
+static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
+{
+	struct pstore_erase_data *ed = data;
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	efi_char16_t efi_name_old[DUMP_NAME_LEN];
+	efi_char16_t *efi_name = ed->name;
+	unsigned long utf16_len = utf16_strlen(ed->name);
+	char name_old[DUMP_NAME_LEN];
+	int i;
+
+	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+		return 0;
+
+	if (utf16_strncmp(entry->var.VariableName,
+			  efi_name, (size_t)utf16_len)) {
+		/*
+		 * Check if an old format, which doesn't support
+		 * holding multiple logs, remains.
+		 */
+		sprintf(name_old, "dump-type%u-%u-%lu", ed->type,
+			(unsigned int)ed->id, ed->time.tv_sec);
+
+		for (i = 0; i < DUMP_NAME_LEN; i++)
+			efi_name_old[i] = name_old[i];
+
+		if (utf16_strncmp(entry->var.VariableName, efi_name_old,
+				  utf16_strlen(efi_name_old)))
+			return 0;
+	}
+
+	/* found */
+	__efivar_entry_delete(entry);
+	return 1;
+}
+
 static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 			    struct timespec time, struct pstore_info *psi)
 {
+	struct pstore_erase_data edata;
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
-	char name_old[DUMP_NAME_LEN];
-	efi_char16_t efi_name_old[DUMP_NAME_LEN];
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct efivars *efivars = psi->data;
-	struct efivar_entry *entry, *found = NULL;
 	int i;
 
 	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
 		time.tv_sec);
 
-	spin_lock(&efivars->lock);
-
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	/*
-	 * Clean up an entry with the same name
-	 */
-
-	list_for_each_entry(entry, &efivars->list, list) {
-		get_var_data_locked(efivars, &entry->var);
-
-		if (efi_guidcmp(entry->var.VendorGuid, vendor))
-			continue;
-		if (utf16_strncmp(entry->var.VariableName, efi_name,
-				  utf16_strlen(efi_name))) {
-			/*
-			 * Check if an old format,
-			 * which doesn't support holding
-			 * multiple logs, remains.
-			 */
-			sprintf(name_old, "dump-type%u-%u-%lu", type,
-				(unsigned int)id, time.tv_sec);
-
-			for (i = 0; i < DUMP_NAME_LEN; i++)
-				efi_name_old[i] = name_old[i];
-
-			if (utf16_strncmp(entry->var.VariableName, efi_name_old,
-					  utf16_strlen(efi_name_old)))
-				continue;
-		}
-
-		/* found */
-		found = entry;
-		efivars->ops->set_variable(entry->var.VariableName,
-					   &entry->var.VendorGuid,
-					   PSTORE_EFI_ATTRIBUTES,
-					   0, NULL);
-		break;
-	}
-
-	if (found)
-		list_del(&found->list);
-
-	spin_unlock(&efivars->lock);
+	edata.id = id;
+	edata.type = type;
+	edata.count = count;
+	edata.time = time;
+	edata.name = efi_name;
 
-	if (found)
-		efivar_unregister(found);
-
-	return 0;
+	return efivar_entry_iter(efi_pstore_erase_func, &edata);
 }
 #else
 static int efi_pstore_open(struct pstore_info *psi)
@@ -1455,8 +1279,8 @@ static int efi_pstore_close(struct pstore_info *psi)
 	return 0;
 }
 
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type, int *count,
-			       struct timespec *timespec,
+static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
+			       int *count, struct timespec *timespec,
 			       char **buf, struct pstore_info *psi)
 {
 	return -1;
@@ -1492,66 +1316,36 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *new_var = (struct efi_variable *)buf;
-	struct efivars *efivars = bin_attr->private;
-	struct efivar_entry *search_efivar, *n;
-	unsigned long strsize1, strsize2;
+	struct efivar_entry *new_entry;
 	efi_status_t status = EFI_NOT_FOUND;
-	int found = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
 	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    validate_var(new_var, new_var->Data, new_var->DataSize) == false) {
+	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
 
-	spin_lock(&efivars->lock);
+	new_entry = kmalloc(sizeof(*new_entry), GFP_KERNEL);
+	if (!new_entry)
+		return -ENOMEM;
 
-	/*
-	 * Does this variable already exist?
-	 */
-	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf16_strsize(new_var->VariableName, 1024);
-		if (strsize1 == strsize2 &&
-			!memcmp(&(search_efivar->var.VariableName),
-				new_var->VariableName, strsize1) &&
-			!efi_guidcmp(search_efivar->var.VendorGuid,
-				new_var->VendorGuid)) {
-			found = 1;
-			break;
-		}
-	}
-	if (found) {
-		spin_unlock(&efivars->lock);
+	memcpy(&new_entry->var, new_var, sizeof(*new_var));
+
+	status = efivar_entry_set(new_entry, new_var->Attributes,
+				  new_var->DataSize, new_var->Data, true);
+	if (status == -EEXIST)
 		return -EINVAL;
-	}
 
-	/* now *really* create the variable via EFI */
-	status = efivars->ops->set_variable(new_var->VariableName,
-					    &new_var->VendorGuid,
-					    new_var->Attributes,
-					    new_var->DataSize,
-					    new_var->Data);
+	if (status)
+		return status;
 
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
-		spin_unlock(&efivars->lock);
-		return -EIO;
-	}
-	spin_unlock(&efivars->lock);
-
-	/* Create the entry in sysfs.  Locking is not required here */
-	status = efivar_create_sysfs_entry(efivars,
-					   utf16_strsize(new_var->VariableName,
-							 1024),
-					   new_var->VariableName,
-					   &new_var->VendorGuid);
+	status = efivar_create_sysfs_entry(new_entry);
 	if (status) {
-		printk(KERN_WARNING "efivars: variable created, but sysfs entry wasn't.\n");
+		kfree(new_entry);
+		printk(KERN_WARNING "efivars: failed to create sysfs entry.\n");
 	}
 	return count;
 }
@@ -1561,56 +1355,25 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 			     char *buf, loff_t pos, size_t count)
 {
 	struct efi_variable *del_var = (struct efi_variable *)buf;
-	struct efivars *efivars = bin_attr->private;
-	struct efivar_entry *search_efivar, *n;
-	unsigned long strsize1, strsize2;
-	efi_status_t status = EFI_NOT_FOUND;
-	int found = 0;
+	struct efivar_entry *entry;
+	int err;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	spin_lock(&efivars->lock);
+	efivar_entry_iter_begin();
+	entry = efivar_entry_find(del_var->VariableName,
+				  del_var->VendorGuid, true);
+	if (!entry)
+		err = -EINVAL;
+	else
+		err = __efivar_entry_delete(entry);
+	efivar_entry_iter_end();
 
-	/*
-	 * Does this variable already exist?
-	 */
-	list_for_each_entry_safe(search_efivar, n, &efivars->list, list) {
-		strsize1 = utf16_strsize(search_efivar->var.VariableName, 1024);
-		strsize2 = utf16_strsize(del_var->VariableName, 1024);
-		if (strsize1 == strsize2 &&
-			!memcmp(&(search_efivar->var.VariableName),
-				del_var->VariableName, strsize1) &&
-			!efi_guidcmp(search_efivar->var.VendorGuid,
-				del_var->VendorGuid)) {
-			found = 1;
-			break;
-		}
-	}
-	if (!found) {
-		spin_unlock(&efivars->lock);
-		return -EINVAL;
-	}
-	/* force the Attributes/DataSize to 0 to ensure deletion */
-	del_var->Attributes = 0;
-	del_var->DataSize = 0;
-
-	status = efivars->ops->set_variable(del_var->VariableName,
-					    &del_var->VendorGuid,
-					    del_var->Attributes,
-					    del_var->DataSize,
-					    del_var->Data);
-
-	if (status != EFI_SUCCESS) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%lx\n",
-			status);
-		spin_unlock(&efivars->lock);
+	if (err)
 		return -EIO;
-	}
-	list_del(&search_efivar->list);
-	/* We need to release this lock before unregistering. */
-	spin_unlock(&efivars->lock);
-	efivar_unregister(search_efivar);
+
+	efivar_unregister(entry);
 
 	/* It's dead Jim.... */
 	return count;
@@ -1666,40 +1429,33 @@ static struct kobject *efi_kobj;
  *    variable_name_size = number of bytes required to hold
  *                         variable_name (not counting the NULL
  *                         character at the end.
- *    efivars->lock is not held on entry or exit.
  * Returns 1 on failure, 0 on success
  */
-static int
-efivar_create_sysfs_entry(struct efivars *efivars,
-			  unsigned long variable_name_size,
-			  efi_char16_t *variable_name,
-			  efi_guid_t *vendor_guid)
+int
+efivar_create_sysfs_entry(struct efivar_entry *new_var)
 {
 	int i, short_name_size;
 	char *short_name;
-	struct efivar_entry *new_efivar;
+	unsigned long variable_name_size;
+	efi_char16_t *variable_name;
+
+	variable_name = new_var->var.VariableName;
+	variable_name_size = utf16_strlen(variable_name) * sizeof(efi_char16_t);
 
 	/*
 	 * Length of the variable bytes in ASCII, plus the '-' separator,
 	 * plus the GUID, plus trailing NUL
 	 */
 	short_name_size = variable_name_size / sizeof(efi_char16_t)
-				+ 1 + GUID_LEN + 1;
+				+ 1 + EFI_VARIABLE_GUID_LEN + 1;
 
 	short_name = kzalloc(short_name_size, GFP_KERNEL);
-	new_efivar = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
 
-	if (!short_name || !new_efivar)  {
+	if (!short_name) {
 		kfree(short_name);
-		kfree(new_efivar);
 		return 1;
 	}
 
-	new_efivar->efivars = efivars;
-	memcpy(new_efivar->var.VariableName, variable_name,
-		variable_name_size);
-	memcpy(&(new_efivar->var.VendorGuid), vendor_guid, sizeof(efi_guid_t));
-
 	/* Convert Unicode to normal chars (assume top bits are 0),
 	   ala UTF-8 */
 	for (i=0; i < (int)(variable_name_size / sizeof(efi_char16_t)); i++) {
@@ -1709,30 +1465,25 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	   private variables from another's.         */
 
 	*(short_name + strlen(short_name)) = '-';
-	efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
+	efi_guid_unparse(&new_var->var.VendorGuid,
+			 short_name + strlen(short_name));
 
-	new_efivar->kobj.kset = efivars->kset;
-	i = kobject_init_and_add(&new_efivar->kobj, &efivar_ktype, NULL,
-				 "%s", short_name);
-	if (i) {
-		kfree(short_name);
-		kfree(new_efivar);
-		return 1;
-	}
+	new_var->kobj.kset = efivars_kset;
 
-	kobject_uevent(&new_efivar->kobj, KOBJ_ADD);
+	i = kobject_init_and_add(&new_var->kobj, &efivar_ktype,
+				   NULL, "%s", short_name);
 	kfree(short_name);
-	short_name = NULL;
-
-	spin_lock(&efivars->lock);
-	list_add(&new_efivar->list, &efivars->list);
-	spin_unlock(&efivars->lock);
+	if (i)
+		return 1;
 
+	kobject_uevent(&new_var->kobj, KOBJ_ADD);
+	efivar_entry_add(new_var);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(efivar_create_sysfs_entry);
 
 static int
-create_efivars_bin_attributes(struct efivars *efivars)
+create_efivars_bin_attributes(void)
 {
 	struct bin_attribute *attr;
 	int error;
@@ -1745,8 +1496,7 @@ create_efivars_bin_attributes(struct efivars *efivars)
 	attr->attr.name = "new_var";
 	attr->attr.mode = 0200;
 	attr->write = efivar_create;
-	attr->private = efivars;
-	efivars->new_var = attr;
+	efivars_new_var = attr;
 
 	/* del_var */
 	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
@@ -1757,75 +1507,105 @@ create_efivars_bin_attributes(struct efivars *efivars)
 	attr->attr.name = "del_var";
 	attr->attr.mode = 0200;
 	attr->write = efivar_delete;
-	attr->private = efivars;
-	efivars->del_var = attr;
+	efivars_del_var = attr;
 
-	sysfs_bin_attr_init(efivars->new_var);
-	sysfs_bin_attr_init(efivars->del_var);
+	sysfs_bin_attr_init(efivars_new_var);
+	sysfs_bin_attr_init(efivars_del_var);
 
 	/* Register */
-	error = sysfs_create_bin_file(&efivars->kset->kobj,
-				      efivars->new_var);
+	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_new_var);
 	if (error) {
 		printk(KERN_ERR "efivars: unable to create new_var sysfs file"
 			" due to error %d\n", error);
 		goto out_free;
 	}
-	error = sysfs_create_bin_file(&efivars->kset->kobj,
-				      efivars->del_var);
+
+	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_del_var);
 	if (error) {
 		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
 			" due to error %d\n", error);
-		sysfs_remove_bin_file(&efivars->kset->kobj,
-				      efivars->new_var);
+		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
 		goto out_free;
 	}
 
 	return 0;
 out_free:
-	kfree(efivars->del_var);
-	efivars->del_var = NULL;
-	kfree(efivars->new_var);
-	efivars->new_var = NULL;
+	kfree(efivars_del_var);
+	efivars_del_var = NULL;
+	kfree(efivars_new_var);
+	efivars_new_var = NULL;
 	return error;
 }
 
-void unregister_efivars(struct efivars *efivars)
+static int efivars_sysfs_callback(struct efivar_entry *entry, void *data)
 {
-	struct efivar_entry *entry, *n;
+	efivar_create_sysfs_entry(entry);
+	return 0;
+}
 
-	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		spin_lock(&efivars->lock);
-		list_del(&entry->list);
-		spin_unlock(&efivars->lock);
-		efivar_unregister(entry);
-	}
-	if (efivars->new_var)
-		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->new_var);
-	if (efivars->del_var)
-		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
-	kfree(efivars->new_var);
-	kfree(efivars->del_var);
-	kobject_put(efivars->kobject);
-	kset_unregister(efivars->kset);
+static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
+{
+	efivar_entry_remove(entry);
+	efivar_unregister(entry);
+	return 0;
 }
-EXPORT_SYMBOL_GPL(unregister_efivars);
 
-int register_efivars(struct efivars *efivars,
-		     const struct efivar_operations *ops,
-		     struct kobject *parent_kobj)
+void efivars_sysfs_exit(void)
+{
+	/* Remove all entries and destroy */
+	__efivar_entry_iter(efivar_sysfs_destroy, NULL, NULL);
+
+	if (efivars_new_var)
+		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
+	if (efivars_del_var)
+		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_del_var);
+	kfree(efivars_new_var);
+	kfree(efivars_del_var);
+	kset_unregister(efivars_kset);
+}
+
+int efivars_sysfs_init(struct kobject *parent_kobj)
 {
-	efi_status_t status = EFI_NOT_FOUND;
-	efi_guid_t vendor_guid;
-	efi_char16_t *variable_name;
-	unsigned long variable_name_size = 1024;
 	int error = 0;
 
-	if (__efivars) {
-		return -EBUSY;
+	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
+	       EFIVARS_DATE);
+
+	efivars_kset = kset_create_and_add("vars", NULL, parent_kobj);
+	if (!efivars_kset) {
+		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
+		return -ENOMEM;
 	}
 
-	__efivars = efivars;
+	efivar_init(efivars_sysfs_callback, NULL);
+
+	error = create_efivars_bin_attributes();
+	if (error)
+		efivars_sysfs_exit();
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(efivars_sysfs_init);
+
+/**
+ * efivar_init - build the initial list of EFI variables
+ * @func: callback function to invoke for every variable
+ * @data: function-specific data to pass to @func
+ *
+ * Get every EFI variable from the firmware, construct a struct
+ * efivar_entry and invoke @func. @func should call efivar_entry_add()
+ * to build the list of variables.
+ *
+ * Returns 0 on success, or a kernel error code on failure.
+ */
+int efivar_init(int (*func)(struct efivar_entry *, void *), void *data)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	struct efivar_entry *entry;
+	unsigned long variable_name_size = 1024;
+	efi_char16_t *variable_name;
+	efi_status_t status;
+	efi_guid_t vendor_guid;
 
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
 	if (!variable_name) {
@@ -1833,25 +1613,6 @@ int register_efivars(struct efivars *efivars,
 		return -ENOMEM;
 	}
 
-	spin_lock_init(&efivars->lock);
-	INIT_LIST_HEAD(&efivars->list);
-	efivars->ops = ops;
-
-	efivars->kset = kset_create_and_add("vars", NULL, parent_kobj);
-	if (!efivars->kset) {
-		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
-		error = -ENOMEM;
-		goto out;
-	}
-
-	efivars->kobject = kobject_create_and_add("efivars", parent_kobj);
-	if (!efivars->kobject) {
-		pr_err("efivars: Subsystem registration failed.\n");
-		error = -ENOMEM;
-		kset_unregister(efivars->kset);
-		goto out;
-	}
-
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
 	 * the variable name and variable data is 1024 bytes.
@@ -1860,15 +1621,21 @@ int register_efivars(struct efivars *efivars,
 	do {
 		variable_name_size = 1024;
 
+		spin_lock(&__efivars->lock);
 		status = ops->get_next_variable(&variable_name_size,
 						variable_name,
 						&vendor_guid);
+		spin_unlock(&__efivars->lock);
 		switch (status) {
 		case EFI_SUCCESS:
-			efivar_create_sysfs_entry(efivars,
-						  variable_name_size,
-						  variable_name,
-						  &vendor_guid);
+			entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+			if (!entry)
+				return -ENOMEM;
+
+			memcpy(entry->var.VariableName, variable_name, variable_name_size);
+			memcpy(&(entry->var.VendorGuid), &vendor_guid, sizeof(efi_guid_t));
+			func(entry, data);
+
 			break;
 		case EFI_NOT_FOUND:
 			break;
@@ -1880,49 +1647,558 @@ int register_efivars(struct efivars *efivars,
 		}
 	} while (status != EFI_NOT_FOUND);
 
-	error = create_efivars_bin_attributes(efivars);
-	if (error)
-		unregister_efivars(efivars);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efivar_init);
 
-	efivars->efi_pstore_info = efi_pstore_info;
+/**
+ * efivar_entry_add - add entry to variable list
+ * @entry: entry to add to list
+ */
+void efivar_entry_add(struct efivar_entry *entry)
+{
+	spin_lock(&__efivars->lock);
+	list_add(&entry->list, &__efivars->list);
+	spin_unlock(&__efivars->lock);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_add);
+
+/**
+ * efivar_entry_remove - remove entry from variable list
+ * @entry: entry to remove from list
+ */
+void efivar_entry_remove(struct efivar_entry *entry)
+{
+	spin_lock(&__efivars->lock);
+	list_del(&entry->list);
+	spin_unlock(&__efivars->lock);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_remove);
 
-	efivars->efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
-	if (efivars->efi_pstore_info.buf) {
-		efivars->efi_pstore_info.bufsize = 1024;
-		efivars->efi_pstore_info.data = efivars;
-		spin_lock_init(&efivars->efi_pstore_info.buf_lock);
-		pstore_register(&efivars->efi_pstore_info);
+/*
+ * efivar_entry_list_del_unlock - remove entry from variable list
+ * @entry: entry to remove
+ *
+ * Remove @entry from the variable list and release the list lock.
+ *
+ * NOTE: slightly weird locking semantics here - we expect to be
+ * called with the efivars lock already held, and we release it before
+ * returning. This is because this function is usually called after
+ * set_variable() while the lock is still held.
+ */
+static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
+{
+	WARN_ON(!spin_is_locked(&__efivars->lock));
+
+	list_del(&entry->list);
+	spin_unlock(&__efivars->lock);
+}
+
+/**
+ * __efivar_entry_delete - delete an EFI variable
+ * @entry: entry containing EFI variable to delete
+ *
+ * Delete the variable from the firmware but leave @entry on the
+ * variable list.
+ *
+ * This function differs from efivar_entry_delete() because it does
+ * not remove @entry from the variable list. Also, it is safe to be
+ * called from within a efivar_entry_iter_begin() and
+ * efivar_entry_iter_end() region, unlike efivar_entry_delete().
+ *
+ * Returns 0 on success, or a converted EFI status code if
+ * set_variable() fails.
+ */
+int __efivar_entry_delete(struct efivar_entry *entry)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	WARN_ON(!spin_is_locked(&__efivars->lock));
+
+	status = ops->set_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   0, 0, NULL);
+
+	return efi_status_to_err(status);
+}
+EXPORT_SYMBOL_GPL(__efivar_entry_delete);
+
+/**
+ * efivar_entry_delete - delete variable and remove entry from list
+ * @entry: entry containing variable to delete
+ *
+ * Delete the variable from the firmware and remove @entry from the
+ * variable list. It is the caller's responsibility to free @entry
+ * once we return.
+ *
+ * Returns 0 on success, or a converted EFI status code if
+ * set_variable() fails.
+ */
+int efivar_entry_delete(struct efivar_entry *entry)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	spin_lock(&__efivars->lock);
+	status = ops->set_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   0, 0, NULL);
+	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND)) {
+		spin_unlock(&__efivars->lock);
+		return efi_status_to_err(status);
 	}
 
-	register_filesystem(&efivarfs_type);
+	efivar_entry_list_del_unlock(entry);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efivar_entry_delete);
+
+/**
+ * efivar_entry_set - call set_variable()
+ * @entry: entry containing the EFI variable to write
+ * @attributes: variable attributes
+ * @size: size of @data buffer
+ * @data: buffer containing variable data
+ * @lookup: check to see if @entry is already on the list?
+ *
+ * Calls set_variable() for an EFI variable. If creating a new EFI
+ * variable, this function is usually followed by efivar_entry_add().
+ *
+ * Returns 0 on success, -EEXIST if @lookup is true and the entry
+ * already exists on the list, or a converted EFI status code if
+ * set_variable() fails.
+ */
+int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
+		     unsigned long size, void *data, bool lookup)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+	efi_char16_t *name = entry->var.VariableName;
+	efi_guid_t vendor = entry->var.VendorGuid;
 
-out:
-	kfree(variable_name);
+	spin_lock(&__efivars->lock);
 
-	return error;
+	if (lookup && efivar_entry_find(name, vendor, false)) {
+		spin_unlock(&__efivars->lock);
+		return -EEXIST;
+	}
+
+	status = ops->set_variable(name, &vendor, attributes, size, data);
+
+	spin_unlock(&__efivars->lock);
+
+	return efi_status_to_err(status);
 }
-EXPORT_SYMBOL_GPL(register_efivars);
+EXPORT_SYMBOL_GPL(efivar_entry_set);
+
+/**
+ * efivar_entry_set_safe - call set_variable() if enough space in firmware
+ * @entry: entry containing the EFI variable to write
+ * @attributes: variable attributes
+ * @size: size of @data buffer
+ * @data: buffer containing variable data
+ * @total: total variable size including variable name
+ *
+ * Calls query_variable_info() to ensure that there is enough free
+ * storage in the firmware for this variable, and if so, calls
+ * set_variable(). If creating a new EFI variable, this function is
+ * usually followed by efivar_entry_add().
+ *
+ * Returns 0 on success, -ENOSPC if the firmware does not have enough
+ * space for set_variable() to succeed, or a converted EFI status code
+ * if set_variable() fails.
+ */
+int efivar_entry_set_safe(struct efivar_entry *entry, u32 attributes,
+			  unsigned long size, void *data)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+	efi_char16_t *name = entry->var.VariableName;
+	efi_guid_t vendor = entry->var.VendorGuid;
+	u64 storage_size, remaining_size, max_size;
+	u64 total;
 
-/*
- * For now we register the efi subsystem with the firmware subsystem
- * and the vars subsystem with the efi subsystem.  In the future, it
- * might make sense to split off the efi subsystem into its own
- * driver, but for now only efivars will register with it, so just
- * include it here.
+	if (!ops->query_variable_info)
+		return -ENOSYS;
+
+	spin_lock(&__efivars->lock);
+	status = ops->query_variable_info(attributes, &storage_size,
+					  &remaining_size, &max_size);
+
+	if (status != EFI_SUCCESS) {
+		spin_unlock(&__efivars->lock);
+		return -ENOSPC;
+	}
+
+	/*
+	 * Does the firmware have enough free space to successfully
+	 * write this variable?
+	 */
+	total = utf16_strsize(name, 1024) + size;
+	if (remaining_size >= total)
+		status = ops->set_variable(name, &vendor,
+					   attributes, size, data);
+
+	spin_unlock(&__efivars->lock);
+
+	return efi_status_to_err(status);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_set_safe);
+/**
+ * efivar_entry_find - search for an entry
+ * @name: the EFI variable name
+ * @guid: the EFI variable vendor's guid
+ * @remove: should we remove the entry from the list?
+ *
+ * Search for an entry on the variable list that has the EFI variable
+ * name @name and vendor guid @guid. If an entry is found on the list
+ * and @remove is true, the entry is removed from the list.
+ *
+ * The caller MUST call efivar_entry_iter_begin() and
+ * efivar_entry_iter_end() before and after the invocation of this
+ * function, respectively.
+ *
+ * Returns the entry if found on the list, %NULL otherwise.
+ */
+struct efivar_entry *efivar_entry_find(efi_char16_t *name,
+				       efi_guid_t guid, bool remove)
+{
+	struct efivar_entry *entry, *n;
+	int strsize1, strsize2;
+	bool found = false;
+
+	WARN_ON(!spin_is_locked(&__efivars->lock));
+
+	list_for_each_entry_safe(entry, n, &__efivars->list, list) {
+		strsize1 = utf16_strsize(name, 1024);
+		strsize2 = utf16_strsize(entry->var.VariableName, 1024);
+		if (strsize1 == strsize2 &&
+		    !memcmp(name, &(entry->var.VariableName), strsize1) &&
+		    !efi_guidcmp(guid, entry->var.VendorGuid)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		return NULL;
+
+	if (remove)
+		list_del(&entry->list);
+
+	return entry;
+}
+EXPORT_SYMBOL_GPL(efivar_entry_find);
+
+/**
+ * efivar_query_info - call query_variable_info()
+ * @attributes: query for variables with these attributes
+ * @storage_size: maximum space for variables with @attributes
+ * @remaining_size: remaining space for variable with @attributes
+ * @max_size: maximum space for an individual variable with @attributes
+ *
+ * Query the amount of space available in the firmware for variables
+ * with @attributes.
+ *
+ * Returns 0 on success, -ENOSYS if the registered efivars ops do not
+ * support query_variable_info(), or a converted EFI status code if
+ * query_variable_info() fails.
+ */
+int efivar_query_info(u32 attributes, u64 *storage_size,
+		      u64 *remaining_size, u64 *max_size)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	if (!ops->query_variable_info)
+		return -ENOSYS;
+
+	spin_lock(&__efivars->lock);
+	status = ops->query_variable_info(attributes, storage_size,
+					  remaining_size, max_size);
+	spin_unlock(&__efivars->lock);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(efivar_query_info);
+
+/**
+ * efivar_entry_size - obtain the size of a variable
+ * @entry: entry for this variable
+ * @size: location to store the variable's size
+ */
+int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	*size = 0;
+
+	spin_lock(&__efivars->lock);
+	status = ops->get_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid, NULL, size, NULL);
+	spin_unlock(&__efivars->lock);
+
+	if (status != EFI_BUFFER_TOO_SMALL)
+	    return efi_status_to_err(status);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efivar_entry_size);
+
+/**
+ * efivar_entry_get - call get_variable()
+ * @entry: read data for this variable
+ * @attributes: variable attributes
+ * @size: size of @data buffer
+ * @data: buffer to store variable data
  */
+int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
+		     unsigned long *size, void *data)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	spin_lock(&__efivars->lock);
+	status = ops->get_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   attributes, size, data);
+	spin_unlock(&__efivars->lock);
+
+	return efi_status_to_err(status);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_get);
+
+/**
+ * efivar_entry_set_get_size - call set_variable() and get new size (atomic)
+ * @entry: entry containing variable to set and get
+ * @attributes: attributes of variable to be written
+ * @size: size of data buffer
+ * @data: buffer containing data to write
+ *
+ * This is a pretty special (complex) function. See efivarfs_file_write().
+ *
+ * Atomically call set_variable() for @entry and if the set is
+ * successful, return the new size of the variable from get_variable()
+ * in @size. The success of set_variable() is indicated by @set.
+ *
+ * Returns 0 on success, -EINVAL if the variable data is invalid, or a
+ * converted EFI status code if either of set_variable() or
+ * get_variable() fail.
+ *
+ * If the EFI variable does not exist when calling set_variable()
+ * (EFI_NOT_FOUND), @entry is removed from the variable list.
+ */
+int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
+			      unsigned long *size, void *data, bool *set)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	efi_status_t status;
+
+	*set = false;
+
+	if (efivar_validate(&entry->var, data, *size) == false)
+		return -EINVAL;
+
+	/*
+	 * The lock here protects the get_variable call, the conditional
+	 * set_variable call, and removal of the variable from the efivars
+	 * list (in the case of an authenticated delete).
+	 */
+	spin_lock(&__efivars->lock);
+
+	status = ops->set_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   attributes, *size, data);
+
+	if (status != EFI_SUCCESS) {
+		spin_unlock(&__efivars->lock);
+		return efi_status_to_err(status);
+	}
+
+	/*
+	 * Writing to the variable may have caused a change in size (which
+	 * could either be an append or an overwrite), or the variable to be
+	 * deleted. Perform a GetVariable() so we can tell what actually
+	 * happened.
+	 */
+	*size = 0;
+	status = ops->get_variable(entry->var.VariableName,
+				   &entry->var.VendorGuid,
+				   NULL, size, NULL);
+
+	if (status == EFI_NOT_FOUND)
+		efivar_entry_list_del_unlock(entry);
+	else
+		spin_unlock(&__efivars->lock);
+
+	return efi_status_to_err(status);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_set_get_size);
+
+/**
+ * efivar_entry_iter_begin - begin iterating the variable list
+ *
+ * Lock the variable list to prevent entry insertion and removal until
+ * efivar_entry_iter_end() is called. This function is usually used in
+ * conjunction with __efivar_entry_iter() or efivar_entry_iter().
+ */
+void efivar_entry_iter_begin(void)
+{
+	spin_lock(&__efivars->lock);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
+
+/**
+ * efivar_entry_iter_end - finish iterating the variable list
+ *
+ * Unlock the variable list and allow modifications to the list again.
+ */
+void efivar_entry_iter_end(void)
+{
+	spin_unlock(&__efivars->lock);
+}
+EXPORT_SYMBOL_GPL(efivar_entry_iter_end);
+
+/**
+ * __efivar_entry_iter - iterate over variable list
+ * @func: callback function
+ * @data: function-specific data to pass to callback
+ * @prev: entry to begin iterating from
+ *
+ * Iterate over the list of EFI variables and call @func with every
+ * entry on the list. It is safe for @func to remove entries in the
+ * list via efivar_entry_delete().
+ *
+ * You MUST call efivar_enter_iter_begin() before this function, and
+ * efivar_entry_iter_end() afterwards.
+ *
+ * It is possible to begin iteration from an arbitrary entry within
+ * the list by passing @prev. @prev is updated on return to point to
+ * the last entry passed to @func. To begin iterating from the
+ * beginning of the list @prev must be %NULL.
+ *
+ * The restrictions for @func are the same as documented for
+ * efivar_entry_iter().
+ */
+int __efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
+			void *data, struct efivar_entry **prev)
+{
+	struct efivar_entry *entry, *n;
+	int err = 0;
+
+	if (!prev || !*prev) {
+		list_for_each_entry_safe(entry, n, &__efivars->list, list) {
+			err = func(entry, data);
+			if (err)
+				break;
+		}
+
+		if (prev)
+			*prev = entry;
+
+		return err;
+	}
+
+
+	list_for_each_entry_safe_continue((*prev), n, &__efivars->list, list) {
+		err = func(*prev, data);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(__efivar_entry_iter);
+
+/**
+ * efivar_entry_iter - iterate over variable list
+ * @func: callback function
+ * @data: function-specific data to pass to callback
+ *
+ * Iterate over the list of EFI variables and call @func with every
+ * entry on the list. It is safe for @func to remove entries in the
+ * list via efivar_entry_delete() while iterating.
+ *
+ * Some notes for the callback function:
+ *  - a non-zero return value indicates an error and terminates the loop
+ *  - @func is called from atomic context
+ */
+int efivar_entry_iter(int (*func)(struct efivar_entry *, void *), void *data)
+{
+	int err = 0;
+
+	efivar_entry_iter_begin();
+	err = __efivar_entry_iter(func, data, NULL);
+	efivar_entry_iter_end();
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(efivar_entry_iter);
+
+/**
+ * efivars_register - register an efivars
+ * @efivars: efivars to register
+ * @ops: efivars operations
+ *
+ * Only a single efivars can be registered at any time.
+ */
+int efivars_register(struct efivars *efivars,
+		     const struct efivar_operations *ops)
+{
+	if (__efivars)
+		return -EBUSY;
+
+	spin_lock_init(&efivars->lock);
+	INIT_LIST_HEAD(&efivars->list);
+	efivars->ops = ops;
+
+	__efivars = efivars;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efivars_register);
+
+/**
+ * efivars_unregister - unregister an efivars
+ * @efivars: efivars to unregister
+ *
+ * The caller must have already removed every entry from the list,
+ * failure to do so is an error.
+ */
+int efivars_unregister(struct efivars *efivars)
+{
+	if (!__efivars) {
+		printk(KERN_ERR "efivars not registered\n");
+		return -EINVAL;
+	}
+
+	if (__efivars != efivars)
+		return -EINVAL;
+
+	if (!list_empty(&efivars->list)) {
+		printk(KERN_ERR "efivars list not empty\n");
+		return -EBUSY;
+	}
+
+	__efivars = NULL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efivars_unregister);
+
+static struct kobject *efivars_kobject;
 
 static int __init
 efivars_init(void)
 {
-	int error = 0;
-
-	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
-	       EFIVARS_DATE);
+	int error;
 
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return 0;
 
-	/* For now we'll register the efi directory at /sys/firmware/efi */
+	/* Register the efi directory at /sys/firmware/efi */
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
 		printk(KERN_ERR "efivars: Firmware registration failed.\n");
@@ -1934,9 +2210,18 @@ efivars_init(void)
 	generic_ops.get_next_variable = efi.get_next_variable;
 	generic_ops.query_variable_info = efi.query_variable_info;
 
-	error = register_efivars(&generic_efivars, &generic_ops, efi_kobj);
+	error = efivars_register(&generic_efivars, &generic_ops);
 	if (error)
-		goto err_put;
+		return error;
+
+	efivars_sysfs_init(efi_kobj);
+
+	efivars_kobject = kobject_create_and_add("efivars", efi_kobj);
+	if (!efivars_kobject) {
+		pr_err("efivars: Subsystem registration failed.\n");
+		kobject_put(efi_kobj);
+		return -ENOMEM;
+	}
 
 	/* Don't forget the systab entry */
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
@@ -1944,15 +2229,17 @@ efivars_init(void)
 		printk(KERN_ERR
 		       "efivars: Sysfs attribute export failed with error %d.\n",
 		       error);
-		goto err_unregister;
 	}
 
-	return 0;
+	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (efi_pstore_info.buf) {
+		efi_pstore_info.bufsize = 4096;
+		spin_lock_init(&efi_pstore_info.buf_lock);
+		pstore_register(&efi_pstore_info);
+	}
+
+	register_filesystem(&efivarfs_type);
 
-err_unregister:
-	unregister_efivars(&generic_efivars);
-err_put:
-	kobject_put(efi_kobj);
 	return error;
 }
 
@@ -1960,7 +2247,8 @@ static void __exit
 efivars_exit(void)
 {
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
-		unregister_efivars(&generic_efivars);
+		efivars_unregister(&generic_efivars);
+		kobject_put(efivars_kobject);
 		kobject_put(efi_kobj);
 	}
 }
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index c409a75..e902f21 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -882,12 +882,19 @@ static __init int gsmi_init(void)
 		goto out_remove_bin_file;
 	}
 
-	ret = register_efivars(&efivars, &efivar_ops, gsmi_kobj);
+	ret = efivars_register(&efivars, &efivar_ops);
 	if (ret) {
 		printk(KERN_INFO "gsmi: Failed to register efivars\n");
 		goto out_remove_sysfs_files;
 	}
 
+	ret = efivars_sysfs_init(gsmi_kobj);
+	if (ret) {
+		printk(KERN_INFO "gsmi: Failed to create efivars files\n");
+		efivars_unregister(&efivars);
+		goto out_remove_sysfs_files;
+	}
+
 	register_reboot_notifier(&gsmi_reboot_notifier);
 	register_die_notifier(&gsmi_die_notifier);
 	atomic_notifier_chain_register(&panic_notifier_list,
@@ -919,7 +926,7 @@ static void __exit gsmi_exit(void)
 	unregister_die_notifier(&gsmi_die_notifier);
 	atomic_notifier_chain_unregister(&panic_notifier_list,
 					 &gsmi_panic_notifier);
-	unregister_efivars(&efivars);
+	efivars_unregister(&efivars);
 
 	sysfs_remove_files(gsmi_kobj, gsmi_attrs);
 	sysfs_remove_bin_file(gsmi_kobj, &eventlog_bin_attr);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 231d046..ab793c4 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -663,6 +663,12 @@ static inline int efi_enabled(int facility)
 				EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS | \
 				EFI_VARIABLE_APPEND_WRITE)
 /*
+ * Length of a GUID string (strlen("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
+ * not including trailing NUL
+ */
+#define EFI_VARIABLE_GUID_LEN 36
+
+/*
  * The type of search to perform when calling boottime->locate_handle
  */
 #define EFI_LOCATE_ALL_HANDLES			0
@@ -764,16 +770,70 @@ struct efivars {
 	struct list_head list;
 	struct kset *kset;
 	struct kobject *kobject;
-	struct bin_attribute *new_var, *del_var;
 	const struct efivar_operations *ops;
-	struct efivar_entry *walk_entry;
-	struct pstore_info efi_pstore_info;
 };
 
-int register_efivars(struct efivars *efivars,
-		     const struct efivar_operations *ops,
-		     struct kobject *parent_kobj);
-void unregister_efivars(struct efivars *efivars);
+/*
+ * The maximum size of VariableName + Data = 1024
+ * Therefore, it's reasonable to save that much
+ * space in each part of the structure,
+ * and we use a page for reading/writing.
+ */
+
+struct efi_variable {
+	efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
+	efi_guid_t    VendorGuid;
+	unsigned long DataSize;
+	__u8          Data[1024];
+	efi_status_t  Status;
+	__u32         Attributes;
+} __attribute__((packed));
+
+struct efivar_entry {
+	struct efivars *efivars;
+	struct efi_variable var;
+	struct list_head list;
+	struct kobject kobj;
+};
+
+int efivars_register(struct efivars *efivars,
+		     const struct efivar_operations *ops);
+int efivars_unregister(struct efivars *efivars);
+
+int efivar_init(int (*func)(struct efivar_entry *, void *), void *data);
+
+void efivar_entry_add(struct efivar_entry *entry);
+void efivar_entry_remove(struct efivar_entry *entry);
+
+int __efivar_entry_delete(struct efivar_entry *entry);
+int efivar_entry_delete(struct efivar_entry *entry);
+
+int efivar_entry_size(struct efivar_entry *entry, unsigned long *size);
+int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
+		     unsigned long *size, void *data);
+int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
+		     unsigned long size, void *data, bool lookup);
+int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
+			      unsigned long *size, void *data, bool *set);
+int efivar_entry_set_safe(struct efivar_entry *entry, u32 attributes,
+			  unsigned long size, void *data);
+
+void efivar_entry_iter_begin(void);
+void efivar_entry_iter_end(void);
+
+int __efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
+			void *data, struct efivar_entry **prev);
+int efivar_entry_iter(int (*func)(struct efivar_entry *, void *), void *data);
+
+struct efivar_entry *efivar_entry_find(efi_char16_t *name,
+				       efi_guid_t guid, bool remove);
+
+bool efivar_validate(struct efi_variable *var, u8 *data, unsigned long len);
+int efivar_query_info(u32 attributes, u64 *storage_size,
+		      u64 *remaining_size, u64 *max_size);
+
+int efivars_sysfs_init(struct kobject *parent);
+int efivar_create_sysfs_entry(struct efivar_entry *new_var);
 
 #endif /* CONFIG_EFI_VARS */
 
-- 
1.7.11.7
