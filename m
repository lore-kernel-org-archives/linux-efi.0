From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] efi: Make efivarfs entries immutable by default.
Date: Wed,  3 Feb 2016 08:02:47 -0500
Message-ID: <1454504567-2826-5-git-send-email-pjones@redhat.com>
References: <1454504567-2826-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454504567-2826-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

"rm -rf" is bricking some peoples' laptops because of variables being
used to store non-reinitializable firmware driver data that's required
to POST the hardware.

These are 100% bugs, and they need to be fixed, but in the mean time it
shouldn't be easy to *accidentally* brick machines.

We have to have delete working, and picking which variables do and don't
work for deletion is quite intractable, so instead make everything
immutable by default (except for a whitelist), and make tools that
aren't quite so broad-spectrum unset the immutable flag.

v2: adds Timeout to our whitelist.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 83 +++++++++++++++++++++++++++++++++------------
 fs/efivarfs/file.c          | 69 +++++++++++++++++++++++++++++++++++++
 fs/efivarfs/inode.c         | 32 +++++++++++------
 fs/efivarfs/internal.h      |  3 +-
 fs/efivarfs/super.c         |  9 +++--
 include/linux/efi.h         |  2 ++
 6 files changed, 163 insertions(+), 35 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index e084d08..2cd32ae 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -186,9 +186,33 @@ static const struct variable_validate variable_validate[] = {
 	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", validate_uint16 },
 	{ EFI_GLOBAL_VARIABLE_GUID, "Lang", validate_ascii_string },
 	{ EFI_GLOBAL_VARIABLE_GUID, "PlatformLang", validate_ascii_string },
+	{ EFI_GLOBAL_VARIABLE_GUID, "OsIndications", NULL },
+	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", NULL },
 	{ NULL_GUID, "", NULL },
 };
 
+static bool
+variable_matches(const char *var_name, size_t len, const char *match_name,
+		 int *match)
+{
+	for (*match = 0; match_name[*match] && *match < len; (*match)++) {
+		char c = match_name[*match];
+		char u = var_name[*match];
+
+		/* Wildcard in the matching name means we've matched */
+		if (c == '*')
+			return true;
+
+		/* Case sensitive match */
+		if (c != u)
+			break;
+
+		if (!c)
+			return true;
+	}
+	return false;
+}
+
 bool
 efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
 {
@@ -205,36 +229,53 @@ efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
 
 	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
 		const char *name = variable_validate[i].name;
-		int match;
+		int match = 0;
 
-		for (match = 0; ; match++) {
-			char c = name[match];
-			char u = utf8_name[match];
+		if (variable_matches(utf8_name, utf8_size+1, name, &match)) {
+			kfree(utf8_name);
+			if (variable_validate[i].validate == NULL)
+				break;
+			return variable_validate[i].validate(var_name, match,
+							     data, len);
+		}
 
-			/* Wildcard in the matching name means we've matched */
-			if (c == '*') {
-				kfree(utf8_name);
-				return variable_validate[i].validate(var_name,
-							     match, data, len);
-			}
+	}
+	kfree(utf8_name);
+	return true;
+}
+EXPORT_SYMBOL_GPL(efivar_validate);
 
-			/* Case sensitive match */
-			if (c != u)
-				break;
+bool
+efivar_variable_is_protected(efi_guid_t vendor, const char *var_name,
+			     size_t len)
+{
+	int i;
+	bool found = false;
+	int match = 0;
 
-			/* Reached the end of the string while matching */
-			if (!c) {
-				kfree(utf8_name);
-				return variable_validate[i].validate(var_name,
-							     match, data, len);
-			}
+	/*
+	 * Now check the validated variables list and then the whitelist -
+	 * both are whitelists
+	 */
+	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
+		if (efi_guidcmp(variable_validate[i].guid, vendor))
+			continue;
+
+		if (variable_matches(var_name, len,
+				     variable_validate[i].name, &match)) {
+			found = true;
+			break;
 		}
 	}
 
-	kfree(utf8_name);
+	/*
+	 * If we found it in our list, it /isn't/ one of our protected names.
+	 */
+	if (found)
+		return false;
 	return true;
 }
-EXPORT_SYMBOL_GPL(efivar_validate);
+EXPORT_SYMBOL_GPL(efivar_variable_is_protected);
 
 static efi_status_t
 check_var_size(u32 attributes, unsigned long size)
diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index c424e48..b793c85 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -10,6 +10,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/mount.h>
 
 #include "internal.h"
 
@@ -103,9 +104,77 @@ out_free:
 	return size;
 }
 
+static int
+efivarfs_ioc_getxflags(struct file *file,
+		       void __user *arg)
+{
+	struct inode *inode = file->f_mapping->host;
+	unsigned int iflags;
+	unsigned int flags = 0;
+
+	iflags = inode->i_flags;
+	if (iflags & S_IMMUTABLE)
+		flags |= FS_IMMUTABLE_FL;
+
+	if (copy_to_user(arg, &flags, sizeof(flags)))
+		return -EFAULT;
+	return 0;
+}
+
+static int
+efivarfs_ioc_setxflags(struct file *file,
+		       void __user *arg)
+{
+	struct inode *inode = file->f_mapping->host;
+	unsigned int flags;
+	int error;
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	if (copy_from_user(&flags, arg, sizeof(flags)))
+		return -EFAULT;
+
+	if (flags & ~FS_IMMUTABLE_FL)
+		return -EOPNOTSUPP;
+
+	if (!capable(CAP_LINUX_IMMUTABLE))
+		return -EPERM;
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+
+	if (flags & FS_IMMUTABLE_FL)
+		inode->i_flags |= S_IMMUTABLE;
+	else
+		inode->i_flags &= ~S_IMMUTABLE;
+
+	return 0;
+}
+
+long
+efivarfs_file_ioctl(
+		    struct file *file,
+		    unsigned int cmd,
+		    unsigned long p)
+{
+	void __user *arg = (void __user *)p;
+
+	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+		return efivarfs_ioc_getxflags(file, arg);
+	case FS_IOC_SETFLAGS:
+		return efivarfs_ioc_setxflags(file, arg);
+	}
+
+	return -ENOTTY;
+}
+
 const struct file_operations efivarfs_file_operations = {
 	.open	= simple_open,
 	.read	= efivarfs_file_read,
 	.write	= efivarfs_file_write,
 	.llseek	= no_llseek,
+	.unlocked_ioctl = efivarfs_file_ioctl,
 };
diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 3381b9d..00735e0 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -15,7 +15,8 @@
 #include "internal.h"
 
 struct inode *efivarfs_get_inode(struct super_block *sb,
-				const struct inode *dir, int mode, dev_t dev)
+				const struct inode *dir, int mode,
+				dev_t dev, bool is_protected)
 {
 	struct inode *inode = new_inode(sb);
 
@@ -23,6 +24,7 @@ struct inode *efivarfs_get_inode(struct super_block *sb,
 		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		inode->i_flags = is_protected ? S_IMMUTABLE : 0;
 		switch (mode & S_IFMT) {
 		case S_IFREG:
 			inode->i_fop = &efivarfs_file_operations;
@@ -102,22 +104,17 @@ static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
 static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 			  umode_t mode, bool excl)
 {
-	struct inode *inode;
+	struct inode *inode = NULL;
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
+	bool is_protected = false;
 
 	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
 		return -EINVAL;
 
-	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
-	if (!inode)
-		return -ENOMEM;
-
 	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
-	if (!var) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!var)
+		return -ENOMEM;
 
 	/* length of the variable name itself: remove GUID and separator */
 	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
@@ -125,6 +122,18 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
 			&var->var.VendorGuid);
 
+	if (efivar_variable_is_protected(var->var.VendorGuid,
+					 dentry->d_name.name,
+					 dentry->d_name.len))
+		is_protected = true;
+
+	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0, is_protected);
+	if (!inode) {
+		err = -ENOMEM;
+		goto out;
+	}
+	inode->i_flags = 0;
+
 	for (i = 0; i < namelen; i++)
 		var->var.VariableName[i] = dentry->d_name.name[i];
 
@@ -138,7 +147,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 out:
 	if (err) {
 		kfree(var);
-		iput(inode);
+		if (inode)
+			iput(inode);
 	}
 	return err;
 }
diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
index b5ff16a..f435832 100644
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -15,7 +15,8 @@ extern const struct file_operations efivarfs_file_operations;
 extern const struct inode_operations efivarfs_dir_inode_operations;
 extern bool efivarfs_valid_name(const char *str, int len);
 extern struct inode *efivarfs_get_inode(struct super_block *sb,
-			const struct inode *dir, int mode, dev_t dev);
+			const struct inode *dir, int mode, dev_t dev,
+			bool is_protected);
 
 extern struct list_head efivarfs_list;
 
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 8651ac2..6d5dd56 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -120,6 +120,7 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	char *name;
 	int len;
 	int err = -ENOMEM;
+	bool is_protected = false;
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
@@ -137,13 +138,17 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 
 	ucs2_as_utf8(name, entry->var.VariableName, len);
 
+	if (efivar_variable_is_protected(entry->var.VendorGuid, name, len))
+		is_protected = true;
+
 	name[len] = '-';
 
 	efi_guid_to_str(&entry->var.VendorGuid, name + len + 1);
 
 	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
 
-	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0);
+	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0,
+				   is_protected);
 	if (!inode)
 		goto fail_name;
 
@@ -199,7 +204,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_d_op		= &efivarfs_d_ops;
 	sb->s_time_gran         = 1;
 
-	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
+	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0, false);
 	if (!inode)
 		return -ENOMEM;
 	inode->i_op = &efivarfs_dir_inode_operations;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 569b5a8..afc841b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1200,6 +1200,8 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 				       struct list_head *head, bool remove);
 
 bool efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len);
+bool efivar_variable_is_protected(efi_guid_t vendor, const char *name,
+				  size_t len);
 
 extern struct work_struct efivar_work;
 void efivar_run_worker(void);
-- 
2.5.0
