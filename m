From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 4/7] drivers/firmware: Create a new EFI drivers directory
Date: Fri,  8 Feb 2013 20:59:15 +0000
Message-ID: <1360357158-8168-5-git-send-email-matt@console-pimps.org>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360357158-8168-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

efivars.c has grown far too large and needs to be divided up.

Move the sysfs support code for EFI variables into efi/ so that it is
more self-contained. This also allows enabling the efivarfs code
without requiring that the sysfs code be enabled. Having EFI variables
accessible to userland via two different methods is just confusing,
especially given that no synchronisation is done between them.

Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 MAINTAINERS                   |   1 +
 drivers/firmware/Kconfig      |  18 +-
 drivers/firmware/Makefile     |   1 +
 drivers/firmware/efi/Kconfig  |  32 +++
 drivers/firmware/efi/Makefile |   4 +
 drivers/firmware/efi/sysfs.c  | 549 ++++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efivars.c    | 530 +---------------------------------------
 include/linux/efi.h           |   4 +-
 8 files changed, 594 insertions(+), 545 deletions(-)
 create mode 100644 drivers/firmware/efi/Kconfig
 create mode 100644 drivers/firmware/efi/Makefile
 create mode 100644 drivers/firmware/efi/sysfs.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 212c255..e37219d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2892,6 +2892,7 @@ F:	arch/x86/boot/compressed/eboot.[ch]
 F:	arch/x86/include/asm/efi.h
 F:	arch/x86/platform/efi/*
 F:	drivers/firmware/efivars.c
+F:	drivers/firmware/efi/*
 F:	include/linux/efi*.h
 
 EFIFB FRAMEBUFFER DRIVER
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index 9b00072..9387630 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -36,23 +36,6 @@ config FIRMWARE_MEMMAP
 
       See also Documentation/ABI/testing/sysfs-firmware-memmap.
 
-config EFI_VARS
-	tristate "EFI Variable Support via sysfs"
-	depends on EFI
-	default n
-	help
-	  If you say Y here, you are able to get EFI (Extensible Firmware
-	  Interface) variable information via sysfs.  You may read,
-	  write, create, and destroy EFI variables through this interface.
-
-	  Note that using this driver in concert with efibootmgr requires
-	  at least test release version 0.5.0-test3 or later, which is
-	  available from Matt Domsch's website located at:
-	  <http://linux.dell.com/efibootmgr/testing/efibootmgr-0.5.0-test3.tar.gz>
-
-	  Subsequent efibootmgr releases may be found at:
-	  <http://linux.dell.com/efibootmgr>
-
 config EFI_PCDP
 	bool "Console device selection via EFI PCDP or HCDP table"
 	depends on ACPI && EFI && IA64
@@ -146,5 +129,6 @@ config ISCSI_IBFT
 	  Otherwise, say N.
 
 source "drivers/firmware/google/Kconfig"
+source "drivers/firmware/efi/Kconfig"
 
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 5a7e273..31bf68c 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
+obj-$(CONFIG_EFI)		+= efi/
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
new file mode 100644
index 0000000..a4f213c
--- /dev/null
+++ b/drivers/firmware/efi/Kconfig
@@ -0,0 +1,32 @@
+menu "EFI (Extensible Firmware Interface) Support"
+	depends on EFI
+
+config EFI_VARS
+	bool "EFI Variable Support"
+	depends on EFI
+	default n
+	help
+	  This option enables the EFI variable support code.
+
+	  This is required for all EFI variable drivers.
+
+	  If unsure, say N.
+
+config EFI_VARS_SYSFS
+	tristate "EFI Variable Support via sysfs"
+	depends on EFI_VARS
+	default n
+	help
+	  If you say Y here, you are able to get EFI (Extensible Firmware
+	  Interface) variable information via sysfs.  You may read,
+	  write, create, and destroy EFI variables through this interface.
+
+	  Note that using this driver in concert with efibootmgr requires
+	  at least test release version 0.5.0-test3 or later, which is
+	  available from Matt Domsch's website located at:
+	  <http://linux.dell.com/efibootmgr/testing/efibootmgr-0.5.0-test3.tar.gz>
+
+	  Subsequent efibootmgr releases may be found at:
+	  <http://linux.dell.com/efibootmgr>
+
+endmenu
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
new file mode 100644
index 0000000..73ec68b
--- /dev/null
+++ b/drivers/firmware/efi/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for linux kernel
+#
+obj-$(CONFIG_EFI_VARS_SYSFS)		+= sysfs.o
diff --git a/drivers/firmware/efi/sysfs.c b/drivers/firmware/efi/sysfs.c
new file mode 100644
index 0000000..d066eb5
--- /dev/null
+++ b/drivers/firmware/efi/sysfs.c
@@ -0,0 +1,549 @@
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
+int efivars_sysfs_init(struct kobject *parent_kobj)
+{
+	int error = 0;
+
+	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
+	       EFIVARS_DATE);
+
+	efivars_kset = kset_create_and_add("vars", NULL, parent_kobj);
+	if (!efivars_kset) {
+		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
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
+EXPORT_SYMBOL_GPL(efivars_sysfs_init);
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index eb8b157..8934f1d 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -4,9 +4,6 @@
  * Copyright (C) 2001,2003,2004 Dell <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
  * Copyright (C) 2004 Intel Corporation <matthew.e.tolentino-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
  *
- * This code takes all variables accessible from EFI runtime and
- *  exports them via sysfs
- *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
  *  the Free Software Foundation; either version 2 of the License, or
@@ -20,49 +17,6 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
  */
 
 #include <linux/capability.h>
@@ -87,22 +41,8 @@
 
 #include <asm/uaccess.h>
 
-#define EFIVARS_VERSION "0.08"
-#define EFIVARS_DATE "2004-May-17"
-
-MODULE_AUTHOR("Matt Domsch <Matt_Domsch-DYMqY+WieiM@public.gmane.org>");
-MODULE_DESCRIPTION("sysfs interface to EFI Variables");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(EFIVARS_VERSION);
-
 #define DUMP_NAME_LEN 52
 
-struct efivar_attribute {
-	struct attribute attr;
-	ssize_t (*show) (struct efivar_entry *entry, char *buf);
-	ssize_t (*store)(struct efivar_entry *entry, const char *buf, size_t count);
-};
-
 static struct efivars generic_efivars;
 static struct efivar_operations generic_ops;
 
@@ -114,21 +54,6 @@ static struct efivars *__efivars;
 	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
 	 EFI_VARIABLE_RUNTIME_ACCESS)
 
-static struct kset *efivars_kset;
-
-static struct bin_attribute *efivars_new_var;
-static struct bin_attribute *efivars_del_var;
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
 /*
  * Return the number of bytes is the length of this string
  * Note: this is NOT the same as the number of unicode characters
@@ -342,225 +267,6 @@ efivar_validate(struct efi_variable *var, u8 *data, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(efivar_validate);
 
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
 static int efivarfs_file_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -1081,7 +787,7 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
 
 static struct pstore_info efi_pstore_info;
 
-#ifdef CONFIG_PSTORE
+#if defined(CONFIG_PSTORE) && (defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE))
 
 static int efi_pstore_open(struct pstore_info *psi)
 {
@@ -1323,74 +1029,6 @@ static struct pstore_info efi_pstore_info = {
 	.erase		= efi_pstore_erase,
 };
 
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
 /*
  * Let's not leave out systab information that snuck into
  * the efivars driver
@@ -1435,170 +1073,6 @@ static struct attribute_group efi_subsys_attr_group = {
 
 static struct kobject *efi_kobj;
 
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
-int efivars_sysfs_init(struct kobject *parent_kobj)
-{
-	int error = 0;
-
-	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
-	       EFIVARS_DATE);
-
-	efivars_kset = kset_create_and_add("vars", NULL, parent_kobj);
-	if (!efivars_kset) {
-		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
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
-EXPORT_SYMBOL_GPL(efivars_sysfs_init);
-
 /**
  * efivar_init - build the initial list of EFI variables
  * @func: callback function to invoke for every variable
@@ -2173,7 +1647,9 @@ efivars_init(void)
 	if (error)
 		return error;
 
+#if defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE)
 	efivars_sysfs_init(efi_kobj);
+#endif
 
 	efivars_kobject = kobject_create_and_add("efivars", efi_kobj);
 	if (!efivars_kobject) {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 97837f8..47a66ec 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -742,7 +742,7 @@ utf16_strlen(efi_char16_t *s)
 	return utf16_strnlen(s, ~0UL);
 }
 
-#if defined(CONFIG_EFI_VARS) || defined(CONFIG_EFI_VARS_MODULE)
+#ifdef CONFIG_EFI_VARS
 /*
  * EFI Variable support.
  *
@@ -829,8 +829,10 @@ bool efivar_validate(struct efi_variable *var, u8 *data, unsigned long len);
 int efivar_query_info(u32 attributes, u64 *storage_size,
 		      u64 *remaining_size, u64 *max_size);
 
+#if defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE)
 int efivars_sysfs_init(struct kobject *parent);
 int efivar_create_sysfs_entry(struct efivar_entry *new_var);
+#endif
 
 #endif /* CONFIG_EFI_VARS */
 
-- 
1.7.11.7
