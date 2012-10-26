From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 11/20] efivarfs: efivarfs_fill_super() fix inode reference counts
Date: Fri, 26 Oct 2012 08:51:54 +0100
Message-ID: <1351237923-10313-12-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

When d_make_root() fails it will automatically drop the reference
on the root inode.  We should not be doing so as well.

Signed-off-by: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 0bbf742..79f3e4e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -948,7 +948,6 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct dentry *root;
 	struct efivar_entry *entry, *n;
 	struct efivars *efivars = &__efivars;
-	int err;
 
 	efivarfs_sb = sb;
 
@@ -960,18 +959,14 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran         = 1;
 
 	inode = efivarfs_get_inode(sb, NULL, S_IFDIR | 0755, 0);
-	if (!inode) {
-		err = -ENOMEM;
-		goto fail;
-	}
+	if (!inode)
+		return -ENOMEM;
 	inode->i_op = &efivarfs_dir_inode_operations;
 
 	root = d_make_root(inode);
 	sb->s_root = root;
-	if (!root) {
-		err = -ENOMEM;
-		goto fail;
-	}
+	if (!root)
+		return -ENOMEM;
 
 	list_for_each_entry_safe(entry, n, &efivars->list, list) {
 		struct inode *inode;
@@ -1012,9 +1007,6 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	return 0;
-fail:
-	iput(inode);
-	return err;
 }
 
 static struct dentry *efivarfs_mount(struct file_system_type *fs_type,
-- 
1.7.11.7
