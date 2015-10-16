From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2] x86/efi: Fix kernel panic when CONFIG_DEBUG_VIRTUAL is enabled
Date: Fri, 16 Oct 2015 16:20:27 -0700
Message-ID: <1445037627-6488-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Glenn P Williamson <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When CONFIG_DEBUG_VIRTUAL is enabled, all accesses to __pa(address) are
monitored to see whether address falls in direct mapping or kernel text
mapping (see Documentation/x86/x86_64/mm.txt for details), if it does
not kernel panics. During 1:1 mapping of EFI runtime services we access
virtual addresses which are == physical addresses, thus the 1:1 mapping
and these addresses donot fall in either of the above two regions and
hence when passed as arguments to __pa() kernel panics as reported by
Dave Hansen here https://lkml.kernel.org/r/5462999A.7090706-ral2JQCrhuFfmgfxC/sS/w@public.gmane.org
So, before calling __pa() virtual addresses should be validated which
results in skipping call to split_page_count() and that should be fine
because it is used to keep track of everything *but* 1:1 mappings.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reported-by: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Glenn P Williamson <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Changes since v1:
Made commit message more clear by adding reference to
Documentation/x86/x86_64/mm.txt, instead of addresses "below 4G"
changed it to "virtual addresses == physical addresses" quoted
mail with k.org redirector and changed last line "to keep track of
evrything *but* 1:1 mappings." Also made code more readable by adding a
variable.
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
2.1.4
