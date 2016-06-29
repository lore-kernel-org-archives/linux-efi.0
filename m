From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/5] arm64: mm: add param to force create_pgd_mapping() to use page mappings
Date: Wed, 29 Jun 2016 14:51:26 +0200
Message-ID: <1467204690-10790-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1467204690-10790-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467204690-10790-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add a bool parameter 'allow_block_mappings' to create_pgd_mapping() and
the various helper functions that it descends into, to give the caller
control over whether block entries may be used to create the mapping.

The UEFI runtime mapping routines will use this to avoid creating block
entries that would need to split up into page entries when applying the
permissions listed in the Memory Attributes firmware table.

This also replaces the block_mappings_allowed() helper function that was
added for DEBUG_PAGEALLOC functionality, but the resulting code is
functionally equivalent (given that debug_page_alloc does not operate on
EFI page table entries anyway)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/mmu.h |  2 +-
 arch/arm64/kernel/efi.c      |  2 +-
 arch/arm64/mm/mmu.c          | 67 ++++++++------------
 3 files changed, 29 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 97b1d8f26b9c..8d9fce037b2f 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -34,7 +34,7 @@ extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
-			       pgprot_t prot);
+			       pgprot_t prot, bool allow_block_mappings);
 extern void *fixmap_remap_fdt(phys_addr_t dt_phys);
 
 #endif
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 78f52488f9ff..981604948521 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -65,7 +65,7 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 
 	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
 			   md->num_pages << EFI_PAGE_SHIFT,
-			   __pgprot(prot_val | PTE_NG));
+			   __pgprot(prot_val | PTE_NG), true);
 	return 0;
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0f85a46c3e18..a86d1acb3a7b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -156,29 +156,10 @@ static void split_pud(pud_t *old_pud, pmd_t *pmd)
 	} while (pmd++, i++, i < PTRS_PER_PMD);
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-static bool block_mappings_allowed(phys_addr_t (*pgtable_alloc)(void))
-{
-
-	/*
-	 * If debug_page_alloc is enabled we must map the linear map
-	 * using pages. However, other mappings created by
-	 * create_mapping_noalloc must use sections in some cases. Allow
-	 * sections to be used in those cases, where no pgtable_alloc
-	 * function is provided.
-	 */
-	return !pgtable_alloc || !debug_pagealloc_enabled();
-}
-#else
-static bool block_mappings_allowed(phys_addr_t (*pgtable_alloc)(void))
-{
-	return true;
-}
-#endif
-
 static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 				  phys_addr_t phys, pgprot_t prot,
-				  phys_addr_t (*pgtable_alloc)(void))
+				  phys_addr_t (*pgtable_alloc)(void),
+				  bool allow_block_mappings)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -209,7 +190,7 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 		next = pmd_addr_end(addr, end);
 		/* try section mapping first */
 		if (((addr | next | phys) & ~SECTION_MASK) == 0 &&
-		      block_mappings_allowed(pgtable_alloc)) {
+		      allow_block_mappings) {
 			pmd_t old_pmd =*pmd;
 			pmd_set_huge(pmd, phys, prot);
 			/*
@@ -248,7 +229,8 @@ static inline bool use_1G_block(unsigned long addr, unsigned long next,
 
 static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 				  phys_addr_t phys, pgprot_t prot,
-				  phys_addr_t (*pgtable_alloc)(void))
+				  phys_addr_t (*pgtable_alloc)(void),
+				  bool allow_block_mappings)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -268,8 +250,7 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 		/*
 		 * For 4K granule only, attempt to put down a 1GB block
 		 */
-		if (use_1G_block(addr, next, phys) &&
-		    block_mappings_allowed(pgtable_alloc)) {
+		if (use_1G_block(addr, next, phys) && allow_block_mappings) {
 			pud_t old_pud = *pud;
 			pud_set_huge(pud, phys, prot);
 
@@ -290,7 +271,7 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 			}
 		} else {
 			alloc_init_pmd(pud, addr, next, phys, prot,
-				       pgtable_alloc);
+				       pgtable_alloc, allow_block_mappings);
 		}
 		phys += next - addr;
 	} while (pud++, addr = next, addr != end);
@@ -304,7 +285,8 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
  */
 static void init_pgd(pgd_t *pgd, phys_addr_t phys, unsigned long virt,
 				    phys_addr_t size, pgprot_t prot,
-				    phys_addr_t (*pgtable_alloc)(void))
+				    phys_addr_t (*pgtable_alloc)(void),
+				    bool allow_block_mappings)
 {
 	unsigned long addr, length, end, next;
 
@@ -322,7 +304,8 @@ static void init_pgd(pgd_t *pgd, phys_addr_t phys, unsigned long virt,
 	end = addr + length;
 	do {
 		next = pgd_addr_end(addr, end);
-		alloc_init_pud(pgd, addr, next, phys, prot, pgtable_alloc);
+		alloc_init_pud(pgd, addr, next, phys, prot, pgtable_alloc,
+			       allow_block_mappings);
 		phys += next - addr;
 	} while (pgd++, addr = next, addr != end);
 }
@@ -340,9 +323,11 @@ static phys_addr_t late_pgtable_alloc(void)
 static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				 unsigned long virt, phys_addr_t size,
 				 pgprot_t prot,
-				 phys_addr_t (*alloc)(void))
+				 phys_addr_t (*alloc)(void),
+				 bool allow_block_mappings)
 {
-	init_pgd(pgd_offset_raw(pgdir, virt), phys, virt, size, prot, alloc);
+	init_pgd(pgd_offset_raw(pgdir, virt), phys, virt, size, prot, alloc,
+		 allow_block_mappings);
 }
 
 /*
@@ -358,16 +343,15 @@ static void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot,
-			     NULL);
+	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, true);
 }
 
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 			       unsigned long virt, phys_addr_t size,
-			       pgprot_t prot)
+			       pgprot_t prot, bool allow_block_mappings)
 {
 	__create_pgd_mapping(mm->pgd, phys, virt, size, prot,
-			     late_pgtable_alloc);
+			     late_pgtable_alloc, allow_block_mappings);
 }
 
 static void create_mapping_late(phys_addr_t phys, unsigned long virt,
@@ -380,7 +364,7 @@ static void create_mapping_late(phys_addr_t phys, unsigned long virt,
 	}
 
 	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot,
-			     late_pgtable_alloc);
+			     late_pgtable_alloc, !debug_pagealloc_enabled());
 }
 
 static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end)
@@ -397,7 +381,8 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 	if (end < kernel_start || start >= kernel_end) {
 		__create_pgd_mapping(pgd, start, __phys_to_virt(start),
 				     end - start, PAGE_KERNEL,
-				     early_pgtable_alloc);
+				     early_pgtable_alloc,
+				     !debug_pagealloc_enabled());
 		return;
 	}
 
@@ -409,12 +394,14 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 		__create_pgd_mapping(pgd, start,
 				     __phys_to_virt(start),
 				     kernel_start - start, PAGE_KERNEL,
-				     early_pgtable_alloc);
+				     early_pgtable_alloc,
+				     !debug_pagealloc_enabled());
 	if (kernel_end < end)
 		__create_pgd_mapping(pgd, kernel_end,
 				     __phys_to_virt(kernel_end),
 				     end - kernel_end, PAGE_KERNEL,
-				     early_pgtable_alloc);
+				     early_pgtable_alloc,
+				     !debug_pagealloc_enabled());
 
 	/*
 	 * Map the linear alias of the [_text, _etext) interval as
@@ -424,7 +411,7 @@ static void __init __map_memblock(pgd_t *pgd, phys_addr_t start, phys_addr_t end
 	 */
 	__create_pgd_mapping(pgd, kernel_start, __phys_to_virt(kernel_start),
 			     kernel_end - kernel_start, PAGE_KERNEL_RO,
-			     early_pgtable_alloc);
+			     early_pgtable_alloc, !debug_pagealloc_enabled());
 }
 
 static void __init map_mem(pgd_t *pgd)
@@ -481,7 +468,7 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
 	BUG_ON(!PAGE_ALIGNED(size));
 
 	__create_pgd_mapping(pgd, pa_start, (unsigned long)va_start, size, prot,
-			     early_pgtable_alloc);
+			     early_pgtable_alloc, !debug_pagealloc_enabled());
 
 	vma->addr	= va_start;
 	vma->phys_addr	= pa_start;
-- 
2.7.4
