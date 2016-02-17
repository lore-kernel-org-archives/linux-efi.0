From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 03/13] x86/mm/pageattr: Use _PAGE_GLOBAL bit for EFI page table mappings
Date: Wed, 17 Feb 2016 12:35:56 +0000
Message-ID: <1455712566-16727-4-git-send-email-matt@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Sai Praneeth <sai.praneeth.prakhya@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Borislav Petkov <bp@alien8.de>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Since EFI page tables can be treated as kernel page tables they should
be global. All the other page mapping functions in pageattr.c set the
_PAGE_GLOBAL bit and we want to avoid inconsistencies when we map a page
in the EFI code paths, for example when that page is split in
__split_large_page(), etc. It also makes it easier to validate that the
EFI region mappings have the correct attributes because there are fewer
differences compared with regular kernel mappings.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/mm/pageattr.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 632d34d20237..bf312da41a6d 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -909,6 +909,20 @@ static void populate_pte(struct cpa_data *cpa,
 
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
2.6.2
