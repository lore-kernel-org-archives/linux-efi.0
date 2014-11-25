From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH] Add esrt support.
Date: Tue, 25 Nov 2014 14:28:04 -0500
Message-ID: <1416943684-11246-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add sysfs files for EFI System Resource Table under
/sys/firmware/efi/esrt and for each EFI System Resource Entry under
entries/ as a subdir.
---
 drivers/firmware/efi/Makefile |   2 +-
 drivers/firmware/efi/efi.c    |  37 +++-
 drivers/firmware/efi/esrt.c   | 402 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |   6 +
 4 files changed, 445 insertions(+), 2 deletions(-)
 create mode 100644 drivers/firmware/efi/esrt.c

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index aef6a95..0d61089 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for linux kernel
 #
-obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
+obj-$(CONFIG_EFI)			+= efi.o esrt.o vars.o reboot.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 8590099..3314522 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -38,6 +38,7 @@ struct efi __read_mostly efi = {
 	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
 	.runtime    = EFI_INVALID_TABLE_ADDR,
 	.config_table  = EFI_INVALID_TABLE_ADDR,
+	.esrt       = EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -63,7 +64,7 @@ static int __init parse_efi_cmdline(char *str)
 }
 early_param("efi", parse_efi_cmdline);
 
-static struct kobject *efi_kobj;
+struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
 
 /*
@@ -92,6 +93,8 @@ static ssize_t systab_show(struct kobject *kobj,
 		str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
 	if (efi.uga != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "UGA=0x%lx\n", efi.uga);
+	if (efi.esrt != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "ESRT=0x%lx\n", efi.esrt);
 
 	return str - buf;
 }
@@ -220,6 +223,37 @@ err_put:
 
 subsys_initcall(efisubsys_init);
 
+u64 efi_mem_max_reasonable_size(u64 phys_addr)
+{
+	struct efi_memory_map *map = efi.memmap;
+	void *p, *e;
+
+	if (!map)
+		return 0;
+	if (WARN_ON(!map->phys_map))
+		return 0;
+	if (WARN_ON(map->nr_map == 0) || WARN_ON(map->desc_size == 0))
+		return 0;
+
+	e = map->phys_map + map->nr_map * map->desc_size;
+	for (p = map->phys_map; p < e; p += map->desc_size) {
+		/* If a driver calls this after efi_free_boot_services,
+		 * ->map will be NULL.  So just always get our own virtual
+		 * map on the CPU. */
+		efi_memory_desc_t *md = phys_to_virt((phys_addr_t)p);
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 end = md->phys_addr + size;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+		    md->type != EFI_BOOT_SERVICES_CODE &&
+		    md->type != EFI_BOOT_SERVICES_DATA)
+			continue;
+		if (!md->virt_addr)
+			continue;
+		if (phys_addr >= md->phys_addr && phys_addr < end)
+			return end - phys_addr;
+	}
+	return 0;
+}
 
 /*
  * We can't ioremap data in EFI boot services RAM, because we've already mapped
@@ -261,6 +295,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
 	{SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
 	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
+	{EFI_SYSTEM_RESOURCE_TABLE_GUID, "ESRT", &efi.esrt},
 	{NULL_GUID, NULL, NULL},
 };
 
diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
new file mode 100644
index 0000000..8c6b238
--- /dev/null
+++ b/drivers/firmware/efi/esrt.c
@@ -0,0 +1,402 @@
+/*
+ * esrt-sysfs.c
+ *
+ * This module exports ESRT entries read-only into userspace through the
+ * sysfs file system.
+ *
+ * Data is currently found below /sys/firmware/efi/esrt/...
+ *
+ */
+#include <linux/capability.h>
+#include <linux/device.h>
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kobject.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+typedef struct {
+	efi_guid_t	fw_class;
+	u32		fw_type;
+	u32		fw_version;
+	u32		lowest_supported_fw_version;
+	u32		capsule_flags;
+	u32		last_attempt_version;
+	u32		last_attempt_status;
+} efi_system_resource_entry_t;
+
+typedef struct {
+	u32	fw_resource_count;
+	u32	fw_resource_count_max;
+	u64	fw_resource_version;
+	efi_system_resource_entry_t entries[];
+} efi_system_resource_table_t;
+
+static efi_system_resource_table_t *esrt;
+
+struct esre_sysfs_entry {
+	efi_system_resource_entry_t esre;
+
+	struct kobject kobj;
+	struct list_head list;
+};
+
+/* global list of esre_sysfs_entry. */
+static LIST_HEAD(entry_list);
+
+/* entry attribute */
+struct esre_sysfs_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct esre_sysfs_entry *entry, char *buf);
+};
+
+static struct esre_sysfs_entry *to_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct esre_sysfs_entry, kobj);
+}
+
+static struct esre_sysfs_attribute *to_attr(struct attribute *attr)
+{
+	return container_of(attr, struct esre_sysfs_attribute, attr);
+}
+
+static ssize_t esre_sysfs_attr_show(struct kobject *kobj,
+				    struct attribute *_attr, char *buf)
+{
+	struct esre_sysfs_entry *entry = to_entry(kobj);
+	struct esre_sysfs_attribute *attr = to_attr(_attr);
+
+	/* Don't tell normal users what firmware versions we've got... */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	return attr->show(entry, buf);
+}
+
+static const struct sysfs_ops esre_sysfs_attr_ops = {
+	.show = esre_sysfs_attr_show,
+};
+
+/* Generic ESRT Entry ("ESRE") support. */
+static ssize_t esre_sysfs_fw_class(struct esre_sysfs_entry *entry, char *buf)
+{
+	char *str = buf;
+	efi_guid_unparse(&entry->esre.fw_class, str);
+	str += strlen(str);
+	str += sprintf(str, "\n");
+
+	return str - buf;
+}
+
+static ssize_t esre_sysfs_fw_type(struct esre_sysfs_entry *entry, char *buf)
+{
+	return sprintf(buf, "%u\n", entry->esre.fw_type);
+}
+
+static ssize_t esre_sysfs_fw_version(struct esre_sysfs_entry *entry, char *buf)
+{
+	return sprintf(buf, "%u\n", entry->esre.fw_version);
+}
+
+static ssize_t esre_sysfs_lowest_supported_fw_version(struct esre_sysfs_entry *entry, char *buf)
+{
+	return sprintf(buf, "%u\n", entry->esre.lowest_supported_fw_version);
+}
+
+static ssize_t esre_sysfs_capsule_flags(struct esre_sysfs_entry *entry, char *buf)
+{
+	return sprintf(buf, "0x%x\n", entry->esre.capsule_flags);
+}
+
+static ssize_t esre_sysfs_last_attempt_version(struct esre_sysfs_entry *entry, char *buf)
+{
+	return sprintf(buf, "%u\n", entry->esre.last_attempt_version);
+}
+
+static ssize_t esre_sysfs_last_attempt_status(struct esre_sysfs_entry *entry, char *buf)
+{
+	return sprintf(buf, "%u\n", entry->esre.last_attempt_status);
+}
+
+#define ESRE_SYSFS_ATTR(_name) \
+struct esre_sysfs_attribute esre_sysfs_attr_##_name = { \
+        .attr = {.name = __stringify(_name), .mode = 0400}, \
+	        .show = esre_sysfs_##_name, \
+}
+
+static ESRE_SYSFS_ATTR(fw_class);
+static ESRE_SYSFS_ATTR(fw_type);
+static ESRE_SYSFS_ATTR(fw_version);
+static ESRE_SYSFS_ATTR(lowest_supported_fw_version);
+static ESRE_SYSFS_ATTR(capsule_flags);
+static ESRE_SYSFS_ATTR(last_attempt_version);
+static ESRE_SYSFS_ATTR(last_attempt_status);
+
+static struct attribute *esre_sysfs_attrs[] = {
+	&esre_sysfs_attr_fw_class.attr,
+	&esre_sysfs_attr_fw_type.attr,
+	&esre_sysfs_attr_fw_version.attr,
+	&esre_sysfs_attr_lowest_supported_fw_version.attr,
+	&esre_sysfs_attr_capsule_flags.attr,
+	&esre_sysfs_attr_last_attempt_version.attr,
+	&esre_sysfs_attr_last_attempt_status.attr,
+	NULL
+};
+
+static void esre_sysfs_release(struct kobject *kobj)
+{
+	struct esre_sysfs_entry *entry = to_entry(kobj);
+
+	list_del(&entry->list);
+	kfree(entry);
+}
+
+static struct kobj_type esre_sysfs_ktype = {
+	.release = esre_sysfs_release,
+	.sysfs_ops = &esre_sysfs_attr_ops,
+	.default_attrs = esre_sysfs_attrs,
+};
+
+static struct kobject *esrt_kobj;
+static struct kset *esrt_kset;
+
+static int esre_sysfs_create_sysfs_entry(efi_system_resource_entry_t *esre)
+{
+	int rc;
+	struct esre_sysfs_entry *entry;
+	char *name;
+	int name_size;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	name_size = EFI_VARIABLE_GUID_LEN + 1;
+	name = kzalloc(name_size, GFP_KERNEL);
+	if (!name) {
+		kfree(entry);
+		return -ENOMEM;
+	}
+	efi_guid_unparse(&esre->fw_class, name);
+
+	memcpy(&entry->esre, esre, sizeof(*esre));
+	entry->kobj.kset = esrt_kset;
+	rc = kobject_init_and_add(&entry->kobj, &esre_sysfs_ktype, NULL,
+				  "%s", name);
+	if (rc) {
+		kfree(name);
+		kfree(entry);
+		return rc;
+	}
+	kfree(name);
+
+	list_add_tail(&entry->list, &entry_list);
+	return 0;
+}
+
+/* support for displaying ESRT fields at the top level */
+#define ESRT_FIELD(name) ((esrt)->name)
+
+#define ESRT_ATTR_SHOW(name, size, fmt) \
+static ssize_t esrt_attr_##name##_show(struct kobject *kobj, \
+				  struct kobj_attribute *attr, char *buf) \
+{ \
+	return sprintf(buf, fmt, le##size##_to_cpu(ESRT_FIELD(name))); \
+} \
+\
+static struct kobj_attribute esrt_attr_##name = __ATTR(name, 0400, \
+	esrt_attr_##name##_show, NULL); \
+
+ESRT_ATTR_SHOW(fw_resource_count, 32, "%u\n");
+ESRT_ATTR_SHOW(fw_resource_count_max, 32, "%u\n");
+ESRT_ATTR_SHOW(fw_resource_version, 64, "%llu\n");
+
+static struct attribute *esrt_attrs[] = {
+	&esrt_attr_fw_resource_count.attr,
+	&esrt_attr_fw_resource_count_max.attr,
+	&esrt_attr_fw_resource_version.attr,
+	NULL,
+};
+
+static umode_t esrt_attr_is_visible(struct kobject *kobj,
+	struct attribute *attr, int n)
+{
+	if (!efi_enabled(EFI_CONFIG_TABLES))
+		return 0;
+	if (efi.esrt == EFI_INVALID_TABLE_ADDR)
+		return 0;
+	return attr->mode;
+}
+
+static struct attribute_group esrt_attr_group = {
+	.attrs = esrt_attrs,
+	.is_visible = esrt_attr_is_visible,
+};
+
+/* ioremap the table, copy it to kmalloced pages, and unmap it */
+static int esrt_duplicate_pages(void)
+{
+	efi_system_resource_table_t *tmpesrt;
+	efi_system_resource_entry_t *entries;
+	size_t size, max;
+
+	if (!efi_enabled(EFI_CONFIG_TABLES))
+		return 0;
+	if (efi.esrt == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	max = efi_mem_max_reasonable_size(efi.esrt);
+	size = sizeof(*esrt);
+
+	if (max < size) {
+		pr_err("ESRT does not fit on single memory map entry.\n");
+		return -EINVAL;
+	}
+
+	tmpesrt = ioremap(efi.esrt, size);
+	if (!tmpesrt) {
+		pr_err("ioremap failed.\n");
+		return -ENOMEM;
+	}
+
+	size += tmpesrt->fw_resource_count * sizeof (*entries);
+	if (max < size) {
+		pr_err("ESRT does not fit on single memory map entry.\n");
+		return -EINVAL;
+	}
+
+	iounmap(tmpesrt);
+	tmpesrt = ioremap(efi.esrt, size);
+	if (!tmpesrt) {
+		pr_err("ioremap failed.\n");
+		return -ENOMEM;
+	}
+
+	if (tmpesrt->fw_resource_count > tmpesrt->fw_resource_count_max) {
+		pr_err("ESRT has invalid fw_resource_count:"
+		       "fw_resource_count_max::%d:%d.\n",
+		       tmpesrt->fw_resource_count,
+		       tmpesrt->fw_resource_count_max);
+		iounmap(tmpesrt);
+		return -EINVAL;
+	}
+
+	/* attempt to test /some/ boundary... 128 should be pretty excessive */
+	if (tmpesrt->fw_resource_count > 128) {
+		pr_err("ESRT says fw_resource_count has very large value %d.\n",
+		       tmpesrt->fw_resource_count);
+		iounmap(tmpesrt);
+		return -EINVAL;
+	}
+
+	esrt = kmalloc(size, GFP_KERNEL);
+	if (!esrt) {
+		iounmap(tmpesrt);
+		pr_err("kmalloc failed.\n");
+		return -ENOMEM;
+	}
+
+	memcpy(esrt, tmpesrt, size);
+	iounmap(tmpesrt);
+	return 0;
+}
+
+static int register_entries(void)
+{
+	efi_system_resource_entry_t *entries = esrt->entries;
+	int i, rc;
+
+	if (!efi_enabled(EFI_CONFIG_TABLES))
+		return 0;
+	if (efi.esrt == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	for (i = 0; i < le32_to_cpu(esrt->fw_resource_count); i++) {
+		rc = esre_sysfs_create_sysfs_entry(&entries[i]);
+		if (rc < 0) {
+			pr_err("EFI System Resource Entry creation "
+			       "failed with error %d.\n", rc);
+			return rc;
+		}
+	}
+	return 0;
+}
+
+static void cleanup_entry_list(void)
+{
+	struct esre_sysfs_entry *entry, *next;
+
+	list_for_each_entry_safe(entry, next, &entry_list, list) {
+		kobject_put(&entry->kobj);
+	}
+}
+
+static int __init esrt_sysfs_init(void)
+{
+	int error = -ENOMEM;
+
+	esrt_kobj = kobject_create_and_add("esrt", efi_kobj);
+	if (!esrt_kobj) {
+		pr_err("esrt: Firmware table registration failed.\n");
+		return -ENOMEM;
+	}
+
+	error = esrt_duplicate_pages();
+	if (error)
+		goto err_remove_esrt;
+
+	error = sysfs_create_group(esrt_kobj, &esrt_attr_group);
+	if (error) {
+		pr_err("esrt: Sysfs attribute export failed with error %d.\n",
+		       error);
+		goto err_free_esrt;
+	}
+
+	esrt_kset = kset_create_and_add("entries", NULL, esrt_kobj);
+	if (!esrt_kset) {
+		pr_err("esrt: kset creation failed.\n");
+		error = -ENOMEM;
+		goto err_remove_group;
+	}
+
+	error = register_entries();
+	if (error)
+		goto err_cleanup_list;
+
+	pr_debug("esrt-sysfs: loaded.\n");
+
+	return 0;
+err_cleanup_list:
+	cleanup_entry_list();
+	kset_unregister(esrt_kset);
+err_remove_group:
+	sysfs_remove_group(esrt_kobj, &esrt_attr_group);
+err_free_esrt:
+	kfree(esrt);
+	esrt = NULL;
+err_remove_esrt:
+	kobject_put(esrt_kobj);
+	return error;
+}
+
+static void __exit esrt_sysfs_exit(void)
+{
+	pr_debug("esrt-sysfs: unloading.\n");
+	cleanup_entry_list();
+	kset_unregister(esrt_kset);
+	sysfs_remove_group(esrt_kobj, &esrt_attr_group);
+	kfree(esrt);
+	esrt = NULL;
+	kobject_del(esrt_kobj);
+	kobject_put(esrt_kobj);
+}
+
+module_init(esrt_sysfs_init);
+module_exit(esrt_sysfs_exit);
+
+MODULE_AUTHOR("Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>");
+MODULE_DESCRIPTION("EFI System Resource Table support");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0949f9c..5b663a7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -562,6 +562,9 @@ void efi_native_runtime_setup(void);
 #define UV_SYSTEM_TABLE_GUID \
     EFI_GUID(  0x3b13a7d4, 0x633e, 0x11dd, 0x93, 0xec, 0xda, 0x25, 0x56, 0xd8, 0x95, 0x93 )
 
+#define EFI_SYSTEM_RESOURCE_TABLE_GUID \
+    EFI_GUID(  0xb122a263, 0x3661, 0x4f68, 0x99, 0x29, 0x78, 0xf8, 0xb0, 0xd6, 0x21, 0x80 )
+
 #define LINUX_EFI_CRASH_GUID \
     EFI_GUID(  0xcfc8fc79, 0xbe2e, 0x4ddc, 0x97, 0xf0, 0x9f, 0x98, 0xbf, 0xe2, 0x98, 0xa0 )
 
@@ -819,6 +822,7 @@ extern struct efi {
 	unsigned long fw_vendor;	/* fw_vendor */
 	unsigned long runtime;		/* runtime table */
 	unsigned long config_table;	/* config tables */
+	unsigned long esrt;		/* EFI System Resource Table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
@@ -875,6 +879,7 @@ extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
 extern u64 efi_mem_attribute (unsigned long phys_addr, unsigned long size);
+extern u64 efi_mem_max_reasonable_size(u64 phys_addr);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
@@ -882,6 +887,7 @@ extern void efi_get_time(struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
 extern struct efi_memory_map memmap;
+extern struct kobject *efi_kobj;
 
 extern int efi_reboot_quirk_mode;
 extern bool efi_poweroff_required(void);
-- 
2.1.0
