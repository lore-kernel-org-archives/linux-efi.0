From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V6 2/4] x86: acpi: implement
 arch_apei_get_mem_attributes()
Date: Wed, 22 Jul 2015 10:20:23 -0700
Message-ID: <55AFD0D7.70204@codeaurora.org>
References: <1437438759-3686-1-git-send-email-zjzhang@codeaurora.org>
 <1437438759-3686-3-git-send-email-zjzhang@codeaurora.org>
 <20150722120926.GD2734@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722120926.GD2734-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Thank you Matt for the great feedback.

On 7/22/2015 5:09 AM, Matt Fleming wrote:
> On Mon, 20 Jul, at 05:32:37PM, Jonathan (Zhixiong) Zhang wrote:
>> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> ... to allow arch specific implementation of getting page
>> protection type associated with a physical address.
>>
>> If the physical address has memory attributes defined by EFI
>> memmap as EFI_MEMORY_UC, the page protection type is
>> PAGE_KENERL_NOCACHE. Otherwise, the page protection type is
>> PAGE_KERNEL.
>>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>   arch/x86/kernel/acpi/apei.c | 10 ++++++++++
>>   include/acpi/apei.h         |  1 +
>>   2 files changed, 11 insertions(+)
>>
>> diff --git a/arch/x86/kernel/acpi/apei.c b/arch/x86/kernel/acpi/apei.c
>> index c280df6b2aa2..9c6b3c8d81e4 100644
>> --- a/arch/x86/kernel/acpi/apei.c
>> +++ b/arch/x86/kernel/acpi/apei.c
>> @@ -14,6 +14,8 @@
>>
>>   #include <acpi/apei.h>
>>
>> +#include <linux/efi.h>
>> +
>>   #include <asm/mce.h>
>>   #include <asm/tlbflush.h>
>>
>> @@ -60,3 +62,11 @@ void arch_apei_flush_tlb_one(unsigned long addr)
>>   {
>>   	__flush_tlb_one(addr);
>>   }
>> +
>> +pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
>> +{
>> +	if (efi_mem_attributes(addr) & EFI_MEMORY_UC)
>> +		return PAGE_KERNEL_NOCACHE;
>> +
>> +	return PAGE_KERNEL;
>> +}
>
> Like I mentioned before, this is theoretically racey because depending
> on when you call arch_apei_get_mem_attribute() during boot, you'll
> potentially return a different protection for the *same* memory region.
> This is because on x86 we discard the EFI memory map in
> efi_free_boot_services(), after which time efi_mem_attributes() will
> always return 0.
>
> Now, hitting that race would depend on a number of things but most
> importantly it would require the region of RAM containing the Hardware
> Error data to have EFI_MEMORY_UC set in the EFI memmap. For x86 I think
> it's fair to say that's extremely unlikely given our cache coherency
> architecture.
>
> Also, as Will noted for arm64, this really wants to be static inline.
Yes, will do.
> I'm still hoping the x86/ACPI folks will chime in on this patch.
Same here.
>
> For x86 we don't need to perform this lookup today for GHES so I would
> just always return PAGE_KERNEL but include a comment explaining that
> doing anything else is unneeded. Something like this?
The analysis and comments added make total sense to me. Will do so in V8
of the patch set after Will's feedback on v7.
>
> ---
>
> static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
> {
>
> 	/*
> 	 * We currently have no way to lookup the EFI memory map
> 	 * attributes for a region in a consistent way because the memap
> 	 * is discarded after efi_free_boot_services(). So if you call
> 	 * efi_mem_attributes() during boot and at runtime you could
> 	 * theoretically see different attributes.
> 	 *
> 	 * Since we've yet to see any x86 platforms that require
> 	 * anything other than PAGE_KERNEL (some arm64 platforms require
> 	 * the equivalent of PAGE_KERNEL_NOCACHE), return that until we
> 	 * know different.
> 	 */
>
> 	return PAGE_KERNEL;
> }
>

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
