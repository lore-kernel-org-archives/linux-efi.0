From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: efi: export more efi table variable to sysfs
Date: Mon, 25 Nov 2013 16:47:04 +0800
Message-ID: <20131125084808.001612497@dhcp-16-126.nay.redhat.com>
References: <20131125084659.182036023@dhcp-16-126.nay.redhat.com>
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
Greg: use group attrs and is_visible
Boris: align comments lines

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/ABI/testing/sysfs-firmware-efi |   26 +++++++++++++++
 arch/x86/platform/efi/efi.c                  |    4 ++
 drivers/firmware/efi/efi.c                   |   44 +++++++++++++++++++++++++++
 include/linux/efi.h                          |    3 +
 4 files changed, 77 insertions(+)

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
 
@@ -71,13 +74,54 @@ static ssize_t systab_show(struct kobjec
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
+static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
+static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
+static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
+
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
+	&efi_attr_fw_vendor.attr,
+	&efi_attr_runtime.attr,
+	&efi_attr_config_table.attr,
 	NULL,	/* maybe more in the future? */
 };
 
+static umode_t efi_attr_is_visible(struct kobject *kobj,
+					struct attribute *attr, int n)
+{
+	umode_t mode = attr->mode;
+
+	if (attr == &efi_attr_fw_vendor.attr)
+		return (efi.fw_vendor == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	else if (attr == &efi_attr_runtime.attr)
+		return (efi.runtime == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	else if (attr == &efi_attr_config_table.attr)
+		return (efi.config_table == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+
+	return mode;
+}
+
 static struct attribute_group efi_subsys_attr_group = {
 	.attrs = efi_subsys_attrs,
+	.is_visible = efi_attr_is_visible,
 };
 
 static struct efivars generic_efivars;
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
 
+	efi.config_table = (unsigned long)efi.systab->tables;
+	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
+	efi.runtime	 = (unsigned long)efi.systab->runtime;
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
