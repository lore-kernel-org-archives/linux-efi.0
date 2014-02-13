From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/22] efi: add helper function to get UEFI params from
 FDT
Date: Thu, 13 Feb 2014 09:56:15 -0500
Message-ID: <1392303375.2771.28.camel@deneb.redhat.com>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
	 <1391619853-10601-4-git-send-email-leif.lindholm@linaro.org>
	 <20140213111637.GE20717@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140213111637.GE20717-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-02-13 at 11:17 +0000, Matt Fleming wrote:
> On Wed, 05 Feb, at 05:03:54PM, Leif Lindholm wrote:
> > From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > ARM and ARM64 architectures use the device tree to pass UEFI parameters
> > from stub to kernel. These parameters are things known to the stub but
> > not discoverable by the kernel after the stub calls ExitBootSerives().
> > There is a helper function in:
> > 
> >    drivers/firmware/efi/fdt.c
> > 
> > which the stub uses to add the UEFI parameters to the device tree.
> > This patch adds a complimentary helper function which UEFI runtime
> > support may use to retrieve the parameters from the device tree.
> > If an architecture wants to use this helper, it should select
> > CONFIG_UEFI_PARAMS_FROM_FDT.
> > 
> > Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/firmware/efi/Kconfig |    7 ++++
> >  drivers/firmware/efi/efi.c   |   79 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/efi.h          |    9 +++++
> >  3 files changed, 95 insertions(+)
> 
> Is there a particular reason this change is being added to
> drivers/firmware/efi/efi.c and not drivers/firmware/efi/fdt.c?
> 

drivers/firmware/efi/fdt.c is included by the stub which may or may not
be linked into kernel image. This helper is used by runtime services and
needs to be built into kernel.

--Mark
