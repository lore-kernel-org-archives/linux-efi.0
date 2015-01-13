From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: rtc-efi: mark UIE as unsupported
Date: Tue, 13 Jan 2015 12:28:53 +0000
Message-ID: <1421152133-28506-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Tools like hwclock attempt to enable the RTC update interrupt (UIE) to
maximize the accuracy of the reported time value. The EFI rtc does not
have interrupt capability so this is a pointless exercise to begin with,
but the generic RTC framework ends up issuing a SetWakeupTime() Runtime
Services call before drawing that conclusion on its own.

Instead, we can mark UIE as unsupported at driver probe time. The net
result is the same, but without the spurious SetWakeupTime() call.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/rtc/rtc-efi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index b37b0c80bd5a..cb989cd00b14 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -218,6 +218,7 @@ static int __init efi_rtc_probe(struct platform_device *dev)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
+	rtc->uie_unsupported = 1;
 	platform_set_drvdata(dev, rtc);
 
 	return 0;
-- 
1.8.3.2
