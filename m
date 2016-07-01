From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5 6/8] efi: load SSTDs from EFI variables
Date: Fri,  1 Jul 2016 23:19:10 +0300
Message-ID: <1467404352-27101-7-git-send-email-octavian.purdila@intel.com>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467404352-27101-1-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J . Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Cc: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leonard.crestez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch allows SSDTs to be loaded from EFI variables. It works by
specifying the EFI variable name containing the SSDT to be loaded. All
variables with the same name (regardless of the vendor GUID) will be
loaded.

Note that we can't use acpi_install_table and we must rely on the
dynamic ACPI table loading and bus re-scanning mechanisms. That is
because I2C/SPI controllers are initialized earlier then the EFI
subsystems and all I2C/SPI ACPI devices are enumerated when the
I2C/SPI controllers are initialized.

Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/acpi/ssdt-overlays.txt | 67 ++++++++++++++++++++++++++++
 Documentation/kernel-parameters.txt  |  7 +++
 drivers/firmware/efi/efi.c           | 85 ++++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+)

diff --git a/Documentation/acpi/ssdt-overlays.txt b/Documentation/acpi/ssdt-overlays.txt
index 8050259..c4b57ba 100644
--- a/Documentation/acpi/ssdt-overlays.txt
+++ b/Documentation/acpi/ssdt-overlays.txt
@@ -89,3 +89,70 @@ cp ssdt.aml kernel/firmware/acpi
 # on top:
 find kernel | cpio -H newc --create > /boot/instrumented_initrd
 cat /boot/initrd >>/boot/instrumented_initrd
+
+== Loading ACPI SSDTs from EFI variables ==
+
+This is the preferred method, when EFI is supported on the platform, because it
+allows a persistent, OS independent way of storing the user defined SSDTs. There
+is also work underway to implement EFI support for loading user defined SSDTs
+and using this method will make it easier to convert to the EFI loading
+mechanism when that will arrive.
+
+In order to load SSDTs from an EFI variable the efivar_ssdt kernel command line
+parameter can be used. The argument for the option is the variable name to
+use. If there are multiple variables with the same name but with different
+vendor GUIDs, all of them will be loaded.
+
+In order to store the AML code in an EFI variable the efivarfs filesystem can be
+used. It is enabled and mounted by default in /sys/firmware/efi/efivars in all
+recent distribution.
+
+Creating a new file in /sys/firmware/efi/efivars will automatically create a new
+EFI variable. Updating a file in /sys/firmware/efi/efivars will update the EFI
+variable. Please note that the file name needs to be specially formatted as
+"Name-GUID" and that the first 4 bytes in the file (little-endian format)
+represent the attributes of the EFI variable (see EFI_VARIABLE_MASK in
+include/linux/efi.h). Writing to the file must also be done with one write
+operation.
+
+For example, you can use the following bash script to create/update an EFI
+variable with the content from a given file:
+
+#!/bin/sh -e
+
+while ! [ -z "$1" ]; do
+        case "$1" in
+        "-f") filename="$2"; shift;;
+        "-g") guid="$2"; shift;;
+        *) name="$1";;
+        esac
+        shift
+done
+
+usage()
+{
+        echo "Syntax: ${0##*/} -f filename [ -g guid ] name"
+        exit 1
+}
+
+[ -n "$name" -a -f "$filename" ] || usage
+
+EFIVARFS="/sys/firmware/efi/efivars"
+
+[ -d "$EFIVARFS" ] || exit 2
+
+if stat -tf $EFIVARFS | grep -q -v de5e81e4; then
+        mount -t efivarfs none $EFIVARFS
+fi
+
+# try to pick up an existing GUID
+[ -n "$guid" ] || guid=$(find "$EFIVARFS" -name "$name-*" | head -n1 | cut -f2- -d-)
+
+# use a randomly generated GUID
+[ -n "$guid" ] || guid="$(cat /proc/sys/kernel/random/uuid)"
+
+# efivarfs expects all of the data in one write
+tmp=$(mktemp)
+/bin/echo -ne "\007\000\000\000" | cat - $filename > $tmp
+dd if=$tmp of="$EFIVARFS/$name-$guid" bs=$(stat -c %s $tmp)
+rm $tmp
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 82b42c9..bbfb56f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1185,6 +1185,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Address Range Mirroring feature even if your box
 			doesn't support it.
 
+	efivar_ssdt=	[EFI; X86] Name of an EFI variable that contains an SSDT
+			that is to be dynamically loaded by Linux. If there are
+			multiple variables with the same name but with different
+			vendor GUIDs, all of them will be loaded. See
+			Documentation/acpi/ssdt-overlays.txt for details.
+
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 05509f3..02f8efd 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -24,6 +24,9 @@
 #include <linux/of_fdt.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/acpi.h>
+#include <linux/ucs2_string.h>
 
 #include <asm/early_ioremap.h>
 
@@ -195,6 +198,85 @@ static void generic_ops_unregister(void)
 	efivars_unregister(&generic_efivars);
 }
 
+#if IS_ENABLED(CONFIG_ACPI)
+#define EFIVAR_SSDT_NAME_MAX	16
+static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX];
+static int __init efivar_ssdt_setup(char *str)
+{
+	if (strlen(str) < sizeof(efivar_ssdt))
+		memcpy(efivar_ssdt, str, strlen(str));
+	else
+		pr_warn("efivar_ssdt: name too long: %s\n", str);
+	return 0;
+}
+__setup("efivar_ssdt=", efivar_ssdt_setup);
+
+static __init int efivar_ssdt_iter(efi_char16_t *name, efi_guid_t vendor,
+				   unsigned long name_size, void *data)
+{
+	struct efivar_entry *entry = data;
+	char utf8_name[EFIVAR_SSDT_NAME_MAX];
+	int limit = min_t(unsigned long, EFIVAR_SSDT_NAME_MAX, name_size);
+	unsigned long size;
+	int err;
+
+	ucs2_as_utf8(utf8_name, name, limit - 1);
+	if (strncmp(utf8_name, efivar_ssdt, limit) != 0)
+		return 0;
+
+	pr_info("Loading SSDT from EFI variable %s\n", efivar_ssdt);
+
+	memcpy(entry->var.VariableName, name, name_size);
+	memcpy(&entry->var.VendorGuid, &vendor, sizeof(efi_guid_t));
+
+	err = efivar_entry_size(entry, &size);
+	if (err) {
+		pr_err("efivar_ssdt: failed to get var size\n");
+		return 0;
+	}
+
+	data = kmalloc(size, GFP_KERNEL);
+	if (!data)
+		return 0;
+
+	err = efivar_entry_get(entry, NULL, &size, data);
+	if (err) {
+		pr_err("efivar_ssdt: failed to get var data\n");
+		kfree(data);
+		return 0;
+	}
+
+	err = acpi_load_table(data);
+	if (err) {
+		pr_err("efivar_ssdt: failed to load table: %d\n", err);
+		kfree(data);
+	}
+
+	return 0;
+}
+
+static __init int efivar_ssdt_load(void)
+{
+	struct efivar_entry *entry;
+	/* We need a temporary empty list to be able to set duplicates
+	 * to true so that the efivar lock is dropped to allow us to
+	 * call efivar_entry_get from the iterator function.
+	 */
+	LIST_HEAD(tmp);
+	int ret;
+
+	/* efivar_entry is too big to allocate it on stack */
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+	ret = efivar_init(efivar_ssdt_iter, entry, true, &tmp);
+	kfree(entry);
+	return ret;
+}
+#else
+static inline int efivar_ssdt_load(void) { return 0; }
+#endif
+
 /*
  * We register the efi subsystem with the firmware subsystem and the
  * efivars subsystem with the efi subsystem, if the system was booted with
@@ -218,6 +300,9 @@ static int __init efisubsys_init(void)
 	if (error)
 		goto err_put;
 
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
+		efivar_ssdt_load();
+
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
 	if (error) {
 		pr_err("efi: Sysfs attribute export failed with error %d.\n",
-- 
2.7.4
