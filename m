From: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi: add support for EFI_MEMORY_RO attribute introduced
 by UEFIv2.5
Date: Wed, 24 Jun 2015 13:47:21 +0200
Message-ID: <558A98C9.5000306@redhat.com>
References: <1435142544-10014-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435142544-10014-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 06/24/15 12:42, Ard Biesheuvel wrote:
> The UEFI spec v2.5 introduces a new memory attribute EFI_MEMORY_RO,
> which is now the preferred attribute to convey that the nature of
> the contents of such a region allows it to be mapped read-only
> (i.e., it contains .text and .rodata only). The specification of
> the existing EFI_MEMORY_WP attribute has been updated to align
> more closely with its common use as a cacheability attribute rather
> than a permission attribute.
> 
> Add the #define and add the attribute to the memory map dumping
> routine.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 8 +++++---
>  include/linux/efi.h        | 1 +
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 03a6b313568c..7c4c2202b663 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -502,16 +502,18 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>  
>  	attr = md->attribute;
>  	if (attr & ~(EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT |
> -		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_WP |
> -		     EFI_MEMORY_RP | EFI_MEMORY_XP | EFI_MEMORY_RUNTIME))
> +		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_RO |
> +		     EFI_MEMORY_WP | EFI_MEMORY_RP | EFI_MEMORY_XP |
> +		     EFI_MEMORY_RUNTIME))
>  		snprintf(pos, size, "|attr=0x%016llx]",
>  			 (unsigned long long)attr);
>  	else
> -		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
> +		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
>  			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
>  			 attr & EFI_MEMORY_XP      ? "XP"  : "",
>  			 attr & EFI_MEMORY_RP      ? "RP"  : "",
>  			 attr & EFI_MEMORY_WP      ? "WP"  : "",
> +			 attr & EFI_MEMORY_RO      ? "RO"  : "",
>  			 attr & EFI_MEMORY_UCE     ? "UCE" : "",
>  			 attr & EFI_MEMORY_WB      ? "WB"  : "",
>  			 attr & EFI_MEMORY_WT      ? "WT"  : "",
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index af5be0368dec..407e1e6ef29e 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -96,6 +96,7 @@ typedef	struct {
>  #define EFI_MEMORY_WP		((u64)0x0000000000001000ULL)	/* write-protect */
>  #define EFI_MEMORY_RP		((u64)0x0000000000002000ULL)	/* read-protect */
>  #define EFI_MEMORY_XP		((u64)0x0000000000004000ULL)	/* execute-protect */
> +#define EFI_MEMORY_RO		((u64)0x0000000000020000ULL)	/* read-only */
>  #define EFI_MEMORY_RUNTIME	((u64)0x8000000000000000ULL)	/* range requires runtime mapping */
>  #define EFI_MEMORY_DESCRIPTOR_VERSION	1
>  
> 

Reviewed-by: Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
