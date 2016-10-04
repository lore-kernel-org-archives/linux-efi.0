From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efifb: show framebuffer layout as device attributes
Date: Tue, 4 Oct 2016 09:35:21 -0400
Message-ID: <20161004133520.ecyfshyalxjl5eap@redhat.com>
References: <20161003170923.15025-1-pjones@redhat.com>
 <CAKv+Gu-tW51s7ajiAZWWYyN3b_H3qXbXDpGV4Oowf5AiFzmSSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-tW51s7ajiAZWWYyN3b_H3qXbXDpGV4Oowf5AiFzmSSA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 04, 2016 at 02:31:55PM +0100, Ard Biesheuvel wrote:
> Hi Peter,
> 
> On 3 October 2016 at 10:09, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Userland sometimes needs to know what the framebuffer configuration was
> > when the firmware was running.  This enables us to render localized
> > status strings during firmware updates using the data from the ACPI BGRT
> > table and the protocol described at the url below:
> >
> > https://msdn.microsoft.com/en-us/windows/hardware/drivers/bringup/boot-screen-components
> >
> > This patch also fixes up efifb's printk() usage to use pr_warn() /
> > pr_info() / pr_err() instead.
> >
> > Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> I've given this a spin on arm64 (QEMU), and it works as expected.
> 
> Tested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Since you're the maintainer of efifb, how do you expect this to be taken in?

Usually I just funnel anything EFI related through mfleming, since he's
already doing regular pushes upstream and it's part of his workflow.
Matt, does that work for you in this case?

> 
> -- 
> Ard.
> 
> 
> > ---
> >  drivers/video/fbdev/efifb.c | 59 +++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 46 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> > index 924bad4..099b76b 100644
> > --- a/drivers/video/fbdev/efifb.c
> > +++ b/drivers/video/fbdev/efifb.c
> > @@ -118,6 +118,31 @@ static inline bool fb_base_is_valid(void)
> >         return false;
> >  }
> >
> > +#define efifb_attr_decl(name, fmt)                                     \
> > +static ssize_t name##_show(struct device *dev,                         \
> > +                          struct device_attribute *attr,               \
> > +                          char *buf)                                   \
> > +{                                                                      \
> > +       return sprintf(buf, fmt "\n", (screen_info.lfb_##name));        \
> > +}                                                                      \
> > +static DEVICE_ATTR_RO(name)
> > +
> > +efifb_attr_decl(base, "0x%x");
> > +efifb_attr_decl(linelength, "%u");
> > +efifb_attr_decl(height, "%u");
> > +efifb_attr_decl(width, "%u");
> > +efifb_attr_decl(depth, "%u");
> > +
> > +static struct attribute *efifb_attrs[] = {
> > +       &dev_attr_base.attr,
> > +       &dev_attr_linelength.attr,
> > +       &dev_attr_width.attr,
> > +       &dev_attr_height.attr,
> > +       &dev_attr_depth.attr,
> > +       NULL
> > +};
> > +ATTRIBUTE_GROUPS(efifb);
> > +
> >  static int efifb_probe(struct platform_device *dev)
> >  {
> >         struct fb_info *info;
> > @@ -205,14 +230,13 @@ static int efifb_probe(struct platform_device *dev)
> >         } else {
> >                 /* We cannot make this fatal. Sometimes this comes from magic
> >                    spaces our resource handlers simply don't know about */
> > -               printk(KERN_WARNING
> > -                      "efifb: cannot reserve video memory at 0x%lx\n",
> > +               pr_warn("efifb: cannot reserve video memory at 0x%lx\n",
> >                         efifb_fix.smem_start);
> >         }
> >
> >         info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
> >         if (!info) {
> > -               printk(KERN_ERR "efifb: cannot allocate framebuffer\n");
> > +               pr_err("efifb: cannot allocate framebuffer\n");
> >                 err = -ENOMEM;
> >                 goto err_release_mem;
> >         }
> > @@ -230,16 +254,15 @@ static int efifb_probe(struct platform_device *dev)
> >
> >         info->screen_base = ioremap_wc(efifb_fix.smem_start, efifb_fix.smem_len);
> >         if (!info->screen_base) {
> > -               printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
> > -                               "0x%x @ 0x%lx\n",
> > +               pr_err("efifb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",
> >                         efifb_fix.smem_len, efifb_fix.smem_start);
> >                 err = -EIO;
> >                 goto err_release_fb;
> >         }
> >
> > -       printk(KERN_INFO "efifb: framebuffer at 0x%lx, using %dk, total %dk\n",
> > +       pr_info("efifb: framebuffer at 0x%lx, using %dk, total %dk\n",
> >                efifb_fix.smem_start, size_remap/1024, size_total/1024);
> > -       printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
> > +       pr_info("efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
> >                efifb_defined.xres, efifb_defined.yres,
> >                efifb_defined.bits_per_pixel, efifb_fix.line_length,
> >                screen_info.pages);
> > @@ -247,7 +270,7 @@ static int efifb_probe(struct platform_device *dev)
> >         efifb_defined.xres_virtual = efifb_defined.xres;
> >         efifb_defined.yres_virtual = efifb_fix.smem_len /
> >                                         efifb_fix.line_length;
> > -       printk(KERN_INFO "efifb: scrolling: redraw\n");
> > +       pr_info("efifb: scrolling: redraw\n");
> >         efifb_defined.yres_virtual = efifb_defined.yres;
> >
> >         /* some dummy values for timing to make fbset happy */
> > @@ -265,7 +288,7 @@ static int efifb_probe(struct platform_device *dev)
> >         efifb_defined.transp.offset = screen_info.rsvd_pos;
> >         efifb_defined.transp.length = screen_info.rsvd_size;
> >
> > -       printk(KERN_INFO "efifb: %s: "
> > +       pr_info("efifb: %s: "
> >                "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
> >                "Truecolor",
> >                screen_info.rsvd_size,
> > @@ -285,12 +308,19 @@ static int efifb_probe(struct platform_device *dev)
> >         info->fix = efifb_fix;
> >         info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;
> >
> > -       if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
> > -               printk(KERN_ERR "efifb: cannot allocate colormap\n");
> > +       err = sysfs_create_groups(&dev->dev.kobj, efifb_groups);
> > +       if (err) {
> > +               pr_err("efifb: cannot add sysfs attrs\n");
> >                 goto err_unmap;
> >         }
> > -       if ((err = register_framebuffer(info)) < 0) {
> > -               printk(KERN_ERR "efifb: cannot register framebuffer\n");
> > +       err = fb_alloc_cmap(&info->cmap, 256, 0);
> > +       if (err < 0) {
> > +               pr_err("efifb: cannot allocate colormap\n");
> > +               goto err_groups;
> > +       }
> > +       err = register_framebuffer(info);
> > +       if (err < 0) {
> > +               pr_err("efifb: cannot register framebuffer\n");
> >                 goto err_fb_dealoc;
> >         }
> >         fb_info(info, "%s frame buffer device\n", info->fix.id);
> > @@ -298,6 +328,8 @@ static int efifb_probe(struct platform_device *dev)
> >
> >  err_fb_dealoc:
> >         fb_dealloc_cmap(&info->cmap);
> > +err_groups:
> > +       sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
> >  err_unmap:
> >         iounmap(info->screen_base);
> >  err_release_fb:
> > @@ -313,6 +345,7 @@ static int efifb_remove(struct platform_device *pdev)
> >         struct fb_info *info = platform_get_drvdata(pdev);
> >
> >         unregister_framebuffer(info);
> > +       sysfs_remove_groups(&pdev->dev.kobj, efifb_groups);
> >         framebuffer_release(info);
> >
> >         return 0;
> > --
> > 2.10.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
  Peter
