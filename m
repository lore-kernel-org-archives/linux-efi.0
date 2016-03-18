From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 4/9] efi: efifb: use builtin_platform_driver and drop unused includes
Date: Fri, 18 Mar 2016 17:47:36 +0100
Message-ID: <1458319661-19762-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1458319661-19762-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458319661-19762-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Since efifb can only be built directly into the kernel, drop the module
specific includes and definitions. Drop some other includes we don't need
as well.

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
