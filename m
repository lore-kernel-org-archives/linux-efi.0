From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] arm64/efi: move virtmap init to early initcall
Date: Thu, 22 Jan 2015 10:01:40 +0000
Message-ID: <1421920900-27028-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, lauraa-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now that the create_mapping() code in mm/mmu.c is able to support
setting up kernel page tables at initcall time, we can move the whole
virtmap creation to arm64_enable_runtime_services() instead of having
a distinct stage during early boot. This also allows us to drop the
arm64-specific EFI_VIRTMAP flag.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

This applies on top of Laura's "arm64: add better page protections to arm64":
the refactoring of mmu.c she did there allows us to greatly simplify the UEFI
virtmap code, and drop the explicit 'efi_virtmap_init()' call from setup_arch().

 arch/arm64/include/asm/efi.h |  18 ++-----
 arch/arm64/kernel/efi.c      | 111 +++++++++++++++++++++----------------------
 arch/arm64/kernel/setup.c    |   1 -
 arch/arm64/mm/mmu.c          |   2 +-
 4 files changed, 59 insertions(+), 73 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 7baf2cc04e1e..ef572206f1c3 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -6,10 +6,8 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
-extern void efi_virtmap_init(void);
 #else
 #define efi_init()
-#define efi_virtmap_init()
 #endif
 
 #define efi_call_virt(f, ...)						\
@@ -53,23 +51,17 @@ extern void efi_virtmap_init(void);
 #define EFI_ALLOC_ALIGN		SZ_64K
 
 /*
- * On ARM systems, virtually remapped UEFI runtime services are set up in three
+ * On ARM systems, virtually remapped UEFI runtime services are set up in two
  * distinct stages:
  * - The stub retrieves the final version of the memory map from UEFI, populates
  *   the virt_addr fields and calls the SetVirtualAddressMap() [SVAM] runtime
  *   service to communicate the new mapping to the firmware (Note that the new
  *   mapping is not live at this time)
- * - During early boot, the page tables are allocated and populated based on the
- *   virt_addr fields in the memory map, but only if all descriptors with the
- *   EFI_MEMORY_RUNTIME attribute have a non-zero value for virt_addr. If this
- *   succeeds, the EFI_VIRTMAP flag is set to indicate that the virtual mappings
- *   have been installed successfully.
- * - During an early initcall(), the UEFI Runtime Services are enabled and the
- *   EFI_RUNTIME_SERVICES bit set if some conditions are met, i.e., we need a
- *   non-early mapping of the UEFI system table, and we need to have the virtmap
- *   installed.
+ * - During an early initcall(), the EFI system table is permanently remapped
+ *   and the virtual remapping of the UEFI Runtime Services regions is loaded
+ *   into a private set of page tables. If this all succeeds, the Runtime
+ *   Services are enabled and the EFI_RUNTIME_SERVICES bit set.
  */
-#define EFI_VIRTMAP		EFI_ARCH_1
 
 void efi_virtmap_load(void);
 void efi_virtmap_unload(void);
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index c9cb0fbe7aa4..b42c7b480e1e 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -38,6 +38,19 @@ struct efi_memory_map memmap;
 
 static u64 efi_system_table;
 
+static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
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
 static int uefi_debug __initdata;
 static int __init uefi_debug_setup(char *str)
 {
@@ -213,6 +226,45 @@ void __init efi_init(void)
 		return;
 
 	reserve_regions();
+	early_memunmap(memmap.map, params.mmap_size);
+}
+
+static bool __init efi_virtmap_init(void)
+{
+	efi_memory_desc_t *md;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		u64 paddr, npages, size;
+		pgprot_t prot;
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
+		pr_info("  EFI remap 0x%016llx => %p\n",
+			md->phys_addr, (void *)md->virt_addr);
+
+		/*
+		 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
+		 * executable, everything else can be mapped with the XN bits
+		 * set.
+		 */
+		if (!is_normal_ram(md))
+			prot = __pgprot(PROT_DEVICE_nGnRE);
+		else if (md->type == EFI_RUNTIME_SERVICES_CODE)
+			prot = PAGE_KERNEL_EXEC;
+		else
+			prot = PAGE_KERNEL;
+
+		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
+	}
+	return true;
 }
 
 /*
@@ -254,7 +306,7 @@ static int __init arm64_enable_runtime_services(void)
 	}
 	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
-	if (!efi_enabled(EFI_VIRTMAP)) {
+	if (!efi_virtmap_init()) {
 		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
 		return -1;
 	}
@@ -283,19 +335,6 @@ static int __init arm64_dmi_init(void)
 }
 core_initcall(arm64_dmi_init);
 
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
 static void efi_set_pgd(struct mm_struct *mm)
 {
 	cpu_switch_mm(mm->pgd, mm);
@@ -315,47 +354,3 @@ void efi_virtmap_unload(void)
 	efi_set_pgd(current->active_mm);
 	preempt_enable();
 }
-
-void __init efi_virtmap_init(void)
-{
-	efi_memory_desc_t *md;
-
-	if (!efi_enabled(EFI_BOOT))
-		return;
-
-	for_each_efi_memory_desc(&memmap, md) {
-		u64 paddr, npages, size;
-		pgprot_t prot;
-
-		if (!(md->attribute & EFI_MEMORY_RUNTIME))
-			continue;
-		if (WARN(md->virt_addr == 0,
-			 "UEFI virtual mapping incomplete or missing -- no entry found for 0x%llx\n",
-			 md->phys_addr))
-			return;
-
-		paddr = md->phys_addr;
-		npages = md->num_pages;
-		memrange_efi_to_native(&paddr, &npages);
-		size = npages << PAGE_SHIFT;
-
-		pr_info("  EFI remap 0x%016llx => %p\n",
-			md->phys_addr, (void *)md->virt_addr);
-
-		/*
-		 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
-		 * executable, everything else can be mapped with the XN bits
-		 * set.
-		 */
-		if (!is_normal_ram(md))
-			prot = __pgprot(PROT_DEVICE_nGnRE);
-		else if (md->type == EFI_RUNTIME_SERVICES_CODE)
-			prot = PAGE_KERNEL_EXEC;
-		else
-			prot = PAGE_KERNEL;
-
-		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
-	}
-	set_bit(EFI_VIRTMAP, &efi.flags);
-	early_memunmap(memmap.map, memmap.map_end - memmap.map);
-}
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 207413fe08a0..bb10903887d4 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -382,7 +382,6 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	request_standard_resources();
 
-	efi_virtmap_init();
 	early_ioremap_reset();
 
 	unflatten_device_tree();
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 91d55b6efd8a..155cbb0a74b6 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -269,7 +269,7 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       pgprot_t prot)
 {
 	__create_mapping(mm, pgd_offset(mm, virt), phys, virt, size, prot,
-				early_alloc);
+				late_alloc);
 }
 
 static void create_mapping_late(phys_addr_t phys, unsigned long virt,
-- 
1.8.3.2
