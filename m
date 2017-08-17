From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC Part1 PATCH v3 07/17] x86/mm: Include SEV for encryption
 memory attribute changes
Date: Thu, 17 Aug 2017 13:10:45 -0500
Message-ID: <a1daf0f5-57cb-d9c3-79f7-3d4852c35974@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-8-brijesh.singh@amd.com>
 <20170727145841.GG28553@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170727145841.GG28553@nazgul.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin
List-Id: linux-efi@vger.kernel.org

On 7/27/2017 9:58 AM, Borislav Petkov wrote:
> On Mon, Jul 24, 2017 at 02:07:47PM -0500, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> The current code checks only for sme_active() when determining whether
>> to perform the encryption attribute change.  Include sev_active() in this
>> check so that memory attribute changes can occur under SME and SEV.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/mm/pageattr.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
>> index dfb7d65..b726b23 100644
>> --- a/arch/x86/mm/pageattr.c
>> +++ b/arch/x86/mm/pageattr.c
>> @@ -1781,8 +1781,8 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>>   	unsigned long start;
>>   	int ret;
>>   
>> -	/* Nothing to do if the SME is not active */
>> -	if (!sme_active())
>> +	/* Nothing to do if SME and SEV are not active */
>> +	if (!sme_active() && !sev_active())
> 
> This is the second place which does
> 
> 	if (!SME && !SEV)
> 
> I wonder if, instead of sprinking those, we should have a
> 
> 	if (mem_enc_active())
> 
> or so which unifies all those memory encryption logic tests and makes
> the code more straightforward for readers who don't have to pay
> attention to SME vs SEV ...

Yup, that will make things look cleaner and easier to understand.

Thanks,
Tom

> 
> Just a thought.
> 
