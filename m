From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 1/2] arm64: apei: implement arch_apei_get_mem_attributes()
Date: Fri, 14 Aug 2015 11:55:27 -0700
Message-ID: <55CE399F.1030108@codeaurora.org>
References: <1439396234-22863-1-git-send-email-matt@codeblueprint.co.uk>
 <1439396234-22863-2-git-send-email-matt@codeblueprint.co.uk>
 <20150813082207.GB14610@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150813082207.GB14610-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 8/13/2015 1:22 AM, Ingo Molnar wrote:
>
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>
>> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> Table 8 of UEFI 2.5 section 2.3.6.1 defines mappings from EFI
>> memory types to MAIR attribute encodings for arm64.
>>
>> If the physical address has memory attributes defined by EFI
>> memmap as EFI_MEMORY_[UC|WC|WT], return approprate page protection
>> type according to the UEFI spec. Otherwise, return PAGE_KERNEL.
>>
>> Reviewed-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
>> Acked-by: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>   arch/arm64/include/asm/acpi.h | 30 ++++++++++++++++++++++++++++++
>>   1 file changed, 30 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
>> index 406485ed110a..1cbad43e561d 100644
>> --- a/arch/arm64/include/asm/acpi.h
>> +++ b/arch/arm64/include/asm/acpi.h
>> @@ -19,6 +19,11 @@
>>   #include <asm/psci.h>
>>   #include <asm/smp_plat.h>
>>
>> +#ifdef CONFIG_ACPI_APEI
>> +#include <linux/efi.h>
>> +#include <asm/pgtable.h>
>> +#endif
>> +
>>   /* Macros for consistency checks of the GICC subtable of MADT */
>>   #define ACPI_MADT_GICC_LENGTH	\
>>   	(acpi_gbl_FADT.header.revision < 6 ? 76 : 80)
>> @@ -92,4 +97,29 @@ static inline const char *acpi_get_enable_method(int cpu)
>>   {
>>   	return acpi_psci_present() ? "psci" : NULL;
>>   }
>> +
>> +#ifdef	CONFIG_ACPI_APEI
>> +static inline pgprot_t arch_apei_get_mem_attribute(phys_addr_t addr)
>> +{
>> +	/*
>> +	 * According to "Table 8 Map: EFI memory types to AArch64 memory types"
>> +	 * of UEFI 2.5 section 2.3.6.1, each EFI memory type is mapped to
>> +	 * corresponding MAIR attribute encoding.
>
> s/mapped to corresponding/
>    mapped to a corresponding
Will do.
>
>> +	 * The EFI memory attribute advises all possible capabilities of a
>> +	 * memory region. We use the most efficient capability.
>> +	 */
>> +
>> +	u64 attr;
>> +
>> +	attr = efi_mem_attributes(addr);
>> +	if (attr & EFI_MEMORY_WB)
>> +		return PAGE_KERNEL;
>> +	if (attr & EFI_MEMORY_WT)
>> +		return __pgprot(PROT_NORMAL_WT);
>> +	if (attr & EFI_MEMORY_WC)
>> +		return __pgprot(PROT_NORMAL_NC);
>> +	return __pgprot(PROT_DEVICE_nGnRnE);
>> +}
>> +#endif
>
> Also, this doesn't look like a small function - why is it inlined?
The function grew a bit after its first version. Since it is on the
fence of not being a small function, I did not change it to out of
the line. I will move it to arch/arm64/kernel/acpi.c guarded by
CONFIG_ACPI_APEI instead of having to create a very small new file,
if there is no opposition.
>
> Moving it to .c would also slightly improve compilation times for every .c file
> that includes asm/acpi.h.
>
> Thanks,
>
> 	Ingo
>

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
