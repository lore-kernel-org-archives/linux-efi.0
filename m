From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Tue, 11 Apr 2017 17:06:53 +0100
Message-ID: <CAKv+Gu92WM+LaPfNBMyZQ_wnBT0fNvx3CFmMhTDwZ961_KQXYQ@mail.gmail.com>
References: <CAKv+Gu-qRg8-YRCairppKrEfeLcW+OwVF8qZHp7vxXJA_AwPOw@mail.gmail.com>
 <20170330100524.GA22801@red-moon> <CAKv+Gu-ff98HrPK3f+E8soGJUXaaMxPLs2AuJ+rvXd0HWX-jXw@mail.gmail.com>
 <CAKv+Gu8YjySTDMgsrtGqEPMOtVhHc8gvTHZ4C5Ga8OTYdC9R3A@mail.gmail.com>
 <ae87ae28-f50d-095f-576e-f3fd7f96dea2@codeaurora.org> <CAKv+Gu8x0rQUnTUorknW-mW9LFgrxFYsXyy4LU_w9JbA-m_sjA@mail.gmail.com>
 <CAKv+Gu9Su0F9CSRe=sxomuDDH7c2szO6Z8dpqOQ=t_1Vn3JD3g@mail.gmail.com>
 <20170410165328.GA5248@red-moon> <CAKv+Gu-AN-OwnAJG5dt0Qg4GU8HxZBowTSA0H3LhNA3nHfrsQg@mail.gmail.com>
 <CAKv+Gu9dS4OhLbBw59yKYQmoJ8SpFexzk9yH=XfXnzn8NJ4mcg@mail.gmail.com> <20170411131639.GA6652@red-moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170411131639.GA6652@red-moon>
Sender: linux-pci-owner@vger.kernel.org
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Sinan Kaya <okaya@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>, Lukas Wunner <lukas@wunner.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 11 April 2017 at 14:16, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> On Mon, Apr 10, 2017 at 06:29:27PM +0100, Ard Biesheuvel wrote:
>
> [...]
>
>> >>> So before starting the next round of hacking to work around this, I
>> >>> would like rekindle the discussion regarding the way we blindly
>> >>> reassign all resources on ACPI/arm64 systems, and whether there is a
>> >>> way imaginable to avoid doing that.
>> >>
>> >> There is a way if the whole ARM ecosystem work together to sort this
>> >> out and we think that's the right way to do; I am personally not
>> >> entirely convinced about that.
>> >>
>> >
>> > So what are the pros and cons here? EFI fb is not a hugely important
>> > use case, but it is one that relies on BARs staying where they are.
>> > Are there others like that?
>
> Not that I am aware of, which means that pros are thin on the ground.
>

OK. Sinan?

>> >>> I suppose the state of the BARs as we inherit it from the firmware
>> >>> cannot be blindly trusted (and IIUC, this is Lorenzo's primary issue
>> >>> with it). So should there be some side channel (UEFI config table
>> >>> perhaps?) to describe this?
>> >>
>> >> PCI firmware specifications rev 3.1, 4.6.5, "_DSM for Ignoring PCI
>> >> Boot Configurations".
>> >>
>> >> Do we want to enforce it on ARM ? I do not know to be honest (and it
>> >> still would not solve the DT firmware case).
>> >>
>> >
>> > No, it doesn't. But that doesn't mean we shouldn't solve it on ACPI if
>> > the pros outweigh the cons.
>
> No one is screaming for that to happen, I can implement resource
> claiming but at the moment I do not see the benefit.
>
> [...]
>
>> > The reason is to eliminate another unknown from the discussion whether
>> > UEFI can be expected to leave the entire PCI hierarchy in a sane
>> > state.
>> >
>> >> If we want to try to claim the whole resource tree on boot (in ACPI)
>> >> I can send a patch for that but there will be regressions.
>> >>
>> >
>> > I would like to see it, yes.
>>
>> FWIW, the following minimal [naive] patch
>>
>> diff --git a/arch/arm64/kernel/pci.c b/arch/arm64/kernel/pci.c
>> index 4f0e3ebfea4b..37c4d2f116a4 100644
>> --- a/arch/arm64/kernel/pci.c
>> +++ b/arch/arm64/kernel/pci.c
>> @@ -27,7 +27,7 @@
>>   */
>>  void pcibios_fixup_bus(struct pci_bus *bus)
>>  {
>> -       /* nothing to do, expected to be removed in the future */
>> +       pci_read_bridge_bases(bus);
>>  }
>>
>>  /*
>> @@ -208,8 +208,8 @@ struct pci_bus *pci_acpi_scan_root(struct
>> acpi_pci_root *root)
>>         if (!bus)
>>                 return NULL;
>>
>> -       pci_bus_size_bridges(bus);
>> -       pci_bus_assign_resources(bus);
>> +       pci_assign_unassigned_root_bus_resources(bus);
>> +       pci_bus_claim_resources(bus);
>
> I do not understand this code. If you reassign the whole thing
> before claiming it I am not sure what's the point of claiming
> the resources later, that's basically a nop. pci_bus_claim_resources()
> should suffice (if FW set-up is sane - which also reads bridge bases,
> BTW).
>

OK, I'm struggling a bit with this code. As you know, it is not light
bedtime reading :-)

In any case, I am starting to see your point. While I am able to claim
most of the configuration by calling pci_bus_claim_resources() only
[modulo some I/O BARs for which I will send out a bugfix shortly], the
option ROM BARs are left disabled by UEFI, and so I end up with

pci 0000:00:01.0: PCI bridge to [bus 01]
pci 0000:00:02.0: PCI bridge to [bus 02]
pci 0000:00:03.0: PCI bridge to [bus 03]
pci 0000:02:01.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]:
no compatible bridge window
pci 0000:03:01.0: can't claim BAR 6 [mem 0xfffc0000-0xffffffff pref]:
no compatible bridge window

and everything else works fine.

Both PPC and x86 have similar code to infer from the BARs themselves
whether they were programmed, but in our case, it comes down to
checking whether a parent resource exists that covers the range.

It may still make sense to add support for the _DSM method, and leave
it to the firmware to tell the kernel whether the PCI configuration is
supposed to be correct, so I will send out an RFC for that as well.
