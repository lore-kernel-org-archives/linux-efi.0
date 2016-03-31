From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 06/10] spi: add support for ACPI reconfigure notifications
Date: Thu, 31 Mar 2016 12:37:02 +0300
Message-ID: <1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

This allows the SPI core to enumerate devices from ACPI tables that
are dynamically loaded after the SPI master device has been probed.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/spi/spi.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 47eff80..8751f02 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1619,7 +1619,8 @@ static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
 
 	if (acpi_bus_get_device(handle, &adev))
 		return AE_OK;
-	if (acpi_bus_get_status(adev) || !adev->status.present)
+	if (acpi_bus_get_status(adev) || !adev->status.present ||
+	    acpi_device_enumerated(adev))
 		return AE_OK;
 
 	spi = spi_alloc_device(master);
@@ -1645,6 +1646,8 @@ static acpi_status acpi_spi_add_device(acpi_handle handle, u32 level,
 	if (spi->irq < 0)
 		spi->irq = acpi_dev_gpio_irq_get(adev, 0);
 
+	adev->flags.visited = true;
+
 	adev->power.flags.ignore_parent = true;
 	strlcpy(spi->modalias, acpi_device_hid(adev), sizeof(spi->modalias));
 	if (spi_add_device(spi)) {
@@ -2698,6 +2701,35 @@ static struct notifier_block spi_of_notifier = {
 extern struct notifier_block spi_of_notifier;
 #endif /* IS_ENABLED(CONFIG_OF_DYNAMIC) */
 
+#if IS_ENABLED(CONFIG_ACPI)
+static int acpi_spi_table_load(struct device *dev, const void *data)
+{
+	struct spi_master *master = container_of(dev, struct spi_master, dev);
+
+	acpi_register_spi_devices(master);
+	return 0;
+}
+
+static int acpi_spi_notify(struct notifier_block *nb, unsigned long value,
+			   void *arg)
+{
+	switch (value) {
+	case ACPI_RECONFIG_TABLE_LOAD:
+		class_find_device(&spi_master_class, NULL, NULL,
+				  acpi_spi_table_load);
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
@@ -2718,6 +2750,8 @@ static int __init spi_init(void)
 
 	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
 		WARN_ON(of_reconfig_notifier_register(&spi_of_notifier));
+	if (IS_ENABLED(CONFIG_ACPI))
+		WARN_ON(acpi_reconfig_notifier_register(&spi_acpi_notifier));
 
 	return 0;
 
-- 
1.9.1
