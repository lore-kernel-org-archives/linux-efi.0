From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 3/6] x86/efi: Map RAM into the identity page table for mixed mode
Date: Mon, 23 Nov 2015 13:33:11 +0000
Message-ID: <1448285594-17617-4-git-send-email-matt@codeblueprint.co.uk>
References: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448285594-17617-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

We are relying on the pre-existing mappings in 'trampoline_pgd' when
accessing function arguments in the EFI mixed mode thunking code.

Instead let's map memory explicitly so that things will continue to
work when we move to a separate page table in the future.

Reviewed-by: Borislav Petkov <bp@suse.de>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi_64.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 4fb0ba21d168..be1eeae668e7 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -144,6 +144,7 @@ void efi_sync_low_kernel_mappings(void)
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	unsigned long pfn, text;
+	efi_memory_desc_t *md;
 	struct page *page;
 	unsigned npages;
 	pgd_t *pgd;
@@ -177,6 +178,25 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	if (!IS_ENABLED(CONFIG_EFI_MIXED))
 		return 0;
 
+	/*
+	 * Map all of RAM so that we can access arguments in the 1:1
+	 * mapping when making EFI runtime calls.
+	 */
+	for_each_efi_memory_desc(&memmap, md) {
+		if (md->type != EFI_CONVENTIONAL_MEMORY &&
+		    md->type != EFI_LOADER_DATA &&
+		    md->type != EFI_LOADER_CODE)
+			continue;
+
+		pfn = md->phys_addr >> PAGE_SHIFT;
+		npages = md->num_pages;
+
+		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, npages, 0)) {
+			pr_err("Failed to map 1:1 memory\n");
+			return 1;
+		}
+	}
+
 	page = alloc_page(GFP_KERNEL|__GFP_DMA32);
 	if (!page)
 		panic("Unable to allocate EFI runtime stack < 4GB\n");
-- 
2.6.2
