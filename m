From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] efi: Format EFI version prints the way the standard says.
Date: Fri,  2 Sep 2016 16:57:53 -0400
Message-ID: <1472849873-32041-3-git-send-email-pjones@redhat.com>
References: <20160902185758.GB9082@redhat.com>
 <1472849873-32041-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472849873-32041-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We print "EFI v2.xx.yy vendor blahblah" at several places.  Make them
conform to the standard format.

This leaves 2 checkpatch warnings in arch/ia64/kernel/efi.c intact; the
old code would have produced them, and they match the nearby code in the
functions.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/ia64/kernel/efi.c          | 15 +++++++--------
 arch/x86/platform/efi/efi.c     | 23 +++++++++++++++--------
 drivers/firmware/efi/arm-init.c | 14 +++++++-------
 drivers/firmware/efi/efi.c      | 18 +++++++++++++++---
 include/linux/efi.h             |  2 ++
 5 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 2af99a8..bf16028 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -473,7 +473,7 @@ efi_init (void)
 	void *efi_map_start, *efi_map_end;
 	efi_char16_t *c16;
 	u64 efi_desc_size;
-	char *cp, vendor[100] = "unknown";
+	char *cp, vendor[100] = "unknown", version[] = "65535.255.255";
 	int i;
 
 	set_bit(EFI_BOOT, &efi.flags);
@@ -516,11 +516,12 @@ efi_init (void)
 
 	efi.spec_version = efi.systab->hdr.version;
 
+	if (efi_spec_version_format(version) <= 0)
+		strcpy(version, "(unknown)");
+
 	if ((efi.systab->hdr.revision >> 16) == 0)
-		printk(KERN_WARNING "Warning: EFI system table version "
-		       "%d.%02d, expected 1.00 or greater\n",
-		       efi.systab->hdr.revision >> 16,
-		       efi.systab->hdr.revision & 0xffff);
+		printk(KERN_WARNING "Warning: EFI system table version %s, expected 1.00 or greater\n",
+		       version);
 
 	/* Show what we know for posterity */
 	c16 = __va(efi.systab->fw_vendor);
@@ -530,9 +531,7 @@ efi_init (void)
 		vendor[i] = '\0';
 	}
 
-	printk(KERN_INFO "EFI v%u.%.02u by %s:",
-	       efi.systab->hdr.revision >> 16,
-	       efi.systab->hdr.revision & 0xffff, vendor);
+	printk(KERN_INFO "EFI v%s by %s\n", version, vendor);
 
 	palo_phys      = EFI_INVALID_TABLE_ADDR;
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 51c091e..245e3e0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -328,10 +328,15 @@ static int __init efi_systab_init(void *phys)
 
 	efi.spec_version = efi.systab->hdr.revision;
 
-	if ((efi.systab->hdr.revision >> 16) == 0)
-		pr_err("Warning: System table version %d.%02d, expected 1.00 or greater!\n",
-		       efi.systab->hdr.revision >> 16,
-		       efi.systab->hdr.revision & 0xffff);
+	if ((efi.systab->hdr.revision >> 16) == 0) {
+		char version[] = "65535.255.255";
+
+		if (efi_spec_version_format(version) <= 0)
+			strcpy(version, "(unknown)");
+
+		pr_err("Warning: System table version %s, expected 1.00 or greater!\n",
+		       version);
+	}
 
 	return 0;
 }
@@ -447,7 +452,7 @@ static int __init efi_memmap_init(void)
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
-	char vendor[100] = "unknown";
+	char vendor[100] = "unknown", version[] = "65535.255.255";
 	int i = 0;
 	void *tmp;
 
@@ -474,6 +479,7 @@ void __init efi_init(void)
 	/*
 	 * Show what we know for posterity
 	 */
+
 	c16 = tmp = early_memremap(efi.systab->fw_vendor, 2);
 	if (c16) {
 		for (i = 0; i < sizeof(vendor) - 1 && *c16; ++i)
@@ -483,9 +489,10 @@ void __init efi_init(void)
 		pr_err("Could not map the firmware vendor!\n");
 	early_memunmap(tmp, 2);
 
-	pr_info("EFI v%u.%.02u by %s\n",
-		efi.systab->hdr.revision >> 16,
-		efi.systab->hdr.revision & 0xffff, vendor);
+	if (efi_spec_version_format(version) <= 0)
+		strcpy(version, "(unknown)");
+
+	pr_info("EFI v%s by %s\n", version, vendor);
 
 	if (efi_reuse_config(efi.systab->tables, efi.systab->nr_tables))
 		return;
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 8f4aeba..59dba34 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -90,7 +90,7 @@ static int __init uefi_init(void)
 	efi_char16_t *c16;
 	void *config_tables;
 	size_t table_size;
-	char vendor[100] = "unknown";
+	char vendor[100] = "unknown", version[] = "65535.255.255";
 	int i, retval;
 
 	efi.systab = early_memremap_ro(efi_system_table,
@@ -115,10 +115,12 @@ static int __init uefi_init(void)
 
 	efi.spec_version = efi.systab->hdr.revision;
 
+	if (efi_spec_version_format(version) <= 0)
+		strcpy(version, "(unknown)");
+
 	if ((efi.systab->hdr.revision >> 16) < 2)
-		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
-			efi.systab->hdr.revision >> 16,
-			efi.systab->hdr.revision & 0xffff);
+		pr_warn("Warning: EFI system table version %s, expected 1.00 or greater\n",
+			version);
 
 	/* Show what we know for posterity */
 	c16 = early_memremap_ro(efi_to_phys(efi.systab->fw_vendor),
@@ -130,9 +132,7 @@ static int __init uefi_init(void)
 		early_memunmap(c16, sizeof(vendor) * sizeof(efi_char16_t));
 	}
 
-	pr_info("EFI v%u.%.02u by %s\n",
-		efi.systab->hdr.revision >> 16,
-		efi.systab->hdr.revision & 0xffff, vendor);
+	pr_info("EFI v%s by %s\n", version, vendor);
 
 	table_size = sizeof(efi_config_table_64_t) * efi.systab->nr_tables;
 	config_tables = early_memremap_ro(efi_to_phys(efi.systab->tables),
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3ef3a2a..d78e3d6 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -141,9 +141,7 @@ static ssize_t fw_platform_size_show(struct kobject *kobj,
 	return sprintf(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
 }
 
-static ssize_t spec_version_show(struct kobject *kobj,
-				 struct kobj_attribute *attr,
-				 char *buf)
+ssize_t efi_spec_version_format(char *buf)
 {
 	/* The spec says:
 	 *  The revision of the EFI Specification to which this table
@@ -194,6 +192,20 @@ static ssize_t spec_version_show(struct kobject *kobj,
 		return sprintf(buf, "%u.%u.%u", major, minor / 10, minor % 10);
 }
 
+static ssize_t spec_version_show(struct kobject *kobj,
+				 struct kobj_attribute *attr,
+				 char *buf)
+{
+	char version[] = "65535.255.255";
+	ssize_t sz;
+
+	sz = efi_spec_version_format(version);
+	if (sz < 0)
+		return sprintf(buf, "(unknown");
+
+	return sprintf(buf, "%s\n", version);
+}
+
 static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
 static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
 static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c6a3126..d2d5c13 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -535,6 +535,8 @@ typedef efi_status_t efi_query_variable_store_t(u32 attributes,
 
 void efi_native_runtime_setup(void);
 
+ssize_t efi_spec_version_format(char *buf);
+
 /*
  * EFI Configuration Table and GUID definitions
  *
-- 
2.7.4
