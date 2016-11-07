From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v4 3/4] x86/efi: Retrieve and assign Apple device properties
Date: Mon, 7 Nov 2016 11:09:00 +0100
Message-ID: <452042a67c72e181ace915ab4849a219c8301f13.1478506920.git.lukas@wunner.de>
References: <cover.1478506920.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1478506920.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Apple's EFI drivers supply device properties which are needed to support
Macs optimally. They contain vital information which cannot be obtained
any other way (e.g. Thunderbolt Device ROM). They're also used to convey
the current device state so that OS drivers can pick up where EFI
drivers left (e.g. GPU mode setting).

There's an EFI driver dubbed "AAPL,PathProperties" which implements a
per-device key/value store. Other EFI drivers populate it using a custom
protocol. The macOS bootloader /System/Library/CoreServices/boot.efi
retrieves the properties with the same protocol. The kernel extension
AppleACPIPlatform.kext subsequently merges them into the I/O Kit
registry (see ioreg(8)) where they can be queried by other kernel
extensions and user space.

This commit extends the efistub to retrieve the device properties before
ExitBootServices is called. It assigns them to devices in an fs_initcall
so that they can be queried with the API in <linux/property.h>.

Note that the device properties will only be available if the kernel is
booted with the efistub. Distros should adjust their installers to
always use the efistub on Macs. grub with the "linux" directive will not
work unless the functionality of this commit is duplicated in grub.
(The "linuxefi" directive should work but is not included upstream as of
this writing.)

The custom protocol has GUID 91BD12FE-F6C3-44FB-A5B7-5122AB303AE0 and
looks like this:

typedef struct {
	unsigned long version; /* 0x10000 */
	efi_status_t (*get) (
		IN	struct apple_properties_protocol *this,
		IN	struct efi_dev_path *device,
		IN	efi_char16_t *property_name,
		OUT	void *buffer,
		IN OUT	u32 *buffer_len);
		/* EFI_SUCCESS, EFI_NOT_FOUND, EFI_BUFFER_TOO_SMALL */
	efi_status_t (*set) (
		IN	struct apple_properties_protocol *this,
		IN	struct efi_dev_path *device,
		IN	efi_char16_t *property_name,
		IN	void *property_value,
		IN	u32 property_value_len);
		/* allocates copies of property name and value */
		/* EFI_SUCCESS, EFI_OUT_OF_RESOURCES */
	efi_status_t (*del) (
		IN	struct apple_properties_protocol *this,
		IN	struct efi_dev_path *device,
		IN	efi_char16_t *property_name);
		/* EFI_SUCCESS, EFI_NOT_FOUND */
	efi_status_t (*get_all) (
		IN	struct apple_properties_protocol *this,
		OUT	void *buffer,
		IN OUT	u32 *buffer_len);
		/* EFI_SUCCESS, EFI_BUFFER_TOO_SMALL */
} apple_properties_protocol;

Thanks to Pedro Vilaça for this blog post which was helpful in reverse
engineering Apple's EFI drivers and bootloader:
https://reverse.put.as/2016/06/25/apple-efi-firmware-passwords-and-the-scbo-myth/

If someone at Apple is reading this, please note there's a memory leak
in your implementation of the del() function as the property struct is
freed but the name and value allocations are not.

Neither the macOS bootloader nor Apple's EFI drivers check the protocol
version, but we do to avoid breakage if it's ever changed. It's been the
same since at least OS X 10.6 (2009).

The get_all() function conveniently fills a buffer with all properties
in marshalled form which can be passed to the kernel as a setup_data
payload. The number of device properties is dynamic and can change
between a first invocation of get_all() (to determine the buffer size)
and a second invocation (to retrieve the actual buffer), hence the
peculiar loop which does not finish until the buffer size settles.
The macOS bootloader does the same.

The setup_data payload is later on unmarshalled in an fs_initcall. The
idea is that most buses instantiate devices in "subsys" initcall level
and drivers are usually bound to these devices in "device" initcall
level, so we assign the properties in-between, i.e. in "fs" initcall
level.

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
Thunderbolt devices, yet on Macs with Thunderbolt 1 only one device
level behind the host controller is described in the namespace.
Consequently macOS cannot assign properties for chained devices. With
Thunderbolt 2 they started to describe three device levels behind host
controllers in the namespace but this grossly inflates the SSDT and
still fails if the user daisy-chained more than three devices.

We copy the property names and values from the setup_data payload to
swappable virtual memory and afterwards make the payload available to
the page allocator. This is just for the sake of good housekeeping, it
wouldn't occupy a meaningful amount of physical memory (4444 bytes on my
machine). Only the payload is freed, not the setup_data header since
otherwise we'd break the list linkage and we cannot safely update the
predecessor's ->next link because there's no locking for the list.

The payload is currently not passed on to kexec'ed kernels, same for PCI
ROMs retrieved by setup_efi_pci(). This can be added later if there is
demand by amending setup_efi_state(). The payload can then no longer be
made available to the page allocator of course.

Cc: grub-devel-mXXj517/zsQ@public.gmane.org
Cc: Pedro Vilaça <reverser-P1ImLx+pFc0@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> [MacBookPro9,1]
Tested-by: Pierre Moreau <pierre.morrow-GANU6spQydw@public.gmane.org> [MacBookPro11,3]
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 Documentation/kernel-parameters.txt     |   5 +
 arch/x86/boot/compressed/eboot.c        |  65 +++++++++
 arch/x86/include/uapi/asm/bootparam.h   |   1 +
 drivers/firmware/efi/Kconfig            |  13 ++
 drivers/firmware/efi/Makefile           |   1 +
 drivers/firmware/efi/apple-properties.c | 248 ++++++++++++++++++++++++++++++++
 include/linux/efi.h                     |  17 +++
 7 files changed, 350 insertions(+)
 create mode 100644 drivers/firmware/efi/apple-properties.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 37babf9..86a31df 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1062,6 +1062,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	dscc4.setup=	[NET]
 
+	dump_apple_properties	[X86]
+			Dump name and content of EFI device properties on
+			x86 Macs.  Useful for driver authors to determine
+			what data is available or for reverse-engineering.
+
 	dyndbg[="val"]		[KNL,DYNAMIC_DEBUG]
 	module.dyndbg[="val"]
 			Enable debug messages at boot time.  See
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index cc69e37..ff01c8f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -537,6 +537,69 @@ free_handle:
 	efi_call_early(free_pool, pci_handle);
 }
 
+static void retrieve_apple_device_properties(struct boot_params *boot_params)
+{
+	efi_guid_t guid = APPLE_PROPERTIES_PROTOCOL_GUID;
+	struct setup_data *data, *new;
+	efi_status_t status;
+	u32 size = 0;
+	void *p;
+
+	status = efi_call_early(locate_protocol, &guid, NULL, &p);
+	if (status != EFI_SUCCESS)
+		return;
+
+	if (efi_table_attr(apple_properties_protocol, version, p) != 0x10000) {
+		efi_printk(sys_table, "Unsupported properties proto version\n");
+		return;
+	}
+
+	efi_call_proto(apple_properties_protocol, get_all, p, NULL, &size);
+	if (!size)
+		return;
+
+	do {
+		status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+					size + sizeof(struct setup_data), &new);
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table,
+					"Failed to alloc mem for properties\n");
+			return;
+		}
+
+		status = efi_call_proto(apple_properties_protocol, get_all, p,
+					new->data, &size);
+
+		if (status == EFI_BUFFER_TOO_SMALL)
+			efi_call_early(free_pool, new);
+	} while (status == EFI_BUFFER_TOO_SMALL);
+
+	new->type = SETUP_APPLE_PROPERTIES;
+	new->len  = size;
+	new->next = 0;
+
+	data = (struct setup_data *)(unsigned long)boot_params->hdr.setup_data;
+	if (!data)
+		boot_params->hdr.setup_data = (unsigned long)new;
+	else {
+		while (data->next)
+			data = (struct setup_data *)(unsigned long)data->next;
+		data->next = (unsigned long)new;
+	}
+}
+
+static void setup_quirks(struct boot_params *boot_params)
+{
+	efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
+	efi_char16_t *fw_vendor = (efi_char16_t *)(unsigned long)
+		efi_table_attr(efi_system_table, fw_vendor, sys_table);
+
+	if (!memcmp(fw_vendor, apple, sizeof(apple))) {
+		if (IS_ENABLED(CONFIG_APPLE_PROPERTIES))
+			retrieve_apple_device_properties(boot_params);
+	}
+}
+
 static efi_status_t
 setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 {
@@ -1098,6 +1161,8 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	setup_efi_pci(boot_params);
 
+	setup_quirks(boot_params);
+
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				sizeof(*gdt), (void **)&gdt);
 	if (status != EFI_SUCCESS) {
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index c18ce67..b10bf31 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -7,6 +7,7 @@
 #define SETUP_DTB			2
 #define SETUP_PCI			3
 #define SETUP_EFI			4
+#define SETUP_APPLE_PROPERTIES		5
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 893fda4..2e78b0b 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -129,6 +129,19 @@ config EFI_TEST
 	  Say Y here to enable the runtime services support via /dev/efi_test.
 	  If unsure, say N.
 
+config APPLE_PROPERTIES
+	bool "Apple Device Properties"
+	depends on EFI_STUB && X86
+	select EFI_DEV_PATH_PARSER
+	select UCS2_STRING
+	help
+	  Retrieve properties from EFI on Apple Macs and assign them to
+	  devices, allowing for improved support of Apple hardware.
+	  Properties that would otherwise be missing include the
+	  Thunderbolt Device ROM and GPU configuration data.
+
+	  If unsure, say Y if you have a Mac.  Otherwise N.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 3e91ae3..ad67342 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
 obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
 obj-$(CONFIG_EFI_TEST)			+= test/
 obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
+obj-$(CONFIG_APPLE_PROPERTIES)		+= apple-properties.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
new file mode 100644
index 0000000..c473f4c
--- /dev/null
+++ b/drivers/firmware/efi/apple-properties.c
@@ -0,0 +1,248 @@
+/*
+ * apple-properties.c - EFI device properties on Macs
+ * Copyright (C) 2016 Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
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
+static bool dump_properties __initdata;
+
+static int __init dump_properties_enable(char *arg)
+{
+	dump_properties = true;
+	return 0;
+}
+
+__setup("dump_apple_properties", dump_properties_enable);
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
+static u8 one __initdata = 1;
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
+
+		key_len = *(typeof(key_len) *)ptr;
+		if (key_len + sizeof(val_len) > remaining ||
+		    key_len < sizeof(key_len) + sizeof(efi_char16_t) ||
+		    *(efi_char16_t *)(ptr + sizeof(key_len)) == 0) {
+			dev_err(dev, "invalid property name len at %#zx\n",
+				ptr - (void *)dev_header);
+			break;
+		}
+
+		val_len = *(typeof(val_len) *)(ptr + key_len);
+		if (key_len + val_len > remaining ||
+		    val_len < sizeof(val_len)) {
+			dev_err(dev, "invalid property val len at %#zx\n",
+				ptr - (void *)dev_header + key_len);
+			break;
+		}
+
+		/* 4 bytes to accommodate UTF-8 code points + null byte */
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
+		if (dump_properties) {
+			dev_info(dev, "property: %s\n", entry[i].name);
+			print_hex_dump(KERN_INFO, pr_fmt(), DUMP_PREFIX_OFFSET,
+				16, 1, entry[i].pointer.raw_data,
+				entry[i].length, true);
+		}
+
+		ptr += key_len + val_len;
+	}
+
+	if (i != dev_header->prop_count) {
+		dev_err(dev, "got %d device properties, expected %u\n", i,
+			dev_header->prop_count);
+		print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
+			16, 1, dev_header, dev_header->len, true);
+		return;
+	}
+
+	dev_info(dev, "assigning %d device properties\n", i);
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
+		size_t len;
+		int ret, i;
+		void *ptr;
+
+		if (offset + dev_header->len > properties->len ||
+		    dev_header->len <= sizeof(*dev_header)) {
+			pr_err("invalid len in dev_header at %#zx\n", offset);
+			return -EINVAL;
+		}
+
+		ptr = dev_header->path;
+		len = dev_header->len - sizeof(*dev_header);
+
+		dev = efi_get_device_by_path((struct efi_dev_path **)&ptr, &len);
+		if (IS_ERR(dev)) {
+			pr_err("device path parse error %ld at %#zx:\n",
+			       PTR_ERR(dev), ptr - (void *)dev_header);
+			print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
+			       16, 1, dev_header, dev_header->len, true);
+			dev = NULL;
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
+
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
+	struct properties_header *properties;
+	struct setup_data *data;
+	u32 data_len;
+	u64 pa_data;
+	int ret;
+
+	if (!dmi_match(DMI_SYS_VENDOR, "Apple Inc.") &&
+	    !dmi_match(DMI_SYS_VENDOR, "Apple Computer, Inc."))
+		return 0;
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
+
+		data = ioremap(pa_data, sizeof(*data) + data_len);
+		if (!data) {
+			pr_err("cannot map setup_data payload\n");
+			return -ENOMEM;
+		}
+
+		properties = (struct properties_header *)data->data;
+		if (properties->version != 1) {
+			pr_err("unsupported version:\n");
+			print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
+			       16, 1, properties, data_len, true);
+			ret = -ENOTSUPP;
+		} else if (properties->len != data_len) {
+			pr_err("length mismatch, expected %u\n", data_len);
+			print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
+			       16, 1, properties, data_len, true);
+			ret = -EINVAL;
+		} else
+			ret = unmarshal_devices(properties);
+
+		/*
+		 * Can only free the setup_data payload but not its header
+		 * to avoid breaking the chain of ->next pointers.
+		 */
+		data->len = 0;
+		iounmap(data);
+		free_bootmem_late(pa_data + sizeof(*data), data_len);
+
+		return ret;
+	}
+	return 0;
+}
+
+fs_initcall(map_properties);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2617672..a07a476 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -443,6 +443,22 @@ typedef struct {
 #define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO_16 0x20000
 #define EFI_PCI_IO_ATTRIBUTE_VGA_IO_16 0x40000
 
+typedef struct {
+	u32 version;
+	u32 get;
+	u32 set;
+	u32 del;
+	u32 get_all;
+} apple_properties_protocol_32_t;
+
+typedef struct {
+	u64 version;
+	u64 get;
+	u64 set;
+	u64 del;
+	u64 get_all;
+} apple_properties_protocol_64_t;
+
 /*
  * Types and defines for EFI ResetSystem
  */
@@ -592,6 +608,7 @@ void efi_native_runtime_setup(void);
 #define EFI_RNG_ALGORITHM_RAW			EFI_GUID(0xe43176d7, 0xb6e8, 0x4827,  0xb7, 0x84, 0x7f, 0xfd, 0xc4, 0xb6, 0x85, 0x61)
 #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID	EFI_GUID(0xdcfa911d, 0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
 #define EFI_CONSOLE_OUT_DEVICE_GUID		EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
+#define APPLE_PROPERTIES_PROTOCOL_GUID		EFI_GUID(0x91bd12fe, 0xf6c3, 0x44fb,  0xa5, 0xb7, 0x51, 0x22, 0xab, 0x30, 0x3a, 0xe0)
 
 /*
  * This GUID is used to pass to the kernel proper the struct screen_info
-- 
2.10.1
