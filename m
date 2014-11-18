From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 11/13] arm64/efi: use plain memblock API for adding and removing reserved RAM
Date: Tue, 18 Nov 2014 13:57:10 +0100
Message-ID: <1416315432-8534-12-git-send-email-ard.biesheuvel@linaro.org>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416315432-8534-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The memblock API is agnostic of page size, so we can use it on both
4 KB and 64 KB granule kernels to install all UEFI memory regions
(EFI_MEMORY_WB) using memblock_add(), and the memblock layer will stitch
all unaligned regions together. Then we start punching holes in it for the
reserved regions, this time taking the native page size into account.

Finally, the reserved regions are memblock_remove()'d as well. This will
ensure that the regions are accessible via mmap(/dev/mem), even when
CONFIG_STRICT_DEVMEM is in effect.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c        | 41 +++++++++--------------------------------
 drivers/firmware/efi/virtmap.c | 15 +++++++++------
 2 files changed, 18 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 3009c22e2620..2c0a858f699e 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -105,24 +105,6 @@ out:
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
 static __init void reserve_regions(void)
 {
 	efi_memory_desc_t *md;
@@ -134,31 +116,26 @@ static __init void reserve_regions(void)
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
+		if (is_normal_ram(md)) {
+			memblock_add(paddr, size);
 
-		if (is_normal_ram(md))
-			early_init_dt_add_memory_arch(paddr, size);
-
-		if (is_reserve_region(md)) {
-			memblock_reserve(paddr, size);
-			if (uefi_debug)
-				pr_cont("*");
+			if (!efi_mem_is_usable_region(md)) {
+				memrange_efi_to_native(&paddr, &npages);
+				memblock_reserve(paddr, npages << PAGE_SHIFT);
+			}
 		}
 
-		if (uefi_debug)
-			pr_cont("\n");
 	}
-
 	set_bit(EFI_MEMMAP, &efi.flags);
 }
 
diff --git a/drivers/firmware/efi/virtmap.c b/drivers/firmware/efi/virtmap.c
index 98735fb43581..4b6a5c31629f 100644
--- a/drivers/firmware/efi/virtmap.c
+++ b/drivers/firmware/efi/virtmap.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/efi.h>
+#include <linux/memblock.h>
 #include <linux/mm_types.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
@@ -97,8 +98,15 @@ void __init efi_virtmap_init(void)
 		u64 paddr, npages, size;
 		pgprot_t prot;
 
-		if (!efi_mem_is_usable_region(md))
+		paddr = md->phys_addr;
+		npages = md->num_pages;
+		memrange_efi_to_native(&paddr, &npages);
+		size = npages << PAGE_SHIFT;
+
+		if (!efi_mem_is_usable_region(md)) {
 			efi_register_mem_resource(md);
+			memblock_remove(paddr, size);
+		}
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 		if (WARN(md->virt_addr == 0,
@@ -106,11 +114,6 @@ void __init efi_virtmap_init(void)
 			 md->phys_addr))
 			return;
 
-		paddr = md->phys_addr;
-		npages = md->num_pages;
-		memrange_efi_to_native(&paddr, &npages);
-		size = npages << PAGE_SHIFT;
-
 		pr_info("  EFI remap 0x%012llx => %p\n",
 			md->phys_addr, (void *)md->virt_addr);
 
-- 
1.8.3.2
