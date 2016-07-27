From: Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 3/6] efi: Add device path parser
Date: Wed, 27 Jul 2016 13:20:41 +0200
Message-ID: <60c6b006a6207c6c707ad716589c8d1fd7bb4b73.1469616641.git.lukas@wunner.de>
References: <cover.1469616641.git.lukas@wunner.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1469616641.git.lukas@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>, Pierre Moreau <pierre.morrow@free.fr>
List-Id: linux-efi@vger.kernel.org

We've just extended the efistub to retrieve device properties from EFI
on Apple Macs. The properties use EFI Device Paths to indicate the
device they belong to. This commit adds a parser which, given an EFI
Device Path, locates the corresponding struct device and returns a
reference to it.

Initially only ACPI and PCI Device Path nodes are supported, these are
the only types needed for Apple device properties (the corresponding
macOS function AppleACPIPlatformExpert::matchEFIDevicePath() does not
support any others). Further node types can be added with moderate
effort.

Apple device properties is currently the only use case of this parser,
but since this may be useful to others, make it a separate component
which can be selected with config option EFI_DEV_PATH_PARSER. It can
in principle be compiled as a module if acpi_get_first_physical_node()
and acpi_bus_type are exported (and get_device_by_efi_path() itself is
exported).

The dependency on CONFIG_ACPI is needed for acpi_match_device_ids().
It can be removed if an empty inline stub is added for that function.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 drivers/firmware/efi/Kconfig           |   5 +
 drivers/firmware/efi/Makefile          |   1 +
 drivers/firmware/efi/dev-path-parser.c | 186 +++++++++++++++++++++++++++++++++
 include/linux/efi.h                    |  21 ++++
 4 files changed, 213 insertions(+)
 create mode 100644 drivers/firmware/efi/dev-path-parser.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 6394152..6ffafd2 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -116,3 +116,8 @@ endmenu
 
 config UEFI_CPER
 	bool
+
+config EFI_DEV_PATH_PARSER
+	bool
+	depends on ACPI
+	default n
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index a219640..85dcbae 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
 obj-$(CONFIG_EFI_STUB)			+= libstub/
 obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
 obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
+obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
diff --git a/drivers/firmware/efi/dev-path-parser.c b/drivers/firmware/efi/dev-path-parser.c
new file mode 100644
index 0000000..555e74c
--- /dev/null
+++ b/drivers/firmware/efi/dev-path-parser.c
@@ -0,0 +1,186 @@
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
+static int __init acpi_match(struct device *dev, void *data)
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
+static int __init get_device_by_acpi_path(struct efi_dev_path *node,
+					  struct device *parent,
+					  struct device **child)
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
+	*child = bus_find_device(&acpi_bus_type, NULL, &hid_uid, acpi_match);
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
+static int __init pci_match(struct device *dev, void *data)
+{
+	unsigned int devfn = *(unsigned int *)data;
+
+	return dev_is_pci(dev) && to_pci_dev(dev)->devfn == devfn;
+}
+
+static int __init get_device_by_pci_path(struct efi_dev_path *node,
+					 struct device *parent,
+					 struct device **child)
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
+	*child = device_find_child(parent, &devfn, pci_match);
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
+ * The special return value 1 signals the end of the device path, only
+ * get_device_by_end_path() is supposed to return this.
+ *
+ * Be sure to validate the node length and contents before commencing the
+ * search for a device.
+ */
+
+static int __init get_device_by_end_path(struct efi_dev_path *node,
+					 struct device *parent,
+					 struct device **child)
+{
+	if (node->length != 4)
+		return -EINVAL;
+	if (!parent)
+		return -ENODEV;
+
+	*child = get_device(parent);
+	return 1;
+}
+
+/**
+ * get_device_by_efi_path - find device by EFI Device Path
+ * @node: EFI Device Path
+ * @len: maximum length of EFI Device Path in bytes
+ * @dev: device found
+ *
+ * Parse a series of EFI Device Path nodes at @node and find the corresponding
+ * device. If the device was found, its reference count is increased and a
+ * pointer to it is returned in @dev. The caller needs to drop the reference
+ * with put_device() after use. The @node pointer is updated to point to the
+ * location immediately after the "End Entire Device Path" node.
+ *
+ * If a Device Path node is malformed or its corresponding device is not found,
+ * @node is updated to point to this offending node and @dev will be %NULL.
+ *
+ * Most buses instantiate devices in "subsys" initcall level, hence the
+ * earliest initcall level in which this function should be called is "fs".
+ *
+ * Returns 0 on success,
+ *	   %-ENODEV if no device was found,
+ *	   %-EINVAL if a node is malformed or exceeds @len,
+ *	   %-EPROTONOSUPPORT if support for a node type is not yet implemented.
+ */
+int __init get_device_by_efi_path(struct efi_dev_path **node, size_t len,
+				  struct device **dev)
+{
+	struct device *parent = NULL, *child;
+	int ret = 0;
+
+	*dev = NULL;
+
+	while (ret != 1) {
+		if (len < 4 || len < (*node)->length)
+			ret = -EINVAL;
+		else if ((*node)->type == EFI_DEV_ACPI &&
+			 (*node)->sub_type == EFI_DEV_BASIC_ACPI)
+			ret = get_device_by_acpi_path(*node, parent, &child);
+		else if ((*node)->type == EFI_DEV_HW &&
+			 (*node)->sub_type == EFI_DEV_PCI)
+			ret = get_device_by_pci_path(*node, parent, &child);
+		else if (((*node)->type == EFI_DEV_END_PATH ||
+			  (*node)->type == EFI_DEV_END_PATH2) &&
+			 (*node)->sub_type == EFI_DEV_END_ENTIRE)
+			ret = get_device_by_end_path(*node, parent, &child);
+		else
+			ret = -EPROTONOSUPPORT;
+
+		put_device(parent);
+		if (ret < 0)
+			return ret;
+
+		parent = child;
+		*node  = (void *)*node + (*node)->length;
+		len   -= (*node)->length;
+	}
+
+	*dev = child;
+	return 0;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index e53b4b2..973ff44 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1122,6 +1122,27 @@ struct efi_generic_dev_path {
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
+int get_device_by_efi_path(struct efi_dev_path **node, size_t len,
+			   struct device **dev);
+#endif
+
 static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
 {
 	*npages = PFN_UP(*addr + (*npages<<EFI_PAGE_SHIFT)) - PFN_DOWN(*addr);
-- 
2.8.1
