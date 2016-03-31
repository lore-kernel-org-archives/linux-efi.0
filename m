From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 05/10] i2c: add support for ACPI reconfigure notifications
Date: Thu, 31 Mar 2016 12:37:01 +0300
Message-ID: <1459417026-6697-6-git-send-email-octavian.purdila@intel.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-i2c-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

This allows the i2c core to enumerate devices from ACPI tables that
are dynamically loaded after the i2c adapter has been probed.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/i2c/i2c-core.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index ffe715d..7a6f741 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -150,7 +150,8 @@ static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
 
 	if (acpi_bus_get_device(handle, &adev))
 		return AE_OK;
-	if (acpi_bus_get_status(adev) || !adev->status.present)
+	if (acpi_bus_get_status(adev) || !adev->status.present ||
+	    acpi_device_enumerated(adev))
 		return AE_OK;
 
 	memset(&info, 0, sizeof(info));
@@ -189,6 +190,9 @@ static acpi_status acpi_i2c_add_device(acpi_handle handle, u32 level,
 
 	adev->power.flags.ignore_parent = true;
 	strlcpy(info.type, dev_name(&adev->dev), sizeof(info.type));
+
+	adev->flags.visited = true;
+
 	if (!i2c_new_device(adapter, &info)) {
 		adev->power.flags.ignore_parent = false;
 		dev_err(&adapter->dev,
@@ -224,8 +228,36 @@ static void acpi_i2c_register_devices(struct i2c_adapter *adap)
 		dev_warn(&adap->dev, "failed to enumerate I2C slaves\n");
 }
 
+static int acpi_i2c_table_load(struct device *dev, void *data)
+{
+	struct i2c_adapter *adapter = i2c_verify_adapter(dev);
+
+	if (!adapter)
+		return 0;
+
+	acpi_i2c_register_devices(adapter);
+	return 0;
+}
+
+static int acpi_i2c_notify(struct notifier_block *nb, unsigned long value,
+			   void *arg)
+{
+	switch (value) {
+	case ACPI_RECONFIG_TABLE_LOAD:
+		bus_find_device(&i2c_bus_type, NULL, NULL,
+				acpi_i2c_table_load);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block i2c_acpi_notifier = {
+	.notifier_call = acpi_i2c_notify,
+};
 #else /* CONFIG_ACPI */
 static inline void acpi_i2c_register_devices(struct i2c_adapter *adap) { }
+extern struct notifier_block i2c_acpi_notifier;
 #endif /* CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_I2C_OPREGION
@@ -2117,6 +2149,8 @@ static int __init i2c_init(void)
 
 	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
 		WARN_ON(of_reconfig_notifier_register(&i2c_of_notifier));
+	if (IS_ENABLED(CONFIG_ACPI))
+		WARN_ON(acpi_reconfig_notifier_register(&i2c_acpi_notifier));
 
 	return 0;
 
@@ -2131,6 +2165,8 @@ bus_err:
 
 static void __exit i2c_exit(void)
 {
+	if (IS_ENABLED(CONFIG_ACPI))
+		WARN_ON(acpi_reconfig_notifier_unregister(&i2c_acpi_notifier));
 	if (IS_ENABLED(CONFIG_OF_DYNAMIC))
 		WARN_ON(of_reconfig_notifier_unregister(&i2c_of_notifier));
 	i2c_del_driver(&dummy_driver);
-- 
1.9.1
