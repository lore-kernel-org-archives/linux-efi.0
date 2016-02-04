From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 3/7] efi: efistub: prevent __init annotations from being used
Date: Thu,  4 Feb 2016 16:50:26 +0100
Message-ID: <1454601030-9093-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1454601030-9093-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454601030-9093-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, jeremy.linton-5wv7dgnIgG8@public.gmane.org, suzuki.poulose-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

__init annotations should not be used in the EFI stub, since the code is
either included in the decompressor (x86, ARM) where they have no effect,
or the whole stub is __init annotated at the section level (arm64), by
renaming the sections, in which case the __init annotations will be
redundant, and will result in section names like .init.init.text, and our
linker script does not expect that. So un-#define __init so that its
inadvertent use will force a build error.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/efistub.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 6b6548fda089..275f395c886d 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -5,6 +5,16 @@
 /* error code which can't be mistaken for valid address */
 #define EFI_ERROR	(~0UL)
 
+/*
+ * __init annotations should not be used in the EFI stub, since the code is
+ * either included in the decompressor (x86, ARM) where they have no effect,
+ * or the whole stub is __init annotated at the section level (arm64), by
+ * renaming the sections, in which case the __init annotation will be
+ * redundant, and will result in section names like .init.init.text, and our
+ * linker script does not expect that.
+ */
+#undef __init
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
-- 
2.5.0
