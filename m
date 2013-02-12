From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 2/2 v2] efivarfs: guid part of filenames are case-insensitive
Date: Tue, 12 Feb 2013 12:39:34 +0000
Message-ID: <20130212123934.GC14790@console-pimps.org>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-3-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360592935-26026-3-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

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

v2: Use Al's non-eye-watering code for calculating the hash. Optimise
    efivarfs_d_compare() slightly by firstly checking whether the
    string lens match, this also avoids a possible out-of-bounds
    condition when performing the memcmp().

 drivers/firmware/efivars.c | 95 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 868cea5..5d055dc 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1043,6 +1043,84 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
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
+	int guid = len - GUID_LEN;
+
+	if (name->len != len)
+		return 1;
+
+	/* Case-sensitive compare for the variable name */
+	if (memcmp(str, name->name, guid))
+		return 1;
+
+	/* Case-insensitive compare for the GUID */
+	return strcasecmp(name->name + guid, str + guid);
+}
+
+static int efivarfs_d_hash(const struct dentry *dentry,
+			   const struct inode *inode, struct qstr *qstr)
+{
+	unsigned long hash = init_name_hash();
+	const unsigned char *s = qstr->name;
+	unsigned int len = qstr->len;
+
+	if (!efivarfs_valid_name(s, len))
+		return -EINVAL;
+
+	while (len-- > GUID_LEN)
+		hash = partial_name_hash(*s++, hash);
+
+	/* GUID is case-insensitive. */
+	while (len--)
+		hash = partial_name_hash(tolower(*s++), hash);
+
+	qstr->hash = end_name_hash(hash);
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
+static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
+{
+	struct qstr q;
+
+	q.name = name;
+	q.len = strlen(name);
+
+	if (efivarfs_d_hash(NULL, NULL, &q))
+		return NULL;
+
+	return d_alloc(parent, &q);
+}
+
 static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode = NULL;
@@ -1058,6 +1136,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_blocksize_bits    = PAGE_CACHE_SHIFT;
 	sb->s_magic             = EFIVARFS_MAGIC;
 	sb->s_op                = &efivarfs_ops;
+	sb->s_d_op		= &efivarfs_d_ops;
 	sb->s_time_gran         = 1;
 
 	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
@@ -1098,7 +1177,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 		if (!inode)
 			goto fail_name;
 
-		dentry = d_alloc_name(root, name);
+		dentry = efivarfs_alloc_dentry(root, name);
 		if (!dentry)
 			goto fail_inode;
 
@@ -1148,8 +1227,20 @@ static struct file_system_type efivarfs_type = {
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
