From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] arm64: efi: ignore EFI_MEMORY_XP attribute if RP and/or WP are set
Date: Thu, 14 Sep 2017 12:31:53 -0700
Message-ID: <20170914193153.18520-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The UEFI memory map is a bit vague about how to interpret the
EFI_MEMORY_XP attribute when it is combined with EFI_MEMORY_RP and/or
EFI_MEMORY_WP, which have retroactively been redefined as cacheability
attributes rather than permission attributes.

So let's ignore EFI_MEMORY_XP if _RP and/or _WP are also set. In this
case, it is likely that they are being used to describe the capability
of the region (i.e., whether it has the controls to reconfigure it as
non-executable) rather than the nature of the contents of the region
(i.e., whether it contains data that we will never attempt to execute)

Cc: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 82cd07592519..f85ac58d08a3 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -48,7 +48,9 @@ static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 		return pgprot_val(PAGE_KERNEL_ROX);
 
 	/* RW- */
-	if (attr & EFI_MEMORY_XP || type != EFI_RUNTIME_SERVICES_CODE)
+	if (((attr & (EFI_MEMORY_RP | EFI_MEMORY_WP | EFI_MEMORY_XP)) ==
+	     EFI_MEMORY_XP) ||
+	    type != EFI_RUNTIME_SERVICES_CODE)
 		return pgprot_val(PAGE_KERNEL);
 
 	/* RWX */
-- 
2.11.0
