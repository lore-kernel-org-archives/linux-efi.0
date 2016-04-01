From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: [PATCH v10 06/17] Xen: ARM: Add support for mapping platform device mmio
Date: Fri,  1 Apr 2016 23:49:04 +0800
Message-ID: <1459525755-36968-7-git-send-email-shannon.zhao@linaro.org>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, stefano.stabellini@citrix.com
Cc: david.vrabel@citrix.com, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@arm.com, peter.huangpeng@huawei.com, xen-devel@lists.xen.org, zhaoshenglong@huawei.com, shannon.zhao@linaro.org
List-Id: linux-efi@vger.kernel.org

Add a bus_notifier for platform bus device in order to map the device
mmio regions when DOM0 booting with ACPI.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/Makefile     |   1 +
 drivers/xen/arm-device.c | 141 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+)
 create mode 100644 drivers/xen/arm-device.c

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 9b7a35c..415f286 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -9,6 +9,7 @@ CFLAGS_features.o			:= $(nostackp)
 
 CFLAGS_efi.o				+= -fshort-wchar
 
+dom0-$(CONFIG_ARM64) += arm-device.o
 dom0-$(CONFIG_PCI) += pci.o
 dom0-$(CONFIG_USB_SUPPORT) += dbgp.o
 dom0-$(CONFIG_XEN_ACPI) += acpi.o $(xen-pad-y)
diff --git a/drivers/xen/arm-device.c b/drivers/xen/arm-device.c
new file mode 100644
index 0000000..76e26e5
--- /dev/null
+++ b/drivers/xen/arm-device.c
@@ -0,0 +1,141 @@
+/*
+ * Copyright (c) 2015, Linaro Limited, Shannon Zhao
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/acpi.h>
+#include <xen/xen.h>
+#include <xen/page.h>
+#include <xen/interface/memory.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+
+static int xen_unmap_device_mmio(struct resource *resource, unsigned int count)
+{
+	unsigned int i, j, nr;
+	int rc = 0;
+	struct resource *r;
+	struct xen_remove_from_physmap xrp;
+
+	for (i = 0; i < count; i++) {
+		r = &resource[i];
+		nr = DIV_ROUND_UP(resource_size(r), XEN_PAGE_SIZE);
+		if ((resource_type(r) != IORESOURCE_MEM) || (nr == 0))
+			continue;
+
+		for (j = 0; j < nr; j++) {
+			xrp.domid = DOMID_SELF;
+			xrp.gpfn = XEN_PFN_DOWN(r->start) + j;
+			rc = HYPERVISOR_memory_op(XENMEM_remove_from_physmap,
+						  &xrp);
+			if (rc)
+				return rc;
+		}
+	}
+
+	return rc;
+}
+
+static int xen_map_device_mmio(struct resource *resource, unsigned int count)
+{
+	unsigned int i, j, nr;
+	int rc = 0;
+	struct resource *r;
+	xen_pfn_t *gpfns;
+	xen_ulong_t *idxs;
+	int *errs;
+	struct xen_add_to_physmap_range xatp;
+
+	for (i = 0; i < count; i++) {
+		r = &resource[i];
+		nr = DIV_ROUND_UP(resource_size(r), XEN_PAGE_SIZE);
+		if ((resource_type(r) != IORESOURCE_MEM) || (nr == 0))
+			continue;
+
+		gpfns = kzalloc(sizeof(xen_pfn_t) * nr, GFP_KERNEL);
+		idxs = kzalloc(sizeof(xen_ulong_t) * nr, GFP_KERNEL);
+		errs = kzalloc(sizeof(int) * nr, GFP_KERNEL);
+		if (!gpfns || !idxs || !errs) {
+			kfree(gpfns);
+			kfree(idxs);
+			kfree(errs);
+			return -ENOMEM;
+		}
+
+		for (j = 0; j < nr; j++) {
+			gpfns[j] = XEN_PFN_DOWN(r->start) + j;
+			idxs[j] = XEN_PFN_DOWN(r->start) + j;
+		}
+
+		xatp.domid = DOMID_SELF;
+		xatp.size = nr;
+		xatp.space = XENMAPSPACE_dev_mmio;
+
+		set_xen_guest_handle(xatp.gpfns, gpfns);
+		set_xen_guest_handle(xatp.idxs, idxs);
+		set_xen_guest_handle(xatp.errs, errs);
+
+		rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
+		kfree(gpfns);
+		kfree(idxs);
+		kfree(errs);
+		if (rc)
+			return rc;
+	}
+
+	return rc;
+}
+
+static int xen_platform_notifier(struct notifier_block *nb,
+				 unsigned long action, void *data)
+{
+	struct platform_device *pdev = to_platform_device(data);
+	int r = 0;
+
+	if (pdev->num_resources == 0 || pdev->resource == NULL)
+		return NOTIFY_OK;
+
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		r = xen_map_device_mmio(pdev->resource, pdev->num_resources);
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		r = xen_unmap_device_mmio(pdev->resource, pdev->num_resources);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+	if (r)
+		dev_err(&pdev->dev, "Platform: Failed to %s device %s MMIO!\n",
+			action == BUS_NOTIFY_ADD_DEVICE ? "map" :
+			(action == BUS_NOTIFY_DEL_DEVICE ? "unmap" : "?"),
+			pdev->name);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block platform_device_nb = {
+	.notifier_call = xen_platform_notifier,
+};
+
+static int __init register_xen_platform_notifier(void)
+{
+	if (!xen_initial_domain() || acpi_disabled)
+		return 0;
+
+	return bus_register_notifier(&platform_bus_type, &platform_device_nb);
+}
+
+arch_initcall(register_xen_platform_notifier);
-- 
2.1.4
