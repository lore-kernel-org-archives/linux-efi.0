From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 2/6] x86/mm/pageattr: Do not strip pte flags from cpa->pfn
Date: Thu, 12 Nov 2015 15:40:19 +0000
Message-ID: <1447342823-3612-3-git-send-email-matt@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

Removing the PAGE_NX bit from cpa->pfn will corrupt the page frame
number address rather than removing PAGE_NX as the code intends. This
is unlikley to be a problem in practice because _PAGE_BIT_NX is bit 63
and most machines do not have page frame numbers that reach that high.

Still, pte flags are never stored in cpa->pfn so we can safely delete
the code.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/mm/pageattr.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 893921b12272..d5240be55915 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -885,11 +885,6 @@ static void populate_pte(struct cpa_data *cpa,
 	pte = pte_offset_kernel(pmd, start);
 
 	while (num_pages-- && start < end) {
-
-		/* deal with the NX bit */
-		if (!(pgprot_val(pgprot) & _PAGE_NX))
-			cpa->pfn &= ~_PAGE_NX;
-
 		set_pte(pte, pfn_pte(cpa->pfn, pgprot));
 
 		start	 += PAGE_SIZE;
-- 
2.6.2
