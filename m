From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] x86/mm/pageattr: Use _PAGE_GLOBAL bit for EFI page table mappings
Date: Wed, 27 Jan 2016 10:34:56 -0800
Message-ID: <1453919696-13096-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Since EFI page tables can be treated as kernel page tables they should
be global. All the other page mapping functions in pageattr.c set the
_PAGE_GLOBAL bit and we want to avoid inconsistencies when we map a page
in the EFI code paths, for example when that page is split in
__split_large_page(), etc. It also makes it easier to validate that the
EFI region mappings have the correct attributes because there are fewer
differences compared with regular kernel mappings.

Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/mm/pageattr.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 3052e72fa9f5..9256f6406a3c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -904,6 +904,20 @@ static void populate_pte(struct cpa_data *cpa,
 
 	pte = pte_offset_kernel(pmd, start);
 
+	/*
+	 * Set the GLOBAL flags only if the PRESENT flag is
+	 * set otherwise pte_present will return true even on
+	 * a non present pte. The canon_pgprot will clear
+	 * _PAGE_GLOBAL for the ancient hardware that doesn't
+	 * support it.
+	 */
+	if (pgprot_val(pgprot) & _PAGE_PRESENT)
+		pgprot_val(pgprot) |= _PAGE_GLOBAL;
+	else
+		pgprot_val(pgprot) &= ~_PAGE_GLOBAL;
+
+	pgprot = canon_pgprot(pgprot);
+
 	while (num_pages-- && start < end) {
 		set_pte(pte, pfn_pte(cpa->pfn, pgprot));
 
-- 
2.1.4
