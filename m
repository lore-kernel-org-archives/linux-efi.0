From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 03/11] x86/mm/pageattr: Make __lookup_address_in_pgd() global
Date: Wed, 29 Jan 2014 16:23:49 +0000
Message-ID: <1391012637-4839-4-git-send-email-matt@console-pimps.org>
References: <1391012637-4839-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391012637-4839-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Now that we have EFI-specific page tables we need to lookup the pgd when
dumping those page tables, rather than assuming that swapper_pgdir is
the current pgdir.

Remove the double underscore prefix, which is usually reserved for
static functions.

Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/include/asm/pgtable_types.h |  2 ++
 arch/x86/mm/fault.c                  |  7 ++++++-
 arch/x86/mm/pageattr.c               | 12 ++++++++----
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 765a4f52d6cd..4384c560499e 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -381,6 +381,8 @@ static inline void update_page_count(int level, unsigned long pages) { }
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
+extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+				    unsigned int *level);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags);
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9d591c895803..b8d278f66095 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -584,8 +584,13 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 	if (error_code & PF_INSTR) {
 		unsigned int level;
+		pgd_t *pgd;
+		pte_t *pte;
 
-		pte_t *pte = lookup_address(address, &level);
+		pgd = __va(read_cr3() & PHYSICAL_PAGE_MASK);
+		pgd += pgd_index(address);
+
+		pte = lookup_address_in_pgd(pgd, address, &level);
 
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
 			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index a3488689e301..1585da3b9b85 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -323,8 +323,12 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	return prot;
 }
 
-static pte_t *__lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
-				      unsigned int *level)
+/*
+ * Lookup the page table entry for a virtual address in a specific pgd.
+ * Return a pointer to the entry and the level of the mapping.
+ */
+pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+			     unsigned int *level)
 {
 	pud_t *pud;
 	pmd_t *pmd;
@@ -365,7 +369,7 @@ static pte_t *__lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
  */
 pte_t *lookup_address(unsigned long address, unsigned int *level)
 {
-        return __lookup_address_in_pgd(pgd_offset_k(address), address, level);
+        return lookup_address_in_pgd(pgd_offset_k(address), address, level);
 }
 EXPORT_SYMBOL_GPL(lookup_address);
 
@@ -373,7 +377,7 @@ static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
 				  unsigned int *level)
 {
         if (cpa->pgd)
-		return __lookup_address_in_pgd(cpa->pgd + pgd_index(address),
+		return lookup_address_in_pgd(cpa->pgd + pgd_index(address),
 					       address, level);
 
         return lookup_address(address, level);
-- 
1.8.3.1
