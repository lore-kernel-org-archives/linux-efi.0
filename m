From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 2/4] x86, cpa: Map in an arbitrary pgd
Date: Sun,  2 Jun 2013 14:56:08 +0200
Message-ID: <1370177770-26661-3-git-send-email-bp@alien8.de>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370177770-26661-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Add the ability to map pages in an arbitrary pgd.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/include/asm/pgtable_types.h |  3 +-
 arch/x86/mm/pageattr.c               | 80 ++++++++++++++++++++++++++++--------
 2 files changed, 65 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index e6423002c10b..0613e147f083 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -352,7 +352,8 @@ static inline void update_page_count(int level, unsigned long pages) { }
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 extern phys_addr_t slow_virt_to_phys(void *__address);
-
+extern void kernel_map_pages_in_pgd(pgd_t *pgd, unsigned long address,
+				    unsigned numpages, unsigned long page_flags);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bb32480c2d71..3d64e5fc2adc 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -30,6 +30,7 @@
  */
 struct cpa_data {
 	unsigned long	*vaddr;
+	pgd_t		*pgd;
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
@@ -322,17 +323,9 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	return prot;
 }
 
-/*
- * Lookup the page table entry for a virtual address. Return a pointer
- * to the entry and the level of the mapping.
- *
- * Note: We return pud and pmd either when the entry is marked large
- * or when the present bit is not set. Otherwise we would return a
- * pointer to a nonexisting mapping.
- */
-pte_t *lookup_address(unsigned long address, unsigned int *level)
+static pte_t *
+__lookup_address_in_pgd(pgd_t *pgd, unsigned long address, unsigned int *level)
 {
-	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
 	pmd_t *pmd;
 
@@ -361,8 +354,30 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
 
 	return pte_offset_kernel(pmd, address);
 }
+
+/*
+ * Lookup the page table entry for a virtual address. Return a pointer
+ * to the entry and the level of the mapping.
+ *
+ * Note: We return pud and pmd either when the entry is marked large
+ * or when the present bit is not set. Otherwise we would return a
+ * pointer to a nonexisting mapping.
+ */
+pte_t *lookup_address(unsigned long address, unsigned int *level)
+{
+	return __lookup_address_in_pgd(pgd_offset_k(address), address, level);
+}
 EXPORT_SYMBOL_GPL(lookup_address);
 
+pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
+			  unsigned int *level)
+{
+	if (cpa->pgd)
+		return __lookup_address_in_pgd(cpa->pgd, address, level);
+
+	return lookup_address(address, level);
+}
+
 /*
  * This is necessary because __pa() does not work on some
  * kinds of memory, like vmalloc() or the alloc_remap()
@@ -437,7 +452,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * Check for races, another CPU might have split this page
 	 * up already:
 	 */
-	tmp = lookup_address(address, &level);
+	tmp = _lookup_address_cpa(cpa, address, &level);
 	if (tmp != kpte)
 		goto out_unlock;
 
@@ -543,7 +558,8 @@ out_unlock:
 }
 
 static int
-__split_large_page(pte_t *kpte, unsigned long address, struct page *base)
+__split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
+		   struct page *base)
 {
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned long pfn, pfninc = 1;
@@ -556,7 +572,7 @@ __split_large_page(pte_t *kpte, unsigned long address, struct page *base)
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
 	 */
-	tmp = lookup_address(address, &level);
+	tmp = _lookup_address_cpa(cpa, address, &level);
 	if (tmp != kpte) {
 		spin_unlock(&pgd_lock);
 		return 1;
@@ -632,7 +648,8 @@ __split_large_page(pte_t *kpte, unsigned long address, struct page *base)
 	return 0;
 }
 
-static int split_large_page(pte_t *kpte, unsigned long address)
+static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
+			    unsigned long address)
 {
 	struct page *base;
 
@@ -644,7 +661,7 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	if (!base)
 		return -ENOMEM;
 
-	if (__split_large_page(kpte, address, base))
+	if (__split_large_page(cpa, kpte, address, base))
 		__free_page(base);
 
 	return 0;
@@ -697,7 +714,10 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 	else
 		address = *cpa->vaddr;
 repeat:
-	kpte = lookup_address(address, &level);
+	if (cpa->pgd)
+		kpte = __lookup_address_in_pgd(cpa->pgd, address, &level);
+	else
+		kpte = _lookup_address_cpa(cpa, address, &level);
 	if (!kpte)
 		return __cpa_process_fault(cpa, address, primary);
 
@@ -761,7 +781,7 @@ repeat:
 	/*
 	 * We have to split the large page:
 	 */
-	err = split_large_page(kpte, address);
+	err = split_large_page(cpa, kpte, address);
 	if (!err) {
 		/*
 	 	 * Do a global flush tlb after splitting the large page
@@ -910,6 +930,8 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	int ret, cache, checkalias;
 	unsigned long baddr = 0;
 
+	memset(&cpa, 0, sizeof(cpa));
+
 	/*
 	 * Check, if we are requested to change a not supported
 	 * feature:
@@ -1434,6 +1456,30 @@ bool kernel_page_present(struct page *page)
 
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+void kernel_map_pages_in_pgd(pgd_t *pgd, unsigned long address,
+			     unsigned numpages, unsigned long page_flags)
+{
+	struct cpa_data cpa = {
+		.vaddr = &address,
+		.pgd = pgd,
+		.numpages = numpages,
+		.mask_set = __pgprot(0),
+		.mask_clr = __pgprot(0),
+		.flags = 0
+	};
+
+	if (!(__supported_pte_mask & _PAGE_NX))
+		return;
+
+	if (!(page_flags & _PAGE_NX))
+		cpa.mask_clr = __pgprot(_PAGE_NX);
+
+	cpa.mask_set = __pgprot(_PAGE_PRESENT | page_flags);
+
+	__change_page_attr_set_clr(&cpa, 0);
+	__flush_tlb_all();
+}
+
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
-- 
1.8.3.rc1.25.g423ecb0
