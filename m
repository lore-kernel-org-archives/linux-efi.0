From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 7/7] efivarfs: Move to fs/efivarfs
Date: Fri,  8 Feb 2013 20:59:18 +0000
Message-ID: <1360357158-8168-8-git-send-email-matt@console-pimps.org>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360357158-8168-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Now that efivarfs uses the efivar API, move it out of efivars.c and
into fs/efivarfs where it belongs. This move allows us to turn on
other EFI varible code, like CONFIG_EFI_VARS_SYSFS without requiring
that the efivarfs code also be built, and vice versa.

Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 MAINTAINERS                |   9 +
 drivers/firmware/efivars.c | 487 ---------------------------------------------
 fs/Kconfig                 |   1 +
 fs/Makefile                |   1 +
 fs/efivarfs/Kconfig        |  12 ++
 fs/efivarfs/Makefile       |   7 +
 fs/efivarfs/file.c         | 130 ++++++++++++
 fs/efivarfs/inode.c        | 179 +++++++++++++++++
 fs/efivarfs/internal.h     |  18 ++
 fs/efivarfs/super.c        | 233 ++++++++++++++++++++++
 10 files changed, 590 insertions(+), 487 deletions(-)
 create mode 100644 fs/efivarfs/Kconfig
 create mode 100644 fs/efivarfs/Makefile
 create mode 100644 fs/efivarfs/file.c
 create mode 100644 fs/efivarfs/inode.c
 create mode 100644 fs/efivarfs/internal.h
 create mode 100644 fs/efivarfs/super.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c31e5a4..d2b3b29 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2895,6 +2895,15 @@ F:	drivers/firmware/efivars.c
 F:	drivers/firmware/efi/*
 F:	include/linux/efi*.h
 
+EFI VARIABLE FILESYSTEM
+M:	Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
+M:	Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
+M:	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
+L:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Maintained
+F:	fs/efivarfs/
+
 EFIFB FRAMEBUFFER DRIVER
 L:	linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 M:	Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index c2275b8..3445334 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -228,12 +228,6 @@ efivar_validate(struct efi_variable *var, u8 *data, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(efivar_validate);
 
-static int efivarfs_file_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static int efi_status_to_err(efi_status_t status)
 {
 	int err;
@@ -267,485 +261,6 @@ static int efi_status_to_err(efi_status_t status)
 	return err;
 }
 
-static ssize_t efivarfs_file_write(struct file *file,
-		const char __user *userbuf, size_t count, loff_t *ppos)
-{
-	struct efivar_entry *var = file->private_data;
-	void *data;
-	u32 attributes;
-	struct inode *inode = file->f_mapping->host;
-	unsigned long datasize = count - sizeof(attributes);
-	u64 storage_size, remaining_size, max_size;
-	ssize_t bytes = 0;
-	bool set = false;
-	int err;
-
-	if (count < sizeof(attributes))
-		return -EINVAL;
-
-	if (copy_from_user(&attributes, userbuf, sizeof(attributes)))
-		return -EFAULT;
-
-	if (attributes & ~(EFI_VARIABLE_MASK))
-		return -EINVAL;
-
-	/*
-	 * Ensure that the user can't allocate arbitrarily large
-	 * amounts of memory. Pick a default size of 64K if
-	 * QueryVariableInfo() isn't supported by the firmware.
-	 */
-	err = efivar_query_info(attributes, &storage_size,
-			       &remaining_size, &max_size);
-	if (err) {
-		if (err != -ENOSYS)
-			return err;
-
-		remaining_size = 65536;
-	}
-
-	if (datasize > remaining_size)
-		return -ENOSPC;
-
-	data = kmalloc(datasize, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
-		bytes = -EFAULT;
-		goto out;
-	}
-
-	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
-					  data, &set);
-	if (!set && bytes)
-		goto out;
-
-	if (bytes == -ENOENT) {
-		drop_nlink(inode);
-		d_delete(file->f_dentry);
-		dput(file->f_dentry);
-	} else {
-		mutex_lock(&inode->i_mutex);
-		i_size_write(inode, datasize + sizeof(attributes));
-		mutex_unlock(&inode->i_mutex);
-	}
-
-	bytes = count;
-
-out:
-	kfree(data);
-
-	return bytes;
-}
-
-static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
-		size_t count, loff_t *ppos)
-{
-	struct efivar_entry *var = file->private_data;
-	unsigned long datasize = 0;
-	u32 attributes;
-	void *data;
-	ssize_t size = 0;
-	int err;
-
-	err = efivar_entry_size(var, &datasize);
-	if (err)
-		return err;
-
-	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
-
-	if (!data)
-		return -ENOMEM;
-
-	size = efivar_entry_get(var, &attributes, &datasize,
-				data + sizeof(attributes));
-	if (size)
-		goto out_free;
-
-	memcpy(data, &attributes, sizeof(attributes));
-	size = simple_read_from_buffer(userbuf, count, ppos,
-				       data, datasize + sizeof(attributes));
-out_free:
-	kfree(data);
-
-	return size;
-}
-
-static void efivarfs_evict_inode(struct inode *inode)
-{
-	clear_inode(inode);
-}
-
-static const struct super_operations efivarfs_ops = {
-	.statfs = simple_statfs,
-	.drop_inode = generic_delete_inode,
-	.evict_inode = efivarfs_evict_inode,
-	.show_options = generic_show_options,
-};
-
-static struct super_block *efivarfs_sb;
-
-static const struct inode_operations efivarfs_dir_inode_operations;
-
-static const struct file_operations efivarfs_file_operations = {
-	.open	= efivarfs_file_open,
-	.read	= efivarfs_file_read,
-	.write	= efivarfs_file_write,
-	.llseek	= no_llseek,
-};
-
-static struct inode *efivarfs_get_inode(struct super_block *sb,
-				const struct inode *dir, int mode, dev_t dev)
-{
-	struct inode *inode = new_inode(sb);
-
-	if (inode) {
-		inode->i_ino = get_next_ino();
-		inode->i_mode = mode;
-		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		switch (mode & S_IFMT) {
-		case S_IFREG:
-			inode->i_fop = &efivarfs_file_operations;
-			break;
-		case S_IFDIR:
-			inode->i_op = &efivarfs_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
-			inc_nlink(inode);
-			break;
-		}
-	}
-	return inode;
-}
-
-/*
- * Return true if 'str' is a valid efivarfs filename of the form,
- *
- *	VariableName-12345678-1234-1234-1234-1234567891bc
- */
-static bool efivarfs_valid_name(const char *str, int len)
-{
-	const char *s;
-	int i, j;
-	int ranges[2][5] = {
-		{ 0, 9, 14, 19, 24 },
-		{ 8, 13, 18, 23, 36 }
-	};
-
-	/*
-	 * We need a GUID, plus at least one letter for the variable name,
-	 * plus the '-' separator
-	 */
-	if (len < EFI_VARIABLE_GUID_LEN + 2)
-		return false;
-
-	s = strchr(str, '-');
-	if (!s)
-		return false;
-
-	s++;			/* Skip '-' */
-
-	/* Ensure we have enough characters for a GUID */
-	if (len - (s - str) != EFI_VARIABLE_GUID_LEN)
-		return false;
-
-	/*
-	 * Validate that 's' is of the correct format, e.g.
-	 *
-	 *	12345678-1234-1234-1234-123456789abc
-	 */
-	for (i = 0; i < 5; i++) {
-		for (j = ranges[0][i]; j < ranges[1][i]; j++) {
-			if (hex_to_bin(s[j]) < 0)
-				return false;
-		}
-
-		if (j < EFI_VARIABLE_GUID_LEN && s[j] != '-')
-			return false;
-	}
-
-	return true;
-}
-
-static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
-{
-	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
-	guid->b[1] = hex_to_bin(str[4]) << 4 | hex_to_bin(str[5]);
-	guid->b[2] = hex_to_bin(str[2]) << 4 | hex_to_bin(str[3]);
-	guid->b[3] = hex_to_bin(str[0]) << 4 | hex_to_bin(str[1]);
-	guid->b[4] = hex_to_bin(str[11]) << 4 | hex_to_bin(str[12]);
-	guid->b[5] = hex_to_bin(str[9]) << 4 | hex_to_bin(str[10]);
-	guid->b[6] = hex_to_bin(str[16]) << 4 | hex_to_bin(str[17]);
-	guid->b[7] = hex_to_bin(str[14]) << 4 | hex_to_bin(str[15]);
-	guid->b[8] = hex_to_bin(str[19]) << 4 | hex_to_bin(str[20]);
-	guid->b[9] = hex_to_bin(str[21]) << 4 | hex_to_bin(str[22]);
-	guid->b[10] = hex_to_bin(str[24]) << 4 | hex_to_bin(str[25]);
-	guid->b[11] = hex_to_bin(str[26]) << 4 | hex_to_bin(str[27]);
-	guid->b[12] = hex_to_bin(str[28]) << 4 | hex_to_bin(str[29]);
-	guid->b[13] = hex_to_bin(str[30]) << 4 | hex_to_bin(str[31]);
-	guid->b[14] = hex_to_bin(str[32]) << 4 | hex_to_bin(str[33]);
-	guid->b[15] = hex_to_bin(str[34]) << 4 | hex_to_bin(str[35]);
-}
-
-static int efivarfs_create(struct inode *dir, struct dentry *dentry,
-			  umode_t mode, bool excl)
-{
-	struct inode *inode;
-	struct efivar_entry *var;
-	int namelen, i = 0, err = 0;
-
-	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
-		return -EINVAL;
-
-	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
-	if (!inode)
-		return -ENOMEM;
-
-	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
-	if (!var) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	/* length of the variable name itself: remove GUID and separator */
-	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
-
-	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
-			&var->var.VendorGuid);
-
-	for (i = 0; i < namelen; i++)
-		var->var.VariableName[i] = dentry->d_name.name[i];
-
-	var->var.VariableName[i] = '\0';
-
-	inode->i_private = var;
-
-	efivar_entry_add(var);
-	d_instantiate(dentry, inode);
-	dget(dentry);
-out:
-	if (err) {
-		kfree(var);
-		iput(inode);
-	}
-	return err;
-}
-
-static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
-{
-	struct efivar_entry *var = dentry->d_inode->i_private;
-
-	if (efivar_entry_delete(var))
-		return -EINVAL;
-
-	drop_nlink(dentry->d_inode);
-	dput(dentry);
-	return 0;
-};
-
-/*
- * Compare two efivarfs file names.
- *
- * An efivarfs filename is composed of two parts,
- *
- *	1. A case-sensitive variable name
- *	2. A case-insensitive GUID
- *
- * So we need to perform a case-sensitive match on part 1 and a
- * case-insensitive match on part 2.
- */
-static int efivarfs_d_compare(const struct dentry *parent, const struct inode *pinode,
-			      const struct dentry *dentry, const struct inode *inode,
-			      unsigned int len, const char *str,
-			      const struct qstr *name)
-{
-	const char *q;
-	int guid;
-
-	/*
-	 * If the string we're being asked to compare doesn't match
-	 * the expected format return "no match".
-	 */
-	if (!efivarfs_valid_name(str, len))
-		return 1;
-
-	if (!(q = strchr(name->name, '-')))
-		return 1;
-
-	/* Find part 1, the variable name. */
-	guid = q - (const char *)name->name;
-
-	/* Case-sensitive compare for the variable name */
-	if (memcmp(str, name->name, guid))
-		return 1;
-
-	/* Case-insensitive compare for the GUID */
-	return strcasecmp(&name->name[guid], &str[guid]);
-}
-
-static int efivarfs_d_hash(const struct dentry *dentry,
-			   const struct inode *inode, struct qstr *qstr)
-{
-	const unsigned char *us;
-	char lower[NAME_MAX];
-	int guid;
-
-	if (!efivarfs_valid_name(qstr->name, qstr->len))
-		return -EINVAL;
-
-	if (qstr->len > NAME_MAX)
-		return -ENAMETOOLONG;
-
-	us = strchr(qstr->name, '-');
-	if (!us)
-		return -EINVAL;
-
-	/* The variable name part is case-sensitive */
-	guid = us - qstr->name;
-	memcpy(lower, qstr->name, guid);
-
-	/* GUID is case-insensitive. */
-	for (us = &qstr->name[guid]; guid < qstr->len; guid++)
-		lower[guid] = tolower(*us++);
-	lower[guid] = '\0';
-
-	qstr->hash = full_name_hash(lower, qstr->len);
-	return 0;
-}
-
-/*
- * Retaining negative dentries for an in-memory filesystem just wastes
- * memory and lookup time: arrange for them to be deleted immediately.
- */
-static int efivarfs_delete_dentry(const struct dentry *dentry)
-{
-	return 1;
-}
-
-static struct dentry_operations efivarfs_d_ops = {
-	.d_compare = efivarfs_d_compare,
-	.d_hash = efivarfs_d_hash,
-	.d_delete = efivarfs_delete_dentry,
-};
-
-static int efivarfs_callback(struct efivar_entry *entry, void *data)
-{
-	struct super_block *sb = (struct super_block *)data;
-	struct inode *inode = NULL;
-	struct dentry *dentry, *root = sb->s_root;
-	unsigned long size = 0;
-	char *name;
-	int len, i;
-
-	len = utf16_strlen(entry->var.VariableName);
-
-	/* name, plus '-', plus GUID, plus NUL*/
-	name = kmalloc(len + 1 + EFI_VARIABLE_GUID_LEN + 1, GFP_KERNEL);
-	if (!name)
-		goto fail;
-
-	for (i = 0; i < len; i++)
-		name[i] = entry->var.VariableName[i] & 0xFF;
-
-	name[len] = '-';
-
-	efi_guid_unparse(&entry->var.VendorGuid, name + len + 1);
-
-	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
-
-	inode = efivarfs_get_inode(sb, root->d_inode, S_IFREG | 0644, 0);
-	if (!inode)
-		goto fail_name;
-
-	dentry = d_alloc_name(root, name);
-	if (!dentry)
-		goto fail_inode;
-
-	/* copied by the above to local storage in the dentry. */
-	kfree(name);
-
-	efivar_entry_size(entry, &size);
-	efivar_entry_add(entry);
-
-	mutex_lock(&inode->i_mutex);
-	inode->i_private = entry;
-	i_size_write(inode, size + sizeof(entry->var.Attributes));
-	mutex_unlock(&inode->i_mutex);
-	d_add(dentry, inode);
-
-	return 0;
-
-fail_inode:
-	iput(inode);
-fail_name:
-	kfree(name);
-fail:
-	return -ENOMEM;
-}
-
-static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
-{
-	struct inode *inode = NULL;
-	struct dentry *root;
-
-	efivarfs_sb = sb;
-
-	sb->s_maxbytes          = MAX_LFS_FILESIZE;
-	sb->s_blocksize         = PAGE_CACHE_SIZE;
-	sb->s_blocksize_bits    = PAGE_CACHE_SHIFT;
-	sb->s_magic             = EFIVARFS_MAGIC;
-	sb->s_op                = &efivarfs_ops;
-	sb->s_d_op		= &efivarfs_d_ops;
-	sb->s_time_gran         = 1;
-
-	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
-	if (!inode)
-		return -ENOMEM;
-	inode->i_op = &efivarfs_dir_inode_operations;
-
-	root = d_make_root(inode);
-	sb->s_root = root;
-	if (!root)
-		return -ENOMEM;
-
-	return efivar_init(efivarfs_callback, (void *)sb);
-}
-
-static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
-				    int flags, const char *dev_name, void *data)
-{
-	return mount_single(fs_type, flags, data, efivarfs_fill_super);
-}
-
-static void efivarfs_kill_sb(struct super_block *sb)
-{
-	kill_litter_super(sb);
-	efivarfs_sb = NULL;
-}
-
-static struct file_system_type efivarfs_type = {
-	.name    = "efivarfs",
-	.mount   = efivarfs_mount,
-	.kill_sb = efivarfs_kill_sb,
-};
-
-/*
- * Handle negative dentry.
- */
-static struct dentry *efivarfs_lookup(struct inode *dir, struct dentry *dentry,
-				      unsigned int flags)
-{
-	if (dentry->d_name.len > NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
-	d_add(dentry, NULL);
-	return NULL;
-}
-
-static const struct inode_operations efivarfs_dir_inode_operations = {
-	.lookup = efivarfs_lookup,
-	.unlink = efivarfs_unlink,
-	.create = efivarfs_create,
-};
-
 /*
  * Let's not leave out systab information that snuck into
  * the efivars driver
@@ -1370,8 +885,6 @@ efivars_init(void)
 		       error);
 	}
 
-	register_filesystem(&efivarfs_type);
-
 	return error;
 }
 
diff --git a/fs/Kconfig b/fs/Kconfig
index 780725a..c229f82 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -211,6 +211,7 @@ source "fs/sysv/Kconfig"
 source "fs/ufs/Kconfig"
 source "fs/exofs/Kconfig"
 source "fs/f2fs/Kconfig"
+source "fs/efivarfs/Kconfig"
 
 endif # MISC_FILESYSTEMS
 
diff --git a/fs/Makefile b/fs/Makefile
index 9d53192..0fde6a3 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -127,3 +127,4 @@ obj-$(CONFIG_F2FS_FS)		+= f2fs/
 obj-y				+= exofs/ # Multiple modules
 obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
+obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
diff --git a/fs/efivarfs/Kconfig b/fs/efivarfs/Kconfig
new file mode 100644
index 0000000..1fb2b7f
--- /dev/null
+++ b/fs/efivarfs/Kconfig
@@ -0,0 +1,12 @@
+config EFIVAR_FS
+	tristate "EFI Variable filesystem"
+	depends on EFI_VARS
+	help
+	  efivarfs is a replacement filesystem for the old EFI
+	  variable support via sysfs, as it doesn't suffer from the
+	  same 1024-byte variable size limit.
+
+	  To compile this file system support as a module, choose M
+	  here. The module will be called efivarfs.
+
+	  If unsure, say N.
diff --git a/fs/efivarfs/Makefile b/fs/efivarfs/Makefile
new file mode 100644
index 0000000..955d478
--- /dev/null
+++ b/fs/efivarfs/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the efivarfs filesystem
+#
+
+obj-$(CONFIG_EFIVAR_FS)		+= efivarfs.o
+
+efivarfs-objs			:= inode.o file.o super.o
diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
new file mode 100644
index 0000000..b886ebf
--- /dev/null
+++ b/fs/efivarfs/file.c
@@ -0,0 +1,130 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2012 Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/efi.h>
+#include <linux/fs.h>
+
+#include "internal.h"
+
+static int efivarfs_file_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t efivarfs_file_write(struct file *file,
+		const char __user *userbuf, size_t count, loff_t *ppos)
+{
+	struct efivar_entry *var = file->private_data;
+	void *data;
+	u32 attributes;
+	struct inode *inode = file->f_mapping->host;
+	unsigned long datasize = count - sizeof(attributes);
+	u64 storage_size, remaining_size, max_size;
+	ssize_t bytes = 0;
+	bool set = false;
+	int err;
+
+	if (count < sizeof(attributes))
+		return -EINVAL;
+
+	if (copy_from_user(&attributes, userbuf, sizeof(attributes)))
+		return -EFAULT;
+
+	if (attributes & ~(EFI_VARIABLE_MASK))
+		return -EINVAL;
+
+	/*
+	 * Ensure that the user can't allocate arbitrarily large
+	 * amounts of memory. Pick a default size of 64K if
+	 * QueryVariableInfo() isn't supported by the firmware.
+	 */
+	err = efivar_query_info(attributes, &storage_size,
+			       &remaining_size, &max_size);
+	if (err) {
+		if (err != -ENOSYS)
+			return err;
+
+		remaining_size = 65536;
+	}
+
+	if (datasize > remaining_size)
+		return -ENOSPC;
+
+	data = kmalloc(datasize, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
+		bytes = -EFAULT;
+		goto out;
+	}
+
+	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
+					  data, &set);
+	if (!set && bytes)
+		goto out;
+
+	if (bytes == -ENOENT) {
+		drop_nlink(inode);
+		d_delete(file->f_dentry);
+		dput(file->f_dentry);
+	} else {
+		mutex_lock(&inode->i_mutex);
+		i_size_write(inode, datasize + sizeof(attributes));
+		mutex_unlock(&inode->i_mutex);
+	}
+
+	bytes = count;
+
+out:
+	kfree(data);
+
+	return bytes;
+}
+
+static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
+		size_t count, loff_t *ppos)
+{
+	struct efivar_entry *var = file->private_data;
+	unsigned long datasize = 0;
+	u32 attributes;
+	void *data;
+	ssize_t size = 0;
+	int err;
+
+	err = efivar_entry_size(var, &datasize);
+	if (err)
+		return err;
+
+	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
+
+	if (!data)
+		return -ENOMEM;
+
+	size = efivar_entry_get(var, &attributes, &datasize,
+				data + sizeof(attributes));
+	if (size)
+		goto out_free;
+
+	memcpy(data, &attributes, sizeof(attributes));
+	size = simple_read_from_buffer(userbuf, count, ppos,
+				       data, datasize + sizeof(attributes));
+out_free:
+	kfree(data);
+
+	return size;
+}
+
+const struct file_operations efivarfs_file_operations = {
+	.open	= efivarfs_file_open,
+	.read	= efivarfs_file_read,
+	.write	= efivarfs_file_write,
+	.llseek	= no_llseek,
+};
diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
new file mode 100644
index 0000000..1a637ef
--- /dev/null
+++ b/fs/efivarfs/inode.c
@@ -0,0 +1,179 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2012 Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/efi.h>
+#include <linux/fs.h>
+
+#include "internal.h"
+
+struct inode *efivarfs_get_inode(struct super_block *sb,
+				const struct inode *dir, int mode, dev_t dev)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (inode) {
+		inode->i_ino = get_next_ino();
+		inode->i_mode = mode;
+		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		switch (mode & S_IFMT) {
+		case S_IFREG:
+			inode->i_fop = &efivarfs_file_operations;
+			break;
+		case S_IFDIR:
+			inode->i_op = &efivarfs_dir_inode_operations;
+			inode->i_fop = &simple_dir_operations;
+			inc_nlink(inode);
+			break;
+		}
+	}
+	return inode;
+}
+
+/*
+ * Return true if 'str' is a valid efivarfs filename of the form,
+ *
+ *	VariableName-12345678-1234-1234-1234-1234567891bc
+ */
+bool efivarfs_valid_name(const char *str, int len)
+{
+	const char *s;
+	int i, j;
+	int ranges[2][5] = {
+		{ 0, 9, 14, 19, 24 },
+		{ 8, 13, 18, 23, 36 }
+	};
+
+	/*
+	 * We need a GUID, plus at least one letter for the variable name,
+	 * plus the '-' separator
+	 */
+	if (len < EFI_VARIABLE_GUID_LEN + 2)
+		return false;
+
+	s = strchr(str, '-');
+	if (!s)
+		return false;
+
+	s++;			/* Skip '-' */
+
+	/* Ensure we have enough characters for a GUID */
+	if (len - (s - str) != EFI_VARIABLE_GUID_LEN)
+		return false;
+
+	/*
+	 * Validate that 's' is of the correct format, e.g.
+	 *
+	 *	12345678-1234-1234-1234-123456789abc
+	 */
+	for (i = 0; i < 5; i++) {
+		for (j = ranges[0][i]; j < ranges[1][i]; j++) {
+			if (hex_to_bin(s[j]) < 0)
+				return false;
+		}
+
+		if (j < EFI_VARIABLE_GUID_LEN && s[j] != '-')
+			return false;
+	}
+
+	return true;
+}
+
+static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
+{
+	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
+	guid->b[1] = hex_to_bin(str[4]) << 4 | hex_to_bin(str[5]);
+	guid->b[2] = hex_to_bin(str[2]) << 4 | hex_to_bin(str[3]);
+	guid->b[3] = hex_to_bin(str[0]) << 4 | hex_to_bin(str[1]);
+	guid->b[4] = hex_to_bin(str[11]) << 4 | hex_to_bin(str[12]);
+	guid->b[5] = hex_to_bin(str[9]) << 4 | hex_to_bin(str[10]);
+	guid->b[6] = hex_to_bin(str[16]) << 4 | hex_to_bin(str[17]);
+	guid->b[7] = hex_to_bin(str[14]) << 4 | hex_to_bin(str[15]);
+	guid->b[8] = hex_to_bin(str[19]) << 4 | hex_to_bin(str[20]);
+	guid->b[9] = hex_to_bin(str[21]) << 4 | hex_to_bin(str[22]);
+	guid->b[10] = hex_to_bin(str[24]) << 4 | hex_to_bin(str[25]);
+	guid->b[11] = hex_to_bin(str[26]) << 4 | hex_to_bin(str[27]);
+	guid->b[12] = hex_to_bin(str[28]) << 4 | hex_to_bin(str[29]);
+	guid->b[13] = hex_to_bin(str[30]) << 4 | hex_to_bin(str[31]);
+	guid->b[14] = hex_to_bin(str[32]) << 4 | hex_to_bin(str[33]);
+	guid->b[15] = hex_to_bin(str[34]) << 4 | hex_to_bin(str[35]);
+}
+
+static int efivarfs_create(struct inode *dir, struct dentry *dentry,
+			  umode_t mode, bool excl)
+{
+	struct inode *inode;
+	struct efivar_entry *var;
+	int namelen, i = 0, err = 0;
+
+	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
+		return -EINVAL;
+
+	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
+	if (!inode)
+		return -ENOMEM;
+
+	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
+	if (!var) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* length of the variable name itself: remove GUID and separator */
+	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
+
+	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
+			&var->var.VendorGuid);
+
+	for (i = 0; i < namelen; i++)
+		var->var.VariableName[i] = dentry->d_name.name[i];
+
+	var->var.VariableName[i] = '\0';
+
+	inode->i_private = var;
+
+	efivar_entry_add(var);
+	d_instantiate(dentry, inode);
+	dget(dentry);
+out:
+	if (err) {
+		kfree(var);
+		iput(inode);
+	}
+	return err;
+}
+
+static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	struct efivar_entry *var = dentry->d_inode->i_private;
+
+	if (efivar_entry_delete(var))
+		return -EINVAL;
+
+	drop_nlink(dentry->d_inode);
+	dput(dentry);
+	return 0;
+};
+
+/*
+ * Handle negative dentry.
+ */
+static struct dentry *efivarfs_lookup(struct inode *dir, struct dentry *dentry,
+				      unsigned int flags)
+{
+	if (dentry->d_name.len > NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+	d_add(dentry, NULL);
+	return NULL;
+}
+
+const struct inode_operations efivarfs_dir_inode_operations = {
+	.lookup = efivarfs_lookup,
+	.unlink = efivarfs_unlink,
+	.create = efivarfs_create,
+};
diff --git a/fs/efivarfs/internal.h b/fs/efivarfs/internal.h
new file mode 100644
index 0000000..507456c
--- /dev/null
+++ b/fs/efivarfs/internal.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2012 Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef EFIVAR_FS_INTERNAL_H
+#define EFIVAR_FS_INTERNAL_H
+
+extern const struct file_operations efivarfs_file_operations;
+extern const struct inode_operations efivarfs_dir_inode_operations;
+extern bool efivarfs_valid_name(const char *str, int len);
+extern struct inode *efivarfs_get_inode(struct super_block *sb,
+			const struct inode *dir, int mode, dev_t dev);
+
+#endif /* EFIVAR_FS_INTERNAL_H */
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
new file mode 100644
index 0000000..5266ce5
--- /dev/null
+++ b/fs/efivarfs/super.c
@@ -0,0 +1,233 @@
+/*
+ * Copyright (C) 2012 Red Hat, Inc.
+ * Copyright (C) 2012 Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ctype.h>
+#include <linux/efi.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/pagemap.h>
+
+#include "internal.h"
+
+static void efivarfs_evict_inode(struct inode *inode)
+{
+	clear_inode(inode);
+}
+
+static const struct super_operations efivarfs_ops = {
+	.statfs = simple_statfs,
+	.drop_inode = generic_delete_inode,
+	.evict_inode = efivarfs_evict_inode,
+	.show_options = generic_show_options,
+};
+
+static struct super_block *efivarfs_sb;
+
+/*
+ * Compare two efivarfs file names.
+ *
+ * An efivarfs filename is composed of two parts,
+ *
+ *	1. A case-sensitive variable name
+ *	2. A case-insensitive GUID
+ *
+ * So we need to perform a case-sensitive match on part 1 and a
+ * case-insensitive match on part 2.
+ */
+static int efivarfs_d_compare(const struct dentry *parent, const struct inode *pinode,
+			      const struct dentry *dentry, const struct inode *inode,
+			      unsigned int len, const char *str,
+			      const struct qstr *name)
+{
+	const char *q;
+	int guid;
+
+	/*
+	 * If the string we're being asked to compare doesn't match
+	 * the expected format return "no match".
+	 */
+	if (!efivarfs_valid_name(str, len))
+		return 1;
+
+	if (!(q = strchr(name->name, '-')))
+		return 1;
+
+	/* Find part 1, the variable name. */
+	guid = q - (const char *)name->name;
+
+	/* Case-sensitive compare for the variable name */
+	if (memcmp(str, name->name, guid))
+		return 1;
+
+	/* Case-insensitive compare for the GUID */
+	return strcasecmp(&name->name[guid], &str[guid]);
+}
+
+static int efivarfs_d_hash(const struct dentry *dentry,
+			   const struct inode *inode, struct qstr *qstr)
+{
+	const unsigned char *us;
+	char lower[NAME_MAX];
+	int guid;
+
+	if (!efivarfs_valid_name(qstr->name, qstr->len))
+		return -EINVAL;
+
+	if (qstr->len > NAME_MAX)
+		return -ENAMETOOLONG;
+
+	us = strchr(qstr->name, '-');
+	if (!us)
+		return -EINVAL;
+
+	/* The variable name part is case-sensitive */
+	guid = us - qstr->name;
+	memcpy(lower, qstr->name, guid);
+
+	/* GUID is case-insensitive. */
+	for (us = &qstr->name[guid]; guid < qstr->len; guid++)
+		lower[guid] = tolower(*us++);
+	lower[guid] = '\0';
+
+	qstr->hash = full_name_hash(lower, qstr->len);
+	return 0;
+}
+
+/*
+ * Retaining negative dentries for an in-memory filesystem just wastes
+ * memory and lookup time: arrange for them to be deleted immediately.
+ */
+static int efivarfs_delete_dentry(const struct dentry *dentry)
+{
+	return 1;
+}
+
+static struct dentry_operations efivarfs_d_ops = {
+	.d_compare = efivarfs_d_compare,
+	.d_hash = efivarfs_d_hash,
+	.d_delete = efivarfs_delete_dentry,
+};
+
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
+static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct inode *inode = NULL;
+	struct dentry *root;
+
+	efivarfs_sb = sb;
+
+	sb->s_maxbytes          = MAX_LFS_FILESIZE;
+	sb->s_blocksize         = PAGE_CACHE_SIZE;
+	sb->s_blocksize_bits    = PAGE_CACHE_SHIFT;
+	sb->s_magic             = EFIVARFS_MAGIC;
+	sb->s_op                = &efivarfs_ops;
+	sb->s_d_op		= &efivarfs_d_ops;
+	sb->s_time_gran         = 1;
+
+	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
+	if (!inode)
+		return -ENOMEM;
+	inode->i_op = &efivarfs_dir_inode_operations;
+
+	root = d_make_root(inode);
+	sb->s_root = root;
+	if (!root)
+		return -ENOMEM;
+
+	return efivar_init(efivarfs_callback, (void *)sb);
+}
+
+static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
+				    int flags, const char *dev_name, void *data)
+{
+	return mount_single(fs_type, flags, data, efivarfs_fill_super);
+}
+
+static void efivarfs_kill_sb(struct super_block *sb)
+{
+	kill_litter_super(sb);
+	efivarfs_sb = NULL;
+}
+
+static struct file_system_type efivarfs_type = {
+	.name    = "efivarfs",
+	.mount   = efivarfs_mount,
+	.kill_sb = efivarfs_kill_sb,
+};
+
+static __init int efivarfs_init(void)
+{
+	return register_filesystem(&efivarfs_type);
+
+}
+
+static __init void efivarfs_exit(void)
+{
+}
+
+MODULE_AUTHOR("Matthew Garrett, Jeremy Kerr");
+MODULE_DESCRIPTION("EFI Variable Filesystem");
+MODULE_LICENSE("GPL");
+
+module_init(efivarfs_init);
+module_exit(efivarfs_exit);
-- 
1.7.11.7
