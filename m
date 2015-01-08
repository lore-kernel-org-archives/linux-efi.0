From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 2/8] arm64/mm: add create_pgd_mapping() to create private page tables
Date: Thu,  8 Jan 2015 18:48:28 +0000
Message-ID: <1420742914-2404-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420742914-2404-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

For UEFI, we need to install the memory mappings used for Runtime Services
in a dedicated set of page tables. Add create_pgd_mapping(), which allows
us to allocate and install those page table entries early.

Reviewed-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/mmu.h     |  3 +++
 arch/arm64/include/asm/pgtable.h |  5 +++++
 arch/arm64/mm/mmu.c              | 43 ++++++++++++++++++++--------------------
 3 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index c2f006c48bdb..5fd40c43be80 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -33,5 +33,8 @@ extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
 /* create an identity mapping for memory (or io if map_io is true) */
 extern void create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io);
+extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
+			       unsigned long virt, phys_addr_t size,
+			       pgprot_t prot);
 
 #endif
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 210d632aa5ad..59079248529d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -264,6 +264,11 @@ static inline pmd_t pte_pmd(pte_t pte)
 	return __pmd(pte_val(pte));
 }
 
+static inline pgprot_t mk_sect_prot(pgprot_t prot)
+{
+	return __pgprot(pgprot_val(prot) & ~PTE_TABLE_BIT);
+}
+
 /*
  * THP definitions.
  */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7d5dfe2d3de0..3f3d5aa4a8b1 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -158,20 +158,10 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 
 static void __init alloc_init_pmd(struct mm_struct *mm, pud_t *pud,
 				  unsigned long addr, unsigned long end,
-				  phys_addr_t phys, int map_io)
+				  phys_addr_t phys, pgprot_t prot)
 {
 	pmd_t *pmd;
 	unsigned long next;
-	pmdval_t prot_sect;
-	pgprot_t prot_pte;
-
-	if (map_io) {
-		prot_sect = PROT_SECT_DEVICE_nGnRE;
-		prot_pte = __pgprot(PROT_DEVICE_nGnRE);
-	} else {
-		prot_sect = PROT_SECT_NORMAL_EXEC;
-		prot_pte = PAGE_KERNEL_EXEC;
-	}
 
 	/*
 	 * Check for initial section mappings in the pgd/pud and remove them.
@@ -187,7 +177,8 @@ static void __init alloc_init_pmd(struct mm_struct *mm, pud_t *pud,
 		/* try section mapping first */
 		if (((addr | next | phys) & ~SECTION_MASK) == 0) {
 			pmd_t old_pmd =*pmd;
-			set_pmd(pmd, __pmd(phys | prot_sect));
+			set_pmd(pmd, __pmd(phys |
+					   pgprot_val(mk_sect_prot(prot))));
 			/*
 			 * Check for previous table entries created during
 			 * boot (__create_page_tables) and flush them.
@@ -196,7 +187,7 @@ static void __init alloc_init_pmd(struct mm_struct *mm, pud_t *pud,
 				flush_tlb_all();
 		} else {
 			alloc_init_pte(pmd, addr, next, __phys_to_pfn(phys),
-				       prot_pte);
+				       prot);
 		}
 		phys += next - addr;
 	} while (pmd++, addr = next, addr != end);
@@ -204,7 +195,7 @@ static void __init alloc_init_pmd(struct mm_struct *mm, pud_t *pud,
 
 static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
 				  unsigned long addr, unsigned long end,
-				  phys_addr_t phys, int map_io)
+				  phys_addr_t phys, pgprot_t prot)
 {
 	pud_t *pud;
 	unsigned long next;
@@ -222,10 +213,11 @@ static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
 		/*
 		 * For 4K granule only, attempt to put down a 1GB block
 		 */
-		if (!map_io && (PAGE_SHIFT == 12) &&
+		if ((PAGE_SHIFT == 12) &&
 		    ((addr | next | phys) & ~PUD_MASK) == 0) {
 			pud_t old_pud = *pud;
-			set_pud(pud, __pud(phys | PROT_SECT_NORMAL_EXEC));
+			set_pud(pud, __pud(phys |
+					   pgprot_val(mk_sect_prot(prot))));
 
 			/*
 			 * If we have an old value for a pud, it will
@@ -240,7 +232,7 @@ static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
 				flush_tlb_all();
 			}
 		} else {
-			alloc_init_pmd(mm, pud, addr, next, phys, map_io);
+			alloc_init_pmd(mm, pud, addr, next, phys, prot);
 		}
 		phys += next - addr;
 	} while (pud++, addr = next, addr != end);
@@ -252,7 +244,7 @@ static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
  */
 static void __init __create_mapping(struct mm_struct *mm, pgd_t *pgd,
 				    phys_addr_t phys, unsigned long virt,
-				    phys_addr_t size, int map_io)
+				    phys_addr_t size, pgprot_t prot)
 {
 	unsigned long addr, length, end, next;
 
@@ -262,7 +254,7 @@ static void __init __create_mapping(struct mm_struct *mm, pgd_t *pgd,
 	end = addr + length;
 	do {
 		next = pgd_addr_end(addr, end);
-		alloc_init_pud(mm, pgd, addr, next, phys, map_io);
+		alloc_init_pud(mm, pgd, addr, next, phys, prot);
 		phys += next - addr;
 	} while (pgd++, addr = next, addr != end);
 }
@@ -276,7 +268,7 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 	__create_mapping(&init_mm, pgd_offset_k(virt & PAGE_MASK), phys, virt,
-			 size, 0);
+			 size, PAGE_KERNEL_EXEC);
 }
 
 void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
@@ -286,7 +278,16 @@ void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
 		return;
 	}
 	__create_mapping(&init_mm, &idmap_pg_dir[pgd_index(addr)],
-			 addr, addr, size, map_io);
+			 addr, addr, size,
+			 map_io ? __pgprot(PROT_DEVICE_nGnRE)
+				: PAGE_KERNEL_EXEC);
+}
+
+void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
+			       unsigned long virt, phys_addr_t size,
+			       pgprot_t prot)
+{
+	__create_mapping(mm, pgd_offset(mm, virt), phys, virt, size, prot);
 }
 
 static void __init map_mem(void)
-- 
1.8.3.2
