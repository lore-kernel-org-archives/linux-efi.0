From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 06/13] efi/efistub: Prevent __init annotations from being used
Date: Wed, 17 Feb 2016 12:35:59 +0000
Message-ID: <1455712566-16727-7-git-send-email-matt@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Mark Rutland <mark.rutland@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

__init annotations should not be used in the EFI stub, since the code is
either included in the decompressor (x86, ARM) where they have no effect,
or the whole stub is __init annotated at the section level (arm64), by
renaming the sections, in which case the __init annotations will be
redundant, and will result in section names like .init.init.text, and our
linker script does not expect that. So un-#define __init so that its
inadvertent use will force a build error.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/libstub/efistub.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 6b6548fda089..86ff7bfa6ace 100644
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
2.6.2
