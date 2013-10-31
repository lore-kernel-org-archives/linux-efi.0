From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 06/11] x86, pageattr: Add a PTE pagetable populating function
Date: Thu, 31 Oct 2013 17:25:04 +0100
Message-ID: <1383236709-19716-7-git-send-email-bp@alien8.de>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383236709-19716-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Handle last level by unconditionally writing the PTEs into the PTE page
while paying attention to the NX bit.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/mm/pageattr.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 968398b023c0..2a1308a8c072 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -686,7 +686,27 @@ static int alloc_pmd_page(pud_t *pud)
 	return 0;
 }
 
-#define populate_pte(cpa, start, end, pages, pmd, pgprot)	do {} while (0)
+static void populate_pte(struct cpa_data *cpa,
+			 unsigned long start, unsigned long end,
+			 unsigned num_pages, pmd_t *pmd, pgprot_t pgprot)
+{
+	pte_t *pte;
+
+	pte = pte_offset_kernel(pmd, start);
+
+	while (num_pages-- && start < end) {
+
+		/* deal with the NX bit */
+		if (!(pgprot_val(pgprot) & _PAGE_NX))
+			cpa->pfn &= ~_PAGE_NX;
+
+		set_pte(pte, pfn_pte(cpa->pfn >> PAGE_SHIFT, pgprot));
+
+		start	 += PAGE_SIZE;
+		cpa->pfn += PAGE_SIZE;
+		pte++;
+	}
+}
 
 static int populate_pmd(struct cpa_data *cpa,
 			unsigned long start, unsigned long end,
-- 
1.8.4
