From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/8] efi: efifb: use builtin_platform_driver and drop
 unused includes
Date: Fri, 18 Mar 2016 10:52:20 +0000
Message-ID: <20160318105220.GN2619@codeblueprint.co.uk>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
 <1457588408-19309-6-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457588408-19309-6-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Cc'ing Peter.

On Thu, 10 Mar, at 12:40:05PM, Ard Biesheuvel wrote:
> Since efifb can only be built directly into the kernel, drop the module
> specific includes and definitions. Drop some other includes we don't need
> as well.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/video/fbdev/efifb.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index dd594369b8a6..f4c045c0051c 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -6,15 +6,12 @@
>   *
>   */
>  
> -#include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/efi.h>
>  #include <linux/errno.h>
>  #include <linux/fb.h>
>  #include <linux/platform_device.h>
>  #include <linux/screen_info.h>
> -#include <linux/dmi.h>
> -#include <linux/pci.h>
>  #include <video/vga.h>
>  #include <asm/efi.h>
>  
> @@ -331,5 +328,4 @@ static struct platform_driver efifb_driver = {
>  	.remove = efifb_remove,
>  };
>  
> -module_platform_driver(efifb_driver);
> -MODULE_LICENSE("GPL");
> +builtin_platform_driver(efifb_driver);
> -- 
> 1.9.1
> 
