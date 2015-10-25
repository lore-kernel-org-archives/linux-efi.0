From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is enabled
Date: Sun, 25 Oct 2015 10:49:04 +0000
Message-ID: <1445770144-22280-2-git-send-email-matt@codeblueprint.co.uk>
References: <1445770144-22280-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445770144-22280-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Ricardo Neri <ricardo.neri@intel.com>, Glenn P Williamson <glenn.p.williamson@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

When CONFIG_DEBUG_VIRTUAL is enabled, all accesses to __pa(address) are
monitored to see whether address falls in direct mapping or kernel text
mapping (see Documentation/x86/x86_64/mm.txt for details), if it does
not, the kernel panics. During 1:1 mapping of EFI runtime services we access
virtual addresses which are == physical addresses, thus the 1:1 mapping
and these addresses do not fall in either of the above two regions and
hence when passed as arguments to __pa() kernel panics as reported by
Dave Hansen here https://lkml.kernel.org/r/5462999A.7090706@intel.com.

So, before calling __pa() virtual addresses should be validated which
results in skipping call to split_page_count() and that should be fine
because it is used to keep track of everything *but* 1:1 mappings.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Reported-by: Dave Hansen <dave.hansen@intel.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Glenn P Williamson <glenn.p.williamson@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/mm/pageattr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 727158cb3b3c..9abe0c9b1098 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -648,9 +648,12 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
 		set_pte(&pbase[i], pfn_pte(pfn, canon_pgprot(ref_prot)));
 
-	if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
-				PFN_DOWN(__pa(address)) + 1))
-		split_page_count(level);
+	if (virt_addr_valid(address)) {
+		unsigned long pfn = PFN_DOWN(__pa(address));
+
+		if (pfn_range_is_mapped(pfn, pfn + 1))
+			split_page_count(level);
+	}
 
 	/*
 	 * Install the new, split up pagetable.
-- 
2.6.0
