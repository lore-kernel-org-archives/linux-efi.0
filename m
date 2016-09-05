From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH V4] efi: add efi_test driver for exporting UEFI runtime
 service interfaces
Date: Mon, 5 Sep 2016 14:30:04 +0100
Message-ID: <20160905133004.GH32579@codeblueprint.co.uk>
References: <1472094931-8318-1-git-send-email-ivan.hu@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1472094931-8318-1-git-send-email-ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 25 Aug, at 11:15:31AM, Ivan Hu wrote:
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
>  MAINTAINERS                          |   7 +
>  drivers/firmware/efi/Kconfig         |  17 +
>  drivers/firmware/efi/Makefile        |   1 +
>  drivers/firmware/efi/test/Makefile   |   1 +
>  drivers/firmware/efi/test/efi_test.c | 749 +++++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/test/efi_test.h | 110 +++++
>  6 files changed, 885 insertions(+)
>  create mode 100644 drivers/firmware/efi/test/Makefile
>  create mode 100644 drivers/firmware/efi/test/efi_test.c
>  create mode 100644 drivers/firmware/efi/test/efi_test.h

Thanks Ivan, applied for v4.9.
