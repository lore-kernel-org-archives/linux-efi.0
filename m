From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 05/11] x86, pageattr: Add a PUD pagetable populating function
Date: Thu, 19 Sep 2013 16:54:48 +0200
Message-ID: <1379602494-26684-6-git-send-email-bp@alien8.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379602494-26684-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Add the next level of the pagetable populating function, we handle
chunks around a 1G boundary by mapping them with the lower level
functions - otherwise we use 1G pages for the mappings, thus using as
less amount of pagetable pages as possible.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/mm/pageattr.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 21a31e85283c..41c6fdbbfab0 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -666,7 +666,92 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	return 0;
 }
 
-#define populate_pud(cpa, addr, pgd, pgprot)	(-1)
+static int alloc_pmd_page(pud_t *pud)
+{
+	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+	if (!pmd)
+		return -1;
+
+	set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	return 0;
+}
+
+#define populate_pmd(cpa, start, end, pages, pud, pgprot)	(-1)
+
+static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
+			pgprot_t pgprot)
+{
+	pud_t *pud;
+	unsigned long end;
+	int cur_pages = 0;
+
+	end = start + (cpa->numpages << PAGE_SHIFT);
+
+	/*
+	 * Not on a Gb page boundary? => map everything up to it with
+	 * smaller pages.
+	 */
+	if (start & (PUD_SIZE - 1)) {
+		unsigned long pre_end;
+		unsigned long next_page = (start + PUD_SIZE) & PUD_MASK;
+
+		pre_end   = min_t(unsigned long, end, next_page);
+		cur_pages = (pre_end - start) >> PAGE_SHIFT;
+		cur_pages = min_t(int, (int)cpa->numpages, cur_pages);
+
+		pud = pud_offset(pgd, start);
+
+		/*
+		 * Need a PMD page?
+		 */
+		if (pud_none(*pud))
+			if (alloc_pmd_page(pud))
+				return -1;
+
+		cur_pages = populate_pmd(cpa, start, pre_end, cur_pages,
+					 pud, pgprot);
+		if (cur_pages < 0)
+			return cur_pages;
+
+		start = pre_end;
+	}
+
+	/* We mapped them all? */
+	if (cpa->numpages == cur_pages)
+		return cur_pages;
+
+	pud = pud_offset(pgd, start);
+
+	/*
+	 * Map everything starting from the Gb boundary, possibly with 1G pages
+	 */
+	while (end - start >= PUD_SIZE) {
+		set_pud(pud, __pud(cpa->pfn | _PAGE_PSE | massage_pgprot(pgprot)));
+
+		start	  += PUD_SIZE;
+		cpa->pfn  += PUD_SIZE;
+		cur_pages += PUD_SIZE >> PAGE_SHIFT;
+		pud++;
+	}
+
+	/* Map trailing leftover */
+	if (start < end) {
+		int tmp;
+
+		pud = pud_offset(pgd, start);
+		if (pud_none(*pud))
+			if (alloc_pmd_page(pud))
+				return -1;
+
+		tmp = populate_pmd(cpa, start, end, cpa->numpages - cur_pages,
+				   pud, pgprot);
+		if (tmp < 0)
+			return cur_pages;
+
+		cur_pages += tmp;
+	}
+	return cur_pages;
+}
 
 /*
  * Restrictions for kernel page table do not necessarily apply when mapping in
-- 
1.8.4
