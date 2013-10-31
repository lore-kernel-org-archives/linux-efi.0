From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 03/11] x86, pageattr: Add a PGD pagetable populating function
Date: Thu, 31 Oct 2013 17:25:01 +0100
Message-ID: <1383236709-19716-4-git-send-email-bp@alien8.de>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383236709-19716-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

This allocates, if necessary, and populates the corresponding PGD entry
with a PUD page. The next population level is a dummy macro which will
be removed by the next patch and it is added here to keep the patch
small and easily reviewable but not break bisection, at the same time.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/mm/pageattr.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index c53de62a1170..4b47ae0602e1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -666,6 +666,45 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	return 0;
 }
 
+#define populate_pud(cpa, addr, pgd, pgprot)	(-1)
+
+/*
+ * Restrictions for kernel page table do not necessarily apply when mapping in
+ * an alternate PGD.
+ */
+static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
+{
+	pgprot_t pgprot = __pgprot(_KERNPG_TABLE);
+	bool allocd_pgd = false;
+	pgd_t *pgd_entry;
+	pud_t *pud = NULL;	/* shut up gcc */
+	int ret;
+
+	pgd_entry = cpa->pgd + pgd_index(addr);
+
+	/*
+	 * Allocate a PUD page and hand it down for mapping.
+	 */
+	if (pgd_none(*pgd_entry)) {
+		pud = (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+		if (!pud)
+			return -1;
+
+		set_pgd(pgd_entry, __pgd(__pa(pud) | _KERNPG_TABLE));
+		allocd_pgd = true;
+	}
+
+	pgprot_val(pgprot) &= ~pgprot_val(cpa->mask_clr);
+	pgprot_val(pgprot) |=  pgprot_val(cpa->mask_set);
+
+	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
+	if (ret < 0)
+		return ret;
+
+	cpa->numpages = ret;
+	return 0;
+}
+
 static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 			       int primary)
 {
-- 
1.8.4
