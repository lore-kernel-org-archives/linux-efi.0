From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: arm: stop printing addresses of virtual mappings
Date: Fri, 19 Jan 2018 14:38:37 +0000
Message-ID: <20180119143836.uxcv4smmu2gewasj@bivouac.eciton.net>
References: <20180119122619.16023-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180119122619.16023-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 19, 2018 at 12:26:19PM +0000, Ard Biesheuvel wrote:
> With the recent %p -> %px changes, we now get something like this in
> the kernel boot log on ARM/arm64 EFI systems:
> 
>      Remapping and enabling EFI services.
>        EFI remap 0x00000087fb830000 =>         (ptrval)
>        EFI remap 0x00000087fbdb0000 =>         (ptrval)
>        EFI remap 0x00000087fffc0000 =>         (ptrval)
> 
> The physical addresses of the UEFI runtime regions will also be
> printed when booting with the efi=debug command line option, and the
> virtual addresses can be inspected via /sys/kernel/debug/efi_page_tables
> (if enabled). So let's just remove the lines above.

As long as the efi=debug functionality is kept, I have no issue with this.
Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/arm-runtime.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> index 1cc41c3d6315..5d4c8b661548 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -80,10 +80,7 @@ static bool __init efi_virtmap_init(void)
>  			return false;
>  
>  		ret = efi_create_mapping(&efi_mm, md);
> -		if  (!ret) {
> -			pr_info("  EFI remap %pa => %p\n",
> -				&phys, (void *)(unsigned long)md->virt_addr);
> -		} else {
> +		if (ret) {
>  			pr_warn("  EFI remap %pa: failed to create mapping (%d)\n",
>  				&phys, ret);
>  			return false;
> -- 
> 2.11.0
> 
