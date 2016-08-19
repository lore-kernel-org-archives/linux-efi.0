From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: fix handling error value in fdt_find_uefi_params
Date: Fri, 19 Aug 2016 13:30:26 +0100
Message-ID: <20160819123026.GV30909@codeblueprint.co.uk>
References: <1471428040-23463-1-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471428040-23463-1-git-send-email-a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: "open list:EXTENSIBLE FIRMWARE INTERFACE (EFI)" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 17 Aug, at 12:00:40PM, Andrzej Hajda wrote:
> of_get_flat_dt_subnode_by_name can return negative value in case of error.
> 
> The problem has been detected using semantic patch
> scripts/coccinelle/tests/unsigned_lesser_than_zero.cocci
> 
> Signed-off-by: Andrzej Hajda <a.hajda-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 5a2631a..7dd2e2d 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -657,9 +657,12 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>  		}
>  
>  		if (subnode) {
> -			node = of_get_flat_dt_subnode_by_name(node, subnode);
> -			if (node < 0)
> +			int err = of_get_flat_dt_subnode_by_name(node, subnode);
> +
> +			if (err < 0)
>  				return 0;
> +
> +			node = err;
>  		}
>  
>  		return __find_uefi_params(node, info, dt_params[i].params);
> -- 
> 1.9.1
 
Looks good to me. Thanks, applied.
