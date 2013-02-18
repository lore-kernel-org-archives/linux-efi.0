From: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Subject: [PATCH 2/2] efi: rename the efivars module
Date: Mon, 18 Feb 2013 02:01:17 +0100
Message-ID: <1361149277-1026-2-git-send-email-teg@jklm.no>
References: <1361149277-1026-1-git-send-email-teg@jklm.no>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361149277-1026-1-git-send-email-teg-B22kvLQNl6c@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

As part of the splitting up of efivars this got renamed to 'sysfs', rename it
back to 'efivars' for backwards compatibility.

Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
---
 drivers/firmware/efi/Kconfig   |   2 +
 drivers/firmware/efi/Makefile  |   2 +-
 drivers/firmware/efi/efivars.c | 555 +++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/sysfs.c   | 555 -----------------------------------------
 4 files changed, 558 insertions(+), 556 deletions(-)
 create mode 100644 drivers/firmware/efi/efivars.c
 delete mode 100644 drivers/firmware/efi/sysfs.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index e83ef8f..8ca7476 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -41,6 +41,8 @@ config EFI_VARS_SYSFS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://linux.dell.com/efibootmgr>
 
+	  If built as a module it will be called efivars.
+
 config EFI_VARS_PSTORE
 	tristate "EFI Variable Persistent Storage"
 	depends on PSTORE
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 9660b3d..705b63e 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -3,6 +3,6 @@
 #
 obj-$(CONFIG_EFI)			+= efi.o
 obj-$(CONFIG_EFI_VARS)			+= vars.o
-obj-$(CONFIG_EFI_VARS_SYSFS)		+= sysfs.o
+obj-$(CONFIG_EFI_VARS_SYSFS)		+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= pstore.o
 obj-$(CONFIG_EFI_VARS_GENERIC_OPS)	+= generic-ops.o
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
new file mode 100644
index 0000000..d61ab95
--- /dev/null
+++ b/drivers/firmware/efi/efivars.c
@@ -0,0 +1,555 @@
+/*
+ * Originally from efivars.c,
+ *
+ * Copyright (C) 2001,2003,2004 Dell <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ * Copyright (C) 2004 Intel Corporation <matthew.e.tolentino-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *
+ * This code takes all variables accessible from EFI runtime and
+ *  exports them via sysfs
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Changelog:
+ *
+ *  17 May 2004 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ *   remove check for efi_enabled in exit
+ *   add MODULE_VERSION
+ *
+ *  26 Apr 2004 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ *   minor bug fixes
+ *
+ *  21 Apr 2004 - Matt Tolentino <matthew.e.tolentino-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)
+ *   converted driver to export variable information via sysfs
+ *   and moved to drivers/firmware directory
+ *   bumped revision number to v0.07 to reflect conversion & move
+ *
+ *  10 Dec 2002 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ *   fix locking per Peter Chubb's findings
+ *
+ *  25 Mar 2002 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ *   move uuid_unparse() to include/asm-ia64/efi.h:efi_guid_unparse()
+ *
+ *  12 Feb 2002 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ *   use list_for_each_safe when deleting vars.
+ *   remove ifdef CONFIG_SMP around include <linux/smp.h>
+ *   v0.04 release to linux-ia64-WygotPe7DYIabbyE177sbg@public.gmane.org
+ *
+ *  20 April 2001 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ *   Moved vars from /proc/efi to /proc/efi/vars, and made
+ *   efi.c own the /proc/efi directory.
+ *   v0.03 release to linux-ia64-WygotPe7DYIabbyE177sbg@public.gmane.org
+ *
+ *  26 March 2001 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ *   At the request of Stephane, moved ownership of /proc/efi
+ *   to efi.c, and now efivars lives under /proc/efi/vars.
+ *
+ *  12 March 2001 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ *   Feedback received from Stephane Eranian incorporated.
+ *   efivar_write() checks copy_from_user() return value.
+ *   efivar_read/write() returns proper errno.
+ *   v0.02 release to linux-ia64-WygotPe7DYIabbyE177sbg@public.gmane.org
+ *
+ *  26 February 2001 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
+ *   v0.01 release to linux-ia64-WygotPe7DYIabbyE177sbg@public.gmane.org
+ */
+
+#include <linux/efi.h>
+#include <linux/module.h>
+
+#define EFIVARS_VERSION "0.08"
+#define EFIVARS_DATE "2004-May-17"
+
+MODULE_AUTHOR("Matt Domsch <Matt_Domsch-DYMqY+WieiM@public.gmane.org>");
+MODULE_DESCRIPTION("sysfs interface to EFI Variables");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(EFIVARS_VERSION);
+
+
+static struct kset *efivars_kset;
+
+static struct bin_attribute *efivars_new_var;
+static struct bin_attribute *efivars_del_var;
+
+struct efivar_attribute {
+	struct attribute attr;
+	ssize_t (*show) (struct efivar_entry *entry, char *buf);
+	ssize_t (*store)(struct efivar_entry *entry, const char *buf, size_t count);
+};
+
+#define EFIVAR_ATTR(_name, _mode, _show, _store) \
+struct efivar_attribute efivar_attr_##_name = { \
+	.attr = {.name = __stringify(_name), .mode = _mode}, \
+	.show = _show, \
+	.store = _store, \
+};
+
+#define to_efivar_attr(_attr) container_of(_attr, struct efivar_attribute, attr)
+#define to_efivar_entry(obj)  container_of(obj, struct efivar_entry, kobj)
+
+static ssize_t
+efivar_guid_read(struct efivar_entry *entry, char *buf)
+{
+	struct efi_variable *var = &entry->var;
+	char *str = buf;
+
+	if (!entry || !buf)
+		return 0;
+
+	efi_guid_unparse(&var->VendorGuid, str);
+	str += strlen(str);
+	str += sprintf(str, "\n");
+
+	return str - buf;
+}
+
+static ssize_t
+efivar_attr_read(struct efivar_entry *entry, char *buf)
+{
+	struct efi_variable *var = &entry->var;
+	char *str = buf;
+
+	if (!entry || !buf)
+		return -EINVAL;
+
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
+		return -EIO;
+
+	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
+		str += sprintf(str, "EFI_VARIABLE_NON_VOLATILE\n");
+	if (var->Attributes & EFI_VARIABLE_BOOTSERVICE_ACCESS)
+		str += sprintf(str, "EFI_VARIABLE_BOOTSERVICE_ACCESS\n");
+	if (var->Attributes & EFI_VARIABLE_RUNTIME_ACCESS)
+		str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
+	if (var->Attributes & EFI_VARIABLE_HARDWARE_ERROR_RECORD)
+		str += sprintf(str, "EFI_VARIABLE_HARDWARE_ERROR_RECORD\n");
+	if (var->Attributes & EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS)
+		str += sprintf(str,
+			"EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS\n");
+	if (var->Attributes &
+			EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS)
+		str += sprintf(str,
+			"EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS\n");
+	if (var->Attributes & EFI_VARIABLE_APPEND_WRITE)
+		str += sprintf(str, "EFI_VARIABLE_APPEND_WRITE\n");
+	return str - buf;
+}
+
+static ssize_t
+efivar_size_read(struct efivar_entry *entry, char *buf)
+{
+	struct efi_variable *var = &entry->var;
+	char *str = buf;
+
+	if (!entry || !buf)
+		return -EINVAL;
+
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
+		return -EIO;
+
+	str += sprintf(str, "0x%lx\n", var->DataSize);
+	return str - buf;
+}
+
+static ssize_t
+efivar_data_read(struct efivar_entry *entry, char *buf)
+{
+	struct efi_variable *var = &entry->var;
+
+	if (!entry || !buf)
+		return -EINVAL;
+
+	var->DataSize = 1024;
+	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
+		return -EIO;
+
+	memcpy(buf, var->Data, var->DataSize);
+	return var->DataSize;
+}
+/*
+ * We allow each variable to be edited via rewriting the
+ * entire efi variable structure.
+ */
+static ssize_t
+efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
+{
+	struct efi_variable *new_var, *var = &entry->var;
+	int err;
+
+	if (count != sizeof(struct efi_variable))
+		return -EINVAL;
+
+	new_var = (struct efi_variable *)buf;
+	/*
+	 * If only updating the variable data, then the name
+	 * and guid should remain the same
+	 */
+	if (memcmp(new_var->VariableName, var->VariableName, sizeof(var->VariableName)) ||
+		efi_guidcmp(new_var->VendorGuid, var->VendorGuid)) {
+		printk(KERN_ERR "efivars: Cannot edit the wrong variable!\n");
+		return -EINVAL;
+	}
+
+	if ((new_var->DataSize <= 0) || (new_var->Attributes == 0)){
+		printk(KERN_ERR "efivars: DataSize & Attributes must be valid!\n");
+		return -EINVAL;
+	}
+
+	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
+	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
+		printk(KERN_ERR "efivars: Malformed variable content\n");
+		return -EINVAL;
+	}
+
+	memcpy(&entry->var, new_var, count);
+
+	err = efivar_entry_set(entry, new_var->Attributes,
+			       new_var->DataSize, new_var->Data, false);
+	if (err) {
+		printk(KERN_WARNING "efivars: set_variable() failed: status=%d\n", err);
+		return -EIO;
+	}
+
+	return count;
+}
+
+static ssize_t
+efivar_show_raw(struct efivar_entry *entry, char *buf)
+{
+	struct efi_variable *var = &entry->var;
+
+	if (!entry || !buf)
+		return 0;
+
+	memcpy(buf, var, sizeof(*var));
+
+	if (efivar_entry_get(entry, &entry->var.Attributes,
+			     &entry->var.DataSize, entry->var.Data))
+		return -EIO;
+
+	return sizeof(*var);
+}
+
+/*
+ * Generic read/write functions that call the specific functions of
+ * the attributes...
+ */
+static ssize_t efivar_attr_show(struct kobject *kobj, struct attribute *attr,
+				char *buf)
+{
+	struct efivar_entry *var = to_efivar_entry(kobj);
+	struct efivar_attribute *efivar_attr = to_efivar_attr(attr);
+	ssize_t ret = -EIO;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (efivar_attr->show) {
+		ret = efivar_attr->show(var, buf);
+	}
+	return ret;
+}
+
+static ssize_t efivar_attr_store(struct kobject *kobj, struct attribute *attr,
+				const char *buf, size_t count)
+{
+	struct efivar_entry *var = to_efivar_entry(kobj);
+	struct efivar_attribute *efivar_attr = to_efivar_attr(attr);
+	ssize_t ret = -EIO;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (efivar_attr->store)
+		ret = efivar_attr->store(var, buf, count);
+
+	return ret;
+}
+
+static const struct sysfs_ops efivar_attr_ops = {
+	.show = efivar_attr_show,
+	.store = efivar_attr_store,
+};
+
+static void efivar_release(struct kobject *kobj)
+{
+	struct efivar_entry *var = container_of(kobj, struct efivar_entry, kobj);
+	kfree(var);
+}
+
+static EFIVAR_ATTR(guid, 0400, efivar_guid_read, NULL);
+static EFIVAR_ATTR(attributes, 0400, efivar_attr_read, NULL);
+static EFIVAR_ATTR(size, 0400, efivar_size_read, NULL);
+static EFIVAR_ATTR(data, 0400, efivar_data_read, NULL);
+static EFIVAR_ATTR(raw_var, 0600, efivar_show_raw, efivar_store_raw);
+
+static struct attribute *def_attrs[] = {
+	&efivar_attr_guid.attr,
+	&efivar_attr_size.attr,
+	&efivar_attr_attributes.attr,
+	&efivar_attr_data.attr,
+	&efivar_attr_raw_var.attr,
+	NULL,
+};
+
+static struct kobj_type efivar_ktype = {
+	.release = efivar_release,
+	.sysfs_ops = &efivar_attr_ops,
+	.default_attrs = def_attrs,
+};
+
+static inline void
+efivar_unregister(struct efivar_entry *var)
+{
+	kobject_put(&var->kobj);
+}
+
+static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buf, loff_t pos, size_t count)
+{
+	struct efi_variable *new_var = (struct efi_variable *)buf;
+	struct efivar_entry *new_entry;
+	efi_status_t status = EFI_NOT_FOUND;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
+	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
+		printk(KERN_ERR "efivars: Malformed variable content\n");
+		return -EINVAL;
+	}
+
+	new_entry = kmalloc(sizeof(*new_entry), GFP_KERNEL);
+	if (!new_entry)
+		return -ENOMEM;
+
+	memcpy(&new_entry->var, new_var, sizeof(*new_var));
+
+	status = efivar_entry_set(new_entry, new_var->Attributes,
+				  new_var->DataSize, new_var->Data, true);
+	if (status == -EEXIST)
+		return -EINVAL;
+
+	if (status)
+		return status;
+
+	status = efivar_create_sysfs_entry(new_entry);
+	if (status) {
+		kfree(new_entry);
+		printk(KERN_WARNING "efivars: failed to create sysfs entry.\n");
+	}
+	return count;
+}
+
+static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
+			     struct bin_attribute *bin_attr,
+			     char *buf, loff_t pos, size_t count)
+{
+	struct efi_variable *del_var = (struct efi_variable *)buf;
+	struct efivar_entry *entry;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	efivar_entry_iter_begin();
+	entry = efivar_entry_find(del_var->VariableName,
+				  del_var->VendorGuid, true);
+	if (!entry)
+		err = -EINVAL;
+	else
+		err = __efivar_entry_delete(entry);
+	efivar_entry_iter_end();
+
+	if (err)
+		return -EIO;
+
+	efivar_unregister(entry);
+
+	/* It's dead Jim.... */
+	return count;
+}
+
+/*
+ * efivar_create_sysfs_entry()
+ * Requires:
+ *    variable_name_size = number of bytes required to hold
+ *                         variable_name (not counting the NULL
+ *                         character at the end.
+ * Returns 1 on failure, 0 on success
+ */
+int
+efivar_create_sysfs_entry(struct efivar_entry *new_var)
+{
+	int i, short_name_size;
+	char *short_name;
+	unsigned long variable_name_size;
+	efi_char16_t *variable_name;
+
+	variable_name = new_var->var.VariableName;
+	variable_name_size = utf16_strlen(variable_name) * sizeof(efi_char16_t);
+
+	/*
+	 * Length of the variable bytes in ASCII, plus the '-' separator,
+	 * plus the GUID, plus trailing NUL
+	 */
+	short_name_size = variable_name_size / sizeof(efi_char16_t)
+				+ 1 + EFI_VARIABLE_GUID_LEN + 1;
+
+	short_name = kzalloc(short_name_size, GFP_KERNEL);
+
+	if (!short_name) {
+		kfree(short_name);
+		return 1;
+	}
+
+	/* Convert Unicode to normal chars (assume top bits are 0),
+	   ala UTF-8 */
+	for (i=0; i < (int)(variable_name_size / sizeof(efi_char16_t)); i++) {
+		short_name[i] = variable_name[i] & 0xFF;
+	}
+	/* This is ugly, but necessary to separate one vendor's
+	   private variables from another's.         */
+
+	*(short_name + strlen(short_name)) = '-';
+	efi_guid_unparse(&new_var->var.VendorGuid,
+			 short_name + strlen(short_name));
+
+	new_var->kobj.kset = efivars_kset;
+
+	i = kobject_init_and_add(&new_var->kobj, &efivar_ktype,
+				   NULL, "%s", short_name);
+	kfree(short_name);
+	if (i)
+		return 1;
+
+	kobject_uevent(&new_var->kobj, KOBJ_ADD);
+	efivar_entry_add(new_var);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(efivar_create_sysfs_entry);
+
+static int
+create_efivars_bin_attributes(void)
+{
+	struct bin_attribute *attr;
+	int error;
+
+	/* new_var */
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	attr->attr.name = "new_var";
+	attr->attr.mode = 0200;
+	attr->write = efivar_create;
+	efivars_new_var = attr;
+
+	/* del_var */
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr) {
+		error = -ENOMEM;
+		goto out_free;
+	}
+	attr->attr.name = "del_var";
+	attr->attr.mode = 0200;
+	attr->write = efivar_delete;
+	efivars_del_var = attr;
+
+	sysfs_bin_attr_init(efivars_new_var);
+	sysfs_bin_attr_init(efivars_del_var);
+
+	/* Register */
+	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_new_var);
+	if (error) {
+		printk(KERN_ERR "efivars: unable to create new_var sysfs file"
+			" due to error %d\n", error);
+		goto out_free;
+	}
+
+	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_del_var);
+	if (error) {
+		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
+			" due to error %d\n", error);
+		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
+		goto out_free;
+	}
+
+	return 0;
+out_free:
+	kfree(efivars_del_var);
+	efivars_del_var = NULL;
+	kfree(efivars_new_var);
+	efivars_new_var = NULL;
+	return error;
+}
+
+static int efivars_sysfs_callback(struct efivar_entry *entry, void *data)
+{
+	efivar_create_sysfs_entry(entry);
+	return 0;
+}
+
+static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
+{
+	efivar_entry_remove(entry);
+	efivar_unregister(entry);
+	return 0;
+}
+
+void efivars_sysfs_exit(void)
+{
+	/* Remove all entries and destroy */
+	__efivar_entry_iter(efivar_sysfs_destroy, NULL, NULL);
+
+	if (efivars_new_var)
+		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
+	if (efivars_del_var)
+		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_del_var);
+	kfree(efivars_new_var);
+	kfree(efivars_del_var);
+	kset_unregister(efivars_kset);
+}
+
+int efivars_sysfs_init(void)
+{
+	int error = 0;
+
+	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
+	       EFIVARS_DATE);
+
+#if defined(CONFIG_EFI_VARS_GENERIC_OPS)
+	efivars_kset = kset_create_and_add("vars", NULL, efi_kobj);
+#elif defined(CONFIG_GOOGLE_SMI) || defined(CONFIG_GOOGLE_SMI_MODULE)
+	efivars_kset = kset_create_and_add("vars", NULL, gsmi_kobj);
+#endif
+	if (!efivars_kset) {
+		pr_err("efivars: Subsystem registration failed.\n");
+		return -ENOMEM;
+	}
+
+	efivar_init(efivars_sysfs_callback, NULL);
+
+	error = create_efivars_bin_attributes();
+	if (error)
+		efivars_sysfs_exit();
+
+	return error;
+}
+
+module_init(efivars_sysfs_init);
diff --git a/drivers/firmware/efi/sysfs.c b/drivers/firmware/efi/sysfs.c
deleted file mode 100644
index d61ab95..0000000
--- a/drivers/firmware/efi/sysfs.c
+++ /dev/null
@@ -1,555 +0,0 @@
-/*
- * Originally from efivars.c,
- *
- * Copyright (C) 2001,2003,2004 Dell <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- * Copyright (C) 2004 Intel Corporation <matthew.e.tolentino-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
- *
- * This code takes all variables accessible from EFI runtime and
- *  exports them via sysfs
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- * Changelog:
- *
- *  17 May 2004 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   remove check for efi_enabled in exit
- *   add MODULE_VERSION
- *
- *  26 Apr 2004 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   minor bug fixes
- *
- *  21 Apr 2004 - Matt Tolentino <matthew.e.tolentino-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)
- *   converted driver to export variable information via sysfs
- *   and moved to drivers/firmware directory
- *   bumped revision number to v0.07 to reflect conversion & move
- *
- *  10 Dec 2002 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   fix locking per Peter Chubb's findings
- *
- *  25 Mar 2002 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   move uuid_unparse() to include/asm-ia64/efi.h:efi_guid_unparse()
- *
- *  12 Feb 2002 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   use list_for_each_safe when deleting vars.
- *   remove ifdef CONFIG_SMP around include <linux/smp.h>
- *   v0.04 release to linux-ia64-WygotPe7DYIabbyE177sbg@public.gmane.org
- *
- *  20 April 2001 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   Moved vars from /proc/efi to /proc/efi/vars, and made
- *   efi.c own the /proc/efi directory.
- *   v0.03 release to linux-ia64-WygotPe7DYIabbyE177sbg@public.gmane.org
- *
- *  26 March 2001 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   At the request of Stephane, moved ownership of /proc/efi
- *   to efi.c, and now efivars lives under /proc/efi/vars.
- *
- *  12 March 2001 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   Feedback received from Stephane Eranian incorporated.
- *   efivar_write() checks copy_from_user() return value.
- *   efivar_read/write() returns proper errno.
- *   v0.02 release to linux-ia64-WygotPe7DYIabbyE177sbg@public.gmane.org
- *
- *  26 February 2001 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   v0.01 release to linux-ia64-WygotPe7DYIabbyE177sbg@public.gmane.org
- */
-
-#include <linux/efi.h>
-#include <linux/module.h>
-
-#define EFIVARS_VERSION "0.08"
-#define EFIVARS_DATE "2004-May-17"
-
-MODULE_AUTHOR("Matt Domsch <Matt_Domsch-DYMqY+WieiM@public.gmane.org>");
-MODULE_DESCRIPTION("sysfs interface to EFI Variables");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(EFIVARS_VERSION);
-
-
-static struct kset *efivars_kset;
-
-static struct bin_attribute *efivars_new_var;
-static struct bin_attribute *efivars_del_var;
-
-struct efivar_attribute {
-	struct attribute attr;
-	ssize_t (*show) (struct efivar_entry *entry, char *buf);
-	ssize_t (*store)(struct efivar_entry *entry, const char *buf, size_t count);
-};
-
-#define EFIVAR_ATTR(_name, _mode, _show, _store) \
-struct efivar_attribute efivar_attr_##_name = { \
-	.attr = {.name = __stringify(_name), .mode = _mode}, \
-	.show = _show, \
-	.store = _store, \
-};
-
-#define to_efivar_attr(_attr) container_of(_attr, struct efivar_attribute, attr)
-#define to_efivar_entry(obj)  container_of(obj, struct efivar_entry, kobj)
-
-static ssize_t
-efivar_guid_read(struct efivar_entry *entry, char *buf)
-{
-	struct efi_variable *var = &entry->var;
-	char *str = buf;
-
-	if (!entry || !buf)
-		return 0;
-
-	efi_guid_unparse(&var->VendorGuid, str);
-	str += strlen(str);
-	str += sprintf(str, "\n");
-
-	return str - buf;
-}
-
-static ssize_t
-efivar_attr_read(struct efivar_entry *entry, char *buf)
-{
-	struct efi_variable *var = &entry->var;
-	char *str = buf;
-
-	if (!entry || !buf)
-		return -EINVAL;
-
-	var->DataSize = 1024;
-	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
-		return -EIO;
-
-	if (var->Attributes & EFI_VARIABLE_NON_VOLATILE)
-		str += sprintf(str, "EFI_VARIABLE_NON_VOLATILE\n");
-	if (var->Attributes & EFI_VARIABLE_BOOTSERVICE_ACCESS)
-		str += sprintf(str, "EFI_VARIABLE_BOOTSERVICE_ACCESS\n");
-	if (var->Attributes & EFI_VARIABLE_RUNTIME_ACCESS)
-		str += sprintf(str, "EFI_VARIABLE_RUNTIME_ACCESS\n");
-	if (var->Attributes & EFI_VARIABLE_HARDWARE_ERROR_RECORD)
-		str += sprintf(str, "EFI_VARIABLE_HARDWARE_ERROR_RECORD\n");
-	if (var->Attributes & EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS)
-		str += sprintf(str,
-			"EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS\n");
-	if (var->Attributes &
-			EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS)
-		str += sprintf(str,
-			"EFI_VARIABLE_TIME_BASED_AUTHENTICATED_WRITE_ACCESS\n");
-	if (var->Attributes & EFI_VARIABLE_APPEND_WRITE)
-		str += sprintf(str, "EFI_VARIABLE_APPEND_WRITE\n");
-	return str - buf;
-}
-
-static ssize_t
-efivar_size_read(struct efivar_entry *entry, char *buf)
-{
-	struct efi_variable *var = &entry->var;
-	char *str = buf;
-
-	if (!entry || !buf)
-		return -EINVAL;
-
-	var->DataSize = 1024;
-	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
-		return -EIO;
-
-	str += sprintf(str, "0x%lx\n", var->DataSize);
-	return str - buf;
-}
-
-static ssize_t
-efivar_data_read(struct efivar_entry *entry, char *buf)
-{
-	struct efi_variable *var = &entry->var;
-
-	if (!entry || !buf)
-		return -EINVAL;
-
-	var->DataSize = 1024;
-	if (efivar_entry_get(entry, &var->Attributes, &var->DataSize, var->Data))
-		return -EIO;
-
-	memcpy(buf, var->Data, var->DataSize);
-	return var->DataSize;
-}
-/*
- * We allow each variable to be edited via rewriting the
- * entire efi variable structure.
- */
-static ssize_t
-efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
-{
-	struct efi_variable *new_var, *var = &entry->var;
-	int err;
-
-	if (count != sizeof(struct efi_variable))
-		return -EINVAL;
-
-	new_var = (struct efi_variable *)buf;
-	/*
-	 * If only updating the variable data, then the name
-	 * and guid should remain the same
-	 */
-	if (memcmp(new_var->VariableName, var->VariableName, sizeof(var->VariableName)) ||
-		efi_guidcmp(new_var->VendorGuid, var->VendorGuid)) {
-		printk(KERN_ERR "efivars: Cannot edit the wrong variable!\n");
-		return -EINVAL;
-	}
-
-	if ((new_var->DataSize <= 0) || (new_var->Attributes == 0)){
-		printk(KERN_ERR "efivars: DataSize & Attributes must be valid!\n");
-		return -EINVAL;
-	}
-
-	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
-		printk(KERN_ERR "efivars: Malformed variable content\n");
-		return -EINVAL;
-	}
-
-	memcpy(&entry->var, new_var, count);
-
-	err = efivar_entry_set(entry, new_var->Attributes,
-			       new_var->DataSize, new_var->Data, false);
-	if (err) {
-		printk(KERN_WARNING "efivars: set_variable() failed: status=%d\n", err);
-		return -EIO;
-	}
-
-	return count;
-}
-
-static ssize_t
-efivar_show_raw(struct efivar_entry *entry, char *buf)
-{
-	struct efi_variable *var = &entry->var;
-
-	if (!entry || !buf)
-		return 0;
-
-	memcpy(buf, var, sizeof(*var));
-
-	if (efivar_entry_get(entry, &entry->var.Attributes,
-			     &entry->var.DataSize, entry->var.Data))
-		return -EIO;
-
-	return sizeof(*var);
-}
-
-/*
- * Generic read/write functions that call the specific functions of
- * the attributes...
- */
-static ssize_t efivar_attr_show(struct kobject *kobj, struct attribute *attr,
-				char *buf)
-{
-	struct efivar_entry *var = to_efivar_entry(kobj);
-	struct efivar_attribute *efivar_attr = to_efivar_attr(attr);
-	ssize_t ret = -EIO;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	if (efivar_attr->show) {
-		ret = efivar_attr->show(var, buf);
-	}
-	return ret;
-}
-
-static ssize_t efivar_attr_store(struct kobject *kobj, struct attribute *attr,
-				const char *buf, size_t count)
-{
-	struct efivar_entry *var = to_efivar_entry(kobj);
-	struct efivar_attribute *efivar_attr = to_efivar_attr(attr);
-	ssize_t ret = -EIO;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	if (efivar_attr->store)
-		ret = efivar_attr->store(var, buf, count);
-
-	return ret;
-}
-
-static const struct sysfs_ops efivar_attr_ops = {
-	.show = efivar_attr_show,
-	.store = efivar_attr_store,
-};
-
-static void efivar_release(struct kobject *kobj)
-{
-	struct efivar_entry *var = container_of(kobj, struct efivar_entry, kobj);
-	kfree(var);
-}
-
-static EFIVAR_ATTR(guid, 0400, efivar_guid_read, NULL);
-static EFIVAR_ATTR(attributes, 0400, efivar_attr_read, NULL);
-static EFIVAR_ATTR(size, 0400, efivar_size_read, NULL);
-static EFIVAR_ATTR(data, 0400, efivar_data_read, NULL);
-static EFIVAR_ATTR(raw_var, 0600, efivar_show_raw, efivar_store_raw);
-
-static struct attribute *def_attrs[] = {
-	&efivar_attr_guid.attr,
-	&efivar_attr_size.attr,
-	&efivar_attr_attributes.attr,
-	&efivar_attr_data.attr,
-	&efivar_attr_raw_var.attr,
-	NULL,
-};
-
-static struct kobj_type efivar_ktype = {
-	.release = efivar_release,
-	.sysfs_ops = &efivar_attr_ops,
-	.default_attrs = def_attrs,
-};
-
-static inline void
-efivar_unregister(struct efivar_entry *var)
-{
-	kobject_put(&var->kobj);
-}
-
-static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
-			     struct bin_attribute *bin_attr,
-			     char *buf, loff_t pos, size_t count)
-{
-	struct efi_variable *new_var = (struct efi_variable *)buf;
-	struct efivar_entry *new_entry;
-	efi_status_t status = EFI_NOT_FOUND;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	if ((new_var->Attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    efivar_validate(new_var, new_var->Data, new_var->DataSize) == false) {
-		printk(KERN_ERR "efivars: Malformed variable content\n");
-		return -EINVAL;
-	}
-
-	new_entry = kmalloc(sizeof(*new_entry), GFP_KERNEL);
-	if (!new_entry)
-		return -ENOMEM;
-
-	memcpy(&new_entry->var, new_var, sizeof(*new_var));
-
-	status = efivar_entry_set(new_entry, new_var->Attributes,
-				  new_var->DataSize, new_var->Data, true);
-	if (status == -EEXIST)
-		return -EINVAL;
-
-	if (status)
-		return status;
-
-	status = efivar_create_sysfs_entry(new_entry);
-	if (status) {
-		kfree(new_entry);
-		printk(KERN_WARNING "efivars: failed to create sysfs entry.\n");
-	}
-	return count;
-}
-
-static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
-			     struct bin_attribute *bin_attr,
-			     char *buf, loff_t pos, size_t count)
-{
-	struct efi_variable *del_var = (struct efi_variable *)buf;
-	struct efivar_entry *entry;
-	int err;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-
-	efivar_entry_iter_begin();
-	entry = efivar_entry_find(del_var->VariableName,
-				  del_var->VendorGuid, true);
-	if (!entry)
-		err = -EINVAL;
-	else
-		err = __efivar_entry_delete(entry);
-	efivar_entry_iter_end();
-
-	if (err)
-		return -EIO;
-
-	efivar_unregister(entry);
-
-	/* It's dead Jim.... */
-	return count;
-}
-
-/*
- * efivar_create_sysfs_entry()
- * Requires:
- *    variable_name_size = number of bytes required to hold
- *                         variable_name (not counting the NULL
- *                         character at the end.
- * Returns 1 on failure, 0 on success
- */
-int
-efivar_create_sysfs_entry(struct efivar_entry *new_var)
-{
-	int i, short_name_size;
-	char *short_name;
-	unsigned long variable_name_size;
-	efi_char16_t *variable_name;
-
-	variable_name = new_var->var.VariableName;
-	variable_name_size = utf16_strlen(variable_name) * sizeof(efi_char16_t);
-
-	/*
-	 * Length of the variable bytes in ASCII, plus the '-' separator,
-	 * plus the GUID, plus trailing NUL
-	 */
-	short_name_size = variable_name_size / sizeof(efi_char16_t)
-				+ 1 + EFI_VARIABLE_GUID_LEN + 1;
-
-	short_name = kzalloc(short_name_size, GFP_KERNEL);
-
-	if (!short_name) {
-		kfree(short_name);
-		return 1;
-	}
-
-	/* Convert Unicode to normal chars (assume top bits are 0),
-	   ala UTF-8 */
-	for (i=0; i < (int)(variable_name_size / sizeof(efi_char16_t)); i++) {
-		short_name[i] = variable_name[i] & 0xFF;
-	}
-	/* This is ugly, but necessary to separate one vendor's
-	   private variables from another's.         */
-
-	*(short_name + strlen(short_name)) = '-';
-	efi_guid_unparse(&new_var->var.VendorGuid,
-			 short_name + strlen(short_name));
-
-	new_var->kobj.kset = efivars_kset;
-
-	i = kobject_init_and_add(&new_var->kobj, &efivar_ktype,
-				   NULL, "%s", short_name);
-	kfree(short_name);
-	if (i)
-		return 1;
-
-	kobject_uevent(&new_var->kobj, KOBJ_ADD);
-	efivar_entry_add(new_var);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(efivar_create_sysfs_entry);
-
-static int
-create_efivars_bin_attributes(void)
-{
-	struct bin_attribute *attr;
-	int error;
-
-	/* new_var */
-	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
-	if (!attr)
-		return -ENOMEM;
-
-	attr->attr.name = "new_var";
-	attr->attr.mode = 0200;
-	attr->write = efivar_create;
-	efivars_new_var = attr;
-
-	/* del_var */
-	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
-	if (!attr) {
-		error = -ENOMEM;
-		goto out_free;
-	}
-	attr->attr.name = "del_var";
-	attr->attr.mode = 0200;
-	attr->write = efivar_delete;
-	efivars_del_var = attr;
-
-	sysfs_bin_attr_init(efivars_new_var);
-	sysfs_bin_attr_init(efivars_del_var);
-
-	/* Register */
-	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_new_var);
-	if (error) {
-		printk(KERN_ERR "efivars: unable to create new_var sysfs file"
-			" due to error %d\n", error);
-		goto out_free;
-	}
-
-	error = sysfs_create_bin_file(&efivars_kset->kobj, efivars_del_var);
-	if (error) {
-		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
-			" due to error %d\n", error);
-		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
-		goto out_free;
-	}
-
-	return 0;
-out_free:
-	kfree(efivars_del_var);
-	efivars_del_var = NULL;
-	kfree(efivars_new_var);
-	efivars_new_var = NULL;
-	return error;
-}
-
-static int efivars_sysfs_callback(struct efivar_entry *entry, void *data)
-{
-	efivar_create_sysfs_entry(entry);
-	return 0;
-}
-
-static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
-{
-	efivar_entry_remove(entry);
-	efivar_unregister(entry);
-	return 0;
-}
-
-void efivars_sysfs_exit(void)
-{
-	/* Remove all entries and destroy */
-	__efivar_entry_iter(efivar_sysfs_destroy, NULL, NULL);
-
-	if (efivars_new_var)
-		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
-	if (efivars_del_var)
-		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_del_var);
-	kfree(efivars_new_var);
-	kfree(efivars_del_var);
-	kset_unregister(efivars_kset);
-}
-
-int efivars_sysfs_init(void)
-{
-	int error = 0;
-
-	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
-	       EFIVARS_DATE);
-
-#if defined(CONFIG_EFI_VARS_GENERIC_OPS)
-	efivars_kset = kset_create_and_add("vars", NULL, efi_kobj);
-#elif defined(CONFIG_GOOGLE_SMI) || defined(CONFIG_GOOGLE_SMI_MODULE)
-	efivars_kset = kset_create_and_add("vars", NULL, gsmi_kobj);
-#endif
-	if (!efivars_kset) {
-		pr_err("efivars: Subsystem registration failed.\n");
-		return -ENOMEM;
-	}
-
-	efivar_init(efivars_sysfs_callback, NULL);
-
-	error = create_efivars_bin_attributes();
-	if (error)
-		efivars_sysfs_exit();
-
-	return error;
-}
-
-module_init(efivars_sysfs_init);
-- 
1.8.1.3
