From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 08/10] arm64/efi: use LE accessors to access UEFI data
Date: Mon, 21 Jul 2014 17:16:23 +0200
Message-ID: <1405955785-13477-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405955785-13477-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

If we are running a BE kernel, we need to byte reverse all data that UEFI keeps,
as UEFI is strictly little endian.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c        | 53 +++++++++++++++++++++++-------------------
 drivers/firmware/efi/efi.c     | 26 ++++++++++++---------
 drivers/firmware/efi/efivars.c |  2 +-
 3 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e72f3100958f..96df58824189 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -42,7 +42,7 @@ early_param("uefi_debug", uefi_debug_setup);
 
 static int __init is_normal_ram(efi_memory_desc_t *md)
 {
-	if (md->attribute & EFI_MEMORY_WB)
+	if (le64_to_cpu(md->attribute) & EFI_MEMORY_WB)
 		return 1;
 	return 0;
 }
@@ -58,10 +58,11 @@ static void __init efi_setup_idmap(void)
 
 	/* map runtime io spaces */
 	for_each_efi_memory_desc(&memmap, md) {
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) || is_normal_ram(md))
+		if (!(le64_to_cpu(md->attribute) & EFI_MEMORY_RUNTIME) ||
+		    is_normal_ram(md))
 			continue;
-		paddr = md->phys_addr;
-		npages = md->num_pages;
+		paddr = le64_to_cpu(md->phys_addr);
+		npages = le64_to_cpu(md->num_pages);
 		memrange_efi_to_native(&paddr, &npages);
 		size = npages << PAGE_SHIFT;
 		create_id_mapping(paddr, size, 1);
@@ -87,27 +88,27 @@ static int __init uefi_init(void)
 	/*
 	 * Verify the EFI Table
 	 */
-	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
+	if (le64_to_cpu(efi.systab->hdr.signature) != EFI_SYSTEM_TABLE_SIGNATURE) {
 		pr_err("System table signature incorrect\n");
 		return -EINVAL;
 	}
-	if ((efi.systab->hdr.revision >> 16) < 2)
+	if ((le32_to_cpu(efi.systab->hdr.revision) >> 16) < 2)
 		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
 			efi.systab->hdr.revision >> 16,
 			efi.systab->hdr.revision & 0xffff);
 
 	/* Show what we know for posterity */
-	c16 = early_memremap(efi.systab->fw_vendor,
+	c16 = early_memremap(le64_to_cpu(efi.systab->fw_vendor),
 			     sizeof(vendor));
 	if (c16) {
 		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] = c16[i];
+			vendor[i] = le16_to_cpu(c16[i]);
 		vendor[i] = '\0';
 	}
 
 	pr_info("EFI v%u.%.02u by %s\n",
-		efi.systab->hdr.revision >> 16,
-		efi.systab->hdr.revision & 0xffff, vendor);
+		le32_to_cpu(efi.systab->hdr.revision) >> 16,
+		le32_to_cpu(efi.systab->hdr.revision) & 0xffff, vendor);
 
 	retval = efi_config_init(NULL);
 	if (retval == 0)
@@ -144,11 +145,11 @@ static __init int is_reserve_region(efi_memory_desc_t *md)
 	if (!is_normal_ram(md))
 		return 0;
 
-	if (md->attribute & EFI_MEMORY_RUNTIME)
+	if (le64_to_cpu(md->attribute) & EFI_MEMORY_RUNTIME)
 		return 1;
 
-	if (md->type == EFI_ACPI_RECLAIM_MEMORY ||
-	    md->type == EFI_RESERVED_TYPE)
+	if (le32_to_cpu(md->type) == EFI_ACPI_RECLAIM_MEMORY ||
+	    le32_to_cpu(md->type) == EFI_RESERVED_TYPE)
 		return 1;
 
 	return 0;
@@ -163,13 +164,15 @@ static __init void reserve_regions(void)
 		pr_info("Processing EFI memory map:\n");
 
 	for_each_efi_memory_desc(&memmap, md) {
-		paddr = md->phys_addr;
-		npages = md->num_pages;
+		u32 md_type = le32_to_cpu(md->type);
+
+		paddr = le64_to_cpu(md->phys_addr);
+		npages = le64_to_cpu(md->num_pages);
 
 		if (uefi_debug)
 			pr_info("  0x%012llx-0x%012llx [%s]",
 				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
-				memory_type_name[md->type]);
+				memory_type_name[md_type]);
 
 		memrange_efi_to_native(&paddr, &npages);
 		size = npages << PAGE_SHIFT;
@@ -178,8 +181,8 @@ static __init void reserve_regions(void)
 			early_init_dt_add_memory_arch(paddr, size);
 
 		if (is_reserve_region(md) ||
-		    md->type == EFI_BOOT_SERVICES_CODE ||
-		    md->type == EFI_BOOT_SERVICES_DATA) {
+		    md_type == EFI_BOOT_SERVICES_CODE ||
+		    md_type == EFI_BOOT_SERVICES_DATA) {
 			memblock_reserve(paddr, size);
 			if (uefi_debug)
 				pr_cont("*");
@@ -258,17 +261,18 @@ static void __init free_boot_services(void)
 			 */
 			if (free_start) {
 				/* adjust free_end then free region */
-				if (free_end > md->phys_addr)
+				if (free_end > le64_to_cpu(md->phys_addr))
 					free_end -= PAGE_SIZE;
 				total_freed += free_region(free_start, free_end);
 				free_start = 0;
 			}
-			keep_end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+			keep_end = le64_to_cpu(md->phys_addr) +
+				   (le64_to_cpu(md->num_pages) << EFI_PAGE_SHIFT);
 			continue;
 		}
 
-		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA) {
+		if (le32_to_cpu(md->type) != EFI_BOOT_SERVICES_CODE &&
+		    le32_to_cpu(md->type) != EFI_BOOT_SERVICES_DATA) {
 			/* no need to free this region */
 			continue;
 		}
@@ -276,8 +280,8 @@ static void __init free_boot_services(void)
 		/*
 		 * We want to free memory from this region.
 		 */
-		paddr = md->phys_addr;
-		npages = md->num_pages;
+		paddr = le64_to_cpu(md->phys_addr);
+		npages = le64_to_cpu(md->num_pages);
 		memrange_efi_to_native(&paddr, &npages);
 		size = npages << PAGE_SHIFT;
 
@@ -475,3 +479,4 @@ err_unmap:
 	return -1;
 }
 early_initcall(arm64_enter_virtual_mode);
+
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 64ecbb501c50..24cb61b72d06 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -270,18 +270,23 @@ static __init int match_config_table(efi_guid_t *guid,
 int __init efi_config_init(efi_config_table_type_t *arch_tables)
 {
 	void *config_tables, *tablep;
-	int i, sz;
+	unsigned long __tables;
+	int i, sz, nr_tables;
 
-	if (efi_enabled(EFI_64BIT))
+	if (efi_enabled(EFI_64BIT)) {
 		sz = sizeof(efi_config_table_64_t);
-	else
+		nr_tables = le64_to_cpu((__force __le64)efi.systab->nr_tables);
+		__tables = le64_to_cpu((__force __le64)efi.systab->tables);
+	} else {
 		sz = sizeof(efi_config_table_32_t);
+		nr_tables = le32_to_cpu((__force __le32)efi.systab->nr_tables);
+		__tables = le32_to_cpu((__force __le32)efi.systab->tables);
+	}
 
 	/*
 	 * Let's see what config tables the firmware passed to us.
 	 */
-	config_tables = early_memremap(efi.systab->tables,
-				       efi.systab->nr_tables * sz);
+	config_tables = early_memremap(__tables, nr_tables * sz);
 	if (config_tables == NULL) {
 		pr_err("Could not map Configuration table!\n");
 		return -ENOMEM;
@@ -289,21 +294,20 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 
 	tablep = config_tables;
 	pr_info("");
-	for (i = 0; i < efi.systab->nr_tables; i++) {
+	for (i = 0; i < nr_tables; i++) {
 		efi_guid_t guid;
 		unsigned long table;
 
 		if (efi_enabled(EFI_64BIT)) {
 			u64 table64;
 			guid = ((efi_config_table_64_t *)tablep)->guid;
-			table64 = ((efi_config_table_64_t *)tablep)->table;
-			table = table64;
+			table = table64 = le64_to_cpu((__force __le64)
+				((efi_config_table_64_t *)tablep)->table);
 #ifndef CONFIG_64BIT
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_memunmap(config_tables,
-					       efi.systab->nr_tables * sz);
+				early_memunmap(config_tables, nr_tables * sz);
 				return -EINVAL;
 			}
 #endif
@@ -318,7 +322,7 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 		tablep += sz;
 	}
 	pr_cont("\n");
-	early_memunmap(config_tables, efi.systab->nr_tables * sz);
+	early_memunmap(config_tables, nr_tables * sz);
 
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
 
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index f256ecd8a176..e33181a779ab 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -563,7 +563,7 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 	/* Convert Unicode to normal chars (assume top bits are 0),
 	   ala UTF-8 */
 	for (i=0; i < (int)(variable_name_size / sizeof(efi_char16_t)); i++) {
-		short_name[i] = variable_name[i] & 0xFF;
+		short_name[i] = le16_to_cpu((__force __le16)variable_name[i]);
 	}
 	/* This is ugly, but necessary to separate one vendor's
 	   private variables from another's.         */
-- 
1.8.3.2
