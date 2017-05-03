From: Heyi Guo <heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Wed, 3 May 2017 11:09:51 +0800
Message-ID: <f8773b97-7085-ddb3-5dc4-d65cc1f5bce0@linaro.org>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490196629-28088-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,

I have one comment inclined.


ÔÚ 3/22/2017 11:30 PM, Ard Biesheuvel Ð´µÀ:
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
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> v3: check device is enabled before attempting to claim the resource
>
>   drivers/video/fbdev/efifb.c | 60 +++++++++++++++++++-
>   1 file changed, 59 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 8c4dc1e1f94f..88f653864a01 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -10,6 +10,7 @@
>   #include <linux/efi.h>
>   #include <linux/errno.h>
>   #include <linux/fb.h>
> +#include <linux/pci.h>
>   #include <linux/platform_device.h>
>   #include <linux/screen_info.h>
>   #include <video/vga.h>
> @@ -143,6 +144,9 @@ static struct attribute *efifb_attrs[] = {
>   };
>   ATTRIBUTE_GROUPS(efifb);
>   
> +static bool pci_bar_found;	/* did we find a BAR matching the efifb base? */
> +static bool pci_dev_disabled;	/* was the device disabled? */
> +
>   static int efifb_probe(struct platform_device *dev)
>   {
>   	struct fb_info *info;
> @@ -152,7 +156,7 @@ static int efifb_probe(struct platform_device *dev)
>   	unsigned int size_total;
>   	char *option = NULL;
>   
> -	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
> +	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
>   		return -ENODEV;
>   
>   	if (fb_get_options("efifb", &option))
> @@ -360,3 +364,57 @@ static struct platform_driver efifb_driver = {
>   };
>   
>   builtin_platform_driver(efifb_driver);
> +
> +static void claim_efifb_bar(struct pci_dev *dev, int idx)
> +{
> +	u16 word;
> +
> +	pci_bar_found = true;
> +
> +	pci_read_config_word(dev, PCI_COMMAND, &word);
> +	if (!(word & PCI_COMMAND_MEMORY)) {
> +		pci_dev_disabled = true;
> +		dev_err(&dev->dev,
> +			"BAR %d: assigned to efifb but device is disabled!\n",
> +			idx);
> +		return;
> +	}
> +
> +	if (pci_claim_resource(dev, idx)) {
> +		pci_dev_disabled = true;
> +		dev_err(&dev->dev,
> +			"BAR %d: failed to claim resource for efifb!\n", idx);
> +		return;
> +	}
> +
> +	dev_info(&dev->dev, "BAR %d: assigned to efifb\n", idx);
> +}
> +
> +static void efifb_fixup_resources(struct pci_dev *dev)
> +{
> +	u64 base = screen_info.lfb_base;
> +	u64 size = screen_info.lfb_size;
> +	int i;
> +
> +	if (pci_bar_found || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
> +		return;
> +
> +	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> +		base |= (u64)screen_info.ext_lfb_base << 32;
> +
> +	if (!base)
> +		return;
> +
> +	for (i = 0; i < PCI_STD_RESOURCE_END; i++) {
> +		struct resource *res = &dev->resource[i];
> +
> +		if (!(res->flags & IORESOURCE_MEM))
> +			continue;
> +
> +		if (res->start <= base && res->end >= base + size - 1) {
Have we considered PCI address translation here? I suppose the address 
reported by EFI GOP should be the address of CPU domain, not address of 
PCI domain. Address read from PCI BAR is PCI address which should add 
translation offset before being compared to CPU domain address.

I've not familiar with Linux code, so please ignore my comment if the 
code has supported address translation.

Regards,

Gary (Heyi Guo)

> +			claim_efifb_bar(dev, i);
> +			break;
> +		}
> +	}
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);
