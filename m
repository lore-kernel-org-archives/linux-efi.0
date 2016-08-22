From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi: simply the fdt_find_uefi_params
Date: Mon, 22 Aug 2016 11:01:47 +0100
Message-ID: <20160822100147.GA29671@leverpostej>
References: <1471852761-9913-1-git-send-email-shawn.lin@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471852761-9913-1-git-send-email-shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 22, 2016 at 03:59:21PM +0800, Shawn Lin wrote:
> Remove the check of node as it should never be
> less then zero dut to its tupe is unsigned long.
> 
> Signed-off-by: Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> ---
> 
>  drivers/firmware/efi/efi.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 5a2631a..96261ce 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -656,11 +656,8 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>  			continue;
>  		}
>  
> -		if (subnode) {
> +		if (subnode)
>  			node = of_get_flat_dt_subnode_by_name(node, subnode);
> -			if (node < 0)
> -				return 0;
> -		}

This isn't right, given of_get_flat_dt_subnode_by_name return a (signed)
int, and can return negative values (e.g. -FDT_ERR_BADPATH).

Other core parts of the flat DT code (including libfdt) use an int to
store the node offset, so I believe it should be fine to do the same
here instead.

i.e. we should make the node parameter an int.

Thanks,
Mark.

>  
>  		return __find_uefi_params(node, info, dt_params[i].params);
>  	}
> -- 
> 2.3.7
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
