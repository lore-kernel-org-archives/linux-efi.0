From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 02/11] x86/efi: Consolidate region mapping logic
Date: Thu, 23 Jun 2016 12:34:41 +0100
Message-ID: <1466681690-5850-3-git-send-email-matt@codeblueprint.co.uk>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

EFI regions are currently mapped in two separate places. The bulk of
the work is done in efi_map_regions() but when CONFIG_EFI_MIXED is
enabled the additional regions that are required when operating in
mixed mode are mapping in efi_setup_page_tables().

Pull everything into efi_map_regions() and refactor the test for
which regions should be mapped into a should_map_region() function.
Generously sprinkle comments to clarify the different cases.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi.c    | 50 ++++++++++++++++++++++++++++++++++++------
 arch/x86/platform/efi/efi_64.c | 20 -----------------
 2 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f93545e7dc54..7c3d9092c668 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -761,6 +761,46 @@ static void *efi_map_next_entry(void *entry)
 	return entry;
 }
 
+static bool should_map_region(efi_memory_desc_t *md)
+{
+	/*
+	 * Runtime regions always require runtime mappings (obviously).
+	 */
+	if (md->attribute & EFI_MEMORY_RUNTIME)
+		return true;
+
+	/*
+	 * 32-bit EFI doesn't suffer from the bug that requires us to
+	 * reserve boot services regions, and mixed mode support
+	 * doesn't exist for 32-bit kernels.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32))
+		return false;
+
+	/*
+	 * Map all of RAM so that we can access arguments in the 1:1
+	 * mapping when making EFI runtime calls.
+	 */
+	if (IS_ENABLED(CONFIG_EFI_MIXED) && !efi_is_native()) {
+		if (md->type == EFI_CONVENTIONAL_MEMORY ||
+		    md->type == EFI_LOADER_DATA ||
+		    md->type == EFI_LOADER_CODE)
+			return true;
+	}
+
+	/*
+	 * Map boot services regions as a workaround for buggy
+	 * firmware that accesses them even when they shouldn't.
+	 *
+	 * See efi_{reserve,free}_boot_services().
+	 */
+	if (md->type == EFI_BOOT_SERVICES_CODE ||
+	    md->type == EFI_BOOT_SERVICES_DATA)
+		return true;
+
+	return false;
+}
+
 /*
  * Map the efi memory ranges of the runtime services and update new_mmap with
  * virtual addresses.
@@ -777,13 +817,9 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
 	p = NULL;
 	while ((p = efi_map_next_entry(p))) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
-#ifdef CONFIG_X86_64
-			if (md->type != EFI_BOOT_SERVICES_CODE &&
-			    md->type != EFI_BOOT_SERVICES_DATA)
-#endif
-				continue;
-		}
+
+		if (!should_map_region(md))
+			continue;
 
 		efi_map_region(md);
 		get_systab_virt_addr(md);
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6e7242be1c87..3fcdfc93991e 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -213,7 +213,6 @@ void efi_sync_low_kernel_mappings(void)
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	unsigned long pfn, text;
-	efi_memory_desc_t *md;
 	struct page *page;
 	unsigned npages;
 	pgd_t *pgd;
@@ -247,25 +246,6 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	if (!IS_ENABLED(CONFIG_EFI_MIXED))
 		return 0;
 
-	/*
-	 * Map all of RAM so that we can access arguments in the 1:1
-	 * mapping when making EFI runtime calls.
-	 */
-	for_each_efi_memory_desc(md) {
-		if (md->type != EFI_CONVENTIONAL_MEMORY &&
-		    md->type != EFI_LOADER_DATA &&
-		    md->type != EFI_LOADER_CODE)
-			continue;
-
-		pfn = md->phys_addr >> PAGE_SHIFT;
-		npages = md->num_pages;
-
-		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, npages, _PAGE_RW)) {
-			pr_err("Failed to map 1:1 memory\n");
-			return 1;
-		}
-	}
-
 	page = alloc_page(GFP_KERNEL|__GFP_DMA32);
 	if (!page)
 		panic("Unable to allocate EFI runtime stack < 4GB\n");
-- 
2.7.3
