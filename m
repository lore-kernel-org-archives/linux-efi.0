From: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [PATCH] efivarfs: allow unloading when build as module
Date: Thu, 23 Oct 2014 23:20:37 +0200
Message-ID: <1414099237-19081-1-git-send-email-minipli@googlemail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There is no need to keep the module loaded when it serves no function in
case the EFI runtime services are disabled. Return an error in this case
so loading the module will fail.

Also supply a module_exit function to allow unloading the module.

Last, but not least, set the owner of the file_system_type struct.

Cc: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
 fs/efivarfs/super.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 0a48886e069c..6dad1176ec52 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -236,6 +236,7 @@ static void efivarfs_kill_sb(struct super_block *sb)
 }
 
 static struct file_system_type efivarfs_type = {
+	.owner   = THIS_MODULE,
 	.name    = "efivarfs",
 	.mount   = efivarfs_mount,
 	.kill_sb = efivarfs_kill_sb,
@@ -244,17 +245,23 @@ static struct file_system_type efivarfs_type = {
 static __init int efivarfs_init(void)
 {
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
-		return 0;
+		return -ENODEV;
 
 	if (!efivars_kobject())
-		return 0;
+		return -ENODEV;
 
 	return register_filesystem(&efivarfs_type);
 }
 
+static __exit void efivarfs_exit(void)
+{
+	unregister_filesystem(&efivarfs_type);
+}
+
 MODULE_AUTHOR("Matthew Garrett, Jeremy Kerr");
 MODULE_DESCRIPTION("EFI Variable Filesystem");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_FS("efivarfs");
 
 module_init(efivarfs_init);
+module_exit(efivarfs_exit);
-- 
1.7.10.4
