From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v4 2/5] efi: Add embedded peripheral firmware support
Date: Thu, 26 Apr 2018 14:06:34 +0200
Message-ID: <20180426120637.21258-3-hdegoede@redhat.com>
References: <20180426120637.21258-1-hdegoede@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180426120637.21258-1-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org, Torsten Duwe <duwe@suse.de>, Kees Cook <keescook@chromium.org>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Just like with PCI options ROMs, which we save in the setup_efi_pci*
functions from arch/x86/boot/compressed/eboot.c, the EFI code / ROM itself
sometimes may contain data which is useful/necessary for peripheral drivers
to have access to.

Specifically the EFI code may contain an embedded copy of firmware which
needs to be (re)loaded into the peripheral. Normally such firmware would be
part of linux-firmware, but in some cases this is not feasible, for 2
reasons:

1) The firmware is customized for a specific use-case of the chipset / use
with a specific hardware model, so we cannot have a single firmware file
for the chipset. E.g. touchscreen controller firmwares are compiled
specifically for the hardware model they are used with, as they are
calibrated for a specific model digitizer.

2) Despite repeated attempts we have failed to get permission to
redistribute the firmware. This is especially a problem with customized
firmwares, these get created by the chip vendor for a specific ODM and the
copyright may partially belong with the ODM, so the chip vendor cannot
give a blanket permission to distribute these.

This commit adds support for finding peripheral firmware embedded in the
EFI code and making this available to peripheral drivers through the
standard firmware loading mechanism.

Note we check the EFI_BOOT_SERVICES_CODE for embedded firmware near the end
of start_kernel(), just before calling rest_init(), this is on purpose
because the typical EFI_BOOT_SERVICES_CODE memory-segment is too large for
early_memremap(), so the check must be done after mm_init(). This relies
on EFI_BOOT_SERVICES_CODE not being free-ed until efi_free_boot_services()
is called, which means that this will only work on x86 for now.

Reported-by: Dave Olsthoorn <dave@bewaar.me>
Suggested-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v4:
-Drop note in docs about EFI_FIRMWARE_VOLUME_PROTOCOL, it is not part of
 UEFI proper, so the EFI maintainers don't want us referring people to it
-Use new EFI_BOOT_SERVICES flag
-Put the new fw_get_efi_embedded_fw() function in its own fallback_efi.c
 file which only gets built when EFI_EMBEDDED_FIRMWARE is selected
-Define an empty stub for fw_get_efi_embedded_fw() in fallback.h hwen
 EFI_EMBEDDED_FIRMWARE is not selected, to avoid the need for #ifdefs
 in firmware_loader/main.c
-Properly call security_kernel_post_read_file() on the firmware returned
 by efi_get_embedded_fw() to make sure that we are allowed to use it

Changes in v3:
-Fix the docs using "efi-embedded-fw" as property name instead of
 "efi-embedded-firmware"

Changes in v2:
-Rebased on driver-core/driver-core-next
-Add documentation describing the EFI embedded firmware mechanism to:
 Documentation/driver-api/firmware/request_firmware.rst
-Add a new EFI_EMBEDDED_FIRMWARE Kconfig bool and only build the embedded
 fw support if this is set. This is an invisible option which should be
 selected by drivers which need this
-Remove the efi_embedded_fw_desc and dmi_system_id-s for known devices
 from the efi-embedded-fw code, instead drivers using this are expected to
 export a dmi_system_id array, with each entries' driver_data pointing to a
 efi_embedded_fw_desc struct and register this with the efi-embedded-fw code
-Use kmemdup to make a copy instead of efi_mem_reserve()-ing the firmware,
 this avoids us messing with the EFI memmap and avoids the need to make
 changes to efi_mem_desc_lookup()
-Make the firmware-loader code only fallback to efi_get_embedded_fw() if the
 passed in device has the "efi-embedded-firmware" device-property bool set
-Skip usermodehelper fallback when "efi-embedded-firmware" device-property
 is set
---
 .../driver-api/firmware/request_firmware.rst  |  66 ++++++++
 drivers/base/firmware_loader/Makefile         |   1 +
 drivers/base/firmware_loader/fallback.h       |  12 ++
 drivers/base/firmware_loader/fallback_efi.c   |  51 ++++++
 drivers/base/firmware_loader/main.c           |   4 +
 drivers/firmware/efi/Kconfig                  |   3 +
 drivers/firmware/efi/Makefile                 |   1 +
 drivers/firmware/efi/embedded-firmware.c      | 152 ++++++++++++++++++
 include/linux/efi.h                           |   6 +
 include/linux/efi_embedded_fw.h               |  25 +++
 init/main.c                                   |   3 +
 11 files changed, 324 insertions(+)
 create mode 100644 drivers/base/firmware_loader/fallback_efi.c
 create mode 100644 drivers/firmware/efi/embedded-firmware.c
 create mode 100644 include/linux/efi_embedded_fw.h

diff --git a/Documentation/driver-api/firmware/request_firmware.rst b/Documentation/driver-api/firmware/request_firmware.rst
index c8bddbdcfd10..560dfed76e38 100644
--- a/Documentation/driver-api/firmware/request_firmware.rst
+++ b/Documentation/driver-api/firmware/request_firmware.rst
@@ -73,3 +73,69 @@ If something went wrong firmware_request() returns non-zero and fw_entry
 is set to NULL. Once your driver is done with processing the firmware it
 can call call firmware_release(fw_entry) to release the firmware image
 and any related resource.
+
+EFI embedded firmware support
+=============================
+
+On some devices the system's EFI code / ROM may contain an embedded copy
+of firmware for some of the system's integrated peripheral devices and
+the peripheral's Linux device-driver needs to access this firmware.
+
+A device driver which needs this can describe the firmware it needs
+using an efi_embedded_fw_desc struct:
+
+.. kernel-doc:: include/linux/efi_embedded_fw.h
+   :functions: efi_embedded_fw_desc
+
+The EFI embedded-fw code works by scanning all EFI_BOOT_SERVICES_CODE memory
+segments for an eight byte sequence matching prefix, if the prefix is found it
+then does a crc32 over length bytes and if that matches makes a copy of length
+bytes and adds that to its list with found firmwares.
+
+To avoid doing this somewhat expensive scan on all systems, dmi matching is
+used. Drivers are expected to export a dmi_system_id array, with each entries'
+driver_data pointing to an efi_embedded_fw_desc.
+
+To register this array with the efi-embedded-fw code, a driver needs to:
+
+1. Always be builtin to the kernel or store the dmi_system_id array in a
+   separate object file which always gets builtin.
+
+2. Add an extern declaration for the dmi_system_id array to
+   include/linux/efi_embedded_fw.h.
+
+3. Add the dmi_system_id array to the embedded_fw_table in
+   drivers/firmware/efi/embedded-firmware.c wrapped in a #ifdef testing that
+   the driver is being builtin.
+
+4. Add "select EFI_EMBEDDED_FIRMWARE if EFI_STUB" to its Kconfig entry.
+
+The request_firmware() function will always first try to load firmware with
+the specified name directly from the disk, so the EFI embedded-fw can always
+be overridden by placing a file under /lib/firmare.
+
+To make request_firmware() fallback to trying EFI embedded firmwares after this,
+the driver must set a boolean "efi-embedded-firmware" device-property on the
+device before passing it to request_firmware(). Note that this disables the
+usual usermodehelper fallback, so you may want to only set this on systems
+which match your dmi_system_id array.
+
+Once the device-property is set, the driver can use the regular
+request_firmware() function to get the firmware, using the name filled in
+in the efi_embedded_fw_desc.
+
+Note that:
+
+1. The code scanning for EFI embbedded-firmware runs near the end
+   of start_kernel(), just before calling rest_init(). For normal drivers and
+   subsystems using subsys_initcall() to register themselves this does not
+   matter. This means that code running earlier cannot use EFI
+   embbedded-firmware.
+
+2. ATM the EFI embedded-fw code assumes that firmwares always start at an offset
+   which is a multiple of 8 bytes, if this is not true for your case send in
+   a patch to fix this.
+
+3. ATM the EFI embedded-fw code only works on x86 because other archs free
+   EFI_BOOT_SERVICES_CODE before the EFI embedded-fw code gets a chance to
+   scan it.
diff --git a/drivers/base/firmware_loader/Makefile b/drivers/base/firmware_loader/Makefile
index a97eeb0be1d8..365a040995d3 100644
--- a/drivers/base/firmware_loader/Makefile
+++ b/drivers/base/firmware_loader/Makefile
@@ -5,3 +5,4 @@ obj-y			:= fallback_table.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 firmware_class-objs := main.o
 firmware_class-$(CONFIG_FW_LOADER_USER_HELPER) += fallback.o
+firmware_class-$(CONFIG_EFI_EMBEDDED_FIRMWARE) += fallback_efi.o
diff --git a/drivers/base/firmware_loader/fallback.h b/drivers/base/firmware_loader/fallback.h
index 8cfaa3299bb7..92f462415d25 100644
--- a/drivers/base/firmware_loader/fallback.h
+++ b/drivers/base/firmware_loader/fallback.h
@@ -66,4 +66,16 @@ static inline void unregister_sysfs_loader(void)
 }
 #endif /* CONFIG_FW_LOADER_USER_HELPER */
 
+#ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
+int fw_get_efi_embedded_fw(struct device *dev, struct fw_priv *fw_priv,
+			   enum fw_opt *opt_flags, int ret);
+#else
+static inline int fw_get_efi_embedded_fw(struct device *dev,
+					 struct fw_priv *fw_priv,
+					 enum fw_opt *opt_flags, int ret)
+{
+	return ret;
+}
+#endif /* CONFIG_EFI_EMBEDDED_FIRMWARE */
+
 #endif /* __FIRMWARE_FALLBACK_H */
diff --git a/drivers/base/firmware_loader/fallback_efi.c b/drivers/base/firmware_loader/fallback_efi.c
new file mode 100644
index 000000000000..82ba82f48a79
--- /dev/null
+++ b/drivers/base/firmware_loader/fallback_efi.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/efi_embedded_fw.h>
+#include <linux/property.h>
+#include <linux/security.h>
+#include <linux/vmalloc.h>
+
+#include "fallback.h"
+#include "firmware.h"
+
+int fw_get_efi_embedded_fw(struct device *dev, struct fw_priv *fw_priv,
+			   enum fw_opt *opt_flags, int ret)
+{
+	enum kernel_read_file_id id = READING_FIRMWARE;
+	size_t size, max = INT_MAX;
+	int rc;
+
+	if (!dev)
+		return ret;
+
+	if (!device_property_read_bool(dev, "efi-embedded-firmware"))
+		return ret;
+
+	*opt_flags |= FW_OPT_NO_WARN | FW_OPT_NOCACHE | FW_OPT_NOFALLBACK;
+
+	/* Already populated data member means we're loading into a buffer */
+	if (fw_priv->data) {
+		id = READING_FIRMWARE_PREALLOC_BUFFER;
+		max = fw_priv->allocated_size;
+	}
+
+	rc = efi_get_embedded_fw(fw_priv->fw_name, &fw_priv->data, &size, max);
+	if (rc) {
+		dev_warn(dev, "Firmware %s not in EFI\n", fw_priv->fw_name);
+		return ret;
+	}
+
+	rc = security_kernel_post_read_file(NULL, fw_priv->data, size, id);
+	if (rc) {
+		if (id != READING_FIRMWARE_PREALLOC_BUFFER) {
+			vfree(fw_priv->data);
+			fw_priv->data = NULL;
+		}
+		return rc;
+	}
+
+	dev_dbg(dev, "using efi-embedded fw %s\n", fw_priv->fw_name);
+	fw_priv->size = size;
+	fw_state_done(fw_priv);
+	return 0;
+}
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index f009566acd35..adcc248f7b91 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -33,6 +33,8 @@
 #include <linux/syscore_ops.h>
 #include <linux/reboot.h>
 #include <linux/security.h>
+#include <linux/efi_embedded_fw.h>
+#include <linux/property.h>
 
 #include <generated/utsrelease.h>
 
@@ -576,6 +578,8 @@ _firmware_request(const struct firmware **firmware_p, const char *name,
 		goto out;
 
 	ret = fw_get_filesystem_firmware(device, fw->priv);
+	if (ret)
+		ret = fw_get_efi_embedded_fw(device, fw->priv, &opt_flags, ret);
 	if (ret) {
 		if (!(opt_flags & FW_OPT_NO_WARN))
 			dev_warn(device,
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 3098410abad8..faefeff7fb34 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -164,6 +164,9 @@ config RESET_ATTACK_MITIGATION
 	  have been evicted, since otherwise it will trigger even on clean
 	  reboots.
 
+config EFI_EMBEDDED_FIRMWARE
+	bool
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index cb805374f4bc..dde12cea8aac 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
 obj-$(CONFIG_EFI_TEST)			+= test/
 obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
 obj-$(CONFIG_APPLE_PROPERTIES)		+= apple-properties.o
+obj-$(CONFIG_EFI_EMBEDDED_FIRMWARE)	+= embedded-firmware.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
diff --git a/drivers/firmware/efi/embedded-firmware.c b/drivers/firmware/efi/embedded-firmware.c
new file mode 100644
index 000000000000..ef6282945307
--- /dev/null
+++ b/drivers/firmware/efi/embedded-firmware.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Support for extracting embedded firmware for peripherals from EFI code,
+ *
+ * Copyright (c) 2018 Hans de Goede <hdegoede@redhat.com>
+ */
+
+#include <linux/crc32.h>
+#include <linux/dmi.h>
+#include <linux/efi.h>
+#include <linux/efi_embedded_fw.h>
+#include <linux/io.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+struct embedded_fw {
+	struct list_head list;
+	const char *name;
+	void *data;
+	size_t length;
+};
+
+static LIST_HEAD(found_fw_list);
+
+static const struct dmi_system_id * const embedded_fw_table[] = {
+	NULL
+};
+
+/*
+ * Note the efi_check_for_embedded_firmwares() code currently makes the
+ * following 2 assumptions. This may needs to be revisited if embedded firmware
+ * is found where this is not true:
+ * 1) The firmware is only found in EFI_BOOT_SERVICES_CODE memory segments
+ * 2) The firmware always starts at an offset which is a multiple of 8 bytes
+ */
+static int __init efi_check_md_for_embedded_firmware(
+	efi_memory_desc_t *md, const struct efi_embedded_fw_desc *desc)
+{
+	struct embedded_fw *fw;
+	u64 i, size;
+	u32 crc;
+	u8 *mem;
+
+	size = md->num_pages << EFI_PAGE_SHIFT;
+	mem = memremap(md->phys_addr, size, MEMREMAP_WB);
+	if (!mem) {
+		pr_err("Error mapping EFI mem at %#llx\n", md->phys_addr);
+		return -ENOMEM;
+	}
+
+	size -= desc->length;
+	for (i = 0; i < size; i += 8) {
+		if (*((u64 *)(mem + i)) != *((u64 *)desc->prefix))
+			continue;
+
+		/* Seed with ~0, invert to match crc32 userspace utility */
+		crc = ~crc32(~0, mem + i, desc->length);
+		if (crc == desc->crc)
+			break;
+	}
+
+	memunmap(mem);
+
+	if (i >= size)
+		return -ENOENT;
+
+	pr_info("Found EFI embedded fw '%s' crc %08x\n", desc->name, desc->crc);
+
+	fw = kmalloc(sizeof(*fw), GFP_KERNEL);
+	if (!fw)
+		return -ENOMEM;
+
+	mem = memremap(md->phys_addr + i, desc->length, MEMREMAP_WB);
+	if (!mem) {
+		pr_err("Error mapping embedded firmware\n");
+		goto error_free_fw;
+	}
+	fw->data = kmemdup(mem, desc->length, GFP_KERNEL);
+	memunmap(mem);
+	if (!fw->data)
+		goto error_free_fw;
+
+	fw->name = desc->name;
+	fw->length = desc->length;
+	list_add(&fw->list, &found_fw_list);
+
+	return 0;
+
+error_free_fw:
+	kfree(fw);
+	return -ENOMEM;
+}
+
+void __init efi_check_for_embedded_firmwares(void)
+{
+	const struct efi_embedded_fw_desc *fw_desc;
+	const struct dmi_system_id *dmi_id;
+	efi_memory_desc_t *md;
+	int i, r;
+
+	if (!efi_enabled(EFI_BOOT_SERVICES))
+		return;
+
+	for (i = 0; embedded_fw_table[i]; i++) {
+		dmi_id = dmi_first_match(embedded_fw_table[i]);
+		if (!dmi_id)
+			continue;
+
+		fw_desc = dmi_id->driver_data;
+		for_each_efi_memory_desc(md) {
+			if (md->type != EFI_BOOT_SERVICES_CODE)
+				continue;
+
+			r = efi_check_md_for_embedded_firmware(md, fw_desc);
+			if (r == 0)
+				break;
+		}
+	}
+}
+
+int efi_get_embedded_fw(const char *name, void **data, size_t *size,
+			size_t msize)
+{
+	struct embedded_fw *iter, *fw = NULL;
+	void *buf = *data;
+
+	list_for_each_entry(iter, &found_fw_list, list) {
+		if (strcmp(name, iter->name) == 0) {
+			fw = iter;
+			break;
+		}
+	}
+
+	if (!fw)
+		return -ENOENT;
+
+	if (msize && msize < fw->length)
+		return -EFBIG;
+
+	if (!buf) {
+		buf = vmalloc(fw->length);
+		if (!buf)
+			return -ENOMEM;
+	}
+
+	memcpy(buf, fw->data, fw->length);
+	*size = fw->length;
+	*data = buf;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efi_get_embedded_fw);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 396bf18ace5c..fc1ea2cee210 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1575,6 +1575,12 @@ static inline void
 efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg) { }
 #endif
 
+#ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
+void efi_check_for_embedded_firmwares(void);
+#else
+static inline void efi_check_for_embedded_firmwares(void) { }
+#endif
+
 void efi_retrieve_tpm2_eventlog(efi_system_table_t *sys_table);
 
 /*
diff --git a/include/linux/efi_embedded_fw.h b/include/linux/efi_embedded_fw.h
new file mode 100644
index 000000000000..0f7d4df3f57a
--- /dev/null
+++ b/include/linux/efi_embedded_fw.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_EFI_EMBEDDED_FW_H
+#define _LINUX_EFI_EMBEDDED_FW_H
+
+#include <linux/mod_devicetable.h>
+
+/**
+ * struct efi_embedded_fw_desc - This struct is used by the EFI embedded-fw
+ *                               code to search for embedded firmwares.
+ *
+ * @name:   Name to register the firmware with if found
+ * @prefix: First 8 bytes of the firmware
+ * @length: Length of the firmware in bytes including prefix
+ * @crc:    Inverted little endian Ethernet style CRC32, with 0xffffffff seed
+ */
+struct efi_embedded_fw_desc {
+	const char *name;
+	u8 prefix[8];
+	u32 length;
+	u32 crc;
+};
+
+int efi_get_embedded_fw(const char *name, void **dat, size_t *sz, size_t msize);
+
+#endif
diff --git a/init/main.c b/init/main.c
index b795aa341a3a..be48ff4a1f60 100644
--- a/init/main.c
+++ b/init/main.c
@@ -729,6 +729,9 @@ asmlinkage __visible void __init start_kernel(void)
 	arch_post_acpi_subsys_init();
 	sfi_init_late();
 
+	if (efi_enabled(EFI_BOOT_SERVICES))
+		efi_check_for_embedded_firmwares();
+
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
 		efi_free_boot_services();
 	}
-- 
2.17.0
