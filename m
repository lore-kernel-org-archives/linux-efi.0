From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 6/6] arm64/efi: ignore DT memreserve entries instead of removing them
Date: Mon, 21 Sep 2015 17:21:28 -0700
Message-ID: <1442881288-13962-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1442881288-13962-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442881288-13962-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now that the reservation of the FDT image itself is split off from
the processing of memory reservations described by the device tree,
we can make the DT scanning of memreserves conditional on whether
we booted via UEFI and have its memory map available. This allows
us to drop deletion of these memreserves in the stub. It also fixes
the issue where the /reserved-memory node (which offers another
way of reserving memory ranges) was not being ignored under UEFI.

Note that this reverts 0ceac9e094b0 ("efi/arm64: Fix fdt-related
memory reservation").

Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/mm/init.c               |  3 ++-
 drivers/firmware/efi/libstub/fdt.c | 11 +----------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index d8ce7f51dba1..c74ff920540a 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -170,7 +170,8 @@ void __init arm64_memblock_init(void)
 		memblock_reserve(__virt_to_phys(initrd_start), initrd_end - initrd_start);
 #endif
 
-	early_init_fdt_scan_reserved_mem();
+	if (!efi_enabled(EFI_MEMMAP))
+		early_init_fdt_scan_reserved_mem();
 
 	/* 4GB maximum for 32-bit only capable devices */
 	if (IS_ENABLED(CONFIG_ZONE_DMA))
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 343e7992bd8f..a7e87cd582f2 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -24,8 +24,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 			unsigned long map_size, unsigned long desc_size,
 			u32 desc_ver)
 {
-	int node, num_rsv;
-	int status;
+	int node, status;
 	u32 fdt_val32;
 	u64 fdt_val64;
 
@@ -53,14 +52,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	if (status != 0)
 		goto fdt_set_fail;
 
-	/*
-	 * Delete all memory reserve map entries. When booting via UEFI,
-	 * kernel will use the UEFI memory map to find reserved regions.
-	 */
-	num_rsv = fdt_num_mem_rsv(fdt);
-	while (num_rsv-- > 0)
-		fdt_del_mem_rsv(fdt, num_rsv);
-
 	node = fdt_subnode_offset(fdt, 0, "chosen");
 	if (node < 0) {
 		node = fdt_add_subnode(fdt, 0, "chosen");
-- 
1.9.1
