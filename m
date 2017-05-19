From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH 2/2] efifb: Avoid reconfiguration of BAR that covers the
 framebuffer
Date: Fri, 19 May 2017 15:44:45 -0500
Message-ID: <20170519204445.GA25510@bhelgaas-glaptop.roam.corp.google.com>
References: <20170404152744.26687-1-ard.biesheuvel@linaro.org>
 <20170404152744.26687-3-ard.biesheuvel@linaro.org>
 <20170519162716.GA684@bhelgaas-glaptop.roam.corp.google.com>
 <CAKv+Gu87gNJ-HN6-jgeuvg7vWePLkP0xbqcok554g2cG9aXtfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu87gNJ-HN6-jgeuvg7vWePLkP0xbqcok554g2cG9aXtfA@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Leif Lindholm <leif.lindholm@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, May 19, 2017 at 05:37:30PM +0100, Ard Biesheuvel wrote:
> Hi Bjorn,
> 
> On 19 May 2017 at 17:27, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > [+cc linux-pci]
> >
> > On Tue, Apr 04, 2017 at 04:27:44PM +0100, Ard Biesheuvel wrote:
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
> >>
> >> So add a non-x86 quirk to the EFI fb driver to find the BAR associated
> >> with the GOP base address, and claim the BAR resource so that the PCI
> >> core will not move it.
> >
> > I know this has already been merged as 55d728a40d36 ("efi/fb: Avoid
> > reconfiguration of BAR that covers the framebuffer"), and I'm not
> > suggesting that we revert it, but I have some misgivings.
> ...

> > Another is the use of pci_claim_resource() to express the idea that "this
> > BAR can not be moved".  We have IORESOURCE_PCI_FIXED for that purpose, and
> > previous versions of the patch used that.  I understand there was some
> > problem with that, but I wish we could figure out and fix that problem
> > instead of using a different mechanism.
> 
> OK. The problem was that IORESOURCE_PCI_FIXED does not prevent the PCI
> subsystem from handing out the same range to another device.

Yes, this would definitely be a problem.  There must be a path where
we start doing the reassignment before we claim the resources that
have already been assigned.  That's what seems backwards to me -- it
seems like we should claim things that are valid first so we know to
avoid them.

> > I'm not even completely sold on the idea that we need to prevent the BAR
> > from being moved.  I'm not a UEFI expert, but if this requirement is in the
> > spec, we should reference it.  If not, it should be sufficient to remember
> > the boot-time BAR value, match the GOP base to *that*, and map it to
> > whatever the current BAR value is.
> 
> There is no such requirement in the spec. The graphics output protocol
> is not described in terms of PCI, BARs etc. The framebuffer is simply
> a memory range with side effects that is left enabled when handing
> over to the OS.
> 
> In summary, I am as unhappy with the patch as you are, but it is still
> an improvement over the previous situation, so let's simply
> collaborate to get this into shape going forward.
> 
> My preference would be to investigate IORESOURCE_PCI_FIXED again,
> because that still seems like the best way to deal with a live
> framebuffer on a PCI device that has memory decoding enabled. It
> should also address the issue with the current version of the patch,
> i.e., that claiming resources at this point is not possible if the
> device resides behind a bridge.
> 
> So is there any guidance you can give as to how to proceed? If we set
> IORESOURCE_PCI_FIXED, how should be prevent the PCI layer from
> assigning this resource elsewhere if we cannot claim it yet?

My preference would actually be to remember the boot BAR values and
map to the current values because that avoids the unnecessary
restriction.  The IORESOURCE_PCI_FIXED uses that seem legitimate to me
are the legacy VGA and IDE things (stuff that's not described by BARs
and *can't* be moved) and the new "Enhanced Allocation" stuff
(basically a way to describe more non-BAR resources).

We do something sort of similar with pci_revert_fw_address(), although
it's currently only implemented for x86.  I could imagine a more
generic solution that could be used for this GOP issue and could also
replace pci_revert_fw_address().

Conceptually it could be as simple as adding 7 u64 boot-time BAR
values (6 BARs + the ROM) to struct pci_dev.  We went to a lot of
trouble to implement the pcibios_fwaddrmap stuff on x86, and I can't
remember why it's x86-specific.  Maybe we thought the extra 56 bytes
per dev was too much overhead (it does seem like a lot for such a
limited use case).  Maybe there's a clever way to store just the BARs
we actually change and keep that long enough for efifb to use it.

It *would* be nice to fix the problem with IORESOURCE_PCI_FIXED, and I
think it would help clean up PCI resource management a lot.  Ideally
we would be able to claim host bridge resources even before scanning
the bus, then claim BARs immediately when we discover them.  That
would allow us to automatically use any setup done by firmware, and
reassign anything that we couldn't claim.

But I think this will end up being difficult because we currently do
the PCI bus scan before looking at ACPI resources, and sometimes those
ACPI resources overlap with the host bridge windows.  Every time I
look at this, I get discouraged.

Bjorn
