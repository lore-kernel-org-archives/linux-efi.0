From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/9] ARM: factor out allocation routine from __create_mapping()
Date: Thu,  1 Oct 2015 19:04:20 +0200
Message-ID: <1443719063-6832-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443719063-6832-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

To allow __create_mapping() to be used for populating UEFI Runtime
Services page tables, factor out the allocation routine 'early_alloc'
and pass it down as a function pointer into alloc_init_[pud|pmd|pte].
This way, new users of __create_mapping() can supply another allocation
function.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/mm/mmu.c | 34 +++++++++++++-------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 3930bad44a61..dd0967ee23b7 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -723,21 +723,30 @@ static void __init *early_alloc(unsigned long sz)
 	return early_alloc_aligned(sz, sz);
 }
 
-static pte_t * __init early_pte_alloc(pmd_t *pmd, unsigned long addr, unsigned long prot)
+static pte_t * __init pte_alloc(pmd_t *pmd, unsigned long addr,
+				unsigned long prot,
+				void *(*alloc)(unsigned long sz))
 {
 	if (pmd_none(*pmd)) {
-		pte_t *pte = early_alloc(PTE_HWTABLE_OFF + PTE_HWTABLE_SIZE);
+		pte_t *pte = alloc(PTE_HWTABLE_OFF + PTE_HWTABLE_SIZE);
 		__pmd_populate(pmd, __pa(pte), prot);
 	}
 	BUG_ON(pmd_bad(*pmd));
 	return pte_offset_kernel(pmd, addr);
 }
 
+static pte_t * __init early_pte_alloc(pmd_t *pmd, unsigned long addr,
+				      unsigned long prot)
+{
+	return pte_alloc(pmd, addr, prot, early_alloc);
+}
+
 static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
 				  unsigned long end, unsigned long pfn,
-				  const struct mem_type *type)
+				  const struct mem_type *type,
+				  void *(*alloc)(unsigned long sz))
 {
-	pte_t *pte = early_pte_alloc(pmd, addr, type->prot_l1);
+	pte_t *pte = pte_alloc(pmd, addr, type->prot_l1, alloc);
 	do {
 		set_pte_ext(pte, pfn_pte(pfn, __pgprot(type->prot_pte)), 0);
 		pfn++;
@@ -773,7 +782,8 @@ static void __init __map_init_section(pmd_t *pmd, unsigned long addr,
 
 static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 				      unsigned long end, phys_addr_t phys,
-				      const struct mem_type *type)
+				      const struct mem_type *type,
+				      void *(*alloc)(unsigned long sz))
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	unsigned long next;
@@ -794,7 +804,7 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 			__map_init_section(pmd, addr, next, phys, type);
 		} else {
 			alloc_init_pte(pmd, addr, next,
-						__phys_to_pfn(phys), type);
+				       __phys_to_pfn(phys), type, alloc);
 		}
 
 		phys += next - addr;
@@ -804,14 +814,15 @@ static void __init alloc_init_pmd(pud_t *pud, unsigned long addr,
 
 static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
 				  unsigned long end, phys_addr_t phys,
-				  const struct mem_type *type)
+				  const struct mem_type *type,
+				  void *(*alloc)(unsigned long sz))
 {
 	pud_t *pud = pud_offset(pgd, addr);
 	unsigned long next;
 
 	do {
 		next = pud_addr_end(addr, end);
-		alloc_init_pmd(pud, addr, next, phys, type);
+		alloc_init_pmd(pud, addr, next, phys, type, alloc);
 		phys += next - addr;
 	} while (pud++, addr = next, addr != end);
 }
@@ -876,7 +887,8 @@ static void __init create_36bit_mapping(struct mm_struct *mm,
 }
 #endif	/* !CONFIG_ARM_LPAE */
 
-static void __init __create_mapping(struct mm_struct *mm, struct map_desc *md)
+static void __init __create_mapping(struct mm_struct *mm, struct map_desc *md,
+				    void *(*alloc)(unsigned long sz))
 {
 	unsigned long addr, length, end;
 	phys_addr_t phys;
@@ -910,7 +922,7 @@ static void __init __create_mapping(struct mm_struct *mm, struct map_desc *md)
 	do {
 		unsigned long next = pgd_addr_end(addr, end);
 
-		alloc_init_pud(pgd, addr, next, phys, type);
+		alloc_init_pud(pgd, addr, next, phys, type, alloc);
 
 		phys += next - addr;
 		addr = next;
@@ -939,7 +951,7 @@ static void __init create_mapping(struct map_desc *md)
 			(long long)__pfn_to_phys((u64)md->pfn), md->virtual);
 	}
 
-	__create_mapping(&init_mm, md);
+	__create_mapping(&init_mm, md, early_alloc);
 }
 
 /*
-- 
1.9.1
