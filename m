From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] efi: arm64: treat regions with WT/WC set but WB cleared as memory
Date: Thu, 25 Aug 2016 18:17:09 +0200
Message-ID: <1472141829-12026-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Currently, memory regions are only recorded in the memblock memory table
if they have the EFI_MEMORY_WB memory type attribute set. In case the
region is of a reserved type, it is also marked as MEMBLOCK_NOMAP, which
will leave it out of the linear mapping.

However, memory regions may legally have the EFI_MEMORY_WT or EFI_MEMORY_WC
attributes set, and the EFI_MEMORY_WB cleared, in which case the region in
question is obviously backed by normal memory, but is not recorded in the
memblock memory table at all. Since it would be useful to be able to
identify any UEFI reported memory region using memblock_is_memory(), it
makes sense to add all memory to the memblock memory table, and simply mark
it as MEMBLOCK_NOMAP if it lacks the EFI_MEMORY_WB attribute.

While implementing this, let's refactor the code slightly to make it easier
to understand: replace is_normal_ram() with is_memory(), and make it return
true for each region that has any of the WB|WT|WC bits set. (This follows
the AArch64 bindings in the UEFI spec, which state that those are the
attributes that map to normal memory)

Also, replace is_reserve_region() with is_usable_memory(), and only invoke
it if the region in question was identified as memory by is_memory() in the
first place. The net result is the same (only reserved regions that are
backed by memory end up in the memblock memory table with the MEMBLOCK_NOMAP
flag set) but carried out in a more straightforward way.

Finally, we remove the trailing asterisk in the EFI debug output. Keeping it
clutters the code, and it serves no real purpose now that we no longer
temporarily reserve BootServices code and data regions like we did in the
early days of EFI support on arm64 Linux (which it inherited from the x86
implementation)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
v2: refactor is_normal_ram and is_reserve_region
    drop trailing asterisk in EFI debug output

 drivers/firmware/efi/arm-init.c | 32 +++++++++++---------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index c49d50e68aee..c2ac5975fd5d 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -26,9 +26,9 @@
 
 u64 efi_system_table;
 
-static int __init is_normal_ram(efi_memory_desc_t *md)
+static int __init is_memory(efi_memory_desc_t *md)
 {
-	if (md->attribute & EFI_MEMORY_WB)
+	if (md->attribute & (EFI_MEMORY_WB|EFI_MEMORY_WT|EFI_MEMORY_WC))
 		return 1;
 	return 0;
 }
@@ -152,9 +152,9 @@ out:
 }
 
 /*
- * Return true for RAM regions we want to permanently reserve.
+ * Return true for regions that can be used as System RAM.
  */
-static __init int is_reserve_region(efi_memory_desc_t *md)
+static __init int is_usable_memory(efi_memory_desc_t *md)
 {
 	switch (md->type) {
 	case EFI_LOADER_CODE:
@@ -163,18 +163,22 @@ static __init int is_reserve_region(efi_memory_desc_t *md)
 	case EFI_BOOT_SERVICES_DATA:
 	case EFI_CONVENTIONAL_MEMORY:
 	case EFI_PERSISTENT_MEMORY:
-		return 0;
+		/*
+		 * According to the spec, these regions are no longer reserved
+		 * after calling ExitBootServices(). However, we can only use
+		 * them as System RAM if they can be mapped writeback cacheable.
+		 */
+		return (md->attribute & EFI_MEMORY_WB);
 	default:
 		break;
 	}
-	return is_normal_ram(md);
+	return false;
 }
 
 static __init void reserve_regions(void)
 {
 	efi_memory_desc_t *md;
 	u64 paddr, npages, size;
-	int resv;
 
 	if (efi_enabled(EFI_DBG))
 		pr_info("Processing EFI memory map:\n");
@@ -191,25 +195,23 @@ static __init void reserve_regions(void)
 		paddr = md->phys_addr;
 		npages = md->num_pages;
 
-		resv = is_reserve_region(md);
 		if (efi_enabled(EFI_DBG)) {
 			char buf[64];
 
-			pr_info("  0x%012llx-0x%012llx %s%s\n",
+			pr_info("  0x%012llx-0x%012llx %s\n",
 				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
-				efi_md_typeattr_format(buf, sizeof(buf), md),
-				resv ? "*" : "");
+				efi_md_typeattr_format(buf, sizeof(buf), md));
 		}
 
 		memrange_efi_to_native(&paddr, &npages);
 		size = npages << PAGE_SHIFT;
 
-		if (is_normal_ram(md))
+		if (is_memory(md)) {
 			early_init_dt_add_memory_arch(paddr, size);
 
-		if (resv)
-			memblock_mark_nomap(paddr, size);
-
+			if (!is_usable_memory(md))
+				memblock_mark_nomap(paddr, size);
+		}
 	}
 
 	set_bit(EFI_MEMMAP, &efi.flags);
-- 
2.7.4
