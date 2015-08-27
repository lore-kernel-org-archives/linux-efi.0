From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: base UEFI mapping permissions on region attributes
Date: Thu, 27 Aug 2015 22:33:37 +0200
Message-ID: <A4801D35-3216-43D2-AEAE-C01ED59A0F24@linaro.org>
References: <1440595802-20359-1-git-send-email-ard.biesheuvel@linaro.org> <20150827093228.GA23520@arm.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150827093228.GA23520-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


> On 27 aug. 2015, at 11:32, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> 
> Hi Ard,
> 
>> On Wed, Aug 26, 2015 at 02:30:02PM +0100, Ard Biesheuvel wrote:
>> Currently, we infer the UEFI memory region mapping permissions
>> from the memory region type (i.e., runtime services code are
>> mapped RWX and runtime services data mapped RW-). This appears to
>> work fine but is not entirely UEFI spec compliant. So instead, use
>> the designated permission attributes to decide how these regions
>> should be mapped.
>> 
>> Since UEFIv2.5 introduces a new EFI_MEMORY_RO permission attribute,
>> and redefines EFI_MEMORY_WP as a cacheability attribute, use only
>> the former as a read-only attribute. For setting the PXN bit, the
>> corresponding EFI_MEMORY_XP attribute is used.
>> 
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>> Changes since v1:
>> - rewrote page size and alignment check to be more legible
>> - use code that is STRICT_MM_TYPECHECKS compliant
>> 
>> Example output of a recent Tianocore build on FVP Foundation model
>> is attached below.
>> 
>> arch/arm64/kernel/efi.c | 37 +++++++++++++-------
>> 1 file changed, 24 insertions(+), 13 deletions(-)
>> 
>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> index ab21e0d58278..c8d587f46f3e 100644
>> --- a/arch/arm64/kernel/efi.c
>> +++ b/arch/arm64/kernel/efi.c
>> @@ -235,7 +235,7 @@ static bool __init efi_virtmap_init(void)
>> 
>>    for_each_efi_memory_desc(&memmap, md) {
>>        u64 paddr, npages, size;
>> -        pgprot_t prot;
>> +        pteval_t prot_val;
>> 
>>        if (!(md->attribute & EFI_MEMORY_RUNTIME))
>>            continue;
>> @@ -247,22 +247,33 @@ static bool __init efi_virtmap_init(void)
>>        memrange_efi_to_native(&paddr, &npages);
>>        size = npages << PAGE_SHIFT;
>> 
>> -        pr_info("  EFI remap 0x%016llx => %p\n",
>> -            md->phys_addr, (void *)md->virt_addr);
>> +        if (!is_normal_ram(md))
>> +            prot_val = PROT_DEVICE_nGnRE;
>> +        else
>> +            prot_val = pgprot_val(PAGE_KERNEL_EXEC);
>> 
>>        /*
>> -         * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
>> -         * executable, everything else can be mapped with the XN bits
>> -         * set.
>> +         * On 64 KB granule kernels, only use strict permissions when
>> +         * the region does not share a 64 KB page frame with another
>> +         * region at either end.
>>         */
>> -        if (!is_normal_ram(md))
>> -            prot = __pgprot(PROT_DEVICE_nGnRE);
>> -        else if (md->type == EFI_RUNTIME_SERVICES_CODE)
>> -            prot = PAGE_KERNEL_EXEC;
>> -        else
>> -            prot = PAGE_KERNEL;
>> +        if (PAGE_SIZE == EFI_PAGE_SIZE ||
>> +            (PAGE_ALIGNED(md->virt_addr) &&
>> +             PAGE_ALIGNED(md->phys_addr + md->num_pages * EFI_PAGE_SIZE))) {
> 
> Why do you use virt_addr instead of phys_addr for the base check?

No reason in particular, as far as I remember, so i should probably change that
