From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efivarfs: Never return ENOENT from firmware again
Date: Fri, 10 May 2013 18:29:21 +0800
Message-ID: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Previously in 1fa7e69 efi_status_to_err() translated firmware status
EFI_NOT_FOUND to -EIO instead of -ENOENT for efivarfs operations to
avoid confusion. After refactoring in e14ab23, it is also used in other
places where the translation may be unnecessary.

So move the translation to efivarfs specific code. Also return EOF
for reading zero-length files, which is what users would expect.

Cc: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
This is to be applied against mainline or Matt Fleming's chainsaw branch.

 fs/efivarfs/file.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index bfb5315..8dd524f 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -44,8 +44,11 @@ static ssize_t efivarfs_file_write(struct file *file,
 
 	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
 					  data, &set);
-	if (!set && bytes)
+	if (!set && bytes) {
+		if (bytes == -ENOENT)
+			bytes = -EIO;
 		goto out;
+	}
 
 	if (bytes == -ENOENT) {
 		drop_nlink(inode);
@@ -76,7 +79,14 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	int err;
 
 	err = efivar_entry_size(var, &datasize);
-	if (err)
+
+	/*
+	 * efivarfs represents uncommitted variables with
+	 * zero-length files. Reading them should return EOF.
+	 */
+	if (err == -ENOENT)
+		return 0;
+	else if (err)
 		return err;
 
 	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
-- 
1.7.11.7
