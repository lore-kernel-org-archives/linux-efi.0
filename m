From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: [PATCH v11 1/1] efi: a misc char interface for user to update efi firmware
Date: Fri, 29 Jan 2016 12:39:54 +0800
Message-ID: <1454042394-21507-2-git-send-email-hock.leong.kweh@intel.com>
References: <1454042394-21507-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454042394-21507-1-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Anvin H Peter <h.peter.anvin@intel.com>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

Introducing a kernel module to expose capsule loader interface
(misc char device file note) for users to upload capsule binaries.

Example:
cat firmware.bin > /dev/efi_capsule_loader

This patch also export efi_capsule_supported() function symbol for
verifying the submitted capsule header in this kernel module.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
---
 drivers/firmware/efi/Kconfig          |    9 +
 drivers/firmware/efi/Makefile         |    1 +
 drivers/firmware/efi/capsule-loader.c |  334 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/capsule.c        |    1 +
 4 files changed, 345 insertions(+)
 create mode 100644 drivers/firmware/efi/capsule-loader.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index e1670d5..73c14af 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -87,6 +87,15 @@ config EFI_RUNTIME_WRAPPERS
 config EFI_ARMSTUB
 	bool
 
+config EFI_CAPSULE_LOADER
+	tristate "EFI capsule loader"
+	depends on EFI
+	help
+	  This option exposes a loader interface "/dev/efi_capsule_loader" for
+	  users to load EFI capsules.
+
+	  If unsure, say N.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index e4468c7..7d6e1e8 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
 obj-$(CONFIG_EFI_STUB)			+= libstub/
 obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
+obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= capsule-loader.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
new file mode 100644
index 0000000..acffd76
--- /dev/null
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -0,0 +1,334 @@
+/*
+ * EFI capsule loader driver.
+ *
+ * Copyright 2015 Intel Corporation
+ *
+ * This file is part of the Linux kernel, and is made available under
+ * the terms of the GNU General Public License version 2.
+ */
+
+#define pr_fmt(fmt) "EFI: " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/highmem.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/efi.h>
+
+#define NO_FURTHER_WRITE_ACTION -1
+
+struct capsule_info {
+	bool		header_obtained;
+	int		reset_type;
+	long		index;
+	size_t		count;
+	size_t		total_size;
+	struct page	**pages;
+	size_t		page_bytes_remain;
+};
+
+/**
+ * efi_free_all_buff_pages - free all previous allocated buffer pages
+ * @cap_info: pointer to current instance of capsule_info structure
+ *
+ *	In addition of freeing buffer pages, it flags NO_FURTHER_WRITE_ACTION
+ *	to cease processing data in subsequent write(2) calls until close(2)
+ *	is called.
+ **/
+static void efi_free_all_buff_pages(struct capsule_info *cap_info)
+{
+	while (cap_info->index > 0)
+		__free_page(cap_info->pages[--cap_info->index]);
+
+	cap_info->index = NO_FURTHER_WRITE_ACTION;
+}
+
+/**
+ * efi_capsule_setup_info - to obtain the efi capsule header in the binary and
+ *			    setup capsule_info structure
+ * @cap_info: pointer to current instance of capsule_info structure
+ * @kbuff: a mapped first page buffer pointer
+ * @hdr_bytes: the total received number of bytes for efi header
+ **/
+static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
+				      void *kbuff, size_t hdr_bytes)
+{
+	int ret;
+	void *temp_page;
+
+	/* Only process data block that is larger than a efi header size */
+	if (hdr_bytes >= sizeof(efi_capsule_header_t)) {
+		/* Reset back to the correct offset of header */
+		efi_capsule_header_t *cap_hdr = kbuff - cap_info->count;
+		size_t pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >>
+					    PAGE_SHIFT;
+
+		if (pages_needed == 0) {
+			pr_err("%s: pages count invalid\n", __func__);
+			return -EINVAL;
+		}
+
+		/* Check if the capsule binary supported */
+		ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
+					    cap_hdr->imagesize,
+					    &cap_info->reset_type);
+		if (ret) {
+			pr_err("%s: efi_capsule_supported() failed\n",
+			       __func__);
+			return ret;
+		}
+
+		cap_info->total_size = cap_hdr->imagesize;
+		temp_page = krealloc(cap_info->pages,
+				     pages_needed * sizeof(void *),
+				     GFP_KERNEL | __GFP_ZERO);
+		if (!temp_page) {
+			pr_debug("%s: krealloc() failed\n", __func__);
+			return -ENOMEM;
+		}
+
+		cap_info->pages = temp_page;
+		cap_info->header_obtained = true;
+	}
+
+	return 0;
+}
+
+/**
+ * efi_capsule_submit_update - invoke the efi_capsule_update API once binary
+ *			       upload done
+ * @cap_info: pointer to current instance of capsule_info structure
+ **/
+static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
+{
+	int ret;
+	void *cap_hdr_temp;
+
+	cap_hdr_temp = kmap(cap_info->pages[0]);
+	if (!cap_hdr_temp) {
+		pr_debug("%s: kmap() failed\n", __func__);
+		return -EFAULT;
+	}
+
+	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
+	kunmap(cap_info->pages[0]);
+	if (ret) {
+		pr_err("%s: efi_capsule_update() failed\n", __func__);
+		return ret;
+	}
+
+	/* Indicate capsule binary uploading is done */
+	cap_info->index = NO_FURTHER_WRITE_ACTION;
+	pr_info("%s: Successfully upload capsule file with reboot type '%s'\n",
+		__func__, !cap_info->reset_type ? "RESET_COLD" :
+		cap_info->reset_type == 1 ? "RESET_WARM" :
+		"RESET_SHUTDOWN");
+	return 0;
+}
+
+/**
+ * efi_capsule_write - store the capsule binary and pass it to
+ *		       efi_capsule_update() API
+ * @file: file pointer
+ * @buff: buffer pointer
+ * @count: number of bytes in @buff
+ * @offp: not used
+ *
+ *	Expectation:
+ *	- User space tool should start at the beginning of capsule binary and
+ *	  pass data in sequentially.
+ *	- Users should close and re-open this file note in order to upload more
+ *	  capsules.
+ *	- After an error returned, user should close the file and restart the
+ *	  operation for the next try otherwise -EIO will be returned until the
+ *	  file is closed.
+ *	- EFI capsule header must be located at the beginning of capsule binary
+ *	  file and passed in as first block data of write operation.
+ **/
+static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
+				 size_t count, loff_t *offp)
+{
+	int ret = 0;
+	struct capsule_info *cap_info = file->private_data;
+	void *kbuff = NULL;
+	size_t write_byte;
+
+	if (count == 0)
+		return 0;
+
+	/* Return error while NO_FURTHER_WRITE_ACTION is flagged */
+	if (cap_info->index < 0)
+		return -EIO;
+
+	/* Only alloc a new page when previous page is full */
+	if (!cap_info->page_bytes_remain) {
+		cap_info->pages[cap_info->index++] = alloc_page(GFP_KERNEL);
+		if (!cap_info->pages[cap_info->index - 1]) {
+			pr_debug("%s: alloc_page() failed\n", __func__);
+			ret = -ENOMEM;
+			goto failed;
+		}
+		cap_info->page_bytes_remain = PAGE_SIZE;
+	}
+
+	kbuff = kmap(cap_info->pages[cap_info->index - 1]);
+	if (!kbuff) {
+		pr_debug("%s: kmap() failed\n", __func__);
+		ret = -EFAULT;
+		goto failed;
+	}
+	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
+
+	/* Copy capsule binary data from user space to kernel space buffer */
+	write_byte = min_t(size_t, count, cap_info->page_bytes_remain);
+	if (copy_from_user(kbuff, buff, write_byte)) {
+		pr_debug("%s: copy_from_user() failed\n", __func__);
+		ret = -EFAULT;
+		goto fail_unmap;
+	}
+	cap_info->page_bytes_remain -= write_byte;
+
+	/* Setup capsule binary info structure */
+	if (!cap_info->header_obtained) {
+		ret = efi_capsule_setup_info(cap_info, kbuff,
+					     cap_info->count + write_byte);
+		if (ret)
+			goto fail_unmap;
+	}
+
+	cap_info->count += write_byte;
+	kunmap(cap_info->pages[cap_info->index - 1]);
+
+	/* Submit the full binary to efi_capsule_update() API */
+	if (cap_info->header_obtained &&
+	    cap_info->count >= cap_info->total_size) {
+		if (cap_info->count > cap_info->total_size) {
+			pr_err("%s: upload size exceeded header defined size\n",
+			       __func__);
+			ret = -EINVAL;
+			goto failed;
+		}
+
+		ret = efi_capsule_submit_update(cap_info);
+		if (ret)
+			goto failed;
+	}
+
+	return write_byte;
+
+fail_unmap:
+	kunmap(cap_info->pages[cap_info->index - 1]);
+failed:
+	efi_free_all_buff_pages(cap_info);
+	return ret;
+}
+
+/**
+ * efi_capsule_flush - called by file close or file flush
+ * @file: file pointer
+ * @id: not used
+ *
+ *	If a capsule is being partially uploaded then calling this function
+ *	will be treated as upload termination and will free those completed
+ *	buffer pages and -ECANCELED will be returned.
+ **/
+static int efi_capsule_flush(struct file *file, fl_owner_t id)
+{
+	int ret = 0;
+	struct capsule_info *cap_info = file->private_data;
+
+	if (cap_info->index > 0) {
+		pr_err("%s: capsule upload not complete\n", __func__);
+		efi_free_all_buff_pages(cap_info);
+		ret = -ECANCELED;
+	}
+
+	return ret;
+}
+
+/**
+ * efi_capsule_release - called by file close
+ * @inode: not used
+ * @file: file pointer
+ *
+ *	We would not free successfully submitted pages since efi update require
+ *	data to be maintained across system reboot.
+ **/
+static int efi_capsule_release(struct inode *inode, struct file *file)
+{
+	struct capsule_info *cap_info = file->private_data;
+
+	kfree(cap_info->pages);
+	kfree(file->private_data);
+	file->private_data = NULL;
+	return 0;
+}
+
+/**
+ * efi_capsule_open - called by file open
+ * @inode: not used
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
+	if (!cap_info)
+		return -ENOMEM;
+
+	cap_info->pages = kzalloc(sizeof(void *), GFP_KERNEL);
+	if (!cap_info->pages)
+		return -ENOMEM;
+
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
+	.name = "efi_capsule_loader",
+	.fops = &efi_capsule_fops,
+};
+
+static int __init efi_capsule_loader_init(void)
+{
+	int ret;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
+	ret = misc_register(&efi_capsule_misc);
+	if (ret)
+		pr_err("%s: Failed to register misc char file note\n",
+		       __func__);
+
+	return ret;
+}
+module_init(efi_capsule_loader_init);
+
+static void __exit efi_capsule_loader_exit(void)
+{
+	misc_deregister(&efi_capsule_misc);
+}
+module_exit(efi_capsule_loader_exit);
+
+MODULE_DESCRIPTION("EFI capsule firmware binary loader");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 475643d..476a960 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -102,6 +102,7 @@ out:
 	kfree(capsule);
 	return rv;
 }
+EXPORT_SYMBOL_GPL(efi_capsule_supported);
 
 /**
  * efi_capsule_update - send a capsule to the firmware
-- 
1.7.9.5
