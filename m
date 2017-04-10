From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Mon, 10 Apr 2017 17:53:28 +0100
Message-ID: <20170410165328.GA5248@red-moon>
References: <466dcd2b-a781-2fe7-6ef0-5a3767c793e0@codeaurora.org>
 <CAKv+Gu9LbwpnJNi1OL25MWvYPxEOfKRHcs2jA2121BPaQWPzow@mail.gmail.com>
 <27f50de3-721e-e8ec-00c8-b7a9d3cff0d6@codeaurora.org>
 <CAKv+Gu-qRg8-YRCairppKrEfeLcW+OwVF8qZHp7vxXJA_AwPOw@mail.gmail.com>
 <20170330100524.GA22801@red-moon>
 <CAKv+Gu-ff98HrPK3f+E8soGJUXaaMxPLs2AuJ+rvXd0HWX-jXw@mail.gmail.com>
 <CAKv+Gu8YjySTDMgsrtGqEPMOtVhHc8gvTHZ4C5Ga8OTYdC9R3A@mail.gmail.com>
 <ae87ae28-f50d-095f-576e-f3fd7f96dea2@codeaurora.org>
 <CAKv+Gu8x0rQUnTUorknW-mW9LFgrxFYsXyy4LU_w9JbA-m_sjA@mail.gmail.com>
 <CAKv+Gu9Su0F9CSRe=sxomuDDH7c2szO6Z8dpqOQ=t_1Vn3JD3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9Su0F9CSRe=sxomuDDH7c2szO6Z8dpqOQ=t_1Vn3JD3g@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-pci <linux-pci@vger.kernel.org>, Peter Jones <pjones@redhat.com>, Sinan Kaya <okaya@codeaurora.org>, Heyi Guo <heyi.guo@linaro.org>, Lukas Wunner <lukas@wunner.de>, Hanjun Guo <hanjun.guo@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 10, 2017 at 04:28:11PM +0100, Ard Biesheuvel wrote:
> On 2 April 2017 at 16:16, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > On 30 March 2017 at 14:50, Sinan Kaya <okaya@codeaurora.org> wrote:
> >> On 3/30/2017 9:38 AM, Ard Biesheuvel wrote:
> >>> On 30 March 2017 at 11:09, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >>>> On 30 March 2017 at 11:05, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> >>>>> On Thu, Mar 30, 2017 at 09:46:39AM +0100, Ard Biesheuvel wrote:
> >>>>>
> >>>>> [...]
> >>>>>
> >>>>>>> I'm asking why we don't fix the actual problem in PCIe ARM64 adaptation instead
> >>>>>>> of working around it by quirks.
> >>>>>>>
> >>>>>>> I don't see any reason why ACPI ARM64 should carry the burden of legacy systems.
> >>>>>>>
> >>>>>>> Legacy only applies to DT based systems.
> >>>>>>>
> >>>>>>
> >>>>>> I fully agree with this point: ACPI implies firmware, and so we should
> >>>>>> be able to rely on firmware to have initialized the PCIe subsystem by
> >>>>>> the time the kernel gets to access it.
> >>>>>
> >>>>> https://lkml.org/lkml/2016/3/3/458
> >>>>>
> >>>>
> >>>> I don't think the fact that at least one system existed over a year
> >>>> ago whose UEFI assigned resources incorrectly should prevent us from
> >>>> being normative in this case.
> >>>
> >>> In any case, given that EFIFB is enabled by default on some distros,
> >>> and the fact that DT boot is affected as well, I should get this patch
> >>> in to prevent serious potential issues that could arise when someone
> >>> with a graphical UEFI stack updates to such a new kernel.
> >>>
> >>> So I think we are in agreement that this is needed on both ARM and
> >>> arm64, since their PCI configuration is usually not preserved. The
> >>> open question is whether there is any harm in enabling it for x86 as
> >>> well.
> >>>
> >>
> >> Agreed, the other issue is about compatibility with UEFI and future
> >> proofing Linux for other potential issues like hotplug reservation.
> >>
> >
> > OK, given the lack of feedback regarding the suitability of this patch
> > for x86, I am going to rework it as a ARM/arm64 only patch, and queue
> > it as a fix for v4.11. This way, we can backport it to stable (which
> > is arguably appropriate, given that upgrading to a EFIFB enabled
> > kernel may cause severe breakage for existing systems that implement
> > the GOP protocol), and easily change the patch to apply to x86 going
> > forwards, by removing the #ifdefs
> >
> 
> As it turns out, this patch does not solve the problem completely.
> 
> For EFI framebuffers that are backed by a PCI bar of a device residing
> on bus 0, things work happily. However, claiming resources for devices
> behind bridges doesn't work.

May I ask you to elaborate on this please ? It is because we do not
claim the bridge windows upstream the device and they are reassigned ?

> Given that we have not made the situation worse, fixing it is less
> urgent than it was before. I.e., there is no longer a risk of
> inadvertently poking the wrong BAR when writing to the framebuffer.
> There is a regression in functionality, though, since EFI fb devices
> that happened to work (because the firmware BAR == the kernel BAR)
> have stopped working if they are behind a bridge, which is of course
> always the case for PCIe.
> 
> So before starting the next round of hacking to work around this, I
> would like rekindle the discussion regarding the way we blindly
> reassign all resources on ACPI/arm64 systems, and whether there is a
> way imaginable to avoid doing that.

There is a way if the whole ARM ecosystem work together to sort this
out and we think that's the right way to do; I am personally not
entirely convinced about that.

> I suppose the state of the BARs as we inherit it from the firmware
> cannot be blindly trusted (and IIUC, this is Lorenzo's primary issue
> with it). So should there be some side channel (UEFI config table
> perhaps?) to describe this?

PCI firmware specifications rev 3.1, 4.6.5, "_DSM for Ignoring PCI
Boot Configurations".

Do we want to enforce it on ARM ? I do not know to be honest (and it
still would not solve the DT firmware case).

Whatever we do, it is not going to be clean cut IMO. I think that
what x86 does is sensible (well, minus the link ordering dependency we
discovered), I can do it for ARM64 but get ready for regressions and
I still think we have no real FW binding support that would make this
behaviour robust.

I can provide you with examples where, by simply claiming resources
on an ARM system you trigger resources allocation regressions by
preventing the kernel from allocating bigger bridge windows than
the ones set-up by FW.

> How do other architectures deal with this?

On an arch specific basis that make things work.

> Is this what the PCI bios accesses are for?

Which ones :) ?

> In any case, I have updated the UEFI firmware we have for ARM Juno to
> use EDK2's generic PCI host bridge driver instead of one that was
> specially written for ARM Juno, and may deviate in the way it
> allocates PCI resources.

As long as the kernel is free to reallocate them and that FW quiesces
devices at FW->OS handover I see no issues with that.

If we want to try to claim the whole resource tree on boot (in ACPI)
I can send a patch for that but there will be regressions.

Lorenzo
