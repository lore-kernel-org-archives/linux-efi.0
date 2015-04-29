From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [RFC 3/3] efi: add capsule update capability via sysfs
Date: Wed, 29 Apr 2015 16:12:10 -0700
Message-ID: <1430349130.2189.43.camel@HansenPartnership.com>
References: <1430348859.2189.37.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430348859.2189.37.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: James Bottomley <JBottomley@Odin.com>

The firmware update should be applied simply by doing

cat fw_file > /sys/firmware/capsule/update

With a properly formatted fw_file.  Any error will be returned on close of
stdout.  util-linux returns errors correctly from closing stdout, but firmware
shippers should check whatever utilities package they use correctly captures
the error return on close.

Signed-off-by: James Bottomley <JBottomley@Odin.com>
---
 drivers/firmware/efi/Makefile  |  2 +-
 drivers/firmware/efi/capsule.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/capsule.h |  2 ++
 drivers/firmware/efi/efi.c     |  8 +++++
 4 files changed, 89 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/capsule.c
 create mode 100644 drivers/firmware/efi/capsule.h

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index d8be608..698846e 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for linux kernel
 #
-obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
+obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o capsule.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
new file mode 100644
index 0000000..1fd78e7
--- /dev/null
+++ b/drivers/firmware/efi/capsule.c
@@ -0,0 +1,78 @@
+#include <linux/efi.h>
+#include <linux/slab.h>
+#include <linux/transaction_helper.h>
+
+#include "capsule.h"
+
+static struct kset *capsule_kset;
+static struct transaction_buf *capsule_buf;
+
+static int capsule_data_write(struct file *file, struct kobject *kobj,
+			      struct bin_attribute *attr,
+			      char *buffer, loff_t offset, size_t count)
+{
+	if (!capsule_buf) {
+		capsule_buf = kmalloc(sizeof(*capsule_buf), GFP_KERNEL);
+		if (!capsule_buf)
+			return -ENOMEM;
+		transaction_init(capsule_buf);
+	}
+
+	return transaction_write(capsule_buf, buffer, offset, count);
+}
+
+static int capsule_data_flush(struct file *file, struct kobject *kobj,
+		     struct bin_attribute *attr, fl_owner_t id)
+{
+	efi_capsule_header_t *hdr[1];
+	int retval = -EINVAL;
+
+	void *data = transaction_map(capsule_buf, PAGE_KERNEL_RO);
+
+	hdr[0] = data;
+	if (hdr[0]->headersize > capsule_buf->size)
+		goto out;
+
+	retval = efi.update_capsule(hdr, 1, 0);
+
+ out:
+	transaction_free(capsule_buf);
+	kfree(capsule_buf);
+	capsule_buf = NULL;
+
+	return retval;
+}
+
+
+static const struct bin_attribute capsule_update_attr = {
+	.attr = { .name = "update", .mode = 0600 },
+	.size = 0,
+	.write = capsule_data_write,
+	.flush = capsule_data_flush,
+};
+
+__init int efi_capsule_init(struct kobject *efi_kobj)
+{
+
+	int err;
+
+	/* FIXME: check that UEFI actually supports capsule here */
+
+	capsule_kset = kset_create_and_add("capsule", NULL, efi_kobj);
+	if (!capsule_kset) {
+		printk(KERN_ERR "UEFI capsule: failed to register subsystem\n");
+		return -ENOMEM;
+	}
+
+	err = sysfs_create_bin_file(&capsule_kset->kobj, &capsule_update_attr);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+void efi_capsule_remove(struct kobject *efi_kobj)
+{
+	sysfs_remove_bin_file(&capsule_kset->kobj, &capsule_update_attr);
+	kset_unregister(capsule_kset);
+}
diff --git a/drivers/firmware/efi/capsule.h b/drivers/firmware/efi/capsule.h
new file mode 100644
index 0000000..cc38f7d
--- /dev/null
+++ b/drivers/firmware/efi/capsule.h
@@ -0,0 +1,2 @@
+int efi_capsule_init(struct kobject *efi_kobj);
+void efi_capsule_remove(struct kobject *efi_kobj);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3061bb8..92da61e 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -25,6 +25,8 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 
+#include "capsule.h"
+
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -219,8 +221,14 @@ static int __init efisubsys_init(void)
 		goto err_remove_group;
 	}
 
+	error = efi_capsule_init(efi_kobj);
+	if (error)
+		goto err_remove_capsule;
+
 	return 0;
 
+err_remove_capsule:
+	efi_capsule_remove(efi_kobj);
 err_remove_group:
 	sysfs_remove_group(efi_kobj, &efi_subsys_attr_group);
 err_unregister:
-- 
2.1.4
