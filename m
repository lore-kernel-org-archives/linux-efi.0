From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: rtc-efi: export platform:rtc-efi as module alias
Date: Thu, 11 Sep 2014 10:20:40 +0200
Message-ID: <1410423640-1499-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When the rtc-efi driver is built as a module, we already register the
EFI rtc as a platform device if UEFI Runtime Services are enabled.
To wire it up to udev, and let the module be loaded automatically, we
need to export the 'platform:rtc-efi' alias from the module.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/rtc/rtc-efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index 8225b89de810..59a55e7abf78 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -235,3 +235,4 @@ module_platform_driver_probe(efi_rtc_driver, efi_rtc_probe);
 MODULE_AUTHOR("dann frazier <dannf-VXdhtT5mjnY@public.gmane.org>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("EFI RTC driver");
+MODULE_ALIAS("platform:rtc-efi");
-- 
1.8.3.2
