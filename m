From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Thu, 23 Mar 2017 09:48:19 +0100
Message-ID: <20170323084819.GA23281@h08.hostsharing.net>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de>
 <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Heyi Guo <heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 22, 2017 at 07:32:43PM +0000, Ard Biesheuvel wrote:
> On 22 March 2017 at 19:31, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
> > On Wed, Mar 22, 2017 at 03:30:29PM +0000, Ard Biesheuvel wrote:
> >> On UEFI systems, the PCI subsystem is enumerated by the firmware,
> >> and if a graphical framebuffer is exposed by a PCI device, its base
> >> address and size are exposed to the OS via the Graphics Output
> >> Protocol (GOP).
> >>
> >> On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
> >> scratch at boot. This may result in the GOP framebuffer address to
> >> become stale, if the BAR covering the framebuffer is modified. This
> >> will cause the framebuffer to become unresponsive, and may in some
> >> cases result in unpredictable behavior if the range is reassigned to
> >> another device.
> >
> > Hm, commit message seems to indicate the issue is restricted to arm64,
> > yet there's no IS_ENABLED(ARM64) to constrain the added code to that arch?
> 
> True. I am eager to get some x86 coverage for this, since I would
> expect this not to do any harm. But I'm fine with making it ARM/arm64
> specific in the final version.

I see.  IIUC, this is only a problem because pci_bus_assign_resources()
is called from arch/arm64/kernel/pci.c:pci_acpi_scan_root() (as well as
the host drivers) and x86 isn't affected because it doesn't do that.

I have no opinion on executing the quirk on x86 as well, I was just
confused by the discrepancy between commit message and patch, but that
can easily be remedied with a copy+paste of what you replied to Sinan:

       "On x86, it works, given that BARs are usually not reassigned,
	and so the patch should be a no-op in that case, although it
	should still be an improvement to check whether the device that
	owns the BAR actually has memory decoding enabled before we
	attach the framebuffer driver to it."


> >> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);
> >
> > Maybe this can be constrained to PCI_BASE_CLASS_DISPLAY?
> 
> How does one do that with DECLARE_PCI_FIXUP_HEADER?

With DECLARE_PCI_FIXUP_CLASS_HEADER().

Thanks,

Lukas
