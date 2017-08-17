From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC Part1 PATCH v3 11/17] x86/mm, resource: Use PAGE_KERNEL
 protection for ioremap of memory pages
Date: Thu, 17 Aug 2017 14:22:48 -0500
Message-ID: <74c7115c-d435-7ae3-6d2e-820558d3e446@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-12-brijesh.singh@amd.com>
 <20170802040255.GA4336@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170802040255.GA4336@nazgul.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin
List-Id: linux-efi@vger.kernel.org

On 8/1/2017 11:02 PM, Borislav Petkov wrote:
> On Mon, Jul 24, 2017 at 02:07:51PM -0500, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> In order for memory pages to be properly mapped when SEV is active, we
>> need to use the PAGE_KERNEL protection attribute as the base protection.
>> This will insure that memory mapping of, e.g. ACPI tables, receives the
>> proper mapping attributes.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/mm/ioremap.c  | 28 ++++++++++++++++++++++++++++
>>   include/linux/ioport.h |  3 +++
>>   kernel/resource.c      | 17 +++++++++++++++++
>>   3 files changed, 48 insertions(+)
>>
>> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
>> index c0be7cf..7b27332 100644
>> --- a/arch/x86/mm/ioremap.c
>> +++ b/arch/x86/mm/ioremap.c
>> @@ -69,6 +69,26 @@ static int __ioremap_check_ram(unsigned long start_pfn, unsigned long nr_pages,
>>   	return 0;
>>   }
>>   
>> +static int __ioremap_res_desc_other(struct resource *res, void *arg)
>> +{
>> +	return (res->desc != IORES_DESC_NONE);
>> +}
>> +
>> +/*
>> + * This function returns true if the target memory is marked as
>> + * IORESOURCE_MEM and IORESOURCE_BUSY and described as other than
>> + * IORES_DESC_NONE (e.g. IORES_DESC_ACPI_TABLES).
>> + */
>> +static bool __ioremap_check_if_mem(resource_size_t addr, unsigned long size)
>> +{
>> +	u64 start, end;
>> +
>> +	start = (u64)addr;
>> +	end = start + size - 1;
>> +
>> +	return (walk_mem_res(start, end, NULL, __ioremap_res_desc_other) == 1);
>> +}
>> +
>>   /*
>>    * Remap an arbitrary physical address space into the kernel virtual
>>    * address space. It transparently creates kernel huge I/O mapping when
>> @@ -146,7 +166,15 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
>>   		pcm = new_pcm;
>>   	}
>>   
>> +	/*
>> +	 * If the page being mapped is in memory and SEV is active then
>> +	 * make sure the memory encryption attribute is enabled in the
>> +	 * resulting mapping.
>> +	 */
>>   	prot = PAGE_KERNEL_IO;
>> +	if (sev_active() && __ioremap_check_if_mem(phys_addr, size))
>> +		prot = pgprot_encrypted(prot);
> 
> Hmm, so this function already does walk_system_ram_range() a bit
> earlier and now on SEV systems we're going to do it again. Can we make
> walk_system_ram_range() return a distinct value for SEV systems and act
> accordingly in __ioremap_caller() instead of repeating the operation?
> 
> It looks to me like we could...

Let me look into this.  I can probably come up with something that does
the walk once.

Thanks,
Tom

> 
