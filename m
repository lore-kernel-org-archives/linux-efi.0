From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efi: add efi_test driver for exporting UEFI runtime
 service interfaces
Date: Fri, 22 Jul 2016 15:26:58 +0800
Message-ID: <20160722072658.GE12939@linux-rxt1.site>
References: <1468569498-9889-1-git-send-email-ivan.hu@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468569498-9889-1-git-send-email-ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Ivan, 

On Fri, Jul 15, 2016 at 03:58:18PM +0800, Ivan Hu wrote:
> This driver is used by the Firmware Test Suite (FWTS) for testing the UEFI
> runtime interfaces readiness of the firmware.
> 
> This driver exports UEFI runtime service interfaces into userspace,
> which allows to use and test UEFI runtime services provided by the
> firmware.
> 
> This driver uses the efi.<service> function pointers directly instead of
> going through the efivar API to allow for direct testing of the UEFI
> runtime service interfaces provided by the firmware.
> 
> Details for FWTS are available from,
> <https://wiki.ubuntu.com/FirmwareTestSuite>
> 
> Signed-off-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  MAINTAINERS                              |   6 +
>  drivers/firmware/efi/Kconfig             |  15 +
>  drivers/firmware/efi/Makefile            |   1 +
>  drivers/firmware/efi/efi_test/Makefile   |   1 +
>  drivers/firmware/efi/efi_test/efi_test.c | 713 +++++++++++++++++++++++++++++++
>  drivers/firmware/efi/efi_test/efi_test.h | 110 +++++
>  6 files changed, 846 insertions(+)
>  create mode 100644 drivers/firmware/efi/efi_test/Makefile
>  create mode 100644 drivers/firmware/efi/efi_test/efi_test.c
>  create mode 100644 drivers/firmware/efi/efi_test/efi_test.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1209323..1f888cc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4471,6 +4471,12 @@ M:	Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  S:	Maintained
>  F:	drivers/video/fbdev/efifb.c
>  
> +EFI TEST DRIVER
> +L:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +M:      Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> +S:      Maintained
> +F:      drivers/firmware/efi/efi_test/
> +
>  EFS FILESYSTEM
>  W:	http://aeschi.ch.eu.org/efs/
>  S:	Orphan
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 6394152..1cc02bd 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -112,6 +112,21 @@ config EFI_CAPSULE_LOADER
>  
>  	  Most users should say N.
>  
> +config EFI_TEST
> +	tristate "EFI Runtime Services Support"

Because this is a driver for debugging tool, I suggest that it doesn't need to
allow user to build-in to kernel. 

Please considering to put this driver to tools/testing folder. Or you have
a reason to put this testing driver to drivers/firmware/efi ?

> +	depends on EFI
> +	default n
> +	help
> +	  Say Y here to enable the runtime services support via /dev/efi_test.
								^^^^^^^^^^^^^^

I have tried this testing driver with the master branch of fwts git. But I
found that fwts tries to load efi_runtime kernel module and tries to use
/dev/efi_runtime. 

I cloned fwts code from "http://kernel.ubuntu.com/git/hwe/fwts.git" that it
is written on FirmwareTestSuite wiki page. And, I found there have a
efi_runtime driver in fwts/efi_runtime folder.

Did I miss anything for the module name doesn't match?


Thanks a lot!
Joey Lee
