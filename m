From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 07/10] arm64/efi: remove idmap manipulations from UEFI code
Date: Thu,  6 Nov 2014 15:13:23 +0100
Message-ID: <1415283206-14713-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1415283206-14713-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415283206-14713-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now that we have moved the call to SetVirtualAddressMap() to the stub,
UEFI has no use for the ID map, so we can drop the code that installs
ID mappings for UEFI memory regions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h |  2 --
 arch/arm64/include/asm/mmu.h |  2 --
 arch/arm64/kernel/efi.c      | 30 ------------------------------
 arch/arm64/kernel/setup.c    |  1 -
 arch/arm64/mm/mmu.c          | 12 ------------
 5 files changed, 47 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index e2cea16f3bd7..5420ad5a4c63 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -6,10 +6,8 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
-extern void efi_idmap_init(void);
 #else
 #define efi_init()
-#define efi_idmap_init()
 #endif
 
 #define efi_call_virt(f, ...)						\
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 5fd40c43be80..3d311761e3c2 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -31,8 +31,6 @@ extern void paging_init(void);
 extern void setup_mm_for_reboot(void);
 extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
-/* create an identity mapping for memory (or io if map_io is true) */
-extern void create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot);
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 9f05b4fe9fd5..a48a2f9ab669 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -47,27 +47,6 @@ static int __init is_normal_ram(efi_memory_desc_t *md)
 	return 0;
 }
 
-static void __init efi_setup_idmap(void)
-{
-	struct memblock_region *r;
-	efi_memory_desc_t *md;
-	u64 paddr, npages, size;
-
-	for_each_memblock(memory, r)
-		create_id_mapping(r->base, r->size, 0);
-
-	/* map runtime io spaces */
-	for_each_efi_memory_desc(&memmap, md) {
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) || is_normal_ram(md))
-			continue;
-		paddr = md->phys_addr;
-		npages = md->num_pages;
-		memrange_efi_to_native(&paddr, &npages);
-		size = npages << PAGE_SHIFT;
-		create_id_mapping(paddr, size, 1);
-	}
-}
-
 static int __init uefi_init(void)
 {
 	efi_char16_t *c16;
@@ -207,15 +186,6 @@ void __init efi_init(void)
 	reserve_regions();
 }
 
-void __init efi_idmap_init(void)
-{
-	if (!efi_enabled(EFI_BOOT))
-		return;
-
-	/* boot time idmap_pg_dir is incomplete, so fill in missing parts */
-	efi_setup_idmap();
-}
-
 static int __init arm64_enter_virtual_mode(void)
 {
 	u64 mapsize;
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index ac19b2d6a3fc..a6028490a28f 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -392,7 +392,6 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	request_standard_resources();
 
-	efi_idmap_init();
 	efi_virtmap_init();
 
 	unflatten_device_tree();
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b6dc2ce3991a..3e8b3732ca87 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -271,18 +271,6 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
 			 size, PAGE_KERNEL_EXEC);
 }
 
-void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
-{
-	if ((addr >> PGDIR_SHIFT) >= ARRAY_SIZE(idmap_pg_dir)) {
-		pr_warn("BUG: not creating id mapping for %pa\n", &addr);
-		return;
-	}
-	__create_mapping(&init_mm, &idmap_pg_dir[pgd_index(addr)],
-			 addr, addr, size,
-			 map_io ? __pgprot(PROT_DEVICE_nGnRE)
-				: PAGE_KERNEL_EXEC);
-}
-
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
 			       pgprot_t prot)
-- 
1.8.3.2
