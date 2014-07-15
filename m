From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: efistub: jump to 'stext' directly, not through
 the header
Date: Tue, 15 Jul 2014 13:49:07 +0200
Message-ID: <CAKv+Gu_1vYA+akR4_fAeTd+p22kt-EfcJHu+9sVBBToUnSO8_Q@mail.gmail.com>
References: <1405415402-3427-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140715095704.GV26465@leverpostej>
	<CAKv+Gu_PUJVXbDqp5Y3jdVouWhSqPVzaOi_6bpFM6BaLVrwvTQ@mail.gmail.com>
	<20140715113138.GZ26465@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715113138.GZ26465@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15 July 2014 13:31, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>> >> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
>> >> index 619b1dd7bcde..6ef541731d9e 100644
>> >> --- a/arch/arm64/kernel/efi-entry.S
>> >> +++ b/arch/arm64/kernel/efi-entry.S
>> >> @@ -61,7 +61,7 @@ ENTRY(efi_stub_entry)
>> >>        */
>> >>       mov     x20, x0         // DTB address
>> >>       ldr     x0, [sp, #16]   // relocated _text address
>> >> -     mov     x21, x0
>> >> +     add     x21, x0, #:lo12:stext_offset
>> >
>> > I think we can drop the :lo12: here, which will allow us to have a
>> > warning if stext_offset is unexpectedly large (I believe this will
>> > currently silently mask bits were that to happen?).
>> >
>>
>> There is no alternative lo12 relocation that errors out when the value
>> does not fit, so it would have to use a literal instead.
>
> Ah, that's a shame. What happens when the value doesn't fit if the
> linker / assembler don't error out?
>

Obviously, it will jump into the wrong place if stext ever gets pushed
beyond a 4k boundary, which is not that likely (current value is
0x160, we may want to up it to 0x200 at some point if we need to
increase the PE/COFF section alignment, which some versions of the
(poor) PE/COFF documentation say should be 0x200 at the minimum)

However, doing ldr x21, =stext_offset works fine as well

> That sounds like a toolchain bug if they're silently doing the wrong
> thing.
>

Meh, don't think so, really. You get what you pay for, and :lo12: just
isn't supposed to care. (It's mainly used with adrp to get a +/- 4gb
PC relative reach)

-- 
Ard.
