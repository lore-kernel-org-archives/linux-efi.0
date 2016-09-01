From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi: arm64: treat regions with WT/WC set but WB
 cleared as memory
Date: Thu, 1 Sep 2016 15:33:42 +0100
Message-ID: <CAKv+Gu9QVUg2a=+efO+j+nVUNszpRYuzH9mRHTHLNNBBJX+b9w@mail.gmail.com>
References: <1472141829-12026-1-git-send-email-ard.biesheuvel@linaro.org>
 <57C00FA7.8010908@arm.com> <CAKv+Gu8-u7bqEj3Y9N0W0xogRM7t6rzxcY=Of2HHHzhKjo59Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu8-u7bqEj3Y9N0W0xogRM7t6rzxcY=Of2HHHzhKjo59Dg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Takahiro Akashi <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 August 2016 at 11:08, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 26 August 2016 at 11:45, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org> wrote:
>> Hi Ard,
>>
>> On 25/08/16 17:17, Ard Biesheuvel wrote:
>>> Currently, memory regions are only recorded in the memblock memory table
>>> if they have the EFI_MEMORY_WB memory type attribute set. In case the
>>> region is of a reserved type, it is also marked as MEMBLOCK_NOMAP, which
>>> will leave it out of the linear mapping.
>>>
>>> However, memory regions may legally have the EFI_MEMORY_WT or EFI_MEMORY_WC
>>> attributes set, and the EFI_MEMORY_WB cleared, in which case the region in
>>> question is obviously backed by normal memory, but is not recorded in the
>>> memblock memory table at all.
>>
>> I've been hitting this when applying weird (but permissible) attributes to the
>> ACPI regions. Currently without WB we map these as device memory, then let
>> acpica make unaligned accesses to it.
>>
>> This patch fixes all that, and from the conversation on irc, the 'UC only' case
>> for ACPI tables is x86-legacy, and should never happen.
>>
>
> Indeed, deliberately exposing a region containing ACPI tables as
> something that *requires* strongly ordered access does not make sense.
>
> The problem here is that the UEFI memory map describes both occupied
> and available regions, and in the 'available' case, it is obvious that
> these bits describe the nature of the physical backing of the region,
> i.e., whether the bus fabric, memory, etc allow writeback/writethrough
> caching, write buffering etc. This explains why most regions have all
> the bits set.
>
> In the occupied case, this can be misinterpreted as describing the
> nature of the content, like an ACPI table containing fields that are
> not naturally aligned. I.e, I don't think clearing the UC bit here
> should be interpreted to mean that the payload *requires* WB/WT/WC. It
> is up to the kernel to complain if it interprets a region, and notices
> that the only supported mapping type conflicts with the nature of the
> accesses we intend to perform.
>
>>
>>> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
>>> index c49d50e68aee..c2ac5975fd5d 100644
>>> --- a/drivers/firmware/efi/arm-init.c
>>> +++ b/drivers/firmware/efi/arm-init.c
>>> @@ -163,18 +163,22 @@ static __init int is_reserve_region(efi_memory_desc_t *md)
>>>       case EFI_BOOT_SERVICES_DATA:
>>>       case EFI_CONVENTIONAL_MEMORY:
>>>       case EFI_PERSISTENT_MEMORY:
>>> -             return 0;
>>> +             /*
>>> +              * According to the spec, these regions are no longer reserved
>>> +              * after calling ExitBootServices(). However, we can only use
>>> +              * them as System RAM if they can be mapped writeback cacheable.
>>> +              */
>>> +             return (md->attribute & EFI_MEMORY_WB);
>>>       default:
>>>               break;
>>
>> Micro-nit: break here in order to immediately return false looks a bit odd...
>>
>
> Yes, I could not decide what to do with it so I left it.
>
>>
>>>       }
>>> -     return is_normal_ram(md);
>>> +     return false;
>>>  }
>>
>>
>> Tested-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
>> Reviewed-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
>>
>

Matt,

Could we get this queued for v4.9 please?

Thanks,
Ard.
