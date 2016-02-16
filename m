From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] efi: Make efivarfs entries immutable by default.
Date: Tue, 16 Feb 2016 11:09:43 -0500
Message-ID: <1455638983-30455-3-git-send-email-pjones@redhat.com>
References: <1455638983-30455-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455638983-30455-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/filesystems/efivarfs.txt         |   7 ++
 drivers/firmware/efi/vars.c                    | 115 ++++++++++++++++++++-----
 fs/efivarfs/file.c                             |  70 +++++++++++++++
 fs/efivarfs/inode.c                            |  30 ++++---
 fs/efivarfs/internal.h                         |   3 +-
 fs/efivarfs/super.c                            |   9 +-
 include/linux/efi.h                            |   4 +-
 tools/testing/selftests/efivarfs/efivarfs.sh   |  19 +++-
 tools/testing/selftests/efivarfs/open-unlink.c |  72 +++++++++++++++-
 9 files changed, 287 insertions(+), 42 deletions(-)

diff --git a/Documentation/filesystems/efivarfs.txt b/Documentation/filesystems/efivarfs.txt
index c477af0..686a64b 100644
--- a/Documentation/filesystems/efivarfs.txt
+++ b/Documentation/filesystems/efivarfs.txt
@@ -14,3 +14,10 @@ filesystem.
 efivarfs is typically mounted like this,
 
 	mount -t efivarfs none /sys/firmware/efi/efivars
+
+Due to the presence of numerous firmware bugs where removing non-standard
+UEFI variables causes the system firmware to fail to POST, efivarfs
+files that are not well-known standardized variables are created
+as immutable files.  This doesn't prevent removal - "chattr -i" will work -
+but it does prevent this kind of failure from being accomplished
+accidentally.
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 3d96fa4..dd01883 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -172,10 +172,12 @@ struct variable_validate {
 };
 
 /*
- * This is the list of variables we need to validate.
+ * This is the list of variables we need to validate, as well as the
+ * whitelist for what we think is safe not to default to immutable.
  *
  * If it has a validate() method that's not NULL, it'll go into the
- * validation routine.  If not, it is assumed valid.
+ * validation routine.  If not, it is assumed valid, but still used for
+ * whitelisting.
  *
  * Note that it's sorted by {vendor,name}, but globbed names must come after
  * any other name with the same prefix.
@@ -193,17 +195,59 @@ static const struct variable_validate variable_validate[] = {
 	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOut", validate_device_path },
 	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOutDev", validate_device_path },
 	{ EFI_GLOBAL_VARIABLE_GUID, "Lang", validate_ascii_string },
+	{ EFI_GLOBAL_VARIABLE_GUID, "OsIndications", NULL },
 	{ EFI_GLOBAL_VARIABLE_GUID, "PlatformLang", validate_ascii_string },
 	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", validate_uint16 },
+	{ LINUX_EFI_CRASH_GUID, "*", NULL },
 	{ NULL_GUID, "", NULL },
 };
 
+static bool
+variable_matches(const efi_char16_t *ucs2_name, const char *var_name,
+		 size_t len, const char *match_name, int *match)
+{
+	for (*match = 0; ; (*match)++) {
+		char c = match_name[*match];
+		char u = var_name[*match];
+
+		/* Wildcard in the matching name means we've matched */
+		if (c == '*')
+			return true;
+
+		/* All special variables are plain ascii unless they were
+		 * wildcards. */
+		if (ucs2_name[*match] > 127)
+			return false;
+
+		/* Case sensitive match */
+		if (!c && *match == len)
+			return true;
+
+		if (c != u)
+			return false;
+
+		if (!c)
+			return true;
+	}
+	return true;
+}
+
 bool
 efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
-		unsigned long len)
+		unsigned long data_size)
 {
 	int i;
-	u16 *unicode_name = var_name;
+	unsigned long utf8_size;
+	u8 *utf8_name;
+
+	utf8_size = ucs2_strlen(var_name);
+	utf8_name = kmalloc(utf8_size + 1, GFP_KERNEL);
+	if (!utf8_name)
+		return false;
+
+	for (i = 0; var_name[i] != 0; i++)
+		utf8_name[i] = var_name[i];
+	utf8_name[i] = '\0';
 
 	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
 		const char *name = variable_validate[i].name;
@@ -212,33 +256,58 @@ efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
 		if (efi_guidcmp(vendor, variable_validate[i].vendor))
 			continue;
 
-		for (match = 0; ; match++) {
-			char c = name[match];
-			u16 u = unicode_name[match];
+		if (variable_matches(var_name, utf8_name, utf8_size+1,
+				     name, &match)) {
+			if (variable_validate[i].validate == NULL)
+				break;
+			kfree(utf8_name);
+			return variable_validate[i].validate(var_name, match,
+							     data, data_size);
+		}
+	}
+	kfree(utf8_name);
+	return true;
+}
+EXPORT_SYMBOL_GPL(efivar_validate);
 
-			/* All special variables are plain ascii */
-			if (u > 127)
-				return true;
+bool
+efivar_variable_is_removable(efi_guid_t vendor, const char *var_name,
+			     size_t len)
+{
+	int i;
+	bool found = false;
+	int match = 0;
+	efi_char16_t *ucs2_name;
 
-			/* Wildcard in the matching name means we've matched */
-			if (c == '*')
-				return variable_validate[i].validate(var_name,
-							     match, data, len);
+	ucs2_name = kmalloc((len+1) * sizeof (efi_char16_t), GFP_KERNEL);
+	if (!ucs2_name)
+		return false;
 
-			/* Case sensitive match */
-			if (c != u)
-				break;
+	for (i = 0; i < len; i++)
+		ucs2_name[i] = var_name[i];
+	ucs2_name[i] = 0;
+
+	/*
+	 * Check if our variable is in the validated variables list
+	 */
+	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
+		if (efi_guidcmp(variable_validate[i].vendor, vendor))
+			continue;
 
-			/* Reached the end of the string while matching */
-			if (!c)
-				return variable_validate[i].validate(var_name,
-							     match, data, len);
+		if (variable_matches(ucs2_name, var_name, len,
+				     variable_validate[i].name, &match)) {
+			found = true;
+			break;
 		}
 	}
+	kfree(ucs2_name);
 
-	return true;
+	/*
+	 * If it's in our list, it is removable.
+	 */
+	return found;
 }
-EXPORT_SYMBOL_GPL(efivar_validate);
+EXPORT_SYMBOL_GPL(efivar_variable_is_removable);
 
 static efi_status_t
 check_var_size(u32 attributes, unsigned long size)
diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index 90001da..66842e5 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -10,6 +10,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/mount.h>
 
 #include "internal.h"
 
@@ -103,9 +104,78 @@ out_free:
 	return size;
 }
 
+static int
+efivarfs_ioc_getxflags(struct file *file, void __user *arg)
+{
+	struct inode *inode = file->f_mapping->host;
+	unsigned int i_flags;
+	unsigned int flags = 0;
+
+	i_flags = inode->i_flags;
+	if (i_flags & S_IMMUTABLE)
+		flags |= FS_IMMUTABLE_FL;
+
+	if (copy_to_user(arg, &flags, sizeof(flags)))
+		return -EFAULT;
+	return 0;
+}
+
+static int
+efivarfs_ioc_setxflags(struct file *file, void __user *arg)
+{
+	struct inode *inode = file->f_mapping->host;
+	unsigned int flags;
+	unsigned int i_flags = 0;
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
+	if (flags & FS_IMMUTABLE_FL)
+		i_flags |= S_IMMUTABLE;
+
+
+	error = mnt_want_write_file(file);
+	if (error)
+		return error;
+
+	mutex_lock(&inode->i_mutex);
+	inode_set_flags(inode, i_flags, S_IMMUTABLE);
+	mutex_unlock(&inode->i_mutex);
+
+	mnt_drop_write_file(file);
+
+	return 0;
+}
+
+long
+efivarfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long p)
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
index 3381b9d..e2ab6d0 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -15,7 +15,8 @@
 #include "internal.h"
 
 struct inode *efivarfs_get_inode(struct super_block *sb,
-				const struct inode *dir, int mode, dev_t dev)
+				const struct inode *dir, int mode,
+				dev_t dev, bool is_removable)
 {
 	struct inode *inode = new_inode(sb);
 
@@ -23,6 +24,7 @@ struct inode *efivarfs_get_inode(struct super_block *sb,
 		inode->i_ino = get_next_ino();
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		inode->i_flags = is_removable ? 0 : S_IMMUTABLE;
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
+	bool is_removable = false;
 
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
@@ -125,6 +122,16 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
 			&var->var.VendorGuid);
 
+	if (efivar_variable_is_removable(var->var.VendorGuid,
+					 dentry->d_name.name, namelen))
+		is_removable = true;
+
+	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0, is_removable);
+	if (!inode) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	for (i = 0; i < namelen; i++)
 		var->var.VariableName[i] = dentry->d_name.name[i];
 
@@ -138,7 +145,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
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
index b5ff16a..b450518 100644
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -15,7 +15,8 @@ extern const struct file_operations efivarfs_file_operations;
 extern const struct inode_operations efivarfs_dir_inode_operations;
 extern bool efivarfs_valid_name(const char *str, int len);
 extern struct inode *efivarfs_get_inode(struct super_block *sb,
-			const struct inode *dir, int mode, dev_t dev);
+			const struct inode *dir, int mode, dev_t dev,
+			bool is_removable);
 
 extern struct list_head efivarfs_list;
 
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 86a2121..aa3258e 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -120,6 +120,7 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	char *name;
 	int len, i;
 	int err = -ENOMEM;
+	bool is_removable = false;
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
@@ -138,13 +139,17 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	for (i = 0; i < len; i++)
 		name[i] = entry->var.VariableName[i] & 0xFF;
 
+	if (efivar_variable_is_removable(entry->var.VendorGuid, name, len))
+		is_removable = true;
+
 	name[len] = '-';
 
 	efi_guid_to_str(&entry->var.VendorGuid, name + len + 1);
 
 	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
 
-	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0);
+	inode = efivarfs_get_inode(sb, d_inode(root), S_IFREG | 0644, 0,
+				   is_removable);
 	if (!inode)
 		goto fail_name;
 
@@ -200,7 +205,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_d_op		= &efivarfs_d_ops;
 	sb->s_time_gran         = 1;
 
-	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
+	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0, true);
 	if (!inode)
 		return -ENOMEM;
 	inode->i_op = &efivarfs_dir_inode_operations;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 52444fd..47be3ad 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1200,7 +1200,9 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 				       struct list_head *head, bool remove);
 
 bool efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
-		     unsigned long len);
+		     unsigned long data_size);
+bool efivar_variable_is_removable(efi_guid_t vendor, const char *name,
+				  size_t len);
 
 extern struct work_struct efivar_work;
 void efivar_run_worker(void);
diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
index 77edcdc..0572784 100755
--- a/tools/testing/selftests/efivarfs/efivarfs.sh
+++ b/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -88,7 +88,11 @@ test_delete()
 		exit 1
 	fi
 
-	rm $file
+	rm $file 2>/dev/null
+	if [ $? -ne 0 ]; then
+		chattr -i $file
+		rm $file
+	fi
 
 	if [ -e $file ]; then
 		echo "$file couldn't be deleted" >&2
@@ -111,6 +115,7 @@ test_zero_size_delete()
 		exit 1
 	fi
 
+	chattr -i $file
 	printf "$attrs" > $file
 
 	if [ -e $file ]; then
@@ -141,7 +146,11 @@ test_valid_filenames()
 			echo "$file could not be created" >&2
 			ret=1
 		else
-			rm $file
+			rm $file 2>/dev/null
+			if [ $? -ne 0 ]; then
+				chattr -i $file
+				rm $file
+			fi
 		fi
 	done
 
@@ -174,7 +183,11 @@ test_invalid_filenames()
 
 		if [ -e $file ]; then
 			echo "Creating $file should have failed" >&2
-			rm $file
+			rm $file 2>/dev/null
+			if [ $? -ne 0 ]; then
+				chattr -i $file
+				rm $file
+			fi
 			ret=1
 		fi
 	done
diff --git a/tools/testing/selftests/efivarfs/open-unlink.c b/tools/testing/selftests/efivarfs/open-unlink.c
index 8c07644..4af74f7 100644
--- a/tools/testing/selftests/efivarfs/open-unlink.c
+++ b/tools/testing/selftests/efivarfs/open-unlink.c
@@ -1,10 +1,68 @@
+#include <errno.h>
 #include <stdio.h>
 #include <stdint.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
+#include <linux/fs.h>
+
+static int set_immutable(const char *path, int immutable)
+{
+	unsigned int flags;
+	int fd;
+	int rc;
+	int error;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return fd;
+
+	rc = ioctl(fd, FS_IOC_GETFLAGS, &flags);
+	if (rc < 0) {
+		error = errno;
+		close(fd);
+		errno = error;
+		return rc;
+	}
+
+	if (immutable)
+		flags |= FS_IMMUTABLE_FL;
+	else
+		flags &= ~FS_IMMUTABLE_FL;
+
+	rc = ioctl(fd, FS_IOC_SETFLAGS, &flags);
+	error = errno;
+	close(fd);
+	errno = error;
+	return rc;
+}
+
+static int get_immutable(const char *path)
+{
+	unsigned int flags;
+	int fd;
+	int rc;
+	int error;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return fd;
+
+	rc = ioctl(fd, FS_IOC_GETFLAGS, &flags);
+	if (rc < 0) {
+		error = errno;
+		close(fd);
+		errno = error;
+		return rc;
+	}
+	close(fd);
+	if (flags & FS_IMMUTABLE_FL)
+		return 1;
+	return 0;
+}
 
 int main(int argc, char **argv)
 {
@@ -27,7 +85,7 @@ int main(int argc, char **argv)
 	buf[4] = 0;
 
 	/* create a test variable */
-	fd = open(path, O_WRONLY | O_CREAT);
+	fd = open(path, O_WRONLY | O_CREAT, 0600);
 	if (fd < 0) {
 		perror("open(O_WRONLY)");
 		return EXIT_FAILURE;
@@ -41,6 +99,18 @@ int main(int argc, char **argv)
 
 	close(fd);
 
+	rc = get_immutable(path);
+	if (rc < 0) {
+		perror("ioctl(FS_IOC_GETFLAGS)");
+		return EXIT_FAILURE;
+	} else if (rc) {
+		rc = set_immutable(path, 0);
+		if (rc < 0) {
+			perror("ioctl(FS_IOC_SETFLAGS)");
+			return EXIT_FAILURE;
+		}
+	}
+
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		perror("open");
-- 
2.5.0
