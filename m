From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Mon, 27 Mar 2017 16:37:57 +0100
Message-ID: <CAKv+Gu90Q77fOi73Ui++cOip4uHwPgXXo6aj8c2O3mjtnqQEgg@mail.gmail.com>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322193111.GA8190@wunner.de>
 <CAKv+Gu_X-SEnz7h9J8boqqjOQGHQawwdSAq4haH-OGu8zdfNfA@mail.gmail.com>
 <20170323084819.GA23281@h08.hostsharing.net>
 <CAKv+Gu93eJ-js3g7M6Jdm6XGMaWMswFmzBG2qNT4rn+3=1+EyA@mail.gmail.com>
 <20170323105727.GA2441@red-moon>
 <CAKv+Gu-J664KXaZR19nViq4o1n_x=P-trsZ0oNDiONuBpAcd7A@mail.gmail.com>
 <20170323143151.GA21544@red-moon>
 <CAKv+Gu_iUir5d3evOvS3tUK6vY1H7KBktDf253MA8vyZDwOKPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu_iUir5d3evOvS3tUK6vY1H7KBktDf253MA8vyZDwOKPA@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-pci <linux-pci@vger.kernel.org>, Peter Jones <pjones@redhat.com>, Heyi Guo <heyi.guo@linaro.org>, Lukas Wunner <lukas@wunner.de>, Hanjun Guo <hanjun.guo@linaro.org>, Yinghai Lu <yinghai@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 23 March 2017 at 15:15, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 23 March 2017 at 14:31, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
>> On Thu, Mar 23, 2017 at 12:25:48PM +0000, Ard Biesheuvel wrote:
>>> On 23 March 2017 at 10:57, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
>>> > On Thu, Mar 23, 2017 at 09:04:03AM +0000, Ard Biesheuvel wrote:
>>> >> On 23 March 2017 at 08:48, Lukas Wunner <lukas@wunner.de> wrote:
>>> >> > On Wed, Mar 22, 2017 at 07:32:43PM +0000, Ard Biesheuvel wrote:
>>> >> >> On 22 March 2017 at 19:31, Lukas Wunner <lukas@wunner.de> wrote:
>>> >> >> > On Wed, Mar 22, 2017 at 03:30:29PM +0000, Ard Biesheuvel wrote:
>>> >> >> >> On UEFI systems, the PCI subsystem is enumerated by the firmware,
>>> >> >> >> and if a graphical framebuffer is exposed by a PCI device, its base
>>> >> >> >> address and size are exposed to the OS via the Graphics Output
>>> >> >> >> Protocol (GOP).
>>> >> >> >>
>>> >> >> >> On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
>>> >> >> >> scratch at boot. This may result in the GOP framebuffer address to
>>> >> >> >> become stale, if the BAR covering the framebuffer is modified. This
>>> >> >> >> will cause the framebuffer to become unresponsive, and may in some
>>> >> >> >> cases result in unpredictable behavior if the range is reassigned to
>>> >> >> >> another device.
>>> >> >> >
>>> >> >> > Hm, commit message seems to indicate the issue is restricted to arm64,
>>> >> >> > yet there's no IS_ENABLED(ARM64) to constrain the added code to that arch?
>>> >> >>
>>> >> >> True. I am eager to get some x86 coverage for this, since I would
>>> >> >> expect this not to do any harm. But I'm fine with making it ARM/arm64
>>> >> >> specific in the final version.
>>> >> >
>>> >> > I see.  IIUC, this is only a problem because pci_bus_assign_resources()
>>> >> > is called from arch/arm64/kernel/pci.c:pci_acpi_scan_root() (as well as
>>> >> > the host drivers) and x86 isn't affected because it doesn't do that.
>>> >> >
>>> >>
>>> >> Correct. But on x86 (or rather, on a PC), you can be sure that UEFI
>>> >> (or the legacy PCI bios) performed the resource assignment already.
>>> >> One could argue that this is equally the case when running arm64 in
>>> >> ACPI mode, but in general, you cannot assume the presence of firmware
>>> >> on ARM/arm64 that has already taken care of this, and so the state of
>>> >> the BARs has to be presumed invalid.
>>> >
>>> > The story is a bit more convoluted than that owing to x86 (and other
>>> > arches) legacy.
>>> >
>>> > x86 tries to claim all PCI resources (in two passes - first enabled
>>> > devices, second disabled devices) and that predates ACPI/UEFI.
>>> >
>>> > Mind, x86 reassign resources that can't be claimed too, the only
>>> > difference with ARM64 is that, for the better or the worse, we
>>> > have decided not to claim the FW PCI set-up on ARM64 even if it
>>> > is sane, we do not even try, it was a deliberate choice.
>>> >
>>> > This patch should be harmless on x86 since if the FB PCI BAR is set
>>> > up sanely, claiming it again should be a nop (to be checked).
>>> >
>>>
>>> I have checked this with OVMF under QEMU. Claiming the resource early
>>> like we do this in this patch does not result in any diagnostic output
>>> or other symptoms that would suggest that anything unexpected occurs.
>>
>> There is something that I do not understand on how the resource
>> claiming works on x86. IIUC on x86, resource claiming is done in:
>>
>> arch/x86/pci/legacy.c
>>
>> pci_subsys_init()
>>  -> pcibios_init()
>>   -> pcibios_resource_survey()
>>
>> pci_subsys_init() is run in a subsys_initcall.
>>
>
> Yes, the call trace I get for the resource claim for the efifb BAR
> without this patch is
>
> pci_subsys_init+0x3f/0x43
> - pcibios_init+0x2c/0x3d
> -- pcibios_resource_survey+0x38/0x6a
> --- pci_legacy_init+0x2e/0x2e
> ---- pcibios_allocate_resources+0x8a/0x240
> ----- pci_claim_resource+0xdc/0x140
>
>
>> Now, how do we ensure that resource claiming is carried out _after_
>> the PCI root busses have been actually scanned ?
>>
>> The ACPI scan handler interface (so the interface to actually scan
>> a PCI root bridge in ACPI) is initialized in acpi_init() (which
>> is a subsys_initcall), how do we guarantee that is run before
>> pci_subsys_init() ?
>>
>
> $ nm vmlinux |grep -E '__initcall_(acpi_init|pci_subsys_init)'
> ffffffff81d540b8 t __initcall_acpi_init4
> ffffffff81d54158 t __initcall_pci_subsys_init4
>
> so it appears to depend on link order currently.

Bjorn, what is your take on this?

Claiming the BAR resources associated with the efifb region from a
DECLARE_PCI_FIXUP_HEADER() handler does not seem to interfere with the
way resources are claimed later on. For arm64, we need this to ensure
that the BAR doesn't move, but for x86 this does not seem to be an
issue. This means we could potentially make the quirk ARM-only, but I
am a bit reluctant to do so and create even more divergence.

Thanks,
Ard.
