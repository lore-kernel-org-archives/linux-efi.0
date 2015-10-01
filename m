From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/9] arm64/efi: refactor EFI init and runtime code for reuse by 32-bit ARM
Date: Thu,  1 Oct 2015 19:04:16 +0200
Message-ID: <1443719063-6832-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443719063-6832-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This refactors the EFI init and runtime code that will be shared
between arm64 and ARM so that it can be built for both archs.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h       |  16 ++++
 arch/arm64/kernel/efi.c            |  51 ++++++++++
 drivers/firmware/efi/arm-init.c    |  11 ++-
 drivers/firmware/efi/arm-runtime.c | 101 ++++++--------------
 drivers/firmware/efi/efi.c         |   4 +-
 5 files changed, 105 insertions(+), 78 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 7cc8df68c638..a16490d6ec1a 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -2,7 +2,9 @@
 #define _ASM_EFI_H
 
 #include <asm/io.h>
+#include <asm/mmu_context.h>
 #include <asm/neon.h>
+#include <asm/tlbflush.h>
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
@@ -12,6 +14,8 @@ extern void efi_parse_fdt(void *fdt);
 #define efi_parse_fdt(x)
 #endif
 
+int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
+
 #define efi_call_virt(f, ...)						\
 ({									\
 	efi_##f##_t *__f;						\
@@ -65,6 +69,18 @@ extern void efi_parse_fdt(void *fdt);
  *   Services are enabled and the EFI_RUNTIME_SERVICES bit set.
  */
 
+static inline void efi_set_pgd(struct mm_struct *mm)
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
 void efi_virtmap_load(void);
 void efi_virtmap_unload(void);
 
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index bd3b2f5adf0c..77df172f0e6d 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -17,6 +17,57 @@
 
 #include <asm/efi.h>
 
+int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
+{
+	u64 paddr, npages, size;
+	pteval_t prot_val;
+
+	paddr = md->phys_addr;
+	npages = md->num_pages;
+	memrange_efi_to_native(&paddr, &npages);
+	size = npages << PAGE_SHIFT;
+
+	/*
+	 * Order is important here: memory regions may have all of the
+	 * bits below set (and usually do), and any memory that has the
+	 * EFI_MEMORY_WB bit set may be covered by the linear mapping
+	 * and mapped write-back cacheable already. So check the
+	 * EFI_MEMORY_WB bit first.
+	 */
+	if (md->attribute & EFI_MEMORY_WB)
+		prot_val = pgprot_val(PAGE_KERNEL_EXEC);
+	else if (md->attribute & EFI_MEMORY_WT)
+		prot_val = PROT_NORMAL_WT;
+	else if (md->attribute & EFI_MEMORY_WC)
+		prot_val = PROT_NORMAL_NC;
+	else if (md->attribute & EFI_MEMORY_UC)
+		prot_val = PROT_DEVICE_nGnRnE;
+	else
+		return -EINVAL;
+
+	/*
+	 * Since the UEFI spec requires only the type attributes to be
+	 * identical within the same 64 KB page frame, we may encounter
+	 * regions that are not 64 KB aligned, but whose attributes only
+	 * differ from adjacent regions in the permission bits.
+	 * This means we can only enforce any permission restrictions if
+	 * the boundaries of this region are aligned to the OS page
+	 * size.
+	 */
+	if (PAGE_SIZE == EFI_PAGE_SIZE ||
+	    (PAGE_ALIGNED(md->virt_addr) &&
+	     PAGE_ALIGNED(md->virt_addr + md->num_pages * EFI_PAGE_SIZE))) {
+
+		if (md->attribute & EFI_MEMORY_RO)
+			prot_val |= PTE_RDONLY;
+		if (md->attribute & EFI_MEMORY_XP)
+			prot_val |= PTE_PXN;
+	}
+
+	create_pgd_mapping(mm, paddr, md->virt_addr, size, __pgprot(prot_val));
+	return 0;
+}
+
 static int __init arm64_dmi_init(void)
 {
 	/*
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 56987a5b9033..235677b86e4e 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -66,7 +66,7 @@ static int __init uefi_init(void)
 {
 	efi_char16_t *c16;
 	void *config_tables;
-	u64 table_size;
+	int table_size;
 	char vendor[100] = "unknown";
 	int i, retval;
 
@@ -78,7 +78,8 @@ static int __init uefi_init(void)
 	}
 
 	set_bit(EFI_BOOT, &efi.flags);
-	set_bit(EFI_64BIT, &efi.flags);
+	if (IS_ENABLED(CONFIG_64BIT))
+		set_bit(EFI_64BIT, &efi.flags);
 
 	/*
 	 * Verify the EFI Table
@@ -112,7 +113,7 @@ static int __init uefi_init(void)
 				       table_size);
 
 	retval = efi_config_parse_tables(config_tables, efi.systab->nr_tables,
-					 sizeof(efi_config_table_64_t), NULL);
+					 sizeof(efi_config_table_t), NULL);
 
 	early_memunmap(config_tables, table_size);
 out:
@@ -186,7 +187,7 @@ void __init efi_parse_fdt(void *fdt)
 
 	efi_system_table = params.system_table;
 
-	memmap.phys_map = (void *)params.mmap;
+	memmap.phys_map = (void *)(unsigned long)params.mmap;
 	memmap.desc_size = params.desc_size;
 	memmap.desc_version = params.desc_ver;
 	memmap.nr_map = params.mmap_size / params.desc_size;
@@ -201,7 +202,7 @@ void __init efi_init(void)
 	if (!efi_enabled(EFI_MEMMAP))
 		return;
 
-	memmap.map = early_memremap((u64)memmap.phys_map, mmap_size);
+	memmap.map = early_memremap((unsigned long)memmap.phys_map, mmap_size);
 	memmap.map_end = memmap.map + mmap_size;
 
 	if (uefi_init() < 0)
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 5a94ea48670d..7f23f3cffb46 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -23,18 +23,19 @@
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
-#include <asm/tlbflush.h>
-#include <asm/mmu_context.h>
+#include <asm/io.h>
 #include <asm/mmu.h>
+#include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 
-static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
+#ifndef INIT_MM_CONTEXT
+#define INIT_MM_CONTEXT(name)
+#endif
 
 extern u64 efi_system_table;
 
 static struct mm_struct efi_mm = {
 	.mm_rb			= RB_ROOT,
-	.pgd			= efi_pgd,
 	.mm_users		= ATOMIC_INIT(2),
 	.mm_count		= ATOMIC_INIT(1),
 	.mmap_sem		= __RWSEM_INITIALIZER(efi_mm.mmap_sem),
@@ -47,67 +48,34 @@ static bool __init efi_virtmap_init(void)
 {
 	efi_memory_desc_t *md;
 
+	efi_mm.pgd = pgd_alloc(&efi_mm);
+
 	for_each_efi_memory_desc(&memmap, md) {
-		u64 paddr, npages, size;
-		pteval_t prot_val;
+		phys_addr_t phys = (phys_addr_t)md->phys_addr;
+		int ret;
 
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 		if (md->virt_addr == 0)
 			return false;
 
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
+		ret = efi_create_mapping(&efi_mm, md);
+		switch (ret) {
+		case 0:
+			pr_info("  EFI remap %pa => %p (R%c%c)\n",
+				&phys, (void *)(unsigned long)md->virt_addr,
+				md->attribute & EFI_MEMORY_RO ? '-' : 'W',
+				md->attribute & EFI_MEMORY_XP ? '-' : 'X');
+			break;
+		case -EINVAL:
+			pr_warn("  EFI remap %pa: not remapping due to unsupported memory attributes (0x%llx)\n",
+				&phys, md->attribute);
+			return false;
+		default:
+			pr_warn("  EFI remap %pa: failed to create mapping (%d)\n",
+				&phys, ret);
+			return false;
 		}
-
-		pr_info("  EFI remap 0x%012llx => %p (R%c%c)\n",
-			md->phys_addr, (void *)md->virt_addr,
-			prot_val & PTE_RDONLY ? '-' : 'W',
-			prot_val & PTE_PXN ? '-' : 'X');
-
-		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size,
-				   __pgprot(prot_val));
 	}
 	return true;
 }
@@ -117,7 +85,7 @@ static bool __init efi_virtmap_init(void)
  * non-early mapping of the UEFI system table and virtual mappings for all
  * EFI_MEMORY_RUNTIME regions.
  */
-static int __init arm64_enable_runtime_services(void)
+static int __init arm_enable_runtime_services(void)
 {
 	u64 mapsize;
 
@@ -134,7 +102,7 @@ static int __init arm64_enable_runtime_services(void)
 	pr_info("Remapping and enabling EFI services.\n");
 
 	mapsize = memmap.map_end - memmap.map;
-	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
+	memmap.map = (__force void *)ioremap_cache((unsigned long)memmap.phys_map,
 						   mapsize);
 	if (!memmap.map) {
 		pr_err("Failed to remap EFI memory map\n");
@@ -155,6 +123,7 @@ static int __init arm64_enable_runtime_services(void)
 		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
 		return -1;
 	}
+	iounmap(memmap.map);
 
 	/* Set up runtime services function pointers */
 	efi_native_runtime_setup();
@@ -164,19 +133,7 @@ static int __init arm64_enable_runtime_services(void)
 
 	return 0;
 }
-early_initcall(arm64_enable_runtime_services);
-
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
+early_initcall(arm_enable_runtime_services);
 
 void efi_virtmap_load(void)
 {
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index f5e586bd3b24..2eb31e28a35c 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -23,6 +23,8 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 
+#include <asm/efi.h>
+
 struct efi __read_mostly efi = {
 	.mps			= EFI_INVALID_TABLE_ADDR,
 	.acpi			= EFI_INVALID_TABLE_ADDR,
@@ -286,7 +288,7 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
 		 * So just always get our own virtual map on the CPU.
 		 *
 		 */
-		md = early_memremap((phys_addr_t)p, sizeof (*md));
+		md = early_memremap((unsigned long)p, sizeof (*md));
 		if (!md) {
 			pr_err_once("early_memremap(%p, %zu) failed.\n",
 				    p, sizeof (*md));
-- 
1.9.1
