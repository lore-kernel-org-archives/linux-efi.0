From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] drivers/fbdev: efifb: allow BAR to be moved instead of
 claiming it
Date: Tue, 27 Jun 2017 16:02:06 -0400
Message-ID: <20170627200206.5jpvnaokvgqwxoul@redhat.com>
References: <20170627161936.2301-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170627161936.2301-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 27, 2017 at 04:19:36PM +0000, Ard Biesheuvel wrote:
> On UEFI systems, the firmware may expose a Graphics Output Protocol (GOP)
> instance to which the efifb driver attempts to attach in order to provide
> a minimal, unaccelerated framebuffer. The GOP protocol itself is not very
> sophisticated, and only describes the offset and size of the framebuffer
> in memory, and the pixel format.
> 
> If the GOP framebuffer is provided by a PCI device, it will have been
> configured and enabled by the UEFI firmware, and the GOP protocol will
> simply point into a live BAR region. However, the GOP protocol itself does
> not describe this relation, and so we have to take care not to reconfigure
> the BAR without taking efifb's dependency on it into account.
> 
> Commit 55d728a40d36 ("efi/fb: Avoid reconfiguration of BAR that covers
> the framebuffer") attempted to do so by claiming the BAR resource early
> on, which prevents the PCI resource allocation routines from changing it.
> However, it turns out that this only works if the PCI device is not
> behind any bridges, since the bridge resources need to be claimed first.
> 
> So instead, allow the BAR to be moved, but make the efifb driver deal
> with that gracefully. So record the resource that covers the BAR early
> on, and if it turns out the have moved by the time we probe the efifb
> driver, update the framebuffer address accordingly.
> 
> While this is less likely to occur on x86, given that the firmware's
> PCI resource allocation is more likely to be preserved, this is a
> worthwhile sanity check to have in place, and so let's remove the
> #ifdef !CONFIG_X86 that surrounds it.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/video/fbdev/efifb.c | 24 ++++++++++++--------
>  1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
> index b827a8113e26..6220de3e25d3 100644
> --- a/drivers/video/fbdev/efifb.c
> +++ b/drivers/video/fbdev/efifb.c
> @@ -146,6 +146,9 @@ ATTRIBUTE_GROUPS(efifb);
>  
>  static bool pci_dev_disabled;	/* FB base matches BAR of a disabled device */
>  
> +static struct resource *bar_resource;
> +static u64 bar_offset;
> +
>  static int efifb_probe(struct platform_device *dev)
>  {
>  	struct fb_info *info;
> @@ -200,6 +203,13 @@ static int efifb_probe(struct platform_device *dev)
>  		efifb_fix.smem_start |= ext_lfb_base;
>  	}
>  
> +	if (bar_resource &&
> +	    bar_resource->start + bar_offset != efifb_fix.smem_start) {
> +
> +		pr_warn("efifb: PCI BAR has moved, updating fb address\n");
> +		efifb_fix.smem_start = bar_resource->start + bar_offset;

Does this really need a pr_warn()?  Seems like it should be dev_info(),
the point of the patch is to make moving it not be a problem.

-- 
  Peter
