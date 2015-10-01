From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/9] arm64/efi: split off EFI init and runtime code for reuse by 32-bit ARM
Date: Thu,  1 Oct 2015 19:04:15 +0200
Message-ID: <1443719063-6832-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443719063-6832-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This splits off the early EFI init and runtime code that
- discovers the EFI params and the memory map from the FDT, and installs
  the memblocks and config tables.
- prepares and installs the EFI page tables so that UEFI Runtime Services
  can be invoked at the virtual address installed by the stub.

This will allow it to be reused for 32-bit ARM.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c            | 363 +-------------------
 drivers/firmware/efi/Makefile      |   4 +-
 drivers/firmware/efi/arm-init.c    | 214 ++++++++++++
 drivers/firmware/efi/arm-runtime.c | 191 ++++++++++
 4 files changed, 409 insertions(+), 363 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index caca71590984..bd3b2f5adf0c 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -11,348 +11,11 @@
  *
  */
 
-#include <linux/atomic.h>
 #include <linux/dmi.h>
 #include <linux/efi.h>
-#include <linux/export.h>
-#include <linux/memblock.h>
-#include <linux/mm_types.h>
-#include <linux/bootmem.h>
-#include <linux/of.h>
-#include <linux/of_fdt.h>
-#include <linux/preempt.h>
-#include <linux/rbtree.h>
-#include <linux/rwsem.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
+#include <linux/init.h>
 
-#include <asm/cacheflush.h>
 #include <asm/efi.h>
-#include <asm/tlbflush.h>
-#include <asm/mmu_context.h>
-#include <asm/mmu.h>
-#include <asm/pgtable.h>
-
-struct efi_memory_map memmap;
-
-static u64 efi_system_table;
-
-static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
-
-static struct mm_struct efi_mm = {
-	.mm_rb			= RB_ROOT,
-	.pgd			= efi_pgd,
-	.mm_users		= ATOMIC_INIT(2),
-	.mm_count		= ATOMIC_INIT(1),
-	.mmap_sem		= __RWSEM_INITIALIZER(efi_mm.mmap_sem),
-	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
-	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
-	INIT_MM_CONTEXT(efi_mm)
-};
-
-static int __init is_normal_ram(efi_memory_desc_t *md)
-{
-	if (md->attribute & EFI_MEMORY_WB)
-		return 1;
-	return 0;
-}
-
-/*
- * Translate a EFI virtual address into a physical address: this is necessary,
- * as some data members of the EFI system table are virtually remapped after
- * SetVirtualAddressMap() has been called.
- */
-static phys_addr_t efi_to_phys(unsigned long addr)
-{
-	efi_memory_desc_t *md;
-
-	for_each_efi_memory_desc(&memmap, md) {
-		if (!(md->attribute & EFI_MEMORY_RUNTIME))
-			continue;
-		if (md->virt_addr == 0)
-			/* no virtual mapping has been installed by the stub */
-			break;
-		if (md->virt_addr <= addr &&
-		    (addr - md->virt_addr) < (md->num_pages << EFI_PAGE_SHIFT))
-			return md->phys_addr + addr - md->virt_addr;
-	}
-	return addr;
-}
-
-static int __init uefi_init(void)
-{
-	efi_char16_t *c16;
-	void *config_tables;
-	u64 table_size;
-	char vendor[100] = "unknown";
-	int i, retval;
-
-	efi.systab = early_memremap(efi_system_table,
-				    sizeof(efi_system_table_t));
-	if (efi.systab == NULL) {
-		pr_warn("Unable to map EFI system table.\n");
-		return -ENOMEM;
-	}
-
-	set_bit(EFI_BOOT, &efi.flags);
-	set_bit(EFI_64BIT, &efi.flags);
-
-	/*
-	 * Verify the EFI Table
-	 */
-	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
-		pr_err("System table signature incorrect\n");
-		retval = -EINVAL;
-		goto out;
-	}
-	if ((efi.systab->hdr.revision >> 16) < 2)
-		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
-			efi.systab->hdr.revision >> 16,
-			efi.systab->hdr.revision & 0xffff);
-
-	/* Show what we know for posterity */
-	c16 = early_memremap(efi_to_phys(efi.systab->fw_vendor),
-			     sizeof(vendor) * sizeof(efi_char16_t));
-	if (c16) {
-		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
-			vendor[i] = c16[i];
-		vendor[i] = '\0';
-		early_memunmap(c16, sizeof(vendor) * sizeof(efi_char16_t));
-	}
-
-	pr_info("EFI v%u.%.02u by %s\n",
-		efi.systab->hdr.revision >> 16,
-		efi.systab->hdr.revision & 0xffff, vendor);
-
-	table_size = sizeof(efi_config_table_64_t) * efi.systab->nr_tables;
-	config_tables = early_memremap(efi_to_phys(efi.systab->tables),
-				       table_size);
-
-	retval = efi_config_parse_tables(config_tables, efi.systab->nr_tables,
-					 sizeof(efi_config_table_64_t), NULL);
-
-	early_memunmap(config_tables, table_size);
-out:
-	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
-	return retval;
-}
-
-/*
- * Return true for RAM regions we want to permanently reserve.
- */
-static __init int is_reserve_region(efi_memory_desc_t *md)
-{
-	switch (md->type) {
-	case EFI_LOADER_CODE:
-	case EFI_LOADER_DATA:
-	case EFI_BOOT_SERVICES_CODE:
-	case EFI_BOOT_SERVICES_DATA:
-	case EFI_CONVENTIONAL_MEMORY:
-	case EFI_PERSISTENT_MEMORY:
-		return 0;
-	default:
-		break;
-	}
-	return is_normal_ram(md);
-}
-
-static __init void reserve_regions(void)
-{
-	efi_memory_desc_t *md;
-	u64 paddr, npages, size;
-
-	if (efi_enabled(EFI_DBG))
-		pr_info("Processing EFI memory map:\n");
-
-	for_each_efi_memory_desc(&memmap, md) {
-		paddr = md->phys_addr;
-		npages = md->num_pages;
-
-		if (efi_enabled(EFI_DBG)) {
-			char buf[64];
-
-			pr_info("  0x%012llx-0x%012llx %s",
-				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
-				efi_md_typeattr_format(buf, sizeof(buf), md));
-		}
-
-		memrange_efi_to_native(&paddr, &npages);
-		size = npages << PAGE_SHIFT;
-
-		if (is_normal_ram(md))
-			early_init_dt_add_memory(paddr, size);
-
-		if (is_reserve_region(md)) {
-			memblock_mark_nomap(paddr, size);
-			if (efi_enabled(EFI_DBG))
-				pr_cont("*");
-		}
-
-		if (efi_enabled(EFI_DBG))
-			pr_cont("\n");
-	}
-}
-
-void __init efi_parse_fdt(void *fdt)
-{
-	struct efi_fdt_params params;
-
-	/* Grab UEFI information placed in FDT by stub */
-	if (!efi_get_fdt_params(fdt, &params))
-		return;
-
-	efi_system_table = params.system_table;
-
-	memmap.phys_map = (void *)params.mmap;
-	memmap.desc_size = params.desc_size;
-	memmap.desc_version = params.desc_ver;
-	memmap.nr_map = params.mmap_size / params.desc_size;
-
-	set_bit(EFI_MEMMAP, &efi.flags);
-}
-
-void __init efi_init(void)
-{
-	int mmap_size = memmap.nr_map * memmap.desc_size;
-
-	if (!efi_enabled(EFI_MEMMAP))
-		return;
-
-	memmap.map = early_memremap((u64)memmap.phys_map, mmap_size);
-	memmap.map_end = memmap.map + mmap_size;
-
-	if (uefi_init() < 0)
-		return;
-
-	reserve_regions();
-	early_memunmap(memmap.map, mmap_size);
-	memblock_mark_nomap((unsigned long)memmap.phys_map & PAGE_MASK,
-			    PAGE_ALIGN(mmap_size));
-}
-
-static bool __init efi_virtmap_init(void)
-{
-	efi_memory_desc_t *md;
-
-	for_each_efi_memory_desc(&memmap, md) {
-		u64 paddr, npages, size;
-		pteval_t prot_val;
-
-		if (!(md->attribute & EFI_MEMORY_RUNTIME))
-			continue;
-		if (md->virt_addr == 0)
-			return false;
-
-		paddr = md->phys_addr;
-		npages = md->num_pages;
-		memrange_efi_to_native(&paddr, &npages);
-		size = npages << PAGE_SHIFT;
-
-		/*
-		 * Order is important here: memory regions may have all of the
-		 * bits below set (and usually do), and any memory that has the
-		 * EFI_MEMORY_WB bit set may be covered by the linear mapping
-		 * and mapped write-back cacheable already. So check the
-		 * EFI_MEMORY_WB bit first.
-		 */
-		if (md->attribute & EFI_MEMORY_WB) {
-			prot_val = pgprot_val(PAGE_KERNEL_EXEC);
-		} else if (md->attribute & EFI_MEMORY_WT) {
-			prot_val = PROT_NORMAL_WT;
-		} else if (md->attribute & EFI_MEMORY_WC) {
-			prot_val = PROT_NORMAL_NC;
-		} else if (md->attribute & EFI_MEMORY_UC) {
-			prot_val = PROT_DEVICE_nGnRnE;
-		} else {
-			pr_warn("  EFI remap 0x%012llx: not remapping due to unsupported memory attributes (0x%llx)\n",
-				md->phys_addr, md->attribute);
-			continue;
-		}
-
-		/*
-		 * Since the UEFI spec requires only the type attributes to be
-		 * identical within the same 64 KB page frame, we may encounter
-		 * regions that are not 64 KB aligned, but whose attributes only
-		 * differ from adjacent regions in the permission bits.
-		 * This means we can only enforce any permission restrictions if
-		 * the boundaries of this region are aligned to the OS page
-		 * size.
-		 */
-		if (PAGE_SIZE == EFI_PAGE_SIZE ||
-		    (PAGE_ALIGNED(md->virt_addr) &&
-		     PAGE_ALIGNED(md->virt_addr + md->num_pages * EFI_PAGE_SIZE))) {
-
-			if (md->attribute & EFI_MEMORY_RO)
-				prot_val |= PTE_RDONLY;
-			if (md->attribute & EFI_MEMORY_XP)
-				prot_val |= PTE_PXN;
-		}
-
-		pr_info("  EFI remap 0x%012llx => %p (R%c%c)\n",
-			md->phys_addr, (void *)md->virt_addr,
-			prot_val & PTE_RDONLY ? '-' : 'W',
-			prot_val & PTE_PXN ? '-' : 'X');
-
-		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size,
-				   __pgprot(prot_val));
-	}
-	return true;
-}
-
-/*
- * Enable the UEFI Runtime Services if all prerequisites are in place, i.e.,
- * non-early mapping of the UEFI system table and virtual mappings for all
- * EFI_MEMORY_RUNTIME regions.
- */
-static int __init arm64_enable_runtime_services(void)
-{
-	u64 mapsize;
-
-	if (!efi_enabled(EFI_BOOT)) {
-		pr_info("EFI services will not be available.\n");
-		return -1;
-	}
-
-	if (efi_runtime_disabled()) {
-		pr_info("EFI runtime services will be disabled.\n");
-		return -1;
-	}
-
-	pr_info("Remapping and enabling EFI services.\n");
-
-	mapsize = memmap.map_end - memmap.map;
-	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
-						   mapsize);
-	if (!memmap.map) {
-		pr_err("Failed to remap EFI memory map\n");
-		return -1;
-	}
-	memmap.map_end = memmap.map + mapsize;
-	efi.memmap = &memmap;
-
-	efi.systab = (__force void *)ioremap_cache(efi_system_table,
-						   sizeof(efi_system_table_t));
-	if (!efi.systab) {
-		pr_err("Failed to remap EFI System Table\n");
-		return -1;
-	}
-	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
-
-	if (!efi_virtmap_init()) {
-		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
-		return -1;
-	}
-
-	/* Set up runtime services function pointers */
-	efi_native_runtime_setup();
-	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
-
-	efi.runtime_version = efi.systab->hdr.revision;
-
-	return 0;
-}
-early_initcall(arm64_enable_runtime_services);
 
 static int __init arm64_dmi_init(void)
 {
@@ -368,30 +31,6 @@ static int __init arm64_dmi_init(void)
 }
 core_initcall(arm64_dmi_init);
 
-static void efi_set_pgd(struct mm_struct *mm)
-{
-	if (mm == &init_mm)
-		cpu_set_reserved_ttbr0();
-	else
-		cpu_switch_mm(mm->pgd, mm);
-
-	flush_tlb_all();
-	if (icache_is_aivivt())
-		__flush_icache_all();
-}
-
-void efi_virtmap_load(void)
-{
-	preempt_disable();
-	efi_set_pgd(&efi_mm);
-}
-
-void efi_virtmap_unload(void)
-{
-	efi_set_pgd(current->active_mm);
-	preempt_enable();
-}
-
 /*
  * UpdateCapsule() depends on the system being shutdown via
  * ResetSystem().
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index d9140208fc1c..62b272375422 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,7 +1,9 @@
 #
 # Makefile for linux kernel
 #
-obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
+arm-obj-$(CONFIG_ARM64)$(CONFIG_ARM)	:= arm-init.o arm-runtime.o
+
+obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o $(arm-obj-y)
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_ESRT)			+= esrt.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
new file mode 100644
index 000000000000..56987a5b9033
--- /dev/null
+++ b/drivers/firmware/efi/arm-init.c
@@ -0,0 +1,214 @@
+/*
+ * Extensible Firmware Interface
+ *
+ * Based on Extensible Firmware Interface Specification version 2.4
+ *
+ * Copyright (C) 2013 - 2015 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/memblock.h>
+#include <linux/mm_types.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+
+#include <asm/efi.h>
+
+struct efi_memory_map memmap;
+
+u64 efi_system_table;
+
+static int uefi_debug __initdata;
+static int __init uefi_debug_setup(char *str)
+{
+	uefi_debug = 1;
+
+	return 0;
+}
+early_param("uefi_debug", uefi_debug_setup);
+
+static int __init is_normal_ram(efi_memory_desc_t *md)
+{
+	if (md->attribute & EFI_MEMORY_WB)
+		return 1;
+	return 0;
+}
+
+/*
+ * Translate a EFI virtual address into a physical address: this is necessary,
+ * as some data members of the EFI system table are virtually remapped after
+ * SetVirtualAddressMap() has been called.
+ */
+static phys_addr_t efi_to_phys(unsigned long addr)
+{
+	efi_memory_desc_t *md;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (md->virt_addr == 0)
+			/* no virtual mapping has been installed by the stub */
+			break;
+		if (md->virt_addr <= addr &&
+		    (addr - md->virt_addr) < (md->num_pages << EFI_PAGE_SHIFT))
+			return md->phys_addr + addr - md->virt_addr;
+	}
+	return addr;
+}
+
+static int __init uefi_init(void)
+{
+	efi_char16_t *c16;
+	void *config_tables;
+	u64 table_size;
+	char vendor[100] = "unknown";
+	int i, retval;
+
+	efi.systab = early_memremap(efi_system_table,
+				    sizeof(efi_system_table_t));
+	if (efi.systab == NULL) {
+		pr_warn("Unable to map EFI system table.\n");
+		return -ENOMEM;
+	}
+
+	set_bit(EFI_BOOT, &efi.flags);
+	set_bit(EFI_64BIT, &efi.flags);
+
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
+		pr_err("System table signature incorrect\n");
+		retval = -EINVAL;
+		goto out;
+	}
+	if ((efi.systab->hdr.revision >> 16) < 2)
+		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
+			efi.systab->hdr.revision >> 16,
+			efi.systab->hdr.revision & 0xffff);
+
+	/* Show what we know for posterity */
+	c16 = early_memremap(efi_to_phys(efi.systab->fw_vendor),
+			     sizeof(vendor) * sizeof(efi_char16_t));
+	if (c16) {
+		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
+			vendor[i] = c16[i];
+		vendor[i] = '\0';
+		early_memunmap(c16, sizeof(vendor) * sizeof(efi_char16_t));
+	}
+
+	pr_info("EFI v%u.%.02u by %s\n",
+		efi.systab->hdr.revision >> 16,
+		efi.systab->hdr.revision & 0xffff, vendor);
+
+	table_size = sizeof(efi_config_table_64_t) * efi.systab->nr_tables;
+	config_tables = early_memremap(efi_to_phys(efi.systab->tables),
+				       table_size);
+
+	retval = efi_config_parse_tables(config_tables, efi.systab->nr_tables,
+					 sizeof(efi_config_table_64_t), NULL);
+
+	early_memunmap(config_tables, table_size);
+out:
+	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
+	return retval;
+}
+
+/*
+ * Return true for RAM regions we want to permanently reserve.
+ */
+static __init int is_reserve_region(efi_memory_desc_t *md)
+{
+	switch (md->type) {
+	case EFI_LOADER_CODE:
+	case EFI_LOADER_DATA:
+	case EFI_BOOT_SERVICES_CODE:
+	case EFI_BOOT_SERVICES_DATA:
+	case EFI_CONVENTIONAL_MEMORY:
+	case EFI_PERSISTENT_MEMORY:
+		return 0;
+	default:
+		break;
+	}
+	return is_normal_ram(md);
+}
+
+static __init void reserve_regions(void)
+{
+	efi_memory_desc_t *md;
+	u64 paddr, npages, size;
+
+	if (efi_enabled(EFI_DBG))
+		pr_info("Processing EFI memory map:\n");
+
+	for_each_efi_memory_desc(&memmap, md) {
+		paddr = md->phys_addr;
+		npages = md->num_pages;
+
+		if (efi_enabled(EFI_DBG)) {
+			char buf[64];
+
+			pr_info("  0x%012llx-0x%012llx %s",
+				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
+				efi_md_typeattr_format(buf, sizeof(buf), md));
+		}
+
+		memrange_efi_to_native(&paddr, &npages);
+		size = npages << PAGE_SHIFT;
+
+		if (is_normal_ram(md))
+			early_init_dt_add_memory(paddr, size);
+
+		if (is_reserve_region(md)) {
+			memblock_mark_nomap(paddr, size);
+			if (efi_enabled(EFI_DBG))
+				pr_cont("*");
+		}
+
+		if (efi_enabled(EFI_DBG))
+			pr_cont("\n");
+	}
+}
+
+void __init efi_parse_fdt(void *fdt)
+{
+	struct efi_fdt_params params;
+
+	/* Grab UEFI information placed in FDT by stub */
+	if (!efi_get_fdt_params(fdt, &params))
+		return;
+
+	efi_system_table = params.system_table;
+
+	memmap.phys_map = (void *)params.mmap;
+	memmap.desc_size = params.desc_size;
+	memmap.desc_version = params.desc_ver;
+	memmap.nr_map = params.mmap_size / params.desc_size;
+
+	set_bit(EFI_MEMMAP, &efi.flags);
+}
+
+void __init efi_init(void)
+{
+	int mmap_size = memmap.nr_map * memmap.desc_size;
+
+	if (!efi_enabled(EFI_MEMMAP))
+		return;
+
+	memmap.map = early_memremap((u64)memmap.phys_map, mmap_size);
+	memmap.map_end = memmap.map + mmap_size;
+
+	if (uefi_init() < 0)
+		return;
+
+	reserve_regions();
+	early_memunmap(memmap.map, mmap_size);
+	memblock_mark_nomap((unsigned long)memmap.phys_map & PAGE_MASK,
+			    PAGE_ALIGN(mmap_size));
+}
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
new file mode 100644
index 000000000000..5a94ea48670d
--- /dev/null
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -0,0 +1,191 @@
+/*
+ * Extensible Firmware Interface
+ *
+ * Based on Extensible Firmware Interface Specification version 2.4
+ *
+ * Copyright (C) 2013, 2014 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/efi.h>
+#include <linux/memblock.h>
+#include <linux/mm_types.h>
+#include <linux/preempt.h>
+#include <linux/rbtree.h>
+#include <linux/rwsem.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <asm/cacheflush.h>
+#include <asm/efi.h>
+#include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
+#include <asm/mmu.h>
+#include <asm/pgtable.h>
+
+static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
+
+extern u64 efi_system_table;
+
+static struct mm_struct efi_mm = {
+	.mm_rb			= RB_ROOT,
+	.pgd			= efi_pgd,
+	.mm_users		= ATOMIC_INIT(2),
+	.mm_count		= ATOMIC_INIT(1),
+	.mmap_sem		= __RWSEM_INITIALIZER(efi_mm.mmap_sem),
+	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
+	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
+	INIT_MM_CONTEXT(efi_mm)
+};
+
+static bool __init efi_virtmap_init(void)
+{
+	efi_memory_desc_t *md;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		u64 paddr, npages, size;
+		pteval_t prot_val;
+
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (md->virt_addr == 0)
+			return false;
+
+		paddr = md->phys_addr;
+		npages = md->num_pages;
+		memrange_efi_to_native(&paddr, &npages);
+		size = npages << PAGE_SHIFT;
+
+		/*
+		 * Order is important here: memory regions may have all of the
+		 * bits below set (and usually do), and any memory that has the
+		 * EFI_MEMORY_WB bit set may be covered by the linear mapping
+		 * and mapped write-back cacheable already. So check the
+		 * EFI_MEMORY_WB bit first.
+		 */
+		if (md->attribute & EFI_MEMORY_WB) {
+			prot_val = pgprot_val(PAGE_KERNEL_EXEC);
+		} else if (md->attribute & EFI_MEMORY_WT) {
+			prot_val = PROT_NORMAL_WT;
+		} else if (md->attribute & EFI_MEMORY_WC) {
+			prot_val = PROT_NORMAL_NC;
+		} else if (md->attribute & EFI_MEMORY_UC) {
+			prot_val = PROT_DEVICE_nGnRnE;
+		} else {
+			pr_warn("  EFI remap 0x%012llx: not remapping due to unsupported memory attributes (0x%llx)\n",
+				md->phys_addr, md->attribute);
+			continue;
+		}
+
+		/*
+		 * Since the UEFI spec requires only the type attributes to be
+		 * identical within the same 64 KB page frame, we may encounter
+		 * regions that are not 64 KB aligned, but whose attributes only
+		 * differ from adjacent regions in the permission bits.
+		 * This means we can only enforce any permission restrictions if
+		 * the boundaries of this region are aligned to the OS page
+		 * size.
+		 */
+		if (PAGE_SIZE == EFI_PAGE_SIZE ||
+		    (PAGE_ALIGNED(md->virt_addr) &&
+		     PAGE_ALIGNED(md->virt_addr + md->num_pages * EFI_PAGE_SIZE))) {
+
+			if (md->attribute & EFI_MEMORY_RO)
+				prot_val |= PTE_RDONLY;
+			if (md->attribute & EFI_MEMORY_XP)
+				prot_val |= PTE_PXN;
+		}
+
+		pr_info("  EFI remap 0x%012llx => %p (R%c%c)\n",
+			md->phys_addr, (void *)md->virt_addr,
+			prot_val & PTE_RDONLY ? '-' : 'W',
+			prot_val & PTE_PXN ? '-' : 'X');
+
+		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size,
+				   __pgprot(prot_val));
+	}
+	return true;
+}
+
+/*
+ * Enable the UEFI Runtime Services if all prerequisites are in place, i.e.,
+ * non-early mapping of the UEFI system table and virtual mappings for all
+ * EFI_MEMORY_RUNTIME regions.
+ */
+static int __init arm64_enable_runtime_services(void)
+{
+	u64 mapsize;
+
+	if (!efi_enabled(EFI_BOOT)) {
+		pr_info("EFI services will not be available.\n");
+		return -1;
+	}
+
+	if (efi_runtime_disabled()) {
+		pr_info("EFI runtime services will be disabled.\n");
+		return -1;
+	}
+
+	pr_info("Remapping and enabling EFI services.\n");
+
+	mapsize = memmap.map_end - memmap.map;
+	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
+						   mapsize);
+	if (!memmap.map) {
+		pr_err("Failed to remap EFI memory map\n");
+		return -1;
+	}
+	memmap.map_end = memmap.map + mapsize;
+	efi.memmap = &memmap;
+
+	efi.systab = (__force void *)ioremap_cache(efi_system_table,
+						   sizeof(efi_system_table_t));
+	if (!efi.systab) {
+		pr_err("Failed to remap EFI System Table\n");
+		return -1;
+	}
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+
+	if (!efi_virtmap_init()) {
+		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
+		return -1;
+	}
+
+	/* Set up runtime services function pointers */
+	efi_native_runtime_setup();
+	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+
+	efi.runtime_version = efi.systab->hdr.revision;
+
+	return 0;
+}
+early_initcall(arm64_enable_runtime_services);
+
+static void efi_set_pgd(struct mm_struct *mm)
+{
+	if (mm == &init_mm)
+		cpu_set_reserved_ttbr0();
+	else
+		cpu_switch_mm(mm->pgd, mm);
+
+	flush_tlb_all();
+	if (icache_is_aivivt())
+		__flush_icache_all();
+}
+
+void efi_virtmap_load(void)
+{
+	preempt_disable();
+	efi_set_pgd(&efi_mm);
+}
+
+void efi_virtmap_unload(void)
+{
+	efi_set_pgd(current->active_mm);
+	preempt_enable();
+}
-- 
1.9.1
