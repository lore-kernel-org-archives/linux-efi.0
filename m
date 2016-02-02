From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/14] efi: Add NV memory attribute
Date: Tue, 2 Feb 2016 09:54:24 +0100
Message-ID: <56B06EC0.3000009@redhat.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-13-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454364428-494-13-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 02/01/16 23:07, Matt Fleming wrote:
> From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> 
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
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 5 ++++-
>  include/linux/efi.h        | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 0cd8f039602e..9c8c0747c8cd 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -580,13 +580,16 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
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
> index f468f7c53236..99b88c5a6770 100644
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
> 

Reviewed-by: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
