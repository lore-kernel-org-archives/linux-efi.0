From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi/arm64: handle missing virtual mapping for UEFI
 System Table
Date: Fri, 4 Jul 2014 16:51:18 +0200
Message-ID: <CAKv+Gu9U4A-MmgDNw-R0gUxybtR7fhMMXpktimEhB7A0YWzcSQ@mail.gmail.com>
References: <1404468997-6925-1-git-send-email-ard.biesheuvel@linaro.org>
	<1404484941.19665.56.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404484941.19665.56.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(adding Catalin)

On 4 July 2014 16:42, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2014-07-04 at 12:16 +0200, Ard Biesheuvel wrote:
>> If we cannot resolve the virtual address of the UEFI System Table, its physical
>> offset must be missing from the virtual memory map, and there is really no point
>> in proceeding with installing the virtual memory map and the runtime services
>> dispatch table. So back out gracefully.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>
>> v2:
>> - release mappings and free virtmap before bailing
>>
>>  arch/arm64/kernel/efi.c | 28 ++++++++++++++++++++++++++--
>>  1 file changed, 26 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> index 56c3327bbf79..23942158e0f8 100644
>> --- a/arch/arm64/kernel/efi.c
>> +++ b/arch/arm64/kernel/efi.c
>> @@ -416,11 +416,23 @@ static int __init arm64_enter_virtual_mode(void)
>>                       continue;
>>               if (remap_region(md, &virt_md))
>>                       ++count;
>> +             else
>> +                     goto err_unmap;
>
> How about:
>                 if (!remap_region(md, &virt_md))
>                         goto err_unmap;
>                 ++count;
>
>

Sure.

>>       }
>>
>>       efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
>> -     if (efi.systab)
>> -             set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>> +     if (!efi.systab) {
>> +             /*
>> +              * If we have no virtual mapping for the System Table at this
>> +              * point, the memory map doesn't cover the physical offset where
>> +              * it resides. This means the System Table will be inaccessible
>> +              * to Runtime Services themselves once the virtual mapping is
>> +              * installed.
>> +              */
>> +             pr_err("Failed to remap EFI System Table -- buggy firmware?\n");
>> +             goto err_unmap;
>> +     }
>> +     set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>>
>>       local_irq_save(flags);
>>       cpu_switch_mm(idmap_pg_dir, &init_mm);
>> @@ -453,5 +465,17 @@ static int __init arm64_enter_virtual_mode(void)
>>       set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>>
>>       return 0;
>> +
>> +err_unmap:
>> +     /* unmap all mappings that succeeded: there are 'count' of those */
>> +     for_each_efi_memory_desc(&memmap, md) {
>> +             if (!(md->attribute & EFI_MEMORY_RUNTIME))
>> +                     continue;
>> +             if (!count--)
>> +                     break;
>> +             iounmap((__force void *)md->virt_addr);
>> +     }
>
> This is wrong. memmap still belongs to UEFI and hasn't been touched. The
> new mappings are in virtmap. So, it is even simpler:
>
>         /* unmap all mappings that succeeded: there are 'count' of those */
>         for (virt_md = virtmap; count; virt_md++, count--)
>                 iounmap((__force void __iomem *)virt_md->virt_addr);
>

Yes, you're right. Will respin.

-- 
Ard.
