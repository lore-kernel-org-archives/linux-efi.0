From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: add 'offset' param to efi_low_alloc()
Date: Thu, 30 Jul 2015 16:06:51 +0200
Message-ID: <CAKv+Gu9Lrfr594rUYdv-5QngiBf3FcNJ447U7Nnb07aW5kTgwg@mail.gmail.com>
References: <1438164259-14470-1-git-send-email-ard.biesheuvel@linaro.org>
	<1438164259-14470-2-git-send-email-ard.biesheuvel@linaro.org>
	<20150730140144.GH2725@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730140144.GH2725-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 30 July 2015 at 16:01, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Wed, 29 Jul, at 12:04:18PM, Ard Biesheuvel wrote:
>> In some cases, e.g., when allocating memory for the arm64 kernel,
>> we need memory at a certain offset from an aligned boundary. So add
>> an offset parameter to efi_low_alloc(), and update the existing
>> callers to pass zero by default.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/kernel/efi-stub.c                   |  2 +-
>>  arch/x86/boot/compressed/eboot.c               |  4 ++--
>>  drivers/firmware/efi/libstub/efi-stub-helper.c | 20 +++++++++++++++-----
>>  include/linux/efi.h                            |  2 +-
>>  4 files changed, 19 insertions(+), 9 deletions(-)
>
> [...]
>
>> @@ -269,10 +269,19 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>>                * checks pointers against NULL. Skip the first 8
>>                * bytes so we start at a nice even number.
>>                */
>> -             if (start == 0x0)
>> +             if (start + offset == 0x0)
>>                       start += 8;
>>
>> -             start = round_up(start, align);
>> +             /*
>> +              * Check if the offset exceeds the misalignment of this region.
>> +              * In that case, we can round down instead of up, and the
>> +              * resulting start value will be correctly aligned and still
>> +              * point past the start of the region.
>> +              */
>> +             if (offset >= (start & (align - 1)))
>> +                     start = round_down(start, align) + offset;
>> +             else
>> +                     start = round_up(start, align) + offset;
>>               if ((start + size) > end)
>>                       continue;
>
> Aha, now I see what you mean. Thanks for doing this Ard, these are much
> more polished than what I was expecting.
>
> I'm gonna have to NAK this because it's just too much of a special case
> to support directly in efi_low_alloc(), which I think was the exact
> point that you made originally, and which I was too tired/dumb to
> understand. Sorry.
>

No worries. Will has already queued the original patch, which solves
all know issues regarding the placement of the kernel image by the EFI
stub.

> In particular, the fact that you can use the offset argument to violate
> the requested alignment seems like it would trip up most users.
>

Yes. We could always rename this enhanced efi_low_alloc() to
efi_low_alloc_with_offset() and introduce a new efi_low_alloc() which
calls it using an offset of zero. But only if you insist.

-- 
Ard.
