From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] efi: arm64: abort boot on pending SError
Date: Fri,  1 Jul 2016 17:01:30 +0200
Message-ID: <1467385291-9880-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

It is the firmware's job to clear any pending SErrors before entering
the kernel. On UEFI, we can fail gracefully rather than panic during
early boot, so check for this condition in the stub.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index eae693eb3e91..c7e7396de876 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -20,7 +20,14 @@ extern bool __nokaslr;
 
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
-	u64 tg;
+	u64 tg, isr;
+
+	/* check for a pending SError */
+	asm ("mrs %0, isr_el1" : "=r"(isr));
+	if (isr & BIT(8)) {
+		pr_efi_err(sys_table_arg, "Pending SError detected -- aborting\n");
+		return EFI_LOAD_ERROR;
+	}
 
 	/* UEFI mandates support for 4 KB granularity, no need to check */
 	if (IS_ENABLED(CONFIG_ARM64_4K_PAGES))
-- 
2.7.4
