From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [patch 5/9 v3] efi: export more efi table variable to sysfs
Date: Thu, 21 Nov 2013 14:17:09 +0800
Message-ID: <20131121061754.887381332@dhcp-16-126.nay.redhat.com>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline; filename=05-export-more-efi-sysfs-vars.patch
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Export fw_vendor, runtime and config tables physical
addresses to /sys/firmware/efi/systab becaue kexec
kernel will need them.

>From EFI spec these 3 variables will be updated to
virtual address after entering virtual mode. But
kernel startup code will need the physical address.

changelog:
Greg: add standalone sysfs files instead of add lines to systab
Document them as testing ABI

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-firmware-efi |   26 +++++++++
 arch/x86/platform/efi/efi.c                  |    4 +
 drivers/firmware/efi/efi.c                   |   71 +++++++++++++++++++++++++--
 include/linux/efi.h                          |    3 +
 4 files changed, 101 insertions(+), 3 deletions(-)

--- efi.orig/drivers/firmware/efi/efi.c
+++ efi/drivers/firmware/efi/efi.c
@@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
 	.hcdp       = EFI_INVALID_TABLE_ADDR,
 	.uga        = EFI_INVALID_TABLE_ADDR,
 	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
+	.runtime    = EFI_INVALID_TABLE_ADDR,
+	.config_table  = EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -71,6 +74,31 @@ static ssize_t systab_show(struct kobjec
 static struct kobj_attribute efi_attr_systab =
 			__ATTR(systab, 0400, systab_show, NULL);
 
+static ssize_t fw_vendor_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", efi.fw_vendor);
+}
+
+static ssize_t runtime_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", efi.runtime);
+}
+
+static ssize_t config_table_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%lx\n", efi.config_table);
+}
+
+static struct kobj_attribute efi_attr_fw_vendor =
+				__ATTR(fw_vendor, 0400, fw_vendor_show, NULL);
+static struct kobj_attribute efi_attr_runtime =
+			__ATTR(runtime, 0400, runtime_show, NULL);
+static struct kobj_attribute efi_attr_config_table =
+			__ATTR(config_table, 0400, config_table_show, NULL);
+
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
 	NULL,	/* maybe more in the future? */
@@ -123,21 +151,58 @@ static int __init efisubsys_init(void)
 
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
 	if (error) {
-		pr_err("efi: Sysfs attribute export failed with error %d.\n",
-		       error);
+		pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
+		       efi_attr_systab.attr.name, error);
 		goto err_unregister;
 	}
 
+	if (efi.fw_vendor != EFI_INVALID_TABLE_ADDR) {
+		error = sysfs_create_file(efi_kobj, &efi_attr_fw_vendor.attr);
+		if (error) {
+			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
+				efi_attr_fw_vendor.attr.name, error);
+			goto err_remove_group;
+		}
+	}
+
+	if (efi.runtime != EFI_INVALID_TABLE_ADDR) {
+		error = sysfs_create_file(efi_kobj, &efi_attr_runtime.attr);
+		if (error) {
+			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
+				efi_attr_runtime.attr.name, error);
+			goto err_remove_fw_vendor;
+		}
+	}
+
+	if (efi.config_table != EFI_INVALID_TABLE_ADDR) {
+		error = sysfs_create_file(efi_kobj,
+					&efi_attr_config_table.attr);
+		if (error) {
+			pr_err("efi: Sysfs attribute %s export failed with error %d.\n",
+				efi_attr_config_table.attr.name, error);
+			goto err_remove_runtime;
+		}
+	}
+
 	/* and the standard mountpoint for efivarfs */
 	efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
 	if (!efivars_kobj) {
 		pr_err("efivars: Subsystem registration failed.\n");
 		error = -ENOMEM;
-		goto err_remove_group;
+		goto err_remove_config_table;
 	}
 
 	return 0;
 
+err_remove_config_table:
+	if (efi.config_table != EFI_INVALID_TABLE_ADDR)
+		sysfs_remove_file(efi_kobj, &efi_attr_config_table.attr);
+err_remove_runtime:
+	if (efi.runtime != EFI_INVALID_TABLE_ADDR)
+		sysfs_remove_file(efi_kobj, &efi_attr_runtime.attr);
+err_remove_fw_vendor:
+	if (efi.fw_vendor != EFI_INVALID_TABLE_ADDR)
+		sysfs_remove_file(efi_kobj, &efi_attr_fw_vendor.attr);
 err_remove_group:
 	sysfs_remove_group(efi_kobj, &efi_subsys_attr_group);
 err_unregister:
--- efi.orig/include/linux/efi.h
+++ efi/include/linux/efi.h
@@ -556,6 +556,9 @@ extern struct efi {
 	unsigned long hcdp;		/* HCDP table */
 	unsigned long uga;		/* UGA table */
 	unsigned long uv_systab;	/* UV system table */
+	unsigned long fw_vendor;	/* fw_vendor */
+	unsigned long runtime;		/* runtime table */
+	unsigned long config_table;	/* config tables */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
--- efi.orig/arch/x86/platform/efi/efi.c
+++ efi/arch/x86/platform/efi/efi.c
@@ -653,6 +653,10 @@ void __init efi_init(void)
 
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
+	efi.fw_vendor = (unsigned long)efi.systab->fw_vendor;
+	efi.runtime = (unsigned long)efi.systab->runtime;
+	efi.config_table = (unsigned long)efi.systab->tables;
+
 	/*
 	 * Show what we know for posterity
 	 */
--- /dev/null
+++ efi/Documentation/ABI/testing/sysfs-firmware-efi
@@ -0,0 +1,26 @@
+What:		/sys/firmware/efi/fw_vendor
+Date:		Nov 2013
+Contact:	Dave Young <dyoung-8RVElS0ezzQdnm+yROfE0A@public.gmane.org>
+Description:
+		Shows the physical address of firmware vendor in the EFI
+		system table.
+Users:
+		Kexec Mailing List <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
+
+What:		/sys/firmware/efi/runtime
+Date:		Nov 2013
+Contact:	Dave Young <dyoung-8RVElS0ezzQdnm+yROfE0A@public.gmane.org>
+Description:
+		Shows the physical address of runtime service table in the
+		EFI system table.
+Users:
+		Kexec Mailing List <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
+
+What:		/sys/firmware/efi/config_table
+Date:		Nov 2013
+Contact:	Dave Young <dyoung-8RVElS0ezzQdnm+yROfE0A@public.gmane.org>
+Description:
+		Shows the physical address of config table in the EFI
+		system table.
+Users:
+		Kexec Mailing List <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
