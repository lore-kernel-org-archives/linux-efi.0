From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: [PATCH v8 2/2] efi: a misc char interface for user to update efi firmware
Date: Thu,  8 Oct 2015 03:13:53 +0800
Message-ID: <1444245233-19229-3-git-send-email-hock.leong.kweh@intel.com>
References: <1444245233-19229-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444245233-19229-1-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Fleming Matt <matt.fleming@intel.com>, h.peter.anvin@intel.com
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

Introducing a kernel module to expose capsule loader interface
(misc char device file note) for user to upload capsule binaries.

Example method to load the capsule binary:
cat firmware.bin > /dev/efi_capsule_loader

Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
---
 drivers/firmware/efi/Kconfig              |   10 +
 drivers/firmware/efi/Makefile             |    1 +
 drivers/firmware/efi/efi-capsule-loader.c |  356 +++++++++++++++++++++++++++++
 3 files changed, 367 insertions(+)
 create mode 100644 drivers/firmware/efi/efi-capsule-loader.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index f712d47..0be8ee3 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -60,6 +60,16 @@ config EFI_RUNTIME_WRAPPERS
 config EFI_ARMSTUB
 	bool
 
+config EFI_CAPSULE_LOADER
+	tristate "EFI capsule loader"
+	depends on EFI
+	help
+	  This option exposes a loader interface "/dev/efi_capsule_loader" for
+	  user to load EFI capsule binary and update the EFI firmware through
+	  system reboot.
+
+	  If unsure, say N.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 698846e..5ab031a 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
 obj-$(CONFIG_EFI_STUB)			+= libstub/
+obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= efi-capsule-loader.o
diff --git a/drivers/firmware/efi/efi-capsule-loader.c b/drivers/firmware/efi/efi-capsule-loader.c
new file mode 100644
index 0000000..b415b4e
--- /dev/null
+++ b/drivers/firmware/efi/efi-capsule-loader.c
@@ -0,0 +1,356 @@
+/*
+ * EFI capsule loader driver.
+ *
+ * Copyright 2015 Intel Corporation
+ *
+ * This file is part of the Linux kernel, and is made available under
+ * the terms of the GNU General Public License version 2.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/highmem.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/efi.h>
+
+#define DEV_NAME "efi_capsule_loader"
+#define UPLOAD_DONE -1
+#define ERR_OCCURED -2
+
+struct capsule_info {
+	char		header_obtained;
+	int		reset_type;
+	long		index;
+	unsigned long	count;
+	unsigned long	total_size;
+	struct page	**pages;
+	unsigned long	page_count_remain;
+};
+
+static DEFINE_MUTEX(capsule_loader_lock);
+
+/**
+ * efi_free_all_buff_pages - free the current & all previous allocated buffer
+ *			     pages
+ * @file: file pointer
+ * @kbuff: a mapped buffer pointer
+ * @kbuff_page: the current execution allocated buffer page's pointer which has
+ *		not yet assigned to pages[] array
+ *
+ *	The input param can be NULL if the current execution has not allocated
+ *	any buffer page.
+ **/
+static void efi_free_all_buff_pages(struct file *file, void *kbuff,
+				    struct page *kbuff_page)
+{
+	struct capsule_info *cap_info = file->private_data;
+
+	if (kbuff)
+		kunmap(kbuff_page);
+
+	if (kbuff_page)
+		__free_page(kbuff_page);
+
+	while (cap_info->index > 0)
+		__free_page(cap_info->pages[--cap_info->index]);
+
+	kfree(cap_info->pages);
+
+	/* indicate to the next that error had occurred */
+	cap_info->index = ERR_OCCURED;
+}
+
+/**
+ * efi_capsule_setup_info - to obtain the efi capsule header in the binary and
+ *			    setup capsule_info structure
+ * @file: file pointer
+ * @kbuff: a mapped 1st page buffer pointer
+ **/
+static ssize_t efi_capsule_setup_info(struct file *file, void *kbuff)
+{
+	int ret = 0;
+	struct capsule_info *cap_info = file->private_data;
+	void *temp_page;
+	/* reset back to the correct offset of header */
+	efi_capsule_header_t *cap_hdr = kbuff - cap_info->count;
+	size_t pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >>
+				    PAGE_SHIFT;
+
+	if (pages_needed == 0) {
+		pr_err("%s: pages count invalid\n", __func__);
+		return -EINVAL;
+	}
+
+	/* check if the capsule binary supported */
+	mutex_lock(&capsule_loader_lock);
+	ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
+				    cap_hdr->imagesize, &cap_info->reset_type);
+	mutex_unlock(&capsule_loader_lock);
+	if (ret) {
+		pr_err("%s: efi_capsule_supported() failed\n", __func__);
+		return ret;
+	}
+
+	cap_info->total_size = cap_hdr->imagesize;
+	temp_page = krealloc(cap_info->pages, pages_needed * sizeof(void *),
+			     GFP_KERNEL | __GFP_ZERO);
+	if (!temp_page) {
+		pr_debug("%s: krealloc() failed\n", __func__);
+		return -ENOMEM;
+	}
+
+	cap_info->pages = temp_page;
+	cap_info->header_obtained = 1;
+	return ret;
+}
+
+/**
+ * efi_capsule_submit_update - invoke the efi_capsule_update API once binary
+ *			       upload done
+ * @file: file pointer
+ **/
+static ssize_t efi_capsule_submit_update(struct file *file)
+{
+	int ret = 0;
+	struct capsule_info *cap_info = file->private_data;
+	void *cap_hdr_temp;
+
+	cap_hdr_temp = kmap(cap_info->pages[0]);
+	if (!cap_hdr_temp) {
+		pr_debug("%s: kmap() failed\n", __func__);
+		return -EFAULT;
+	}
+
+	mutex_lock(&capsule_loader_lock);
+	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
+	mutex_unlock(&capsule_loader_lock);
+	kunmap(cap_info->pages[0]);
+	if (ret) {
+		pr_err("%s: efi_capsule_update() failed\n", __func__);
+		return ret;
+	}
+
+	/* indicate capsule binary uploading is done */
+	cap_info->index = UPLOAD_DONE;
+	pr_info("%s: Successfully upload capsule file with reboot type '%s'\n",
+		__func__, !cap_info->reset_type ? "RESET_COLD" :
+		cap_info->reset_type == 1 ? "RESET_WARM" :
+		"RESET_SHUTDOWN");
+	return ret;
+}
+
+/**
+ * efi_capsule_write - store the capsule binary and pass it to
+ *		       efi_capsule_update() API in capsule.c
+ * @file: file pointer
+ * @buff: buffer pointer
+ * @count: number of bytes in @buff
+ * @offp: not use
+ *
+ *	Expectation:
+ *	- User space tool should start at the beginning of capsule binary and
+ *	  pass data in sequential.
+ *	- User should close and re-open this file note in order to upload more
+ *	  capsules.
+ *	- Any error occurred, user should close the file and restart the
+ *	  operation for the next try otherwise -EIO will be returned until the
+ *	  file is closed.
+ *	- EFI capsule header must be located at the beginning of capsule binary
+ *	  file and passed in as 1st block write.
+ **/
+static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
+				 size_t count, loff_t *offp)
+{
+	int ret = 0;
+	struct capsule_info *cap_info = file->private_data;
+	struct page *kbuff_page = NULL;
+	void *kbuff = NULL;
+	size_t write_byte;
+
+	if (count == 0)
+		return 0;
+
+	/* return error while error had occurred or capsule uploading is done */
+	if (cap_info->index < 0)
+		return -EIO;
+
+	/* only alloc a new page when previous page is full */
+	if (!cap_info->page_count_remain) {
+		kbuff_page = alloc_page(GFP_KERNEL);
+		if (!kbuff_page) {
+			pr_debug("%s: alloc_page() failed\n", __func__);
+			ret = -ENOMEM;
+			goto failed;
+		}
+		cap_info->page_count_remain = PAGE_SIZE;
+	} else {
+		kbuff_page = cap_info->pages[--cap_info->index];
+	}
+
+	kbuff = kmap(kbuff_page);
+	if (!kbuff) {
+		pr_debug("%s: kmap() failed\n", __func__);
+		ret = -EFAULT;
+		goto failed;
+	}
+	kbuff += PAGE_SIZE - cap_info->page_count_remain;
+
+	/* copy capsule binary data from user space to kernel space buffer */
+	write_byte = min_t(size_t, count, cap_info->page_count_remain);
+	if (copy_from_user(kbuff, buff, write_byte)) {
+		pr_debug("%s: copy_from_user() failed\n", __func__);
+		ret = -EFAULT;
+		goto failed;
+	}
+	cap_info->page_count_remain -= write_byte;
+
+	/* setup capsule binary info structure */
+	if (cap_info->header_obtained == 0 && cap_info->index == 0) {
+		/* handling 1st block is less than header size */
+		if ((cap_info->count + write_byte) <
+		    sizeof(efi_capsule_header_t)) {
+			if (!cap_info->pages)
+				cap_info->pages = kzalloc(sizeof(void *),
+							  GFP_KERNEL);
+		} else {
+			ret = efi_capsule_setup_info(file, kbuff);
+			if (ret)
+				goto failed;
+		}
+	}
+
+	cap_info->pages[cap_info->index++] = kbuff_page;
+	cap_info->count += write_byte;
+	kunmap(kbuff_page);
+	kbuff_page = NULL;
+	kbuff = NULL;
+
+	/* submit the full binary to efi_capsule_update() API */
+	if (cap_info->header_obtained &&
+	    cap_info->count >= cap_info->total_size) {
+		if (cap_info->count > cap_info->total_size) {
+			pr_err("%s: upload size exceeded header defined size\n",
+			       __func__);
+			ret = -EINVAL;
+			goto failed;
+		}
+
+		ret = efi_capsule_submit_update(file);
+		if (ret)
+			goto failed;
+	}
+
+	return write_byte;
+
+failed:
+	efi_free_all_buff_pages(file, kbuff, kbuff_page);
+	return ret;
+}
+
+/**
+ * efi_capsule_flush - called by file close or file flush
+ * @file: file pointer
+ * @id: not use
+ *
+ *	If capsule being uploaded partially, calling this function will be
+ *	treated as uploading canceled and will free up those completed buffer
+ *	pages and then return -ECANCELED.
+ **/
+static int efi_capsule_flush(struct file *file, fl_owner_t id)
+{
+	int ret = 0;
+	struct capsule_info *cap_info = file->private_data;
+
+	if (cap_info->index > 0) {
+		pr_err("%s: capsule upload not complete\n", __func__);
+		efi_free_all_buff_pages(file, NULL, NULL);
+		ret = -ECANCELED;
+	}
+
+	return ret;
+}
+
+/**
+ * efi_capsule_release - called by file close
+ * @inode: not use
+ * @file: file pointer
+ *
+ *	We would not free the successful submitted buffer pages here due to
+ *	efi update require system reboot with data maintained.
+ **/
+static int efi_capsule_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	file->private_data = NULL;
+	return 0;
+}
+
+/**
+ * efi_capsule_open - called by file open
+ * @inode: not use
+ * @file: file pointer
+ *
+ *	Will allocate each capsule_info memory for each file open call.
+ *	This provided the capability to support multiple file open feature
+ *	where user is not needed to wait for others to finish in order to
+ *	upload their capsule binary.
+ **/
+static int efi_capsule_open(struct inode *inode, struct file *file)
+{
+	struct capsule_info *cap_info;
+
+	cap_info = kzalloc(sizeof(*cap_info), GFP_KERNEL);
+	if (!cap_info) {
+		pr_debug("%s: kzalloc() failed\n", __func__);
+		return -ENOMEM;
+	}
+	file->private_data = cap_info;
+
+	return 0;
+}
+
+static const struct file_operations efi_capsule_fops = {
+	.owner = THIS_MODULE,
+	.open = efi_capsule_open,
+	.write = efi_capsule_write,
+	.flush = efi_capsule_flush,
+	.release = efi_capsule_release,
+	.llseek = no_llseek,
+};
+
+static struct miscdevice efi_capsule_misc = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = DEV_NAME,
+	.fops = &efi_capsule_fops,
+};
+
+static int __init efi_capsule_loader_init(void)
+{
+	int ret;
+
+	mutex_init(&capsule_loader_lock);
+
+	ret = misc_register(&efi_capsule_misc);
+	if (ret) {
+		pr_err("%s: Failed to register misc char file note\n",
+		       __func__);
+		mutex_destroy(&capsule_loader_lock);
+	}
+
+	return ret;
+}
+module_init(efi_capsule_loader_init);
+
+static void __exit efi_capsule_loader_exit(void)
+{
+	misc_deregister(&efi_capsule_misc);
+	mutex_destroy(&capsule_loader_lock);
+}
+module_exit(efi_capsule_loader_exit);
+
+MODULE_DESCRIPTION("EFI capsule firmware binary loader");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5
