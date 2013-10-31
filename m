From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 07/11] x86, pageattr: Add a PUD error unwinding path
Date: Thu, 31 Oct 2013 17:25:05 +0100
Message-ID: <1383236709-19716-8-git-send-email-bp@alien8.de>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383236709-19716-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

In case we encounter an error during the mapping of a region, we want to
unwind what we've established so far exactly the way we did the mapping.
This is the PUD part kept deliberately small for easier review.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/mm/pageattr.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 2a1308a8c072..1cbdbbc35b47 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -666,6 +666,51 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	return 0;
 }
 
+#define unmap_pmd_range(pud, start, pre_end)		do {} while (0)
+
+static void unmap_pud_range(pgd_t *pgd, unsigned long start, unsigned long end)
+{
+	pud_t *pud = pud_offset(pgd, start);
+
+	/*
+	 * Not on a GB page boundary?
+	 */
+	if (start & (PUD_SIZE - 1)) {
+		unsigned long next_page = (start + PUD_SIZE) & PUD_MASK;
+		unsigned long pre_end	= min_t(unsigned long, end, next_page);
+
+		unmap_pmd_range(pud, start, pre_end);
+
+		start = pre_end;
+		pud++;
+	}
+
+	/*
+	 * Try to unmap in 1G chunks?
+	 */
+	while (end - start >= PUD_SIZE) {
+
+		if (pud_large(*pud))
+			pud_clear(pud);
+		else
+			unmap_pmd_range(pud, start, start + PUD_SIZE);
+
+		start += PUD_SIZE;
+		pud++;
+	}
+
+	/*
+	 * 2M leftovers?
+	 */
+	if (start < end)
+		unmap_pmd_range(pud, start, end);
+
+	/*
+	 * No need to try to free the PUD page because we'll free it in
+	 * populate_pgd's error path
+	 */
+}
+
 static int alloc_pte_page(pmd_t *pmd)
 {
 	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
@@ -883,9 +928,20 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 	pgprot_val(pgprot) |=  pgprot_val(cpa->mask_set);
 
 	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		unmap_pud_range(pgd_entry, addr,
+				addr + (cpa->numpages << PAGE_SHIFT));
 
+		if (allocd_pgd) {
+			/*
+			 * If I allocated this PUD page, I can just as well
+			 * free it in this error path.
+			 */
+			pgd_clear(pgd_entry);
+			free_page((unsigned long)pud);
+		}
+		return ret;
+	}
 	cpa->numpages = ret;
 	return 0;
 }
-- 
1.8.4
