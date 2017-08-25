From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 3/5] efi/reboot: Make function pointer orig_pm_power_off static
Date: Fri, 25 Aug 2017 16:50:17 +0100
Message-ID: <20170825155019.6740-4-ard.biesheuvel@linaro.org>
References: <20170825155019.6740-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170825155019.6740-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Colin Ian King <colin.king@canonical.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The function pointer orig_pm_power_off is local to the source and does
not need to be in global scope, so make it static.

Cleans up sparse warning:
symbol 'orig_pm_power_off' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/reboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 7117e2d0c7f9..22874544d301 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -5,7 +5,7 @@
 #include <linux/efi.h>
 #include <linux/reboot.h>
 
-void (*orig_pm_power_off)(void);
+static void (*orig_pm_power_off)(void);
 
 int efi_reboot_quirk_mode = -1;
 
-- 
2.11.0
