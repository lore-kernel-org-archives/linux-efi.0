From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] efi/arm*: use memremap() to create the persistent memmap mapping
Date: Wed, 13 Apr 2016 17:37:53 +0200
Message-ID: <1460561873-27756-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1460561873-27756-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460561873-27756-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Instead of using ioremap_cache(), which is slightly inappropriate for
mapping firmware tables, and is not even allowed on ARM for mapping
regions that are covered by a struct page, use memremap(), which was
invented for this purpose, and will also reuse the existing kernel
direct mapping if the requested region is covered by it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/arm-runtime.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 98fe93a9813b..17ccf0a8787a 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -111,8 +111,7 @@ static int __init arm_enable_runtime_services(void)
 
 	mapsize = efi.memmap.map_end - efi.memmap.map;
 
-	efi.memmap.map = (__force void *)ioremap_cache(efi.memmap.phys_map,
-						       mapsize);
+	efi.memmap.map = memremap(efi.memmap.phys_map, mapsize, MEMREMAP_WB);
 	if (!efi.memmap.map) {
 		pr_err("Failed to remap EFI memory map\n");
 		return -ENOMEM;
-- 
2.5.0
