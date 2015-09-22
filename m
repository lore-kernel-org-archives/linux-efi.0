From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 5/6] arm64/efi: ignore DT memory nodes instead of removing them
Date: Mon, 21 Sep 2015 17:21:27 -0700
Message-ID: <1442881288-13962-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1442881288-13962-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442881288-13962-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There are two problems with the UEFI stub DT memory node removal
routine:
- it deletes nodes as it traverses the tree, which happens to work
  but is not supported, as deletion invalidates the node iterator;
- deleting memory nodes entirely may discard annotations in the form
  of additional properties on the nodes.

Now that the UEFI initialization has moved to an earlier stage, we can
actually just ignore any memblocks that are installed after we have
processed the UEFI memory map. This way, it is no longer necessary to
remove the nodes, so we can remove that logic from the stub as well.

Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c            |  2 +-
 arch/arm64/mm/init.c               |  6 ++++-
 drivers/firmware/efi/libstub/fdt.c | 24 +-------------------
 3 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index a9e63122e32d..1baa75a0df20 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -181,7 +181,7 @@ static __init void reserve_regions(void)
 		size = npages << PAGE_SHIFT;
 
 		if (is_normal_ram(md))
-			early_init_dt_add_memory_arch(paddr, size);
+			early_init_dt_add_memory(paddr, size);
 
 		if (is_reserve_region(md)) {
 			memblock_reserve(paddr, size);
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index d88e83ebf60d..d8ce7f51dba1 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -377,5 +377,9 @@ __setup("keepinitrd", keepinitrd_setup);
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
-	early_init_dt_add_memory(base, size);
+	/*
+	 * Ignore DT memory nodes if we are booting via UEFI.
+	 */
+	if (!efi_enabled(EFI_MEMMAP))
+		early_init_dt_add_memory(base, size);
 }
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index ef5d764e2a27..343e7992bd8f 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -24,7 +24,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 			unsigned long map_size, unsigned long desc_size,
 			u32 desc_ver)
 {
-	int node, prev, num_rsv;
+	int node, num_rsv;
 	int status;
 	u32 fdt_val32;
 	u64 fdt_val64;
@@ -54,28 +54,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		goto fdt_set_fail;
 
 	/*
-	 * Delete any memory nodes present. We must delete nodes which
-	 * early_init_dt_scan_memory may try to use.
-	 */
-	prev = 0;
-	for (;;) {
-		const char *type;
-		int len;
-
-		node = fdt_next_node(fdt, prev, NULL);
-		if (node < 0)
-			break;
-
-		type = fdt_getprop(fdt, node, "device_type", &len);
-		if (type && strncmp(type, "memory", len) == 0) {
-			fdt_del_node(fdt, node);
-			continue;
-		}
-
-		prev = node;
-	}
-
-	/*
 	 * Delete all memory reserve map entries. When booting via UEFI,
 	 * kernel will use the UEFI memory map to find reserved regions.
 	 */
-- 
1.9.1
