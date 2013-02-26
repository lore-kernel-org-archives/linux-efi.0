From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] efivarfs: convert to use simple_open()
Date: Tue, 26 Feb 2013 10:19:59 +0800
Message-ID: <CAPgLHd_96Jv0zNKX1rcvfCWPG=2u0R+b57aC6yXGJvoPbAaVuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

This removes an open coded simple_open() function and
replaces file operations references to the function
with simple_open() instead.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/firmware/efivars.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ef5070d..7c3477e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -647,12 +647,6 @@ efivar_unregister(struct efivar_entry *var)
 	kobject_put(&var->kobj);
 }
 
-static int efivarfs_file_open(struct inode *inode, struct file *file)
-{
-	file->private_data = inode->i_private;
-	return 0;
-}
-
 static int efi_status_to_err(efi_status_t status)
 {
 	int err;
@@ -870,7 +864,7 @@ static struct super_block *efivarfs_sb;
 static const struct inode_operations efivarfs_dir_inode_operations;
 
 static const struct file_operations efivarfs_file_operations = {
-	.open	= efivarfs_file_open,
+	.open	= simple_open,
 	.read	= efivarfs_file_read,
 	.write	= efivarfs_file_write,
 	.llseek	= no_llseek,
