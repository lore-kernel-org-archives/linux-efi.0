From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4] efi: implement mandatory locking for UEFI Runtime Services
Date: Tue, 5 Aug 2014 14:14:38 +0200
Message-ID: <CAKv+Gu8tdHE_iE-1nv6d0TuuUTmpL5-rB3+Exht7jAdE+1jW=A@mail.gmail.com>
References: <1407168960-30128-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140805120332.GO15082@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140805120332.GO15082-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 August 2014 14:03, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Mon, 04 Aug, at 06:16:00PM, Ard Biesheuvel wrote:
>> According to section 7.1 of the UEFI spec, Runtime Services are not fully
>> reentrant, and there are particular combinations of calls that need to be
>> serialized. Use a spinlock to serialize all Runtime Services with respect
>> to all others, even if this is more than strictly needed.
>
> I think we should include something that explains how we've managed to
> get away without an explicit runtime lock for so long,
>
>   We've managed to get away without requiring a runtime services lock
>   until now because most of the interactions with EFI involve EFI
>   variables, and those operations are already serialised with
>   __efivars->lock.
>

Yes, that can go straight into the commit log imo

> and then a little bit of blurb about why that's no longer good enough.
>

"""
Some of the assumptions underlying the decision whether locks are
needed or not (e.g., SetVariable() against ResetSystem()) may not
apply universally to all [new] architectures that implement UEFI.
Rather than try to reason our way out of this, let's just implement at
least what the spec requires in terms of locking.
"""

>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/x86/include/asm/efi.h              |   2 +
>>  drivers/firmware/efi/runtime-wrappers.c | 154 +++++++++++++++++++++++++++++---
>>  2 files changed, 146 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
>> index 044a2fd3c5fe..b39ee5f2c02d 100644
>> --- a/arch/x86/include/asm/efi.h
>> +++ b/arch/x86/include/asm/efi.h
>> @@ -86,6 +86,8 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
>>
>>  #endif /* CONFIG_X86_32 */
>>
>> +#define efi_in_nmi() in_nmi()
>> +
>
> Remind me why this is needed for x86 but not for arm again?
>

The spec specifically mentions "NMI on IA-32 and x64 systems, Machine Check and
INIT on Itanium systems" as asynchronous events that require
additional attention.
No such events exist on ARM or arm64 currently, so there is no need to
implement it there.

> The rest looks good. I'm just running it through some tests now.
>

Cheers,
Ard.
