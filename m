From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 07/20] x86: Provide general kernel support for
 memory encryption
Date: Wed, 7 Sep 2016 09:19:36 -0500
Message-ID: <74f3288f-afc7-2170-89ff-a0334451da82@amd.com>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
 <20160822223646.29880.28794.stgit@tlendack-t1.amdoffice.net>
 <20160905152211.GD18856@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160905152211.GD18856@pd.tnic>
Sender: linux-doc-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dm
List-Id: linux-efi@vger.kernel.org

On 09/05/2016 10:22 AM, Borislav Petkov wrote:
> On Mon, Aug 22, 2016 at 05:36:46PM -0500, Tom Lendacky wrote:
>> Adding general kernel support for memory encryption includes:
>> - Modify and create some page table macros to include the Secure Memory
>>   Encryption (SME) memory encryption mask
>> - Update kernel boot support to call an SME routine that checks for and
>>   sets the SME capability (the SME routine will grow later and for now
>>   is just a stub routine)
>> - Update kernel boot support to call an SME routine that encrypts the
>>   kernel (the SME routine will grow later and for now is just a stub
>>   routine)
>> - Provide an SME initialization routine to update the protection map with
>>   the memory encryption mask so that it is used by default
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> ...
> 
>> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
>> index c98a559..30f7715 100644
>> --- a/arch/x86/kernel/head_64.S
>> +++ b/arch/x86/kernel/head_64.S
>> @@ -95,6 +95,13 @@ startup_64:
>>  	jnz	bad_address
>>  
>>  	/*
>> +	 * Enable memory encryption (if available). Add the memory encryption
>> +	 * mask to %rbp to include it in the the page table fixup.
>> +	 */
>> +	call	sme_enable
>> +	addq	sme_me_mask(%rip), %rbp
>> +
>> +	/*
>>  	 * Fixup the physical addresses in the page table
>>  	 */
>>  	addq	%rbp, early_level4_pgt + (L4_START_KERNEL*8)(%rip)
>> @@ -116,7 +123,8 @@ startup_64:
>>  	movq	%rdi, %rax
>>  	shrq	$PGDIR_SHIFT, %rax
>>  
>> -	leaq	(4096 + _KERNPG_TABLE)(%rbx), %rdx
>> +	leaq	(4096 + __KERNPG_TABLE)(%rbx), %rdx
>> +	addq	sme_me_mask(%rip), %rdx		/* Apply mem encryption mask */
> 
> Please add comments over the line and not at the side...

Ok, will do.

Thanks,
Tom

> 
