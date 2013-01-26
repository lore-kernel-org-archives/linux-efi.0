From: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efivarfs: drop_nlink on the correct inode in efivarfs_unlink
Date: Sun, 27 Jan 2013 06:49:09 +0800
Message-ID: <1359240549.15160.60199223209.1.gpush@pororo>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Currently, we're calling drop_nlink on the directory, not the file
inode.

Signed-off-by: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>

---
 drivers/firmware/efivars.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 3d21852..053f28b 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -996,7 +996,7 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 		list_del(&var->list);
 		spin_unlock(&efivars->lock);
 		efivar_unregister(var);
-		drop_nlink(dir);
+		drop_nlink(dentry->d_inode);
 		dput(dentry);
 		return 0;
 	}
