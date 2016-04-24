From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Date: Sun, 24 Apr 2016 18:58:58 +0200
Message-ID: <20160424165858.GA17019@wunner.de>
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
 <20160405194015.GC15353@localhost>
 <20160406213029.GA12421@wunner.de>
 <20160409120055.GR2701@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160409120055.GR2701@codeblueprint.co.uk>
Sender: linux-pci-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Bjorn Helgaas <helgaas@kernel.org>, linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org, zajec5@gmail.com, b43-dev@lists.infradead.org, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, Andrew Worsley <amworsley@gmail.com>, Chris Bainbridge <chris.bainbridge@gmail.com>
List-Id: linux-efi@vger.kernel.org

Hi,

On Sat, Apr 09, 2016 at 01:00:55PM +0100, Matt Fleming wrote:
> On Wed, 06 Apr, at 11:30:29PM, Lukas Wunner wrote:
> > (2) Find out exactly which EFI boot services area is used for DMA and
> >     amend arch/x86/platform/efi/quirks.c:efi_apply_memmap_quirks() to
> >     assign that area a different type if dmi_match(DMI_SYS_VENDOR,
> >     "Apple Inc."). That way it's not freed by efi_free_boot_services().
> >     Add a late_initcall which calls free_bootmem() for that area.
>  
> If it is possible to find out which boot services region is the
> problematic one, this would be the best solution. If there's any way
> to tie it into the PCI quirk, that would be even better so we don't
> need to maintain the blacklist in two places.

I've since cooked up an experimental patch which resets the Broadcom 4331
wireless card from arch/x86/kernel/early-quirks.c, and another which does
the same from arch/x86/boot/compressed/eboot.c. Both approaches stopped
the spurious interrupts for me and should also stop the DMA'ing.

In the latter case, the machine locked up immediately after resetting the
card. Suspecting that the EFI driver doesn't digest the reset well,
I tried kicking it off the card with DisconnectController() first.
This worked, although it returns EFI_NOT_FOUND, which is strange as that
error isn't defined for DisconnectController() per the spec.

I then tested if DisconnectController() alone is already sufficient
(i.e. without resetting the card by writing to its mmio).
Guess what, it is. So the EFI driver seems to leave the card in a
sane state if it's unloaded.

I then realized that the Simple Network protocol is supported for both
the wireless card as well as the Ethernet card built into my MacBook Pro.
What I'll try next is to iterate over all handles that support that
protocol and just Stop() the interface if it's been brought up by EFI.

Perhaps OS X supports some kind of connection handover from EFI.
That would explain why they leave the card enabled.

Best regards,

Lukas
