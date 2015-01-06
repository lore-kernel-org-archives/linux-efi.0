From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/8] arm64/efi: use UEFI memory map unconditionally if
 available
Date: Tue, 6 Jan 2015 09:04:07 +0000
Message-ID: <20150106090407.GF3163@console-pimps.org>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
 <1419275322-29811-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1419275322-29811-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 22 Dec, at 07:08:35PM, Ard Biesheuvel wrote:
> On systems that boot via UEFI, all memory nodes are deleted from the
> device tree, and instead, the size and location of system RAM is derived
> from the UEFI memory map. This is handled by reserve_regions, which not only
> reserves parts of memory that UEFI declares as reserved, but also installs
> the memblocks that cover the remaining usable memory.
> 
> Currently, reserve_regions() is only called if uefi_init() succeeds.
> However, it does not actually depend on anything that uefi_init() does,
> and not calling reserve_regions() results in a broken boot, so it is
> better to just call it unconditionally.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index d7d2e818c856..d2f483a7cffe 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -208,8 +208,7 @@ void __init efi_init(void)
>  	memmap.desc_size = params.desc_size;
>  	memmap.desc_version = params.desc_ver;
>  
> -	if (uefi_init() < 0)
> -		return;
> +	WARN_ON(uefi_init() < 0);
>  
>  	reserve_regions();
>  }
> @@ -218,15 +217,13 @@ static int __init arm64_enter_virtual_mode(void)
>  {
>  	u64 mapsize;
>  
> -	if (!efi_enabled(EFI_BOOT)) {
> -		pr_info("EFI services will not be available.\n");
> -		return -1;
> -	}
> +	if (!efi_enabled(EFI_MEMMAP))
> +		return 0;
>  
>  	mapsize = memmap.map_end - memmap.map;
>  	early_memunmap(memmap.map, mapsize);
>  
> -	if (efi_runtime_disabled()) {
> +	if (!efi_enabled(EFI_BOOT) || efi_runtime_disabled()) {
>  		pr_info("EFI runtime services will be disabled.\n");
>  		return -1;
>  	}

Am I correct in thinking that it's possible to have EFI_MEMMAP set but
not EFI_BOOT? That's not how things work on x86. EFI_BOOT means "I am an
EFI-enabled platform and I was booted using EFI."

In other words, EFI_MEMMAP should imply EFI_BOOT (how did you get the
memmap if you weren't booted using EFI?)

It looks like you should be setting EFI_BOOT (and EFI_64BIT) in
efi_init() if efi_get_fdt_params() succeeds.

-- 
Matt Fleming, Intel Open Source Technology Center
