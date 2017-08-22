From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH][next] efi/reboot: make function pointer orig_pm_power_off static
Date: Tue, 22 Aug 2017 16:50:40 +0100
Message-ID: <20170822155040.32058-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

The function pointer orig_pm_power_off is local to the source and does
not need to be in global scope, so make it static.

Cleans up sparse warning:
symbol 'orig_pm_power_off' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
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
2.14.1
