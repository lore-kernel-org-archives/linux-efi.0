From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 5/8] spi: add support for ACPI reconfigure notifications
Date: Tue, 14 Jun 2016 18:17:23 +0300
Message-ID: <1465917446-14043-6-git-send-email-octavian.purdila@intel.com>
References: <1465917446-14043-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465917446-14043-1-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J . Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Cc: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch adds supports for SPI device enumeration and removal via
ACPI reconfiguration notifications that are send as a result of an
ACPI table load or unload operation.

Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/spi/spi.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 87 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 77e6e45..8b6811c 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1646,18 +1646,15 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
 	return 1;
 }
 
-static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
-				       void *data, void **return_value)
+static acpi_status acpi_register_spi_device(struct spi_master *master,
+					    struct acpi_device *adev)
 {
-	struct spi_master *master = data;
 	struct list_head resource_list;
-	struct acpi_device *adev;
 	struct spi_device *spi;
 	int ret;
 
-	if (acpi_bus_get_device(handle, &adev))
-		return AE_OK;
-	if (acpi_bus_get_status(adev) || !adev->status.present)
+	if (acpi_bus_get_status(adev) || !adev->status.present ||
+	    acpi_device_enumerated(adev))
 		return AE_OK;
 
 	spi = spi_alloc_device(master);
@@ -1683,6 +1680,8 @@ static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
 	if (spi->irq < 0)
 		spi->irq = acpi_dev_gpio_irq_get(adev, 0);
 
+	adev->flags.visited = true;
+
 	adev->power.flags.ignore_parent = true;
 	strlcpy(spi->modalias, acpi_device_hid(adev), sizeof(spi->modalias));
 	if (spi_add_device(spi)) {
@@ -1695,6 +1694,18 @@ static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
 	return AE_OK;
 }
 
+static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
+				       void *data, void **return_value)
+{
+	struct spi_master *master = data;
+	struct acpi_device *adev;
+
+	if (acpi_bus_get_device(handle, &adev))
+		return AE_OK;
+
+	return acpi_register_spi_device(master, adev);
+}
+
 static void acpi_register_spi_devices(struct spi_master *master)
 {
 	acpi_status status;
@@ -3107,6 +3118,73 @@ static struct notifier_block spi_of_notifier = {
 extern struct notifier_block spi_of_notifier;
 #endif /* IS_ENABLED(CONFIG_OF_DYNAMIC) */
 
+#if IS_ENABLED(CONFIG_ACPI)
+static int spi_acpi_master_match(struct device *dev, const void *data)
+{
+	return ACPI_COMPANION(dev->parent) == data;
+}
+
+static int spi_acpi_device_match(struct device *dev, void *data)
+{
+	return ACPI_COMPANION(dev) == data;
+}
+
+static struct spi_master *acpi_spi_find_master_by_adev(struct acpi_device *adev)
+{
+	struct device *dev;
+
+	dev = class_find_device(&spi_master_class, NULL, adev,
+				spi_acpi_master_match);
+	if (!dev)
+		return NULL;
+
+	return container_of(dev, struct spi_master, dev);
+}
+
+static struct spi_device *acpi_spi_find_device_by_adev(struct acpi_device *adev)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&spi_bus_type, NULL, adev, spi_acpi_device_match);
+
+	return dev ? to_spi_device(dev) : NULL;
+}
+
+static int acpi_spi_notify(struct notifier_block *nb, unsigned long value,
+			   void *arg)
+{
+	struct acpi_device *adev = arg;
+	struct spi_master *master;
+	struct spi_device *spi;
+
+	switch (value) {
+	case ACPI_RECONFIG_DEVICE_ADD:
+		master = acpi_spi_find_master_by_adev(adev->parent);
+		if (!master)
+			break;
+
+		acpi_register_spi_device(master, adev);
+		put_device(&master->dev);
+		break;
+	case ACPI_RECONFIG_DEVICE_REMOVE:
+		spi = acpi_spi_find_device_by_adev(adev);
+		if (!spi)
+			break;
+
+		spi_unregister_device(spi);
+		put_device(&spi->dev);
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block spi_acpi_notifier = {
+	.notifier_call = acpi_spi_notify,
+};
+#else
+extern struct notifier_block spi_acpi_notifier;
+#endif
+
 static int __init spi_init(void)
 {
 	int	status;
@@ -3127,6 +3205,8 @@ static int __init spi_init(void)
 
 	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
 		WARN_ON(of_reconfig_notifier_register(&spi_of_notifier));
+	if (IS_ENABLED(CONFIG_ACPI))
+		WARN_ON(acpi_reconfig_notifier_register(&spi_acpi_notifier));
 
 	return 0;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
