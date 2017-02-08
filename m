From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/arm*: Set default address and size cells
 values for an empty dtb
Date: Wed, 8 Feb 2017 11:35:31 +0000
Message-ID: <20170208113530.GC15459@leverpostej>
References: <1486490390-25251-1-git-send-email-jhugo@codeaurora.org>
 <CAKv+Gu963uZB4MaMDuwTGd5-AqEN53Er8tExVLMZNVx3krJrZw@mail.gmail.com>
 <1f47fcdd-c5d8-4082-70a3-ca9b1746d7ca@codeaurora.org>
 <20170207190113.GG26173@leverpostej>
 <c49cc64e-4ca1-8d82-5faf-74c0355c35ef@codeaurora.org>
 <20170207191320.GI26173@leverpostej>
 <252539a6-72f6-1afa-6ed5-3cf6a1aa24c2@codeaurora.org>
 <20170207195558.GK26173@leverpostej>
 <20170208074301.GB18445@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170208074301.GB18445-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Sameer Goel <sgoel-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 08, 2017 at 04:43:04PM +0900, AKASHI, Takahiro wrote:
> On Tue, Feb 07, 2017 at 07:55:59PM +0000, Mark Rutland wrote:

> > (a) The userspace kexec-tools kdump code should take /#address-cells and
> >     /#size-cells into account when inserting the linux,elfcorehdr and
> >     linux,usable-memory-range properties. There can be DTs for 64 bit
> >     platforms where these are not 2.
> >     
> >     Takahiro-san, from looking at your kexec-tools repo, this is not
> >     currently the case. Could you address that?
> 
> Yup, I will, but if this is the case,
> we might need to think about another case where /#address-cells and /#size-cells
> are <1> but the range of crash dump kernel can be still 64-bit wide since
> the system memory information comes from ACPI table (not DT).

That should only happen on an ACPI system for which the vendor has also
provided a DT in the FW, and also chose to use /#address-cells = <1>
and/or /#size-cells = <1>. We could log a warning and give up in this
case.

In the Purely DT case it shouldn't be a problem, since that would imply
all memory is within 32 bits.

... the other option Ard suggested was that we make these properties
always take 64-bit address and size values, and don't use #address-cells
or #size-cells at all when parsing them. I wasn't keen on this since the
properties would be reg-like, but potentially different in size. Maybe
that is the better option, though. :/

> Therefore, the properties in this case should look like:
> / {
>     #address-cells = <1>;
>     #size-cells = <1>;
>     chosen {
>          ...
>          linux,usable-memory-range {
>              #address-cells = <2>;
>              #size-cells = <2>; may be omitted if possible
>              reg = < ... >;
>          }
>          linux,elfcorehdr {
>              #address-cells = <2>;
>              #size-cells = <2>; may be omitted if possible
>              reg = < ... >;
>          }
>          ...
>     }
> }
> 
> Is this what you meant?
> (Obviously, I will have to modify the kernel patches as well.)

No; I was assuming we'd only change the userspace code, not the binding
or the kernel parsing.

If nothing else, the root /#address-cells and /#size-cells would have to
be widened to handle the translation, so the above alone is not
sufficient.

Thanks,
Mark.
