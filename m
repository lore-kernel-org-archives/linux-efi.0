From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC PATCH v1] efivarfs: define integrity_read method
Date: Thu, 06 Jul 2017 14:10:33 -0400
Message-ID: <1499364633.3130.11.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, linux-security-module <linux-security-module@vger.kernel.org>, linux-efi <linux-efi@vger.kernel.org>, linux-ima-user <linux-ima-user@lists.sourceforge.net>
List-Id: linux-efi@vger.kernel.org

This patch defines simple_read_iter_from_buffer(), replaces the
existing efivarfs ->read method with ->read_iter method, and defines
an ->integrity_read file operation method to read data for integrity
hash collection.

(Posting separately for review, before being squashed with the others.)

Changelog v1:
- totally re-written based on Al's comments, containing source code.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 fs/efivarfs/file.c | 12 +++++++-----
 fs/libfs.c         | 32 ++++++++++++++++++++++++++++++++
 include/linux/fs.h |  2 ++
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index 5f22e74bbade..17955a92a5b3 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -64,9 +64,10 @@ static ssize_t efivarfs_file_write(struct file *file,
 	return bytes;
 }
 
-static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
-		size_t count, loff_t *ppos)
+static ssize_t efivarfs_file_read_iter(struct kiocb *iocb,
+				       struct iov_iter *iter)
 {
+	struct file *file = iocb->ki_filp;
 	struct efivar_entry *var = file->private_data;
 	unsigned long datasize = 0;
 	u32 attributes;
@@ -96,8 +97,8 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 		goto out_free;
 
 	memcpy(data, &attributes, sizeof(attributes));
-	size = simple_read_from_buffer(userbuf, count, ppos,
-				       data, datasize + sizeof(attributes));
+	size = simple_read_iter_from_buffer(iocb, iter, data,
+					    datasize + sizeof(attributes));
 out_free:
 	kfree(data);
 
@@ -174,8 +175,9 @@ efivarfs_file_ioctl(struct file *file, unsigned int cmd, unsigned long p)
 
 const struct file_operations efivarfs_file_operations = {
 	.open	= simple_open,
-	.read	= efivarfs_file_read,
+	.read_iter = efivarfs_file_read_iter,
 	.write	= efivarfs_file_write,
 	.llseek	= no_llseek,
 	.unlocked_ioctl = efivarfs_file_ioctl,
+	.integrity_read	= efivarfs_file_read_iter,
 };
diff --git a/fs/libfs.c b/fs/libfs.c
index a04395334bb1..e1b4f8695013 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -16,6 +16,7 @@
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h> /* sync_mapping_buffers */
+#include <linux/uio.h>
 
 #include <linux/uaccess.h>
 
@@ -676,6 +677,37 @@ ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 EXPORT_SYMBOL(simple_write_to_buffer);
 
 /**
+ * simple_read_iter_from_buffer - copy data from the buffer to user space
+ * @iocb: struct containing the file, the current position and other info
+ * @to: the user space buffer to read to
+ * @from: the buffer to read from
+ * @available: the size of the buffer
+ *
+ * The simple_read_iter_from_buffer() function reads up to @available bytes
+ * from the current buffer into the user space buffer.
+ *
+ * On success, the current buffer offset is advanced by the number of bytes
+ * read, or a negative value is returned on error.
+ **/
+ssize_t simple_read_iter_from_buffer(struct kiocb *iocb, struct iov_iter *to,
+                                const void *from, size_t available)
+{
+	loff_t pos = iocb->ki_pos;
+	size_t ret;
+
+	if (pos < 0)
+		return -EINVAL;
+	if (pos >= available)
+		return 0;
+	ret = copy_to_iter(from + pos, available - pos, to);
+	if (!ret && iov_iter_count(to))
+		return -EFAULT;
+	iocb->ki_pos = pos + ret;
+	return ret;
+}
+EXPORT_SYMBOL(simple_read_iter_from_buffer);
+
+/**
  * memory_read_from_buffer - copy data from the buffer
  * @to: the kernel space buffer to read to
  * @count: the maximum number of bytes to read
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 36edfe84c4bf..d85d2c43afd9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3012,6 +3012,8 @@ extern void simple_release_fs(struct vfsmount **mount, int *count);
 
 extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
+extern ssize_t simple_read_iter_from_buffer(struct kiocb *iocb,
+		struct iov_iter *to, const void *from, size_t available);
 extern ssize_t simple_write_to_buffer(void *to, size_t available, loff_t *ppos,
 		const void __user *from, size_t count);
 
-- 
2.7.4
