From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] efi: ARM: avoid warning about phys_addr_t cast
Date: Mon, 18 Apr 2016 10:34:19 +0200
Message-ID: <1460968481-169298-1-git-send-email-arnd@arndb.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

memblock_remove() takes a phys_addr_t, which may be narrower than 64 bits,
causing a harmless warning:

drivers/firmware/efi/arm-init.c: In function 'reserve_regions':
include/linux/kernel.h:29:20: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
 #define ULLONG_MAX (~0ULL)
                    ^
drivers/firmware/efi/arm-init.c:152:21: note: in expansion of macro 'ULLONG_MAX'
  memblock_remove(0, ULLONG_MAX);

This adds an explicit typecast to avoid the warning

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Fixes: 500899c2cc3e ("efi: ARM/arm64: ignore DT memory nodes instead of removing them")
---
 drivers/firmware/efi/arm-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 434dd6065935..fac567c3b66a 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -149,7 +149,7 @@ static __init void reserve_regions(void)
 	 * uses its own memory map instead.
 	 */
 	memblock_dump_all();
-	memblock_remove(0, ULLONG_MAX);
+	memblock_remove(0, (phys_addr_t)ULLONG_MAX);
 
 	for_each_efi_memory_desc(&memmap, md) {
 		paddr = md->phys_addr;
-- 
2.7.0
