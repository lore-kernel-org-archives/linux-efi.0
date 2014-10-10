From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Fri, 10 Oct 2014 09:53:45 -0400
Message-ID: <20141010135344.GB14660@fenchurch.internal.datastacks.com>
References: <1412777487-13636-1-git-send-email-ard.biesheuvel@linaro.org>
 <20141009172354.GA466@leverpostej>
 <CAKv+Gu-D812Rn32rm5wQJfSM+NzPXZWbxDcDkZ8mBzbi5RQJXQ@mail.gmail.com>
 <1412893179.29182.71.camel@deneb.redhat.com>
 <CAFECyb9Tz2Fo2ix0VYiM7WPeie7C=woiVwyQtR4aH_HPcLwkOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb9Tz2Fo2ix0VYiM7WPeie7C=woiVwyQtR4aH_HPcLwkOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 09, 2014 at 04:20:19PM -0700, Roy Franz wrote:
> I think we'll also run into some alignment issues if the loader really just
> loads the section ( we just have the one) rather than the whole file.
> From reviewing the PE/COFF spec again we violate the relationship
> between FileAlignment and SectionAlignment.

It's hard to pin down exactly whose burden this is - clearly the RVAs
and the File Addresses in the binary are supposed to jive with
SectionAlignment and FileAlignment, respectively, but if they don't,
it's unclear what a loader should do about it.  I've got some (x86)
hardware where LoadImage() rejects the binary entirely in this case, but
the code in tiano doesn't seem to care.  Our loader code in shim ignores
both fields entirely - once we've checked validity in terms of overlap
and boundaries, we happily give sections whatever offset they've
requested.  I suppose on some machines that may mean that a malformed
binary gets a /fault/ pretty quickly.  I'll add checks for those
alignments in shim 0.9 , release date TBD.

So because of that x86 machine that does error out, I've got some
different values here:
https://github.com/vathpela/shim/blob/manual-headers/crt0-efi-x86_64.S#L72
than Ard does in his Aarch64 headers.  There are some other things
wrong on that branch because I didn't understand well enough while
writing some of it - it's basically still there for reference, I don't
anticipate ever shipping it.

-- 
        Peter
