From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH V3] efi: add efi_test driver for exporting UEFI runtime
 service interfaces
Date: Tue, 16 Aug 2016 12:25:42 +0100
Message-ID: <20160816112542.GK30909@codeblueprint.co.uk>
References: <1471241917-9694-1-git-send-email-ivan.hu@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471241917-9694-1-git-send-email-ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joeyli <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 15 Aug, at 02:18:37PM, Ivan Hu wrote:
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
>  drivers/firmware/efi/efi_test/efi_test.c | 730 +++++++++++++++++++++++++++++++
>  drivers/firmware/efi/efi_test/efi_test.h | 110 +++++
>  6 files changed, 863 insertions(+)
>  create mode 100644 drivers/firmware/efi/efi_test/Makefile
>  create mode 100644 drivers/firmware/efi/efi_test/efi_test.c
>  create mode 100644 drivers/firmware/efi/efi_test/efi_test.h
 
Please just call the new directory "test" - you don't need to repeat
the words "efi" and "test" over and over.

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

Please add me as a co-maintainer. That is the setup used for other
parts of drivers/firmware/efi/.

>  EFS FILESYSTEM
>  W:	http://aeschi.ch.eu.org/efs/
>  S:	Orphan
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 6394152..7677d99 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -112,6 +112,21 @@ config EFI_CAPSULE_LOADER
>  
>  	  Most users should say N.
>  
> +config EFI_TEST
> +	tristate "EFI Runtime Service Tests Support"
> +	depends on EFI
> +	default n
> +	help
> +	  Say Y here to enable the runtime services support via /dev/efi_test.
> +	  This driver uses the efi.<service> function pointers directly instead
> +	  of going through the efivar API, because it is not trying to test the
> +	  kernel subsystem, just for testing the UEFI runtime service
> +	  interfaces which are provided by the firmware. This driver is used
> +	  by the Firmware Test Suite (FWTS) for testing the UEFI runtime
> +	  interfaces readiness of the firmware.
> +	  Details for FWTS are available from:
> +	  <https://wiki.ubuntu.com/FirmwareTestSuite>
> +

Please include the usual "Most users should say N" or "If unsure, say
N" here. Let's be explicit that if people don't know what this option
is, they shouldn't be enabling it.

> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index a219640..569d1a1 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
>  obj-$(CONFIG_EFI_STUB)			+= libstub/
>  obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
>  obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
> +obj-$(CONFIG_EFI_TEST)			+= efi_test/
>  
>  arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
>  obj-$(CONFIG_ARM)			+= $(arm-obj-y)
> diff --git a/drivers/firmware/efi/efi_test/Makefile b/drivers/firmware/efi/efi_test/Makefile
> new file mode 100644
> index 0000000..bcd4577
> --- /dev/null
> +++ b/drivers/firmware/efi/efi_test/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_EFI_TEST)			+= efi_test.o
> diff --git a/drivers/firmware/efi/efi_test/efi_test.c b/drivers/firmware/efi/efi_test/efi_test.c
> new file mode 100644
> index 0000000..d69b2b9
> --- /dev/null
> +++ b/drivers/firmware/efi/efi_test/efi_test.c
> @@ -0,0 +1,730 @@
> +/*
> + * EFI Test Driver for Runtime Services
> + *
> + * Copyright(C) 2012-2016 Canonical Ltd.
> + *
> + * This driver exports EFI runtime services interfaces into userspace, which
> + * allow to use and test UEFI runtime services provided by firmware.
> + *
> + */
> +
> +#include <linux/version.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/proc_fs.h>
> +#include <linux/efi.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +
> +#include "efi_test.h"
> +
> +MODULE_AUTHOR("Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>");
> +MODULE_DESCRIPTION("EFI Test Driver");
> +MODULE_LICENSE("GPL");
> +
> +/* commit 83e681897 turned efi_enabled into a function, so abstract it */
> +#ifdef EFI_RUNTIME_SERVICES
> +#define EFI_RUNTIME_ENABLED	efi_enabled(EFI_RUNTIME_SERVICES)
> +#else
> +#define EFI_RUNTIME_ENABLED	efi_enabled
> +#endif

This should be unnecessary now the driver is distributed with the
kernel source.

> +/*
> + * Count the bytes in 'str', including the terminating NULL.
> + *
> + * Note this function returns the number of *bytes*, not the number of
> + * ucs2 characters.
> + */
> +static inline size_t __ucs2_strsize(uint16_t  __user *str)
> +{
> +	uint16_t *s = str, c;
> +	size_t len;
> +
> +	if (!str)
> +		return 0;
> +
> +	/* Include terminating NULL */
> +	len = sizeof(uint16_t);
> +
> +	if (get_user(c, s++)) {
> +		WARN(1, "efi_test: Can't read userspace memory for size");
> +		return 0;
> +	}

Shouldn't you be returning -EFAULT here? Don't WARN() about this
either, that's way over the top.

> +
> +	while (c != 0) {
> +		if (get_user(c, s++)) {
> +			WARN(1, "efi_test: Can't read userspace memory for size");
> +			return 0;
> +		}
> +		len += sizeof(uint16_t);
> +	}
> +	return len;
> +}

Could you use ucs2_char_t instead of uint16_t? uint*_t aren't really
used inside the kernel. Also include the word "user" in the function
name to distinguish it from ucs2_strsize() in lib/ucs2_string.c, e.g.
user_ucs2_strsize().

> +static long efi_runtime_get_variable(unsigned long arg)
> +{
> +	struct efi_getvariable __user *getvariable;
> +	struct efi_getvariable getvariable_local;
> +	unsigned long datasize, prev_datasize, *dz;
> +	efi_guid_t vendor_guid, *vd = NULL;
> +	efi_status_t status;
> +	uint16_t *name = NULL;
> +	uint32_t attr, *at;
> +	void *data = NULL;
> +	int rv = 0;
> +
> +	getvariable = (struct efi_getvariable __user *)arg;
> +
> +	if (copy_from_user(&getvariable_local, getvariable,
> +			   sizeof(getvariable_local)))
> +		return -EFAULT;

This is just a minor point, but if the user pointer is only referenced
a couple of times it would be better to call it 'getvariable_user' and
the local version 'getvariable'.

Ditto for all other functions.

> +	if (getvariable_local.data_size &&
> +	    get_user(datasize, getvariable_local.data_size))
> +		return -EFAULT;
> +	if (getvariable_local.vendor_guid) {
> +		if (copy_from_user(&vendor_guid, getvariable_local.vendor_guid,
> +			   sizeof(vendor_guid)))
> +			return -EFAULT;
> +		vd = &vendor_guid;
> +	}
> +
> +	if (getvariable_local.variable_name) {
> +		rv = copy_ucs2_from_user(&name,
> +				getvariable_local.variable_name);
> +		if (rv)
> +			return rv;
> +	}
> +
> +	at = getvariable_local.attributes ? &attr : NULL;
> +	dz = getvariable_local.data_size ? &datasize : NULL;
> +
> +	if (getvariable_local.data_size && getvariable_local.data) {
> +		data = kmalloc(datasize, GFP_KERNEL);
> +		if (!data) {
> +			kfree(name);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	prev_datasize = datasize;
> +	status = efi.get_variable(name, vd, at, dz, data);
> +	kfree(name);
> +
> +	if (data) {
> +		if (status == EFI_SUCCESS && prev_datasize >= datasize)
> +			rv = copy_to_user(getvariable_local.data, data,
> +				datasize);
> +		kfree(data);
> +	}
> +
> +	if (rv)
> +		return rv;
> +
> +	if (put_user(status, getvariable_local.status))
> +		return -EFAULT;
> +	if (status == EFI_SUCCESS && prev_datasize >= datasize) {
> +		if (at && put_user(attr, getvariable_local.attributes))
> +			return -EFAULT;
> +		if (dz && put_user(datasize, getvariable_local.data_size))
> +			return -EFAULT;
> +		return 0;
> +	} else if (status == EFI_BUFFER_TOO_SMALL) {
> +		if (dz && put_user(datasize, getvariable_local.data_size))
> +			return -EFAULT;
> +		return -EINVAL;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

All these conditionals make this code fairly difficult to follow.
Could you refactor this into a success path and error path based on
the value of 'status' after efi.get_variable()?

e.g.

	if (status != EFI_SUCCESS) {
		... error stuff ...
	}

	... success stuff ...

> +
> +static long efi_runtime_set_variable(unsigned long arg)
> +{
> +	struct efi_setvariable __user *setvariable;
> +	struct efi_setvariable setvariable_local;
> +	efi_guid_t vendor_guid;
> +	efi_status_t status;
> +	uint16_t *name = NULL;
> +	void *data;
> +	int rv;
> +
> +	setvariable = (struct efi_setvariable __user *)arg;
> +
> +	if (copy_from_user(&setvariable_local, setvariable,
> +			   sizeof(setvariable_local)))
> +		return -EFAULT;
> +	if (copy_from_user(&vendor_guid, setvariable_local.vendor_guid,
> +			   sizeof(vendor_guid)))
> +		return -EFAULT;
> +
> +	if (setvariable_local.variable_name) {
> +		rv = copy_ucs2_from_user(&name, setvariable_local.variable_name);
> +		if (rv)
> +			return rv;
> +	}
> +
> +	data = kmalloc(setvariable_local.data_size, GFP_KERNEL);
> +	if (!data) {
> +		kfree(name);
> +		return -ENOMEM;
> +	}
> +	if (copy_from_user(data, setvariable_local.data,
> +			   setvariable_local.data_size)) {
> +		kfree(data);
> +		kfree(name);
> +		return -EFAULT;
> +	}
> +
> +	status = efi.set_variable(name, &vendor_guid,
> +				setvariable_local.attributes,
> +				setvariable_local.data_size, data);
> +
> +	kfree(data);
> +	kfree(name);
> +
> +	if (put_user(status, setvariable_local.status))
> +		return -EFAULT;
> +	return status == EFI_SUCCESS ? 0 : -EINVAL;
> +}

Please use goto's and labels to reduce the number of places that you
need to call kfree().

> +
> +static long efi_runtime_get_time(unsigned long arg)
> +{
> +	struct efi_gettime __user *gettime;
> +	struct efi_gettime  gettime_local;
> +	efi_status_t status;
> +	efi_time_cap_t cap;
> +	efi_time_t efi_time;
> +
> +	gettime = (struct efi_gettime __user *)arg;
> +	if (copy_from_user(&gettime_local, gettime, sizeof(gettime_local)))
> +		return -EFAULT;
> +
> +	status = efi.get_time(gettime_local.time ? &efi_time : NULL,
> +			      gettime_local.capabilities ? &cap : NULL);
> +
> +	if (put_user(status, gettime_local.status))
> +		return -EFAULT;
> +	if (status != EFI_SUCCESS) {
> +		pr_err("efi_test: can't read time\n");
> +		return -EINVAL;
> +	}
> +	if (gettime_local.capabilities) {
> +		efi_time_cap_t __user *cap_local;
> +
> +		cap_local = (efi_time_cap_t *)gettime_local.capabilities;
> +		if (put_user(cap.resolution,
> +			&(cap_local->resolution)) ||
> +			put_user(cap.accuracy, &(cap_local->accuracy)) ||
> +			put_user(cap.sets_to_zero, &(cap_local->sets_to_zero)))
> +			return -EFAULT;
> +	}
> +	if (gettime_local.time)
> +		return copy_to_user(gettime_local.time, &efi_time,
> +			sizeof(efi_time_t)) ? -EFAULT : 0;

Using the ternary operator like this is kinda messy when you're doing
a function call on the same line. Just expand it to a full
if-conditional.

> +static long efi_runtime_query_capsulecaps(unsigned long arg)
> +{
> +	struct efi_querycapsulecapabilities __user *u_caps;
> +	struct efi_querycapsulecapabilities caps;
> +	efi_capsule_header_t *capsules;
> +	efi_status_t status;
> +	uint64_t max_size;
> +	int i, reset_type;
> +	int rv;
> +
> +	u_caps = (struct efi_querycapsulecapabilities __user *)arg;
> +
> +	if (copy_from_user(&caps, u_caps, sizeof(caps)))
> +		return -EFAULT;
> +
> +	capsules = kcalloc(caps.capsule_count + 1,
> +			   sizeof(efi_capsule_header_t), GFP_KERNEL);
> +	if (!capsules)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < caps.capsule_count; i++) {
> +		efi_capsule_header_t *c;
> +		/*
> +		 * We cannot dereference caps.capsule_header_array directly to
> +		 * obtain the address of the capsule as it resides in the
> +		 * user space
> +		 */
> +		if (get_user(c, caps.capsule_header_array + i)) {
> +			rv = -EFAULT;
> +			goto err_exit;
> +		}
> +		if (copy_from_user(&capsules[i], c,
> +				sizeof(efi_capsule_header_t))) {
> +			rv = -EFAULT;
> +			goto err_exit;
> +		}
> +	}
> +
> +	caps.capsule_header_array = &capsules;
> +
> +	status = efi.query_capsule_caps((efi_capsule_header_t **)
> +					caps.capsule_header_array,
> +					caps.capsule_count,
> +					&max_size, &reset_type);
> +
> +	if (put_user(status, caps.status)) {
> +		rv = -EFAULT;
> +		goto err_exit;
> +	}
> +
> +	if (put_user(max_size, caps.maximum_capsule_size)) {
> +		rv = -EFAULT;
> +		goto err_exit;
> +	}
> +
> +	if (put_user(reset_type, caps.reset_type)) {
> +		rv = -EFAULT;
> +		goto err_exit;
> +	}
> +
> +	if (status != EFI_SUCCESS) {
> +		rv = -EINVAL;
> +		goto err_exit;
> +	}
> +
> +	kfree(capsules);
> +	return 0;
> +
> +err_exit:
> +	kfree(capsules);
> +	return rv;
> +}

If you initialise 'rv' to zero at the start of this function you can
use 'err_exit' as the one and only exit path, though you'll probably
want to rename it to 'out' or something.
