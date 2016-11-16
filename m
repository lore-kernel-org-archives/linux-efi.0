From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/16] PCI: Lock down BAR access when the kernel is locked
 down
Date: Wed, 16 Nov 2016 21:48:29 +0000
Message-ID: <147933290912.19316.14293837405737099299.stgit@warthog.procyon.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Matthew Garrett <matthew.garrett@nebula.com>

Any hardware that can potentially generate DMA has to be locked down in
order to avoid it being possible for an attacker to modify kernel code,
allowing them to circumvent disabled module loading or module signing.
Default to paranoid - in future we can potentially relax this for
sufficiently IOMMU-isolated devices.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/pci/pci-sysfs.c |   10 ++++++++++
 drivers/pci/proc.c      |    9 ++++++++-
 drivers/pci/syscall.c   |    3 ++-
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index bcd10c795284..c5e3650a05fa 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -30,6 +30,7 @@
 #include <linux/vgaarb.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
+#include <linux/security.h>
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
@@ -716,6 +717,9 @@ static ssize_t pci_write_config(struct file *filp, struct kobject *kobj,
 	loff_t init_off = off;
 	u8 *data = (u8 *) buf;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	if (off > dev->cfg_size)
 		return 0;
 	if (off + count > dev->cfg_size) {
@@ -1007,6 +1011,9 @@ static int pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	resource_size_t start, end;
 	int i;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
 		if (res == &pdev->resource[i])
 			break;
@@ -1106,6 +1113,9 @@ static ssize_t pci_write_resource_io(struct file *filp, struct kobject *kobj,
 				     struct bin_attribute *attr, char *buf,
 				     loff_t off, size_t count)
 {
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
 }
 
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 2408abe4ee8c..7fad915f705e 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -11,6 +11,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/capability.h>
+#include <linux/security.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 #include "pci.h"
@@ -116,6 +117,9 @@ static ssize_t proc_bus_pci_write(struct file *file, const char __user *buf,
 	int size = dev->cfg_size;
 	int cnt;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)
@@ -195,6 +199,9 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
 #endif /* HAVE_PCI_MMAP */
 	int ret = 0;
 
+	if (kernel_is_locked_down())
+		return -EPERM;
+
 	switch (cmd) {
 	case PCIIOC_CONTROLLER:
 		ret = pci_domain_nr(dev->bus);
@@ -233,7 +240,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 	struct pci_filp_private *fpriv = file->private_data;
 	int i, ret, write_combine;
 
-	if (!capable(CAP_SYS_RAWIO))
+	if (!capable(CAP_SYS_RAWIO) || kernel_is_locked_down())
 		return -EPERM;
 
 	/* Make sure the caller is mapping a real resource for this device */
diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index b91c4da68365..a0d000702475 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/pci.h>
 #include <linux/syscalls.h>
+#include <linux/security.h>
 #include <asm/uaccess.h>
 #include "pci.h"
 
@@ -92,7 +93,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 	u32 dword;
 	int err = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) || kernel_is_locked_down())
 		return -EPERM;
 
 	dev = pci_get_bus_and_slot(bus, dfn);
