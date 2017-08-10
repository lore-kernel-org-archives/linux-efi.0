From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC Part1 PATCH v3 05/17] x86, realmode: Don't decrypt
 trampoline area under SEV
Date: Thu, 10 Aug 2017 08:03:12 -0500
Message-ID: <c7f50d1e-4410-8ea2-d4d0-06de24a4c2e9@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-6-brijesh.singh@amd.com>
 <20170726160304.GE30471@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170726160304.GE30471@nazgul.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin
List-Id: linux-efi@vger.kernel.org

On 7/26/2017 11:03 AM, Borislav Petkov wrote:
>   Subject: x86/realmode: ...

Done.

> 
> On Mon, Jul 24, 2017 at 02:07:45PM -0500, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> When SEV is active the trampoline area will need to be in encrypted
>> memory so only mark the area decrypted if SME is active.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>   arch/x86/realmode/init.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
>> index 1f71980..c7eeca7 100644
>> --- a/arch/x86/realmode/init.c
>> +++ b/arch/x86/realmode/init.c
>> @@ -63,9 +63,11 @@ static void __init setup_real_mode(void)
>>   	/*
>>   	 * If SME is active, the trampoline area will need to be in
>>   	 * decrypted memory in order to bring up other processors
>> -	 * successfully.
>> +	 * successfully. For SEV the trampoline area needs to be in
>> +	 * encrypted memory, so only do this for SME.
> 
> Or simply say:
> 
> "It is not needed for SEV."

Will do.

Thanks,
Tom

> 
