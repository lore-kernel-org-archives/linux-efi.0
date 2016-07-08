From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v7 5/8] spi: add support for ACPI reconfigure notifications
Date: Fri,  8 Jul 2016 19:13:11 +0300
Message-ID: <1467994394-23983-6-git-send-email-octavian.purdila@intel.com>
References: <1467994394-23983-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467994394-23983-1-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J . Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonard.crestez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch adds supports for SPI device enumeration and removal via
ACPI reconfiguration notifications that are send as a result of an
ACPI table load or unload operation.

The code is very similar with the device tree reconfiguration code
with only small differences in the way we test and set the enumerated
state of the device:

 * the equivalent of device tree's OF_POPULATED flag is the
   flags.visited field in the ACPI device and the following wrappers
   are used to manipulate it: acpi_device_enumerated(),
   acpi_device_set_enumerated() and acpi_device_clear_enumerated()

 * the device tree code checks of status of the OF_POPULATED flag to
   avoid trying to create duplicate Linux devices in two places: once
   when the controller is probed, and once when the reconfigure event
   is received; in the ACPI code the check is performed only once when
   the ACPI namespace is searched because this code path is invoked in
   both of the two mentioned cases

The rest of the enumeration handling is similar with device tree: when
the Linux device is unregistered the ACPI device is marked as not
enumerated; also, when a device remove notification is received we
check that the device is in the enumerated state before continuing
with the removal of the Linux device.

Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mika Westerberg <mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Acked-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/spi/spi.c | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 93 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 77e6e45..7589c8a 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -622,6 +622,8 @@ void spi_unregister_device(struct spi_device *spi)
 
 	if (spi->dev.of_node)
 		of_node_clear_flag(spi->dev.of_node, OF_POPULATED);
+	if (ACPI_COMPANION(&spi->dev))
+		acpi_device_clear_enumerated(ACPI_COMPANION(&spi->dev));
 	device_unregister(&spi->dev);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_device);
@@ -1646,18 +1648,15 @@ static int acpi_spi_add_resource(struct acpi_resource *ares, void *data)
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
@@ -1683,6 +1682,8 @@ static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
 	if (spi->irq < 0)
 		spi->irq = acpi_dev_gpio_irq_get(adev, 0);
 
+	acpi_device_set_enumerated(adev);
+
 	adev->power.flags.ignore_parent = true;
 	strlcpy(spi->modalias, acpi_device_hid(adev), sizeof(spi->modalias));
 	if (spi_add_device(spi)) {
@@ -1695,6 +1696,18 @@ static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
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
@@ -3107,6 +3120,77 @@ static struct notifier_block spi_of_notifier = {
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
+		if (!acpi_device_enumerated(adev))
+			break;
+
+		spi = acpi_spi_find_device_by_adev(adev);
+		if (!spi)
+			break;
+
+		spi_unregister_device(spi);
+		put_device(&spi->dev);
+		break;
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
@@ -3127,6 +3211,8 @@ static int __init spi_init(void)
 
 	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
 		WARN_ON(of_reconfig_notifier_register(&spi_of_notifier));
+	if (IS_ENABLED(CONFIG_ACPI))
+		WARN_ON(acpi_reconfig_notifier_register(&spi_acpi_notifier));
 
 	return 0;
 
-- 
2.7.4
