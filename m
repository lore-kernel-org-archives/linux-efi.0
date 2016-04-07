From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v11 07/17] Xen: ARM: Add support for mapping AMBA device mmio
Date: Thu, 7 Apr 2016 20:03:24 +0800
Message-ID: <1460030614-16112-8-git-send-email-zhaoshenglong@huawei.com>
References: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460030614-16112-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, sstabellini@kernel.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, julien.grall@arm.com, david.vrabel@citrix.com, xen-devel@lists.xen.org, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: linux-efi@vger.kernel.org

From: Shannon Zhao <shannon.zhao@linaro.org>

Add a bus_notifier for AMBA bus device in order to map the device
mmio regions when DOM0 booting with ACPI.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Julien Grall <julien.grall@arm.com>
---
 drivers/xen/arm-device.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/xen/arm-device.c b/drivers/xen/arm-device.c
index b918e8e..778acf8 100644
--- a/drivers/xen/arm-device.c
+++ b/drivers/xen/arm-device.c
@@ -151,3 +151,46 @@ static int __init register_xen_platform_notifier(void)
 }
 
 arch_initcall(register_xen_platform_notifier);
+
+#ifdef CONFIG_ARM_AMBA
+#include <linux/amba/bus.h>
+
+static int xen_amba_notifier(struct notifier_block *nb,
+			     unsigned long action, void *data)
+{
+	struct amba_device *adev = to_amba_device(data);
+	int r = 0;
+
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		r = xen_map_device_mmio(&adev->res, 1);
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		r = xen_unmap_device_mmio(&adev->res, 1);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+	if (r)
+		dev_err(&adev->dev, "AMBA: Failed to %s device %s MMIO!\n",
+			action == BUS_NOTIFY_ADD_DEVICE ? "map" :
+			(action == BUS_NOTIFY_DEL_DEVICE ? "unmap" : "?"),
+			adev->dev.init_name);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block amba_device_nb = {
+	.notifier_call = xen_amba_notifier,
+};
+
+static int __init register_xen_amba_notifier(void)
+{
+	if (!xen_initial_domain() || acpi_disabled)
+		return 0;
+
+	return bus_register_notifier(&amba_bustype, &amba_device_nb);
+}
+
+arch_initcall(register_xen_amba_notifier);
+#endif
-- 
2.0.4
