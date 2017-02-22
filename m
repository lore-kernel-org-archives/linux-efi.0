From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [RFC PATCH v4 07/28] x86: Provide general kernel support for
 memory encryption
Date: Wed, 22 Feb 2017 10:43:41 -0600
Message-ID: <9b048215-0e78-dbf0-e82c-de3a1ee91ff3@amd.com>
References: <20170216154158.19244.66630.stgit@tlendack-t1.amdoffice.net>
 <20170216154332.19244.55451.stgit@tlendack-t1.amdoffice.net>
 <20170220183823.k7bsg77wbb4xyc2s@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170220183823.k7bsg77wbb4xyc2s-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy
List-Id: linux-efi@vger.kernel.org

On 2/20/2017 12:38 PM, Borislav Petkov wrote:
> On Thu, Feb 16, 2017 at 09:43:32AM -0600, Tom Lendacky wrote:
>> Adding general kernel support for memory encryption includes:
>> - Modify and create some page table macros to include the Secure Memory
>>   Encryption (SME) memory encryption mask
>> - Modify and create some macros for calculating physical and virtual
>>   memory addresses
>> - Provide an SME initialization routine to update the protection map with
>>   the memory encryption mask so that it is used by default
>> - #undef CONFIG_AMD_MEM_ENCRYPT in the compressed boot path
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>
> ...
>
>> +#define __sme_pa(x)		(__pa((x)) | sme_me_mask)
>> +#define __sme_pa_nodebug(x)	(__pa_nodebug((x)) | sme_me_mask)
>> +
>>  #else	/* !CONFIG_AMD_MEM_ENCRYPT */
>>
>>  #ifndef sme_me_mask
>> @@ -35,6 +42,13 @@ static inline bool sme_active(void)
>>  }
>>  #endif
>>
>> +static inline void __init sme_early_init(void)
>> +{
>> +}
>> +
>> +#define __sme_pa		__pa
>> +#define __sme_pa_nodebug	__pa_nodebug
>
> One more thing - in the !CONFIG_AMD_MEM_ENCRYPT case, sme_me_mask is 0
> so you don't need to define __sme_pa* again.

Makes sense.  I'll move those macros outside the #ifdef (I'll do the
same for the new __sme_clr() and __sme_set() macros, too).

Thanks,
Tom

>
