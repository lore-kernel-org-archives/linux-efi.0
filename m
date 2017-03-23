From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Thu, 23 Mar 2017 14:31:51 +0000
Message-ID: <20170323143151.GA21544@red-moon>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de>
 <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
 <20170323084819.GA23281@h08.hostsharing.net>
 <CAKv+Gu93eJ-js3g7M6Jdm6XGMaWMswFmzBG2qNT4rn+3=1+EyA@mail.gmail.com>
 <20170323105727.GA2441@red-moon>
 <CAKv+Gu-J664KXaZR19nViq4o1n_x=P-trsZ0oNDiONuBpAcd7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-J664KXaZR19nViq4o1n_x=P-trsZ0oNDiONuBpAcd7A@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Lukas Wunner <lukas@wunner.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Mar 23, 2017 at 12:25:48PM +0000, Ard Biesheuvel wrote:
> On 23 March 2017 at 10:57, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> > On Thu, Mar 23, 2017 at 09:04:03AM +0000, Ard Biesheuvel wrote:
> >> On 23 March 2017 at 08:48, Lukas Wunner <lukas@wunner.de> wrote:
> >> > On Wed, Mar 22, 2017 at 07:32:43PM +0000, Ard Biesheuvel wrote:
> >> >> On 22 March 2017 at 19:31, Lukas Wunner <lukas@wunner.de> wrote:
> >> >> > On Wed, Mar 22, 2017 at 03:30:29PM +0000, Ard Biesheuvel wrote:
> >> >> >> On UEFI systems, the PCI subsystem is enumerated by the firmware,
> >> >> >> and if a graphical framebuffer is exposed by a PCI device, its base
> >> >> >> address and size are exposed to the OS via the Graphics Output
> >> >> >> Protocol (GOP).
> >> >> >>
> >> >> >> On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
> >> >> >> scratch at boot. This may result in the GOP framebuffer address to
> >> >> >> become stale, if the BAR covering the framebuffer is modified. This
> >> >> >> will cause the framebuffer to become unresponsive, and may in some
> >> >> >> cases result in unpredictable behavior if the range is reassigned to
> >> >> >> another device.
> >> >> >
> >> >> > Hm, commit message seems to indicate the issue is restricted to arm64,
> >> >> > yet there's no IS_ENABLED(ARM64) to constrain the added code to that arch?
> >> >>
> >> >> True. I am eager to get some x86 coverage for this, since I would
> >> >> expect this not to do any harm. But I'm fine with making it ARM/arm64
> >> >> specific in the final version.
> >> >
> >> > I see.  IIUC, this is only a problem because pci_bus_assign_resources()
> >> > is called from arch/arm64/kernel/pci.c:pci_acpi_scan_root() (as well as
> >> > the host drivers) and x86 isn't affected because it doesn't do that.
> >> >
> >>
> >> Correct. But on x86 (or rather, on a PC), you can be sure that UEFI
> >> (or the legacy PCI bios) performed the resource assignment already.
> >> One could argue that this is equally the case when running arm64 in
> >> ACPI mode, but in general, you cannot assume the presence of firmware
> >> on ARM/arm64 that has already taken care of this, and so the state of
> >> the BARs has to be presumed invalid.
> >
> > The story is a bit more convoluted than that owing to x86 (and other
> > arches) legacy.
> >
> > x86 tries to claim all PCI resources (in two passes - first enabled
> > devices, second disabled devices) and that predates ACPI/UEFI.
> >
> > Mind, x86 reassign resources that can't be claimed too, the only
> > difference with ARM64 is that, for the better or the worse, we
> > have decided not to claim the FW PCI set-up on ARM64 even if it
> > is sane, we do not even try, it was a deliberate choice.
> >
> > This patch should be harmless on x86 since if the FB PCI BAR is set
> > up sanely, claiming it again should be a nop (to be checked).
> >
> 
> I have checked this with OVMF under QEMU. Claiming the resource early
> like we do this in this patch does not result in any diagnostic output
> or other symptoms that would suggest that anything unexpected occurs.

There is something that I do not understand on how the resource
claiming works on x86. IIUC on x86, resource claiming is done in:

arch/x86/pci/legacy.c

pci_subsys_init()
 -> pcibios_init()
  -> pcibios_resource_survey()

pci_subsys_init() is run in a subsys_initcall.

Now, how do we ensure that resource claiming is carried out _after_
the PCI root busses have been actually scanned ?

The ACPI scan handler interface (so the interface to actually scan
a PCI root bridge in ACPI) is initialized in acpi_init() (which
is a subsys_initcall), how do we guarantee that is run before
pci_subsys_init() ?

x86 implements pcibios_resource_survey_bus(), but that's called only
for hotplugged bridges (?):

drivers/acpi/pci_root.c -> acpi_pci_root_add()

>From the log below, I see two options:

- x86 pcibios_resource_survey() is called before any root bus is added
  (so it does precious little)
- x86 pcibios_resource_survey() is called after root busses are added and
  the PCI device fixup has been applied (and the additional claim in it
  succeeds silently)

I am certainly missing something here, I will grab an x86 box to add
a couple of logs and see if my assumptions are correct, I would like
to get to the bottom of this, I think that's important.

Lorenzo
 
> For the record: I applied the following hunk on top of the current
> version of this patch
> 
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 88f653864a01..98b7c437a448 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -380,7 +380,10 @@ static void claim_efifb_bar(struct pci_dev *dev, int idx)
>                 return;
>         }
> 
> -       if (pci_claim_resource(dev, idx)) {
> +       if (dev->resource[idx].parent != NULL) {
> +               dev_info(&dev->dev, "BAR %d: resource already claimed\n", idx);
> +               while (1) { asm ("hlt"); }
> +       } else if (pci_claim_resource(dev, idx)) {
>                 pci_dev_disabled = true;
>                 dev_err(&dev->dev,
>                         "BAR %d: failed to claim resource for efifb!\n", idx);
> 
> and got the following output in the kernel log related to BDF 0/2/0 and efifb
> 
> pci 0000:00:02.0: [1234:1111] type 00 class 0x030000
> pci 0000:00:02.0: reg 0x10: [mem 0x80000000-0x80ffffff pref]
> pci 0000:00:02.0: reg 0x18: [mem 0x81020000-0x81020fff]
> pci 0000:00:02.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
> pci 0000:00:02.0: BAR 0: assigned to efifb
> pci 0000:00:02.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]:
> no compatible bridge window
> pci 0000:00:02.0: BAR 6: assigned [mem 0x08040000-0x0804ffff pref]
> pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
> efifb: probing for efifb
> efifb: framebuffer at 0x80000000, using 1876k, total 1875k
> efifb: mode is 800x600x32, linelength=3200, pages=1
> efifb: scrolling: redraw
> efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> 
> whereas a kernel without this patch gives me
> 
> pci 0000:00:02.0: [1234:1111] type 00 class 0x030000
> pci 0000:00:02.0: reg 0x10: [mem 0x80000000-0x80ffffff pref]
> pci 0000:00:02.0: reg 0x18: [mem 0x81020000-0x81020fff]
> pci 0000:00:02.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
> pci 0000:00:02.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]:
> no compatible bridge window
> pci 0000:00:02.0: BAR 6: assigned [mem 0x08040000-0x0804ffff pref]
> pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
> efifb: probing for efifb
> efifb: framebuffer at 0x80000000, using 1876k, total 1875k
> efifb: mode is 800x600x32, linelength=3200, pages=1
> efifb: scrolling: redraw
> efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> 
> /proc/iomem looks exactly the same.
> 
> So in summary, x86 does not seem to care.
> 
> Furthermore, I tested with this change, as suggested by Lukas
> 
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 88f653864a01..c72d84590343 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -417,4 +417,5 @@ static void efifb_fixup_resources(struct pci_dev *dev)
>                 }
>         }
>  }
> -DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);
> +DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY,
> +                              16, efifb_fixup_resources);
> 
> 
> which does appear to work fine, and thinking about it, I feel there is
> only so much we can do to sanity check the efifb against the PCI setup
> performed by the firmware, so I am inclined to fold this in.
