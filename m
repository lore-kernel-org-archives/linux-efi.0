From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Tue, 21 Mar 2017 11:54:48 +0000
Message-ID: <20170321115447.GA3667@red-moon>
References: <1490048037-1850-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1490048037-1850-1-git-send-email-ard.biesheuvel@linaro.org>
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
Cc: linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, leif.lindholm@linaro.org, heyi.guo@linaro.org, pjones@redhat.com, hanjun.guo@linaro.org, Bjorn Helgaas <bhelgaas@google.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

[+Bjorn]

On Mon, Mar 20, 2017 at 10:13:57PM +0000, Ard Biesheuvel wrote:
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

How does it currently work on eg x86 ? I suspect it just works because
on x86 resources are claimed at boot and if the FB memory BAR contains
reasonable values it is left alone by the kernel code reassigning
resources on x86.

> So add a quirk to the EFI fb driver to find the BAR associated with
> the GOP base address, and set the IORESOURCE_PCI_FIXED attribute so
> that the PCI core will leave it alone.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/video/fbdev/efifb.c | 33 ++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index 8c4dc1e1f94f..97a3b15b6f04 100644
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
> @@ -360,3 +361,35 @@ static struct platform_driver efifb_driver = {
>  };
>  
>  builtin_platform_driver(efifb_driver);
> +
> +static bool resource_found;
> +
> +static void efifb_fixup_resources(struct pci_dev *dev)
> +{
> +	u64 fb_base = screen_info.lfb_base;
> +	u64 fb_size = screen_info.lfb_size;
> +	int i;
> +
> +	if (resource_found || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
> +		return;
> +
> +	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> +		fb_base |= (u64)screen_info.ext_lfb_base << 32;
> +
> +	if (!fb_base)
> +		return;
> +
> +	for (i = 0; i < PCI_STD_RESOURCE_END; i++) {
> +		struct resource *res = &dev->resource[i];
> +
> +		if (!(res->flags & IORESOURCE_MEM))
> +			continue;
> +
> +		if (res->start <= fb_base && res->end >= fb_base + fb_size) {

You are checking for a live resource here right (ie PCI device should be
enabled) ? I am not sure that just checking the resource range is safe
(I mean it would be most certainly a FW bug to have a PCI disabled
device with memory BAR programmed with the FB addresses but thought it
was worth mentioning).

Lorenzo

> +			res->flags |= IORESOURCE_PCI_FIXED;
> +			resource_found = true;
> +			break;
> +		}
> +	}
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);
> -- 
> 2.7.4
> 
