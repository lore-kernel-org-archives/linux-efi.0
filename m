From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 4/7] arm64/efi: uefi_init error handling fix
Date: Fri, 15 Aug 2014 16:05:44 +0100
Message-ID: <20140815150544.GX27466@arm.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007731-15081-4-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1408007731-15081-4-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 14, 2014 at 10:15:29AM +0100, Dave Young wrote:
> There's one early memmap leak in uefi_init error path, fix it and slightly tune
> the error handling code.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reported-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>

Thanks for fixing this.

Will

> ---
>  arch/arm64/kernel/efi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index e72f310..6ed0362 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -89,7 +89,8 @@ static int __init uefi_init(void)
>  	 */
>  	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
>  		pr_err("System table signature incorrect\n");
> -		return -EINVAL;
> +		retval = -EINVAL;
> +		goto out;
>  	}
>  	if ((efi.systab->hdr.revision >> 16) < 2)
>  		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
> @@ -103,6 +104,7 @@ static int __init uefi_init(void)
>  		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
>  			vendor[i] = c16[i];
>  		vendor[i] = '\0';
> +		early_memunmap(c16, sizeof(vendor));
>  	}
>  
>  	pr_info("EFI v%u.%.02u by %s\n",
> @@ -113,9 +115,8 @@ static int __init uefi_init(void)
>  	if (retval == 0)
>  		set_bit(EFI_CONFIG_TABLES, &efi.flags);
>  
> -	early_memunmap(c16, sizeof(vendor));
> +out:
>  	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
> -
>  	return retval;
>  }
>  
> -- 
> 1.8.3.1
> 
> 
