From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC PATCH] efivarfs: define integrity_read method
Date: Thu, 06 Jul 2017 08:14:01 -0400
Message-ID: <1499343241.5500.15.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, linux-security-module <linux-security-module@vger.kernel.org>, linux-ima-user <linux-ima-user@lists.sourceforge.net>, linux-efi <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

This patch defines an ->integrity_read file operation method to read data for
integrity hash collection.

(Posting separately for review, before being squashed with the others.) 

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 fs/efivarfs/file.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index 5f22e74bbade..b687c982e0a1 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -10,6 +10,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/uio.h>
 #include <linux/mount.h>
 
 #include "internal.h"
@@ -64,8 +65,9 @@ static ssize_t efivarfs_file_write(struct file *file,
 	return bytes;
 }
 
-static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
-		size_t count, loff_t *ppos)
+static ssize_t __efivarfs_file_read(struct file *file, char __user *userbuf,
+				    size_t count, loff_t *ppos,
+				    struct iov_iter *iter)
 {
 	struct efivar_entry *var = file->private_data;
 	unsigned long datasize = 0;
@@ -96,14 +98,32 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 		goto out_free;
 
 	memcpy(data, &attributes, sizeof(attributes));
-	size = simple_read_from_buffer(userbuf, count, ppos,
-				       data, datasize + sizeof(attributes));
+
+	if (!iter)
+		size = simple_read_from_buffer(userbuf, count, ppos, data,
+					       datasize + sizeof(attributes));
+	else
+		size = copy_to_iter(data, datasize + sizeof(attributes), iter);
 out_free:
 	kfree(data);
 
 	return size;
 }
 
+static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
+				  size_t count, loff_t *ppos)
+{
+	return __efivarfs_file_read(file, userbuf, count, ppos, NULL);
+}
+
+static ssize_t efivarfs_file_read_iter(struct kiocb *iocb,
+				       struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+
+	return __efivarfs_file_read(file, NULL, 0, NULL, iter);
+}
+
 static int
 efivarfs_ioc_getxflags(struct file *file, void __user *arg)
 {
@@ -178,4 +198,5 @@ const struct file_operations efivarfs_file_operations = {
 	.write	= efivarfs_file_write,
 	.llseek	= no_llseek,
 	.unlocked_ioctl = efivarfs_file_ioctl,
+	.integrity_read	= efivarfs_file_read_iter,
 };
-- 
2.7.4
