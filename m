From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: handle potential failure to remap memory map
Date: Thu, 15 Jan 2015 11:50:47 -0500
Message-ID: <1421340647.22837.2.camel@deneb.redhat.com>
References: <1421323266-30973-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421323266-30973-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-01-15 at 12:01 +0000, Ard Biesheuvel wrote:
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

Somewhat unrelated but we should unmap memmap.map if the efi.systab
mapping fails.

Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
