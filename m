From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC Part1 PATCH v3 03/17] x86/mm: Secure Encrypted
 Virtualization (SEV) support
Date: Wed, 26 Jul 2017 11:47:32 -0500
Message-ID: <facf3ac6-ebda-57a7-f961-6029b3ac7be7@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-4-brijesh.singh@amd.com>
 <20170726042840.GB30702@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170726042840.GB30702@nazgul.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin
List-Id: linux-efi@vger.kernel.org

On 7/25/2017 11:28 PM, Borislav Petkov wrote:
> On Mon, Jul 24, 2017 at 02:07:43PM -0500, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Provide support for Secure Encyrpted Virtualization (SEV). This initial
> 
> Your subject misses a verb and patch subjects should have an active verb
> denoting what the patch does. The sentence above is a good example.

Yup, will update.

> 
>> support defines a flag that is used by the kernel to determine if it is
>> running with SEV active.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/include/asm/mem_encrypt.h | 2 ++
>>   arch/x86/mm/mem_encrypt.c          | 3 +++
>>   include/linux/mem_encrypt.h        | 8 +++++++-
>>   3 files changed, 12 insertions(+), 1 deletion(-)
> 
> ...
> 
>> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
>> index 0fbd092..1e4643e 100644
>> --- a/arch/x86/mm/mem_encrypt.c
>> +++ b/arch/x86/mm/mem_encrypt.c
>> @@ -40,6 +40,9 @@ static char sme_cmdline_off[] __initdata = "off";
>>   unsigned long sme_me_mask __section(.data) = 0;
>>   EXPORT_SYMBOL_GPL(sme_me_mask);
>>   
>> +unsigned int sev_enabled __section(.data) = 0;
>> +EXPORT_SYMBOL_GPL(sev_enabled);
> 
> So sev_enabled is a pure bool used only in bool context, not like
> sme_me_mask whose value is read too. Which means, you can make the
> former static and query it only through accessor functions.

If it's made static then the sme_active()/sev_active() inline functions
would need to be turned into functions within the mem_encrypt.c file. So
there's a trade-off to do that, which is the better one?

> 
>>   /* Buffer used for early in-place encryption by BSP, no locking needed */
>>   static char sme_early_buffer[PAGE_SIZE] __aligned(PAGE_SIZE);
>>   
>> diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
>> index 1255f09..ea0831a 100644
>> --- a/include/linux/mem_encrypt.h
>> +++ b/include/linux/mem_encrypt.h
>> @@ -22,12 +22,18 @@
>>   #else	/* !CONFIG_ARCH_HAS_MEM_ENCRYPT */
>>   
>>   #define sme_me_mask	0UL
>> +#define sev_enabled	0
>>   
>>   #endif	/* CONFIG_ARCH_HAS_MEM_ENCRYPT */
>>   
>>   static inline bool sme_active(void)
>>   {
>> -	return !!sme_me_mask;
>> +	return (sme_me_mask && !sev_enabled);
> 
> You don't need the brackets. Below too.

Ok.

> 
>> +}
>> +
>> +static inline bool sev_active(void)
>> +{
>> +	return (sme_me_mask && sev_enabled);
>>   }
> 
> So this is confusing, TBH. SME and SEV are not mutually exclusive and
> yet the logic here says so. Why?
> 
> I mean, in the hypervisor context, sme_active() is still true.
> 
> /me is confused.

The kernel needs to distinguish between running under SME and running
under SEV. SME and SEV are similar but not the same. The trampoline code
is a good example.  Before paging is activated, SME will access all
memory as decrypted, but SEV will access all memory as encrypted.  So
when APs are being brought up under SME the trampoline area cannot be
encrypted, whereas under SEV the trampoline area must be encrypted.

Thanks,
Tom

> 
