From: Nicolai Stange <nicstange@gmail.com>
Subject: Re: [PATCH v3 2/2] efi: efi_mem_reserve(): don't reserve through memblock after mm_init()
Date: Fri, 06 Jan 2017 14:02:31 +0100
Message-ID: <87wpe8mjdk.fsf@gmail.com>
References: <20170105125130.2815-1-nicstange@gmail.com>
        <20170105125130.2815-2-nicstange@gmail.com>
        <CAKv+Gu8RHsMKmEHBqNv=q4SB-spCtuydbCshs2ut1+Kk8vraOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu8RHsMKmEHBqNv=q4SB-spCtuydbCshs2ut1+Kk8vraOQ@mail.gmail.com>
        (Ard Biesheuvel's message of "Fri, 6 Jan 2017 08:35:52 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Mika =?utf-8?Q?Penttil=C3=A4?= <mika.penttila@nextfour.com>, Dan Williams <dan.j.williams@intel.com>, Dave Young <dyoung@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:

> On 5 January 2017 at 12:51, Nicolai Stange <nicstange@gmail.com> wrote:
>> Before invoking the arch specific handler, efi_mem_reserve() reserves
>> the given memory region through memblock.
>>
>> efi_mem_reserve() can get called after mm_init() though -- through
>> efi_bgrt_init(), for example. After mm_init(), memblock is dead and should
>> not be used anymore.
>>
>> Let efi_mem_reserve() check whether memblock is dead and not do the
>> reservation if so. Emit a warning from the generic efi_arch mem_reserve()
>> in this case: if the architecture doesn't provide any other means of
>> registering the region as reserved, the operation would be a nop.
>>
>> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
>> Signed-off-by: Nicolai Stange <nicstange@gmail.com>
>> ---
>> Applicable to next-20170105.
>> No changes to v2.
>> Boot-tested on x86_64.
>>
>>  drivers/firmware/efi/efi.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index 92914801e388..158a8df2f4af 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -403,7 +403,10 @@ u64 __init efi_mem_desc_end(efi_memory_desc_t *md)
>>         return end;
>>  }
>>
>> -void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
>> +void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>> +{
>> +       WARN(slab_is_available(), "efi_mem_reserve() has no effect");
>> +}
>>
>>  /**
>>   * efi_mem_reserve - Reserve an EFI memory region
>> @@ -419,7 +422,7 @@ void __init __weak efi_arch_mem_reserve(phys_addr_t addr, u64 size) {}
>>   */
>>  void __init efi_mem_reserve(phys_addr_t addr, u64 size)
>>  {
>> -       if (!memblock_is_region_reserved(addr, size))
>> +       if (!slab_is_available() && !memblock_is_region_reserved(addr, size))
>>                 memblock_reserve(addr, size);
>>

More context:

            /*
             * Some architectures (x86) reserve all boot services ranges
             * until efi_free_boot_services() because of buggy firmware
             * implementations. This means the above memblock_reserve() is
             * superfluous on x86 and instead what it needs to do is
             * ensure the @start, @size is not freed.
             */
            efi_arch_mem_reserve(addr, size);
    }


> I share Dave's concern: on x86, this will silently ignore the
> reservation if slab_is_available() returns true,

AFAICS, x86 has got an efi_arch_mem_reserve() which doesn't ignore the
reservation at any stage.

The default implementation of efi_arch_mem_reserve() used on ARM is
empty though ... 

> so we should at least warn here.

... and this patch adds a WARN() to the empty stub.


> I don't think this patch solves any known issues, so I'd
> rather defer this for now, and pick up the discussion when Matt is
> back,

I'm fine with either way and yes, no splat has been observed in the
wild.

Just to make it explicit: the issue addressed here is a potential
use-after-free (both, read and write) on memblock.reserved.regions in
case of CONFIG_ARCH_DISCARD_MEMBLOCK=y. It would certainly make sense to
clarify the commit description in the next iteration...

Thanks,

Nicolai
