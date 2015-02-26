From: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 3/3] Moved assignment out of if() statement in efifb.c
Date: Thu, 26 Feb 2015 05:48:08 -0500
Message-ID: <20150226104803.GC20577@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Removing initialization out of if condition.

Signed-off-by: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
---
 drivers/video/fbdev/efifb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index cc1a156..9124ba9 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -275,11 +275,13 @@ static int efifb_probe(struct platform_device *dev)
        info->fix = efifb_fix;
        info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;

-       if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
+       err = fb_alloc_cmap(&info->cmap, 256, 0);
+       if (err < 0) {
                pr_err("efifb: cannot allocate colormap\n");
                goto err_unmap;
        }
-       if ((err = register_framebuffer(info)) < 0) {
+       err = register_framebuffer(info);
+       if (err < 0) {
                pr_err("efifb: cannot register framebuffer\n");
                goto err_fb_dealoc;
        }
--
1.9.3
