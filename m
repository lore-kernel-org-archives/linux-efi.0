From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] arm*: efi: drop writable mapping of the UEFI System table
Date: Fri, 26 Feb 2016 15:20:35 +0100
Message-ID: <1456496435-12679-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1456496435-12679-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456496435-12679-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit 2eec5dedf770 ("efi/arm-init: Use read-only early mappings")
updated the early ARM UEFI init code to create the temporary, early
mapping of the UEFI System table using read-only attributes, as a
hardening measure against inadvertent modification.

However, this still leaves the permanent, writable mapping of the UEFI
System table, which is only ever referenced during invocations of UEFI
Runtime Services, at which time the UEFI virtual mapping is available,
which also covers the system table. (This is guaranteed by the fact that
SetVirtualAddressMap(), which is a runtime service itself, converts
various entries in the table to their virtual equivalents, which implies
that the table must be covered by a RuntimeServicesData region that has
the EFI_MEMORY_RUNTIME attribute.)

So instead of creating this permanent mapping, record the virtual address
of the system table inside the UEFI virtual mapping, and dereference that
when accessing the table. This protects the contents of the system table
from inadvertent (or deliberate) modification when no UEFI Runtime
Services calls are in progress.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/arm-init.c    |  2 ++
 drivers/firmware/efi/arm-runtime.c | 27 ++++++++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 9e15d571b53c..415ddfc213a7 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -85,6 +85,8 @@ static int __init uefi_init(void)
 			efi.systab->hdr.revision >> 16,
 			efi.systab->hdr.revision & 0xffff);
 
+	efi.runtime_version = efi.systab->hdr.revision;
+
 	/* Show what we know for posterity */
 	c16 = early_memremap(efi_to_phys(efi.systab->fw_vendor),
 			     sizeof(vendor) * sizeof(efi_char16_t));
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 16c7d2a71156..6c97d4884fc7 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -42,10 +42,12 @@ static struct mm_struct efi_mm = {
 static bool __init efi_virtmap_init(void)
 {
 	efi_memory_desc_t *md;
+	bool systab_found;
 
 	efi_mm.pgd = pgd_alloc(&efi_mm);
 	init_new_context(NULL, &efi_mm);
 
+	systab_found = false;
 	for_each_efi_memory_desc(&memmap, md) {
 		phys_addr_t phys = md->phys_addr;
 		int ret;
@@ -64,8 +66,20 @@ static bool __init efi_virtmap_init(void)
 				&phys, ret);
 			return false;
 		}
+		/*
+		 * If this entry covers the address of the UEFI system table,
+		 * calculate and record its virtual address.
+		 */
+		if (efi_system_table >= phys &&
+		    efi_system_table < phys + (md->num_pages * EFI_PAGE_SIZE)) {
+			efi.systab = (void *)(efi_system_table - phys +
+					      md->virt_addr);
+			systab_found = true;
+		}
 	}
-	return true;
+	if (!systab_found)
+		pr_err("No virtual mapping found for the UEFI System Table\n");
+	return systab_found;
 }
 
 /*
@@ -99,15 +113,8 @@ static int __init arm_enable_runtime_services(void)
 	memmap.map_end = memmap.map + mapsize;
 	efi.memmap = &memmap;
 
-	efi.systab = (__force void *)ioremap_cache(efi_system_table,
-						   sizeof(efi_system_table_t));
-	if (!efi.systab) {
-		pr_err("Failed to remap EFI System Table\n");
-		return -ENOMEM;
-	}
-
 	if (!efi_virtmap_init()) {
-		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
+		pr_err("UEFI virtual mapping missing or invalid -- runtime services will not be available\n");
 		return -ENOMEM;
 	}
 
@@ -115,8 +122,6 @@ static int __init arm_enable_runtime_services(void)
 	efi_native_runtime_setup();
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
-	efi.runtime_version = efi.systab->hdr.revision;
-
 	return 0;
 }
 early_initcall(arm_enable_runtime_services);
-- 
2.5.0
