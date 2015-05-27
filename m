From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: arch, x86: arch, ia64: rearrange EFI memmap
 related functions
Date: Wed, 27 May 2015 12:35:49 -0700
Message-ID: <55661C95.5010200@codeaurora.org>
References: <1430773335-22897-1-git-send-email-zjzhang@codeaurora.org> <1430773335-22897-2-git-send-email-zjzhang@codeaurora.org> <20150527123103.GC3030@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150527123103.GC3030-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Thank you Matt very much for the code review! Pls. see comments inline.

On 5/27/2015 5:31 AM, Matt Fleming wrote:
> On Mon, 04 May, at 02:02:14PM, Jonathan (Zhixiong) Zhang wrote:
>> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> Both x86 and ia64 implemented efi_mem_attributs function, which is architecture
>> agnositc. This function is moved to efi subsystem.
>>
>> efi_remap() function is added. If EFI memmap feature is enabled, and if a
>> memory region has attribute of EFI_MEMORY_UC, map it as uncached.
>>
>> ---
>> This patch was tested on an arm64 platform. It was built on x86 platform.
>>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>   arch/ia64/kernel/efi.c      | 11 -----------
>>   arch/x86/platform/efi/efi.c | 18 ------------------
>>   drivers/firmware/efi/efi.c  | 27 +++++++++++++++++++++++++++
>>   include/linux/efi.h         |  1 +
>>   4 files changed, 28 insertions(+), 29 deletions(-)
>>
 >> <snipped>
>
> This should be split into two patches, one to remove the duplicate
> efi_mem_attributes() and the other to create the new efi_ioremap()
> function.
Makes sense, will do.

>
>> +void __iomem *efi_remap(phys_addr_t phys_addr, size_t size)
>> +{
>> +	if (efi_enabled(EFI_MEMMAP) &&
>> +	    (efi_mem_attributes(phys_addr) & EFI_MEMORY_UC))
>> +		return ioremap(phys_addr, size);
>> +	else
>> +		return ioremap_cache(phys_addr, size);
>> +}
>
> Note that on x86 we don't leave the EFI memmap mapped throughout
> runtime, it gets unmapped in efi_free_boot_services().
>
> Which means that the second patch in this series isn't going to work
> correctly if an error is reported after the kernel has finished booting.
>
> It looks like arm64 leaves the EFI memmap mapped at runtime, right?
>
Correct, only x86 unmaps EFI memmap since efi_free_boot_services() is 
not implemented for other architectures, as shown in include/linux/efi.h .

With x86 arch, efi_unmap_memmap() is called in efi_free_boot_services() 
to unmap EFI memmap, this function is defined in 
arch/x86/platform/efi/efi.c. It clears EFI_MEMMAP bit in efi flag. 
Therefore in this case, efi_enabled(EFI_MEMMAP) returns false for x86 
platforms with EFI memory map support, after kernel finished booting; 
efi_remap() function in turn maps the memory region as cached.

Therefore, I believe the second patch in this series will work correctly 
for above situation as well. How do you think?

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
