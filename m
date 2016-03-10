From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 7/8] efi/arm*: efifb: expose efifb platform device if GOP is available
Date: Thu, 10 Mar 2016 12:40:07 +0700
Message-ID: <1457588408-19309-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457588408-19309-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This allows the efifb driver to be built for ARM and arm64, and adds the
registration of a "efi-framebuffer" platform device if the GOP code in the
stub has populated screen_info appropriately.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/include/asm/efi.h      |  4 ++++
 arch/arm64/include/asm/efi.h    |  4 ++++
 drivers/firmware/efi/arm-init.c | 19 +++++++++++++++++++
 drivers/video/fbdev/Kconfig     |  2 +-
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 6329b5be1eca..9b6d441b08fd 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -66,6 +66,10 @@ void efi_virtmap_unload(void);
 struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg);
 void free_screen_info(efi_system_table_t *sys_table, struct screen_info *si);
 
+static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
+{
+}
+
 /*
  * This GUID is used to pass to the kernel proper the struct screen_info
  * structure that was populated by the stub based on the GOP protocol instance
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a6c14f29b970..00e9d7099a8f 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -57,6 +57,10 @@ int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 #define alloc_screen_info(x...)		&screen_info
 #define free_screen_info(x...)
 
+static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
+{
+}
+
 #define EFI_ALLOC_ALIGN		SZ_64K
 
 /*
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 9e15d571b53c..eca9b4f826ee 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -17,6 +17,8 @@
 #include <linux/mm_types.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/platform_device.h>
+#include <linux/screen_info.h>
 
 #include <asm/efi.h>
 
@@ -206,4 +208,21 @@ void __init efi_init(void)
 	memblock_mark_nomap(params.mmap & PAGE_MASK,
 			    PAGE_ALIGN(params.mmap_size +
 				       (params.mmap & ~PAGE_MASK)));
+
+	if (screen_info.orig_video_isVGA == VIDEO_TYPE_EFI &&
+	    memblock_is_map_memory(screen_info.lfb_base))
+		memblock_mark_nomap(screen_info.lfb_base, screen_info.lfb_size);
+}
+
+static int __init register_gop_device(void)
+{
+	void *pd;
+
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+		return 0;
+
+	/* the efifb driver accesses screen_info directly, no need to pass it */
+	pd = platform_device_register_simple("efi-framebuffer", 0, NULL, 0);
+	return PTR_ERR_OR_ZERO(pd);
 }
+subsys_initcall(register_gop_device);
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 8ea45a5cd806..ccbaa25aad76 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -761,7 +761,7 @@ config FB_VESA
 
 config FB_EFI
 	bool "EFI-based Framebuffer Support"
-	depends on (FB = y) && X86 && EFI
+	depends on (FB = y) && !IA64 && EFI
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.9.1
