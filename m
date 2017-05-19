From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] efifb: Avoid reconfiguration of BAR that covers the framebuffer
Date: Fri, 19 May 2017 17:37:30 +0100
Message-ID: <CAKv+Gu87gNJ-HN6-jgeuvg7vWePLkP0xbqcok554g2cG9aXtfA@mail.gmail.com>
References: <20170404152744.26687-1-ard.biesheuvel@linaro.org>
 <20170404152744.26687-3-ard.biesheuvel@linaro.org> <20170519162716.GA684@bhelgaas-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170519162716.GA684-1RhO1Y9PlrlHTL0Zs8A6p5iNqAH0jzoTYJqu5kTmcBRl57MIdRCFDg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Bjorn,

On 19 May 2017 at 17:27, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> [+cc linux-pci]
>
> On Tue, Apr 04, 2017 at 04:27:44PM +0100, Ard Biesheuvel wrote:
>> On UEFI systems, the PCI subsystem is enumerated by the firmware,
>> and if a graphical framebuffer is exposed by a PCI device, its base
>> address and size are exposed to the OS via the Graphics Output
>> Protocol (GOP).
>>
>> On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
>> scratch at boot. This may result in the GOP framebuffer address to
>> become stale, if the BAR covering the framebuffer is modified. This
>> will cause the framebuffer to become unresponsive, and may in some
>> cases result in unpredictable behavior if the range is reassigned to
>> another device.
>>
>> So add a non-x86 quirk to the EFI fb driver to find the BAR associated
>> with the GOP base address, and claim the BAR resource so that the PCI
>> core will not move it.
>
> I know this has already been merged as 55d728a40d36 ("efi/fb: Avoid
> reconfiguration of BAR that covers the framebuffer"), and I'm not
> suggesting that we revert it, but I have some misgivings.
>

Thanks for taking a look. I have been struggling with this issue for a
while now.

> One is the "#ifndef CONFIG_X86".  In principle, there is nothing arch-
> specific here.  I don't think it's a good idea to build in dependencies on
> things like "this arch preserves (or reprograms) PCI BARs".  The PCI core
> may reprogram all, some, or none of the PCI BARs, depending on what (if
> anything) firmware has done.
>

IIRC this was a late addition. I agree that the issue exists in theory
on x86 as well. However, I was primarily dealing with the reality of
arm64 systems that suddenly explode in inexplicable ways after
upgrading the kernel to one that happens to have EFIFB built in. The
patch went into -stable as well, so I still think adding #ifndef
CONFIG_X86 was the right choice here.

> Another is the use of pci_claim_resource() to express the idea that "this
> BAR can not be moved".  We have IORESOURCE_PCI_FIXED for that purpose, and
> previous versions of the patch used that.  I understand there was some
> problem with that, but I wish we could figure out and fix that problem
> instead of using a different mechanism.
>

OK. The problem was that IORESOURCE_PCI_FIXED does not prevent the PCI
subsystem from handing out the same range to another device.

> I'm not even completely sold on the idea that we need to prevent the BAR
> from being moved.  I'm not a UEFI expert, but if this requirement is in the
> spec, we should reference it.  If not, it should be sufficient to remember
> the boot-time BAR value, match the GOP base to *that*, and map it to
> whatever the current BAR value is.
>

There is no such requirement in the spec. The graphics output protocol
is not described in terms of PCI, BARs etc. The framebuffer is simply
a memory range with side effects that is left enabled when handing
over to the OS.

In summary, I am as unhappy with the patch as you are, but it is still
an improvement over the previous situation, so let's simply
collaborate to get this into shape going forward.

My preference would be to investigate IORESOURCE_PCI_FIXED again,
because that still seems like the best way to deal with a live
framebuffer on a PCI device that has memory decoding enabled. It
should also address the issue with the current version of the patch,
i.e., that claiming resources at this point is not possible if the
device resides behind a bridge.

So is there any guidance you can give as to how to proceed? If we set
IORESOURCE_PCI_FIXED, how should be prevent the PCI layer from
assigning this resource elsewhere if we cannot claim it yet?

Regards,
Ard.


>> Fixes: 9822504c1fa5 ("efifb: Enable the efi-framebuffer platform driver ...")
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.7+
>> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/video/fbdev/efifb.c | 66 ++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 65 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
>> index 8c4dc1e1f94f..758960b6aec9 100644
>> --- a/drivers/video/fbdev/efifb.c
>> +++ b/drivers/video/fbdev/efifb.c
>> @@ -10,6 +10,7 @@
>>  #include <linux/efi.h>
>>  #include <linux/errno.h>
>>  #include <linux/fb.h>
>> +#include <linux/pci.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/screen_info.h>
>>  #include <video/vga.h>
>> @@ -143,6 +144,8 @@ static struct attribute *efifb_attrs[] = {
>>  };
>>  ATTRIBUTE_GROUPS(efifb);
>>
>> +static bool pci_dev_disabled;        /* FB base matches BAR of a disabled device */
>> +
>>  static int efifb_probe(struct platform_device *dev)
>>  {
>>       struct fb_info *info;
>> @@ -152,7 +155,7 @@ static int efifb_probe(struct platform_device *dev)
>>       unsigned int size_total;
>>       char *option = NULL;
>>
>> -     if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
>> +     if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
>>               return -ENODEV;
>>
>>       if (fb_get_options("efifb", &option))
>> @@ -360,3 +363,64 @@ static struct platform_driver efifb_driver = {
>>  };
>>
>>  builtin_platform_driver(efifb_driver);
>> +
>> +#ifndef CONFIG_X86
>> +
>> +static bool pci_bar_found;   /* did we find a BAR matching the efifb base? */
>> +
>> +static void claim_efifb_bar(struct pci_dev *dev, int idx)
>> +{
>> +     u16 word;
>> +
>> +     pci_bar_found = true;
>> +
>> +     pci_read_config_word(dev, PCI_COMMAND, &word);
>> +     if (!(word & PCI_COMMAND_MEMORY)) {
>> +             pci_dev_disabled = true;
>> +             dev_err(&dev->dev,
>> +                     "BAR %d: assigned to efifb but device is disabled!\n",
>> +                     idx);
>> +             return;
>> +     }
>> +
>> +     if (pci_claim_resource(dev, idx)) {
>> +             pci_dev_disabled = true;
>> +             dev_err(&dev->dev,
>> +                     "BAR %d: failed to claim resource for efifb!\n", idx);
>> +             return;
>> +     }
>> +
>> +     dev_info(&dev->dev, "BAR %d: assigned to efifb\n", idx);
>> +}
>> +
>> +static void efifb_fixup_resources(struct pci_dev *dev)
>> +{
>> +     u64 base = screen_info.lfb_base;
>> +     u64 size = screen_info.lfb_size;
>> +     int i;
>> +
>> +     if (pci_bar_found || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
>> +             return;
>> +
>> +     if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
>> +             base |= (u64)screen_info.ext_lfb_base << 32;
>> +
>> +     if (!base)
>> +             return;
>> +
>> +     for (i = 0; i < PCI_STD_RESOURCE_END; i++) {
>> +             struct resource *res = &dev->resource[i];
>> +
>> +             if (!(res->flags & IORESOURCE_MEM))
>> +                     continue;
>> +
>> +             if (res->start <= base && res->end >= base + size - 1) {
>> +                     claim_efifb_bar(dev, i);
>> +                     break;
>> +             }
>> +     }
>> +}
>> +DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY,
>> +                            16, efifb_fixup_resources);
>> +
>> +#endif
>> --
>> 2.9.3
>>
