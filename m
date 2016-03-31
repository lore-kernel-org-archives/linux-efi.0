From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 04/10] acpi: fix enumeration (visited) flags for bus rescans
Date: Thu, 31 Mar 2016 12:37:00 +0300
Message-ID: <1459417026-6697-5-git-send-email-octavian.purdila@intel.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
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

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/acpi/scan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index a7e476c..8f3fd37 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1670,7 +1670,7 @@ static int acpi_check_spi_i2c_slave(struct acpi_resource *ares, void *data)
 	return -1;
 }
 
-static void acpi_default_enumeration(struct acpi_device *device)
+static bool acpi_default_enumeration(struct acpi_device *device)
 {
 	struct list_head resource_list;
 	bool is_spi_i2c_slave = false;
@@ -1685,6 +1685,7 @@ static void acpi_default_enumeration(struct acpi_device *device)
 	acpi_dev_free_resource_list(&resource_list);
 	if (!is_spi_i2c_slave)
 		acpi_create_platform_device(device);
+	return !is_spi_i2c_slave;
 }
 
 static const struct acpi_device_id generic_device_ids[] = {
@@ -1744,6 +1745,7 @@ static void acpi_bus_attach(struct acpi_device *device)
 	struct acpi_device *child;
 	acpi_handle ejd;
 	int ret;
+	bool enumerated = true;
 
 	if (ACPI_SUCCESS(acpi_bus_get_ejd(device->handle, &ejd)))
 		register_dock_dependent_device(device, ejd);
@@ -1766,7 +1768,7 @@ static void acpi_bus_attach(struct acpi_device *device)
 
 		device->flags.initialized = true;
 	}
-	device->flags.visited = false;
+
 	ret = acpi_scan_attach_handler(device);
 	if (ret < 0)
 		return;
@@ -1778,9 +1780,10 @@ static void acpi_bus_attach(struct acpi_device *device)
 			return;
 
 		if (!ret && device->pnp.type.platform_id)
-			acpi_default_enumeration(device);
+			enumerated = acpi_default_enumeration(device);
 	}
-	device->flags.visited = true;
+	if (enumerated)
+		device->flags.visited = true;
 
  ok:
 	list_for_each_entry(child, &device->children, node)
-- 
1.9.1
