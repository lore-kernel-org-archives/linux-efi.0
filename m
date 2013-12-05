From: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V5 6/6] Add config EFI_STUB for ARM to Kconfig
Date: Thu, 05 Dec 2013 20:04:28 +0000
Message-ID: <20131205200428.8FEBAC40785@trevor.secretlab.ca>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org> < 1385595115-21488-7-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385595115-21488-7-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 27 Nov 2013 15:31:55 -0800, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Dude. Must have commit text. You know better.  :-)

> ---
>  arch/arm/Kconfig |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a1b4758..6601985 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1857,6 +1857,16 @@ config EFI
>  	  This option is only useful on systems that have UEFI firmware.
>  	  However, even with this option, the resultant kernel will
>  	  continue to boot on non-UEFI platforms.
> +config EFI_STUB

Need a blank line between the previous stanza and config EFI_STUB

> +	bool "EFI stub support"
> +	depends on EFI && !CPU_BIG_ENDIAN
> +	---help---
> +	  This kernel feature allows a zImage to be loaded directly
> +	  by EFI firmware without the use of a bootloader.  A PE/COFF
> +	  header is added to the zImage in a way that makes the binary
> +	  both a Linux zImage and an PE/COFF executable that can be
> +	  executed directly by EFI firmware.
> +	  See Documentation/efi-stub.txt for more information.

Nit: 80 column word wrap is customary.

g.
