From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 11/13] x86/mm/pageattr: Don't implicitly allow _PAGE_RW in kernel_map_pages_in_pgd()
Date: Wed, 17 Feb 2016 12:36:04 +0000
Message-ID: <1455712566-16727-12-git-send-email-matt@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Sai Praneeth <sai.praneeth.prakhya@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, "Lee, Chun-Yi" <jlee@suse.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

As part of the preparation for the EFI_MEMORY_RO flag added in the UEFI
2.5 specification, we need the ability to map pages in kernel page
tables without _PAGE_RW being set.

Modify kernel_map_pages_in_pgd() to require its callers to pass _PAGE_RW
if the pages need to be mapped read/write. Otherwise, we'll map the
pages as read-only.

Cc: Borislav Petkov <bp@alien8.de>
Cc: "Lee, Chun-Yi" <jlee@suse.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/mm/pageattr.c         | 3 +++
 arch/x86/platform/efi/efi_64.c | 8 ++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bf312da41a6d..14c38ae80409 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1971,6 +1971,9 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 	if (!(page_flags & _PAGE_NX))
 		cpa.mask_clr = __pgprot(_PAGE_NX);
 
+	if (!(page_flags & _PAGE_RW))
+		cpa.mask_clr = __pgprot(_PAGE_RW);
+
 	cpa.mask_set = __pgprot(_PAGE_PRESENT | page_flags);
 
 	retval = __change_page_attr_set_clr(&cpa, 0);
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index b492521503fe..b0965b27e47f 100644
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
2.6.2
