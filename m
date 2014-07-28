From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] arm64: ignore DT memreserve entries when booting in UEFI mode
Date: Mon, 28 Jul 2014 19:03:03 +0100
Message-ID: <1406570583-22848-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

UEFI provides its own method for marking regions to reserve, via the
memory map which is also used to initialise memblock. So when using the
UEFI memory map, ignore any memreserve entries present in the DT.

Reported-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c |    2 ++
 arch/arm64/mm/init.c    |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 14db1f6..7ad17b2 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -188,6 +188,8 @@ static __init void reserve_regions(void)
 		if (uefi_debug)
 			pr_cont("\n");
 	}
+
+	set_bit(EFI_MEMMAP, &efi.flags);
 }
 
 
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index e90c542..58dbf2e 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -32,6 +32,7 @@
 #include <linux/of_fdt.h>
 #include <linux/dma-mapping.h>
 #include <linux/dma-contiguous.h>
+#include <linux/efi.h>
 
 #include <asm/sections.h>
 #include <asm/setup.h>
@@ -151,7 +152,8 @@ void __init arm64_memblock_init(void)
 	memblock_reserve(__pa(swapper_pg_dir), SWAPPER_DIR_SIZE);
 	memblock_reserve(__pa(idmap_pg_dir), IDMAP_DIR_SIZE);
 
-	early_init_fdt_scan_reserved_mem();
+	if (!efi_enabled(EFI_MEMMAP))
+		early_init_fdt_scan_reserved_mem();
 
 	/* 4GB maximum for 32-bit only capable devices */
 	if (IS_ENABLED(CONFIG_ZONE_DMA))
-- 
1.7.10.4
