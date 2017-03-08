From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] x86/mm/KASLR: Correct the upper boundary of KALSR mm
 regions if adjacent to EFI
Date: Wed, 8 Mar 2017 14:05:53 +0530
Message-ID: <CACi5LpNOyiVmy4hTSXAJWT1p=DD65=wijgJMTcOAo9YudiD_pw@mail.gmail.com>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
 <1488959258-4731-2-git-send-email-bhe@redhat.com> <20170308081857.GB12600@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170308081857.GB12600-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 8, 2017 at 1:48 PM, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 03/08/17 at 03:47pm, Baoquan He wrote:
>> EFI allocates runtime services regions top-down, starting from EFI_VA_START
>> to EFI_VA_END. So EFI_VA_START is bigger than EFI_VA_END and is the end of
>> EFI region. The upper boundary of memory regions randomized by KASLR should
>> be EFI_VA_END if it's adjacent to EFI region, but not EFI_VA_START.
>>
>> Correct it in this patch.
>>
>> Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  arch/x86/mm/kaslr.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
>> index 887e571..aed2064 100644
>> --- a/arch/x86/mm/kaslr.c
>> +++ b/arch/x86/mm/kaslr.c
>> @@ -48,7 +48,7 @@ static const unsigned long vaddr_start = __PAGE_OFFSET_BASE;
>>  #if defined(CONFIG_X86_ESPFIX64)
>>  static const unsigned long vaddr_end = ESPFIX_BASE_ADDR;
>>  #elif defined(CONFIG_EFI)
>> -static const unsigned long vaddr_end = EFI_VA_START;
>> +static const unsigned long vaddr_end = EFI_VA_END;
>>  #else
>>  static const unsigned long vaddr_end = __START_KERNEL_map;
>>  #endif
>> @@ -105,7 +105,7 @@ void __init kernel_randomize_memory(void)
>>        */
>>       BUILD_BUG_ON(vaddr_start >= vaddr_end);
>>       BUILD_BUG_ON(IS_ENABLED(CONFIG_X86_ESPFIX64) &&
>> -                  vaddr_end >= EFI_VA_START);
>> +                  vaddr_end >= EFI_VA_END);
>>       BUILD_BUG_ON((IS_ENABLED(CONFIG_X86_ESPFIX64) ||
>>                     IS_ENABLED(CONFIG_EFI)) &&
>>                    vaddr_end >= __START_KERNEL_map);
>> --
>> 2.5.5
>>
>
> Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Thanks Bao for this fix. This makes the KASLR code consistent with
Address space markers hints in [1]

[1] http://lxr.free-electrons.com/source/arch/x86/mm/dump_pagetables.c#L82

Reviewed-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Regards,
Bhupesh
