From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH] x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is enabled
Date: Tue, 13 Oct 2015 12:42:57 -0700
Message-ID: <1444765377-29303-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: matt.fleming@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org, Sai Praneeth <sai.praneeth.prakhya@intel.com>, Ricardo Neri <ricardo.neri@intel.com>, Glenn P Williamson <glenn.p.williamson@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

When CONFIG_DEBUG_VIRTUAL is turned on, all accesses to __pa(address)
are monitored to see whether address falls in direct mapping or kernel
mapping, if it does not kernel panics. During 1:1 mapping of EFI runtime
services we access addresses which are below 4G and hence when passed as
arguments to __pa() kernel panics as reported by Dave Hansen here
https://lkml.org/lkml/2015/1/27/742. So, before calling __pa() virtual
addresses should be validated which results in skipping call to
split_page_count() and that should be fine because it is used to keep
track of direct kernel mappings and not 1:1 mappings.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Reported-by: Dave Hansen <dave.hansen@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Glenn P Williamson <glenn.p.williamson@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
---
 arch/x86/mm/pageattr.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 727158cb3b3c..3a603830503a 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -648,9 +648,11 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
 		set_pte(&pbase[i], pfn_pte(pfn, canon_pgprot(ref_prot)));
 
-	if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
-				PFN_DOWN(__pa(address)) + 1))
-		split_page_count(level);
+	if (virt_addr_valid(address)) {
+		if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),
+					PFN_DOWN(__pa(address)) + 1))
+			split_page_count(level);
+	}
 
 	/*
 	 * Install the new, split up pagetable.
-- 
2.1.4
