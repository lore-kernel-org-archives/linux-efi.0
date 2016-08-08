From: ivanhu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH V2] efi: add efi_test driver for exporting UEFI runtime
 service interfaces
Date: Mon, 8 Aug 2016 13:44:21 +0800
Message-ID: <9981aae0-cd44-2d5c-9493-c8a8ea0fd90d@canonical.com>
References: <1470016096-5063-1-git-send-email-ivan.hu@canonical.com>
 <20160804110821.GM16090@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160804110821.GM16090-empE8CJ7fzk2xCFIczX1Fw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Joey,

Thanks for your comments.
"MODULE_LICENSE("GPL")" had already added below the MODULE_DESCRIPTION.
And I will check the others and send out the fix.

Cheers,
Ivan

On 2016年08月04日 19:08, joeyli wrote:
> Hi Ivan,
>
> On Mon, Aug 01, 2016 at 09:48:16AM +0800, Ivan Hu wrote:
>> This driver is used by the Firmware Test Suite (FWTS) for testing the UEFI
>> runtime interfaces readiness of the firmware.
>>
>> This driver exports UEFI runtime service interfaces into userspace,
>> which allows to use and test UEFI runtime services provided by the
>> firmware.
>>
>> This driver uses the efi.<service> function pointers directly instead of
>> going through the efivar API to allow for direct testing of the UEFI
>> runtime service interfaces provided by the firmware.
>>
>> Details for FWTS are available from,
>> <https://wiki.ubuntu.com/FirmwareTestSuite>
>>
>> Signed-off-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> ---
>>  MAINTAINERS                              |   6 +
>>  drivers/firmware/efi/Kconfig             |  15 +
>>  drivers/firmware/efi/Makefile            |   1 +
>>  drivers/firmware/efi/efi_test/Makefile   |   1 +
>>  drivers/firmware/efi/efi_test/efi_test.c | 726 +++++++++++++++++++++++++++++++
>>  drivers/firmware/efi/efi_test/efi_test.h | 110 +++++
>>  6 files changed, 859 insertions(+)
>>  create mode 100644 drivers/firmware/efi/efi_test/Makefile
>>  create mode 100644 drivers/firmware/efi/efi_test/efi_test.c
>>  create mode 100644 drivers/firmware/efi/efi_test/efi_test.h
>>
>
> [...snip]
>
>> index 0000000..18931ba
>> --- /dev/null
>> +++ b/drivers/firmware/efi/efi_test/efi_test.c
>> @@ -0,0 +1,726 @@
>> +/*
>> + * EFI Test Driver for Runtime Services
>> + *
>> + * Copyright(C) 2012-2016 Canonical Ltd.
>> + *
>> + * This driver exports EFI runtime services interfaces into userspace, which
>> + * allow to use and test UEFI runtime services provided by firmware.
>> + *
>
> I have a suggestion to declare the GPL license in file description.
>
> I am not sure that the GPL in file description is a must have, because
> the efi-pstore.c also doesn't declare GPL in file description. Maybe
> 'MODULE_LICENSE("GPL")' is enough?
>
> You can consider to add it.
>
>> + */
>> +
>> +#include <linux/version.h>
>> +#include <linux/miscdevice.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/proc_fs.h>
>> +#include <linux/efi.h>
>> +#include <linux/slab.h>
>> +#include <linux/uaccess.h>
>> +
>> +#include "efi_test.h"
>> +
>> +MODULE_AUTHOR("Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>");
>> +MODULE_DESCRIPTION("EFI Test Driver");
>> +MODULE_LICENSE("GPL");
>> +
>> +/* commit 83e681897 turned efi_enabled into a function, so abstract it */
>> +#ifdef EFI_RUNTIME_SERVICES
>> +#define EFI_RUNTIME_ENABLED	efi_enabled(EFI_RUNTIME_SERVICES)
>> +#else
>> +#define EFI_RUNTIME_ENABLED	efi_enabled
>> +#endif
>> +
>> +/*
>> + * Count the bytes in 'str', including the terminating NULL.
>> + *
>> + * Note this function returns the number of *bytes*, not the number of
>> + * ucs2 characters.
>> + */
>> +static inline size_t __ucs2_strsize(uint16_t  __user *str)
>> +{
>> +	uint16_t *s = str, c;
>> +	size_t len;
>> +
>> +	if (!str)
>> +		return 0;
>> +
>> +	/* Include terminating NULL */
>> +	len = sizeof(uint16_t);
>> +
>> +	if (get_user(c, s++)) {
>> +		WARN(1, "efi_test: Can't read userspace memory for size");
>> +		return 0;
>> +	}
>> +
>> +	while (c != 0) {
>> +		if (get_user(c, s++)) {
>> +			WARN(1, "efi_test: Can't read userspace memory for size");
>> +			return 0;
>> +		}
>> +		len += sizeof(uint16_t);
>> +	}
>> +	return len;
>> +}
>> +
>
> Looks __ucs2_strsize will return zero size when str is zero or when it can not
> read userspace memory.
>
> Then please see below...
>
>> +/*
>> + * Allocate a buffer and copy a ucs2 string from user space into it.
>> + */
>> +static inline int
>> +copy_ucs2_from_user_len(uint16_t **dst, uint16_t __user *src, size_t len)
>> +{
>> +	uint16_t *buf;
>> +
>> +	if (!src) {
>> +		*dst = NULL;
>> +		return 0;
>> +	}
>> +
>> +	if (!access_ok(VERIFY_READ, src, 1))
>> +		return -EFAULT;
>> +
>> +	buf = kmalloc(len, GFP_KERNEL);
>> +	if (!buf) {
>> +		*dst = NULL;
>> +		return -ENOMEM;
>> +	}
>> +	*dst = buf;
>> +
>> +	if (copy_from_user(*dst, src, len)) {
>> +		kfree(buf);
>> +		return -EFAULT;
>> +	}
>> +
>> +	return 0;
>> +}
>
> If the input len is zero, then kmalloc returns ZERO_SIZE_PTR, it causes
> ZERO_SIZE_PTR dereference in later copy_from_user().
>
>> +
>> +/*
>> + * Count the bytes in 'str', including the terminating NULL.
>> + *
>> + * Just a wrap for __ucs2_strsize
>> + */
>> +static inline int get_ucs2_strsize_from_user(uint16_t __user *src, size_t *len)
>> +{
>> +	if (!access_ok(VERIFY_READ, src, 1))
>> +		return -EFAULT;
>> +
>> +	*len = __ucs2_strsize(src);
>> +	if (*len == 0)
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Calculate the required buffer allocation size and copy a ucs2 string
>> + * from user space into it.
>> + *
>> + * This function differs from copy_ucs2_from_user_len() because it
>> + * calculates the size of the buffer to allocate by taking the length of
>> + * the string 'src'.
>> + *
>> + * If a non-zero value is returned, the caller MUST NOT access 'dst'.
>> + *
>> + * It is the caller's responsibility to free 'dst'.
>> + */
>> +static inline int copy_ucs2_from_user(uint16_t **dst, uint16_t __user *src)
>> +{
>> +	size_t len;
>> +
>> +	if (!access_ok(VERIFY_READ, src, 1))
>> +		return -EFAULT;
>
> The above code prevents src is zero.
>
>> +
>> +	len = __ucs2_strsize(src);
>> +	return copy_ucs2_from_user_len(dst, src, len);
>> +}
>> +
>
> The __ucs2_strsize may returns zero when it can not read userspace
> memory, why not check that len should not be zero like
> get_ucs2_strsize_from_user() does?
>
>> +/*
>> + * Copy a ucs2 string to a user buffer.
>> + *
>> + * This function is a simple wrapper around copy_to_user() that does
>> + * nothing if 'src' is NULL, which is useful for reducing the amount of
>> + * NULL checking the caller has to do.
>> + *
>> + * 'len' specifies the number of bytes to copy.
>> + */
>> +static inline int
>> +copy_ucs2_to_user_len(uint16_t __user *dst, uint16_t *src, size_t len)
>> +{
>> +	if (!src)
>> +		return 0;
>> +
>> +	if (!access_ok(VERIFY_WRITE, dst, 1))
>> +		return -EFAULT;
>> +
>> +	return copy_to_user(dst, src, len);
>> +}
>> +
>> +static long efi_runtime_get_variable(unsigned long arg)
>> +{
>> +	struct efi_getvariable __user *getvariable;
>> +	struct efi_getvariable getvariable_local;
>> +	unsigned long datasize, prev_datasize, *dz;
>> +	efi_guid_t vendor_guid, *vd = NULL;
>> +	efi_status_t status;
>> +	uint16_t *name = NULL;
>> +	uint32_t attr, *at;
>> +	void *data = NULL;
>> +	int rv = 0;
>> +
>> +	getvariable = (struct efi_getvariable __user *)arg;
>> +
>> +	if (copy_from_user(&getvariable_local, getvariable,
>> +			   sizeof(getvariable_local)))
>> +		return -EFAULT;
>> +	if (getvariable_local.data_size &&
>> +	    get_user(datasize, getvariable_local.data_size))
>> +		return -EFAULT;
>> +	if (getvariable_local.vendor_guid) {
>> +		if (copy_from_user(&vendor_guid, getvariable_local.vendor_guid,
>> +			   sizeof(vendor_guid)))
>> +			return -EFAULT;
>> +		vd = &vendor_guid;
>> +	}
>> +
>> +	if (getvariable_local.variable_name) {
>> +		rv = copy_ucs2_from_user(&name,
>> +				getvariable_local.variable_name);
>> +		if (rv)
>> +			return rv;
>> +	}
>> +
>> +	at = getvariable_local.attributes ? &attr : NULL;
>> +	dz = getvariable_local.data_size ? &datasize : NULL;
>> +
>> +	if (getvariable_local.data_size && getvariable_local.data) {
>> +		data = kmalloc(datasize, GFP_KERNEL);
>> +		if (!data) {
>> +			kfree(name);
>> +			return -ENOMEM;
>> +		}
>> +	}
>> +
>> +	prev_datasize = datasize;
>> +	status = efi.get_variable(name, vd, at, dz, data);
>> +	kfree(name);
>> +
>> +	if (data) {
>> +		if (status == EFI_SUCCESS && prev_datasize >= datasize)
>> +			rv = copy_to_user(getvariable_local.data, data,
>> +				datasize);
>> +		kfree(data);
>> +	}
>> +
>> +	if (rv)
>> +		return rv;
>> +
>> +	if (put_user(status, getvariable_local.status))
>> +		return -EFAULT;
>> +	if (status == EFI_SUCCESS && prev_datasize >= datasize) {
>> +		if (at && put_user(attr, getvariable_local.attributes))
>> +			return -EFAULT;
>> +		if (dz && put_user(datasize, getvariable_local.data_size))
>> +			return -EFAULT;
>> +		return 0;
>> +	} else if (status == EFI_BUFFER_TOO_SMALL) {
>> +		if (dz && put_user(datasize, getvariable_local.data_size))
>> +			return -EFAULT;
>> +		return -EINVAL;
>> +	} else {
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static long efi_runtime_set_variable(unsigned long arg)
>> +{
>> +	struct efi_setvariable __user *setvariable;
>> +	struct efi_setvariable setvariable_local;
>> +	efi_guid_t vendor_guid;
>> +	efi_status_t status;
>> +	uint16_t *name;
>> +	void *data;
>> +	int rv;
>> +
>> +	setvariable = (struct efi_setvariable __user *)arg;
>> +
>> +	if (copy_from_user(&setvariable_local, setvariable,
>> +			   sizeof(setvariable_local)))
>> +		return -EFAULT;
>> +	if (copy_from_user(&vendor_guid, setvariable_local.vendor_guid,
>> +			   sizeof(vendor_guid)))
>> +		return -EFAULT;
>> +
>> +	rv = copy_ucs2_from_user(&name, setvariable_local.variable_name);
>> +	if (rv)
>> +		return rv;
>
> In efi_runtime_get_variable(), it checks variable_name input. Why doesn't
> check here?
>
>
> Thanks a lot!
> Joey Lee
>
