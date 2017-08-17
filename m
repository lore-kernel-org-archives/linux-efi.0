From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC Part1 PATCH v3 12/17] x86/mm: DMA support for SEV memory
 encryption
Date: Thu, 17 Aug 2017 14:35:25 -0500
Message-ID: <4002e0e2-34e8-c8ea-80e8-f5deae8b21e7@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-13-brijesh.singh@amd.com>
 <20170807034820.GA7521@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170807034820.GA7521@nazgul.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin
List-Id: linux-efi@vger.kernel.org



On 8/6/2017 10:48 PM, Borislav Petkov wrote:
> On Mon, Jul 24, 2017 at 02:07:52PM -0500, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> DMA access to memory mapped as encrypted while SEV is active can not be
>> encrypted during device write or decrypted during device read.
> 
> Yeah, definitely rewrite that sentence.

Heh, yup.

> 
>> In order
>> for DMA to properly work when SEV is active, the SWIOTLB bounce buffers
>> must be used.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/mm/mem_encrypt.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++
>>   lib/swiotlb.c             |  5 +--
>>   2 files changed, 89 insertions(+), 2 deletions
> 
> ...
> 
>> @@ -202,6 +280,14 @@ void __init mem_encrypt_init(void)
>>   	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
>>   	swiotlb_update_mem_attributes();
>>   
>> +	/*
>> +	 * With SEV, DMA operations cannot use encryption. New DMA ops
>> +	 * are required in order to mark the DMA areas as decrypted or
>> +	 * to use bounce buffers.
>> +	 */
>> +	if (sev_active())
>> +		dma_ops = &sme_dma_ops;
> 
> Well, we do differentiate between SME and SEV and the check is
> sev_active but the ops are called sme_dma_ops. Call them sev_dma_ops
> instead for less confusion.

Yup, will do.

Thanks,
Tom

> 
