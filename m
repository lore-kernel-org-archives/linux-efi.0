From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/2] efi: Add embedded peripheral firmware support
Date: Sat, 31 Mar 2018 14:19:44 +0200
Message-ID: <20180331121944.8618-2-hdegoede@redhat.com>
References: <20180331121944.8618-1-hdegoede@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180331121944.8618-1-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org
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

Note we check the EFI_BOOT_SERVICES_CODE for embedded firmware pretty
late in the init sequence, this is on purpose because the typical
EFI_BOOT_SERVICES_CODE memory-segment is too large for early_memremap().
This means we rely on the EFI_BOOT_SERVICES_CODE not being free-ed until
efi_free_boot_services() is called, which means that this will only work
on x86, if we ever want this on ARM we should make ARM delay the freeing
of the EFI_BOOT_SERVICES_* memory-segments too.

Note this commit also modifies efi_mem_desc_lookup() to not skip
EFI_BOOT_SERVICES_CODE memory-segments, so that efi_mem_reserve() works
on such segments.

Reported-by: Dave Olsthoorn <dave@bewaar.me>
Suggested-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/base/firmware_class.c            |  29 +++
 drivers/firmware/efi/Makefile            |   1 +
 drivers/firmware/efi/efi.c               |   1 +
 drivers/firmware/efi/embedded-firmware.c | 232 +++++++++++++++++++++++
 include/linux/efi.h                      |   2 +
 init/main.c                              |   1 +
 6 files changed, 266 insertions(+)
 create mode 100644 drivers/firmware/efi/embedded-firmware.c

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 7dd36ace6152..b1e7b3de1975 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -12,6 +12,7 @@
 
 #include <linux/capability.h>
 #include <linux/device.h>
+#include <linux/efi.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/timer.h>
@@ -1207,6 +1208,32 @@ static inline void unregister_sysfs_loader(void)
 
 #endif /* CONFIG_FW_LOADER_USER_HELPER */
 
+#ifdef CONFIG_EFI
+static int
+fw_get_efi_embedded_fw(struct device *dev, struct fw_priv *fw_priv, int ret)
+{
+	size_t size;
+	int rc;
+
+	rc = efi_get_embedded_fw(fw_priv->fw_name, &fw_priv->data, &size,
+				 fw_priv->data ? fw_priv->allocated_size : 0);
+	if (rc == 0) {
+		dev_dbg(dev, "using efi-embedded fw %s\n", fw_priv->fw_name);
+		fw_priv->size = size;
+		fw_state_done(fw_priv);
+		ret = 0;
+	}
+
+	return ret;
+}
+#else
+static inline int
+fw_get_efi_embedded_fw(struct device *dev, struct fw_priv *fw_priv, int ret)
+{
+	return ret;
+}
+#endif
+
 /* prepare firmware and firmware_buf structs;
  * return 0 if a firmware is already assigned, 1 if need to load one,
  * or a negative error code
@@ -1296,6 +1323,8 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		goto out;
 
 	ret = fw_get_filesystem_firmware(device, fw->priv);
+	if (ret)
+		ret = fw_get_efi_embedded_fw(device, fw->priv, ret);
 	if (ret) {
 		if (!(opt_flags & FW_OPT_NO_WARN))
 			dev_warn(device,
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index cb805374f4bc..cb946f7d0181 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -13,6 +13,7 @@ KASAN_SANITIZE_runtime-wrappers.o	:= n
 obj-$(CONFIG_ACPI_BGRT) 		+= efi-bgrt.o
 obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o memattr.o tpm.o
 obj-$(CONFIG_EFI)			+= capsule.o memmap.o
+obj-$(CONFIG_EFI)			+= embedded-firmware.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_ESRT)			+= esrt.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index fddc5f706fd2..1a5ea950f58f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -455,6 +455,7 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
 		u64 end;
 
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA &&
 		    md->type != EFI_RUNTIME_SERVICES_DATA) {
 			continue;
diff --git a/drivers/firmware/efi/embedded-firmware.c b/drivers/firmware/efi/embedded-firmware.c
new file mode 100644
index 000000000000..80848f332b22
--- /dev/null
+++ b/drivers/firmware/efi/embedded-firmware.c
@@ -0,0 +1,232 @@
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
+#include <linux/types.h>
+
+/* Sofar there are no machines with more then 1 interesting embedded firmware */
+#define MAX_EMBEDDED_FIRMWARES	1
+
+struct embedded_fw_desc {
+	const char *name;
+	u8 prefix[8];
+	u32 length;
+	u32 crc;
+};
+
+struct embedded_fw {
+	const char *name;
+	void *data;
+	size_t length;
+};
+
+static struct embedded_fw found_fw[MAX_EMBEDDED_FIRMWARES];
+static int found_fw_count;
+
+static struct embedded_fw_desc chuwi_vi8_plus_fw[] __initdata = {
+	{
+		.name	= "chipone/icn8318-HAMP0002.fw",
+		.prefix = { 0xb0, 0x07, 0x00, 0x00, 0xe4, 0x07, 0x00, 0x00 },
+		.length	= 35012,
+		.crc	= 0x74dfd3fc,
+	},
+	{}
+};
+
+static struct embedded_fw_desc chuwi_hi8_pro_fw[] __initdata = {
+	{
+		.name	= "silead/gsl3680-chuwi-hi8-pro.fw",
+		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
+		.length	= 39864,
+		.crc	= 0xfe2bedba,
+	},
+	{}
+};
+
+static struct embedded_fw_desc cube_iwork8_air_fw[] __initdata = {
+	{
+		.name	= "silead/gsl3670-cube-iwork8-air.fw",
+		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
+		.length	= 38808,
+		.crc	= 0xfecde51f,
+	},
+	{}
+};
+
+static struct embedded_fw_desc pipo_w2s_fw[] __initdata = {
+	{
+		.name	= "silead/gsl1680-pipo-w2s.fw",
+		.prefix = { 0xf0, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00 },
+		.length	= 39072,
+		.crc	= 0x28d5dc6c,
+	},
+	{}
+};
+
+static struct dmi_system_id embedded_fw_table[] __initdata = {
+	{
+		/* Chuwi Vi8 Plus (CWI506) */
+		.driver_data = (void *)chuwi_vi8_plus_fw,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hampoo"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "D2D3_Vi8A1"),
+			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+		},
+	},
+	{
+		/* Chuwi Hi8 Pro (CWI513) */
+		.driver_data = (void *)chuwi_hi8_pro_fw,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hampoo"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X1D3_C806N"),
+		},
+	},
+	{
+		/* Cube iWork8 Air */
+		.driver_data = (void *)cube_iwork8_air_fw,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "cube"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "i1-TF"),
+			DMI_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+		},
+	},
+	{
+		/* Pipo W2s */
+		.driver_data = (void *)pipo_w2s_fw,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "PIPO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "W2S"),
+		},
+	},
+	{}
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
+	efi_memory_desc_t *md, const struct embedded_fw_desc *desc)
+{
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
+	if (found_fw_count >= MAX_EMBEDDED_FIRMWARES) {
+		pr_err("Error already have %d embedded firmwares\n",
+		       MAX_EMBEDDED_FIRMWARES);
+		return -ENOSPC;
+	}
+
+	found_fw[found_fw_count].data =
+		memremap(md->phys_addr + i, desc->length, MEMREMAP_WB);
+	if (!found_fw[found_fw_count].data) {
+		pr_err("Error mapping embedded firmware\n");
+		return -ENOMEM;
+	}
+
+	found_fw[found_fw_count].name = desc->name;
+	found_fw[found_fw_count].length = desc->length;
+	found_fw_count++;
+
+	/* Note md points to *unmapped* memory after this!!! */
+	efi_mem_reserve(md->phys_addr + i, desc->length);
+	return 0;
+}
+
+void __init efi_check_for_embedded_firmwares(void)
+{
+	const struct embedded_fw_desc *fw_desc;
+	const struct dmi_system_id *dmi_id;
+	efi_memory_desc_t *md;
+	int i, r;
+
+	dmi_id = dmi_first_match(embedded_fw_table);
+	if (!dmi_id)
+		return;
+
+	fw_desc = dmi_id->driver_data;
+	for (i = 0; fw_desc[i].length; i++) {
+		for_each_efi_memory_desc(md) {
+			if (md->type != EFI_BOOT_SERVICES_CODE)
+				continue;
+
+			r = efi_check_md_for_embedded_firmware(md, &fw_desc[i]);
+			if (r == 0) {
+				/*
+				 * On success efi_mem_reserve() has been called
+				 * installing a new memmap, so our pointers
+				 * are invalid now and we MUST break the loop.
+				 */
+				break;
+			}
+		}
+	}
+}
+
+int efi_get_embedded_fw(const char *name, void **data, size_t *size,
+			size_t msize)
+{
+	struct embedded_fw *fw = NULL;
+	void *buf = *data;
+	int i;
+
+	for (i = 0; i < found_fw_count; i++) {
+		if (strcmp(name, found_fw[i].name) == 0) {
+			fw = &found_fw[i];
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
diff --git a/include/linux/efi.h b/include/linux/efi.h
index f5083aa72eae..bbdfda1d9e8d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1573,6 +1573,8 @@ efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg) { }
 #endif
 
 void efi_retrieve_tpm2_eventlog(efi_system_table_t *sys_table);
+void efi_check_for_embedded_firmwares(void);
+int efi_get_embedded_fw(const char *name, void **dat, size_t *sz, size_t msize);
 
 /*
  * Arch code can implement the following three template macros, avoiding
diff --git a/init/main.c b/init/main.c
index 969eaf140ef0..79b4a1b12509 100644
--- a/init/main.c
+++ b/init/main.c
@@ -710,6 +710,7 @@ asmlinkage __visible void __init start_kernel(void)
 	sfi_init_late();
 
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
+		efi_check_for_embedded_firmwares();
 		efi_free_boot_services();
 	}
 
-- 
2.17.0.rc2
