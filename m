From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v10 07/17] Xen: ARM: Add support for mapping AMBA device mmio
Date: Fri,  1 Apr 2016 23:49:05 +0800
Message-ID: <1459525755-36968-8-git-send-email-shannon.zhao@linaro.org>
References: <1459525755-36968-1-git-send-email-shannon.zhao@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459525755-36968-1-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-5wv7dgnIgG8@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Add a bus_notifier for AMBA bus device in order to map the device
mmio regions when DOM0 booting with ACPI.

Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
---
 drivers/xen/arm-device.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/xen/arm-device.c b/drivers/xen/arm-device.c
index 76e26e5..3854043 100644
--- a/drivers/xen/arm-device.c
+++ b/drivers/xen/arm-device.c
@@ -139,3 +139,46 @@ static int __init register_xen_platform_notifier(void)
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
2.1.4
