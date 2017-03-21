From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Tue, 21 Mar 2017 19:18:30 +0000
Message-ID: <CAKv+Gu98gMwK-mUmKGxffjHWC+fb0XpYtbUgfuEV0W0dSbQ4Dw@mail.gmail.com>
References: <1490123810-12383-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490123810-12383-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lorenzo Pieralisi <lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Heyi Guo <heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-pci <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 21 March 2017 at 19:16, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On UEFI systems, the PCI subsystem is enumerated by the firmware,
> and if a graphical framebuffer is exposed by a PCI device, its base
> address and size are exposed to the OS via the Graphics Output
> Protocol (GOP).
>
> On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
> scratch at boot. This may result in the GOP framebuffer address to
> become stale, if the BAR covering the framebuffer is modified. This
> will cause the framebuffer to become unresponsive, and may in some
> cases result in unpredictable behavior if the range is reassigned to
> another device.
>
> So add a quirk to the EFI fb driver to find the BAR associated with
> the GOP base address, and set the IORESOURCE_PCI_FIXED attribute so
> that the PCI core will leave it alone.
>

This final paragraph is now out of date, and should be fixed. Apologies.

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> As it turns out, setting the IORESOURCE_PCI_FIXED flag is not sufficient
> to make the PCI core leave the BARs alone, so instead, the BAR resource
> is claimed in the quirk handler.
>
> As suggested by Lorenzo, a check is added that the device has memory
> decoding enabled, and if it doesn't, no attempt is made to use the
> EFI framebuffer.
>
>  drivers/video/fbdev/efifb.c | 58 +++++++++++++++++++-
>  1 file changed, 57 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 8c4dc1e1f94f..eeeaf78c4a5b 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -10,6 +10,7 @@
>  #include <linux/efi.h>
>  #include <linux/errno.h>
>  #include <linux/fb.h>
> +#include <linux/pci.h>
>  #include <linux/platform_device.h>
>  #include <linux/screen_info.h>
>  #include <video/vga.h>
> @@ -143,6 +144,9 @@ static struct attribute *efifb_attrs[] = {
>  };
>  ATTRIBUTE_GROUPS(efifb);
>
> +static bool pci_bar_found;     /* did we find a BAR matching the efifb base? */
> +static bool pci_bar_disabled;  /* was it disabled? */
> +
>  static int efifb_probe(struct platform_device *dev)
>  {
>         struct fb_info *info;
> @@ -152,7 +156,7 @@ static int efifb_probe(struct platform_device *dev)
>         unsigned int size_total;
>         char *option = NULL;
>
> -       if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
> +       if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_bar_disabled)
>                 return -ENODEV;
>
>         if (fb_get_options("efifb", &option))
> @@ -360,3 +364,55 @@ static struct platform_driver efifb_driver = {
>  };
>
>  builtin_platform_driver(efifb_driver);
> +
> +static void claim_efifb_bar(struct pci_dev *dev, int idx)
> +{
> +       u16 word;
> +
> +       pci_bar_found = true;
> +
> +       if (pci_claim_resource(dev, idx)) {
> +               pci_bar_disabled = true;
> +               dev_err(&dev->dev, "BAR %d: failed to claim efifb BAR\n", idx);
> +               return;
> +       }
> +
> +       pci_read_config_word(dev, PCI_COMMAND, &word);
> +       if (!(word & PCI_COMMAND_MEMORY)) {
> +               pci_bar_disabled = true;
> +               dev_err(&dev->dev,
> +                       "BAR %d: efifb BAR has memory decoding disabled!\n", idx);
> +               return;
> +       }
> +
> +       dev_info(&dev->dev, "BAR %d: claimed for efifb\n", idx);
> +}
> +
> +static void efifb_fixup_resources(struct pci_dev *dev)
> +{
> +       u64 base = screen_info.lfb_base;
> +       u64 size = screen_info.lfb_size;
> +       int i;
> +
> +       if (pci_bar_found || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
> +               return;
> +
> +       if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> +               base |= (u64)screen_info.ext_lfb_base << 32;
> +
> +       if (!base)
> +               return;
> +
> +       for (i = 0; i < PCI_STD_RESOURCE_END; i++) {
> +               struct resource *res = &dev->resource[i];
> +
> +               if (!(res->flags & IORESOURCE_MEM))
> +                       continue;
> +
> +               if (res->start <= base && res->end >= base + size - 1) {
> +                       claim_efifb_bar(dev, i);
> +                       break;
> +               }
> +       }
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);
> --
> 2.7.4
>
