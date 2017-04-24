From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 09/32] x86/mm: Provide general kernel support for
 memory encryption
Date: Mon, 24 Apr 2017 10:53:58 -0500
Message-ID: <9fc79e28-ad64-1c2f-4c46-a4efcdd550b0@amd.com>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
 <20170418211754.10190.25082.stgit@tlendack-t1.amdoffice.net>
 <0106e3fc-9780-e872-2274-fecf79c28923@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <0106e3fc-9780-e872-2274-fecf79c28923@intel.com>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@intel.com>, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org
Cc: Rik van Riel <riel@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, "Michael S. Tsirkin" <mst@redhat.com>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>
List-Id: linux-efi@vger.kernel.org

On 4/21/2017 4:52 PM, Dave Hansen wrote:
> On 04/18/2017 02:17 PM, Tom Lendacky wrote:
>> @@ -55,7 +57,7 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
>>  	__phys_addr_symbol(__phys_reloc_hide((unsigned long)(x)))
>>
>>  #ifndef __va
>> -#define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
>> +#define __va(x)			((void *)(__sme_clr(x) + PAGE_OFFSET))
>>  #endif
>
> It seems wrong to be modifying __va().  It currently takes a physical
> address, and this modifies it to take a physical address plus the SME bits.

This actually modifies it to be sure the encryption bit is not part of
the physical address.

>
> How does that end up ever happening?  If we are pulling physical
> addresses out of the page tables, we use p??_phys().  I'd expect *those*
> to be masking off the SME bits.
>
> Is it these cases?
>
> 	pgd_t *base = __va(read_cr3());
>
> For those, it seems like we really want to create two modes of reading
> cr3.  One that truly reads CR3 and another that reads the pgd's physical
> address out of CR3.  Then you only do the SME masking on the one
> fetching a physical address, and the SME bits never leak into __va().

I'll investigate this and see if I can remove the mod to __va().

Thanks,
Tom

>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
