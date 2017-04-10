From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Mon, 10 Apr 2017 18:13:30 +0100
Message-ID: <CAKv+Gu-AN-OwnAJG5dt0Qg4GU8HxZBowTSA0H3LhNA3nHfrsQg@mail.gmail.com>
References: <466dcd2b-a781-2fe7-6ef0-5a3767c793e0@codeaurora.org>
 <CAKv+Gu9LbwpnJNi1OL25MWvYPxEOfKRHcs2jA2121BPaQWPzow@mail.gmail.com>
 <27f50de3-721e-e8ec-00c8-b7a9d3cff0d6@codeaurora.org> <CAKv+Gu-qRg8-YRCairppKrEfeLcW+OwVF8qZHp7vxXJA_AwPOw@mail.gmail.com>
 <20170330100524.GA22801@red-moon> <CAKv+Gu-ff98HrPK3f+E8soGJUXaaMxPLs2AuJ+rvXd0HWX-jXw@mail.gmail.com>
 <CAKv+Gu8YjySTDMgsrtGqEPMOtVhHc8gvTHZ4C5Ga8OTYdC9R3A@mail.gmail.com>
 <ae87ae28-f50d-095f-576e-f3fd7f96dea2@codeaurora.org> <CAKv+Gu8x0rQUnTUorknW-mW9LFgrxFYsXyy4LU_w9JbA-m_sjA@mail.gmail.com>
 <CAKv+Gu9Su0F9CSRe=sxomuDDH7c2szO6Z8dpqOQ=t_1Vn3JD3g@mail.gmail.com> <20170410165328.GA5248@red-moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170410165328.GA5248@red-moon>
Sender: linux-pci-owner@vger.kernel.org
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Sinan Kaya <okaya@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>, Lukas Wunner <lukas@wunner.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 10 April 2017 at 17:53, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> On Mon, Apr 10, 2017 at 04:28:11PM +0100, Ard Biesheuvel wrote:
>> On 2 April 2017 at 16:16, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > On 30 March 2017 at 14:50, Sinan Kaya <okaya@codeaurora.org> wrote:
>> >> On 3/30/2017 9:38 AM, Ard Biesheuvel wrote:
>> >>> On 30 March 2017 at 11:09, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> >>>> On 30 March 2017 at 11:05, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
>> >>>>> On Thu, Mar 30, 2017 at 09:46:39AM +0100, Ard Biesheuvel wrote:
>> >>>>>
>> >>>>> [...]
>> >>>>>
>> >>>>>>> I'm asking why we don't fix the actual problem in PCIe ARM64 adaptation instead
>> >>>>>>> of working around it by quirks.
>> >>>>>>>
>> >>>>>>> I don't see any reason why ACPI ARM64 should carry the burden of legacy systems.
>> >>>>>>>
>> >>>>>>> Legacy only applies to DT based systems.
>> >>>>>>>
>> >>>>>>
>> >>>>>> I fully agree with this point: ACPI implies firmware, and so we should
>> >>>>>> be able to rely on firmware to have initialized the PCIe subsystem by
>> >>>>>> the time the kernel gets to access it.
>> >>>>>
>> >>>>> https://lkml.org/lkml/2016/3/3/458
>> >>>>>
>> >>>>
>> >>>> I don't think the fact that at least one system existed over a year
>> >>>> ago whose UEFI assigned resources incorrectly should prevent us from
>> >>>> being normative in this case.
>> >>>
>> >>> In any case, given that EFIFB is enabled by default on some distros,
>> >>> and the fact that DT boot is affected as well, I should get this patch
>> >>> in to prevent serious potential issues that could arise when someone
>> >>> with a graphical UEFI stack updates to such a new kernel.
>> >>>
>> >>> So I think we are in agreement that this is needed on both ARM and
>> >>> arm64, since their PCI configuration is usually not preserved. The
>> >>> open question is whether there is any harm in enabling it for x86 as
>> >>> well.
>> >>>
>> >>
>> >> Agreed, the other issue is about compatibility with UEFI and future
>> >> proofing Linux for other potential issues like hotplug reservation.
>> >>
>> >
>> > OK, given the lack of feedback regarding the suitability of this patch
>> > for x86, I am going to rework it as a ARM/arm64 only patch, and queue
>> > it as a fix for v4.11. This way, we can backport it to stable (which
>> > is arguably appropriate, given that upgrading to a EFIFB enabled
>> > kernel may cause severe breakage for existing systems that implement
>> > the GOP protocol), and easily change the patch to apply to x86 going
>> > forwards, by removing the #ifdefs
>> >
>>
>> As it turns out, this patch does not solve the problem completely.
>>
>> For EFI framebuffers that are backed by a PCI bar of a device residing
>> on bus 0, things work happily. However, claiming resources for devices
>> behind bridges doesn't work.
>
> May I ask you to elaborate on this please ? It is because we do not
> claim the bridge windows upstream the device and they are reassigned ?
>

The pci_claim_resource() call fails like this

pci 0000:01:01.0: can't claim BAR 0 [mem 0x10000000-0x10ffffff pref]:
no compatible bridge window
pci 0000:01:01.0: BAR 0: failed to claim resource for efifb!

which is caused by the fact that the parent resources are all zeroes.
It appears the BAR configuration is never read from the bridges, so
the only way we will ever have meaningful values in there is if we
allocate them ourselves.

>> Given that we have not made the situation worse, fixing it is less
>> urgent than it was before. I.e., there is no longer a risk of
>> inadvertently poking the wrong BAR when writing to the framebuffer.
>> There is a regression in functionality, though, since EFI fb devices
>> that happened to work (because the firmware BAR == the kernel BAR)
>> have stopped working if they are behind a bridge, which is of course
>> always the case for PCIe.
>>
>> So before starting the next round of hacking to work around this, I
>> would like rekindle the discussion regarding the way we blindly
>> reassign all resources on ACPI/arm64 systems, and whether there is a
>> way imaginable to avoid doing that.
>
> There is a way if the whole ARM ecosystem work together to sort this
> out and we think that's the right way to do; I am personally not
> entirely convinced about that.
>

So what are the pros and cons here? EFI fb is not a hugely important
use case, but it is one that relies on BARs staying where they are.
Are there others like that?

>> I suppose the state of the BARs as we inherit it from the firmware
>> cannot be blindly trusted (and IIUC, this is Lorenzo's primary issue
>> with it). So should there be some side channel (UEFI config table
>> perhaps?) to describe this?
>
> PCI firmware specifications rev 3.1, 4.6.5, "_DSM for Ignoring PCI
> Boot Configurations".
>
> Do we want to enforce it on ARM ? I do not know to be honest (and it
> still would not solve the DT firmware case).
>

No, it doesn't. But that doesn't mean we shouldn't solve it on ACPI if
the pros outweigh the cons.

> Whatever we do, it is not going to be clean cut IMO. I think that
> what x86 does is sensible (well, minus the link ordering dependency we
> discovered), I can do it for ARM64 but get ready for regressions and
> I still think we have no real FW binding support that would make this
> behaviour robust.
>
> I can provide you with examples where, by simply claiming resources
> on an ARM system you trigger resources allocation regressions by
> preventing the kernel from allocating bigger bridge windows than
> the ones set-up by FW.
>

So how is this specific to ARM then? If we are running the same
resource allocation routines, why should we end up with a firmware
allocation that the kernel cannot use?

>> How do other architectures deal with this?
>
> On an arch specific basis that make things work.
>
>> Is this what the PCI bios accesses are for?
>
> Which ones :) ?
>

Well, some of them :-)

I guess the question was if the overridden __weak methods are supposed
to hook into tables or other BIOS structures that contain information
about the PCI resource allocations by the firmware.

>> In any case, I have updated the UEFI firmware we have for ARM Juno to
>> use EDK2's generic PCI host bridge driver instead of one that was
>> specially written for ARM Juno, and may deviate in the way it
>> allocates PCI resources.
>
> As long as the kernel is free to reallocate them and that FW quiesces
> devices at FW->OS handover I see no issues with that.
>

The reason is to eliminate another unknown from the discussion whether
UEFI can be expected to leave the entire PCI hierarchy in a sane
state.

> If we want to try to claim the whole resource tree on boot (in ACPI)
> I can send a patch for that but there will be regressions.
>

I would like to see it, yes.
