From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Thu, 23 Mar 2017 15:15:17 +0000
Message-ID: <CAKv+Gu_iUir5d3evOvS3tUK6vY1H7KBktDf253MA8vyZDwOKPA@mail.gmail.com>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de> <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
 <20170323084819.GA23281@h08.hostsharing.net> <CAKv+Gu93eJ-js3g7M6Jdm6XGMaWMswFmzBG2qNT4rn+3=1+EyA@mail.gmail.com>
 <20170323105727.GA2441@red-moon> <CAKv+Gu-J664KXaZR19nViq4o1n_x=P-trsZ0oNDiONuBpAcd7A@mail.gmail.com>
 <20170323143151.GA21544@red-moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170323143151.GA21544@red-moon>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>
Cc: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Heyi Guo <heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 March 2017 at 14:31, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org> wrote:
> On Thu, Mar 23, 2017 at 12:25:48PM +0000, Ard Biesheuvel wrote:
>> On 23 March 2017 at 10:57, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org> wrote:
>> > On Thu, Mar 23, 2017 at 09:04:03AM +0000, Ard Biesheuvel wrote:
>> >> On 23 March 2017 at 08:48, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
>> >> > On Wed, Mar 22, 2017 at 07:32:43PM +0000, Ard Biesheuvel wrote:
>> >> >> On 22 March 2017 at 19:31, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org> wrote:
>> >> >> > On Wed, Mar 22, 2017 at 03:30:29PM +0000, Ard Biesheuvel wrote:
>> >> >> >> On UEFI systems, the PCI subsystem is enumerated by the firmware,
>> >> >> >> and if a graphical framebuffer is exposed by a PCI device, its base
>> >> >> >> address and size are exposed to the OS via the Graphics Output
>> >> >> >> Protocol (GOP).
>> >> >> >>
>> >> >> >> On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
>> >> >> >> scratch at boot. This may result in the GOP framebuffer address to
>> >> >> >> become stale, if the BAR covering the framebuffer is modified. This
>> >> >> >> will cause the framebuffer to become unresponsive, and may in some
>> >> >> >> cases result in unpredictable behavior if the range is reassigned to
>> >> >> >> another device.
>> >> >> >
>> >> >> > Hm, commit message seems to indicate the issue is restricted to arm64,
>> >> >> > yet there's no IS_ENABLED(ARM64) to constrain the added code to that arch?
>> >> >>
>> >> >> True. I am eager to get some x86 coverage for this, since I would
>> >> >> expect this not to do any harm. But I'm fine with making it ARM/arm64
>> >> >> specific in the final version.
>> >> >
>> >> > I see.  IIUC, this is only a problem because pci_bus_assign_resources()
>> >> > is called from arch/arm64/kernel/pci.c:pci_acpi_scan_root() (as well as
>> >> > the host drivers) and x86 isn't affected because it doesn't do that.
>> >> >
>> >>
>> >> Correct. But on x86 (or rather, on a PC), you can be sure that UEFI
>> >> (or the legacy PCI bios) performed the resource assignment already.
>> >> One could argue that this is equally the case when running arm64 in
>> >> ACPI mode, but in general, you cannot assume the presence of firmware
>> >> on ARM/arm64 that has already taken care of this, and so the state of
>> >> the BARs has to be presumed invalid.
>> >
>> > The story is a bit more convoluted than that owing to x86 (and other
>> > arches) legacy.
>> >
>> > x86 tries to claim all PCI resources (in two passes - first enabled
>> > devices, second disabled devices) and that predates ACPI/UEFI.
>> >
>> > Mind, x86 reassign resources that can't be claimed too, the only
>> > difference with ARM64 is that, for the better or the worse, we
>> > have decided not to claim the FW PCI set-up on ARM64 even if it
>> > is sane, we do not even try, it was a deliberate choice.
>> >
>> > This patch should be harmless on x86 since if the FB PCI BAR is set
>> > up sanely, claiming it again should be a nop (to be checked).
>> >
>>
>> I have checked this with OVMF under QEMU. Claiming the resource early
>> like we do this in this patch does not result in any diagnostic output
>> or other symptoms that would suggest that anything unexpected occurs.
>
> There is something that I do not understand on how the resource
> claiming works on x86. IIUC on x86, resource claiming is done in:
>
> arch/x86/pci/legacy.c
>
> pci_subsys_init()
>  -> pcibios_init()
>   -> pcibios_resource_survey()
>
> pci_subsys_init() is run in a subsys_initcall.
>

Yes, the call trace I get for the resource claim for the efifb BAR
without this patch is

pci_subsys_init+0x3f/0x43
- pcibios_init+0x2c/0x3d
-- pcibios_resource_survey+0x38/0x6a
--- pci_legacy_init+0x2e/0x2e
---- pcibios_allocate_resources+0x8a/0x240
----- pci_claim_resource+0xdc/0x140


> Now, how do we ensure that resource claiming is carried out _after_
> the PCI root busses have been actually scanned ?
>
> The ACPI scan handler interface (so the interface to actually scan
> a PCI root bridge in ACPI) is initialized in acpi_init() (which
> is a subsys_initcall), how do we guarantee that is run before
> pci_subsys_init() ?
>

$ nm vmlinux |grep -E '__initcall_(acpi_init|pci_subsys_init)'
ffffffff81d540b8 t __initcall_acpi_init4
ffffffff81d54158 t __initcall_pci_subsys_init4

so it appears to depend on link order currently.
