From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/6] arm64/efi: remove free_boot_services() and friends
Date: Fri, 24 Oct 2014 14:39:43 +0200
Message-ID: <1414154384-15385-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1414154384-15385-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414154384-15385-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now that we are calling SetVirtualAddressMap() from the stub, there is no
need to reserve boot-only memory regions, which implies that there is also
no reason to free them again later.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 123 +-----------------------------------------------
 1 file changed, 1 insertion(+), 122 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 324398c03acd..cbff3e8eff11 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -202,9 +202,7 @@ static __init void reserve_regions(void)
 		if (is_normal_ram(md))
 			early_init_dt_add_memory_arch(paddr, size);
 
-		if (is_reserve_region(md) ||
-		    md->type == EFI_BOOT_SERVICES_CODE ||
-		    md->type == EFI_BOOT_SERVICES_DATA) {
+		if (is_reserve_region(md)) {
 			memblock_reserve(paddr, size);
 			if (uefi_debug)
 				pr_cont("*");
@@ -217,123 +215,6 @@ static __init void reserve_regions(void)
 	set_bit(EFI_MEMMAP, &efi.flags);
 }
 
-
-static u64 __init free_one_region(u64 start, u64 end)
-{
-	u64 size = end - start;
-
-	if (uefi_debug)
-		pr_info("  EFI freeing: 0x%012llx-0x%012llx\n",	start, end - 1);
-
-	free_bootmem_late(start, size);
-	return size;
-}
-
-static u64 __init free_region(u64 start, u64 end)
-{
-	u64 map_start, map_end, total = 0;
-
-	if (end <= start)
-		return total;
-
-	map_start = (u64)memmap.phys_map;
-	map_end = PAGE_ALIGN(map_start + (memmap.map_end - memmap.map));
-	map_start &= PAGE_MASK;
-
-	if (start < map_end && end > map_start) {
-		/* region overlaps UEFI memmap */
-		if (start < map_start)
-			total += free_one_region(start, map_start);
-
-		if (map_end < end)
-			total += free_one_region(map_end, end);
-	} else
-		total += free_one_region(start, end);
-
-	return total;
-}
-
-static void __init free_boot_services(void)
-{
-	u64 total_freed = 0;
-	u64 keep_end, free_start, free_end;
-	efi_memory_desc_t *md;
-
-	/*
-	 * If kernel uses larger pages than UEFI, we have to be careful
-	 * not to inadvertantly free memory we want to keep if there is
-	 * overlap at the kernel page size alignment. We do not want to
-	 * free is_reserve_region() memory nor the UEFI memmap itself.
-	 *
-	 * The memory map is sorted, so we keep track of the end of
-	 * any previous region we want to keep, remember any region
-	 * we want to free and defer freeing it until we encounter
-	 * the next region we want to keep. This way, before freeing
-	 * it, we can clip it as needed to avoid freeing memory we
-	 * want to keep for UEFI.
-	 */
-
-	keep_end = 0;
-	free_start = 0;
-
-	for_each_efi_memory_desc(&memmap, md) {
-		u64 paddr, npages, size;
-
-		if (is_reserve_region(md)) {
-			/*
-			 * We don't want to free any memory from this region.
-			 */
-			if (free_start) {
-				/* adjust free_end then free region */
-				if (free_end > md->phys_addr)
-					free_end -= PAGE_SIZE;
-				total_freed += free_region(free_start, free_end);
-				free_start = 0;
-			}
-			keep_end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
-			continue;
-		}
-
-		if (md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA) {
-			/* no need to free this region */
-			continue;
-		}
-
-		/*
-		 * We want to free memory from this region.
-		 */
-		paddr = md->phys_addr;
-		npages = md->num_pages;
-		memrange_efi_to_native(&paddr, &npages);
-		size = npages << PAGE_SHIFT;
-
-		if (free_start) {
-			if (paddr <= free_end)
-				free_end = paddr + size;
-			else {
-				total_freed += free_region(free_start, free_end);
-				free_start = paddr;
-				free_end = paddr + size;
-			}
-		} else {
-			free_start = paddr;
-			free_end = paddr + size;
-		}
-		if (free_start < keep_end) {
-			free_start += PAGE_SIZE;
-			if (free_start >= free_end)
-				free_start = 0;
-		}
-	}
-	if (free_start)
-		total_freed += free_region(free_start, free_end);
-
-	if (total_freed)
-		pr_info("Freed 0x%llx bytes of EFI boot services memory",
-			total_freed);
-}
-
 void __init efi_init(void)
 {
 	struct efi_fdt_params params;
@@ -443,8 +324,6 @@ static int __init arm64_enter_virtual_mode(void)
 	}
 	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
-	free_boot_services();
-
 	if (!efi_enabled(EFI_VIRTMAP)) {
 		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
 		return -1;
-- 
1.8.3.2
