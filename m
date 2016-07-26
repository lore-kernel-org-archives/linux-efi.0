From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] efi: add efi_test driver for exporting UEFI runtime
 service interfaces
Date: Tue, 26 Jul 2016 22:47:02 +0800
Message-ID: <20160726144702.GQ21549@linux-rxt1.site>
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

[...snip]

> index 6394152..1cc02bd 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -112,6 +112,21 @@ config EFI_CAPSULE_LOADER
>  
>  	  Most users should say N.
>  
> +config EFI_TEST
> +	tristate "EFI Runtime Services Support"

I suggest that add _TEST_ or _DEBUG_ term to the above short description to
indicate that this driver is for testing.

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
>  endmenu
>  

[...snip]

> index 0000000..3a41d32
> --- /dev/null
> +++ b/drivers/firmware/efi/efi_test/efi_test.c
> @@ -0,0 +1,713 @@
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
> +
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
> +
> +/*
> + * Free a buffer allocated by copy_ucs2_from_user_len()
> + */
> +static inline void ucs2_kfree(uint16_t *buf)
> +{
> +	kfree(buf);
> +}

Why not just direct call kfree() in the later codes but need a inline
function as wrapper?

> +
> +/*
> + * Allocate a buffer and copy a ucs2 string from user space into it.
> + */
> +static inline int
> +copy_ucs2_from_user_len(uint16_t **dst, uint16_t __user *src, size_t len)
> +{
> +	uint16_t *buf;
> +
> +	if (!src) {
> +		*dst = NULL;
> +		return 0;
> +	}
> +
> +	if (!access_ok(VERIFY_READ, src, 1))
> +		return -EFAULT;
> +
> +	buf = kmalloc(len, GFP_KERNEL);
> +	if (!buf) {
> +		*dst = 0;

It's minor, but I suggest that the above code keeps the same style
with '*dst = NULL'.

> +		return -ENOMEM;
> +	}
> +	*dst = buf;
> +
> +	if (copy_from_user(*dst, src, len)) {
> +		kfree(buf);
> +		return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Count the bytes in 'str', including the terminating NULL.
> + *
> + * Just a wrap for __ucs2_strsize
> + */
> +static inline int get_ucs2_strsize_from_user(uint16_t __user *src, size_t *len)
> +{
> +	if (!access_ok(VERIFY_READ, src, 1))
> +		return -EFAULT;
> +
> +	*len = __ucs2_strsize(src);
> +	if (*len == 0)
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +/*
> + * Calculate the required buffer allocation size and copy a ucs2 string
> + * from user space into it.
> + *
> + * This function differs from copy_ucs2_from_user_len() because it
> + * calculates the size of the buffer to allocate by taking the length of
> + * the string 'src'.
> + *
> + * If a non-zero value is returned, the caller MUST NOT access 'dst'.
> + *
> + * It is the caller's responsibility to free 'dst'.
> + */
> +static inline int copy_ucs2_from_user(uint16_t **dst, uint16_t __user *src)
> +{
> +	size_t len;
> +
> +	if (!access_ok(VERIFY_READ, src, 1))
> +		return -EFAULT;
> +
> +	len = __ucs2_strsize(src);
> +	return copy_ucs2_from_user_len(dst, src, len);
> +}
> +
> +/*
> + * Copy a ucs2 string to a user buffer.
> + *
> + * This function is a simple wrapper around copy_to_user() that does
> + * nothing if 'src' is NULL, which is useful for reducing the amount of
> + * NULL checking the caller has to do.
> + *
> + * 'len' specifies the number of bytes to copy.
> + */
> +static inline int
> +copy_ucs2_to_user_len(uint16_t __user *dst, uint16_t *src, size_t len)
> +{
> +	if (!src)
> +		return 0;
> +
> +	if (!access_ok(VERIFY_WRITE, dst, 1))
> +		return -EFAULT;
> +
> +	return copy_to_user(dst, src, len);
> +}
> +
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
> +	if (getvariable_local.data_size &&
> +	    get_user(datasize, getvariable_local.data_size))
> +		return -EFAULT;
> +	if (getvariable_local.vendor_guid) {
> +
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
> +			ucs2_kfree(name);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	prev_datasize = datasize;
> +	status = efi.get_variable(name, vd, at, dz, data);
> +	ucs2_kfree(name);
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
> +	} else {
> +		return -EINVAL;
> +	}
> +

Looks the above codes doesn't return DataSize to user space if it got
EFI_BUFFER_TOO_SMALL.

In UEFI spec:

If the Data buffer is too small to hold the contents of the variable, the error
EFI_BUFFER_TOO_SMALL is returned and DataSize is set to the required buffer size to obtain
the data.

> +	return 0;
> +}
> +
> +static long efi_runtime_set_variable(unsigned long arg)
> +{
> +	struct efi_setvariable __user *setvariable;
> +	struct efi_setvariable setvariable_local;
> +	efi_guid_t vendor_guid;
> +	efi_status_t status;
> +	uint16_t *name;
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
> +	rv = copy_ucs2_from_user(&name, setvariable_local.variable_name);
> +	if (rv)
> +		return rv;
> +
> +	data = kmalloc(setvariable_local.data_size, GFP_KERNEL);
> +	if (!data) {
> +		ucs2_kfree(name);
> +		return -ENOMEM;
> +	}
> +	if (copy_from_user(data, setvariable_local.data,
> +			   setvariable_local.data_size)) {
> +		ucs2_kfree(data);
> +		kfree(name);

Here should be?

	ucs2_kfree(name);
	kfree(date);

> +		return -EFAULT;
> +	}
> +
> +	status = efi.set_variable(name, &vendor_guid,
> +				setvariable_local.attributes,
> +				setvariable_local.data_size, data);
> +
> +	kfree(data);
> +	ucs2_kfree(name);
> +
> +	if (put_user(status, setvariable_local.status))
> +		return -EFAULT;
> +	return status == EFI_SUCCESS ? 0 : -EINVAL;
> +}
> +

[...snip]

> +
> +static long efi_runtime_get_nextvariablename(unsigned long arg)
> +{
> +	struct efi_getnextvariablename __user *getnextvariablename;
> +	struct efi_getnextvariablename getnextvariablename_local;
> +	unsigned long name_size, prev_name_size = 0, *ns = NULL;
> +	efi_status_t status;
> +	efi_guid_t *vd = NULL;
> +	efi_guid_t vendor_guid;
> +	uint16_t *name = NULL;
> +	int rv;
> +
> +	getnextvariablename = (struct efi_getnextvariablename
> +							__user *)arg;
> +
> +	if (copy_from_user(&getnextvariablename_local, getnextvariablename,
> +			   sizeof(getnextvariablename_local)))
> +		return -EFAULT;
> +
> +	if (getnextvariablename_local.variable_name_size) {
> +		if (get_user(name_size,
> +				getnextvariablename_local.variable_name_size))
> +			return -EFAULT;
> +		ns = &name_size;
> +		prev_name_size = name_size;
> +	}
> +
> +	if (getnextvariablename_local.vendor_guid) {
> +		if (copy_from_user(&vendor_guid,
> +				getnextvariablename_local.vendor_guid,
> +				sizeof(vendor_guid)))
> +			return -EFAULT;
> +		vd = &vendor_guid;
> +	}
> +
> +	if (getnextvariablename_local.variable_name) {
> +		size_t name_string_size = 0;
> +
> +		rv = get_ucs2_strsize_from_user(
> +				getnextvariablename_local.variable_name,
> +				&name_string_size);
> +		if (rv)
> +			return rv;
> +		/*
> +		 * name_size may be smaller than the real buffer size where
> +		 * VariableName located in some use cases. The most typical
> +		 * case is passing a 0 toget the required buffer size for the
> +		 * 1st time call. So we need to copy the content from user
> +		 * space for at least the string size ofVariableName, or else
> +		 * the name passed to UEFI may not be terminatedas we expected.
> +		 */

There have typo in the above comments.

> +		rv = copy_ucs2_from_user_len(&name,
> +				getnextvariablename_local.variable_name,
> +				prev_name_size > name_string_size ?
> +				prev_name_size : name_string_size);
> +		if (rv)
> +			return rv;
> +	}
> +
> +	status = efi.get_next_variable(ns, name, vd);
> +
> +	if (name) {
> +		rv = copy_ucs2_to_user_len(
> +				getnextvariablename_local.variable_name,
> +				name, prev_name_size);
> +		ucs2_kfree(name);
> +		if (rv)
> +			return -EFAULT;
> +	}
> +
> +	if (put_user(status, getnextvariablename_local.status))
> +		return -EFAULT;
> +
> +	if (ns) {
> +		if (put_user(*ns,
> +			getnextvariablename_local.variable_name_size))
> +			return -EFAULT;
> +	}
> +
> +	if (vd) {
> +		if (copy_to_user(getnextvariablename_local.vendor_guid,
> +				 vd, sizeof(efi_guid_t)))
> +			return -EFAULT;
> +	}
> +
> +	if (status != EFI_SUCCESS)
> +		return -EINVAL;
> +	return 0;
> +}
> +

[...snip]

> +
> +static long efi_runtime_query_capsulecaps(unsigned long arg)
> +{
> +	struct efi_querycapsulecapabilities __user *u_caps;
> +	struct efi_querycapsulecapabilities caps;
> +	efi_capsule_header_t *capsules;
> +	efi_status_t status;
> +	uint64_t max_size;
> +	int i, reset_type;
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
> +		 * We cannot dereference caps.CapsuleHeaderArray directly to
> +		 * obtain the address of the capsule as it resides in the
> +		 * user space
> +		 */
> +		if (get_user(c, caps.capsule_header_array + i))
> +			return -EFAULT;
> +		if (copy_from_user(&capsules[i], c,
> +				sizeof(efi_capsule_header_t)))
> +			return -EFAULT;
> +	}

The above two "return -EFAULT" cause that it has memory leak of the capsules 
buffer.

> +
> +	caps.capsule_header_array = &capsules;
> +
> +	status = efi.query_capsule_caps((efi_capsule_header_t **)
> +					caps.capsule_header_array,
> +					caps.capsule_count,
> +					&max_size, &reset_type);
> +
> +	if (put_user(status, caps.status))
> +		return -EFAULT;
> +
> +	if (put_user(max_size, caps.maximum_capsule_size))
> +		return -EFAULT;
> +
> +	if (put_user(reset_type, caps.reset_type))
> +		return -EFAULT;
> +
> +	if (status != EFI_SUCCESS)
> +		return -EINVAL;
> +
> +	return 0;
> +}

Here is also, it doesn't well free capsules.

[...snip]


Regards
Joey Lee
