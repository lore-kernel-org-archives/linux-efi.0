From: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH v2] efi, x86: Add a "debug" option to the efi= cmdline
Date: Thu, 5 Feb 2015 07:45:10 -0500
Message-ID: <20150205124507.GB20082@linuxteamdev.amer.dell.com>
References: <20150105140332.GB3163@console-pimps.org>
 <54AAA723.1070605@redhat.com>
 <54BF3DCA.4070708@jonmasters.org>
 <20150121100633.GC12173@pd.tnic>
 <20150126104936.GB3320@codeblueprint.co.uk>
 <20150130164309.GG1451@pd.tnic>
 <20150205031846.GA1903@darkstar.redhat.com>
 <20150205081143.GA23980@pd.tnic>
 <20150205084139.GA23146@dhcp-16-198.nay.redhat.com>
 <20150205104441.GC23980@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150205104441.GC23980-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jonathan-Zp4isUonpHBD60Wz+7aTrA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

It is better if we add some printk from efifb messages.
Please review the below patch.

>From 7fbac896ab87f1b37646ac2f49bb8216ec330642 Mon Sep 17 00:00:00 2001
From: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
Date: Wed, 4 Feb 2015 06:50:32 -0500
Subject: [PATCH] efi, x86: Add a debug option to the efi= cmdline

Signed-off-by: Parmeshwr Prasad <parmeshwr_prasad-8PEkshWhKlo@public.gmane.org>
---
 drivers/video/fbdev/efifb.c | 49 +++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 4bfff34..505bc56 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -145,7 +145,8 @@ static int efifb_probe(struct platform_device *dev)
                printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
                return -ENODEV;
        }
-       printk(KERN_INFO "efifb: probing for efifb\n");
+       if (efi_enabled(EFI_DBG))
+               printk(KERN_INFO "efifb: probing for efifb\n");

        /* just assume they're all unset if any are */
        if (!screen_info.blue_size) {
@@ -224,20 +225,22 @@ static int efifb_probe(struct platform_device *dev)
                err = -EIO;
                goto err_release_fb;
        }
-
-       printk(KERN_INFO "efifb: framebuffer at 0x%lx, mapped to 0x%p, "
-              "using %dk, total %dk\n",
-              efifb_fix.smem_start, info->screen_base,
-              size_remap/1024, size_total/1024);
-       printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
-              efifb_defined.xres, efifb_defined.yres,
-              efifb_defined.bits_per_pixel, efifb_fix.line_length,
-              screen_info.pages);
+       if (efi_enabled(EFI_DBG)){
+               printk(KERN_INFO "efifb: framebuffer at 0x%lx, mapped to 0x%p, "
+                       "using %dk, total %dk\n",
+                       efifb_fix.smem_start, info->screen_base,
+                       size_remap/1024, size_total/1024);
+               printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
+                       efifb_defined.xres, efifb_defined.yres,
+                       efifb_defined.bits_per_pixel, efifb_fix.line_length,
+                       screen_info.pages);
+       }

        efifb_defined.xres_virtual = efifb_defined.xres;
        efifb_defined.yres_virtual = efifb_fix.smem_len /
                                        efifb_fix.line_length;
-       printk(KERN_INFO "efifb: scrolling: redraw\n");
+       if (efi_enabled(EFI_DBG))
+               printk(KERN_INFO "efifb: scrolling: redraw\n");
        efifb_defined.yres_virtual = efifb_defined.yres;

        /* some dummy values for timing to make fbset happy */
@@ -255,17 +258,19 @@ static int efifb_probe(struct platform_device *dev)
        efifb_defined.transp.offset = screen_info.rsvd_pos;
        efifb_defined.transp.length = screen_info.rsvd_size;

-       printk(KERN_INFO "efifb: %s: "
-              "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
-              "Truecolor",
-              screen_info.rsvd_size,
-              screen_info.red_size,
-              screen_info.green_size,
-              screen_info.blue_size,
-              screen_info.rsvd_pos,
-              screen_info.red_pos,
-              screen_info.green_pos,
-              screen_info.blue_pos);
+       if (efi_enabled(EFI_DBG)){
+               printk(KERN_INFO "efifb: %s: "
+                      "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
+                      "Truecolor",
+                      screen_info.rsvd_size,
+                      screen_info.red_size,
+                      screen_info.green_size,
+                      screen_info.blue_size,
+                      screen_info.rsvd_pos,
+                      screen_info.red_pos,
+                      screen_info.green_pos,
+                      screen_info.blue_pos);
+       }

        efifb_fix.ypanstep  = 0;
        efifb_fix.ywrapstep = 0;
--
1.9.3

On Thu, Feb 05, 2015 at 04:44:41AM -0600, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Subject: [PATCH v2] efi, x86: Add a "debug" option to the efi= cmdline
> 
> ... and hide the memory regions dump behind it. Make it default-off.
> 
> Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Link: http://lkml.kernel.org/r/20141209095843.GA3990-fF5Pk5pvG8Y@public.gmane.org
> Acked-by: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/kernel-parameters.txt | 3 ++-
>  arch/x86/platform/efi/efi.c         | 5 ++++-
>  include/linux/efi.h                 | 1 +
>  3 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 176d4fe4f076..101ab5601c2d 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1024,7 +1024,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Format: {"off" | "on" | "skip[mbr]"}
>  
>  	efi=		[EFI]
> -			Format: { "old_map", "nochunk", "noruntime" }
> +			Format: { "old_map", "nochunk", "noruntime", "debug" }
>  			old_map [X86-64]: switch to the old ioremap-based EFI
>  			runtime services mapping. 32-bit still uses this one by
>  			default.
> @@ -1032,6 +1032,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			boot stub, as chunking can cause problems with some
>  			firmware implementations.
>  			noruntime : disable EFI runtime services support
> +			debug: enable misc debug output
>  
>  	efi_no_storage_paranoia [EFI; X86]
>  			Using this parameter you can use more than 50% of
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index dbc8627a5cdf..e859d56ce9f8 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -491,7 +491,8 @@ void __init efi_init(void)
>  	if (efi_memmap_init())
>  		return;
>  
> -	print_efi_memmap();
> +	if (efi_enabled(EFI_DBG))
> +		print_efi_memmap();
>  }
>  
>  void __init efi_late_init(void)
> @@ -939,6 +940,8 @@ static int __init arch_parse_efi_cmdline(char *str)
>  {
>  	if (parse_option_str(str, "old_map"))
>  		set_bit(EFI_OLD_MEMMAP, &efi.flags);
> +	if (parse_option_str(str, "debug"))
> +		set_bit(EFI_DBG, &efi.flags);
>  
>  	return 0;
>  }
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 0238d612750e..14cec75d7e74 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -940,6 +940,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
>  #define EFI_PARAVIRT		6	/* Access is via a paravirt interface */
>  #define EFI_ARCH_1		7	/* First arch-specific bit */
> +#define EFI_DBG			8	/* Print additional debug info at runtime */
>  
>  #ifdef CONFIG_EFI
>  /*
> -- 
> 2.2.0.33.gc18b867
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> ECO tip #101: Trim your mails when you reply.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
