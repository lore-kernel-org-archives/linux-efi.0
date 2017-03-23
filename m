From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Thu, 23 Mar 2017 09:04:03 +0000
Message-ID: <CAKv+Gu93eJ-js3g7M6Jdm6XGMaWMswFmzBG2qNT4rn+3=1+EyA@mail.gmail.com>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de> <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
 <20170323084819.GA23281@h08.hostsharing.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170323084819.GA23281@h08.hostsharing.net>
Sender: linux-pci-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 23 March 2017 at 08:48, Lukas Wunner <lukas@wunner.de> wrote:
> On Wed, Mar 22, 2017 at 07:32:43PM +0000, Ard Biesheuvel wrote:
>> On 22 March 2017 at 19:31, Lukas Wunner <lukas@wunner.de> wrote:
>> > On Wed, Mar 22, 2017 at 03:30:29PM +0000, Ard Biesheuvel wrote:
>> >> On UEFI systems, the PCI subsystem is enumerated by the firmware,
>> >> and if a graphical framebuffer is exposed by a PCI device, its base
>> >> address and size are exposed to the OS via the Graphics Output
>> >> Protocol (GOP).
>> >>
>> >> On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
>> >> scratch at boot. This may result in the GOP framebuffer address to
>> >> become stale, if the BAR covering the framebuffer is modified. This
>> >> will cause the framebuffer to become unresponsive, and may in some
>> >> cases result in unpredictable behavior if the range is reassigned to
>> >> another device.
>> >
>> > Hm, commit message seems to indicate the issue is restricted to arm64,
>> > yet there's no IS_ENABLED(ARM64) to constrain the added code to that arch?
>>
>> True. I am eager to get some x86 coverage for this, since I would
>> expect this not to do any harm. But I'm fine with making it ARM/arm64
>> specific in the final version.
>
> I see.  IIUC, this is only a problem because pci_bus_assign_resources()
> is called from arch/arm64/kernel/pci.c:pci_acpi_scan_root() (as well as
> the host drivers) and x86 isn't affected because it doesn't do that.
>

Correct. But on x86 (or rather, on a PC), you can be sure that UEFI
(or the legacy PCI bios) performed the resource assignment already.
One could argue that this is equally the case when running arm64 in
ACPI mode, but in general, you cannot assume the presence of firmware
on ARM/arm64 that has already taken care of this, and so the state of
the BARs has to be presumed invalid.

> I have no opinion on executing the quirk on x86 as well, I was just
> confused by the discrepancy between commit message and patch, but that
> can easily be remedied with a copy+paste of what you replied to Sinan:
>
>        "On x86, it works, given that BARs are usually not reassigned,
>         and so the patch should be a no-op in that case, although it
>         should still be an improvement to check whether the device that
>         owns the BAR actually has memory decoding enabled before we
>         attach the framebuffer driver to it."
>
>

OK, I will include that.

>> >> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);
>> >
>> > Maybe this can be constrained to PCI_BASE_CLASS_DISPLAY?
>>
>> How does one do that with DECLARE_PCI_FIXUP_HEADER?
>
> With DECLARE_PCI_FIXUP_CLASS_HEADER().
>

Ah ok, thanks for pointing that out.

I do wonder whether it makes sense to keep the code as is, so that we
spot unexpected configurations, i.e., where the GOP points into a BAR
that is unrelated to graphics. In this case, I think we should disable
efifb rather than proceed without claiming any PCI resources (as we
did without this patch)
