From: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 2/3] Static should not be initialize so removing static
 initilization from efifb.c
Date: Thu, 26 Feb 2015 05:45:40 -0500
Message-ID: <20150226104537.GB20577@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

 Static variables should not be initialized. So removing initialization of
static variable.

Signed-off-by: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
---
 drivers/video/fbdev/efifb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index facfbb3..cc1a156 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -17,7 +17,7 @@
 #include <video/vga.h>
 #include <asm/sysfb.h>

-static bool request_mem_succeeded = false;
+static bool request_mem_succeeded;

 static struct fb_var_screeninfo efifb_defined = {
        .activate               = FB_ACTIVATE_NOW,
--
1.9.3
