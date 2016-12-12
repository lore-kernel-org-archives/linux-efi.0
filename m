From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI changes for v4.10
Date: Mon, 12 Dec 2016 09:07:36 +0100
Message-ID: <20161212080736.GA5982@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest EFI tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: 018edcfac4c3b140366ad51b0907f3becb5bb624 efi/libstub: Make efi_random_alloc() allocate below 4 GB on 32-bit

The main changes in this development cycle were:

 - Implement EFI dev path parser and other changes to fully support thunderbolt
   devices on Apple Macbooks (Lukas Wunner)

 - Add RNG seeding via the EFI stub, on ARM/arm64 (Ard Biesheuvel)

 - Expose EFI framebuffer configuration to user-space, to improve tooling
   (Peter Jones)

 - Misc fixes and cleanups (Ivan Hu, Wei Yongjun, Yisheng Xie, Dan Carpenter,
   Roy Franz)

 Thanks,

	Ingo

------------------>

Dan Carpenter (1):
      efi/efivar_ssdt_load: Don't return success on allocation failure

Ivan Hu (3):
      efi/efi_test: Fix uninitialized variable 'datasize'
      efi/efi_test: Fix uninitialized variable 'rv'
      efi/efi_test: Use memdup_user() as a cleanup

Lukas Wunner (7):
      efi: Add device path parser
      efi: Allow bitness-agnostic protocol calls
      x86/efi: Retrieve and assign Apple device properties
      thunderbolt: Use Device ROM retrieved from EFI
      thunderbolt, efi: Fix Kconfig dependencies
      thunderbolt, efi: Fix Kconfig dependencies harder
      thunderbolt: Compile on x86 only

Peter Jones (1):
      efifb: Show framebuffer layout as device attributes

Roy Franz (1):
      efi/libstub: Fix allocation size calculations

Wei Yongjun (1):
      efi: Remove unused include of <linux/version.h>

Yisheng Xie (1):
      efi/arm*: Fix efi_init() error handling


 Documentation/kernel-parameters.txt            |   5 +
 MAINTAINERS                                    |   6 +-
 arch/arm/include/asm/efi.h                     |   3 +
 arch/arm64/include/asm/efi.h                   |   3 +
 arch/x86/boot/compressed/eboot.c               |  65 +++++++
 arch/x86/include/asm/efi.h                     |  16 +-
 arch/x86/include/uapi/asm/bootparam.h          |   1 +
 drivers/firmware/efi/Kconfig                   |  18 ++
 drivers/firmware/efi/Makefile                  |   2 +
 drivers/firmware/efi/apple-properties.c        | 248 +++++++++++++++++++++++++
 drivers/firmware/efi/arm-init.c                |   4 +-
 drivers/firmware/efi/dev-path-parser.c         | 203 ++++++++++++++++++++
 drivers/firmware/efi/efi.c                     |  76 +++++++-
 drivers/firmware/efi/libstub/Makefile          |   4 +-
 drivers/firmware/efi/libstub/arm-stub.c        |   2 +
 drivers/firmware/efi/libstub/efi-stub-helper.c |  33 ++--
 drivers/firmware/efi/libstub/efistub.h         |  11 ++
 drivers/firmware/efi/libstub/random.c          |  67 ++++++-
 drivers/firmware/efi/test/efi_test.c           |  15 +-
 drivers/thunderbolt/Kconfig                    |   2 +
 drivers/thunderbolt/eeprom.c                   |  43 +++++
 drivers/thunderbolt/switch.c                   |   2 +-
 drivers/video/fbdev/efifb.c                    |  59 ++++--
 include/linux/efi.h                            |  46 +++++
 24 files changed, 872 insertions(+), 62 deletions(-)
 create mode 100644 drivers/firmware/efi/apple-properties.c
 create mode 100644 drivers/firmware/efi/dev-path-parser.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 37babf91f2cb..86a31dfc036e 100644
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
diff --git a/MAINTAINERS b/MAINTAINERS
index 851b89b9edcb..afaf24f95f46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4631,12 +4631,14 @@ L:	linux-efi@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
 S:	Maintained
 F:	Documentation/efi-stub.txt
-F:	arch/ia64/kernel/efi.c
+F:	arch/*/kernel/efi.c
 F:	arch/x86/boot/compressed/eboot.[ch]
-F:	arch/x86/include/asm/efi.h
+F:	arch/*/include/asm/efi.h
 F:	arch/x86/platform/efi/
 F:	drivers/firmware/efi/
 F:	include/linux/efi*.h
+F:	arch/arm/boot/compressed/efi-header.S
+F:	arch/arm64/kernel/efi-entry.S
 
 EFI VARIABLE FILESYSTEM
 M:	Matthew Garrett <matthew.garrett@nebula.com>
diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 766bf9b78160..0b06f5341b45 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -57,6 +57,9 @@ void efi_virtmap_unload(void);
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
 #define efi_is_64bit()			(false)
 
+#define efi_call_proto(protocol, f, instance, ...)			\
+	((protocol##_t *)instance)->f(instance, ##__VA_ARGS__)
+
 struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg);
 void free_screen_info(efi_system_table_t *sys_table, struct screen_info *si);
 
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a9e54aad15ef..771b3f0bc757 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -51,6 +51,9 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
 #define efi_is_64bit()			(true)
 
+#define efi_call_proto(protocol, f, instance, ...)			\
+	((protocol##_t *)instance)->f(instance, ##__VA_ARGS__)
+
 #define alloc_screen_info(x...)		&screen_info
 #define free_screen_info(x...)
 
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index cc69e37548db..ff01c8fc76f7 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -537,6 +537,69 @@ static void setup_efi_pci(struct boot_params *params)
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
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 389d700b961e..e99675b9c861 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -210,12 +210,18 @@ static inline bool efi_is_64bit(void)
 	return __efi_early()->is64;
 }
 
+#define efi_table_attr(table, attr, instance)				\
+	(efi_is_64bit() ?						\
+		((table##_64_t *)(unsigned long)instance)->attr :	\
+		((table##_32_t *)(unsigned long)instance)->attr)
+
+#define efi_call_proto(protocol, f, instance, ...)			\
+	__efi_early()->call(efi_table_attr(protocol, f, instance),	\
+		instance, ##__VA_ARGS__)
+
 #define efi_call_early(f, ...)						\
-	__efi_early()->call(efi_is_64bit() ?				\
-		((efi_boot_services_64_t *)(unsigned long)		\
-			__efi_early()->boot_services)->f :		\
-		((efi_boot_services_32_t *)(unsigned long)		\
-			__efi_early()->boot_services)->f, __VA_ARGS__)
+	__efi_early()->call(efi_table_attr(efi_boot_services, f,	\
+		__efi_early()->boot_services), __VA_ARGS__)
 
 #define __efi_call_early(f, ...)					\
 	__efi_early()->call((unsigned long)f, __VA_ARGS__);
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index c18ce67495fa..b10bf319ed20 100644
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
index c981be17d3c0..2e78b0b96d74 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -129,7 +129,25 @@ config EFI_TEST
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
 	bool
+
+config EFI_DEV_PATH_PARSER
+	bool
+	depends on ACPI
+	default n
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index c8a439f6d715..ad67342313ed 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -21,6 +21,8 @@ obj-$(CONFIG_EFI_STUB)			+= libstub/
 obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
 obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
 obj-$(CONFIG_EFI_TEST)			+= test/
+obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
+obj-$(CONFIG_APPLE_PROPERTIES)		+= apple-properties.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
new file mode 100644
index 000000000000..c473f4c5ca34
--- /dev/null
+++ b/drivers/firmware/efi/apple-properties.c
@@ -0,0 +1,248 @@
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
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 8efe13075c92..f853ad2c4ca0 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -244,8 +244,10 @@ void __init efi_init(void)
 	     "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
 	      efi.memmap.desc_version);
 
-	if (uefi_init() < 0)
+	if (uefi_init() < 0) {
+		efi_memmap_unmap();
 		return;
+	}
 
 	reserve_regions();
 	efi_memattr_init();
diff --git a/drivers/firmware/efi/dev-path-parser.c b/drivers/firmware/efi/dev-path-parser.c
new file mode 100644
index 000000000000..85d1834ee9b7
--- /dev/null
+++ b/drivers/firmware/efi/dev-path-parser.c
@@ -0,0 +1,203 @@
+/*
+ * dev-path-parser.c - EFI Device Path parser
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
+#include <linux/acpi.h>
+#include <linux/efi.h>
+#include <linux/pci.h>
+
+struct acpi_hid_uid {
+	struct acpi_device_id hid[2];
+	char uid[11]; /* UINT_MAX + null byte */
+};
+
+static int __init match_acpi_dev(struct device *dev, void *data)
+{
+	struct acpi_hid_uid hid_uid = *(struct acpi_hid_uid *)data;
+	struct acpi_device *adev = to_acpi_device(dev);
+
+	if (acpi_match_device_ids(adev, hid_uid.hid))
+		return 0;
+
+	if (adev->pnp.unique_id)
+		return !strcmp(adev->pnp.unique_id, hid_uid.uid);
+	else
+		return !strcmp("0", hid_uid.uid);
+}
+
+static long __init parse_acpi_path(struct efi_dev_path *node,
+				   struct device *parent, struct device **child)
+{
+	struct acpi_hid_uid hid_uid = {};
+	struct device *phys_dev;
+
+	if (node->length != 12)
+		return -EINVAL;
+
+	sprintf(hid_uid.hid[0].id, "%c%c%c%04X",
+		'A' + ((node->acpi.hid >> 10) & 0x1f) - 1,
+		'A' + ((node->acpi.hid >>  5) & 0x1f) - 1,
+		'A' + ((node->acpi.hid >>  0) & 0x1f) - 1,
+			node->acpi.hid >> 16);
+	sprintf(hid_uid.uid, "%u", node->acpi.uid);
+
+	*child = bus_find_device(&acpi_bus_type, NULL, &hid_uid,
+				 match_acpi_dev);
+	if (!*child)
+		return -ENODEV;
+
+	phys_dev = acpi_get_first_physical_node(to_acpi_device(*child));
+	if (phys_dev) {
+		get_device(phys_dev);
+		put_device(*child);
+		*child = phys_dev;
+	}
+
+	return 0;
+}
+
+static int __init match_pci_dev(struct device *dev, void *data)
+{
+	unsigned int devfn = *(unsigned int *)data;
+
+	return dev_is_pci(dev) && to_pci_dev(dev)->devfn == devfn;
+}
+
+static long __init parse_pci_path(struct efi_dev_path *node,
+				  struct device *parent, struct device **child)
+{
+	unsigned int devfn;
+
+	if (node->length != 6)
+		return -EINVAL;
+	if (!parent)
+		return -EINVAL;
+
+	devfn = PCI_DEVFN(node->pci.dev, node->pci.fn);
+
+	*child = device_find_child(parent, &devfn, match_pci_dev);
+	if (!*child)
+		return -ENODEV;
+
+	return 0;
+}
+
+/*
+ * Insert parsers for further node types here.
+ *
+ * Each parser takes a pointer to the @node and to the @parent (will be NULL
+ * for the first device path node). If a device corresponding to @node was
+ * found below @parent, its reference count should be incremented and the
+ * device returned in @child.
+ *
+ * The return value should be 0 on success or a negative int on failure.
+ * The special return values 0x01 (EFI_DEV_END_INSTANCE) and 0xFF
+ * (EFI_DEV_END_ENTIRE) signal the end of the device path, only
+ * parse_end_path() is supposed to return this.
+ *
+ * Be sure to validate the node length and contents before commencing the
+ * search for a device.
+ */
+
+static long __init parse_end_path(struct efi_dev_path *node,
+				  struct device *parent, struct device **child)
+{
+	if (node->length != 4)
+		return -EINVAL;
+	if (node->sub_type != EFI_DEV_END_INSTANCE &&
+	    node->sub_type != EFI_DEV_END_ENTIRE)
+		return -EINVAL;
+	if (!parent)
+		return -ENODEV;
+
+	*child = get_device(parent);
+	return node->sub_type;
+}
+
+/**
+ * efi_get_device_by_path - find device by EFI Device Path
+ * @node: EFI Device Path
+ * @len: maximum length of EFI Device Path in bytes
+ *
+ * Parse a series of EFI Device Path nodes at @node and find the corresponding
+ * device.  If the device was found, its reference count is incremented and a
+ * pointer to it is returned.  The caller needs to drop the reference with
+ * put_device() after use.  The @node pointer is updated to point to the
+ * location immediately after the "End of Hardware Device Path" node.
+ *
+ * If another Device Path instance follows, @len is decremented by the number
+ * of bytes consumed.  Otherwise @len is set to %0.
+ *
+ * If a Device Path node is malformed or its corresponding device is not found,
+ * @node is updated to point to this offending node and an ERR_PTR is returned.
+ *
+ * If @len is initially %0, the function returns %NULL.  Thus, to iterate over
+ * all instances in a path, the following idiom may be used:
+ *
+ *	while (!IS_ERR_OR_NULL(dev = efi_get_device_by_path(&node, &len))) {
+ *		// do something with dev
+ *		put_device(dev);
+ *	}
+ *	if (IS_ERR(dev))
+ *		// report error
+ *
+ * Devices can only be found if they're already instantiated. Most buses
+ * instantiate devices in the "subsys" initcall level, hence the earliest
+ * initcall level in which this function should be called is "fs".
+ *
+ * Returns the device on success or
+ *	%ERR_PTR(-ENODEV) if no device was found,
+ *	%ERR_PTR(-EINVAL) if a node is malformed or exceeds @len,
+ *	%ERR_PTR(-ENOTSUPP) if support for a node type is not yet implemented.
+ */
+struct device * __init efi_get_device_by_path(struct efi_dev_path **node,
+					      size_t *len)
+{
+	struct device *parent = NULL, *child;
+	long ret = 0;
+
+	if (!*len)
+		return NULL;
+
+	while (!ret) {
+		if (*len < 4 || *len < (*node)->length)
+			ret = -EINVAL;
+		else if ((*node)->type     == EFI_DEV_ACPI &&
+			 (*node)->sub_type == EFI_DEV_BASIC_ACPI)
+			ret = parse_acpi_path(*node, parent, &child);
+		else if ((*node)->type     == EFI_DEV_HW &&
+			 (*node)->sub_type == EFI_DEV_PCI)
+			ret = parse_pci_path(*node, parent, &child);
+		else if (((*node)->type    == EFI_DEV_END_PATH ||
+			  (*node)->type    == EFI_DEV_END_PATH2))
+			ret = parse_end_path(*node, parent, &child);
+		else
+			ret = -ENOTSUPP;
+
+		put_device(parent);
+		if (ret < 0)
+			return ERR_PTR(ret);
+
+		parent = child;
+		*node  = (void *)*node + (*node)->length;
+		*len  -= (*node)->length;
+	}
+
+	if (ret == EFI_DEV_END_ENTIRE)
+		*len = 0;
+
+	return child;
+}
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 1ac199cd75e7..92914801e388 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -23,7 +23,10 @@
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/io.h>
+#include <linux/kexec.h>
 #include <linux/platform_device.h>
+#include <linux/random.h>
+#include <linux/reboot.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/ucs2_string.h>
@@ -48,6 +51,7 @@ struct efi __read_mostly efi = {
 	.esrt			= EFI_INVALID_TABLE_ADDR,
 	.properties_table	= EFI_INVALID_TABLE_ADDR,
 	.mem_attr_table		= EFI_INVALID_TABLE_ADDR,
+	.rng_seed		= EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -259,8 +263,10 @@ static __init int efivar_ssdt_load(void)
 		}
 
 		data = kmalloc(size, GFP_KERNEL);
-		if (!data)
+		if (!data) {
+			ret = -ENOMEM;
 			goto free_entry;
+		}
 
 		ret = efivar_entry_get(entry, NULL, &size, data);
 		if (ret) {
@@ -438,6 +444,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{EFI_SYSTEM_RESOURCE_TABLE_GUID, "ESRT", &efi.esrt},
 	{EFI_PROPERTIES_TABLE_GUID, "PROP", &efi.properties_table},
 	{EFI_MEMORY_ATTRIBUTES_TABLE_GUID, "MEMATTR", &efi.mem_attr_table},
+	{LINUX_EFI_RANDOM_SEED_TABLE_GUID, "RNG", &efi.rng_seed},
 	{NULL_GUID, NULL, NULL},
 };
 
@@ -499,6 +506,29 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 	pr_cont("\n");
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
 
+	if (efi.rng_seed != EFI_INVALID_TABLE_ADDR) {
+		struct linux_efi_random_seed *seed;
+		u32 size = 0;
+
+		seed = early_memremap(efi.rng_seed, sizeof(*seed));
+		if (seed != NULL) {
+			size = seed->size;
+			early_memunmap(seed, sizeof(*seed));
+		} else {
+			pr_err("Could not map UEFI random seed!\n");
+		}
+		if (size > 0) {
+			seed = early_memremap(efi.rng_seed,
+					      sizeof(*seed) + size);
+			if (seed != NULL) {
+				add_device_randomness(seed->bits, seed->size);
+				early_memunmap(seed, sizeof(*seed) + size);
+			} else {
+				pr_err("Could not map UEFI random seed!\n");
+			}
+		}
+	}
+
 	/* Parse the EFI Properties table if it exists */
 	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
 		efi_properties_table_t *tbl;
@@ -822,3 +852,47 @@ int efi_status_to_err(efi_status_t status)
 
 	return err;
 }
+
+#ifdef CONFIG_KEXEC
+static int update_efi_random_seed(struct notifier_block *nb,
+				  unsigned long code, void *unused)
+{
+	struct linux_efi_random_seed *seed;
+	u32 size = 0;
+
+	if (!kexec_in_progress)
+		return NOTIFY_DONE;
+
+	seed = memremap(efi.rng_seed, sizeof(*seed), MEMREMAP_WB);
+	if (seed != NULL) {
+		size = min(seed->size, 32U);
+		memunmap(seed);
+	} else {
+		pr_err("Could not map UEFI random seed!\n");
+	}
+	if (size > 0) {
+		seed = memremap(efi.rng_seed, sizeof(*seed) + size,
+				MEMREMAP_WB);
+		if (seed != NULL) {
+			seed->size = size;
+			get_random_bytes(seed->bits, seed->size);
+			memunmap(seed);
+		} else {
+			pr_err("Could not map UEFI random seed!\n");
+		}
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block efi_random_seed_nb = {
+	.notifier_call = update_efi_random_seed,
+};
+
+static int register_update_efi_random_seed(void)
+{
+	if (efi.rng_seed == EFI_INVALID_TABLE_ADDR)
+		return 0;
+	return register_reboot_notifier(&efi_random_seed_nb);
+}
+late_initcall(register_update_efi_random_seed);
+#endif
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 5e23e2d305e7..6621b13c370f 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -36,11 +36,11 @@ arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
-lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o \
+lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o random.o \
 				   $(patsubst %.c,lib-%.o,$(arm-deps))
 
 lib-$(CONFIG_ARM)		+= arm32-stub.o
-lib-$(CONFIG_ARM64)		+= arm64-stub.o random.o
+lib-$(CONFIG_ARM64)		+= arm64-stub.o
 CFLAGS_arm64-stub.o 		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 #
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 993aa56755f6..b4f7d78f9e8b 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -340,6 +340,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	if (status != EFI_SUCCESS)
 		pr_efi_err(sys_table, "Failed initrd from command line!\n");
 
+	efi_random_get_seed(sys_table);
+
 	new_fdt_addr = fdt_addr;
 	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
 				&new_fdt_addr, dram_base + MAX_FDT_OFFSET,
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index aded10662020..757badc1debb 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,15 +32,6 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
-/*
- * Allow the platform to override the allocation granularity: this allows
- * systems that have the capability to run with a larger page size to deal
- * with the allocations for initrd and fdt more efficiently.
- */
-#ifndef EFI_ALLOC_ALIGN
-#define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
-#endif
-
 #define EFI_MMAP_NR_SLACK_SLOTS	8
 
 struct file_info {
@@ -186,14 +177,16 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 		goto fail;
 
 	/*
-	 * Enforce minimum alignment that EFI requires when requesting
-	 * a specific address.  We are doing page-based allocations,
-	 * so we must be aligned to a page.
+	 * Enforce minimum alignment that EFI or Linux requires when
+	 * requesting a specific address.  We are doing page-based (or
+	 * larger) allocations, and both the address and size must meet
+	 * alignment constraints.
 	 */
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
+	size = round_up(size, EFI_ALLOC_ALIGN);
+	nr_pages = size / EFI_PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
@@ -208,7 +201,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
 
 		if (end > max)
 			end = max;
@@ -278,14 +271,16 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		goto fail;
 
 	/*
-	 * Enforce minimum alignment that EFI requires when requesting
-	 * a specific address.  We are doing page-based allocations,
-	 * so we must be aligned to a page.
+	 * Enforce minimum alignment that EFI or Linux requires when
+	 * requesting a specific address.  We are doing page-based (or
+	 * larger) allocations, and both the address and size must meet
+	 * alignment constraints.
 	 */
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
+	size = round_up(size, EFI_ALLOC_ALIGN);
+	nr_pages = size / EFI_PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
 		unsigned long m = (unsigned long)map;
@@ -300,7 +295,7 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
 
 		/*
 		 * Don't allocate at 0x0. It will confuse code that
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index ee49cd23ee63..b98824e3800a 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -15,6 +15,15 @@
  */
 #undef __init
 
+/*
+ * Allow the platform to override the allocation granularity: this allows
+ * systems that have the capability to run with a larger page size to deal
+ * with the allocations for initrd and fdt more efficiently.
+ */
+#ifndef EFI_ALLOC_ALIGN
+#define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
+#endif
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
@@ -62,4 +71,6 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg);
 
+efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg);
+
 #endif
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 0c9f58c5ba50..7e72954d5860 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/efi.h>
+#include <linux/log2.h>
 #include <asm/efi.h>
 
 #include "efistub.h"
@@ -41,21 +42,23 @@ efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table_arg,
  */
 static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
 					 unsigned long size,
-					 unsigned long align)
+					 unsigned long align_shift)
 {
-	u64 start, end;
+	unsigned long align = 1UL << align_shift;
+	u64 first_slot, last_slot, region_end;
 
 	if (md->type != EFI_CONVENTIONAL_MEMORY)
 		return 0;
 
-	start = round_up(md->phys_addr, align);
-	end = round_down(md->phys_addr + md->num_pages * EFI_PAGE_SIZE - size,
-			 align);
+	region_end = min((u64)ULONG_MAX, md->phys_addr + md->num_pages*EFI_PAGE_SIZE - 1);
 
-	if (start > end)
+	first_slot = round_up(md->phys_addr, align);
+	last_slot = round_down(region_end - size + 1, align);
+
+	if (first_slot > last_slot)
 		return 0;
 
-	return (end - start + 1) / align;
+	return ((unsigned long)(last_slot - first_slot) >> align_shift) + 1;
 }
 
 /*
@@ -98,7 +101,7 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 		efi_memory_desc_t *md = (void *)memory_map + map_offset;
 		unsigned long slots;
 
-		slots = get_entry_num_slots(md, size, align);
+		slots = get_entry_num_slots(md, size, ilog2(align));
 		MD_NUM_SLOTS(md) = slots;
 		total_slots += slots;
 	}
@@ -141,3 +144,51 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 
 	return status;
 }
+
+#define RANDOM_SEED_SIZE	32
+
+efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
+{
+	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
+	efi_guid_t rng_algo_raw = EFI_RNG_ALGORITHM_RAW;
+	efi_guid_t rng_table_guid = LINUX_EFI_RANDOM_SEED_TABLE_GUID;
+	struct efi_rng_protocol *rng;
+	struct linux_efi_random_seed *seed;
+	efi_status_t status;
+
+	status = efi_call_early(locate_protocol, &rng_proto, NULL,
+				(void **)&rng);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
+				sizeof(*seed) + RANDOM_SEED_SIZE,
+				(void **)&seed);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = rng->get_rng(rng, &rng_algo_raw, RANDOM_SEED_SIZE,
+			      seed->bits);
+	if (status == EFI_UNSUPPORTED)
+		/*
+		 * Use whatever algorithm we have available if the raw algorithm
+		 * is not implemented.
+		 */
+		status = rng->get_rng(rng, NULL, RANDOM_SEED_SIZE,
+				      seed->bits);
+
+	if (status != EFI_SUCCESS)
+		goto err_freepool;
+
+	seed->size = RANDOM_SEED_SIZE;
+	status = efi_call_early(install_configuration_table, &rng_table_guid,
+				seed);
+	if (status != EFI_SUCCESS)
+		goto err_freepool;
+
+	return EFI_SUCCESS;
+
+err_freepool:
+	efi_call_early(free_pool, seed);
+	return status;
+}
diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index f61bb52be318..8cd578f62059 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -8,7 +8,6 @@
  *
  */
 
-#include <linux/version.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -156,7 +155,7 @@ static long efi_runtime_get_variable(unsigned long arg)
 {
 	struct efi_getvariable __user *getvariable_user;
 	struct efi_getvariable getvariable;
-	unsigned long datasize, prev_datasize, *dz;
+	unsigned long datasize = 0, prev_datasize, *dz;
 	efi_guid_t vendor_guid, *vd = NULL;
 	efi_status_t status;
 	efi_char16_t *name = NULL;
@@ -266,14 +265,10 @@ static long efi_runtime_set_variable(unsigned long arg)
 			return rv;
 	}
 
-	data = kmalloc(setvariable.data_size, GFP_KERNEL);
-	if (!data) {
+	data = memdup_user(setvariable.data, setvariable.data_size);
+	if (IS_ERR(data)) {
 		kfree(name);
-		return -ENOMEM;
-	}
-	if (copy_from_user(data, setvariable.data, setvariable.data_size)) {
-		rv = -EFAULT;
-		goto out;
+		return PTR_ERR(data);
 	}
 
 	status = efi.set_variable(name, &vendor_guid,
@@ -429,7 +424,7 @@ static long efi_runtime_get_nextvariablename(unsigned long arg)
 	efi_guid_t *vd = NULL;
 	efi_guid_t vendor_guid;
 	efi_char16_t *name = NULL;
-	int rv;
+	int rv = 0;
 
 	getnextvariablename_user = (struct efi_getnextvariablename __user *)arg;
 
diff --git a/drivers/thunderbolt/Kconfig b/drivers/thunderbolt/Kconfig
index c121acc15bfe..d35db16aa43f 100644
--- a/drivers/thunderbolt/Kconfig
+++ b/drivers/thunderbolt/Kconfig
@@ -1,6 +1,8 @@
 menuconfig THUNDERBOLT
 	tristate "Thunderbolt support for Apple devices"
 	depends on PCI
+	depends on X86 || COMPILE_TEST
+	select APPLE_PROPERTIES if EFI_STUB && X86
 	select CRC32
 	help
 	  Cactus Ridge Thunderbolt Controller driver
diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 2b9602c2c355..6392990c984d 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/crc32.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 #include "tb.h"
 
@@ -360,6 +361,40 @@ static int tb_drom_parse_entries(struct tb_switch *sw)
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
+	sw->drom = NULL;
+	return -EINVAL;
+}
+
+/**
  * tb_drom_read - copy drom to sw->drom and parse it
  */
 int tb_drom_read(struct tb_switch *sw)
@@ -374,6 +409,13 @@ int tb_drom_read(struct tb_switch *sw)
 
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
@@ -418,6 +460,7 @@ int tb_drom_read(struct tb_switch *sw)
 	if (res)
 		goto err;
 
+parse:
 	header = (void *) sw->drom;
 
 	if (header->data_len + TB_DROM_DATA_START != size) {
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 9840fdecb73b..c6f30b1695a9 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -460,7 +460,7 @@ int tb_switch_resume(struct tb_switch *sw)
 		tb_sw_warn(sw, "uid read failed\n");
 		return err;
 	}
-	if (sw->uid != uid) {
+	if (sw != sw->tb->root_switch && sw->uid != uid) {
 		tb_sw_info(sw,
 			"changed while suspended (uid %#llx -> %#llx)\n",
 			sw->uid, uid);
diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 37a37c4d04cb..8c4dc1e1f94f 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -118,6 +118,31 @@ static inline bool fb_base_is_valid(void)
 	return false;
 }
 
+#define efifb_attr_decl(name, fmt)					\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr,		\
+			   char *buf)					\
+{									\
+	return sprintf(buf, fmt "\n", (screen_info.lfb_##name));	\
+}									\
+static DEVICE_ATTR_RO(name)
+
+efifb_attr_decl(base, "0x%x");
+efifb_attr_decl(linelength, "%u");
+efifb_attr_decl(height, "%u");
+efifb_attr_decl(width, "%u");
+efifb_attr_decl(depth, "%u");
+
+static struct attribute *efifb_attrs[] = {
+	&dev_attr_base.attr,
+	&dev_attr_linelength.attr,
+	&dev_attr_width.attr,
+	&dev_attr_height.attr,
+	&dev_attr_depth.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(efifb);
+
 static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
@@ -205,14 +230,13 @@ static int efifb_probe(struct platform_device *dev)
 	} else {
 		/* We cannot make this fatal. Sometimes this comes from magic
 		   spaces our resource handlers simply don't know about */
-		printk(KERN_WARNING
-		       "efifb: cannot reserve video memory at 0x%lx\n",
+		pr_warn("efifb: cannot reserve video memory at 0x%lx\n",
 			efifb_fix.smem_start);
 	}
 
 	info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
 	if (!info) {
-		printk(KERN_ERR "efifb: cannot allocate framebuffer\n");
+		pr_err("efifb: cannot allocate framebuffer\n");
 		err = -ENOMEM;
 		goto err_release_mem;
 	}
@@ -230,16 +254,15 @@ static int efifb_probe(struct platform_device *dev)
 
 	info->screen_base = ioremap_wc(efifb_fix.smem_start, efifb_fix.smem_len);
 	if (!info->screen_base) {
-		printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
-				"0x%x @ 0x%lx\n",
+		pr_err("efifb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",
 			efifb_fix.smem_len, efifb_fix.smem_start);
 		err = -EIO;
 		goto err_release_fb;
 	}
 
-	printk(KERN_INFO "efifb: framebuffer at 0x%lx, using %dk, total %dk\n",
+	pr_info("efifb: framebuffer at 0x%lx, using %dk, total %dk\n",
 	       efifb_fix.smem_start, size_remap/1024, size_total/1024);
-	printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
+	pr_info("efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
 	       efifb_defined.xres, efifb_defined.yres,
 	       efifb_defined.bits_per_pixel, efifb_fix.line_length,
 	       screen_info.pages);
@@ -247,7 +270,7 @@ static int efifb_probe(struct platform_device *dev)
 	efifb_defined.xres_virtual = efifb_defined.xres;
 	efifb_defined.yres_virtual = efifb_fix.smem_len /
 					efifb_fix.line_length;
-	printk(KERN_INFO "efifb: scrolling: redraw\n");
+	pr_info("efifb: scrolling: redraw\n");
 	efifb_defined.yres_virtual = efifb_defined.yres;
 
 	/* some dummy values for timing to make fbset happy */
@@ -265,7 +288,7 @@ static int efifb_probe(struct platform_device *dev)
 	efifb_defined.transp.offset = screen_info.rsvd_pos;
 	efifb_defined.transp.length = screen_info.rsvd_size;
 
-	printk(KERN_INFO "efifb: %s: "
+	pr_info("efifb: %s: "
 	       "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
 	       "Truecolor",
 	       screen_info.rsvd_size,
@@ -285,12 +308,19 @@ static int efifb_probe(struct platform_device *dev)
 	info->fix = efifb_fix;
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;
 
-	if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
-		printk(KERN_ERR "efifb: cannot allocate colormap\n");
+	err = sysfs_create_groups(&dev->dev.kobj, efifb_groups);
+	if (err) {
+		pr_err("efifb: cannot add sysfs attrs\n");
 		goto err_unmap;
 	}
-	if ((err = register_framebuffer(info)) < 0) {
-		printk(KERN_ERR "efifb: cannot register framebuffer\n");
+	err = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (err < 0) {
+		pr_err("efifb: cannot allocate colormap\n");
+		goto err_groups;
+	}
+	err = register_framebuffer(info);
+	if (err < 0) {
+		pr_err("efifb: cannot register framebuffer\n");
 		goto err_fb_dealoc;
 	}
 	fb_info(info, "%s frame buffer device\n", info->fix.id);
@@ -298,6 +328,8 @@ static int efifb_probe(struct platform_device *dev)
 
 err_fb_dealoc:
 	fb_dealloc_cmap(&info->cmap);
+err_groups:
+	sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
 err_unmap:
 	iounmap(info->screen_base);
 err_release_fb:
@@ -313,6 +345,7 @@ static int efifb_remove(struct platform_device *pdev)
 	struct fb_info *info = platform_get_drvdata(pdev);
 
 	unregister_framebuffer(info);
+	sysfs_remove_groups(&pdev->dev.kobj, efifb_groups);
 	framebuffer_release(info);
 
 	return 0;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2d089487d2da..a07a476178cd 100644
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
@@ -589,8 +605,10 @@ void efi_native_runtime_setup(void);
 #define DEVICE_TREE_GUID			EFI_GUID(0xb1b621d5, 0xf19c, 0x41a5,  0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0)
 #define EFI_PROPERTIES_TABLE_GUID		EFI_GUID(0x880aaca3, 0x4adc, 0x4a04,  0x90, 0x79, 0xb7, 0x47, 0x34, 0x08, 0x25, 0xe5)
 #define EFI_RNG_PROTOCOL_GUID			EFI_GUID(0x3152bca5, 0xeade, 0x433d,  0x86, 0x2e, 0xc0, 0x1c, 0xdc, 0x29, 0x1f, 0x44)
+#define EFI_RNG_ALGORITHM_RAW			EFI_GUID(0xe43176d7, 0xb6e8, 0x4827,  0xb7, 0x84, 0x7f, 0xfd, 0xc4, 0xb6, 0x85, 0x61)
 #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID	EFI_GUID(0xdcfa911d, 0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
 #define EFI_CONSOLE_OUT_DEVICE_GUID		EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
+#define APPLE_PROPERTIES_PROTOCOL_GUID		EFI_GUID(0x91bd12fe, 0xf6c3, 0x44fb,  0xa5, 0xb7, 0x51, 0x22, 0xab, 0x30, 0x3a, 0xe0)
 
 /*
  * This GUID is used to pass to the kernel proper the struct screen_info
@@ -599,6 +617,7 @@ void efi_native_runtime_setup(void);
  */
 #define LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID	EFI_GUID(0xe03fc20a, 0x85dc, 0x406e,  0xb9, 0x0e, 0x4a, 0xb5, 0x02, 0x37, 0x1d, 0x95)
 #define LINUX_EFI_LOADER_ENTRY_GUID		EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,  0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
+#define LINUX_EFI_RANDOM_SEED_TABLE_GUID	EFI_GUID(0x1ce1e5bc, 0x7ceb, 0x42f2,  0x81, 0xe5, 0x8a, 0xad, 0xf1, 0x80, 0xf5, 0x7b)
 
 typedef struct {
 	efi_guid_t guid;
@@ -872,6 +891,7 @@ extern struct efi {
 	unsigned long esrt;		/* ESRT table */
 	unsigned long properties_table;	/* properties table */
 	unsigned long mem_attr_table;	/* memory attributes table */
+	unsigned long rng_seed;		/* UEFI firmware random seed */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
@@ -1145,6 +1165,26 @@ struct efi_generic_dev_path {
 	u16 length;
 } __attribute ((packed));
 
+struct efi_dev_path {
+	u8 type;	/* can be replaced with unnamed */
+	u8 sub_type;	/* struct efi_generic_dev_path; */
+	u16 length;	/* once we've moved to -std=c11 */
+	union {
+		struct {
+			u32 hid;
+			u32 uid;
+		} acpi;
+		struct {
+			u8 fn;
+			u8 dev;
+		} pci;
+	};
+} __attribute ((packed));
+
+#if IS_ENABLED(CONFIG_EFI_DEV_PATH_PARSER)
+struct device *efi_get_device_by_path(struct efi_dev_path **node, size_t *len);
+#endif
+
 static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
 {
 	*npages = PFN_UP(*addr + (*npages<<EFI_PAGE_SHIFT)) - PFN_DOWN(*addr);
@@ -1493,4 +1533,10 @@ efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
 				    struct efi_boot_memmap *map,
 				    void *priv,
 				    efi_exit_boot_map_processing priv_func);
+
+struct linux_efi_random_seed {
+	u32	size;
+	u8	bits[];
+};
+
 #endif /* _LINUX_EFI_H */
