From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/2] efi: efi_mem_reserve(): don't reserve through
 memblock after mm_init()
Date: Fri, 6 Jan 2017 16:41:41 +0000
Message-ID: <CAKv+Gu_BnSf_LMsWHTeFaTak8iV1Cwex7WBEsufwYRrBzY8KzQ@mail.gmail.com>
References: <20170105125130.2815-1-nicstange@gmail.com> <20170105125130.2815-2-nicstange@gmail.com>
 <CAKv+Gu8RHsMKmEHBqNv=q4SB-spCtuydbCshs2ut1+Kk8vraOQ@mail.gmail.com> <87wpe8mjdk.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87wpe8mjdk.fsf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 6 January 2017 at 13:02, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>
>> On 5 January 2017 at 12:51, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Before invoking the arch specific handler, efi_mem_reserve() reserves
>>> the given memory region through memblock.
>>>
>>> efi_mem_reserve() can get called after mm_init() though -- through
>>> efi_bgrt_init(), for example. After mm_init(), memblock is dead and should
>>> not be used anymore.
>>>
>>> Let efi_mem_reserve() check whether memblock is dead and not do the
>>> reservation if so. Emit a warning from the generic efi_arch mem_reserve()
>>> in this case: if the architecture doesn't provide any other means of
>>> registering the region as reserved, the operation would be a nop.
>>>
>>> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
>>> Signed-off-by: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> ---
>>> Applicable to next-20170105.
>>> No changes to v2.
>>> Boot-tested on x86_64.
>>>
>>>  drivers/firmware/efi/efi.c | 7 +++++--
>>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>>> index 92914801e388..158a8df2f4af 100644
>>> --- a/drivers/firmware/efi/efi.c
>>> +++ b/drivers/firmware/efi/efi.c
>>> @@ -403,7 +403,10 @@ u64 __init efi_mem_desc_end(efi_memory_desc_t *md)
>>>         return end;
>>>  }
>>>
>>> -void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
>>> +void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>>> +{
>>> +       WARN(slab_is_available(), "efi_mem_reserve() has no effect");
>>> +}
>>>
>>>  /**
>>>   * efi_mem_reserve - Reserve an EFI memory region
>>> @@ -419,7 +422,7 @@ void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
>>>   */
>>>  void __init efi_mem_reserve(phys_addr_t addr, u64 size)
>>>  {
>>> -       if (!memblock_is_region_reserved(addr, size))
>>> +       if (!slab_is_available() && !memblock_is_region_reserved(addr, size))
>>>                 memblock_reserve(addr, size);
>>>
>
> More context:
>
>             /*
>              * Some architectures (x86) reserve all boot services ranges
>              * until efi_free_boot_services() because of buggy firmware
>              * implementations. This means the above memblock_reserve() is
>              * superfluous on x86 and instead what it needs to do is
>              * ensure the @start, @size is not freed.
>              */
>             efi_arch_mem_reserve(addr, size);
>     }
>
>
>> I share Dave's concern: on x86, this will silently ignore the
>> reservation if slab_is_available() returns true,
>
> AFAICS, x86 has got an efi_arch_mem_reserve() which doesn't ignore the
> reservation at any stage.
>

Thanks for the clarification. But my concern is whether changing the
EFI memory map is going to have any effect at this stage, i.e., after
slab_is_available() returns true: haven't we already communicated to
the kernel which RAM regions it may allocate from? How does it know
the memory map has changed, and how do we ensure that it has not
already allocated from the region we are reserving here?

> The default implementation of efi_arch_mem_reserve() used on ARM is
> empty though ...
>
>> so we should at least warn here.
>
> ... and this patch adds a WARN() to the empty stub.
>
>
>> I don't think this patch solves any known issues, so I'd
>> rather defer this for now, and pick up the discussion when Matt is
>> back,
>
> I'm fine with either way and yes, no splat has been observed in the
> wild.
>
> Just to make it explicit: the issue addressed here is a potential
> use-after-free (both, read and write) on memblock.reserved.regions in
> case of CONFIG_ARCH_DISCARD_MEMBLOCK=y. It would certainly make sense to
> clarify the commit description in the next iteration...
>
