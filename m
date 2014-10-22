From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/10] arm64/efi: use UEFI memory map unconditionally if available
Date: Wed, 22 Oct 2014 19:20:34 +0200
Message-ID: <CAKv+Gu-zy-3uGtq4a9EmRBLDsG5Q0vf32_=g7+x0p4HyrXEhxg@mail.gmail.com>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
	<1413987713-30528-7-git-send-email-ard.biesheuvel@linaro.org>
	<1413997616.2985.74.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413997616.2985.74.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yi Li <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 October 2014 19:06, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2014-10-22 at 16:21 +0200, Ard Biesheuvel wrote:
>> On systems that boot via UEFI, all memory nodes are deleted from the
>> device tree, and instead, the size and location of system RAM is derived
>> from the UEFI memory map. This is handled by reserve_regions, which not only
>> reserves parts of memory that UEFI declares as reserved, but also installs
>> the memblocks that cover the remaining usable memory.
>>
>> Currently, reserve_regions() is only called if uefi_init() succeeds.
>> However, it does not actually depend on anything that uefi_init() does,
>> and not calling reserve_regions() results in a broken boot, so it is
>> better to just call it unconditionally.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/kernel/efi.c | 11 ++++-------
>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> index 51522ab0c6da..4cec21b1ecdd 100644
>> --- a/arch/arm64/kernel/efi.c
>> +++ b/arch/arm64/kernel/efi.c
>> @@ -313,8 +313,7 @@ void __init efi_init(void)
>>       memmap.desc_size = params.desc_size;
>>       memmap.desc_version = params.desc_ver;
>>
>> -     if (uefi_init() < 0)
>> -             return;
>> +     WARN_ON(uefi_init() < 0);
>>
>>       reserve_regions();
>>  }
>
> It also looks like EFI_BOOT flag will be set even if uefi_init fails.
> If uefi_init fails, we only need reserve_regions() for the purpose
> of adding memblocks. Otherwise, we end up wasting a lot of memory.

Indeed. But perhaps it would be cleaner to add the memblocks in a
separate function that gets called before uefi_init(), let
reserve_regions() do just what it name implies, and retain the above
hunk so that the reserve_regions() call is only performed if UEFI
initialized correctly.

-- 
Ard.


> So, something like this would also be needed:
>
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 03aaa99..5a6e189 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -81,9 +81,6 @@ static int __init uefi_init(void)
>                 return -ENOMEM;
>         }
>
> -       set_bit(EFI_BOOT, &efi.flags);
> -       set_bit(EFI_64BIT, &efi.flags);
> -
>         /*
>          * Verify the EFI Table
>          */
> @@ -109,6 +106,9 @@ static int __init uefi_init(void)
>                 efi.systab->hdr.revision >> 16,
>                 efi.systab->hdr.revision & 0xffff, vendor);
>
> +       set_bit(EFI_BOOT, &efi.flags);
> +       set_bit(EFI_64BIT, &efi.flags);
> +
>         retval = efi_config_init(NULL);
>         if (retval == 0)
>                 set_bit(EFI_CONFIG_TABLES, &efi.flags);
> @@ -177,9 +177,10 @@ static __init void reserve_regions(void)
>                 if (is_normal_ram(md))
>                         early_init_dt_add_memory_arch(paddr, size);
>
> -               if (is_reserve_region(md) ||
> -                   md->type == EFI_BOOT_SERVICES_CODE ||
> -                   md->type == EFI_BOOT_SERVICES_DATA) {
> +               if (efi_enabled(EFI_BOOT) &&
> +                   (is_reserve_region(md) ||
> +                    md->type == EFI_BOOT_SERVICES_CODE ||
> +                    md->type == EFI_BOOT_SERVICES_DATA)) {
>                         memblock_reserve(paddr, size);
>                         if (uefi_debug)
>                                 pr_cont("*");
>
>> @@ -374,15 +373,13 @@ static int __init arm64_enter_virtual_mode(void)
>>       int count = 0;
>>       unsigned long flags;
>>
>> -     if (!efi_enabled(EFI_BOOT)) {
>> -             pr_info("EFI services will not be available.\n");
>> -             return -1;
>> -     }
>> +     if (!efi_enabled(EFI_MEMMAP))
>> +             return 0;
>>
>>       mapsize = memmap.map_end - memmap.map;
>>       early_memunmap(memmap.map, mapsize);
>>
>> -     if (efi_runtime_disabled()) {
>> +     if (!efi_enabled(EFI_BOOT) || efi_runtime_disabled()) {
>>               pr_info("EFI runtime services will be disabled.\n");
>>               return -1;
>>       }
>
>
