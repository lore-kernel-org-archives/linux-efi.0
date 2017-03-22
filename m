From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Wed, 22 Mar 2017 12:39:57 +0000
Message-ID: <CAKv+Gu-XJK8bJvPrjfHbFHsOmuJ96RRgdsg2E7vgC0HZDemyFg@mail.gmail.com>
References: <1490123810-12383-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170322102939.GB3519@red-moon> <35F65528-FC1F-4813-A0C6-641CF864212A@linaro.org>
 <20170322113500.GA3940@red-moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20170322113500.GA3940@red-moon>
Sender: linux-pci-owner@vger.kernel.org
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <hanjun.guo@linaro.org>, Heyi Guo <heyi.guo@linaro.org>, linux-pci <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

On 22 March 2017 at 11:35, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> [+Yinghai]
>
> On Wed, Mar 22, 2017 at 11:08:48AM +0000, Ard Biesheuvel wrote:
>>
>> > On 22 Mar 2017, at 10:29, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
>> >
>> >> On Tue, Mar 21, 2017 at 07:16:50PM +0000, Ard Biesheuvel wrote:
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
>> >>
>> >> So add a quirk to the EFI fb driver to find the BAR associated with
>> >> the GOP base address, and set the IORESOURCE_PCI_FIXED attribute so
>> >> that the PCI core will leave it alone.
>> >>
>> >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> >> ---
>> >> As it turns out, setting the IORESOURCE_PCI_FIXED flag is not sufficient
>> >> to make the PCI core leave the BARs alone, so instead, the BAR resource
>> >> is claimed in the quirk handler.
>> >>
>> >> As suggested by Lorenzo, a check is added that the device has memory
>> >> decoding enabled, and if it doesn't, no attempt is made to use the
>> >> EFI framebuffer.
>> >>
>> >> drivers/video/fbdev/efifb.c | 58 +++++++++++++++++++-
>> >> 1 file changed, 57 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
>> >> index 8c4dc1e1f94f..eeeaf78c4a5b 100644
>> >> --- a/drivers/video/fbdev/efifb.c
>> >> +++ b/drivers/video/fbdev/efifb.c
>> >> @@ -10,6 +10,7 @@
>> >> #include <linux/efi.h>
>> >> #include <linux/errno.h>
>> >> #include <linux/fb.h>
>> >> +#include <linux/pci.h>
>> >> #include <linux/platform_device.h>
>> >> #include <linux/screen_info.h>
>> >> #include <video/vga.h>
>> >> @@ -143,6 +144,9 @@ static struct attribute *efifb_attrs[] = {
>> >> };
>> >> ATTRIBUTE_GROUPS(efifb);
>> >>
>> >> +static bool pci_bar_found;    /* did we find a BAR matching the efifb base? */
>> >> +static bool pci_bar_disabled;    /* was it disabled? */
>> >> +
>> >> static int efifb_probe(struct platform_device *dev)
>> >> {
>> >>    struct fb_info *info;
>> >> @@ -152,7 +156,7 @@ static int efifb_probe(struct platform_device *dev)
>> >>    unsigned int size_total;
>> >>    char *option = NULL;
>> >>
>> >> -    if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
>> >> +    if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_bar_disabled)
>> >>        return -ENODEV;
>> >>
>> >>    if (fb_get_options("efifb", &option))
>> >> @@ -360,3 +364,55 @@ static struct platform_driver efifb_driver = {
>> >> };
>> >>
>> >> builtin_platform_driver(efifb_driver);
>> >> +
>> >> +static void claim_efifb_bar(struct pci_dev *dev, int idx)
>> >> +{
>> >> +    u16 word;
>> >> +
>> >> +    pci_bar_found = true;
>> >> +
>> >> +    if (pci_claim_resource(dev, idx)) {
>> >
>> > I would not do that. If claiming the resource succeeds, it will become
>> > immutable (ie it becomes part of the resource tree), if it is your FB
>> > fine if it isn't this will mess things up since a) you won't be able to
>> > claim the PCI resources for the real FB and b) you won't be able to
>> > reallocate the PCI resources for the device we *think* is the FB but it
>> > actually isn't (unless we force a realloc).
>> >
>> > So, I would carry out the check below first, if the device is enabled
>> > we should flag its resource IORESOURCE_PCI_FIXED otherwise just do
>> > nothing and let PCI core (through arch specific realloc policy) handle
>> > it.
>> >
>>
>> Well, it turned out that this does not actually work: the BAR is not
>> reassigned, but the same range ends up being given to another device
>> in some cases.
>
> Ok, that's because the PCI core just prevent assigning that resource
> but it does not request it (ie insert it in the resource tree) which
> is what you do when claiming it.
>

Yes, that seems to be what is happening.

> I wonder how IORESOURCE_PCI_FIXED works on eg x86, I think it is time
> to have a proper look into resources allocation code because there
> are bits and pieces that are quite obscure to me.
>

I did a quick test with calling request_mem_region(), in which case we
end up with something like

10000000-3efeffff : PCI Bus 0000:00
  10000000-101d4bff : efifb:pci
  101d5000-101d5fff : 0000:00:01.0
  101d6000-101d6fff : 0000:00:02.0
  101d7000-101d7fff : 0000:00:04.0
    101d7000-101d7fff : ehci_hcd
  101d8000-101d8fff : 0000:00:05.0
  101e0000-101effff : 0000:00:05.0
  10200000-1023ffff : 0000:00:02.0

which works, because the region is no longer assigned to another BAR.

But I think claiming the resource via the PCI subsystem is probably
more appropriate, because then we get

10000000-3efeffff : PCI Bus 0000:00
  10000000-10ffffff : 0000:00:05.0
    10000000-101d4fff : efifb
  11000000-1103ffff : 0000:00:02.0
  11040000-1104ffff : 0000:00:05.0
  11050000-11050fff : 0000:00:01.0
  11051000-11051fff : 0000:00:02.0
  11052000-11052fff : 0000:00:04.0
    11052000-11052fff : ehci_hcd
  11053000-11053fff : 0000:00:05.0

(Note that efifb does not use the entire BAR resource)

> I think I would reverse the order in which you carry out the BAR
> reservation anyway (first check if the device is enabled second request
> the resource ie claim it).
>

I will spin a v3 with the check and the claim in reverse order. But I
think we should keep the pci_claim() call.
