From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 2/2] acpi, apei: use appropriate pgprot_t to map GHES
 memory
Date: Mon, 17 Aug 2015 14:10:58 -0700
Message-ID: <55D24DE2.6070807@codeaurora.org>
References: <1439591850-29002-1-git-send-email-zjzhang@codeaurora.org>
 <1439591850-29002-2-git-send-email-zjzhang@codeaurora.org>
 <20150817131357.GB3233@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150817131357.GB3233-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi @ vger . kernel . org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 8/17/2015 6:13 AM, Matt Fleming wrote:
> On Fri, 14 Aug, at 03:37:30PM, Jonathan (Zhixiong) Zhang wrote:
>> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> With ACPI APEI firmware first handling, generic hardware error
>> record is updated by firmware in GHES memory region. On an arm64
>> platform, firmware updates GHES memory region with uncached
>> access attribute, and then Linux reads stale data from cache.
>>
>> With current code, GHES memory region is mapped with PAGE_KERNEL
>> based on the assumption that cache coherency of GHES memory region
>> is maintained by firmware on all platforms. This assumption is
>> not true for above mentioned arm64 platform.
>>
>> Instead GHES memory region should be mapped with page protection type
>> according to what is returned from arch_apei_get_mem_attribute().
>>
>> Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>   drivers/acpi/apei/ghes.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 23981ac1c6c2..f742335bd8bb 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -160,8 +160,10 @@ static void __iomem *ghes_ioremap_pfn_irq(u64 pfn)
>>   	unsigned long vaddr;
>>
>>   	vaddr = (unsigned long)GHES_IOREMAP_IRQ_PAGE(ghes_ioremap_area->addr);
>> -	ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
>> -			   pfn << PAGE_SHIFT, PAGE_KERNEL);
>> +	ioremap_page_range(vaddr,
>> +			   vaddr + PAGE_SIZE,
>> +			   pfn << PAGE_SHIFT,
>> +			   arch_apei_get_mem_attribute(pfn << PAGE_SHIFT));
>>
>>   	return (void __iomem *)vaddr;
>>   }
>
> Y'know, this would be more readable if written as,
>
> 	unsigned long vaddr, paddr;
> 	pgprot_t prot;
>
>    	vaddr = (unsigned long)GHES_IOREMAP_IRQ_PAGE(ghes_ioremap_area->addr);
>
> 	paddr = pfn << PAGE_SHIFT;
> 	prot = arch_apei_get_mem_attribute(paddr);
>
> 	ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
>
> But either way,
>
> Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Thanks. I will go with the easier to read way.
>

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
