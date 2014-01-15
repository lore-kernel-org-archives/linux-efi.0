From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V6 6/8] Add EFI stub for ARM
Date: Wed, 15 Jan 2014 11:47:00 +0000
Message-ID: <20140115114700.GI30907@bivouac.eciton.net>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
 <1389371417-379-7-git-send-email-roy.franz@linaro.org>
 <CAKv+Gu9OfieNhvj07tQv+ucQomZhDVDxwdV3Z9Tm+HaHE8HG-Q@mail.gmail.com>
 <CAFECyb9jx4NA0v_qNgrto4qG3KV3fBOpGh839Mnvbjody4xwYA@mail.gmail.com>
 <CAFECyb9jbVHjM7--tRgbjfS9_MaAAvOhR3qXEKPKS6eW23V9Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb9jbVHjM7--tRgbjfS9_MaAAvOhR3qXEKPKS6eW23V9Kg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 14, 2014 at 06:16:58PM -0800, Roy Franz wrote:
> >>> +      .align 3
> >>> +pe_header:
> >>> +       .ascii  "PE"
> >>> +       .short  0
> >>> +
> >>> +coff_header:
> >>> +       .short  0x01c2                          @ ARM or Thumb
> >>
> >> Could you explain why you are using 0x1c2 (Thumb) here and not 0x1c0 (ARM) ?
> >
> > Nope.  It should be 0x1c0.
> 
> OK, now I resolved the nagging feeling that I had already fixed
> this...   Right now, the EDK2 UEFI implementation
> requires the machine type for ARM to be "0x1c2".  I don't think that
> this is correct, but correcting this in EDK2 slipped through
> the cracks, but is now back on my todo list.

Nope, it should be 0x1c2.

0x1c0 is the COFF code for ARM only, which corresponds roughly with
OABI - which is not supported (and never will be) by the UEFI
specification.
0x1c2 means ARM or Thumb (Interworking), which is what we have.

The UEFI specification (correctly) neglects to even mention 0x1c0
and 0x1c4.

Do also note that the COFF information relates to the executable,
the stub. The rest of the kernel image is just a blob as far as UEFI
is concerned.

> I think that for now we should leave this as 0x1c2 so that the
> unpatched EDK2 builds will boot it, and some time after EDK2 is
> updated
> this can be changed.  I'll work on a patch for EDK2 and get the
> discussion going on that list to resolve this in EDK2.

No need.

/
    Leif
