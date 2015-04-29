From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: [RFC 2/3] firmware_class: split out transaction helpers
Date: Wed, 29 Apr 2015 16:10:52 -0700
Message-ID: <1430349052.2189.41.camel@HansenPartnership.com>
References: <1430348859.2189.37.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430348859.2189.37.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>

The firmware class contains code to manage an arbitrary sized buffer for
discrete read and write operations.  We need precisely this ability to update
firmware capsule files (and likely for other transactions as well), so split
out the capability into a library helper

Signed-off-by: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
---
 drivers/base/firmware_class.c      | 117 ++++---------------------------
 include/linux/transaction_helper.h |  26 +++++++
 lib/Makefile                       |   2 +-
 lib/transaction_helper.c           | 137 +++++++++++++++++++++++++++++++++++++
 4 files changed, 179 insertions(+), 103 deletions(-)
 create mode 100644 include/linux/transaction_helper.h
 create mode 100644 lib/transaction_helper.c

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 171841a..7d4c9d0 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -29,6 +29,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/reboot.h>
 #include <linux/security.h>
+#include <linux/transaction_helper.h>
 
 #include <generated/utsrelease.h>
 
@@ -144,10 +145,8 @@ struct firmware_buf {
 	size_t size;
 #ifdef CONFIG_FW_LOADER_USER_HELPER
 	bool is_paged_buf;
+	struct transaction_buf *tb;
 	bool need_uevent;
-	struct page **pages;
-	int nr_pages;
-	int page_array_size;
 	struct list_head pending_list;
 #endif
 	char fw_id[];
@@ -248,13 +247,9 @@ static void __fw_free_buf(struct kref *ref)
 	spin_unlock(&fwc->lock);
 
 #ifdef CONFIG_FW_LOADER_USER_HELPER
-	if (buf->is_paged_buf) {
-		int i;
-		vunmap(buf->data);
-		for (i = 0; i < buf->nr_pages; i++)
-			__free_page(buf->pages[i]);
-		kfree(buf->pages);
-	} else
+	if (buf->is_paged_buf)
+		transaction_free(buf->tb);
+	else
 #endif
 		vfree(buf->data);
 	kfree(buf);
@@ -374,7 +369,7 @@ static void fw_set_page_data(struct firmware_buf *buf, struct firmware *fw)
 {
 	fw->priv = buf;
 #ifdef CONFIG_FW_LOADER_USER_HELPER
-	fw->pages = buf->pages;
+	fw->pages = buf->tb->pages;
 #endif
 	fw->size = buf->size;
 	fw->data = buf->data;
@@ -591,7 +586,7 @@ static int fw_map_pages_buf(struct firmware_buf *buf)
 		return 0;
 
 	vunmap(buf->data);
-	buf->data = vmap(buf->pages, buf->nr_pages, 0, PAGE_KERNEL_RO);
+	buf->data = transaction_map(buf->tb, PAGE_KERNEL_RO);
 	if (!buf->data)
 		return -ENOMEM;
 	return 0;
@@ -618,7 +613,6 @@ static ssize_t firmware_loading_store(struct device *dev,
 	struct firmware_buf *fw_buf;
 	ssize_t written = count;
 	int loading = simple_strtol(buf, NULL, 10);
-	int i;
 
 	mutex_lock(&fw_lock);
 	fw_buf = fw_priv->buf;
@@ -629,12 +623,8 @@ static ssize_t firmware_loading_store(struct device *dev,
 	case 1:
 		/* discarding any previous partial load */
 		if (!test_bit(FW_STATUS_DONE, &fw_buf->status)) {
-			for (i = 0; i < fw_buf->nr_pages; i++)
-				__free_page(fw_buf->pages[i]);
-			kfree(fw_buf->pages);
-			fw_buf->pages = NULL;
-			fw_buf->page_array_size = 0;
-			fw_buf->nr_pages = 0;
+			transaction_free(fw_buf->tb);
+			transaction_init(fw_buf->tb);
 			set_bit(FW_STATUS_LOADING, &fw_buf->status);
 		}
 		break;
@@ -701,74 +691,14 @@ static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
 		ret_count = -ENODEV;
 		goto out;
 	}
-	if (offset > buf->size) {
-		ret_count = 0;
-		goto out;
-	}
-	if (count > buf->size - offset)
-		count = buf->size - offset;
-
-	ret_count = count;
-
-	while (count) {
-		void *page_data;
-		int page_nr = offset >> PAGE_SHIFT;
-		int page_ofs = offset & (PAGE_SIZE-1);
-		int page_cnt = min_t(size_t, PAGE_SIZE - page_ofs, count);
-
-		page_data = kmap(buf->pages[page_nr]);
-
-		memcpy(buffer, page_data + page_ofs, page_cnt);
 
-		kunmap(buf->pages[page_nr]);
-		buffer += page_cnt;
-		offset += page_cnt;
-		count -= page_cnt;
-	}
+	ret_count = transaction_read(buf->tb, buffer, offset, count);
+	
 out:
 	mutex_unlock(&fw_lock);
 	return ret_count;
 }
 
-static int fw_realloc_buffer(struct firmware_priv *fw_priv, int min_size)
-{
-	struct firmware_buf *buf = fw_priv->buf;
-	int pages_needed = PAGE_ALIGN(min_size) >> PAGE_SHIFT;
-
-	/* If the array of pages is too small, grow it... */
-	if (buf->page_array_size < pages_needed) {
-		int new_array_size = max(pages_needed,
-					 buf->page_array_size * 2);
-		struct page **new_pages;
-
-		new_pages = kmalloc(new_array_size * sizeof(void *),
-				    GFP_KERNEL);
-		if (!new_pages) {
-			fw_load_abort(fw_priv);
-			return -ENOMEM;
-		}
-		memcpy(new_pages, buf->pages,
-		       buf->page_array_size * sizeof(void *));
-		memset(&new_pages[buf->page_array_size], 0, sizeof(void *) *
-		       (new_array_size - buf->page_array_size));
-		kfree(buf->pages);
-		buf->pages = new_pages;
-		buf->page_array_size = new_array_size;
-	}
-
-	while (buf->nr_pages < pages_needed) {
-		buf->pages[buf->nr_pages] =
-			alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
-
-		if (!buf->pages[buf->nr_pages]) {
-			fw_load_abort(fw_priv);
-			return -ENOMEM;
-		}
-		buf->nr_pages++;
-	}
-	return 0;
-}
-
 /**
  * firmware_data_write - write method for firmware
  * @filp: open sysfs file
@@ -800,29 +730,12 @@ static ssize_t firmware_data_write(struct file *filp, struct kobject *kobj,
 		goto out;
 	}
 
-	retval = fw_realloc_buffer(fw_priv, offset + count);
-	if (retval)
-		goto out;
-
-	retval = count;
-
-	while (count) {
-		void *page_data;
-		int page_nr = offset >> PAGE_SHIFT;
-		int page_ofs = offset & (PAGE_SIZE - 1);
-		int page_cnt = min_t(size_t, PAGE_SIZE - page_ofs, count);
-
-		page_data = kmap(buf->pages[page_nr]);
-
-		memcpy(page_data + page_ofs, buffer, page_cnt);
+	retval = transaction_write(buf->tb, buffer, offset, count);
+	if (retval < 0)
+		fw_load_abort(fw_priv);
 
-		kunmap(buf->pages[page_nr]);
-		buffer += page_cnt;
-		offset += page_cnt;
-		count -= page_cnt;
-	}
+	buf->size = buf->tb->size;
 
-	buf->size = max_t(size_t, offset, buf->size);
 out:
 	mutex_unlock(&fw_lock);
 	return retval;
diff --git a/include/linux/transaction_helper.h b/include/linux/transaction_helper.h
new file mode 100644
index 0000000..009181b
--- /dev/null
+++ b/include/linux/transaction_helper.h
@@ -0,0 +1,26 @@
+/*
+ * transaction_helper.h - headers and defines for lib/transaction_helper.c
+ */
+
+#ifndef _TRANSACTION_HELPER_H_
+#define _TRANSACTION_HELPER_H_
+
+#include <linux/vmalloc.h>	/* pgprot_t */
+
+struct transaction_buf {
+	void *vaddr;
+	size_t size;
+	struct page **pages;
+	int nr_pages;
+	int page_array_size;
+};
+
+void transaction_free(struct transaction_buf *buf);
+void *transaction_map(struct transaction_buf *buf, pgprot_t prot);
+void transaction_init(struct transaction_buf *buf);
+ssize_t transaction_write(struct transaction_buf *buf, char *data,
+			  loff_t offset, size_t count);
+ssize_t transaction_read(struct transaction_buf *buf, char *data, loff_t offset,
+			 size_t count);
+
+#endif /* _TRANSACTION_HELPER_H_ */
diff --git a/lib/Makefile b/lib/Makefile
index 6c37933..fac1534 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o argv_split.o \
 	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o seq_buf.o
+	 earlycpio.o seq_buf.o transaction_helper.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff --git a/lib/transaction_helper.c b/lib/transaction_helper.c
new file mode 100644
index 0000000..2407512
--- /dev/null
+++ b/lib/transaction_helper.c
@@ -0,0 +1,137 @@
+/*
+ * transaction_helper.c - helper functions for sysfs binary file transaction
+ *
+ * Most of this file is split out of firmware_class.c
+ */
+
+#include <linux/highmem.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/transaction_helper.h>
+
+void transaction_free(struct transaction_buf *buf)
+{
+	int i;
+
+	if (buf->vaddr)
+		vunmap(buf->vaddr);
+	for (i = 0; i < buf->nr_pages; i++)
+		__free_page(buf->pages[i]);
+	kfree(buf->pages);
+}
+
+void *transaction_map(struct transaction_buf *buf, pgprot_t prot)
+{
+	if (buf->vaddr)
+		vunmap(buf->vaddr);
+	buf->vaddr = vmap(buf->pages, buf->nr_pages, 0, prot);
+
+	return buf->vaddr;
+}
+
+void transaction_init(struct transaction_buf *buf)
+{
+	memset(buf, 0, sizeof(*buf));
+}
+
+static int transaction_realloc_buffer(struct transaction_buf *buf, int min_size)
+{
+	int pages_needed = PAGE_ALIGN(min_size) >> PAGE_SHIFT;
+
+	/* If the array of pages is too small, grow it... */
+	if (buf->page_array_size < pages_needed) {
+		int new_array_size = max(pages_needed,
+					 buf->page_array_size * 2);
+		struct page **new_pages;
+
+		new_pages = kmalloc(new_array_size * sizeof(void *),
+				    GFP_KERNEL);
+		if (!new_pages) {
+			return -ENOMEM;
+		}
+		memcpy(new_pages, buf->pages,
+		       buf->page_array_size * sizeof(void *));
+		memset(&new_pages[buf->page_array_size], 0, sizeof(void *) *
+		       (new_array_size - buf->page_array_size));
+		kfree(buf->pages);
+		buf->pages = new_pages;
+		buf->page_array_size = new_array_size;
+	}
+
+	while (buf->nr_pages < pages_needed) {
+		buf->pages[buf->nr_pages] =
+			alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+
+		if (!buf->pages[buf->nr_pages])
+			return -ENOMEM;
+
+		buf->nr_pages++;
+	}
+	return 0;
+}
+
+ssize_t transaction_write(struct transaction_buf *buf, char *data,
+			  loff_t offset, size_t count)
+{
+	int retval;
+
+	retval = transaction_realloc_buffer(buf, offset + count);
+	if (retval)
+		return retval;
+
+	retval = count;
+
+	while (count) {
+		void *page_data;
+		int page_nr = offset >> PAGE_SHIFT;
+		int page_ofs = offset & (PAGE_SIZE - 1);
+		int page_cnt = min_t(size_t, PAGE_SIZE - page_ofs, count);
+
+		page_data = kmap(buf->pages[page_nr]);
+
+		memcpy(page_data + page_ofs, data, page_cnt);
+
+		kunmap(buf->pages[page_nr]);
+		data += page_cnt;
+		offset += page_cnt;
+		count -= page_cnt;
+	}
+
+	buf->size = max_t(size_t, offset, buf->size);
+
+	return retval;
+}
+
+ssize_t transaction_read(struct transaction_buf *buf, char *data, loff_t offset,
+			 size_t count)
+{
+	int retval = 0;
+
+	if (offset > buf->size)
+		goto out;
+
+	if (count > buf->size - offset)
+		count = buf->size - offset;
+
+	retval = count;
+
+	while (count) {
+		void *page_data;
+		int page_nr = offset >> PAGE_SHIFT;
+		int page_ofs = offset & (PAGE_SIZE-1);
+		int page_cnt = min_t(size_t, PAGE_SIZE - page_ofs, count);
+
+		page_data = kmap(buf->pages[page_nr]);
+
+		memcpy(data, page_data + page_ofs, page_cnt);
+
+		kunmap(buf->pages[page_nr]);
+		data += page_cnt;
+		offset += page_cnt;
+		count -= page_cnt;
+	}
+
+ out:
+	return retval;
+}
-- 
2.1.4
