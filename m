From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH] Add esrt support.
Date: Tue,  9 Dec 2014 17:18:34 -0500
Message-ID: <1418163514-22977-1-git-send-email-pjones@redhat.com>
References: <20141209213847.GB1159@fenchurch.internal.datastacks.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141209213847.GB1159-FS9oOTXHwv9t4tGkRPVz9tcb/sdHg95EuydrBrBl+0sAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add sysfs files for EFI System Resource Table under
/sys/firmware/efi/esrt and for each EFI System Resource Entry under
entries/ as a subdir.

v2 with suggestions from bpetkov.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/Makefile |   2 +-
 drivers/firmware/efi/efi.c    |  45 ++++-
 drivers/firmware/efi/esrt.c   | 392 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |   6 +
 4 files changed, 443 insertions(+), 2 deletions(-)
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
index 8590099..bc7eaca 100644
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
@@ -220,6 +223,45 @@ err_put:
 
 subsys_initcall(efisubsys_init);
 
+/*
+ * Given a physicall address, determine if it exists within an EFI Memory Map
+ * entry, and if so, how much of that map exists at a higher address.  That
+ * is, if this is the address of something in an EFI map, what's the highest
+ * address at which it's likely to end.
+ */
+u64 efi_mem_max_reasonable_size(u64 phys_addr)
+{
+	struct efi_memory_map *map = efi.memmap;
+	void *p, *e;
+
+	if (!map)
+		return -1;
+	if (WARN_ON(!map->phys_map))
+		return -1;
+	if (WARN_ON(map->nr_map == 0) || WARN_ON(map->desc_size == 0))
+		return -1;
+
+	e = map->phys_map + map->nr_map * map->desc_size;
+	for (p = map->phys_map; p < e; p += map->desc_size) {
+		/*
+		 * If a driver calls this after efi_free_boot_services,
+		 * ->map will be NULL.
+		 * So just always get our own virtual map on the CPU.
+		 */
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
+	return -1;
+}
 
 /*
  * We can't ioremap data in EFI boot services RAM, because we've already mapped
@@ -261,6 +303,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
 	{SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
 	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
+	{EFI_SYSTEM_RESOURCE_TABLE_GUID, "ESRT", &efi.esrt},
 	{NULL_GUID, NULL, NULL},
 };
 
diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
new file mode 100644
index 0000000..ffa2144
--- /dev/null
+++ b/drivers/firmware/efi/esrt.c
@@ -0,0 +1,392 @@
+/*
+ * esrt.c
+ *
+ * This module exports EFI System Resource Table (ESRT) entries into userspace
+ * through the sysfs file system. The ESRT provides a read-only catalog of
+ * system components for which the system accepts firmware upgrades via UEFI's
+ * "Capsule Update" feature. This module allows userland utilties to evaluate
+ * what firmware updates can be applied to this system, and potentially arrange
+ * for those updates to occur.
+ *
+ * Data is currently found below /sys/firmware/efi/esrt/...
+ */
+#define pr_fmt(fmt) "esrt: " fmt
+
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
+/*
+ * _count and _version are what they seem like.  _max is actually just
+ * accounting info for the firmware when creating the table; it should never
+ * have been exposed to us.  To wit, the spec says:
+ * The maximum number of resource array entries that can be within the
+ * table without reallocating the table, must not be zero.
+ * Since there's no guidance about what that means in terms of memory layout,
+ * it means nothing to us.
+ */
+typedef struct {
+	u32	fw_resource_count;
+	u32	fw_resource_count_max;
+	u64	fw_resource_version;
+	efi_system_resource_entry_t entries[];
+} efi_system_resource_table_t;
+
+static efi_system_resource_table_t *esrt;
+
+struct esre_entry {
+	efi_system_resource_entry_t *esre;
+
+	struct kobject kobj;
+	struct list_head list;
+};
+
+/* global list of esre_entry. */
+static LIST_HEAD(entry_list);
+
+/* entry attribute */
+struct esre_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct esre_entry *entry, char *buf);
+	ssize_t (*store)(struct esre_entry *entry,
+	                 const char *buf, size_t count);
+};
+
+static struct esre_entry *to_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct esre_entry, kobj);
+}
+
+static struct esre_attribute *to_attr(struct attribute *attr)
+{
+	return container_of(attr, struct esre_attribute, attr);
+}
+
+static ssize_t esre_attr_show(struct kobject *kobj,
+			      struct attribute *_attr, char *buf)
+{
+	struct esre_entry *entry = to_entry(kobj);
+	struct esre_attribute *attr = to_attr(_attr);
+
+	/* Don't tell normal users what firmware versions we've got... */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	return attr->show(entry, buf);
+}
+
+static const struct sysfs_ops esre_attr_ops = {
+	.show = esre_attr_show,
+};
+
+/* Generic ESRT Entry ("ESRE") support. */
+static ssize_t esre_fw_class_show(struct esre_entry *entry, char *buf)
+{
+	char *str = buf;
+	efi_guid_unparse(&entry->esre->fw_class, str);
+	str += strlen(str);
+	str += sprintf(str, "\n");
+
+	return str - buf;
+}
+
+static struct esre_attribute esre_fw_class = __ATTR(fw_class, 0400,
+	esre_fw_class_show, NULL);
+
+#define esre_attr_decl(name, size, fmt) \
+static ssize_t esre_##name##_show(struct esre_entry *entry, char *buf) { \
+	return sprintf(buf, fmt "\n", le##size##_to_cpu(entry->esre->name)); \
+} \
+\
+static struct esre_attribute esre_##name = __ATTR(name, 0400, \
+	esre_##name##_show, NULL)
+
+esre_attr_decl(fw_type, 32, "%u");
+esre_attr_decl(fw_version, 32, "%u");
+esre_attr_decl(lowest_supported_fw_version, 32,"%u");
+esre_attr_decl(capsule_flags, 32, "0x%x");
+esre_attr_decl(last_attempt_version, 32, "%u");
+esre_attr_decl(last_attempt_status, 32, "%u");
+
+static struct attribute *esre_attrs[] = {
+	&esre_fw_class.attr,
+	&esre_fw_type.attr,
+	&esre_fw_version.attr,
+	&esre_lowest_supported_fw_version.attr,
+	&esre_capsule_flags.attr,
+	&esre_last_attempt_version.attr,
+	&esre_last_attempt_status.attr,
+	NULL
+};
+
+static void esre_release(struct kobject *kobj)
+{
+	struct esre_entry *entry = to_entry(kobj);
+
+	list_del(&entry->list);
+	kfree(entry);
+}
+
+static struct kobj_type esre_ktype = {
+	.release = esre_release,
+	.sysfs_ops = &esre_attr_ops,
+	.default_attrs = esre_attrs,
+};
+
+static struct kobject *esrt_kobj;
+static struct kset *esrt_kset;
+
+static int esre_create_sysfs_entry(efi_system_resource_entry_t *esre)
+{
+	int rc;
+	struct esre_entry *entry;
+	char name[EFI_VARIABLE_GUID_LEN + 1];
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	efi_guid_unparse(&esre->fw_class, name);
+
+	entry->esre = esre;
+	entry->kobj.kset = esrt_kset;
+	rc = kobject_init_and_add(&entry->kobj, &esre_ktype, NULL,
+				  "%s", name);
+	if (rc) {
+		kfree(entry);
+		return rc;
+	}
+
+	list_add_tail(&entry->list, &entry_list);
+	return 0;
+}
+
+/* support for displaying ESRT fields at the top level */
+#define esrt_attr_decl(name, size, fmt) \
+static ssize_t esrt_##name##_show(struct kobject *kobj, \
+				  struct kobj_attribute *attr, char *buf) \
+{ \
+	return sprintf(buf, fmt "\n", le##size##_to_cpu(esrt->name)); \
+} \
+\
+static struct kobj_attribute esrt_##name = __ATTR(name, 0400, \
+	esrt_##name##_show, NULL)
+
+esrt_attr_decl(fw_resource_count, 32, "%u");
+esrt_attr_decl(fw_resource_count_max, 32, "%u");
+esrt_attr_decl(fw_resource_version, 64, "%llu");
+
+static struct attribute *esrt_attrs[] = {
+	&esrt_fw_resource_count.attr,
+	&esrt_fw_resource_count_max.attr,
+	&esrt_fw_resource_version.attr,
+	NULL,
+};
+
+static inline int esrt_table_exists(void)
+{
+	if (!efi_enabled(EFI_CONFIG_TABLES))
+		return 0;
+	if (efi.esrt == EFI_INVALID_TABLE_ADDR)
+		return 0;
+	return 1;
+}
+
+static umode_t esrt_attr_is_visible(struct kobject *kobj,
+				    struct attribute *attr, int n)
+{
+	if (!esrt_table_exists())
+		return 0;
+	return attr->mode;
+}
+
+static struct attribute_group esrt_attr_group = {
+	.attrs = esrt_attrs,
+	.is_visible = esrt_attr_is_visible,
+};
+
+/*
+ * ioremap the table, copy it to kmalloced pages, and unmap it.
+ */
+static int esrt_duplicate_pages(void)
+{
+	efi_system_resource_table_t *tmpesrt;
+	efi_system_resource_entry_t *entries;
+	size_t size, max;
+	int err = -EINVAL;
+
+	if (!esrt_table_exists())
+		return err;
+
+	max = efi_mem_max_reasonable_size(efi.esrt);
+	if (max < 0) {
+		pr_err("ESRT header is not in the memory map.\n");
+		return err;
+	}
+	size = sizeof(*esrt);
+
+	if (max < size) {
+		pr_err("ESRT header doen't fit on single memory map entry.\n");
+		return err;
+	}
+
+	tmpesrt = ioremap(efi.esrt, size);
+	if (!tmpesrt) {
+		pr_err("ioremap failed.\n");
+		return -ENOMEM;
+	}
+
+	if (tmpesrt->fw_resource_count > 0 && max - size < sizeof (*entries)) {
+		pr_err("ESRT memory map entry can only hold the header.\n");
+		goto err_iounmap;
+	}
+
+	/*
+	 * The format doesn't really give us any boundary to test here,
+	 * so I'm making up 128 as the max number of individually updatable
+	 * components we support.
+	 * 128 should be pretty excessive, but there's still some chance
+	 * somebody will do that someday and we'll need to raise this.
+	 */
+	if (tmpesrt->fw_resource_count > 128) {
+		pr_err("ESRT says fw_resource_count has very large value %d.\n",
+		       tmpesrt->fw_resource_count);
+		goto err_iounmap;
+	}
+
+	/*
+	 * We know it can't be larger than N * sizeof() here, and N is limited
+	 * by the previous test to a small number, so there's no overflow.
+	 */
+	size += tmpesrt->fw_resource_count * sizeof (*entries);
+	if (max < size) {
+		pr_err("ESRT does not fit on single memory map entry.\n");
+		goto err_iounmap;
+	}
+
+	esrt = kmalloc(size, GFP_KERNEL);
+	if (!esrt) {
+		pr_err("kmalloc failed.\n");
+		err = -ENOMEM;
+		goto err_iounmap;
+	}
+
+	memcpy(esrt, tmpesrt, size);
+	err = 0;
+err_iounmap:
+	iounmap(tmpesrt);
+	return err;
+}
+
+static int register_entries(void)
+{
+	efi_system_resource_entry_t *entries = esrt->entries;
+	int i, rc;
+
+	if (!esrt_table_exists())
+		return 0;
+
+	for (i = 0; i < le32_to_cpu(esrt->fw_resource_count); i++) {
+		rc = esre_create_sysfs_entry(&entries[i]);
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
+	struct esre_entry *entry, *next;
+
+	list_for_each_entry_safe(entry, next, &entry_list, list) {
+		kobject_put(&entry->kobj);
+	}
+}
+
+static int __init esrt_sysfs_init(void)
+{
+	int error;
+
+	error = esrt_duplicate_pages();
+	if (error)
+		return error;
+
+	esrt_kobj = kobject_create_and_add("esrt", efi_kobj);
+	if (!esrt_kobj) {
+		pr_err("Firmware table registration failed.\n");
+		error = -ENOMEM;
+		goto err;
+	}
+
+	error = sysfs_create_group(esrt_kobj, &esrt_attr_group);
+	if (error) {
+		pr_err("Sysfs attribute export failed with error %d.\n",
+		       error);
+		goto err_remove_esrt;
+	}
+
+	esrt_kset = kset_create_and_add("entries", NULL, esrt_kobj);
+	if (!esrt_kset) {
+		pr_err("kset creation failed.\n");
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
+err_remove_esrt:
+	kobject_put(esrt_kobj);
+err:
+	kfree(esrt);
+	esrt = NULL;
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
