From: Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5/6] efi: Assign Apple device properties
Date: Wed, 27 Jul 2016 13:20:41 +0200
Message-ID: <a0edd928ab099682c2cb4c4544c599573144d03a.1469616641.git.lukas@wunner.de>
References: <cover.1469616641.git.lukas@wunner.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1469616641.git.lukas@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>, Pierre Moreau <pierre.morrow@free.fr>, reverser@put.as
List-Id: linux-efi@vger.kernel.org

We've just extended the efistub to retrieve device properties from EFI
on Apple Macs and stash them in a setup_data payload.

Unmarshal that payload and assign the properties to their devices.

The property names and values are copied from the setup_data payload to
swappable virtual memory. The payload is afterwards made available to
the page allocator. This is just for the sake of good housekeeping, it
wouldn't occupy a meaningful amount of physical memory (4444 bytes on my
machine). Only the payload is freed, not the setup_data header since
otherwise we'd break the list linkage and we cannot safely update the
predecessor's ->next link since there's no locking for the list.

Most buses instantiate devices in "subsys" initcall level. Drivers are
usually bound to these devices in "device" initcall level. Assign the
properties in-between, i.e. in "fs" initcall level.

This assumes that devices to which properties pertain are instantiated
from a "subsys" initcall or earlier. That should always be the case
since on macOS, AppleACPIPlatformExpert::matchEFIDevicePath() only
supports ACPI and PCI nodes and we've fully scanned those buses during
"subsys" initcall level.

The second assumption is that properties are only needed from a "device"
initcall or later. Seems reasonable to me, but should this ever not work
out, an alternative approach would be to store the property sets e.g. in
a btree early during boot. Then whenever device_add() is called, an EFI
Device Path would have to be constructed for the newly added device,
and looked up in the btree. That way, the property set could be assigned
to the device immediately on instantiation. And this would also work for
devices instantiated in a deferred fashion. It seems like this approach
would be more complicated and require more code. That doesn't seem
justified without a specific use case.

For comparison, the strategy on macOS is to assign properties to objects
in the ACPI namespace (AppleACPIPlatformExpert::mergeEFIProperties()).
That approach is definitely wrong as it fails for devices not present in
the namespace: The NHI EFI driver supplies properties for attached
Thunderbolt devices, yet on Macs with Thunderbolt 1 only one device level
behind the host controller is described in the namespace. Consequently
macOS cannot assign properties for chained devices. With Thunderbolt 2
they started to describe three device levels behind host controllers in
the namespace. This grossly inflates the ACPI table and still fails if
the user daisy-chained more than three devices.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Andreas Noever <andreas.noever@gmail.com>
Tested-by: Lukas Wunner <lukas@wunner.de> [MacBookPro9,1]
Tested-by: Pierre Moreau <pierre.morrow@free.fr> [MacBookPro11,3]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 Documentation/kernel-parameters.txt     |   5 +
 drivers/firmware/efi/Kconfig            |  11 ++
 drivers/firmware/efi/Makefile           |   1 +
 drivers/firmware/efi/apple-properties.c | 219 ++++++++++++++++++++++++++++++++
 4 files changed, 236 insertions(+)
 create mode 100644 drivers/firmware/efi/apple-properties.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 82b42c9..d693fc3d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -993,6 +993,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	dscc4.setup=	[NET]
 
+	dump_apple_properties	[X86]
+			Dump name and content of EFI device properties on
+			x86 Macs.  Useful for driver authors to determine
+			what data is available or for reverse-engineering.
+
 	dyndbg[="val"]		[KNL,DYNAMIC_DEBUG]
 	module.dyndbg[="val"]
 			Enable debug messages at boot time.  See
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 6ffafd2..df53e80 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -112,6 +112,17 @@ config EFI_CAPSULE_LOADER
 
 	  Most users should say N.
 
+config APPLE_PROPERTIES
+	bool "Apple Device Properties"
+	depends on EFI_STUB && X86
+	select EFI_DEV_PATH_PARSER
+	select UCS2_STRING
+	---help---
+	  Retrieve properties from EFI on Apple Macs and assign them to
+	  devices, allowing for improved support of Apple hardware.
+	  Properties that would otherwise be missing include the
+	  Thunderbolt Device ROM and GPU configuration data.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 85dcbae..dfc51e6 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_EFI_STUB)			+= libstub/
 obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
 obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
 obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
+obj-$(CONFIG_APPLE_PROPERTIES)		+= apple-properties.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
new file mode 100644
index 0000000..ff7b31d
--- /dev/null
+++ b/drivers/firmware/efi/apple-properties.c
@@ -0,0 +1,219 @@
+/*
+ * apple-properties.c - EFI device properties on Macs
+ * Copyright (C) 2016 Lukas Wunner <lukas@wunner.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2) as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) "apple-properties: " fmt
+
+#include <linux/bootmem.h>
+#include <linux/dmi.h>
+#include <linux/efi.h>
+#include <linux/property.h>
+#include <linux/slab.h>
+#include <linux/ucs2_string.h>
+#include <asm/setup.h>
+
+struct dev_header {
+	u32 len;
+	u32 prop_count;
+	struct efi_dev_path path[0];
+	/*
+	 * followed by key/value pairs, each key and value preceded by u32 len,
+	 * len includes itself, value may be empty (in which case its len is 4)
+	 */
+};
+
+struct properties_header {
+	u32 len;
+	u32 version;
+	u32 dev_count;
+	struct dev_header dev_header[0];
+};
+
+
+static bool __initdata dump_properties = false;
+
+static int __init dump_properties_enable(char *arg)
+{
+	dump_properties = true;
+	return 0;
+}
+
+__setup("dump_apple_properties", dump_properties_enable);
+
+
+static u8 __initdata one = 1;
+
+static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
+					     struct device *dev, void *ptr,
+					     struct property_entry entry[])
+{
+	int i;
+
+	for (i = 0; i < dev_header->prop_count; i++) {
+		int remaining = dev_header->len - (ptr - (void *)dev_header);
+		u32 key_len, val_len;
+		char *key;
+
+		if (sizeof(key_len) > remaining)
+			break;
+		key_len = *(typeof(key_len) *)ptr;
+		if (key_len + sizeof(val_len) > remaining ||
+		    key_len < sizeof(key_len) + sizeof(efi_char16_t) ||
+		    *(efi_char16_t *)(ptr + sizeof(key_len)) == 0) {
+			dev_err(dev, "invalid property name len at %#zx\n",
+				ptr - (void *)dev_header);
+			break;
+		}
+		val_len = *(typeof(val_len) *)(ptr + key_len);
+		if (key_len + val_len > remaining ||
+		    val_len < sizeof(val_len)) {
+			dev_err(dev, "invalid property val len at %#zx\n",
+				ptr - (void *)dev_header + key_len);
+			break;
+		}
+
+		key = kzalloc((key_len - sizeof(key_len)) * 4 + 1, GFP_KERNEL);
+		if (!key) {
+			dev_err(dev, "cannot allocate property name\n");
+			break;
+		}
+		ucs2_as_utf8(key, ptr + sizeof(key_len),
+			     key_len - sizeof(key_len));
+
+		entry[i].name = key;
+		entry[i].is_array = true;
+		entry[i].length = val_len - sizeof(val_len);
+		entry[i].pointer.raw_data = ptr + key_len + sizeof(val_len);
+		if (!entry[i].length) {
+			/* driver core doesn't accept empty properties */
+			entry[i].length = 1;
+			entry[i].pointer.raw_data = &one;
+		}
+
+		ptr += key_len + val_len;
+
+		if (dump_properties) {
+			dev_info(dev, "property: %s\n", entry[i].name);
+			print_hex_dump(KERN_INFO, pr_fmt(), DUMP_PREFIX_OFFSET,
+				16, 1, entry[i].pointer.raw_data,
+				entry[i].length, true);
+		}
+	}
+
+	if (i != dev_header->prop_count) {
+		dev_err(dev, "got %d device properties, expected %u\n", i,
+			dev_header->prop_count);
+		print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
+			16, 1, dev_header, dev_header->len, true);
+	} else
+		dev_info(dev, "assigning %d device properties\n", i);
+}
+
+static int __init unmarshal_devices(struct properties_header *properties)
+{
+	size_t offset = offsetof(struct properties_header, dev_header[0]);
+
+	while (offset + sizeof(struct dev_header) < properties->len) {
+		struct dev_header *dev_header = (void *)properties + offset;
+		struct property_entry *entry = NULL;
+		struct device *dev;
+		int ret, i;
+		void *ptr;
+
+		if (offset + dev_header->len > properties->len) {
+			pr_err("invalid len in dev_header at %#lx\n", offset);
+			return -EINVAL;
+		}
+
+		ptr = dev_header->path;
+		ret = get_device_by_efi_path((struct efi_dev_path **)&ptr,
+			       dev_header->len - sizeof(*dev_header), &dev);
+		if (ret) {
+			pr_err("device path parse error %d at %#zx:\n", ret,
+			       ptr - (void *)dev_header);
+			print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
+			       16, 1, dev_header, dev_header->len, true);
+			goto skip_device;
+		}
+
+		entry = kcalloc(dev_header->prop_count + 1, sizeof(*entry),
+				GFP_KERNEL);
+		if (!entry) {
+			dev_err(dev, "cannot allocate properties\n");
+			goto skip_device;
+		}
+
+		unmarshal_key_value_pairs(dev_header, dev, ptr, entry);
+		if (!entry[0].name)
+			goto skip_device;
+
+		ret = device_add_properties(dev, entry); /* makes deep copy */
+		if (ret)
+			dev_err(dev, "error %d assigning properties\n", ret);
+		for (i = 0; entry[i].name; i++)
+			kfree(entry[i].name);
+
+skip_device:
+		kfree(entry);
+		put_device(dev);
+		offset += dev_header->len;
+	}
+
+	return 0;
+}
+
+static int __init map_properties(void)
+{
+	struct setup_data *data;
+	u32 data_len;
+	u64 pa_data;
+	int ret;
+
+	if (!dmi_match(DMI_SYS_VENDOR, "Apple Inc.") &&
+	    !dmi_match(DMI_SYS_VENDOR, "Apple Computer, Inc."))
+		return -ENODEV;
+
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = ioremap(pa_data, sizeof(*data));
+		if (!data) {
+			pr_err("cannot map setup_data header\n");
+			return -ENOMEM;
+		}
+
+		if (data->type != SETUP_APPLE_PROPERTIES) {
+			pa_data = data->next;
+			iounmap(data);
+			continue;
+		}
+
+		data_len = data->len;
+		iounmap(data);
+		data = ioremap(pa_data, sizeof(*data) + data_len);
+		if (!data) {
+			pr_err("cannot map setup_data payload\n");
+			return -ENOMEM;
+		}
+		ret = unmarshal_devices((struct properties_header *)data->data);
+		data->len = 0;
+		iounmap(data);
+		free_bootmem_late(pa_data + sizeof(*data), data_len);
+		return ret;
+	}
+	return 0;
+}
+
+fs_initcall(map_properties);
-- 
2.8.1
