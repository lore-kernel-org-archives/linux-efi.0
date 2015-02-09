From: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH] Trivial patch in efifb.c to solve common indent issue and
 indent error
Date: Mon, 9 Feb 2015 07:55:53 -0500
Message-ID: <20150209125548.GA27277@linuxteamdev.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org
Cc: linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi All,

Please review this patch.
this patch is aimed to solve some indentation issue. It has also solved
three trivial error in efifb.c file.

And I have also changed printk with pr_err, pr_info ... at respective places.


>From c49139fac1d15fe2da80d06e2a79eb8be7c079a7 Mon Sep 17 00:00:00 2001
From: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
Date: Mon, 9 Feb 2015 07:33:59 -0500
Subject: [PATCH] Trival patch: improved indentation, and removed some ERROR
 from code

Signed-off-by: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
---
 drivers/video/fbdev/efifb.c | 158 +++++++++++++++++++++++---------------------
 1 file changed, 84 insertions(+), 74 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 4bfff34..5c03035 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -17,29 +17,28 @@
 #include <video/vga.h>
 #include <asm/sysfb.h>

-static bool request_mem_succeeded = false;
+static bool request_mem_succeeded;

 static struct fb_var_screeninfo efifb_defined = {
-       .activate               = FB_ACTIVATE_NOW,
-       .height                 = -1,
-       .width                  = -1,
-       .right_margin           = 32,
-       .upper_margin           = 16,
-       .lower_margin           = 4,
-       .vsync_len              = 4,
-       .vmode                  = FB_VMODE_NONINTERLACED,
+       .activate = FB_ACTIVATE_NOW,
+       .height = -1,
+       .width = -1,
+       .right_margin = 32,
+       .upper_margin = 16,
+       .lower_margin = 4,
+       .vsync_len = 4,
+       .vmode = FB_VMODE_NONINTERLACED,
 };

 static struct fb_fix_screeninfo efifb_fix = {
-       .id                     = "EFI VGA",
-       .type                   = FB_TYPE_PACKED_PIXELS,
-       .accel                  = FB_ACCEL_NONE,
-       .visual                 = FB_VISUAL_TRUECOLOR,
+       .id = "EFI VGA",
+       .type = FB_TYPE_PACKED_PIXELS,
+       .accel = FB_ACCEL_NONE,
+       .visual = FB_VISUAL_TRUECOLOR,
 };
 static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
-                          unsigned blue, unsigned transp,
-                          struct fb_info *info)
+                          unsigned blue, unsigned transp, struct fb_info *info)
 {
        /*
         *  Set a single color register. The values supplied are
@@ -52,13 +51,13 @@ static int efifb_setcolreg(unsigned regno, unsigned red,
unsigned green,
                return 1;

        if (regno < 16) {
-               red   >>= 8;
+               red >>= 8;
                green >>= 8;
-               blue  >>= 8;
-               ((u32 *)(info->pseudo_palette))[regno] =
-                       (red   << info->var.red.offset)   |
-                       (green << info->var.green.offset) |
-                       (blue  << info->var.blue.offset);
+               blue >>= 8;
+               ((u32 *) (info->pseudo_palette))[regno] =
+                   (red << info->var.red.offset) |
+                   (green << info->var.green.offset) |
+                   (blue << info->var.blue.offset);
        }
        return 0;
 }
@@ -74,12 +73,12 @@ static void efifb_destroy(struct fb_info *info)
 }

 static struct fb_ops efifb_ops = {
-       .owner          = THIS_MODULE,
-       .fb_destroy     = efifb_destroy,
-       .fb_setcolreg   = efifb_setcolreg,
-       .fb_fillrect    = cfb_fillrect,
-       .fb_copyarea    = cfb_copyarea,
-       .fb_imageblit   = cfb_imageblit,
+       .owner = THIS_MODULE,
+       .fb_destroy = efifb_destroy,
+       .fb_setcolreg = efifb_setcolreg,
+       .fb_fillrect = cfb_fillrect,
+       .fb_copyarea = cfb_copyarea,
+       .fb_imageblit = cfb_imageblit,
 };

 static int efifb_setup(char *options)
@@ -89,25 +88,35 @@ static int efifb_setup(char *options)

        if (options && *options) {
                while ((this_opt = strsep(&options, ",")) != NULL) {
-                       if (!*this_opt) continue;
+                       if (!*this_opt)
+                               continue;

                        for (i = 0; i < M_UNKNOWN; i++) {
                                if (efifb_dmi_list[i].base != 0 &&
-                                   !strcmp(this_opt,
efifb_dmi_list[i].optname)) {
-                                       screen_info.lfb_base =
efifb_dmi_list[i].base;
-                                       screen_info.lfb_linelength =
efifb_dmi_list[i].stride;
-                                       screen_info.lfb_width =
efifb_dmi_list[i].width;
-                                       screen_info.lfb_height =
efifb_dmi_list[i].height;
+                                   !strcmp(this_opt,
+                                           efifb_dmi_list[i].optname)) {
+                                       screen_info.lfb_base =
+                                           efifb_dmi_list[i].base;
+                                       screen_info.lfb_linelength =
+                                           efifb_dmi_list[i].stride;
+                                       screen_info.lfb_width =
+                                           efifb_dmi_list[i].width;
+                                       screen_info.lfb_height =
+                                           efifb_dmi_list[i].height;
                                }
                        }
                        if (!strncmp(this_opt, "base:", 5))
-                               screen_info.lfb_base =
simple_strtoul(this_opt+5, NULL, 0);
+                               screen_info.lfb_base =
+                                   simple_strtoul(this_opt + 5, NULL, 0);
                        else if (!strncmp(this_opt, "stride:", 7))
-                               screen_info.lfb_linelength =
simple_strtoul(this_opt+7, NULL, 0) * 4;
+                               screen_info.lfb_linelength =
+                                   simple_strtoul(this_opt + 7, NULL, 0) * 4;
                        else if (!strncmp(this_opt, "height:", 7))
-                               screen_info.lfb_height =
simple_strtoul(this_opt+7, NULL, 0);
+                               screen_info.lfb_height =
+                                   simple_strtoul(this_opt + 7, NULL, 0);
                        else if (!strncmp(this_opt, "width:", 6))
-                               screen_info.lfb_width =
simple_strtoul(this_opt+6, NULL, 0);
+                               screen_info.lfb_width =
+                                   simple_strtoul(this_opt + 6, NULL, 0);
                }
        }

@@ -142,10 +151,10 @@ static int efifb_probe(struct platform_device *dev)
        if (!screen_info.pages)
                screen_info.pages = 1;
        if (!screen_info.lfb_base) {
-               printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
+               pr_err("efifb: invalid framebuffer address\n");
                return -ENODEV;
        }
-       printk(KERN_INFO "efifb: probing for efifb\n");
+       pr_info("efifb: probing for efifb\n");

        /* just assume they're all unset if any are */
        if (!screen_info.blue_size) {
@@ -181,7 +190,7 @@ static int efifb_probe(struct platform_device *dev)
         *                 use for efifb.  With modern cards it is no
         *                 option to simply use size_total as that
         *                 wastes plenty of kernel address space. */
-       size_remap  = size_vmode * 2;
+       size_remap = size_vmode * 2;
        if (size_remap > size_total)
                size_remap = size_total;
        if (size_remap % PAGE_SIZE)
@@ -193,14 +202,14 @@ static int efifb_probe(struct platform_device *dev)
        } else {
                /* We cannot make this fatal. Sometimes this comes from magic
                   spaces our resource handlers simply don't know about */
-               printk(KERN_WARNING
+               pr_warn(
                       "efifb: cannot reserve video memory at 0x%lx\n",
-                       efifb_fix.smem_start);
+                      efifb_fix.smem_start);
        }

        info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
        if (!info) {
-               printk(KERN_ERR "efifb: cannot allocate framebuffer\n");
+               pr_err("efifb: cannot allocate framebuffer\n");
                err = -ENOMEM;
                goto err_release_mem;
        }
@@ -216,46 +225,46 @@ static int efifb_probe(struct platform_device *dev)
        info->apertures->ranges[0].base = efifb_fix.smem_start;
        info->apertures->ranges[0].size = size_remap;

-       info->screen_base = ioremap_wc(efifb_fix.smem_start,
efifb_fix.smem_len);
+       info->screen_base =
+           ioremap_wc(efifb_fix.smem_start, efifb_fix.smem_len);
        if (!info->screen_base) {
-               printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
-                               "0x%x @ 0x%lx\n",
-                       efifb_fix.smem_len, efifb_fix.smem_start);
+               pr_err("efifb: abort, cannot ioremap video memory "
+                      "0x%x @ 0x%lx\n",
+                      efifb_fix.smem_len, efifb_fix.smem_start);
                err = -EIO;
                goto err_release_fb;
        }

-       printk(KERN_INFO "efifb: framebuffer at 0x%lx, mapped to 0x%p, "
+       pr_info("efifb: framebuffer at 0x%lx, mapped to 0x%p, "
               "using %dk, total %dk\n",
               efifb_fix.smem_start, info->screen_base,
-              size_remap/1024, size_total/1024);
-       printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
+              size_remap / 1024, size_total / 1024);
+       pr_info("efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
               efifb_defined.xres, efifb_defined.yres,
               efifb_defined.bits_per_pixel, efifb_fix.line_length,
               screen_info.pages);

        efifb_defined.xres_virtual = efifb_defined.xres;
-       efifb_defined.yres_virtual = efifb_fix.smem_len /
-                                       efifb_fix.line_length;
-       printk(KERN_INFO "efifb: scrolling: redraw\n");
+       efifb_defined.yres_virtual = efifb_fix.smem_len / efifb_fix.line_length;
+       pr_info("efifb: scrolling: redraw\n");
        efifb_defined.yres_virtual = efifb_defined.yres;

        /* some dummy values for timing to make fbset happy */
-       efifb_defined.pixclock     = 10000000 / efifb_defined.xres *
-                                       1000 / efifb_defined.yres;
-       efifb_defined.left_margin  = (efifb_defined.xres / 8) & 0xf8;
-       efifb_defined.hsync_len    = (efifb_defined.xres / 8) & 0xf8;
-
-       efifb_defined.red.offset    = screen_info.red_pos;
-       efifb_defined.red.length    = screen_info.red_size;
-       efifb_defined.green.offset  = screen_info.green_pos;
-       efifb_defined.green.length  = screen_info.green_size;
-       efifb_defined.blue.offset   = screen_info.blue_pos;
-       efifb_defined.blue.length   = screen_info.blue_size;
+       efifb_defined.pixclock = 10000000 / efifb_defined.xres *
+           1000 / efifb_defined.yres;
+       efifb_defined.left_margin = (efifb_defined.xres / 8) & 0xf8;
+       efifb_defined.hsync_len = (efifb_defined.xres / 8) & 0xf8;
+
+       efifb_defined.red.offset = screen_info.red_pos;
+       efifb_defined.red.length = screen_info.red_size;
+       efifb_defined.green.offset = screen_info.green_pos;
+       efifb_defined.green.length = screen_info.green_size;
+       efifb_defined.blue.offset = screen_info.blue_pos;
+       efifb_defined.blue.length = screen_info.blue_size;
        efifb_defined.transp.offset = screen_info.rsvd_pos;
        efifb_defined.transp.length = screen_info.rsvd_size;

-       printk(KERN_INFO "efifb: %s: "
+       pr_info("efifb: %s: "
               "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
               "Truecolor",
               screen_info.rsvd_size,
@@ -264,10 +273,9 @@ static int efifb_probe(struct platform_device *dev)
               screen_info.blue_size,
               screen_info.rsvd_pos,
               screen_info.red_pos,
-              screen_info.green_pos,
-              screen_info.blue_pos);
+              screen_info.green_pos, screen_info.blue_pos);

-       efifb_fix.ypanstep  = 0;
+       efifb_fix.ypanstep = 0;
        efifb_fix.ywrapstep = 0;

        info->fbops = &efifb_ops;
@@ -275,12 +283,14 @@ static int efifb_probe(struct platform_device *dev)
        info->fix = efifb_fix;
        info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;

-       if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
-               printk(KERN_ERR "efifb: cannot allocate colormap\n");
+       err = fb_alloc_cmap(&info->cmap, 256, 0);
+       if ((err < 0) {
+               pr_err("efifb: cannot allocate colormap\n");
                goto err_unmap;
        }
-       if ((err = register_framebuffer(info)) < 0) {
-               printk(KERN_ERR "efifb: cannot register framebuffer\n");
+       err = register_framebuffer(info);
+       if (err < 0) {
+               pr_err("efifb: cannot register framebuffer\n");
                goto err_fb_dealoc;
        }
        fb_info(info, "%s frame buffer device\n", info->fix.id);
@@ -310,8 +320,8 @@ static int efifb_remove(struct platform_device *pdev)

 static struct platform_driver efifb_driver = {
        .driver = {
-               .name = "efi-framebuffer",
-       },
+                  .name = "efi-framebuffer",
+                  },
        .probe = efifb_probe,
        .remove = efifb_remove,
 };
--
1.9.3
