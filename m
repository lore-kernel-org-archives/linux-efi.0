From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] efi: esrt: use memremap not ioremap to access ESRT
 table in memory
Date: Thu, 18 Feb 2016 13:16:05 +0100
Message-ID: <CAKv+Gu_AW7PKJJOd2mbEu3LKJe+gNaPHnH=sgO=YXM_KWFyKxw@mail.gmail.com>
References: <1455535953-5056-1-git-send-email-ard.biesheuvel@linaro.org>
	<1455535953-5056-2-git-send-email-ard.biesheuvel@linaro.org>
	<20160218104407.GC2651@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218104407.GC2651-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 February 2016 at 11:44, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 15 Feb, at 12:32:32PM, Ard Biesheuvel wrote:
>> On ARM and arm64, ioremap() and memremap() are not interchangeable like
>> on x86, and the use of ioremap() on ordinary RAM is typically flagged
>> as an error if the memory region being mapped is also covered by the
>> linear mapping, since that would lead to aliases with conflicting
>> cacheability attributes.
>>
>> Since what we are dealing with is not an I/O region with side effects,
>> using ioremap() here is arguably incorrect anyway, so let's replace
>> it with memremap instead. Also add a missing unmap on the success path,
>> and drop a memblock_remove() call which does not belong here, this far
>> into the boot sequence.
>>
>> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/esrt.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>
> [...]
>
>> @@ -432,8 +434,6 @@ static int __init esrt_sysfs_init(void)
>>       if (error)
>>               goto err_cleanup_list;
>>
>> -     memblock_remove(esrt_data, esrt_data_size);
>> -
>>       pr_debug("esrt-sysfs: loaded.\n");
>>
>>       return 0;
>
> Shouldn't we be replacing memblock_remove() with free_bootmem_late()?
> The original ESRT region is still reserved at this point, so we should
> do our best to release it to the page allocator.

I'd rather we keep it reserved. That way, the config table entry still
points to something valid, which could be useful for kexec(), I think?
At least, that is how I intended to handle config tables on ARM ...
