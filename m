From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH] arm64/efi: use id mapping for Runtime Services
Date: Thu, 31 Jul 2014 16:11:49 +0200
Message-ID: <1406815909-26825-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There are 2 interesting pieces of information in the UEFI spec section 2.3.6
regarding the mapping of runtime regions:
(a) the firmware should not request a virtual mapping for configuration tables,
    even though they are marked as EfiRuntimeServicesData;
(b) calling SetVirtualAddressMap() is optional, and it is equally appropriate to
    call Runtime Services using an identity mapping.

So we can eliminate some of the complexity around UEFI Runtime Services by not
using a virtual mapping at all, and calling the services at their physical
address. This is especially useful under kexec, as SetVirtualAddressMap() may
only be called once, and there is no guarantee that mappings are stable between
different kexec'd kernels.

The fallout for other in-kernel users of UEFI data structures should be
negligible, as they cannot legally access those data structures through
pre-existing virtual mappings anyway (point (a) above)

It should also be noted that, as the kernel side of the address space (TTBR1) is
retained, the stack and pointer function arguments remain accessible to the
runtime service while the id mapping is active.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h |  24 ++++++++--
 arch/arm64/kernel/efi.c      | 106 ++-----------------------------------------
 2 files changed, 23 insertions(+), 107 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a34fd3b12e2b..d42a21e79b39 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -1,8 +1,10 @@
 #ifndef _ASM_EFI_H
 #define _ASM_EFI_H
 
+#include <asm/cacheflush.h>
 #include <asm/io.h>
 #include <asm/neon.h>
+#include <asm/tlbflush.h>
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
@@ -12,23 +14,37 @@ extern void efi_idmap_init(void);
 #define efi_idmap_init()
 #endif
 
+static inline void switch_pgd(pgd_t *pgd, struct mm_struct *mm)
+{
+	cpu_switch_mm(pgd, mm);
+	flush_tlb_all();
+	if (icache_is_aivivt())
+		__flush_icache_all();
+}
+
 #define efi_call_virt(f, ...)						\
 ({									\
-	efi_##f##_t *__f = efi.systab->runtime->f;			\
+	efi_##f##_t *__f;						\
 	efi_status_t __s;						\
 									\
-	kernel_neon_begin();						\
+	kernel_neon_begin(); /* disables preemption */			\
+	switch_pgd(idmap_pg_dir, &init_mm);				\
+	__f =  efi.systab->runtime->f;					\
 	__s = __f(__VA_ARGS__);						\
+	switch_pgd(current->active_mm->pgd, current->active_mm);	\
 	kernel_neon_end();						\
 	__s;								\
 })
 
 #define __efi_call_virt(f, ...)						\
 ({									\
-	efi_##f##_t *__f = efi.systab->runtime->f;			\
+	efi_##f##_t *__f;						\
 									\
-	kernel_neon_begin();						\
+	kernel_neon_begin(); /* disables preemption */			\
+	switch_pgd(idmap_pg_dir, &init_mm);				\
+	__f =  efi.systab->runtime->f;					\
 	__f(__VA_ARGS__);						\
+	switch_pgd(current->active_mm->pgd, current->active_mm);	\
 	kernel_neon_end();						\
 })
 
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e72f3100958f..d620a031e7bf 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -27,8 +27,6 @@
 
 struct efi_memory_map memmap;
 
-static efi_runtime_services_t *runtime;
-
 static u64 efi_system_table;
 
 static int uefi_debug __initdata;
@@ -340,51 +338,9 @@ void __init efi_idmap_init(void)
 	efi_setup_idmap();
 }
 
-static int __init remap_region(efi_memory_desc_t *md, void **new)
-{
-	u64 paddr, vaddr, npages, size;
-
-	paddr = md->phys_addr;
-	npages = md->num_pages;
-	memrange_efi_to_native(&paddr, &npages);
-	size = npages << PAGE_SHIFT;
-
-	if (is_normal_ram(md))
-		vaddr = (__force u64)ioremap_cache(paddr, size);
-	else
-		vaddr = (__force u64)ioremap(paddr, size);
-
-	if (!vaddr) {
-		pr_err("Unable to remap 0x%llx pages @ %p\n",
-		       npages, (void *)paddr);
-		return 0;
-	}
-
-	/* adjust for any rounding when EFI and system pagesize differs */
-	md->virt_addr = vaddr + (md->phys_addr - paddr);
-
-	if (uefi_debug)
-		pr_info("  EFI remap 0x%012llx => %p\n",
-			md->phys_addr, (void *)md->virt_addr);
-
-	memcpy(*new, md, memmap.desc_size);
-	*new += memmap.desc_size;
-
-	return 1;
-}
-
-/*
- * Switch UEFI from an identity map to a kernel virtual map
- */
 static int __init arm64_enter_virtual_mode(void)
 {
-	efi_memory_desc_t *md;
-	phys_addr_t virtmap_phys;
-	void *virtmap, *virt_md;
-	efi_status_t status;
 	u64 mapsize;
-	int count = 0;
-	unsigned long flags;
 
 	if (!efi_enabled(EFI_BOOT)) {
 		pr_info("EFI services will not be available.\n");
@@ -402,76 +358,20 @@ static int __init arm64_enter_virtual_mode(void)
 
 	efi.memmap = &memmap;
 
-	/* Map the runtime regions */
-	virtmap = kmalloc(mapsize, GFP_KERNEL);
-	if (!virtmap) {
-		pr_err("Failed to allocate EFI virtual memmap\n");
-		return -1;
-	}
-	virtmap_phys = virt_to_phys(virtmap);
-	virt_md = virtmap;
-
-	for_each_efi_memory_desc(&memmap, md) {
-		if (!(md->attribute & EFI_MEMORY_RUNTIME))
-			continue;
-		if (!remap_region(md, &virt_md))
-			goto err_unmap;
-		++count;
-	}
-
-	efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
+	efi.systab = (__force void *)ioremap_cache(efi_system_table,
+						   sizeof(efi_system_table_t));
 	if (!efi.systab) {
-		/*
-		 * If we have no virtual mapping for the System Table at this
-		 * point, the memory map doesn't cover the physical offset where
-		 * it resides. This means the System Table will be inaccessible
-		 * to Runtime Services themselves once the virtual mapping is
-		 * installed.
-		 */
 		pr_err("Failed to remap EFI System Table -- buggy firmware?\n");
-		goto err_unmap;
+		return -1;
 	}
 	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
-	local_irq_save(flags);
-	cpu_switch_mm(idmap_pg_dir, &init_mm);
-
-	/* Call SetVirtualAddressMap with the physical address of the map */
-	runtime = efi.systab->runtime;
-	efi.set_virtual_address_map = runtime->set_virtual_address_map;
-
-	status = efi.set_virtual_address_map(count * memmap.desc_size,
-					     memmap.desc_size,
-					     memmap.desc_version,
-					     (efi_memory_desc_t *)virtmap_phys);
-	cpu_set_reserved_ttbr0();
-	flush_tlb_all();
-	local_irq_restore(flags);
-
-	kfree(virtmap);
-
 	free_boot_services();
 
-	if (status != EFI_SUCCESS) {
-		pr_err("Failed to set EFI virtual address map! [%lx]\n",
-			status);
-		return -1;
-	}
-
 	/* Set up runtime services function pointers */
-	runtime = efi.systab->runtime;
 	efi_native_runtime_setup();
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
 	return 0;
-
-err_unmap:
-	/* unmap all mappings that succeeded: there are 'count' of those */
-	for (virt_md = virtmap; count--; virt_md += memmap.desc_size) {
-		md = virt_md;
-		iounmap((__force void __iomem *)md->virt_addr);
-	}
-	kfree(virtmap);
-	return -1;
 }
 early_initcall(arm64_enter_virtual_mode);
-- 
1.8.3.2
