From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v4 5/8] spi: add support for ACPI reconfigure notifications
Date: Fri, 17 Jun 2016 14:52:13 +0300
Message-ID: <1466164336-9508-6-git-send-email-octavian.purdila@intel.com>
References: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

This patch adds supports for SPI device enumeration and removal via
ACPI reconfiguration notifications that are send as a result of an
ACPI table load or unload operation.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 89 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 77e6e45..37cda92 100644
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
@@ -3107,6 +3120,73 @@ static struct notifier_block spi_of_notifier = {
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
@@ -3127,6 +3207,8 @@ static int __init spi_init(void)
 
 	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
 		WARN_ON(of_reconfig_notifier_register(&spi_of_notifier));
+	if (IS_ENABLED(CONFIG_ACPI))
+		WARN_ON(acpi_reconfig_notifier_register(&spi_acpi_notifier));
 
 	return 0;
 
-- 
2.7.4
