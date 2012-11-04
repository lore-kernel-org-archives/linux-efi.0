From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Date: Sun,  4 Nov 2012 17:35:06 +0000
Message-ID: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Corentin Chary <corentincj-EjuBZuxMvz2sTnJN9+BGXg@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alessandro Crismani <alessandro.crismani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mikhail Bakhterev <mike.bakhterev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Patrick H <kernel-0BLq+tI11CLk1uMJSBkQmQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

We've started getting reports of users seeing Machine Check Exceptions
when booting their Samsung laptops in UEFI mode,

     https://bugzilla.kernel.org/show_bug.cgi?id=47121

This module seems to be the culprit as it's grovelling around in the
0xf0000 region which has no mapping in either the e820 or EFI memory
maps on the affected machines.

Reported-by: Alessandro Crismani <alessandro.crismani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-by: Mikhail Bakhterev <mike.bakhterev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Patrick H <kernel-0BLq+tI11CLk1uMJSBkQmQ@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Corentin Chary <corentincj-EjuBZuxMvz2sTnJN9+BGXg@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/platform/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index c86bae8..0fe5200 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -717,7 +717,7 @@ config XO15_EBOOK
 
 config SAMSUNG_LAPTOP
 	tristate "Samsung Laptop driver"
-	depends on X86
+	depends on X86 && !EFI
 	depends on RFKILL || RFKILL = n
 	depends on BACKLIGHT_CLASS_DEVICE
 	select LEDS_CLASS
-- 
1.7.11.7
