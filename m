From: Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
Subject: [PATCH] efivarfs: Eliminate dead code in efivarfs_create()
Date: Tue, 23 Feb 2016 17:07:10 +0100
Message-ID: <1456243630-24834-1-git-send-email-tklauser@distanz.ch>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

After commit ed8b0de5a33d ("efi: Make efivarfs entries immutable by
default"), inode will always be NULL in the error check before iput(),
thus remove the check and the call to iput() alltogether. Also directly
fold the error handling code into the only place it is needed, which
makes the code a bit smaller.

Found by the Coverity scanner (CID 1353443).

Signed-off-by: Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
---
 fs/efivarfs/inode.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index e2ab6d0497f2..43321c9cd71b 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -106,7 +106,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 {
 	struct inode *inode = NULL;
 	struct efivar_entry *var;
-	int namelen, i = 0, err = 0;
+	int namelen, i = 0;
 	bool is_removable = false;
 
 	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
@@ -128,8 +128,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 
 	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0, is_removable);
 	if (!inode) {
-		err = -ENOMEM;
-		goto out;
+		kfree(var);
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < namelen; i++)
@@ -142,13 +142,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	efivar_entry_add(var, &efivarfs_list);
 	d_instantiate(dentry, inode);
 	dget(dentry);
-out:
-	if (err) {
-		kfree(var);
-		if (inode)
-			iput(inode);
-	}
-	return err;
+
+	return 0;
 }
 
 static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
-- 
2.7.0.297.g563e384
