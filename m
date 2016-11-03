From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH v3 1/3] efi: Add device path parser
Date: Thu, 3 Nov 2016 11:18:48 +0100
Message-ID: <be385ad8859dc1a2f43c0a6fe3926bc44437f1be.1478145888.git.lukas@wunner.de>
References: <cover.1478145888.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1478145888.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We're about to extended the efistub to retrieve device properties from
EFI on Apple Macs. The properties use EFI Device Paths to indicate the
device they belong to. This commit adds a parser which, given an EFI
Device Path, locates the corresponding struct device and returns a
reference to it.

Initially only ACPI and PCI Device Path nodes are supported, these are
the only types needed for Apple device properties (the corresponding
macOS function AppleACPIPlatformExpert::matchEFIDevicePath() does not
support any others). Further node types can be added with little to
moderate effort.

Apple device properties is currently the only use case of this parser,
but Peter Jones intends to use it to match up devices with the
ConInDev/ConOutDev/ErrOutDev variables and add sysfs attributes to these
devices to say the hardware supports using them as console. Thus,
make this parser a separate component which can be selected with config
option EFI_DEV_PATH_PARSER. It can in principle be compiled as a module
if acpi_get_first_physical_node() and acpi_bus_type are exported (and
efi_get_device_by_path() itself is exported).

The dependency on CONFIG_ACPI is needed for acpi_match_device_ids().
It can be removed if an empty inline stub is added for that function.

Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 drivers/firmware/efi/Kconfig           |   5 +
 drivers/firmware/efi/Makefile          |   1 +
 drivers/firmware/efi/dev-path-parser.c | 203 +++++++++++++++++++++++++++++++++
 include/linux/efi.h                    |  20 ++++
 4 files changed, 229 insertions(+)
 create mode 100644 drivers/firmware/efi/dev-path-parser.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index c981be1..893fda4 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -133,3 +133,8 @@ endmenu
 
 config UEFI_CPER
 	bool
+
+config EFI_DEV_PATH_PARSER
+	bool
+	depends on ACPI
+	default n
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index c8a439f..3e91ae3 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_EFI_STUB)			+= libstub/
 obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
 obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
 obj-$(CONFIG_EFI_TEST)			+= test/
+obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
diff --git a/drivers/firmware/efi/dev-path-parser.c b/drivers/firmware/efi/dev-path-parser.c
new file mode 100644
index 0000000..85d1834
--- /dev/null
+++ b/drivers/firmware/efi/dev-path-parser.c
@@ -0,0 +1,203 @@
+/*
+ * dev-path-parser.c - EFI Device Path parser
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
diff --git a/include/linux/efi.h b/include/linux/efi.h
index f5a821d..2617672 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1148,6 +1148,26 @@ struct efi_generic_dev_path {
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
-- 
2.10.1
