From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC PATCH 2/2] efi: libstub: add support for the Chaoskey RNG
 USB stick to the stub
Date: Sat, 2 Sep 2017 08:45:01 +0200
Message-ID: <20170902064501.GB26383@kroah.com>
References: <20170819151740.625-1-ard.biesheuvel@linaro.org>
 <20170819151740.625-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170819151740.625-2-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardened-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, Aug 19, 2017 at 04:17:40PM +0100, Ard Biesheuvel wrote:
> Early entropy is hard to come by, especially on non-x86 systems that
> lack an architected instruction and are not as uniform as PCs.
> Fortunately, on UEFI systems, we can invoke the EFI_RNG_PROTOCOL,
> which exposes the platform specific entropy source in a generic way.
> We use this protocol to fill the RNG UEFI config table (which is used
> during early boot to seed the kernel's entropy pool), and on ARM and
> arm64, we invoke it to seed KASLR as well.
> 
> Sadly, EFI_RNG_PROTOCOL is not widely implemented, and so it would be
> nice to have a fallback for UEFI systems that lack it. So implement
> this fallback based on the Chaoskey RNG USB stick, which should be
> exposed using the standard UEFI USB I/O protocol if the firmware has
> USB support.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/Kconfig                   |   7 ++
>  drivers/firmware/efi/libstub/Makefile          |   2 +-
>  drivers/firmware/efi/libstub/efistub.h         |   3 +
>  drivers/firmware/efi/libstub/random-chaoskey.c | 126 +++++++++++++++++++++++++
>  4 files changed, 137 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/firmware/efi/libstub/random-chaoskey.c
> 
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 2b4c39fdfa91..448a6186d9fb 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -87,6 +87,13 @@ config EFI_RUNTIME_WRAPPERS
>  config EFI_ARMSTUB
>  	bool
>  
> +config EFI_RNG_CHAOSKEY
> +	bool "Chaoskey USB RNG support in the UEFI stub"
> +	help
> +	  Fall back to a Chaoskey RNG USB stick in case EFI_RNG_PROTOCOL
> +	  is not implemented by the firmware. This is used for early
> +	  seeding of the entropy pool, and for KASLR on ARM and arm64.
> +
>  config EFI_BOOTLOADER_CONTROL
>  	tristate "EFI Bootloader Control"
>  	depends on EFI_VARS
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index dedf9bde44db..fad6bc1d0e2a 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -40,7 +40,7 @@ $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
>  
>  lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o random.o \
>  				   $(patsubst %.c,lib-%.o,$(arm-deps))
> -
> +lib-$(CONFIG_EFI_RNG_CHAOSKEY)	+= random-chaoskey.o
>  lib-$(CONFIG_ARM)		+= arm32-stub.o
>  lib-$(CONFIG_ARM64)		+= arm64-stub.o
>  CFLAGS_arm64-stub.o 		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index 3afff5facd3b..9579ddb5937d 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -62,6 +62,9 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
>  			      unsigned long size, unsigned long align,
>  			      unsigned long *addr, unsigned long random_seed);
>  
> +efi_status_t efi_get_random_chaoskey(efi_system_table_t *sys_table_arg,
> +				     unsigned long size, u8 *out);
> +
>  efi_status_t check_platform_features(efi_system_table_t *sys_table_arg);
>  
>  efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg);
> diff --git a/drivers/firmware/efi/libstub/random-chaoskey.c b/drivers/firmware/efi/libstub/random-chaoskey.c
> new file mode 100644
> index 000000000000..3f94ec3df9ff
> --- /dev/null
> +++ b/drivers/firmware/efi/libstub/random-chaoskey.c
> @@ -0,0 +1,126 @@
> +/*
> + * Copyright (C) 2017 Linaro Ltd;  <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/efi.h>
> +#include <asm/efi.h>
> +
> +#include "efistub.h"
> +
> +#define CHAOSKEY_VENDOR_ID		0x1d50	/* OpenMoko */
> +#define CHAOSKEY_PRODUCT_ID		0x60c6	/* ChaosKey */
> +
> +static efi_usb_io_protocol_t *chaoskey_usb_io;
> +static unsigned long chaoskey_usb_ep_addr, chaoskey_usb_ep_size;
> +
> +static void locate_chaoskey(efi_system_table_t *sys_table_arg)
> +{
> +	efi_guid_t usb_io_guid = EFI_USB_IO_PROTOCOL_GUID;
> +	unsigned long bufsize = 0, i, j;
> +	efi_handle_t *handles;
> +	efi_status_t status;
> +
> +	chaoskey_usb_io = (void *)-1;
> +
> +	/* find all USB devices that UEFI knows about */
> +	status = efi_call_early(locate_handle, EFI_LOCATE_BY_PROTOCOL,
> +				&usb_io_guid, NULL, &bufsize, NULL);
> +	if (status != EFI_BUFFER_TOO_SMALL)
> +		return;
> +
> +	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, bufsize,
> +				(void **)&handles);
> +	if (status != EFI_SUCCESS)
> +		return;
> +
> +	status = efi_call_early(locate_handle, EFI_LOCATE_BY_PROTOCOL,
> +				&usb_io_guid, NULL, &bufsize, handles);
> +	if (status != EFI_SUCCESS)
> +		goto out;
> +
> +	for (i = 0; i < bufsize / sizeof(efi_handle_t); i++) {
> +		struct usb_device_descriptor dev;
> +		struct usb_interface_descriptor iface;
> +		efi_usb_io_protocol_t *p;
> +
> +		status = efi_call_early(handle_protocol, handles[i],
> +					&usb_io_guid, (void **)&p);
> +		if (status != EFI_SUCCESS)
> +			continue; /* shouldn't happen */
> +
> +		/* get the device descriptor so we can check the vid/pid */
> +		status = p->get_device_descriptor(p, &dev);
> +		if (status != EFI_SUCCESS)
> +			continue; /* shouldn't happen either */
> +
> +		if (dev.idVendor != CHAOSKEY_VENDOR_ID ||
> +		    dev.idProduct != CHAOSKEY_PRODUCT_ID)

idVendor and idProduct are little endian types.

You have run sparse on this code, right?


> +			continue;
> +
> +		/* get the number of endpoints from the interface descriptor */
> +		status = p->get_iface_descriptor(p, &iface);
> +		if (status != EFI_SUCCESS)
> +			continue;
> +
> +		/* locate the first BULK IN endpoint */
> +		for (j = 0; j < iface.bNumEndpoints; j++) {
> +			struct usb_endpoint_descriptor ep;

Don't we have built-in usb functions for this now?  Why not use them
instead of hand-rolling your own logic?

thanks,

greg k-h
