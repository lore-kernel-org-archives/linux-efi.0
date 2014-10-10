From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: set PE/COFF section alignment to 4 KB
Date: Fri, 10 Oct 2014 16:21:55 +0100
Message-ID: <20141010152155.GG6004@leverpostej>
References: <1412933124-13018-1-git-send-email-ard.biesheuvel@linaro.org>
 <20141010103301.GC4076@leverpostej>
 <CAKv+Gu9b56r3Ujv342xC5CA3_i4yE6ySd=UjUss2U5Yaho0jAQ@mail.gmail.com>
 <20141010140915.GE6004@leverpostej>
 <CAKv+Gu-mP8VqKZQ46JFBrzYq-Xko9h9JYRoghwGjr2mfxA29SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-mP8VqKZQ46JFBrzYq-Xko9h9JYRoghwGjr2mfxA29SQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 10, 2014 at 03:50:49PM +0100, Ard Biesheuvel wrote:
> On 10 October 2014 16:09, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > On Fri, Oct 10, 2014 at 11:37:03AM +0100, Ard Biesheuvel wrote:
> >> On 10 October 2014 12:33, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> >> > Hi Ard,
> >> >
> >> > On Fri, Oct 10, 2014 at 10:25:24AM +0100, Ard Biesheuvel wrote:
> >> >> Position independent AArch64 code needs to be linked and loaded at the same
> >> >> relative offset from a 4 KB boundary, or adrp/add and adrp/ldr pairs will
> >> >> not work correctly. (This is how PC relative symbol references with a 4 GB
> >> >> reach are emitted)
> >> >>
> >> >> We need to declare this in the PE/COFF header, otherwise the PE/COFF loader
> >> >> may load the Image and invoke the stub at an offset which violates this rule.
> >> >
> >> > Has this been observed happening, or was this just found by inspection?
> >> >
> >>
> >> This is also something found by inspection, or rather, by the
> >> discussion going on in the other thread. I am not aware of any PE/COFF
> >> loaders that may choose an offset that is not 4 KB aligned, even if
> >> the header we give it appears to allow it.
> >>
> >> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >> >> ---
> >> >>  arch/arm64/kernel/head.S | 4 ++--
> >> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >> >>
> >> >> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> >> >> index 0a6e4f924df8..5e83e5b8a9de 100644
> >> >> --- a/arch/arm64/kernel/head.S
> >> >> +++ b/arch/arm64/kernel/head.S
> >> >> @@ -159,7 +159,7 @@ optional_header:
> >> >>
> >> >>  extra_header_fields:
> >> >>       .quad   0                               // ImageBase
> >> >> -     .long   0x20                            // SectionAlignment
> >> >> +     .long   0x1000                          // SectionAlignment
> >
> > Looking at this again, I'm more confused than I was to begin with.
> >
> 
> :-)
> 
> > Surely we know exactly where the .text section will be loaded because of
> > its VirtualAddress? If that were the case, we can drop the .align 12 as
> > we already load it at the offset any arp or :lo12: immediate will have
> > been built for.
> >
> 
> No, not quite. It only tells us what the /offset/ should be of the
> section from the ImageBase chosen by the loader, not what the
> alignment of ImageBase itself should be. For instance, with a section
> VirtualAddress of 0x1000 and a SectionAlignment of 0x400, the section
> could legally be loaded @ 0x1400 or 0x1800 (for ImageBase == 0x400 or
> 0x800, respectively)

I see.

I had myself confused between the image and sections, and (mistakenly)
thought we had control over the alignment of the image as opposed to
sections. I thought the loader chose an ImageBase that was sufficiently
aligned, then just loaded each segment at the requested offset from
that. It sounds like the loader actually has to try to reconcile the
offset of each section against each other to determine an ImageBase to
use.

Given that the only thing we can control the alignment of is the .text
section (with an offset applied below that), aligning the .text section
to 4k sounds right.

Thanks for bearing with me!

Thanks,
Mark.
