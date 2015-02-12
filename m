From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: get_memory_map: add sufficient slack for memory descriptors
Date: Thu, 12 Feb 2015 03:21:32 -0500
Message-ID: <CAFECyb_e9HgsdDDD9bLhurDbi3qWOckEcWqQSsRLk6nDTCzLJg@mail.gmail.com>
References: <1423718659-795-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423718659-795-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 12, 2015 at 12:24 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> As it turns out, when allocating room for the UEFI memory map using
> UEFI's AllocatePool (), it may result in two new memory map entries
> being created, for instance, when using Tianocore's preallocated region
> feature. For example, the following region
>
> 0x00005ead5000-0x00005ebfffff [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC]
>
> may be split like this
>
> 0x00005ead5000-0x00005eae2fff [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC]
> 0x00005eae3000-0x00005eae4fff [Loader Data        |   |  |  |  |   |WB|WT|WC|UC]
> 0x00005eae5000-0x00005ebfffff [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC]
>
> if the preallocated Loader Data region was chosen to be right in the
> middle of the original free space.
>
> After patch d1a8d66b9177 ("efi/libstub: Call get_memory_map() to
> obtain map and desc sizes"), this is not being dealt with correctly
> anymore, as the existing logic to allocate room for a single additional
> entry has become insufficient.
>
> So instead, add room for two additional entries instead.
>
> Fixes: d1a8d66b9177 ("efi/libstub: Call get_memory_map() to obtain map and desc sizes")
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index af5d63c7cc53..ca0b07ed3b14 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -84,10 +84,10 @@ efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
>                 return EFI_LOAD_ERROR;
>
>         /*
> -        * Add an additional efi_memory_desc_t because we're doing an
> -        * allocation which may be in a new descriptor region.
> +        * Add room for two additional efi_memory_desc_t entries because we're
> +        * doing an allocation which may be in a new descriptor region.
>          */
> -       *map_size += *desc_size;
> +       *map_size += *desc_size * 2;
>         status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
>                                 *map_size, (void **)&m);
>         if (status != EFI_SUCCESS)
> --
> 1.8.3.2
>

Reviewed-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
