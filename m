From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 24/40] efifb: Enable the efi-framebuffer platform driver for ARM and arm64
Date: Mon, 25 Apr 2016 21:06:56 +0100
Message-ID: <1461614832-17633-25-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, David Herrmann <dh.herrmann@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Peter Jones <pjones@redhat.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Allows the efifb driver to be built for ARM and arm64. This simply involves
updating the Kconfig dependency expression, and supplying dummy versions of
efifb_setup_from_dmi().

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/arm/include/asm/efi.h   | 4 ++++
 arch/arm64/include/asm/efi.h | 4 ++++
 drivers/video/fbdev/Kconfig  | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 25f8b1162c2e..b45fe39bf35b 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -67,6 +67,10 @@ void efi_virtmap_unload(void);
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
index fa09886f72e6..79dc8c237c7e 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -59,6 +59,10 @@ int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
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
2.7.3
