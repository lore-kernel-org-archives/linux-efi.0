From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH v2 1/5] x86/mm/pageattr: Ensure cpa->pfn only contains page frame numbers
Date: Sat, 14 Nov 2015 22:00:47 +0000
Message-ID: <1447538451-5793-2-git-send-email-matt@codeblueprint.co.uk>
References: <1447538451-5793-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447538451-5793-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The x86 pageattr code is confused about the data that is stored
cpa->pfn, sometimes it's treated as a page frame number, sometimes
it's treated as an unshifted physical address, and in one place it's
treated as a pte.

The result of this is that the mapping functions do not map the
intended physical address.

This isn't a problem in practice because most of the addresses we're
mapping in the EFI code paths are already mapped in 'trampoline_pgd'
and so the pageattr mappings functions don't actually do anything in
this case. But when we move to using a separate page table for the EFI
runtime this will be an issue.

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---

Changes in v2:
 - Folded the deletion of the _PAGE_NX code into this patch.

 arch/x86/mm/pageattr.c         | 17 ++++++-----------
 arch/x86/platform/efi/efi_64.c | 33 ++++++++++++++++++++++-----------
 2 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 9abe0c9b1098..d5240be55915 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -885,15 +885,10 @@ static void populate_pte(struct cpa_data *cpa,
 	pte = pte_offset_kernel(pmd, start);
 
 	while (num_pages-- && start < end) {
-
-		/* deal with the NX bit */
-		if (!(pgprot_val(pgprot) & _PAGE_NX))
-			cpa->pfn &= ~_PAGE_NX;
-
-		set_pte(pte, pfn_pte(cpa->pfn >> PAGE_SHIFT, pgprot));
+		set_pte(pte, pfn_pte(cpa->pfn, pgprot));
 
 		start	 += PAGE_SIZE;
-		cpa->pfn += PAGE_SIZE;
+		cpa->pfn++;
 		pte++;
 	}
 }
@@ -949,11 +944,11 @@ static int populate_pmd(struct cpa_data *cpa,
 
 		pmd = pmd_offset(pud, start);
 
-		set_pmd(pmd, __pmd(cpa->pfn | _PAGE_PSE |
+		set_pmd(pmd, __pmd(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
 				   massage_pgprot(pmd_pgprot)));
 
 		start	  += PMD_SIZE;
-		cpa->pfn  += PMD_SIZE;
+		cpa->pfn  += PMD_SIZE >> PAGE_SHIFT;
 		cur_pages += PMD_SIZE >> PAGE_SHIFT;
 	}
 
@@ -1022,11 +1017,11 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 	 * Map everything starting from the Gb boundary, possibly with 1G pages
 	 */
 	while (end - start >= PUD_SIZE) {
-		set_pud(pud, __pud(cpa->pfn | _PAGE_PSE |
+		set_pud(pud, __pud(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
 				   massage_pgprot(pud_pgprot)));
 
 		start	  += PUD_SIZE;
-		cpa->pfn  += PUD_SIZE;
+		cpa->pfn  += PUD_SIZE >> PAGE_SHIFT;
 		cur_pages += PUD_SIZE >> PAGE_SHIFT;
 		pud++;
 	}
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a0ac0f9c307f..c8b58ac47b77 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -143,7 +143,7 @@ void efi_sync_low_kernel_mappings(void)
 
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
-	unsigned long text;
+	unsigned long pfn, text;
 	struct page *page;
 	unsigned npages;
 	pgd_t *pgd;
@@ -160,7 +160,8 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	 * and ident-map those pages containing the map before calling
 	 * phys_efi_set_virtual_address_map().
 	 */
-	if (kernel_map_pages_in_pgd(pgd, pa_memmap, pa_memmap, num_pages, _PAGE_NX)) {
+	pfn = pa_memmap >> PAGE_SHIFT;
+	if (kernel_map_pages_in_pgd(pgd, pfn, pa_memmap, num_pages, _PAGE_NX)) {
 		pr_err("Error ident-mapping new memmap (0x%lx)!\n", pa_memmap);
 		return 1;
 	}
@@ -176,21 +177,29 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	if (!IS_ENABLED(CONFIG_EFI_MIXED))
 		return 0;
 
+	npages = (_end - _text) >> PAGE_SHIFT;
+	text = __pa(_text);
+	pfn = text >> PAGE_SHIFT;
+
+	if (kernel_map_pages_in_pgd(pgd, pfn, text, npages, 0)) {
+		pr_err("Failed to map kernel text 1:1\n");
+		return 1;
+	}
+
 	page = alloc_page(GFP_KERNEL|__GFP_DMA32);
 	if (!page)
 		panic("Unable to allocate EFI runtime stack < 4GB\n");
 
 	efi_scratch.phys_stack = virt_to_phys(page_address(page));
-	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
-
-	npages = (_end - _text) >> PAGE_SHIFT;
-	text = __pa(_text);
+	pfn = page_to_pfn(page);
 
-	if (kernel_map_pages_in_pgd(pgd, text >> PAGE_SHIFT, text, npages, 0)) {
-		pr_err("Failed to map kernel text 1:1\n");
+	if (kernel_map_pages_in_pgd(pgd, pfn, efi_scratch.phys_stack, 1, 0)) {
+		pr_err("Failed to map mixed mode stack\n");
 		return 1;
 	}
 
+	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
+
 	return 0;
 }
 
@@ -204,12 +213,14 @@ void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
-	unsigned long pf = 0;
+	unsigned long flags = 0;
+	unsigned long pfn;
 
 	if (!(md->attribute & EFI_MEMORY_WB))
-		pf |= _PAGE_PCD;
+		flags |= _PAGE_PCD;
 
-	if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
+	pfn = md->phys_addr >> PAGE_SHIFT;
+	if (kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags))
 		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
 			   md->phys_addr, va);
 }
-- 
2.6.2
