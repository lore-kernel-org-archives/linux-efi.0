From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v4 2/8] acpi: fix enumeration (visited) flags for bus rescans
Date: Fri, 17 Jun 2016 14:52:10 +0300
Message-ID: <1466164336-9508-3-git-send-email-octavian.purdila@intel.com>
References: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

If the ACPI tables changes as a result of a dinamically loaded table and
a bus rescan is required the enumeration/visited flag are not
consistent.

I2C/SPI are not directly enumerated in acpi_bus_attach(), however the
visited flag is set. This makes it impossible to check if an ACPI device
has already been enumerated by the I2C and SPI subsystems. To fix this
issue we only set the visited flags if the device is not I2C or SPI.

With this change we also need to remove setting visited to false from
acpi_bus_attach(), otherwise if we rescan already enumerated I2C/SPI
devices we try to re-enumerate them.

Note that I2C/SPI devices can be enumerated either via a scan handler
(when using PRP0001) or via regular device_attach(). In either case
the flow goes through acpi_default_enumeration() which makes it the
ideal place to mark the ACPI device as enumerated.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/acpi/scan.c  | 13 +++++++------
 include/linux/acpi.h | 18 ++++++++++++++++++
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 5f28cf7..f80f8a7 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1406,7 +1406,7 @@ void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
 	acpi_bus_get_flags(device);
 	device->flags.match_driver = false;
 	device->flags.initialized = true;
-	device->flags.visited = false;
+	acpi_device_clear_enumerated(device);
 	device_initialize(&device->dev);
 	dev_set_uevent_suppress(&device->dev, true);
 	acpi_init_coherency(device);
@@ -1683,8 +1683,10 @@ static void acpi_default_enumeration(struct acpi_device *device)
 	acpi_dev_get_resources(device, &resource_list, acpi_check_spi_i2c_slave,
 			       &is_spi_i2c_slave);
 	acpi_dev_free_resource_list(&resource_list);
-	if (!is_spi_i2c_slave)
+	if (!is_spi_i2c_slave) {
 		acpi_create_platform_device(device);
+		acpi_device_set_enumerated(device);
+	}
 }
 
 static const struct acpi_device_id generic_device_ids[] = {
@@ -1751,7 +1753,7 @@ static void acpi_bus_attach(struct acpi_device *device)
 	acpi_bus_get_status(device);
 	/* Skip devices that are not present. */
 	if (!acpi_device_is_present(device)) {
-		device->flags.visited = false;
+		acpi_device_clear_enumerated(device);
 		device->flags.power_manageable = 0;
 		return;
 	}
@@ -1766,7 +1768,7 @@ static void acpi_bus_attach(struct acpi_device *device)
 
 		device->flags.initialized = true;
 	}
-	device->flags.visited = false;
+
 	ret = acpi_scan_attach_handler(device);
 	if (ret < 0)
 		return;
@@ -1780,7 +1782,6 @@ static void acpi_bus_attach(struct acpi_device *device)
 		if (!ret && device->pnp.type.platform_id)
 			acpi_default_enumeration(device);
 	}
-	device->flags.visited = true;
 
  ok:
 	list_for_each_entry(child, &device->children, node)
@@ -1872,7 +1873,7 @@ void acpi_bus_trim(struct acpi_device *adev)
 	 */
 	acpi_device_set_power(adev, ACPI_STATE_D3_COLD);
 	adev->flags.initialized = false;
-	adev->flags.visited = false;
+	acpi_device_clear_enumerated(adev);
 }
 EXPORT_SYMBOL_GPL(acpi_bus_trim);
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 288fac5..7089e99 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -532,6 +532,16 @@ void acpi_walk_dep_device_list(acpi_handle handle);
 struct platform_device *acpi_create_platform_device(struct acpi_device *);
 #define ACPI_PTR(_ptr)	(_ptr)
 
+static inline void acpi_device_set_enumerated(struct acpi_device *adev)
+{
+	adev->flags.visited = true;
+}
+
+static inline void acpi_device_clear_enumerated(struct acpi_device *adev)
+{
+	adev->flags.visited = false;
+}
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -678,6 +688,14 @@ static inline enum dev_dma_attr acpi_get_dma_attr(struct acpi_device *adev)
 
 #define ACPI_PTR(_ptr)	(NULL)
 
+static inline void acpi_device_set_enumerated(struct acpi_device *adev)
+{
+}
+
+static inline void acpi_device_clear_enumerated(struct acpi_device *adev)
+{
+}
+
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI
-- 
2.7.4
