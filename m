From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: [PATCH v5 2/2] efi: a misc char interface for user to update efi firmware
Date: Fri, 21 Aug 2015 19:34:48 +0800
Message-ID: <1440156888-25796-3-git-send-email-hock.leong.kweh@intel.com>
References: <1440156888-25796-1-git-send-email-hock.leong.kweh@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440156888-25796-1-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Fleming Matt <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>

Introducing a kernel module to expose capsule loader interface
(misc char device file note) for user to upload capsule binaries.

Example method to load the capsule binary:
cat firmware.bin > /dev/efi_capsule_loader

Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
---
 drivers/firmware/efi/Kconfig              |   10 ++
 drivers/firmware/efi/Makefile             |    1 +
 drivers/firmware/efi/efi-capsule-loader.c |  218 +++++++++++++++++++++++++++++
 3 files changed, 229 insertions(+)
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
index 0000000..1da8608
--- /dev/null
+++ b/drivers/firmware/efi/efi-capsule-loader.c
@@ -0,0 +1,218 @@
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
+
+struct capsule_info {
+	int		curr_index;
+	int		curr_size;
+	int		total_size;
+	struct page	**pages;
+};
+
+static DEFINE_MUTEX(capsule_loader_lock);
+
+/*
+ * This function will store the capsule binary and pass it to
+ * efi_capsule_update() API in capsule.c
+ */
+static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
+				 size_t count, loff_t *offp)
+{
+	int ret = 0;
+	struct capsule_info *cap_info = file->private_data;
+	struct page *kbuff_page;
+	void *kbuff;
+
+	pr_debug("%s: Entering Write()\n", __func__);
+	if (count == 0)
+		return 0;
+
+	if (cap_info->curr_index == -1)
+		return count;
+
+	kbuff_page = alloc_page(GFP_KERNEL);
+	if (!kbuff_page) {
+		pr_err("%s: alloc_page() failed\n", __func__);
+		if (!cap_info->curr_index)
+			return -ENOMEM;
+		ret = -ENOMEM;
+		goto failed;
+	}
+
+	kbuff = kmap(kbuff_page);
+	if (!kbuff) {
+		pr_err("%s: kmap() failed\n", __func__);
+		if (cap_info->curr_index)
+			cap_info->pages[cap_info->curr_index++] = kbuff_page;
+		ret = -EFAULT;
+		goto failed;
+	}
+
+	/* copy capsule binary data from user space to kernel space buffer */
+	if (copy_from_user(kbuff, buff, min_t(size_t, count, PAGE_SIZE))) {
+		pr_err("%s: copy_from_user() failed\n", __func__);
+		if (cap_info->curr_index)
+			cap_info->pages[cap_info->curr_index++] = kbuff_page;
+		kunmap(kbuff_page);
+		ret = -EFAULT;
+		goto failed;
+	}
+
+	/* setup capsule binary info structure */
+	if (cap_info->curr_index == 0) {
+		efi_capsule_header_t *cap_hdr = kbuff;
+		int reset_type;
+		int pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >>
+					PAGE_SHIFT;
+
+		if (pages_needed <= 0) {
+			pr_err("%s: pages count invalid\n", __func__);
+			ret = -EINVAL;
+			kunmap(kbuff_page);
+			goto failed;
+		}
+
+		/* check if the capsule binary supported */
+		ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
+					    cap_hdr->imagesize, &reset_type);
+		if (ret) {
+			pr_err("%s: efi_capsule_supported() failed\n",
+			       __func__);
+			kunmap(kbuff_page);
+			goto failed;
+		}
+
+		cap_info->total_size = cap_hdr->imagesize;
+		cap_info->pages = kmalloc_array(pages_needed, sizeof(void *),
+						GFP_KERNEL);
+		if (!cap_info->pages) {
+			pr_err("%s: kmalloc_array() failed\n", __func__);
+			ret = -ENOMEM;
+			kunmap(kbuff_page);
+			goto failed;
+		}
+	}
+
+	cap_info->pages[cap_info->curr_index++] = kbuff_page;
+	cap_info->curr_size += count;
+	kunmap(kbuff_page);
+
+	/* submit the full binary to efi_capsule_update() API */
+	if (cap_info->curr_size >= cap_info->total_size) {
+		ret = efi_capsule_update(kmap(cap_info->pages[0]),
+					 cap_info->pages);
+		kunmap(cap_info->pages[0]);
+		if (ret) {
+			pr_err("%s: efi_capsule_update() failed\n", __func__);
+			goto failed;
+		}
+		/* indicate capsule binary uploading is done */
+		cap_info->curr_index = -1;
+	}
+
+	/*
+	 * we cannot free the pages here due to reboot need that data
+	 * maintained.
+	 */
+	return count;
+
+failed:
+	if (!cap_info->curr_index) {
+		__free_page(kbuff_page);
+	} else {
+		while (cap_info->curr_index > 0)
+			__free_page(cap_info->pages[--cap_info->curr_index]);
+		kfree(cap_info->pages);
+	}
+
+	return ret;
+}
+
+static int efi_capsule_release(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+	struct capsule_info *cap_info = file->private_data;
+
+	pr_debug("%s: Exit in Release()\n", __func__);
+	/* release those uncompleted uploaded block */
+	if (cap_info->curr_index > 0) {
+		pr_err("%s: capsule upload not complete\n", __func__);
+		while (cap_info->curr_index > 0)
+			__free_page(cap_info->pages[--cap_info->curr_index]);
+		kfree(cap_info->pages);
+		ret = -ECANCELED;
+	}
+	kfree(file->private_data);
+	file->private_data = NULL;
+	mutex_unlock(&capsule_loader_lock);
+	return ret;
+}
+
+static int efi_capsule_open(struct inode *inode, struct file *file)
+{
+	int ret = -EBUSY;
+	struct capsule_info *cap_info;
+
+	pr_debug("%s: Entering Open()\n", __func__);
+	if (mutex_trylock(&capsule_loader_lock)) {
+		cap_info = kzalloc(sizeof(*cap_info), GFP_KERNEL);
+		file->private_data = cap_info;
+		ret = 0;
+	}
+	return ret;
+}
+
+static const struct file_operations efi_capsule_fops = {
+	.owner = THIS_MODULE,
+	.open = efi_capsule_open,
+	.write = efi_capsule_write,
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
+	if (ret)
+		pr_err("%s: misc_register() failed\n", __func__);
+
+	return ret;
+}
+module_init(efi_capsule_loader_init);
+
+static void __exit efi_capsule_loader_exit(void)
+{
+	mutex_destroy(&capsule_loader_lock);
+	misc_deregister(&efi_capsule_misc);
+}
+module_exit(efi_capsule_loader_exit);
+
+MODULE_DESCRIPTION("EFI capsule firmware binary loader");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5
