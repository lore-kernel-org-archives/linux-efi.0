From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/11] efi: Refactor efi_memmap_init_early() into arch-neutral code
Date: Tue, 5 Jul 2016 06:24:01 +0800
Message-ID: <AC2EF16D-8E14-488A-814B-9C308F883EE1@linaro.org>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk> <1466681690-5850-4-git-send-email-matt@codeblueprint.co.uk> <CAKv+Gu_n9eVL6mNtrLQWdCwde9oLfkGYV5CnqLhSPO31Aehpzw@mail.gmail.com> <20160704121952.GK8415@codeblueprint.co.uk>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160704121952.GK8415-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


> On 4 jul. 2016, at 20:19, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
>> On Fri, 24 Jun, at 01:44:48PM, Ard Biesheuvel wrote:
>> 
>> This assignment breaks the calculation of mapsize in
>> arm_enable_runtime_services(), so you should probably fold the
>> following hunk into this patch.
>> 
>> diff --git a/drivers/firmware/efi/arm-runtime.c
>> b/drivers/firmware/efi/arm-runtime.c
>> index ce1424672d89..1884347a3ef6 100644
>> --- a/drivers/firmware/efi/arm-runtime.c
>> +++ b/drivers/firmware/efi/arm-runtime.c
>> @@ -109,7 +109,7 @@ static int __init arm_enable_runtime_services(void)
>> 
>>        pr_info("Remapping and enabling EFI services.\n");
>> 
>> -       mapsize = efi.memmap.map_end - efi.memmap.map;
>> +       mapsize = efi.memmap.desc_size * efi.memmap.nr_map;
>> 
>>        if (efi_memmap_init_late(efi.memmap.phys_map, mapsize)) {
>>                pr_err("Failed to remap EFI memory map\n");
> 
> Thanks Ard, I folded this in.
> 
>> With that change (or an equivalent one):
>> 
>> Tested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Are those tags for just this patch or the entire series?
> 

That is for the series (but I only tested arm, so ymmv)

> FYI, my plan right now is to queue this for v4.9 because it's fairly
> invasive and I expect some fallout. If anyone has a problem with that
> and knows of a reason it should be queued sooner, please let me know.

No problem, but once you've queued it i'd like the arm esrt patches to go on top, ideally in the same release. I will dust those off once this series hits your tree--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
