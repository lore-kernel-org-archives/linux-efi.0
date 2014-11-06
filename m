From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 01/10] arm64/mm: add explicit struct_mm argument to __create_mapping()
Date: Thu,  6 Nov 2014 15:13:17 +0100
Message-ID: <1415283206-14713-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1415283206-14713-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415283206-14713-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Currently, swapper_pg_dir and idmap_pg_dir share the init_mm mm_struct
instance. To allow the introduction of other pg_dir instances, for instance,
for UEFI's mapping of Runtime Services, make the struct_mm instance an
explicit argument that gets passed down to the pmd and pte instantiation
functions. Note that the consumers (pmd_populate/pgd_populate) of the
mm_struct argument don't actually inspect it, but let's fix it for
correctness' sake.

Acked-by: Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/mm/mmu.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0bf90d26e745..83e6713143a3 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -155,9 +155,9 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
-static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
-				  unsigned long end, phys_addr_t phys,
-				  int map_io)
+static void __init alloc_init_pmd(struct mm_struct *mm, pud_t *pud,
+				  unsigned long addr, unsigned long end,
+				  phys_addr_t phys, int map_io)
 {
 	pmd_t *pmd;
 	unsigned long next;
@@ -177,7 +177,7 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 	 */
 	if (pud_none(*pud) || pud_bad(*pud)) {
 		pmd = early_alloc(PTRS_PER_PMD * sizeof(pmd_t));
-		pud_populate(&init_mm, pud, pmd);
+		pud_populate(mm, pud, pmd);
 	}
 
 	pmd = pmd_offset(pud, addr);
@@ -201,16 +201,16 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 	} while (pmd++, addr = next, addr != end);
 }
 
-static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
-				  unsigned long end, unsigned long phys,
-				  int map_io)
+static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
+				  unsigned long addr, unsigned long end,
+				  unsigned long phys, int map_io)
 {
 	pud_t *pud;
 	unsigned long next;
 
 	if (pgd_none(*pgd)) {
 		pud = early_alloc(PTRS_PER_PUD * sizeof(pud_t));
-		pgd_populate(&init_mm, pgd, pud);
+		pgd_populate(mm, pgd, pud);
 	}
 	BUG_ON(pgd_bad(*pgd));
 
@@ -239,7 +239,7 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
 				flush_tlb_all();
 			}
 		} else {
-			alloc_init_pmd(pud, addr, next, phys, map_io);
+			alloc_init_pmd(mm, pud, addr, next, phys, map_io);
 		}
 		phys += next - addr;
 	} while (pud++, addr = next, addr != end);
@@ -249,9 +249,9 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
  * Create the page directory entries and any necessary page tables for the
  * mapping specified by 'md'.
  */
-static void __init __create_mapping(pgd_t *pgd, phys_addr_t phys,
-				    unsigned long virt, phys_addr_t size,
-				    int map_io)
+static void __init __create_mapping(struct mm_struct *mm, pgd_t *pgd,
+				    phys_addr_t phys, unsigned long virt,
+				    phys_addr_t size, int map_io)
 {
 	unsigned long addr, length, end, next;
 
@@ -261,7 +261,7 @@ static void __init __create_mapping(pgd_t *pgd, phys_addr_t phys,
 	end = addr + length;
 	do {
 		next = pgd_addr_end(addr, end);
-		alloc_init_pud(pgd, addr, next, phys, map_io);
+		alloc_init_pud(mm, pgd, addr, next, phys, map_io);
 		phys += next - addr;
 	} while (pgd++, addr = next, addr != end);
 }
@@ -274,7 +274,8 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	__create_mapping(pgd_offset_k(virt & PAGE_MASK), phys, virt, size, 0);
+	__create_mapping(&init_mm, pgd_offset_k(virt & PAGE_MASK), phys, virt,
+			 size, 0);
 }
 
 void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
@@ -283,7 +284,7 @@ void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
 		pr_warn("BUG: not creating id mapping for %pa\n", &addr);
 		return;
 	}
-	__create_mapping(&idmap_pg_dir[pgd_index(addr)],
+	__create_mapping(&init_mm, &idmap_pg_dir[pgd_index(addr)],
 			 addr, addr, size, map_io);
 }
 
-- 
1.8.3.2
