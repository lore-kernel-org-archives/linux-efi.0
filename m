From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: fix the wrong check for the offset of subnode
Date: Wed, 24 Aug 2016 15:28:18 +0100
Message-ID: <20160824142818.GX30909@codeblueprint.co.uk>
References: <1472005090-5871-1-git-send-email-shawn.lin@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472005090-5871-1-git-send-email-shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Cc'ing Mark and other folks)

On Wed, 24 Aug, at 10:18:10AM, Shawn Lin wrote:
> of_get_flat_dt_subnode_by_name return the offset of
> the subnode, and we should check if it's valid. But
> the original code use the unsigned type to check it,
> which makes the we always get subnode successfully
> even if returning -FDT_ERR_BADPATH etc. Let's fix it
> by adding offset variable.
> 
> Suggested-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Shawn Lin <shawn.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> ---
> 
>  drivers/firmware/efi/efi.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
 
There's already a patch queued up in the 'urgent' branch for this
issue,

  https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=urgent&id=b7453c7a235c597b44c365887e57e7c300e72bf0

If your patch is superior in some way please mention that in the patch
description.

> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 5a2631a..7a5964e 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -647,6 +647,7 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>  {
>  	struct param_info *info = data;
>  	int i;
> +	int offset = node;
>  
>  	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
>  		const char *subnode = dt_params[i].subnode;
> @@ -657,12 +658,12 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>  		}
>  
>  		if (subnode) {
> -			node = of_get_flat_dt_subnode_by_name(node, subnode);
> -			if (node < 0)
> +			offset = of_get_flat_dt_subnode_by_name(node, subnode);
> +			if (offset < 0)
>  				return 0;
>  		}
>  
> -		return __find_uefi_params(node, info, dt_params[i].params);
> +		return __find_uefi_params(offset, info, dt_params[i].params);
>  	}
>  
>  	return 0;
> -- 
> 2.3.7
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
