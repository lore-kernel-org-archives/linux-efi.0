From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 03/22] efi: add helper function to get UEFI params from
 FDT
Date: Thu, 13 Feb 2014 11:17:02 +0000
Message-ID: <20140213111637.GE20717@console-pimps.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
 <1391619853-10601-4-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1391619853-10601-4-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 05 Feb, at 05:03:54PM, Leif Lindholm wrote:
> From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ARM and ARM64 architectures use the device tree to pass UEFI parameters
> from stub to kernel. These parameters are things known to the stub but
> not discoverable by the kernel after the stub calls ExitBootSerives().
> There is a helper function in:
> 
>    drivers/firmware/efi/fdt.c
> 
> which the stub uses to add the UEFI parameters to the device tree.
> This patch adds a complimentary helper function which UEFI runtime
> support may use to retrieve the parameters from the device tree.
> If an architecture wants to use this helper, it should select
> CONFIG_UEFI_PARAMS_FROM_FDT.
> 
> Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/Kconfig |    7 ++++
>  drivers/firmware/efi/efi.c   |   79 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h          |    9 +++++
>  3 files changed, 95 insertions(+)

Is there a particular reason this change is being added to
drivers/firmware/efi/efi.c and not drivers/firmware/efi/fdt.c?

-- 
Matt Fleming, Intel Open Source Technology Center
