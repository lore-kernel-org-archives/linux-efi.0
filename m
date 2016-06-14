From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 2/8] acpi: fix enumeration (visited) flags for bus rescans
Date: Tue, 14 Jun 2016 18:17:20 +0300
Message-ID: <1465917446-14043-3-git-send-email-octavian.purdila@intel.com>
References: <1465917446-14043-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465917446-14043-1-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J . Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Cc: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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

Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/acpi/scan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 5f28cf7..7656ea4 100644
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
2.7.4
