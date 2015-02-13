From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: get_memory_map: add sufficient slack for memory descriptors
Date: Sat, 14 Feb 2015 00:23:52 +0800
Message-ID: <4582A14D-E69B-459E-BC9E-F642B098D061@linaro.org>
References: <1423718659-795-1-git-send-email-ard.biesheuvel@linaro.org> <20150212102226.GB1245@leverpostej> <CAKv+Gu88vzPpXoSEs1ZSQbO7wsqh7NRSZc=iSpC9D6vzus7f8g@mail.gmail.com> <20150212144727.GD4665@codeblueprint.co.uk> <CAKv+Gu-NAKASZc4phj5x83mB8Ak4Gy2zYq-a0CDADEOTBD4pXA@mail.gmail.com> <20150212151607.GH1522@leverpostej> <CAKv+Gu_Z0Upoy0J-hxf0i7Oen00tb-TENJ9CszdEtTHsb5pGSg@mail.gmail.com> <20150213160448.GA30567@codeblueprint.co.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150213160448.GA30567-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


> On 14 Feb 2015, at 00:04, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
>> On Thu, 12 Feb, at 11:31:02PM, Ard Biesheuvel wrote:
>> 
>> Actually, looking again at the original patch, it appears that my
>> analysis was incorrect regarding the possibility that the loop would
>> never terminate. The only thing that could happen if desc_size >
>> sizeof(efi_memory_desc_t) is that you need two iterations instead of
>> one to get a pool allocation that is of sufficient size.
>> So perhaps it is better to just revert the patch.
>> 
>> My apologies for the hassle.
> 
> This is what I've got queued up,
> 

Acked-by: Ard Biesheuvel <ard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks Matt

> ---
> 
> From 3f281b98ffc99e604a3988aa93304a3a591eeeb5 Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Date: Fri, 13 Feb 2015 15:46:56 +0000
> Subject: [PATCH] Revert "efi/libstub: Call get_memory_map() to obtain map and
> desc sizes"
> 
> This reverts commit d1a8d66b9177105e898e73716f97eb61842c457a.
> 
> Ard reported a boot failure when running UEFI under Qemu and Xen and
> experimenting with various Tianocore build options,
> 
> "As it turns out, when allocating room for the UEFI memory map using
>  UEFI's AllocatePool (), it may result in two new memory map entries
>  being created, for instance, when using Tianocore's preallocated region
>  feature. For example, the following region
> 
>  0x00005ead5000-0x00005ebfffff [Conventional Memory|   |  |  |  |  |WB|WT|WC|UC]
> 
>  may be split like this
> 
>  0x00005ead5000-0x00005eae2fff [Conventional Memory|   |  |  |  |  |WB|WT|WC|UC]
>  0x00005eae3000-0x00005eae4fff [Loader Data        |   |  |  |  |  |WB|WT|WC|UC]
>  0x00005eae5000-0x00005ebfffff [Conventional Memory|   |  |  |  |  |WB|WT|WC|UC]
> 
>  if the preallocated Loader Data region was chosen to be right in the
>  middle of the original free space.
> 
>  After patch d1a8d66b9177 ("efi/libstub: Call get_memory_map() to
>  obtain map and desc sizes"), this is not being dealt with correctly
>  anymore, as the existing logic to allocate room for a single additional
>  entry has become insufficient."
> 
> Mark requested to reinstate the old loop we had before commit
> d1a8d66b9177, which grows the memory map buffer until it's big enough to
> hold the EFI memory map.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> drivers/firmware/efi/libstub/efi-stub-helper.c | 16 ++++++----------
> 1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index d073e3946383..9bd9fbb5bea8 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -66,29 +66,25 @@ efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
>    unsigned long key;
>    u32 desc_version;
> 
> -    *map_size = 0;
> -    *desc_size = 0;
> -    key = 0;
> -    status = efi_call_early(get_memory_map, map_size, NULL,
> -                &key, desc_size, &desc_version);
> -    if (status != EFI_BUFFER_TOO_SMALL)
> -        return EFI_LOAD_ERROR;
> -
> +    *map_size = sizeof(*m) * 32;
> +again:
>    /*
>     * Add an additional efi_memory_desc_t because we're doing an
>     * allocation which may be in a new descriptor region.
>     */
> -    *map_size += *desc_size;
> +    *map_size += sizeof(*m);
>    status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
>                *map_size, (void **)&m);
>    if (status != EFI_SUCCESS)
>        goto fail;
> 
> +    *desc_size = 0;
> +    key = 0;
>    status = efi_call_early(get_memory_map, map_size, m,
>                &key, desc_size, &desc_version);
>    if (status == EFI_BUFFER_TOO_SMALL) {
>        efi_call_early(free_pool, m);
> -        return EFI_LOAD_ERROR;
> +        goto again;
>    }
> 
>    if (status != EFI_SUCCESS)
> -- 
> 1.9.3
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
