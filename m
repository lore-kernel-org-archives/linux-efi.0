From: Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Tue, 11 Apr 2017 14:16:39 +0100
Message-ID: <20170411131639.GA6652@red-moon>
References: <CAKv+Gu-qRg8-YRCairppKrEfeLcW+OwVF8qZHp7vxXJA_AwPOw@mail.gmail.com>
 <20170330100524.GA22801@red-moon>
 <CAKv+Gu-ff98HrPK3f+E8soGJUXaaMxPLs2AuJ+rvXd0HWX-jXw@mail.gmail.com>
 <CAKv+Gu8YjySTDMgsrtGqEPMOtVhHc8gvTHZ4C5Ga8OTYdC9R3A@mail.gmail.com>
 <ae87ae28-f50d-095f-576e-f3fd7f96dea2@codeaurora.org>
 <CAKv+Gu8x0rQUnTUorknW-mW9LFgrxFYsXyy4LU_w9JbA-m_sjA@mail.gmail.com>
 <CAKv+Gu9Su0F9CSRe=sxomuDDH7c2szO6Z8dpqOQ=t_1Vn3JD3g@mail.gmail.com>
 <20170410165328.GA5248@red-moon>
 <CAKv+Gu-AN-OwnAJG5dt0Qg4GU8HxZBowTSA0H3LhNA3nHfrsQg@mail.gmail.com>
 <CAKv+Gu9dS4OhLbBw59yKYQmoJ8SpFexzk9yH=XfXnzn8NJ4mcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9dS4OhLbBw59yKYQmoJ8SpFexzk9yH=XfXnzn8NJ4mcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Sinan Kaya <okaya-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Heyi Guo <heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 10, 2017 at 06:29:27PM +0100, Ard Biesheuvel wrote:

[...]

> >>> So before starting the next round of hacking to work around this, I
> >>> would like rekindle the discussion regarding the way we blindly
> >>> reassign all resources on ACPI/arm64 systems, and whether there is a
> >>> way imaginable to avoid doing that.
> >>
> >> There is a way if the whole ARM ecosystem work together to sort this
> >> out and we think that's the right way to do; I am personally not
> >> entirely convinced about that.
> >>
> >
> > So what are the pros and cons here? EFI fb is not a hugely important
> > use case, but it is one that relies on BARs staying where they are.
> > Are there others like that?

Not that I am aware of, which means that pros are thin on the ground.

> >>> I suppose the state of the BARs as we inherit it from the firmware
> >>> cannot be blindly trusted (and IIUC, this is Lorenzo's primary issue
> >>> with it). So should there be some side channel (UEFI config table
> >>> perhaps?) to describe this?
> >>
> >> PCI firmware specifications rev 3.1, 4.6.5, "_DSM for Ignoring PCI
> >> Boot Configurations".
> >>
> >> Do we want to enforce it on ARM ? I do not know to be honest (and it
> >> still would not solve the DT firmware case).
> >>
> >
> > No, it doesn't. But that doesn't mean we shouldn't solve it on ACPI if
> > the pros outweigh the cons.

No one is screaming for that to happen, I can implement resource
claiming but at the moment I do not see the benefit.

[...]

> > The reason is to eliminate another unknown from the discussion whether
> > UEFI can be expected to leave the entire PCI hierarchy in a sane
> > state.
> >
> >> If we want to try to claim the whole resource tree on boot (in ACPI)
> >> I can send a patch for that but there will be regressions.
> >>
> >
> > I would like to see it, yes.
> 
> FWIW, the following minimal [naive] patch
> 
> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
> index 4f0e3ebfea4b..37c4d2f116a4 100644
> --- a/arch/arm64/kernel/pci.c
> +++ b/arch/arm64/kernel/pci.c
> @@ -27,7 +27,7 @@
>   */
>  void pcibios_fixup_bus(struct pci_bus *bus)
>  {
> -       /* nothing to do, expected to be removed in the future */
> +       pci_read_bridge_bases(bus);
>  }
> 
>  /*
> @@ -208,8 +208,8 @@ struct pci_bus *pci_acpi_scan_root(struct
> acpi_pci_root *root)
>         if (!bus)
>                 return NULL;
> 
> -       pci_bus_size_bridges(bus);
> -       pci_bus_assign_resources(bus);
> +       pci_assign_unassigned_root_bus_resources(bus);
> +       pci_bus_claim_resources(bus);

I do not understand this code. If you reassign the whole thing
before claiming it I am not sure what's the point of claiming
the resources later, that's basically a nop. pci_bus_claim_resources()
should suffice (if FW set-up is sane - which also reads bridge bases,
BTW).

Lorenzo

>         list_for_each_entry(child, &bus->children, node)
>                 pcie_bus_configure_settings(child);
> 
> running under QEMU+UEFI with the following PCI topology
> 
> -[0000:00]-+-00.0  Red Hat, Inc. Device 0008
>            +-01.0-[01]----01.0  Device 1234:1111
>            +-02.0-[02]--+-02.0  Red Hat, Inc Virtio RNG
>            |            \-03.0  Red Hat, Inc Virtio block device
>            \-03.0-[03]----04.0  Red Hat, Inc Virtio network device
> 
> results in the log below, preserving the configuration created by UEFI
> 
> pci_bus 0000:00: root bus resource [mem 0x10000000-0x3efeffff window]
> pci_bus 0000:00: root bus resource [io  0x0000-0xffff window]
> pci_bus 0000:00: root bus resource [mem 0x8000000000-0xffffffffff window]
> pci_bus 0000:00: root bus resource [bus 00-0f]
> pci 0000:00:00.0: [1b36:0008] type 00 class 0x060000
> pci 0000:00:01.0: [1b36:0001] type 01 class 0x060400
> pci 0000:00:01.0: reg 0x10: [mem 0x8000202000-0x80002020ff 64bit]
> pci 0000:00:02.0: [1b36:0001] type 01 class 0x060400
> pci 0000:00:02.0: reg 0x10: [mem 0x8000201000-0x80002010ff 64bit]
> pci 0000:00:03.0: [1b36:0001] type 01 class 0x060400
> pci 0000:00:03.0: reg 0x10: [mem 0x8000200000-0x80002000ff 64bit]
> pci 0000:01:01.0: [1234:1111] type 00 class 0x030000
> pci 0000:01:01.0: reg 0x10: [mem 0x10000000-0x10ffffff pref]
> pci 0000:01:01.0: reg 0x18: [mem 0x11200000-0x11200fff]
> pci 0000:01:01.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
> pci 0000:01:01.0: can't claim BAR 0 [mem 0x10000000-0x10ffffff pref]:
> no compatible bridge window
> pci 0000:01:01.0: BAR 0: failed to claim resource for efifb!
> pci 0000:00:01.0: PCI bridge to [bus 01]
> pci 0000:00:01.0:   bridge window [mem 0x11200000-0x112fffff]
> pci 0000:00:01.0:   bridge window [mem 0x10000000-0x10ffffff 64bit pref]
> pci 0000:02:02.0: [1af4:1005] type 00 class 0x00ff00
> pci 0000:02:02.0: reg 0x10: [io  0x1040-0x105f]
> pci 0000:02:02.0: reg 0x20: [mem 0x8000004000-0x8000007fff 64bit pref]
> pci 0000:02:03.0: [1af4:1001] type 00 class 0x010000
> pci 0000:02:03.0: reg 0x10: [io  0x1000-0x103f]
> pci 0000:02:03.0: reg 0x14: [mem 0x11100000-0x11100fff]
> pci 0000:02:03.0: reg 0x20: [mem 0x8000000000-0x8000003fff 64bit pref]
> pci 0000:00:02.0: PCI bridge to [bus 02]
> pci 0000:00:02.0:   bridge window [io  0x1000-0x1fff]
> pci 0000:00:02.0:   bridge window [mem 0x11100000-0x111fffff]
> pci 0000:00:02.0:   bridge window [mem 0x8000000000-0x80000fffff 64bit pref]
> pci 0000:03:04.0: [1af4:1000] type 00 class 0x020000
> pci 0000:03:04.0: reg 0x10: [io  0x0000-0x001f]
> pci 0000:03:04.0: reg 0x14: [mem 0x11000000-0x11000fff]
> pci 0000:03:04.0: reg 0x20: [mem 0x8000100000-0x8000103fff 64bit pref]
> pci 0000:03:04.0: reg 0x30: [mem 0xfffc0000-0xffffffff pref]
> pci 0000:00:03.0: PCI bridge to [bus 03]
> pci 0000:00:03.0:   bridge window [io  0x0000-0x0fff]
> pci 0000:00:03.0:   bridge window [mem 0x11000000-0x110fffff]
> pci 0000:00:03.0:   bridge window [mem 0x8000100000-0x80001fffff 64bit pref]
> pci 0000:00:01.0: BAR 14: assigned [mem 0x10000000-0x117fffff]
> pci 0000:00:01.0: BAR 15: assigned [mem 0x8000000000-0x8000ffffff 64bit pref]
> pci 0000:00:02.0: BAR 14: assigned [mem 0x11800000-0x118fffff]
> pci 0000:00:02.0: BAR 15: assigned [mem 0x8001000000-0x80010fffff 64bit pref]
> pci 0000:00:03.0: BAR 14: assigned [mem 0x11900000-0x119fffff]
> pci 0000:00:03.0: BAR 15: assigned [mem 0x8001100000-0x80011fffff 64bit pref]
> pci 0000:00:02.0: BAR 13: assigned [io  0x1000-0x1fff]
> pci 0000:00:03.0: BAR 13: assigned [io  0x2000-0x2fff]
> pci 0000:00:01.0: BAR 0: assigned [mem 0x8001200000-0x80012000ff 64bit]
> pci 0000:00:02.0: BAR 0: assigned [mem 0x8001200100-0x80012001ff 64bit]
> pci 0000:00:03.0: BAR 0: assigned [mem 0x8001200200-0x80012002ff 64bit]
> pci 0000:01:01.0: BAR 0: assigned [mem 0x10000000-0x10ffffff pref]
> pci 0000:01:01.0: BAR 6: assigned [mem 0x11000000-0x1100ffff pref]
> pci 0000:01:01.0: BAR 2: assigned [mem 0x11010000-0x11010fff]
> pci 0000:00:01.0: PCI bridge to [bus 01]
> pci 0000:00:01.0:   bridge window [mem 0x10000000-0x117fffff]
> pci 0000:00:01.0:   bridge window [mem 0x8000000000-0x8000ffffff 64bit pref]
> pci 0000:02:02.0: BAR 4: assigned [mem 0x8001000000-0x8001003fff 64bit pref]
> pci 0000:02:03.0: BAR 4: assigned [mem 0x8001004000-0x8001007fff 64bit pref]
> pci 0000:02:03.0: BAR 1: assigned [mem 0x11800000-0x11800fff]
> pci 0000:02:03.0: BAR 0: assigned [io  0x1000-0x103f]
> pci 0000:02:02.0: BAR 0: assigned [io  0x1040-0x105f]
> pci 0000:00:02.0: PCI bridge to [bus 02]
> pci 0000:00:02.0:   bridge window [io  0x1000-0x1fff]
> pci 0000:00:02.0:   bridge window [mem 0x11800000-0x118fffff]
> pci 0000:00:02.0:   bridge window [mem 0x8001000000-0x80010fffff 64bit pref]
> pci 0000:03:04.0: BAR 6: assigned [mem 0x11900000-0x1193ffff pref]
> pci 0000:03:04.0: BAR 4: assigned [mem 0x8001100000-0x8001103fff 64bit pref]
> pci 0000:03:04.0: BAR 1: assigned [mem 0x11940000-0x11940fff]
> pci 0000:03:04.0: BAR 0: assigned [io  0x2000-0x201f]
> pci 0000:00:03.0: PCI bridge to [bus 03]
> pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
> pci 0000:00:03.0:   bridge window [mem 0x11900000-0x119fffff]
> pci 0000:00:03.0:   bridge window [mem 0x8001100000-0x80011fffff 64bit pref]
> pci_bus 0000:00: resource 4 [mem 0x10000000-0x3efeffff window]
> pci_bus 0000:00: resource 5 [io  0x0000-0xffff window]
> pci_bus 0000:00: resource 6 [mem 0x8000000000-0xffffffffff window]
> pci_bus 0000:01: resource 1 [mem 0x10000000-0x117fffff]
> pci_bus 0000:01: resource 2 [mem 0x8000000000-0x8000ffffff 64bit pref]
> pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
> pci_bus 0000:02: resource 1 [mem 0x11800000-0x118fffff]
> pci_bus 0000:02: resource 2 [mem 0x8001000000-0x80010fffff 64bit pref]
> pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
> pci_bus 0000:03: resource 1 [mem 0x11900000-0x119fffff]
> pci_bus 0000:03: resource 2 [mem 0x8001100000-0x80011fffff 64bit pref]
> pci 0000:00:01.0: PCI bridge to [bus 01]
> pci 0000:00:01.0:   bridge window [mem 0x10000000-0x117fffff]
> pci 0000:00:01.0:   bridge window [mem 0x8000000000-0x8000ffffff 64bit pref]
> pci 0000:00:02.0: PCI bridge to [bus 02]
> pci 0000:00:02.0:   bridge window [io  0x1000-0x1fff]
> pci 0000:00:02.0:   bridge window [mem 0x11800000-0x118fffff]
> pci 0000:00:02.0:   bridge window [mem 0x8001000000-0x80010fffff 64bit pref]
> pci 0000:00:03.0: PCI bridge to [bus 03]
> pci 0000:00:03.0:   bridge window [io  0x2000-0x2fff]
> pci 0000:00:03.0:   bridge window [mem 0x11900000-0x119fffff]
> pci 0000:00:03.0:   bridge window [mem 0x8001100000-0x80011fffff 64bit pref]
