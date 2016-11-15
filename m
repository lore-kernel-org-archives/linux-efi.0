From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v3 04/20] x86: Handle reduction in physical address
 size with SME
Date: Tue, 15 Nov 2016 11:08:37 -0600
Message-ID: <92827ace-20c5-8549-e667-9fa2becaa1ff@amd.com>
References: <20161110003426.3280.2999.stgit@tlendack-t1.amdoffice.net>
 <20161110003513.3280.12104.stgit@tlendack-t1.amdoffice.net>
 <20161115121035.GD24857@8bytes.org> <20161115121456.f4slpk4i2jl3e2ke@pd.tnic>
 <a4cc5b07-89e1-aaa0-1977-1de95883ba62@amd.com>
 <20161115153338.a2cxmatnpqcgiaiy@pd.tnic>
 <bb47e943-f5b6-0d73-cf9a-fea002a5c70e@amd.com>
 <20161115163350.jal7sd6ghbmk5sqc@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161115163350.jal7sd6ghbmk5sqc@pd.tnic>
Sender: kvm-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander
List-Id: linux-efi@vger.kernel.org

On 11/15/2016 10:33 AM, Borislav Petkov wrote:
> On Tue, Nov 15, 2016 at 10:06:16AM -0600, Tom Lendacky wrote:
>> Yes, but that doesn't relate to the physical address space reduction.
>>
>> Once the SYS_CFG MSR bit for SME is set, even if the encryption bit is
>> never used, there is a physical reduction of the address space. So when
>> checking whether to adjust the physical address bits I can't rely on the
>> sme_me_mask, I have to look at the MSR.
>>
>> But when I'm looking to decide whether to encrypt or decrypt something,
>> I use the sme_me_mask to decide if that is needed.  If the sme_me_mask
>> is not set then the encrypt/decrypt op shouldn't be performed.
>>
>> I might not be grasping the point you're trying to make...
> 
> Ok, let me try to summarize how I see it. There are a couple of states:
> 
> * CPUID bit in 0x8000001f - that's SME supported
> 
> * Reduction of address space - MSR bit. That could be called "SME
> BIOS-eenabled".
> 
> * SME active. That's both of the above and is sme_me_mask != 0.
> 
> Right?

Correct.

> 
> So you said previously "The feature may be present and enabled even if
> it is not currently active."
> 
> But then you say "active" below
> 
>>> And in patch 12 you have:
>>>
>>> +       /*
>>> +        * If memory encryption is active, the trampoline area will need to
>>> +        * be in un-encrypted memory in order to bring up other processors
>>> +        * successfully.
>>> +        */
>>> +       sme_early_mem_dec(__pa(base), size);
>>> +       sme_set_mem_unenc(base, size);
> 
> and test sme_me_mask. Which makes sense now after having explained which
> hw setting controls what.
> 
> So can we agree on the nomenclature for all the different SME states
> first and use those throughout the code? And hold those states down in
> Documentation/x86/amd-memory-encryption.txt so that it is perfectly
> clear to people looking at the code.

Yup, that sounds good.  I'll update the documentation to clarify the
various states/modes of SME.

> 
> Also, if we need to check those states more than once, we should add
> inline helpers:
> 
> sme_supported()
> sme_bios_enabled()
> sme_active()
> 
> How does that sound?

Sounds good.

Thanks,
Tom

> 

