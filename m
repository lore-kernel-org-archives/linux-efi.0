From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 09/10] arm64/efi: ignore unusable regions instead of reserving them
Date: Thu,  6 Nov 2014 15:13:25 +0100
Message-ID: <1415283206-14713-10-git-send-email-ard.biesheuvel@linaro.org>
References: <1415283206-14713-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415283206-14713-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This changes the way memblocks are installed based on the contents of
the UEFI memory map. Formerly, all regions would be memblock_add()'ed,
after which unusable regions would be memblock_reserve()'d as well.
To simplify things, but also to allow access to the unusable regions
through mmap(/dev/mem), even with CONFIG_STRICT_DEVMEM set, change
this so that only usable regions are memblock_add()'ed in the first
place.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 69 +++++++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 3009c22e2620..af2214c692d3 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -40,13 +40,6 @@ static int __init uefi_debug_setup(char *str)
 }
 early_param("uefi_debug", uefi_debug_setup);
 
-static int __init is_normal_ram(efi_memory_desc_t *md)
-{
-	if (md->attribute & EFI_MEMORY_WB)
-		return 1;
-	return 0;
-}
-
 static int __init uefi_init(void)
 {
 	efi_char16_t *c16;
@@ -105,28 +98,11 @@ out:
 	return retval;
 }
 
-/*
- * Return true for RAM regions we want to permanently reserve.
- */
-static __init int is_reserve_region(efi_memory_desc_t *md)
-{
-	switch (md->type) {
-	case EFI_LOADER_CODE:
-	case EFI_LOADER_DATA:
-	case EFI_BOOT_SERVICES_CODE:
-	case EFI_BOOT_SERVICES_DATA:
-	case EFI_CONVENTIONAL_MEMORY:
-		return 0;
-	default:
-		break;
-	}
-	return is_normal_ram(md);
-}
-
-static __init void reserve_regions(void)
+static __init void process_memory_map(void)
 {
 	efi_memory_desc_t *md;
 	u64 paddr, npages, size;
+	u32 lost = 0;
 
 	if (uefi_debug)
 		pr_info("Processing EFI memory map:\n");
@@ -134,31 +110,38 @@ static __init void reserve_regions(void)
 	for_each_efi_memory_desc(&memmap, md) {
 		paddr = md->phys_addr;
 		npages = md->num_pages;
+		size = npages << EFI_PAGE_SHIFT;
 
 		if (uefi_debug) {
 			char buf[64];
 
-			pr_info("  0x%012llx-0x%012llx %s",
-				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
+			pr_info("  0x%012llx-0x%012llx %s\n",
+				paddr, paddr + size - 1,
 				efi_md_typeattr_format(buf, sizeof(buf), md));
 		}
 
-		memrange_efi_to_native(&paddr, &npages);
-		size = npages << PAGE_SHIFT;
-
-		if (is_normal_ram(md))
-			early_init_dt_add_memory_arch(paddr, size);
-
-		if (is_reserve_region(md)) {
-			memblock_reserve(paddr, size);
-			if (uefi_debug)
-				pr_cont("*");
-		}
-
-		if (uefi_debug)
-			pr_cont("\n");
+		if (!efi_mem_is_usable_region(md))
+			continue;
+
+		early_init_dt_add_memory_arch(paddr, size);
+
+		/*
+		 * Keep a tally of how much memory we are losing due to
+		 * rounding of regions that are not aligned to the page
+		 * size. We cannot easily recover this memory without
+		 * sorting the memory map and attempting to merge adjacent
+		 * usable regions.
+		 */
+		if (PAGE_SHIFT != EFI_PAGE_SHIFT)
+			lost += (npages << EFI_PAGE_SHIFT) -
+				round_down(max_t(s64, size - PAGE_ALIGN(paddr) +
+						 md->phys_addr, 0),
+					   PAGE_SIZE);
 	}
 
+	if (lost > SZ_1K)
+		pr_warn("efi: lost %u KB of RAM to rounding\n", lost / SZ_1K);
+
 	set_bit(EFI_MEMMAP, &efi.flags);
 }
 
@@ -182,7 +165,7 @@ void __init efi_init(void)
 
 	WARN_ON(uefi_init() < 0);
 
-	reserve_regions();
+	process_memory_map();
 }
 
 static int __init arm64_enter_virtual_mode(void)
-- 
1.8.3.2
