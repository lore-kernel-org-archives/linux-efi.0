From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH 2/2] x86/mm/KASLR: Correct the upper boundary of KALSR mm
 regions if adjacent to EFI
Date: Wed, 8 Mar 2017 07:32:41 -0800
Message-ID: <CAJcbSZH9aKLDYpvbjooB=c+BWsRnv4Xvsmg7ScEjHSBDwWXWLw@mail.gmail.com>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
 <1488959258-4731-2-git-send-email-bhe@redhat.com> <20170308081857.GB12600@dhcp-128-65.nay.redhat.com>
 <CACi5LpNOyiVmy4hTSXAJWT1p=DD65=wijgJMTcOAo9YudiD_pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACi5LpNOyiVmy4hTSXAJWT1p=DD65=wijgJMTcOAo9YudiD_pw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

Thanks for the change.

Acked-by: Thomas Garnier <thgarnie@google.com>

On Wed, Mar 8, 2017 at 12:35 AM, Bhupesh Sharma <bhsharma@redhat.com> wrote:
> On Wed, Mar 8, 2017 at 1:48 PM, Dave Young <dyoung@redhat.com> wrote:
>> On 03/08/17 at 03:47pm, Baoquan He wrote:
>>> EFI allocates runtime services regions top-down, starting from EFI_VA_START
>>> to EFI_VA_END. So EFI_VA_START is bigger than EFI_VA_END and is the end of
>>> EFI region. The upper boundary of memory regions randomized by KASLR should
>>> be EFI_VA_END if it's adjacent to EFI region, but not EFI_VA_START.
>>>
>>> Correct it in this patch.
>>>
>>> Signed-off-by: Baoquan He <bhe@redhat.com>
>>> ---
>>>  arch/x86/mm/kaslr.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
>>> index 887e571..aed2064 100644
>>> --- a/arch/x86/mm/kaslr.c
>>> +++ b/arch/x86/mm/kaslr.c
>>> @@ -48,7 +48,7 @@ static const unsigned long vaddr_start = __PAGE_OFFSET_BASE;
>>>  #if defined(CONFIG_X86_ESPFIX64)
>>>  static const unsigned long vaddr_end = ESPFIX_BASE_ADDR;
>>>  #elif defined(CONFIG_EFI)
>>> -static const unsigned long vaddr_end = EFI_VA_START;
>>> +static const unsigned long vaddr_end = EFI_VA_END;
>>>  #else
>>>  static const unsigned long vaddr_end = __START_KERNEL_map;
>>>  #endif
>>> @@ -105,7 +105,7 @@ void __init kernel_randomize_memory(void)
>>>        */
>>>       BUILD_BUG_ON(vaddr_start >= vaddr_end);
>>>       BUILD_BUG_ON(IS_ENABLED(CONFIG_X86_ESPFIX64) &&
>>> -                  vaddr_end >= EFI_VA_START);
>>> +                  vaddr_end >= EFI_VA_END);
>>>       BUILD_BUG_ON((IS_ENABLED(CONFIG_X86_ESPFIX64) ||
>>>                     IS_ENABLED(CONFIG_EFI)) &&
>>>                    vaddr_end >= __START_KERNEL_map);
>>> --
>>> 2.5.5
>>>
>>
>> Acked-by: Dave Young <dyoung@redhat.com>
>>
>
> Thanks Bao for this fix. This makes the KASLR code consistent with
> Address space markers hints in [1]
>
> [1] http://lxr.free-electrons.com/source/arch/x86/mm/dump_pagetables.c#L82
>
> Reviewed-by: Bhupesh Sharma <bhsharma@redhat.com>
>
> Regards,
> Bhupesh



-- 
Thomas
