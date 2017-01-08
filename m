From: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] efi: efi_mem_reserve(): don't reserve through memblock after mm_init()
Date: Sun, 08 Jan 2017 01:24:49 +0100
Message-ID: <8760lqiejy.fsf@gmail.com>
References: <20170105125130.2815-1-nicstange@gmail.com>
        <20170105125130.2815-2-nicstange@gmail.com>
        <CAKv+Gu8RHsMKmEHBqNv=q4SB-spCtuydbCshs2ut1+Kk8vraOQ@mail.gmail.com>
        <87wpe8mjdk.fsf@gmail.com>
        <CAKv+Gu_BnSf_LMsWHTeFaTak8iV1Cwex7WBEsufwYRrBzY8KzQ@mail.gmail.com>
        <87showm682.fsf@gmail.com>
        <CAKv+Gu9B_amUwKuQCfMj6d96EpcLdeBDm732E0iqKSkRp11Z4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9B_amUwKuQCfMj6d96EpcLdeBDm732E0iqKSkRp11Z4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Ard Biesheuvel's message of "Fri, 6 Jan 2017 19:28:40 +0000")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86@kernel.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mika =?utf-8?Q?Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

> On 6 January 2017 at 17:46, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>>
>>> On 6 January 2017 at 13:02, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>>>>
>>>>> On 5 January 2017 at 12:51, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>> Before invoking the arch specific handler, efi_mem_reserve() reserves
>>>>>> the given memory region through memblock.
>>>>>>
>>>>>> efi_mem_reserve() can get called after mm_init() though -- through
>>>>>> efi_bgrt_init(), for example. After mm_init(), memblock is dead and should
>>>>>> not be used anymore.
>>>>>>
>>>>>> Let efi_mem_reserve() check whether memblock is dead and not do the
>>>>>> reservation if so. Emit a warning from the generic efi_arch mem_reserve()
>>>>>> in this case: if the architecture doesn't provide any other means of
>>>>>> registering the region as reserved, the operation would be a nop.
>>>>>>
>>>>>> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
>>>>>> Signed-off-by: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>>> ---
>>>>>> Applicable to next-20170105.
>>>>>> No changes to v2.
>>>>>> Boot-tested on x86_64.
>>>>>>
>>>>>>  drivers/firmware/efi/efi.c | 7 +++++--
>>>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>>>>>> index 92914801e388..158a8df2f4af 100644
>>>>>> --- a/drivers/firmware/efi/efi.c
>>>>>> +++ b/drivers/firmware/efi/efi.c
>>>>>> @@ -403,7 +403,10 @@ u64 __init efi_mem_desc_end(efi_memory_desc_t *md)
>>>>>>         return end;
>>>>>>  }
>>>>>>
>>>>>> -void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
>>>>>> +void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>>>>>> +{
>>>>>> +       WARN(slab_is_available(), "efi_mem_reserve() has no effect");
>>>>>> +}
>>>>>>
>>>>>>  /**
>>>>>>   * efi_mem_reserve - Reserve an EFI memory region
>>>>>> @@ -419,7 +422,7 @@ void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
>>>>>>   */
>>>>>>  void __init efi_mem_reserve(phys_addr_t addr, u64 size)
>>>>>>  {
>>>>>> -       if (!memblock_is_region_reserved(addr, size))
>>>>>> +       if (!slab_is_available() && !memblock_is_region_reserved(addr, size))
>>>>>>                 memblock_reserve(addr, size);
>>>>>>
>>>>
>>>> More context:
>>>>
>>>>             /*
>>>>              * Some architectures (x86) reserve all boot services ranges
>>>>              * until efi_free_boot_services() because of buggy firmware
>>>>              * implementations. This means the above memblock_reserve() is
>>>>              * superfluous on x86 and instead what it needs to do is
>>>>              * ensure the @start, @size is not freed.
>>>>              */
>>>>             efi_arch_mem_reserve(addr, size);
>>>>     }
>>>>
>>>>
>>>>> I share Dave's concern: on x86, this will silently ignore the
>>>>> reservation if slab_is_available() returns true,
>>>>
>>>> AFAICS, x86 has got an efi_arch_mem_reserve() which doesn't ignore the
>>>> reservation at any stage.
>>>>
>>>
>>> Thanks for the clarification. But my concern is whether changing the
>>> EFI memory map is going to have any effect at this stage, i.e., after
>>> slab_is_available() returns true: haven't we already communicated to
>>> the kernel which RAM regions it may allocate from? How does it know
>>> the memory map has changed, and how do we ensure that it has not
>>> already allocated from the region we are reserving here?
>>
>> Ah, I see what you mean. I think it works like this on x86:
>>
>> All EFI_BOOT_SERVICES_* regions as reported by the firmware are marked
>> as reserved at memblock unconditionally through the early setup_arch()
>> => efi_reserve_boot_services(). This prevents these from getting handed
>> over to the "normal" kernel MM until efi_free_boot_services()
>> gets called later on. The latter frees these EFI_BOOT_SERVICES_* regions,
>> but only if their EFI_MEMORY_RUNTIME flag is not set.
>>
>> Now, efi_arch_mem_reserve() basically just sets the EFI_MEMORY_RUNTIME
>> flag, allowing the given region to survive beyond efi_free_boot_services().
>>
>> Corrolary 1: any efi_mem_reserve() after efi_free_boot_services wouldn't
>> have any effect.
>>
>
> This is my point exactly. But it appears efi_free_boot_services()
> occurs much later than I thought, and so there is a sizabe time window
> where SLAB is up but reservations can still be made. But we don't
> check whether efi_free_boot_services() has been called.

Ok, but this patch is about slab_is_available()/resp. the
non-availability of memblock and I'd rather consider the implementation
of these kinds of safety checks as being a different story?



Out of curiosity, I had a deeper look at the BootServices*-md
requirement though:

> Another problem is that we never check that the reservation is covered
> by a BootServicesData region, which are the only ones that are
> guaranteed to be retained up to this point.

I think the "only ones that are guaranteed to be retained" part might
not be completely correct: at least my firmware seems to report only the
EFI_CONVENTIONAL_MEMORY, EFI_LOADER_DATA, EFI_LOADER_CODE,
EFI_BOOT_SERVICES_CODE and EFI_BOOT_SERVICES_DATA as E820_RAM
(I think that these mappings are dictated by table 15-330 of ACPI 6.1:
"UEFI Memory Types and mapping to ACPI address range types").

This would mean, that memblock_x86_fill() adds only these regions to
memblock.memory.

free_all_bootmem() only operates on the (non-highmem) regions given by
memblock.memory and thus, any region of a type different from the ones
listed above would never get freed to the buddy allocator anyway, AFAICS.

Thus, the only md type where ranges efi_mem_reserve()'d therein aren't
retained are EFI_CONVENTIONAL_MEMORY, EFI_LOADER_DATA and
EFI_LOADER_CODE (and possibly highmem). Hopefully, nobody would ever
call efi_mem_reserve() on such a range but that assumption might be
wrong.


>> Corollary 2: anything handed to efi_arch_mem_reserve() must live within
>> some memory region which had been reported by firmware already.
>>
>
> Yes, but the EFI memory map describes all of RAM, so this is not an
> issue by itself.

Ok. But I've just realized that after __efi_enter_virtual_mode(),
efi_map_regions() would have stripped that list down to only those MDs
for which should_map_region() returns true. With efi_is_native(), that's
everything having EFI_MEMORY_RUNTIME set and the BOOT_SERVICES_*
regions.


Thanks,

Nicolai
