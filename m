From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH 3/3] arm64: mm: Remove split_p*d() functions
Date: Tue, 31 May 2016 16:14:32 +0100
Message-ID: <1464707672-21882-4-git-send-email-catalin.marinas@arm.com>
References: <1464707672-21882-1-git-send-email-catalin.marinas@arm.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464707672-21882-1-git-send-email-catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Since the efi_create_mapping() no longer generates overlapping regions
and being the last user of the split_p*d code, remove these functions
and the corresponding TLBI.

Signed-off-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm64/mm/mmu.c | 47 ++++-------------------------------------------
 1 file changed, 4 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index c31f796f33ac..00a9e3f64ea9 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -134,24 +134,6 @@ void __strict_break_before_make(pte_t old_pte, pte_t new_pte, const char *info)
 }
 #endif
 
-/*
- * remap a PMD into pages
- */
-static void split_pmd(pmd_t *pmd, pte_t *pte)
-{
-	unsigned long pfn = pmd_pfn(*pmd);
-	int i = 0;
-
-	do {
-		/*
-		 * Need to have the least restrictive permissions available
-		 * permissions will be fixed up later
-		 */
-		set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
-		pfn++;
-	} while (pte++, i++, i < PTRS_PER_PTE);
-}
-
 static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 				  unsigned long end, unsigned long pfn,
 				  pgprot_t prot,
@@ -159,15 +141,13 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 {
 	pte_t *pte;
 
-	if (pmd_none(*pmd) || pmd_sect(*pmd)) {
+	BUG_ON(pmd_sect(*pmd));
+	if (pmd_none(*pmd)) {
 		phys_addr_t pte_phys;
 		BUG_ON(!pgtable_alloc);
 		pte_phys = pgtable_alloc();
 		pte = pte_set_fixmap(pte_phys);
-		if (pmd_sect(*pmd))
-			split_pmd(pmd, pte);
 		__pmd_populate(pmd, pte_phys, PMD_TYPE_TABLE);
-		flush_tlb_all();
 		pte_clear_fixmap();
 	}
 	BUG_ON(pmd_bad(*pmd));
@@ -181,18 +161,6 @@ static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
 	pte_clear_fixmap();
 }
 
-static void split_pud(pud_t *old_pud, pmd_t *pmd)
-{
-	unsigned long addr = pud_pfn(*old_pud) << PAGE_SHIFT;
-	pgprot_t prot = __pgprot(pud_val(*old_pud) ^ addr);
-	int i = 0;
-
-	do {
-		set_pmd(pmd, __pmd(addr | pgprot_val(prot)));
-		addr += PMD_SIZE;
-	} while (pmd++, i++, i < PTRS_PER_PMD);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static bool block_mappings_allowed(phys_addr_t (*pgtable_alloc)(void))
 {
@@ -223,20 +191,13 @@ static void alloc_init_pmd(pud_t *pud, unsigned long addr, unsigned long end,
 	/*
 	 * Check for initial section mappings in the pgd/pud and remove them.
 	 */
-	if (pud_none(*pud) || pud_sect(*pud)) {
+	BUG_ON(pud_sect(*pud));
+	if (pud_none(*pud)) {
 		phys_addr_t pmd_phys;
 		BUG_ON(!pgtable_alloc);
 		pmd_phys = pgtable_alloc();
 		pmd = pmd_set_fixmap(pmd_phys);
-		if (pud_sect(*pud)) {
-			/*
-			 * need to have the 1G of mappings continue to be
-			 * present
-			 */
-			split_pud(pud, pmd);
-		}
 		__pud_populate(pud, pmd_phys, PUD_TYPE_TABLE);
-		flush_tlb_all();
 		pmd_clear_fixmap();
 	}
 	BUG_ON(pud_bad(*pud));
