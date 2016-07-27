From: Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6/6] thunderbolt: Use Device ROM retrieved from EFI
Date: Wed, 27 Jul 2016 13:20:41 +0200
Message-ID: <8743c01825c3d16f812acec7525e5c87f4eed37a.1469616641.git.lukas@wunner.de>
References: <cover.1469616641.git.lukas@wunner.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1469616641.git.lukas@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>, Pierre Moreau <pierre.morrow@free.fr>, reverser@put.as
List-Id: linux-efi@vger.kernel.org

Macs with Thunderbolt 1 do not have a unit-specific DROM: The DROM is
empty with uid 0x1000000000000. (Apple started factory-burning a unit-
specific DROM with Thunderbolt 2.)

Instead, the NHI EFI driver supplies a DROM in a device property. Use
it if available. It's only available when booting with the efistub.
If it's not available, silently fall back to our hardcoded DROM.

The size of the DROM is always 256 bytes. The number is hardcoded into
the NHI EFI driver. This commit can deal with an arbitrary size however,
just in case they ever change that.

A modification is needed in the resume code where we currently read the
uid of all switches in the hierarchy to detect plug events that occurred
during sleep. On Thunderbolt 1 root switches this will now lead to a
mismatch between the uid of the empty DROM and the EFI DROM. Exempt the
root switch from this check: It's built in, so the uid should never
change. However we continue to *read* the uid of the root switch, this
seems like a good way to test its reachability after resume.

Background information: The EFI firmware volume contains ROM files for
the NHI, GMUX and several other chips as well as key material. Drivers
do not access those files directly but rather through a file server via
protocol AC5E4829-A8FD-440B-AF33-9FFE013B12D8. Files are identified by
GUID, the NHI DROM has 339370BD-CFC6-4454-8EF7-704653120818.

The NHI EFI driver amends that file with a unit-specific uid. The uid
has 64 bit but its entropy is much lower: 24 bit represent the model,
24 bit are taken from a serial number, 16 bit are fixed. The NHI EFI
driver obtains the serial number via the DataHub protocol, copies it
into the DROM, calculates the CRC and submits the result as a device
property.

Cc: reverser@put.as
Cc: Andreas Noever <andreas.noever@gmail.com>
Tested-by: Lukas Wunner <lukas@wunner.de> [MacBookPro9,1]
Tested-by: Pierre Moreau <pierre.morrow@free.fr> [MacBookPro11,3]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/thunderbolt/Kconfig  |  1 +
 drivers/thunderbolt/eeprom.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/switch.c |  2 +-
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
index c121acc..0056df7 100644
--- a/drivers/thunderbolt/Kconfig
+++ b/drivers/thunderbolt/Kconfig
@@ -1,6 +1,7 @@
 menuconfig THUNDERBOLT
 	tristate "Thunderbolt support for Apple devices"
 	depends on PCI
+	select APPLE_PROPERTIES
 	select CRC32
 	help
 	  Cactus Ridge Thunderbolt Controller driver
diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 2b9602c..785a171 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/crc32.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include "tb.h"
 
@@ -360,6 +361,39 @@ static int tb_drom_parse_entries(struct tb_switch *sw)
 }
 
 /**
+ * tb_drom_copy_efi - copy drom supplied by EFI to sw->drom if present
+ */
+static int tb_drom_copy_efi(struct tb_switch *sw, u16 *size)
+{
+	struct device *dev = &sw->tb->nhi->pdev->dev;
+	int len, res;
+
+	len = device_property_read_u8_array(dev, "ThunderboltDROM", NULL, 0);
+	if (len < 0 || len < sizeof(struct tb_drom_header))
+		return -EINVAL;
+
+	sw->drom = kmalloc(len, GFP_KERNEL);
+	if (!sw->drom)
+		return -ENOMEM;
+
+	res = device_property_read_u8_array(dev, "ThunderboltDROM", sw->drom,
+									len);
+	if (res)
+		goto err;
+
+	*size = ((struct tb_drom_header *)sw->drom)->data_len +
+							  TB_DROM_DATA_START;
+	if (*size > len)
+		goto err;
+
+	return 0;
+
+err:
+	kfree(sw->drom);
+	return -EINVAL;
+}
+
+/**
  * tb_drom_read - copy drom to sw->drom and parse it
  */
 int tb_drom_read(struct tb_switch *sw)
@@ -374,6 +408,13 @@ int tb_drom_read(struct tb_switch *sw)
 
 	if (tb_route(sw) == 0) {
 		/*
+		 * Apple's NHI EFI driver supplies a DROM for the root switch
+		 * in a device property. Use it if available.
+		 */
+		if (tb_drom_copy_efi(sw, &size) == 0)
+			goto parse;
+
+		/*
 		 * The root switch contains only a dummy drom (header only,
 		 * no entries). Hardcode the configuration here.
 		 */
@@ -418,6 +459,7 @@ int tb_drom_read(struct tb_switch *sw)
 	if (res)
 		goto err;
 
+parse:
 	header = (void *) sw->drom;
 
 	if (header->data_len + TB_DROM_DATA_START != size) {
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 1e116f5..91804b8 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -458,7 +458,7 @@ int tb_switch_resume(struct tb_switch *sw)
 		tb_sw_warn(sw, "uid read failed\n");
 		return err;
 	}
-	if (sw->uid != uid) {
+	if (tb_route(sw) != 0 && sw->uid != uid) {
 		tb_sw_info(sw,
 			"changed while suspended (uid %#llx -> %#llx)\n",
 			sw->uid, uid);
-- 
2.8.1
