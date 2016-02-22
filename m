From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] arm*: efi: drop permanent mapping of the UEFI System table
Date: Mon, 22 Feb 2016 15:59:39 +0100
Message-ID: <1456153179-27214-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The permanent, writable mapping of the UEFI System table is only
referenced during invocations of UEFI Runtime Services, at which time
the UEFI virtual mapping is available, which also covers the system
table (since the runtime services themselves need access to it)

So instead of creating this permanent mapping, record the virtual
address of the system table inside the UEFI virtual mapping, and
use that instead. This protects the contents of the system table
from inadvertent (or deliberate) modification.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

Something I spotted while working on the memory attribute table stuff.
Since this is low hanging fruit and otherwise completely unrelated to it,
I am posting it as a separate patch

 drivers/firmware/efi/arm-init.c    |  2 ++
 drivers/firmware/efi/arm-runtime.c | 24 ++++++++++----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 022f11157acd..e995d61da747 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -85,6 +85,8 @@ static int __init uefi_init(void)
 			efi.systab->hdr.revision >> 16,
 			efi.systab->hdr.revision & 0xffff);
 
+	efi.runtime_version = efi.systab->hdr.revision;
+
 	/* Show what we know for posterity */
 	c16 = early_memremap_ro(efi_to_phys(efi.systab->fw_vendor),
 				sizeof(vendor) * sizeof(efi_char16_t));
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 848ede1587dc..6ce13d6b7122 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -64,6 +64,16 @@ static bool __init efi_virtmap_init(void)
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
+			set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+		}
 	}
 
 	if (efi_memattr_apply_permissions(&efi_mm, efi_set_mapping_permissions))
@@ -102,16 +112,8 @@ static int __init arm_enable_runtime_services(void)
 	memmap.map_end = memmap.map + mapsize;
 	efi.memmap = &memmap;
 
-	efi.systab = (__force void *)ioremap_cache(efi_system_table,
-						   sizeof(efi_system_table_t));
-	if (!efi.systab) {
-		pr_err("Failed to remap EFI System Table\n");
-		return -ENOMEM;
-	}
-	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
-
-	if (!efi_virtmap_init()) {
-		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
+	if (!efi_virtmap_init() || !efi_enabled(EFI_SYSTEM_TABLES)) {
+		pr_err("UEFI virtual mapping missing or invalid -- runtime services will not be available\n");
 		return -ENOMEM;
 	}
 
@@ -119,8 +121,6 @@ static int __init arm_enable_runtime_services(void)
 	efi_native_runtime_setup();
 	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
-	efi.runtime_version = efi.systab->hdr.revision;
-
 	return 0;
 }
 early_initcall(arm_enable_runtime_services);
-- 
2.5.0
