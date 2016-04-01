From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 9/9] efifb: enable the efi-framebuffer platform driver for ARM and arm64
Date: Fri,  1 Apr 2016 18:05:35 +0200
Message-ID: <1459526735-24936-10-git-send-email-ard.biesheuvel@linaro.org>
References: <1459526735-24936-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459526735-24936-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Allows the efifb driver to be built for ARM and arm64. This simply involves
updating the Kconfig dependency expression, and supplying dummy versions of
efifb_setup_from_dmi().

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/include/asm/efi.h   | 4 ++++
 arch/arm64/include/asm/efi.h | 4 ++++
 drivers/video/fbdev/Kconfig  | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index be12877e8609..76ce7adde990 100644
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
  * A reasonable upper bound for the uncompressed kernel size is 32 MBytes,
  * so we will reserve that amount of memory. We have no easy way to tell what
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index ed6c85d3a583..ec43456e3ef1 100644
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
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index 983280e8d93f..e5a391aecde1 100644
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
2.5.0
