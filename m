From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 02/10] acpi: install SSDT tables from initrd
Date: Thu, 31 Mar 2016 12:36:58 +0300
Message-ID: <1459417026-6697-3-git-send-email-octavian.purdila@intel.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

This patch allows loading user defined SSDTs from the first,
uncompressed, initrd. The SSDT aml code must be stored in files under
the /kernel/firmware/acpi/overlay path.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/acpi/ssdt-overlays.txt | 94 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/bus.c                   | 63 ++++++++++++++++++++++++
 2 files changed, 157 insertions(+)
 create mode 100644 Documentation/acpi/ssdt-overlays.txt

diff --git a/Documentation/acpi/ssdt-overlays.txt b/Documentation/acpi/ssdt-overlays.txt
new file mode 100644
index 0000000..a94c3f9
--- /dev/null
+++ b/Documentation/acpi/ssdt-overlays.txt
@@ -0,0 +1,94 @@
+
+In order to support ACPI open-ended hardware configurations (e.g. development
+boards) we need a way to augment the ACPI configuration provided by the firmware
+image. A common example is connecting sensors on I2C / SPI buses on development
+boards.
+
+Although this can be accomplished by creating a kernel platform driver or
+recompiling the firmware image with updated ACPI tables, neither is practical:
+the former proliferates board specific kernel code while the latter requires
+access to firmware tools which are often not publicly available.
+
+Because ACPI supports external references in AML code a more practical
+way to augment firmware ACPI configuration is by dynamically loading
+user defined SSDT tables that contain the board specific information.
+
+For example, to enumerate a Bosch BMA222E accelerometer on the I2C bus of the
+Minnowboard MAX development board exposed via the LSE connector [1], the
+following ASL code can be used:
+
+DefinitionBlock ("minnowmax.aml", "SSDT", 1, "Vendor", "Accel", 0x00000003)
+{
+    External (\_SB.I2C6, DeviceObj)
+
+    Scope (\_SB.I2C6)
+    {
+        Device (STAC)
+        {
+            Name (_ADR, Zero)
+            Name (_HID, "BMA222E")
+
+            Method (_CRS, 0, Serialized)
+            {
+                Name (RBUF, ResourceTemplate ()
+                {
+                    I2cSerialBus (0x0018, ControllerInitiated, 0x00061A80,
+                                  AddressingMode7Bit, "\\_SB.I2C6", 0x00,
+                                  ResourceConsumer, ,)
+                    GpioInt (Edge, ActiveHigh, Exclusive, PullDown, 0x0000,
+                             "\\_SB.GPO2", 0x00, ResourceConsumer, , )
+                    { // Pin list
+                        0
+                    }
+                })
+                Return (RBUF)
+            }
+        }
+    }
+}
+
+which can then be compiled to AML binary format:
+
+$ iasl minnowmax.asl
+
+Intel ACPI Component Architecture
+ASL Optimizing Compiler version 20140214-64 [Mar 29 2014]
+Copyright (c) 2000 - 2014 Intel Corporation
+
+ASL Input:     minnomax.asl - 30 lines, 614 bytes, 7 keywords
+AML Output:    minnowmax.aml - 165 bytes, 6 named objects, 1 executable opcodes
+
+[1] http://wiki.minnowboard.org/MinnowBoard_MAX#Low_Speed_Expansion_Connector_.28Top.29
+
+The resulting AML code can then be loaded by the kernel using one of the methods
+below.
+
+== Loading ACPI SSDTs from initrd ==
+
+This option allows loading of user defined SSDTs from initrd and it is useful
+when the system does not support EFI or when there is not enough EFI storage.
+
+It works in a similar way with initrd based ACPI tables overrides: SSDT aml code
+must be placed in the first, uncompressed, initrd under the
+"kernel/firmware/acpi/overlay" path. We use a different path than the initrd
+tables override to avoid conflicts with the override feature.
+
+Multiple files can be used and this will translate in loading multiple
+tables. Only tables with the SSDT signature will be loaded.
+
+Here is an example:
+
+# Add the raw ACPI tables to an uncompressed cpio archive.
+# They must be put into a /kernel/firmware/acpi/overlay directory inside the
+# cpio archive.
+# The uncompressed cpio archive must be the first.
+# Other, typically compressed cpio archives, must be
+# concatenated on top of the uncompressed one.
+mkdir -p kernel/firmware/acpi
+cp ssdt.aml kernel/firmware/acpi
+
+# Create the uncompressed cpio archive and concatenate the original initrd
+# on top:
+find kernel | cpio -H newc --create > /boot/instrumented_initrd
+cat /boot/initrd >>/boot/instrumented_initrd
+
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 891c42d..5e0d076 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -37,9 +37,14 @@
 #include <acpi/apei.h>
 #include <linux/dmi.h>
 #include <linux/suspend.h>
+#include <linux/initrd.h>
+#include <linux/earlycpio.h>
 
 #include "internal.h"
 
+#undef pr_fmt
+#define pr_fmt(fmt) "ACPI: " fmt
+
 #define _COMPONENT		ACPI_BUS_COMPONENT
 ACPI_MODULE_NAME("bus");
 
@@ -863,6 +868,62 @@ static int __init acpi_bus_init_irq(void)
 	return 0;
 }
 
+void __init acpi_load_initrd_ssdts(void)
+{
+	void *data = (void *)initrd_start;
+	int size = initrd_end - initrd_start;
+	const char *path = "kernel/firmware/acpi/overlay";
+	long offset = 0;
+	struct cpio_data file;
+	struct acpi_table_header *header;
+	void *table;
+	acpi_status status;
+
+	while (true) {
+		file = find_cpio_data(path, data, size, &offset);
+		if (!file.data)
+			break;
+
+		data += offset;
+		size -= offset;
+
+		if (file.size < sizeof(struct acpi_table_header)) {
+			pr_err("initrd table smaller than ACPI header [%s%s]\n",
+			       path, file.name);
+			continue;
+		}
+
+		header = file.data;
+
+		if (file.size != header->length) {
+			pr_err("initrd file / table length mismatch [%s%s]\n",
+			       path, file.name);
+			continue;
+		}
+
+		if (memcmp(header->signature, ACPI_SIG_SSDT, 4)) {
+			pr_warn("skipping non-SSDT initrd table [%s%s]\n",
+				path, file.name);
+			continue;
+		}
+
+		table = kmemdup(file.data, file.size, GFP_KERNEL);
+		if (!table)
+			continue;
+
+		status = acpi_install_table((uintptr_t)table, 0);
+		if (ACPI_FAILURE(status)) {
+			pr_err("failed to install SSDT from initrd [%s%s]\n",
+			       path, file.name);
+			kfree(table);
+		}
+
+		pr_info("installed SSDT table found in initrd [%s%s][0x%x]\n",
+			path, file.name, header->length);
+		add_taint(TAINT_OVERLAY_ACPI_TABLE, LOCKDEP_STILL_OK);
+	}
+}
+
 /**
  * acpi_early_init - Initialize ACPICA and populate the ACPI namespace.
  *
@@ -911,6 +972,8 @@ void __init acpi_early_init(void)
 		goto error0;
 	}
 
+	acpi_load_initrd_ssdts();
+
 	status = acpi_load_tables();
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX
-- 
1.9.1
