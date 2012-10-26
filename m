From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 13/20] efivarfs: efivarfs_fill_super() ensure we clean up correctly on error
Date: Fri, 26 Oct 2012 08:51:56 +0100
Message-ID: <1351237923-10313-14-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Ensure we free both the name and inode on error when building the
individual variables.

Signed-off-by: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index dcb34ae..2d67781 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -948,6 +948,7 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct dentry *root;
 	struct efivar_entry *entry, *n;
 	struct efivars *efivars = &__efivars;
+	char *name;
 
 	efivarfs_sb = sb;
 
@@ -969,16 +970,18 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 		return -ENOMEM;
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
-		struct inode *inode;
 		struct dentry *dentry, *root = efivarfs_sb->s_root;
-		char *name;
 		unsigned long size = 0;
 		int len, i;
 
+		inode = NULL;
+
 		len = utf16_strlen(entry->var.VariableName);
 
 		/* GUID plus trailing NULL */
 		name = kmalloc(len + 38, GFP_ATOMIC);
+		if (!name)
+			goto fail;
 
 		for (i = 0; i < len; i++)
 			name[i] = entry->var.VariableName[i] & 0xFF;
@@ -991,7 +994,13 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 		inode = efivarfs_get_inode(efivarfs_sb, root->d_inode,
 					  S_IFREG | 0644, 0);
+		if (!inode)
+			goto fail_name;
+
 		dentry = d_alloc_name(root, name);
+		if (!dentry)
+			goto fail_inode;
+
 		/* copied by the above to local storage in the dentry. */
 		kfree(name);
 
@@ -1009,6 +1018,13 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	return 0;
+
+fail_inode:
+	iput(inode);
+fail_name:
+	kfree(name);
+fail:
+	return -ENOMEM;
 }
 
 static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
-- 
1.7.11.7
