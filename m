From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 2/2] arm64: call early_ioremap_reset() in paging_init()
Date: Tue,  6 Jan 2015 13:41:13 +0000
Message-ID: <1420551673-31416-3-git-send-email-leif.lindholm@linaro.org>
References: <1420551673-31416-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420551673-31416-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

arm64 does not support early_memremap/memunmap/ioremap/iounmap after
paging_init() has been called. The core early_*remap code handles this
via the after_paging_init variable, which is set by a call to
early_ioremap_reset().

However, arm64 currently does not call early_ioremap_reset(), which
has made it possible to poke around in the fixmap region after kmap
is enabled. Add the required call.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Fixes: bf4b558eba92 ("arm64: add early_ioremap support")
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/mm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6032f3e..506544f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -348,6 +348,7 @@ void __init paging_init(void)
 {
 	void *zero_page;
 
+	early_ioremap_reset();
 	map_mem();
 
 	/*
-- 
2.1.3
