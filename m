From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V4 1/4] efi: x86: rearrange efi_mem_attributes()
Date: Mon, 15 Jun 2015 15:24:46 -0700
Message-ID: <557F50AE.50403@codeaurora.org>
References: <1434157307-32318-1-git-send-email-zjzhang@codeaurora.org> <1434157307-32318-2-git-send-email-zjzhang@codeaurora.org> <20150615170957.GC17685@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150615170957.GC17685-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


On 6/15/2015 10:09 AM, Matt Fleming wrote:
> On Fri, 12 Jun, at 06:01:44PM, Jonathan (Zhixiong) Zhang wrote:
>> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> x86 and ia64 implement efi_mem_attributes() differently. This
>> function needs to be available for other arch (such as arm64)
>> as well, such as for the purpose of ACPI/APEI.
>>
>> ia64 efi does not setup memmap variable and does not set
>> EFI_MEMMAP flag, so it needs to have its unique implementation
>> of efi_mem_attributes().
>
> Something like the above paragraph...
>
>> @@ -517,3 +517,21 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>>   			 attr & EFI_MEMORY_UC      ? "UC"  : "");
>>   	return buf;
>>   }
>
> needs to go here, i.e. as documentation for efi_mem_atributes(). You
> need to explain why this function is marked as __weak at the function
> definition site.
>
>> +u64 __weak efi_mem_attributes(unsigned long phys_addr)
>> +{
>> +	efi_memory_desc_t *md;
>> +	void *p;
>> +
>> +	if (!efi_enabled(EFI_MEMMAP))
>> +		return 0;
>> +
>> +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>> +		md = p;
>> +		if ((md->phys_addr <= phys_addr) &&
>> +		    (phys_addr < (md->phys_addr +
>> +		    (md->num_pages << EFI_PAGE_SHIFT))))
>> +			return md->attribute;
>> +	}
>> +	return 0;
>> +}
>
> because otherwise people are going to read this in the future and think,
>
>   "efi_mem_attribute() doesn't quite work how I want it to for my arch,
>   but it's __weak, so I'll override it"
>
> which is absolutely not the practice we should be promoting.
>
> How about something like this,
>
> 	/*
> 	 * efi_mem_attributes - lookup memmap attributes for physical address
> 	 * @phys_addr: the physical address to lookup
> 	 *
> 	 * Search in the EFI memory map for the region covering
> 	 * @phys_addr. Returns the EFI memory attributes if the region
> 	 * was found in the memory map, 0 otherwise.
> 	 *
> 	 * Despite being marked __weak most architectures should *not*
> 	 * override this function. It is __weak solely for the benefit
> 	 * of ia64 which has a funky EFI memory map that doesn't work
> 	 * the same way as other architectures.
> 	 */
>
Thank you Matt for the suggestion. Will do so accordingly.

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
