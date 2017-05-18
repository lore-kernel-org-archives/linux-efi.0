From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] efi/libstub: arm64: use hidden attribute for struct screen_info reference
Date: Thu, 18 May 2017 10:09:51 +0100
Message-ID: <20170518090953.32628-2-ard.biesheuvel@linaro.org>
References: <20170518090953.32628-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170518090953.32628-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

To prevent the compiler from emitting absolute references to screen_info
when building position independent code, redeclare the symbol with hidden
visibility.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8f3043aba873..464ac850c5e2 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -81,6 +81,9 @@ static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
 #define alloc_screen_info(x...)		&screen_info
 #define free_screen_info(x...)
 
+/* redeclare as 'hidden' so the compiler will generate relative references */
+extern struct screen_info screen_info __attribute__((__visibility__("hidden")));
+
 static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
 {
 }
-- 
2.9.3
