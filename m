From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Tue, 15 Jul 2014 12:31:38 +0100
Message-ID: <20140715113138.GZ26465@leverpostej>
References: <1405415402-3427-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140715095704.GV26465@leverpostej>
 <CAKv+Gu_PUJVXbDqp5Y3jdVouWhSqPVzaOi_6bpFM6BaLVrwvTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_PUJVXbDqp5Y3jdVouWhSqPVzaOi_6bpFM6BaLVrwvTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> >> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> >> index 619b1dd7bcde..6ef541731d9e 100644
> >> --- a/arch/arm64/kernel/efi-entry.S
> >> +++ b/arch/arm64/kernel/efi-entry.S
> >> @@ -61,7 +61,7 @@ ENTRY(efi_stub_entry)
> >>        */
> >>       mov     x20, x0         // DTB address
> >>       ldr     x0, [sp, #16]   // relocated _text address
> >> -     mov     x21, x0
> >> +     add     x21, x0, #:lo12:stext_offset
> >
> > I think we can drop the :lo12: here, which will allow us to have a
> > warning if stext_offset is unexpectedly large (I believe this will
> > currently silently mask bits were that to happen?).
> >
> 
> There is no alternative lo12 relocation that errors out when the value
> does not fit, so it would have to use a literal instead.

Ah, that's a shame. What happens when the value doesn't fit if the
linker / assembler don't error out?

That sounds like a toolchain bug if they're silently doing the wrong
thing.

Cheers,
Mark.
