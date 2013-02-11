From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 2/2] efivarfs: guid part of filenames are case-insensitive
Date: Mon, 11 Feb 2013 14:28:55 +0000
Message-ID: <1360592935-26026-3-git-send-email-matt@console-pimps.org>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360592935-26026-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It makes no sense to treat the following filenames as unique,

	VarName-abcdefab-abcd-abcd-abcd-abcdefabcdef
	VarName-ABCDEFAB-ABCD-ABCD-ABCD-ABCDEFABCDEF
	VarName-ABcDEfAB-ABcD-ABcD-ABcD-ABcDEfABcDEf
	VarName-aBcDEfAB-aBcD-aBcD-aBcD-aBcDEfaBcDEf
	... etc ...

since the guid will be converted into a binary representation, which
has no case.

Roll our own dentry operations so that we can treat the variable name
part of filenames ("VarName" in the above example) as case-sensitive,
but the guid portion as case-insensitive. That way, efivarfs will
refuse to create the above files if any one already exists.

Reported-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 101 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 100 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index a4fa409..10088fd 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -79,6 +79,7 @@
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/pstore.h>
+#include <linux/ctype.h>
 
 #include <linux/fs.h>
 #include <linux/ramfs.h>
@@ -1049,6 +1050,91 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 	return -EINVAL;
 };
 
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
 static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode = NULL;
@@ -1064,6 +1150,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_blocksize_bits    = PAGE_CACHE_SHIFT;
 	sb->s_magic             = EFIVARFS_MAGIC;
 	sb->s_op                = &efivarfs_ops;
+	sb->s_d_op		= &efivarfs_d_ops;
 	sb->s_time_gran         = 1;
 
 	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
@@ -1154,8 +1241,20 @@ static struct file_system_type efivarfs_type = {
 	.kill_sb = efivarfs_kill_sb,
 };
 
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
 static const struct inode_operations efivarfs_dir_inode_operations = {
-	.lookup = simple_lookup,
+	.lookup = efivarfs_lookup,
 	.unlink = efivarfs_unlink,
 	.create = efivarfs_create,
 };
-- 
1.7.11.7
