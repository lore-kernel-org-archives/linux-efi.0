From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 04/11] efi: Add efi_memmap_init_late() for permanent EFI memmap
Date: Thu, 23 Jun 2016 12:34:43 +0100
Message-ID: <1466681690-5850-5-git-send-email-matt@codeblueprint.co.uk>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, Borislav Petkov <bp@alien8.de>, Mark Rutland <mark.rutland@arm.com>
List-Id: linux-efi@vger.kernel.org

Drivers need a way to access the EFI memory map at runtime. ARM and
arm64 currently provide this by remapping the EFI memory map into the
vmalloc space before setting up the EFI virtual mappings.

x86 does not provide this functionality which has resulted in the code
in efi_mem_desc_lookup() where it will manually map individual EFI
memmap entries if the memmap has already been torn down on x86,

  /*
   * If a driver calls this after efi_free_boot_services,
   * ->map will be NULL, and the target may also not be mapped.
   * So just always get our own virtual map on the CPU.
   *
   */
  md = early_memremap(p, sizeof (*md));

There isn't a good reason for not providing a permanent EFI memory map
for runtime queries, especially since the EFI regions are not mapped
into the standard kernel page tables.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi.c        |  46 +++++++++----
 arch/x86/platform/efi/quirks.c     |   2 -
 drivers/firmware/efi/arm-runtime.c |   4 +-
 drivers/firmware/efi/efi.c         | 135 ++++++++++++++++++++++++++-----------
 include/linux/efi.h                |   2 +
 5 files changed, 130 insertions(+), 59 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b434c887229c..33bc6c12702c 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -843,6 +843,19 @@ static void __init kexec_enter_virtual_mode(void)
 		get_systab_virt_addr(md);
 	}
 
+	/*
+	 * Unregister the early EFI memmap from efi_init() and install
+	 * the new EFI memory map.
+	 */
+	efi_memmap_unmap();
+
+	if (efi_memmap_init_late(efi.memmap.phys_map,
+				 efi.memmap.desc_size * efi.memmap.nr_map)) {
+		pr_err("Failed to remap late EFI memory map\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return;
+	}
+
 	save_runtime_map();
 
 	BUG_ON(!efi.systab);
@@ -904,6 +917,7 @@ static void __init __efi_enter_virtual_mode(void)
 	int count = 0, pg_shift = 0;
 	void *new_memmap = NULL;
 	efi_status_t status;
+	phys_addr_t pa;
 
 	efi.systab = NULL;
 
@@ -921,11 +935,26 @@ static void __init __efi_enter_virtual_mode(void)
 		return;
 	}
 
+	pa = __pa(new_memmap);
+
+	/*
+	 * Unregister the early EFI memmap from efi_init() and install
+	 * the new EFI memory map that we are about to pass to the
+	 * firmware via SetVirtualAddressMap().
+	 */
+	efi_memmap_unmap();
+
+	if (efi_memmap_init_late(pa, efi.memmap.desc_size * count)) {
+		pr_err("Failed to remap late EFI memory map\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+		return;
+	}
+
 	save_runtime_map();
 
 	BUG_ON(!efi.systab);
 
-	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift)) {
+	if (efi_setup_page_tables(pa, 1 << pg_shift)) {
 		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
 	}
@@ -937,14 +966,14 @@ static void __init __efi_enter_virtual_mode(void)
 				efi.memmap.desc_size * count,
 				efi.memmap.desc_size,
 				efi.memmap.desc_version,
-				(efi_memory_desc_t *)__pa(new_memmap));
+				(efi_memory_desc_t *)pa);
 	} else {
 		status = efi_thunk_set_virtual_address_map(
 				efi_phys.set_virtual_address_map,
 				efi.memmap.desc_size * count,
 				efi.memmap.desc_size,
 				efi.memmap.desc_version,
-				(efi_memory_desc_t *)__pa(new_memmap));
+				(efi_memory_desc_t *)pa);
 	}
 
 	if (status != EFI_SUCCESS) {
@@ -976,17 +1005,6 @@ static void __init __efi_enter_virtual_mode(void)
 	efi_runtime_update_mappings();
 	efi_dump_pagetable();
 
-	/*
-	 * We mapped the descriptor array into the EFI pagetable above
-	 * but we're not unmapping it here because if we're running in
-	 * EFI mixed mode we need all of memory to be accessible when
-	 * we pass parameters to the EFI runtime services in the
-	 * thunking code.
-	 *
-	 * efi_cleanup_page_tables(__pa(new_memmap), 1 << pg_shift);
-	 */
-	free_pages((unsigned long)new_memmap, pg_shift);
-
 	/* clean DUMMY object */
 	efi_delete_dummy_variable();
 }
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 0af180004e74..570c33683a26 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -265,8 +265,6 @@ void __init efi_free_boot_services(void)
 
 		free_bootmem_late(start, size);
 	}
-
-	efi_memmap_unmap();
 }
 
 /*
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 17ccf0a8787a..ce1424672d89 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -111,12 +111,10 @@ static int __init arm_enable_runtime_services(void)
 
 	mapsize = efi.memmap.map_end - efi.memmap.map;
 
-	efi.memmap.map = memremap(efi.memmap.phys_map, mapsize, MEMREMAP_WB);
-	if (!efi.memmap.map) {
+	if (efi_memmap_init_late(efi.memmap.phys_map, mapsize)) {
 		pr_err("Failed to remap EFI memory map\n");
 		return -ENOMEM;
 	}
-	efi.memmap.map_end = efi.memmap.map + mapsize;
 
 	if (!efi_virtmap_init()) {
 		pr_err("UEFI virtual mapping missing or invalid -- runtime services will not be available\n");
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3e6dce71f54d..50eda492d0bb 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -251,56 +251,31 @@ subsys_initcall(efisubsys_init);
 
 /*
  * Find the efi memory descriptor for a given physical address.  Given a
- * physicall address, determine if it exists within an EFI Memory Map entry,
+ * physical address, determine if it exists within an EFI Memory Map entry,
  * and if so, populate the supplied memory descriptor with the appropriate
  * data.
  */
 int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
 {
-	struct efi_memory_map *map = &efi.memmap;
-	phys_addr_t p, e;
+	efi_memory_desc_t *md;
 
 	if (!efi_enabled(EFI_MEMMAP)) {
 		pr_err_once("EFI_MEMMAP is not enabled.\n");
 		return -EINVAL;
 	}
 
-	if (!map) {
-		pr_err_once("efi.memmap is not set.\n");
-		return -EINVAL;
-	}
 	if (!out_md) {
 		pr_err_once("out_md is null.\n");
 		return -EINVAL;
         }
-	if (WARN_ON_ONCE(!map->phys_map))
-		return -EINVAL;
-	if (WARN_ON_ONCE(map->nr_map == 0) || WARN_ON_ONCE(map->desc_size == 0))
-		return -EINVAL;
 
-	e = map->phys_map + map->nr_map * map->desc_size;
-	for (p = map->phys_map; p < e; p += map->desc_size) {
-		efi_memory_desc_t *md;
+	for_each_efi_memory_desc(md) {
 		u64 size;
 		u64 end;
 
-		/*
-		 * If a driver calls this after efi_free_boot_services,
-		 * ->map will be NULL, and the target may also not be mapped.
-		 * So just always get our own virtual map on the CPU.
-		 *
-		 */
-		md = early_memremap(p, sizeof (*md));
-		if (!md) {
-			pr_err_once("early_memremap(%pa, %zu) failed.\n",
-				    &p, sizeof (*md));
-			return -ENOMEM;
-		}
-
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
 		    md->type != EFI_BOOT_SERVICES_DATA &&
 		    md->type != EFI_RUNTIME_SERVICES_DATA) {
-			early_memunmap(md, sizeof (*md));
 			continue;
 		}
 
@@ -308,11 +283,8 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
 		end = md->phys_addr + size;
 		if (phys_addr >= md->phys_addr && phys_addr < end) {
 			memcpy(out_md, md, sizeof(*out_md));
-			early_memunmap(md, sizeof (*md));
 			return 0;
 		}
-
-		early_memunmap(md, sizeof (*md));
 	}
 	pr_err_once("requested map not found.\n");
 	return -ENOENT;
@@ -449,32 +421,49 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 }
 
 /**
- * efi_memmap_init_early - Map the EFI memory map data structure
+ * __efi_memmap_init - Common code for mapping the EFI memory map
  * @data: EFI memory map data
+ * @late: Use early or late mapping function?
  *
- * Use early_memremap() to map the passed in EFI memory map and assign
- * it to efi.memmap.
+ * This function takes care of figuring out which function to use to
+ * map the EFI memory map in efi.memmap based on how far into the boot
+ * we are.
+ *
+ * During bootup @late should be %false since we only have access to
+ * the early_memremap*() functions as the vmalloc space isn't setup.
+ * Once the kernel is fully booted we can fallback to the more robust
+ * memremap*() API.
+ *
+ * Returns zero on success, a negative error code on failure.
  */
-int __init efi_memmap_init_early(struct efi_memory_map_data *data)
+static int __init
+__efi_memmap_init(struct efi_memory_map_data *data, bool late)
 {
 	struct efi_memory_map map;
+	phys_addr_t phys_map;
 
 	if (efi_enabled(EFI_PARAVIRT))
 		return 0;
 
-	map.phys_map = data->phys_map;
+	phys_map = data->phys_map;
+
+	if (late)
+		map.map = memremap(phys_map, data->size, MEMREMAP_WB);
+	else
+		map.map = early_memremap(phys_map, data->size);
 
-	map.map = early_memremap(data->phys_map, data->size);
 	if (!map.map) {
 		pr_err("Could not map the memory map!\n");
 		return -ENOMEM;
 	}
 
+	map.phys_map = data->phys_map;
 	map.nr_map = data->size / data->desc_size;
 	map.map_end = map.map + data->size;
 
 	map.desc_version = data->desc_version;
 	map.desc_size = data->desc_size;
+	map.late = late;
 
 	set_bit(EFI_MEMMAP, &efi.flags);
 
@@ -483,17 +472,83 @@ int __init efi_memmap_init_early(struct efi_memory_map_data *data)
 	return 0;
 }
 
+/**
+ * efi_memmap_init_early - Map the EFI memory map data structure
+ * @data: EFI memory map data
+ *
+ * Use early_memremap() to map the passed in EFI memory map and assign
+ * it to efi.memmap.
+ */
+int __init efi_memmap_init_early(struct efi_memory_map_data *data)
+{
+	/* Cannot go backwards */
+	WARN_ON(efi.memmap.late);
+
+	return __efi_memmap_init(data, false);
+}
+
 void __init efi_memmap_unmap(void)
 {
-	unsigned long size;
+	if (!efi.memmap.late) {
+		unsigned long size;
 
-	size = efi.memmap.desc_size * efi.memmap.nr_map;
+		size = efi.memmap.desc_size * efi.memmap.nr_map;
+		early_memunmap(efi.memmap.map, size);
+	} else {
+		memunmap(efi.memmap.map);
+	}
 
-	early_memunmap(efi.memmap.map, size);
 	efi.memmap.map = NULL;
 	clear_bit(EFI_MEMMAP, &efi.flags);
 }
 
+/**
+ * efi_memmap_init_late - Map efi.memmap with memremap()
+ * @phys_addr: Physical address of the new EFI memory map
+ * @size: Size in bytes of the new EFI memory map
+ *
+ * Setup a mapping of the EFI memory map using ioremap_cache(). This
+ * function should only be called once the vmalloc space has been
+ * setup and is therefore not suitable for calling during early EFI
+ * initialise, e.g. in efi_init(). Additionally, it expects
+ * efi_memmap_init_early() to have already been called.
+ *
+ * The reason there are two EFI memmap initialisation
+ * (efi_memmap_init_early() and this late version) is because the
+ * early EFI memmap should be explicitly unmapped once EFI
+ * initialisation is complete as the fixmap space used to map the EFI
+ * memmap (via early_memremap()) is a scarce resource.
+ *
+ * This late mapping is intended to persist for the duration of
+ * runtime so that things like efi_mem_desc_lookup() and
+ * efi_mem_attributes() always work.
+ *
+ * Returns zero on success, a negative error code on failure.
+ */
+int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size)
+{
+	struct efi_memory_map_data data = {
+		.phys_map = addr,
+		.size = size,
+	};
+
+	/* Did we forget to unmap the early EFI memmap? */
+	WARN_ON(efi.memmap.map);
+
+	/* Were we already called? */
+	WARN_ON(efi.memmap.late);
+
+	/*
+	 * It makes no sense to allow callers to register different
+	 * values for the following fields. Copy them out of the
+	 * existing early EFI memmap.
+	 */
+	data.desc_version = efi.memmap.desc_version;
+	data.desc_size = efi.memmap.desc_size;
+
+	return __efi_memmap_init(&data, true);
+}
+
 #ifdef CONFIG_EFI_VARS_MODULE
 static int __init efi_load_efivars(void)
 {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 055fbecd3156..deb9d1c79bbf 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -761,6 +761,7 @@ struct efi_memory_map {
 	int nr_map;
 	unsigned long desc_version;
 	unsigned long desc_size;
+	bool late;
 };
 
 struct efi_fdt_params {
@@ -987,6 +988,7 @@ static inline efi_status_t efi_query_variable_store(u32 attributes,
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 
 extern int __init efi_memmap_init_early(struct efi_memory_map_data *data);
+extern int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size);
 extern void __init efi_memmap_unmap(void);
 
 extern int efi_config_init(efi_config_table_type_t *arch_tables);
-- 
2.7.3
