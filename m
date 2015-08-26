From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] arm64: use core efi=debug instead of uefi_debug command line parameter
Date: Wed, 26 Aug 2015 14:24:57 +0100
Message-ID: <1440595498-30630-3-git-send-email-leif.lindholm@linaro.org>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440595498-30630-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Now that we have an efi=debug command line option in the core code, use
this instead of the arm64-specific uefi_debug option.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 Documentation/arm/uefi.txt |  2 --
 arch/arm64/kernel/efi.c    | 19 +++++--------------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
index d60030a..7b3fdfe 100644
--- a/Documentation/arm/uefi.txt
+++ b/Documentation/arm/uefi.txt
@@ -60,5 +60,3 @@ linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
 --------------------------------------------------------------------------------
 linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
 --------------------------------------------------------------------------------
-
-For verbose debug messages, specify 'uefi_debug' on the kernel command line.
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e8ca6ea..612ad5e 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -51,15 +51,6 @@ static struct mm_struct efi_mm = {
 	INIT_MM_CONTEXT(efi_mm)
 };
 
-static int uefi_debug __initdata;
-static int __init uefi_debug_setup(char *str)
-{
-	uefi_debug = 1;
-
-	return 0;
-}
-early_param("uefi_debug", uefi_debug_setup);
-
 static int __init is_normal_ram(efi_memory_desc_t *md)
 {
 	if (md->attribute & EFI_MEMORY_WB)
@@ -171,14 +162,14 @@ static __init void reserve_regions(void)
 	efi_memory_desc_t *md;
 	u64 paddr, npages, size;
 
-	if (uefi_debug)
+	if (efi_enabled(EFI_DBG))
 		pr_info("Processing EFI memory map:\n");
 
 	for_each_efi_memory_desc(&memmap, md) {
 		paddr = md->phys_addr;
 		npages = md->num_pages;
 
-		if (uefi_debug) {
+		if (efi_enabled(EFI_DBG)) {
 			char buf[64];
 
 			pr_info("  0x%012llx-0x%012llx %s",
@@ -194,11 +185,11 @@ static __init void reserve_regions(void)
 
 		if (is_reserve_region(md)) {
 			memblock_reserve(paddr, size);
-			if (uefi_debug)
+			if (efi_enabled(EFI_DBG))
 				pr_cont("*");
 		}
 
-		if (uefi_debug)
+		if (efi_enabled(EFI_DBG))
 			pr_cont("\n");
 	}
 
@@ -210,7 +201,7 @@ void __init efi_init(void)
 	struct efi_fdt_params params;
 
 	/* Grab UEFI information placed in FDT by stub */
-	if (!efi_get_fdt_params(&params, uefi_debug))
+	if (!efi_get_fdt_params(&params, efi_enabled(EFI_DBG)))
 		return;
 
 	efi_system_table = params.system_table;
-- 
2.1.4
