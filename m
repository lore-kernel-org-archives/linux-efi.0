From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] efi/arm64: fix fdt-related memory reservation
Date: Mon,  8 Sep 2014 13:01:08 -0400
Message-ID: <1410195668-9975-1-git-send-email-msalter@redhat.com>
References: <1410183102-6969-1-git-send-email-msalter@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410183102-6969-1-git-send-email-msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit 86c8b27a01cf:
 "arm64: ignore DT memreserve entries when booting in UEFI mode

prevents early_init_fdt_scan_reserved_mem() from being called for
arm64 kernels booting via UEFI. This was done because the kernel
will use the UEFI memory map to determine reserved memory regions.
That approach has problems in that early_init_fdt_scan_reserved_mem()
also reserves the FDT itself and any node-specific reserved memory.
By chance of some kernel configs, the FDT may be overwritten before
it can be unflattened and the kernel will fail to boot. More subtle
problems will result if the FDT has node specific reserved memory
which is not really reserved.

This patch has the UEFI stub remove the memory reserve map entries
from the FDT as it does with the memory nodes. This allows
early_init_fdt_scan_reserved_mem() to be called unconditionally
so that the other needed reservations are made.

Change from v1:
  * Acks added
  * Fixed loop logic to remove reserved regions

Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm64/mm/init.c               |  3 +--
 drivers/firmware/efi/libstub/fdt.c | 10 +++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 5472c24..a83061f 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -149,8 +149,7 @@ void __init arm64_memblock_init(void)
 		memblock_reserve(__virt_to_phys(initrd_start), initrd_end - initrd_start);
 #endif
 
-	if (!efi_enabled(EFI_MEMMAP))
-		early_init_fdt_scan_reserved_mem();
+	early_init_fdt_scan_reserved_mem();
 
 	/* 4GB maximum for 32-bit only capable devices */
 	if (IS_ENABLED(CONFIG_ZONE_DMA))
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a56bb35..c846a96 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -22,7 +22,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 			unsigned long map_size, unsigned long desc_size,
 			u32 desc_ver)
 {
-	int node, prev;
+	int node, prev, num_rsv;
 	int status;
 	u32 fdt_val32;
 	u64 fdt_val64;
@@ -73,6 +73,14 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		prev = node;
 	}
 
+	/*
+	 * Delete all memory reserve map entries. When booting via UEFI,
+	 * kernel will use the UEFI memory map to find reserved regions.
+	 */
+	num_rsv = fdt_num_mem_rsv(fdt);
+	while (num_rsv-- > 0)
+		fdt_del_mem_rsv(fdt, num_rsv);
+
 	node = fdt_subnode_offset(fdt, 0, "chosen");
 	if (node < 0) {
 		node = fdt_add_subnode(fdt, 0, "chosen");
-- 
1.8.3.1
