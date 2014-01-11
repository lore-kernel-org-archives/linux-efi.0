From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 3/4] x86, pageattr: Export page unmapping interface
Date: Sat, 11 Jan 2014 21:49:29 +0100
Message-ID: <1389473370-1940-4-git-send-email-bp@alien8.de>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389473370-1940-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

We will use it in efi so expose it.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/include/asm/pgtable_types.h |  2 ++
 arch/x86/mm/pageattr.c               | 44 +++++++++++++++++++++++++-----------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index a83aa44bb1fb..765a4f52d6cd 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -384,6 +384,8 @@ extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags);
+void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
+			       unsigned numpages);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b3b19f46c016..a3488689e301 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -692,6 +692,18 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 	return true;
 }
 
+static bool try_to_free_pud_page(pud_t *pud)
+{
+	int i;
+
+	for (i = 0; i < PTRS_PER_PUD; i++)
+		if (!pud_none(pud[i]))
+			return false;
+
+	free_page((unsigned long)pud);
+	return true;
+}
+
 static bool unmap_pte_range(pmd_t *pmd, unsigned long start, unsigned long end)
 {
 	pte_t *pte = pte_offset_kernel(pmd, start);
@@ -805,6 +817,16 @@ static void unmap_pud_range(pgd_t *pgd, unsigned long start, unsigned long end)
 	 */
 }
 
+static void unmap_pgd_range(pgd_t *root, unsigned long addr, unsigned long end)
+{
+	pgd_t *pgd_entry = root + pgd_index(addr);
+
+	unmap_pud_range(pgd_entry, addr, end);
+
+	if (try_to_free_pud_page((pud_t *)pgd_page_vaddr(*pgd_entry)))
+		pgd_clear(pgd_entry);
+}
+
 static int alloc_pte_page(pmd_t *pmd)
 {
 	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
@@ -999,9 +1021,8 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 {
 	pgprot_t pgprot = __pgprot(_KERNPG_TABLE);
-	bool allocd_pgd = false;
-	pgd_t *pgd_entry;
 	pud_t *pud = NULL;	/* shut up gcc */
+	pgd_t *pgd_entry;
 	int ret;
 
 	pgd_entry = cpa->pgd + pgd_index(addr);
@@ -1015,7 +1036,6 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 			return -1;
 
 		set_pgd(pgd_entry, __pgd(__pa(pud) | _KERNPG_TABLE));
-		allocd_pgd = true;
 	}
 
 	pgprot_val(pgprot) &= ~pgprot_val(cpa->mask_clr);
@@ -1023,19 +1043,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 
 	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
 	if (ret < 0) {
-		unmap_pud_range(pgd_entry, addr,
+		unmap_pgd_range(cpa->pgd, addr,
 				addr + (cpa->numpages << PAGE_SHIFT));
-
-		if (allocd_pgd) {
-			/*
-			 * If I allocated this PUD page, I can just as well
-			 * free it in this error path.
-			 */
-			pgd_clear(pgd_entry);
-			free_page((unsigned long)pud);
-		}
 		return ret;
 	}
+
 	cpa->numpages = ret;
 	return 0;
 }
@@ -1861,6 +1873,12 @@ out:
 	return retval;
 }
 
+void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
+			       unsigned numpages)
+{
+	unmap_pgd_range(root, address, address + (numpages << PAGE_SHIFT));
+}
+
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
-- 
1.8.5.2.192.g7794a68
