From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 09/40] efi/arm*: Use memremap() to create the persistent memmap mapping
Date: Mon, 25 Apr 2016 21:06:41 +0100
Message-ID: <1461614832-17633-10-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Instead of using ioremap_cache(), which is slightly inappropriate for
mapping firmware tables, and is not even allowed on ARM for mapping
regions that are covered by a struct page, use memremap(), which was
invented for this purpose, and will also reuse the existing kernel
direct mapping if the requested region is covered by it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/arm-runtime.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 55a9ea041068..19283deac375 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -105,8 +105,7 @@ static int __init arm_enable_runtime_services(void)
 
 	mapsize = efi.memmap.map_end - efi.memmap.map;
 
-	efi.memmap.map = (__force void *)ioremap_cache(efi.memmap.phys_map,
-						       mapsize);
+	efi.memmap.map = memremap(efi.memmap.phys_map, mapsize, MEMREMAP_WB);
 	if (!efi.memmap.map) {
 		pr_err("Failed to remap EFI memory map\n");
 		return -ENOMEM;
-- 
2.7.3
