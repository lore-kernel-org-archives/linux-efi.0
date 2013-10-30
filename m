From: "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH v2] efivarfs: 'efivarfs_file_write' function reorganization
Date: Wed, 30 Oct 2013 15:57:41 -0300
Message-ID: <1383159461-29668-1-git-send-email-geyslan@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-br@googlegroups.com
Cc: "Geyslan G. Bem" <geyslan@gmail.com>, Matthew Garrett <matthew.garrett@nebula.com>, Jeremy Kerr <jk@ozlabs.org>, Matt Fleming <matt.fleming@intel.com>, "open list:EFI VARIABLE FILE..." <linux-efi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

This reorganization:

Removes useless 'bytes' prior assignment.

Uses 'memdup_user' instead 'kmalloc' + 'copy_from_user'.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/efivarfs/file.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index 8dd524f..cdb2971 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -21,7 +21,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	u32 attributes;
 	struct inode *inode = file->f_mapping->host;
 	unsigned long datasize = count - sizeof(attributes);
-	ssize_t bytes = 0;
+	ssize_t bytes;
 	bool set = false;
 
 	if (count < sizeof(attributes))
@@ -33,14 +33,9 @@ static ssize_t efivarfs_file_write(struct file *file,
 	if (attributes & ~(EFI_VARIABLE_MASK))
 		return -EINVAL;
 
-	data = kmalloc(datasize, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
-		bytes = -EFAULT;
-		goto out;
-	}
+	data = memdup_user(userbuf + sizeof(attributes), datasize);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
 	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
 					  data, &set);
-- 
1.8.4
