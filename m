From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v3] efifb: avoid reconfiguration of BAR that covers the
 framebuffer
Date: Wed, 22 Mar 2017 20:31:11 +0100
Message-ID: <20170322193111.GA8190@wunner.de>
References: <1490196629-28088-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490196629-28088-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 22, 2017 at 03:30:29PM +0000, Ard Biesheuvel wrote:
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

Hm, commit message seems to indicate the issue is restricted to arm64,
yet there's no IS_ENABLED(ARM64) to constrain the added code to that arch?


> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);

Maybe this can be constrained to PCI_BASE_CLASS_DISPLAY?

Thanks,

Lukas
