From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/2] arm64: don't make early_*map() calls post paging_init()
Date: Tue,  6 Jan 2015 13:41:12 +0000
Message-ID: <1420551673-31416-2-git-send-email-leif.lindholm@linaro.org>
References: <1420551673-31416-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420551673-31416-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

arm64 early_ioremap/iounmap/memremap/memunmap are not supported beyond
the call to paging_init(), but arm64_enter_virtual_mode() (an early
initcall) makes one call to unmap the UEFI memory map.

Rearrange the code to unmap this region before paging_init(), and then
pull back the remapping of the EFI memory map to the second part of
UEFI initialisation - efi_idmap_init() - renaming that function as
efi_memmap_init(), which better describes what it now does.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Fixes: f84d02755f5a ("arm64: add EFI runtime services")
---
 arch/arm64/include/asm/efi.h |  4 ++--
 arch/arm64/kernel/efi.c      | 27 ++++++++++++++-------------
 arch/arm64/kernel/setup.c    |  2 +-
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a34fd3b..92f4d44 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -6,10 +6,10 @@
 
 #ifdef CONFIG_EFI
 extern void efi_init(void);
-extern void efi_idmap_init(void);
+extern void efi_memmap_init(void);
 #else
 #define efi_init()
-#define efi_idmap_init()
+#define efi_memmap_init()
 #endif
 
 #define efi_call_virt(f, ...)						\
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 6fac253..e311066 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -313,17 +313,26 @@ void __init efi_init(void)
 	memmap.desc_size = params.desc_size;
 	memmap.desc_version = params.desc_ver;
 
-	if (uefi_init() < 0)
-		return;
+	if (uefi_init() >= 0)
+		reserve_regions();
 
-	reserve_regions();
+	early_memunmap(memmap.map, params.mmap_size);
 }
 
-void __init efi_idmap_init(void)
+void __init efi_memmap_init(void)
 {
+	u64 mapsize;
+
 	if (!efi_enabled(EFI_BOOT))
 		return;
 
+	/* replace early memmap mapping with permanent mapping */
+	mapsize = memmap.map_end - memmap.map;
+	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
+						   mapsize);
+	memmap.map_end = memmap.map + mapsize;
+	efi.memmap = &memmap;
+
 	/* boot time idmap_pg_dir is incomplete, so fill in missing parts */
 	efi_setup_idmap();
 }
@@ -379,23 +388,15 @@ static int __init arm64_enter_virtual_mode(void)
 		return -1;
 	}
 
-	mapsize = memmap.map_end - memmap.map;
-	early_memunmap(memmap.map, mapsize);
-
 	if (efi_runtime_disabled()) {
 		pr_info("EFI runtime services will be disabled.\n");
 		return -1;
 	}
 
 	pr_info("Remapping and enabling EFI services.\n");
-	/* replace early memmap mapping with permanent mapping */
-	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
-						   mapsize);
-	memmap.map_end = memmap.map + mapsize;
-
-	efi.memmap = &memmap;
 
 	/* Map the runtime regions */
+	mapsize = memmap.map_end - memmap.map;
 	virtmap = kmalloc(mapsize, GFP_KERNEL);
 	if (!virtmap) {
 		pr_err("Failed to allocate EFI virtual memmap\n");
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index b809911..ebf7820 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -401,7 +401,7 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 	request_standard_resources();
 
-	efi_idmap_init();
+	efi_memmap_init();
 
 	unflatten_device_tree();
 
-- 
2.1.3
