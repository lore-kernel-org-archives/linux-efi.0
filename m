From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC Part1 PATCH v3 15/17] x86: Add support for changing memory
 encryption attribute in early boot
Date: Mon, 28 Aug 2017 06:49:19 -0500
Message-ID: <4b3cec09-ab6a-0400-00fe-328b36564942@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-16-brijesh.singh@amd.com>
 <20170828105119.xs73tinknqcmrgvk@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170828105119.xs73tinknqcmrgvk@pd.tnic>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: brijesh.singh@amd.com, linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmiss>
List-Id: linux-efi@vger.kernel.org

Hi Boris,


On 8/28/17 5:51 AM, Borislav Petkov wrote:

[..]

> +static int __init early_set_memory_enc_dec(resource_size_t paddr,
>> +					   unsigned long size, bool enc)
>> +{
>> +	unsigned long vaddr, vaddr_end, vaddr_next;
>> +	unsigned long psize, pmask;
>> +	int split_page_size_mask;
>> +	pte_t *kpte;
>> +	int level;
>> +
>> +	vaddr = (unsigned long)__va(paddr);
>> +	vaddr_next = vaddr;
>> +	vaddr_end = vaddr + size;
>> +
>> +	/*
>> +	 * We are going to change the physical page attribute from C=1 to C=0
>> +	 * or vice versa. Flush the caches to ensure that data is written into
>> +	 * memory with correct C-bit before we change attribute.
>> +	 */
>> +	clflush_cache_range(__va(paddr), size);
>> +
>> +	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
>> +		kpte = lookup_address(vaddr, &level);
>> +		if (!kpte || pte_none(*kpte))
>> +			return 1;
> Return before flushing TLBs? Perhaps you mean
>
> 			ret = 1;
> 			goto out;
>
> here and out does
>
> 	__flush_tlb_all();
> 	return ret;

thanks, good catch. I will fix in next rev.

-Brijesh
