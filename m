From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 4/9] efi: efifb: use builtin_platform_driver and drop unused includes
Date: Fri,  1 Apr 2016 18:05:30 +0200
Message-ID: <1459526735-24936-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1459526735-24936-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459526735-24936-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Since efifb can only be built directly into the kernel, drop the module
specific includes and definitions. Drop some other includes we don't need
as well.

Acked-By: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/video/fbdev/efifb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index dd594369b8a6..f4c045c0051c 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -6,15 +6,12 @@
  *
  */
 
-#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/efi.h>
 #include <linux/errno.h>
 #include <linux/fb.h>
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
-#include <linux/dmi.h>
-#include <linux/pci.h>
 #include <video/vga.h>
 #include <asm/efi.h>
 
@@ -331,5 +328,4 @@ static struct platform_driver efifb_driver = {
 	.remove = efifb_remove,
 };
 
-module_platform_driver(efifb_driver);
-MODULE_LICENSE("GPL");
+builtin_platform_driver(efifb_driver);
-- 
2.5.0
