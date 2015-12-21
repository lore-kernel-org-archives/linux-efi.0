From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/4] efi: add NV memory attribute
Date: Mon, 21 Dec 2015 15:54:36 +0000
Message-ID: <20151221155436.GE4227@codeblueprint.co.uk>
References: <1450402114-3606-1-git-send-email-elliott@hpe.com>
 <1450402114-3606-3-git-send-email-elliott@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450402114-3606-3-git-send-email-elliott-ZPxbGqLxI0U@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Cc'ing people that have worked in this area recently)

On Thu, 17 Dec, at 07:28:32PM, Robert Elliott wrote:
> Add the NV memory attribute introduced in UEFI 2.5 and add a column
> for it in the types and attributes string used when printing the UEFI
> memory map.
> 
> old:
> efi: mem61: [type=14            |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> 
> new:
> efi: mem61: [type=14            |   |  |NV|  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> 
> Signed-off-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 5 ++++-
>  include/linux/efi.h        | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 027ca21..4dd5464 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -611,13 +611,16 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>  	if (attr & ~(EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT |
>  		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_RO |
>  		     EFI_MEMORY_WP | EFI_MEMORY_RP | EFI_MEMORY_XP |
> +		     EFI_MEMORY_NV |
>  		     EFI_MEMORY_RUNTIME | EFI_MEMORY_MORE_RELIABLE))
>  		snprintf(pos, size, "|attr=0x%016llx]",
>  			 (unsigned long long)attr);
>  	else
> -		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> +		snprintf(pos, size,
> +			 "|%3s|%2s|%2s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
>  			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
>  			 attr & EFI_MEMORY_MORE_RELIABLE ? "MR" : "",
> +			 attr & EFI_MEMORY_NV      ? "NV"  : "",
>  			 attr & EFI_MEMORY_XP      ? "XP"  : "",
>  			 attr & EFI_MEMORY_RP      ? "RP"  : "",
>  			 attr & EFI_MEMORY_WP      ? "WP"  : "",
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 569b5a8..9ce9e9e 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -97,6 +97,7 @@ typedef	struct {
>  #define EFI_MEMORY_WP		((u64)0x0000000000001000ULL)	/* write-protect */
>  #define EFI_MEMORY_RP		((u64)0x0000000000002000ULL)	/* read-protect */
>  #define EFI_MEMORY_XP		((u64)0x0000000000004000ULL)	/* execute-protect */
> +#define EFI_MEMORY_NV		((u64)0x0000000000008000ULL)	/* non-volatile */
>  #define EFI_MEMORY_MORE_RELIABLE \
>  				((u64)0x0000000000010000ULL)	/* higher reliability */
>  #define EFI_MEMORY_RO		((u64)0x0000000000020000ULL)	/* read-only */

Seems straight forward to me.

Applied, thanks.
