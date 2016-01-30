From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] x86/mm/pageattr: Don't implicitly allow _PAGE_RW in kernel_map_pages_in_pgd()
Date: Fri, 29 Jan 2016 17:04:39 -0800
Message-ID: <1454115880-6914-2-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1454115880-6914-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454115880-6914-1-git-send-email-sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

As part of the preparation for the EFI_MEMORY_RO flag added in the UEFI
2.5 specification, we need the ability to map pages in kernel page
tables without _PAGE_RW being set.

Modify kernel_map_pages_in_pgd() to require its callers to pass _PAGE_RW
if the pages need to be mapped read/write. Otherwise, we'll map the
pages as read-only.

Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/mm/pageattr.c         | 3 +++
 arch/x86/platform/efi/efi_64.c | 8 ++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 63dd44979d56..9256f6406a3c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1966,6 +1966,9 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 	if (!(page_flags & _PAGE_NX))
 		cpa.mask_clr = __pgprot(_PAGE_NX);
 
+	if (!(page_flags & _PAGE_RW))
+		cpa.mask_clr = __pgprot(_PAGE_RW);
+
 	cpa.mask_set = __pgprot(_PAGE_PRESENT | page_flags);
 
 	retval = __change_page_attr_set_clr(&cpa, 0);
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 040fff163d96..a6277b79aa99 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -233,7 +233,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	 * phys_efi_set_virtual_address_map().
 	 */
 	pfn = pa_memmap >> PAGE_SHIFT;
-	if (kernel_map_pages_in_pgd(pgd, pfn, pa_memmap, num_pages, _PAGE_NX)) {
+	if (kernel_map_pages_in_pgd(pgd, pfn, pa_memmap, num_pages, _PAGE_NX | _PAGE_RW)) {
 		pr_err("Error ident-mapping new memmap (0x%lx)!\n", pa_memmap);
 		return 1;
 	}
@@ -262,7 +262,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 		pfn = md->phys_addr >> PAGE_SHIFT;
 		npages = md->num_pages;
 
-		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, npages, 0)) {
+		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, npages, _PAGE_RW)) {
 			pr_err("Failed to map 1:1 memory\n");
 			return 1;
 		}
@@ -279,7 +279,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	text = __pa(_text);
 	pfn = text >> PAGE_SHIFT;
 
-	if (kernel_map_pages_in_pgd(pgd, pfn, text, npages, 0)) {
+	if (kernel_map_pages_in_pgd(pgd, pfn, text, npages, _PAGE_RW)) {
 		pr_err("Failed to map kernel text 1:1\n");
 		return 1;
 	}
@@ -294,7 +294,7 @@ void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
 {
-	unsigned long flags = 0;
+	unsigned long flags = _PAGE_RW;
 	unsigned long pfn;
 	pgd_t *pgd = efi_pgd;
 
-- 
2.1.4
