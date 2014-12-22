From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/8] arm64/efi: register physmem in reserve_regions()
Date: Mon, 22 Dec 2014 19:08:40 +0000
Message-ID: <1419275322-29811-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419275322-29811-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

After traversing the UEFI memory map to discover the regions that are backed
by normal RAM, register the resulting minimal memory map into the physmem
memblock table.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index ba5fe66c3634..b1b816ecf3b3 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -155,6 +155,7 @@ static __init void reserve_regions(void)
 {
 	efi_memory_desc_t *md;
 	u64 paddr, npages, size;
+	struct memblock_region *r;
 
 	if (uefi_debug)
 		pr_info("Processing EFI memory map:\n");
@@ -187,6 +188,14 @@ static __init void reserve_regions(void)
 			pr_cont("\n");
 	}
 
+	/*
+	 * After memblock has stitched all the regions together, copy the
+	 * resulting map of physical memory from the memory memblock table into
+	 * the physmem memblock table.
+	 */
+	for_each_memblock(memory, r)
+		memblock_add_phys(r->base, r->size);
+
 	set_bit(EFI_MEMMAP, &efi.flags);
 }
 
-- 
1.8.3.2
