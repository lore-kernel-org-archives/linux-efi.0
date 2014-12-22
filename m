From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 8/8] arm64/efi: memblock_remove rather than _reserve UEFI reserved RAM
Date: Mon, 22 Dec 2014 19:08:42 +0000
Message-ID: <1419275322-29811-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419275322-29811-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now that we have the 'physmem' memblock table to keep track of physical
RAM regions, we can start using memblock_remove() to eliminate UEFI
reserved regions from the 'memory' memblock table and the kernel direct
linear mapping entirely. This makes these regions inaccessible entirely,
unless they are remapped explicitly by the UEFI Runtime Services layer,
UEFI configuration table drivers or the ACPI layer.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index b1b816ecf3b3..d0efd9df6216 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -167,7 +167,7 @@ static __init void reserve_regions(void)
 		if (uefi_debug) {
 			char buf[64];
 
-			pr_info("  0x%012llx-0x%012llx %s",
+			pr_info("  0x%012llx-0x%012llx %s\n",
 				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
 				efi_md_typeattr_format(buf, sizeof(buf), md));
 		}
@@ -177,15 +177,6 @@ static __init void reserve_regions(void)
 
 		if (is_normal_ram(md))
 			early_init_dt_add_memory_arch(paddr, size);
-
-		if (is_reserve_region(md)) {
-			memblock_reserve(paddr, size);
-			if (uefi_debug)
-				pr_cont("*");
-		}
-
-		if (uefi_debug)
-			pr_cont("\n");
 	}
 
 	/*
@@ -196,7 +187,18 @@ static __init void reserve_regions(void)
 	for_each_memblock(memory, r)
 		memblock_add_phys(r->base, r->size);
 
+	for_each_efi_memory_desc(&memmap, md) {
+		if (is_reserve_region(md)) {
+			paddr = md->phys_addr;
+			npages = md->num_pages;
+			memrange_efi_to_native(&paddr, &npages);
+			memblock_remove(paddr, npages << PAGE_SHIFT);
+		}
+	}
+
 	set_bit(EFI_MEMMAP, &efi.flags);
+	if (uefi_debug)
+		__memblock_dump_all();
 }
 
 void __init efi_init(void)
-- 
1.8.3.2
