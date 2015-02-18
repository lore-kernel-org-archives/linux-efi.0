From: Parmeshwr Prasad <parmeshwr_prasad@dell.com>
Subject: Re: [PATCH 1/3] Printk() is replaced with pr_* respective functions
 in efifb.c
Date: Wed, 18 Feb 2015 04:51:16 -0500
Message-ID: <20150218095111.GA22630@linuxteamdev.amer.dell.com>
References: <20150218082942.GB9820@linuxteamdev.amer.dell.com>
 <1424249497.25416.23.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424249497.25416.23.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "pjones@redhat.com" <pjones@redhat.com>, "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>, "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Thanks Joe for your suggestion.
I have changes patch as you said.

Signed-off-by: Parmeshwr Prasad <parmeshwr_prasad@dell.com>
---
 drivers/video/fbdev/efifb.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 4bfff34..7557991 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -6,6 +6,8 @@
  *
  */

+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -142,10 +144,10 @@ static int efifb_probe(struct platform_device *dev)
        if (!screen_info.pages)
                screen_info.pages = 1;
        if (!screen_info.lfb_base) {
-               printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
+               pr_debug("invalid framebuffer address\n");
                return -ENODEV;
        }
-       printk(KERN_INFO "efifb: probing for efifb\n");
+       pr_info("probing for efifb\n");

        /* just assume they're all unset if any are */
        if (!screen_info.blue_size) {
@@ -193,14 +195,14 @@ static int efifb_probe(struct platform_device *dev)
        } else {
                /* We cannot make this fatal. Sometimes this comes from magic
                   spaces our resource handlers simply don't know about */
-               printk(KERN_WARNING
-                      "efifb: cannot reserve video memory at 0x%lx\n",
+               pr_warn(
+                      "cannot reserve video memory at 0x%lx\n",
                        efifb_fix.smem_start);
        }

        info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
        if (!info) {
-               printk(KERN_ERR "efifb: cannot allocate framebuffer\n");
+               pr_err("cannot allocate framebuffer\n");
                err = -ENOMEM;
                goto err_release_mem;
        }
@@ -218,18 +220,18 @@ static int efifb_probe(struct platform_device *dev)

        info->screen_base = ioremap_wc(efifb_fix.smem_start,
efifb_fix.smem_len);
        if (!info->screen_base) {
-               printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
+               pr_err("abort, cannot ioremap video memory "
                                "0x%x @ 0x%lx\n",
                        efifb_fix.smem_len, efifb_fix.smem_start);
                err = -EIO;
                goto err_release_fb;
        }

-       printk(KERN_INFO "efifb: framebuffer at 0x%lx, mapped to 0x%p, "
+       pr_info("framebuffer at 0x%lx, mapped to 0x%p, "
               "using %dk, total %dk\n",
               efifb_fix.smem_start, info->screen_base,
               size_remap/1024, size_total/1024);
-       printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
+       pr_info("mode is %dx%dx%d, linelength=%d, pages=%d\n",
               efifb_defined.xres, efifb_defined.yres,
               efifb_defined.bits_per_pixel, efifb_fix.line_length,
               screen_info.pages);
@@ -237,7 +239,7 @@ static int efifb_probe(struct platform_device *dev)
        efifb_defined.xres_virtual = efifb_defined.xres;
        efifb_defined.yres_virtual = efifb_fix.smem_len /
                                        efifb_fix.line_length;
-       printk(KERN_INFO "efifb: scrolling: redraw\n");
+       pr_info("scrolling: redraw\n");
        efifb_defined.yres_virtual = efifb_defined.yres;

        /* some dummy values for timing to make fbset happy */
@@ -255,7 +257,7 @@ static int efifb_probe(struct platform_device *dev)
        efifb_defined.transp.offset = screen_info.rsvd_pos;
        efifb_defined.transp.length = screen_info.rsvd_size;

-       printk(KERN_INFO "efifb: %s: "
+       pr_info("%s: "
               "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
               "Truecolor",
               screen_info.rsvd_size,
@@ -276,11 +278,11 @@ static int efifb_probe(struct platform_device *dev)
        info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;

        if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
-               printk(KERN_ERR "efifb: cannot allocate colormap\n");
+               pr_err("cannot allocate colormap\n");
                goto err_unmap;
        }
        if ((err = register_framebuffer(info)) < 0) {
-               printk(KERN_ERR "efifb: cannot register framebuffer\n");
+               pr_err("cannot register framebuffer\n");
                goto err_fb_dealoc;
        }
        fb_info(info, "%s frame buffer device\n", info->fix.id);
--
1.9.3

-Parmeshwr
On Wed, Feb 18, 2015 at 02:51:37AM -0600, Joe Perches wrote:
> On Wed, 2015-02-18 at 03:29 -0500, Parmeshwr Prasad wrote:
> > This is a trivial patch:
> > 
> > I have replaced printk() with respective pr_* functions.
> 
> Hi.
> 
> A few suggestions:
> 
> o Add this #define before any include
> 	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> o Strip the embedded "efifb: " prefixes from the formats
> o Coalesce the formats
> o Don't change KERN_<LEVEL> uses unnecessarily
>   If you do change logging levels, state why in the change log
> o Align the multiline arguments
> 
> > diff --git a/drivers/video/fbdev/efifb.c b/diriveom rrs/video/fbdev/efifb.c
> []
> > @@ -142,10 +142,10 @@ static int efifb_probe(struct platform_device *dev)
> >         if (!screen_info.pages)
> >                 screen_info.pages = 1;
> >         if (!screen_info.lfb_base) {
> > -               printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
> > +               pr_err("efifb: invalid framebuffer address\n");
> 
> Strip the "efifb: " prefix from all the pr_<level> uses
> 
> 		pr_err("invalid framebuffer address\n");
> 
> > @@ -193,14 +193,14 @@ static int efifb_probe(struct platform_device *dev)
> >         } else {
> >                 /* We cannot make this fatal. Sometimes this comes from magic
> >                    spaces our resource handlers simply don't know about */
> > -               printk(KERN_WARNING
> > +               pr_warn(
> >                        "efifb: cannot reserve video memory at 0x%lx\n",
> >                         efifb_fix.smem_start);
> 
> Move the format to the same line as pr_warn
> 
> 		pr_warn("cannot reserve video memory at 0x%lx\n",
> 
> > @@ -218,18 +218,18 @@ static int efifb_probe(struct platform_device *dev)
> > 
> >         info->screen_base = ioremap_wc(efifb_fix.smem_start, efifb_fix.smem_len);
> >         if (!info->screen_base) {
> > -               printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
> > +               pr_err("efifb: abort, cannot ioremap video memory "
> >                                 "0x%x @ 0x%lx\n",
> >                        efifb_fix.smem_len, efifb_fix.smem_start);
> 
> Coalesce the format and align the arguments
> 
> 		pr_err("abort, cannot ioremap video memory 0x%x @ 0x%lx\n"
> 		       efifb_fix.smem_len, efifb_fix.smem_start);
> 
> You should end up with something like:
> 
> ---
>  drivers/video/fbdev/efifb.c | 57 +++++++++++++++++++++------------------------
>  1 file changed, 27 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 4bfff34..2769bc9 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -6,6 +6,8 @@
>   *
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
> @@ -142,10 +144,10 @@ static int efifb_probe(struct platform_device *dev)
>  	if (!screen_info.pages)
>  		screen_info.pages = 1;
>  	if (!screen_info.lfb_base) {
> -		printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
> +		pr_debug("invalid framebuffer address\n");
>  		return -ENODEV;
>  	}
> -	printk(KERN_INFO "efifb: probing for efifb\n");
> +	pr_info("probing for efifb\n");
>  
>  	/* just assume they're all unset if any are */
>  	if (!screen_info.blue_size) {
> @@ -193,14 +195,13 @@ static int efifb_probe(struct platform_device *dev)
>  	} else {
>  		/* We cannot make this fatal. Sometimes this comes from magic
>  		   spaces our resource handlers simply don't know about */
> -		printk(KERN_WARNING
> -		       "efifb: cannot reserve video memory at 0x%lx\n",
> +		pr_warn("cannot reserve video memory at 0x%lx\n",
>  			efifb_fix.smem_start);
>  	}
>  
>  	info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
>  	if (!info) {
> -		printk(KERN_ERR "efifb: cannot allocate framebuffer\n");
> +		pr_err("cannot allocate framebuffer\n");
>  		err = -ENOMEM;
>  		goto err_release_mem;
>  	}
> @@ -218,26 +219,24 @@ static int efifb_probe(struct platform_device *dev)
>  
>  	info->screen_base = ioremap_wc(efifb_fix.smem_start, efifb_fix.smem_len);
>  	if (!info->screen_base) {
> -		printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
> -				"0x%x @ 0x%lx\n",
> -			efifb_fix.smem_len, efifb_fix.smem_start);
> +		pr_err("abort, cannot ioremap video memory 0x%x @ 0x%lx\n",
> +		       efifb_fix.smem_len, efifb_fix.smem_start);
>  		err = -EIO;
>  		goto err_release_fb;
>  	}
>  
> -	printk(KERN_INFO "efifb: framebuffer at 0x%lx, mapped to 0x%p, "
> -	       "using %dk, total %dk\n",
> -	       efifb_fix.smem_start, info->screen_base,
> -	       size_remap/1024, size_total/1024);
> -	printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
> -	       efifb_defined.xres, efifb_defined.yres,
> -	       efifb_defined.bits_per_pixel, efifb_fix.line_length,
> -	       screen_info.pages);
> +	pr_info("framebuffer at 0x%lx, mapped to 0x%p, using %dk, total %dk\n",
> +		efifb_fix.smem_start, info->screen_base,
> +		size_remap / 1024, size_total / 1024);
> +	pr_info("mode is %dx%dx%d, linelength=%d, pages=%d\n",
> +		efifb_defined.xres, efifb_defined.yres,
> +		efifb_defined.bits_per_pixel, efifb_fix.line_length,
> +		screen_info.pages);
>  
>  	efifb_defined.xres_virtual = efifb_defined.xres;
>  	efifb_defined.yres_virtual = efifb_fix.smem_len /
>  					efifb_fix.line_length;
> -	printk(KERN_INFO "efifb: scrolling: redraw\n");
> +	pr_info("scrolling: redraw\n");
>  	efifb_defined.yres_virtual = efifb_defined.yres;
>  
>  	/* some dummy values for timing to make fbset happy */
> @@ -255,17 +254,15 @@ static int efifb_probe(struct platform_device *dev)
>  	efifb_defined.transp.offset = screen_info.rsvd_pos;
>  	efifb_defined.transp.length = screen_info.rsvd_size;
>  
> -	printk(KERN_INFO "efifb: %s: "
> -	       "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
> -	       "Truecolor",
> -	       screen_info.rsvd_size,
> -	       screen_info.red_size,
> -	       screen_info.green_size,
> -	       screen_info.blue_size,
> -	       screen_info.rsvd_pos,
> -	       screen_info.red_pos,
> -	       screen_info.green_pos,
> -	       screen_info.blue_pos);
> +	pr_info("Truecolor: size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
> +		screen_info.rsvd_size,
> +		screen_info.red_size,
> +		screen_info.green_size,
> +		screen_info.blue_size,
> +		screen_info.rsvd_pos,
> +		screen_info.red_pos,
> +		screen_info.green_pos,
> +		screen_info.blue_pos);
>  
>  	efifb_fix.ypanstep  = 0;
>  	efifb_fix.ywrapstep = 0;
> @@ -276,11 +273,11 @@ static int efifb_probe(struct platform_device *dev)
>  	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;
>  
>  	if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
> -		printk(KERN_ERR "efifb: cannot allocate colormap\n");
> +		pr_err("cannot allocate colormap\n");
>  		goto err_unmap;
>  	}
>  	if ((err = register_framebuffer(info)) < 0) {
> -		printk(KERN_ERR "efifb: cannot register framebuffer\n");
> +		pr_err("cannot register framebuffer\n");
>  		goto err_fb_dealoc;
>  	}
>  	fb_info(info, "%s frame buffer device\n", info->fix.id);
> 
> 
