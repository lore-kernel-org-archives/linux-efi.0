From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: handle potential failure to remap memory map
Date: Thu, 15 Jan 2015 16:40:11 +0000
Message-ID: <20150115164010.GK16217@leverpostej>
References: <1421323266-30973-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421323266-30973-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 15, 2015 at 12:01:06PM +0000, Ard Biesheuvel wrote:
> When remapping the UEFI memory map using ioremap_cache(), we
> have to deal with potential failure. Note that, even if the
> common case is for ioremap_cache() to return the existing linear
> mapping of the memory map, we cannot rely on that to be always the
> case, e.g., in the presence of a mem= kernel parameter.
> 
> At the same time, remove a stale comment and move the memmap code
> together.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

This should probably be picked up before my mem= patch, which I will be
resending shortly. I'll mention that when posting.

I guess Catalin should pick this up given the other portions are in the
arm64 tree, and this falls under arch/arm64.

Thanks,
Mark.

> ---
>  arch/arm64/kernel/efi.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index a98415b5979c..c9cb0fbe7aa4 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -229,19 +229,21 @@ static int __init arm64_enable_runtime_services(void)
>  		return -1;
>  	}
>  
> -	mapsize = memmap.map_end - memmap.map;
> -
>  	if (efi_runtime_disabled()) {
>  		pr_info("EFI runtime services will be disabled.\n");
>  		return -1;
>  	}
>  
>  	pr_info("Remapping and enabling EFI services.\n");
> -	/* replace early memmap mapping with permanent mapping */
> +
> +	mapsize = memmap.map_end - memmap.map;
>  	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
>  						   mapsize);
> +	if (!memmap.map) {
> +		pr_err("Failed to remap EFI memory map\n");
> +		return -1;
> +	}
>  	memmap.map_end = memmap.map + mapsize;
> -
>  	efi.memmap = &memmap;
>  
>  	efi.systab = (__force void *)ioremap_cache(efi_system_table,
> -- 
> 1.8.3.2
> 
> 
