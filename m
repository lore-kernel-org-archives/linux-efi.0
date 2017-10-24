From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm: omit sorting of the UEFI memory map
Date: Tue, 24 Oct 2017 12:21:07 +0100
Message-ID: <20171024112107.GB31064@arm.com>
References: <20171022141457.28769-1-ard.biesheuvel@linaro.org>
 <20171024110519.GE20805@n2100.armlinux.org.uk>
 <CAKv+Gu8gPHj1jV1ZyW8u1qSb5F=L6HDrmCcVueo0szy+2USsXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8gPHj1jV1ZyW8u1qSb5F=L6HDrmCcVueo0szy+2USsXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jeffy Chen <jeffy.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Matthias Brugger <mbrugger-IBi9RG/b67k@public.gmane.org>, Chris Zhong <zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 24, 2017 at 12:09:59PM +0100, Ard Biesheuvel wrote:
> On 24 October 2017 at 12:05, Russell King - ARM Linux
> <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org> wrote:
> > On Sun, Oct 22, 2017 at 03:14:57PM +0100, Ard Biesheuvel wrote:
> >> ARM shares its EFI stub implementation with arm64, which has some
> >> special handling in the virtual remapping code to
> >> a) make sure that we can map everything even if the OS executes
> >>    with 64k page size, and
> >> b) make sure that adjacent regions with the same attributes are not
> >>    reordered or moved apart in memory.
> >>
> >> The latter is a workaround for a 'feature' that was shortly recommended
> >> by UEFI spec v2.5, but deprecated shortly after, due to the fact that
> >> it broke many OS installers, including non-Linux ones, and it was never
> >> widely implemented for ARM systems. Before implementing b), the arm64
> >> code simply rounded up all regions to 64 KB granularity, but given that
> >> that results in moving adjacent regions apart, it had to be refined when
> >> b) was implemented.
> >>
> >> The adjacency check requires a sort() pass, due to the fact that the
> >> UEFI spec does not mandate any ordering, and the inclusion of the
> >> lib/sort.c code into the ARM EFI stub is causing some trouble with
> >> the decompressor build due to the fact that its EXPORT_SYMBOL() call
> >> triggers the creation of ksymtab/kcrctab sections.
> >>
> >> So let's simply do away with the adjacency check for ARM, and simply put
> >> all UEFI runtime regions together if they have the same memory attributes.
> >> This is guaranteed to work, given that ARM only supports 4 KB pages,
> >> and allows us to remove the sort() call entirely.
> >>
> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >
> > I guess as this is shared between ARM and ARM64, ARM64 folk should ack
> > this before I merge it - can I have an ack from that side please?
> >
> 
> Note that the patch does not touch arch/arm64, nor does it affect
> arm64, given that the change is a no-op if CONFIG_ARM64=y. That said,
> I welcome any acks from the arm64 maintainers, but I don't think they
> are actually required here.

Looks fine to me:

Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>

Thanks,

Will
