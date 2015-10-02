From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v6 2/2] efi: a misc char interface for user to update efi
 firmware
Date: Fri, 2 Oct 2015 19:39:03 +0200
Message-ID: <20151002173903.GF16538@pd.tnic>
References: <1443733554-22743-1-git-send-email-hock.leong.kweh@intel.com>
 <1443733554-22743-3-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443733554-22743-3-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Fleming Matt <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Oct 02, 2015 at 05:05:54AM +0800, Kweh, Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> 
> Introducing a kernel module to expose capsule loader interface
> (misc char device file note) for user to upload capsule binaries.
> 
> Example method to load the capsule binary:
> cat firmware.bin > /dev/efi_capsule_loader
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> ---
>  drivers/firmware/efi/Kconfig              |   10 ++
>  drivers/firmware/efi/Makefile             |    1 +
>  drivers/firmware/efi/efi-capsule-loader.c |  246 +++++++++++++++++++++++++++++
>  3 files changed, 257 insertions(+)
>  create mode 100644 drivers/firmware/efi/efi-capsule-loader.c
> 
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index f712d47..0be8ee3 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -60,6 +60,16 @@ config EFI_RUNTIME_WRAPPERS
>  config EFI_ARMSTUB
>  	bool
>  
> +config EFI_CAPSULE_LOADER
> +	tristate "EFI capsule loader"
> +	depends on EFI
> +	help
> +	  This option exposes a loader interface "/dev/efi_capsule_loader" for
> +	  user to load EFI capsule binary and update the EFI firmware through
> +	  system reboot.

Do you mean here: user has to cat the fw binary *and* *then* reboot the box?

If so, we probably should issue such note to dmesg after successful
write...

> +
> +	  If unsure, say N.
> +
>  endmenu
>  
>  config UEFI_CPER
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 698846e..5ab031a 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_UEFI_CPER)			+= cper.o
>  obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
>  obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
>  obj-$(CONFIG_EFI_STUB)			+= libstub/
> +obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= efi-capsule-loader.o
> diff --git a/drivers/firmware/efi/efi-capsule-loader.c b/drivers/firmware/efi/efi-capsule-loader.c
> new file mode 100644
> index 0000000..571e0c8
> --- /dev/null
> +++ b/drivers/firmware/efi/efi-capsule-loader.c
> @@ -0,0 +1,246 @@
> +/*
> + * EFI capsule loader driver.
> + *
> + * Copyright 2015 Intel Corporation
> + *
> + * This file is part of the Linux kernel, and is made available under
> + * the terms of the GNU General Public License version 2.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/miscdevice.h>
> +#include <linux/highmem.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/efi.h>
> +
> +#define DEV_NAME "efi_capsule_loader"
> +
> +static struct capsule_info {
> +	char		header_obtained;
> +	long		index;
> +	unsigned long	count;
> +	unsigned long	total_size;
> +	struct page	**pages;
> +	unsigned long	page_count_remain;
> +} cap_info;
> +
> +static DEFINE_MUTEX(capsule_loader_lock);
> +
> +/*
> + * This function will free the current & all previous allocated buffer pages.

No need to start the comment with "This function" - that's implicitly the case.
Same for the other comments below.

> + * The input parameter is the allocated buffer page for current execution which
> + * has not yet assigned to pages array. The input param can be NULL if the
> + * current execution has not allocated any buffer page.

We have the standard format of documenting those:

 * @kbuff_page: the allocated buffer page...

> + */
> +static void efi_free_all_buff_pages(struct page *kbuff_page)
> +{
> +	if (!kbuff_page)
> +		__free_page(kbuff_page);
> +
> +	if (cap_info.index > 0)
> +		while (cap_info.index > 0)
> +			__free_page(cap_info.pages[--cap_info.index]);
> +
> +	if (cap_info.header_obtained)
> +		kfree(cap_info.pages);
> +
> +	/* indicate to the next that error had occurred */
> +	cap_info.index = -2;
> +}
> +
> +/*
> + * This function will store the capsule binary and pass it to
> + * efi_capsule_update() API in capsule.c.
> + *
> + * Expectation:
> + * - userspace tool should start at the beginning of capsule binary and pass
> + *   data in sequential.
> + * - user should close and re-open this file note in order to upload more
> + *   capsules.
> + * - any error occurred, user should close the file and restart the operation
> + *   for the next try otherwise -EIO will be returned until the file is closed.
> + */
> +static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
> +				 size_t count, loff_t *offp)
> +{
> +	int ret = 0;
> +	struct page *kbuff_page;
> +	void *kbuff;
> +	size_t write_byte;
> +
> +	pr_debug("%s: Entering Write()\n", __func__);
> +	if (count == 0)
> +		return 0;
> +
> +	/* return error while error had occurred or capsule uploading is done */
> +	if (cap_info.index < 0)
> +		return -EIO;
> +
> +	/* only alloc a new page when the current page is full */
> +	if (!cap_info.page_count_remain) {
> +		kbuff_page = alloc_page(GFP_KERNEL);
> +		if (!kbuff_page) {
> +			pr_debug("%s: alloc_page() failed\n", __func__);
> +			efi_free_all_buff_pages(NULL);
> +			return -ENOMEM;
> +		}
> +		cap_info.page_count_remain = PAGE_SIZE;
> +	} else {
> +		kbuff_page = cap_info.pages[--cap_info.index];
> +	}
> +	kbuff = kmap(kbuff_page);
> +	if (!kbuff) {
> +		pr_debug("%s: kmap() failed\n", __func__);
> +		efi_free_all_buff_pages(kbuff_page);
> +		return -EFAULT;
> +	}
> +	kbuff += PAGE_SIZE - cap_info.page_count_remain;
> +
> +	/* copy capsule binary data from user space to kernel space buffer */
> +	write_byte = min_t(size_t, count, cap_info.page_count_remain);
> +	if (copy_from_user(kbuff, buff, write_byte)) {
> +		pr_debug("%s: copy_from_user() failed\n", __func__);
> +		kunmap(kbuff_page);
> +		efi_free_all_buff_pages(kbuff_page);
> +		return -EFAULT;
> +	}
> +	cap_info.page_count_remain -= write_byte;
> +
> +	/* setup capsule binary info structure */
> +	if (cap_info.header_obtained == 0 && cap_info.index == 0) {
> +		efi_capsule_header_t *cap_hdr = kbuff;
> +		int reset_type;
> +		size_t pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >>
> +					PAGE_SHIFT;
> +
> +		if (pages_needed == 0) {
> +			pr_err("%s: pages count invalid\n", __func__);
> +			kunmap(kbuff_page);
> +			efi_free_all_buff_pages(kbuff_page);
> +			return -EINVAL;
> +		}
> +
> +		/* check if the capsule binary supported */
> +		ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
> +					    cap_hdr->imagesize, &reset_type);
> +		if (ret) {
> +			pr_err("%s: efi_capsule_supported() failed\n",
> +			       __func__);
> +			kunmap(kbuff_page);
> +			efi_free_all_buff_pages(kbuff_page);
> +			return ret;
> +		}
> +
> +		cap_info.total_size = cap_hdr->imagesize;
> +		cap_info.pages = kmalloc_array(pages_needed, sizeof(void *),
> +						GFP_KERNEL);
> +		if (!cap_info.pages) {
> +			pr_debug("%s: kmalloc_array() failed\n", __func__);
> +			kunmap(kbuff_page);
> +			efi_free_all_buff_pages(kbuff_page);
> +			return -ENOMEM;
> +		}
> +
> +		cap_info.header_obtained = 1;
> +	}
> +
> +	cap_info.pages[cap_info.index++] = kbuff_page;
> +	cap_info.count += write_byte;
> +	kunmap(kbuff_page);
> +
> +	/* submit the full binary to efi_capsule_update() API */
> +	if (cap_info.count >= cap_info.total_size) {
> +		void *cap_hdr_temp;
> +
> +		cap_hdr_temp = kmap(cap_info.pages[0]);
> +		if (!cap_hdr_temp) {
> +			pr_debug("%s: kmap() failed\n", __func__);
> +			efi_free_all_buff_pages(NULL);
> +			return -EFAULT;
> +		}
> +		ret = efi_capsule_update(cap_hdr_temp, cap_info.pages);
> +		kunmap(cap_info.pages[0]);
> +		if (ret) {
> +			pr_err("%s: efi_capsule_update() failed\n", __func__);
> +			efi_free_all_buff_pages(NULL);
> +			return ret;
> +		}
> +		/* indicate capsule binary uploading is done */
> +		cap_info.index = -1;
> +	}
> +
> +	return write_byte;
> +}

This function is huuuge and it could use some splitting. At least the
code blocks under

	/* setup capsule binary info structure */

and

	/* submit the full binary to efi_capsule_update() API */

could be separate, helper functions.

And you have the same repeated pattern on the error path:

	kunmap();
	efi_free_all_buff_pages(NULL);
	return -<errno>

Mind rewriting that with goto err_... labels like it is normally done in
the kernel.

> +
> +static int efi_capsule_release(struct inode *inode, struct file *file)
> +{
> +	int ret = 0;
> +
> +	pr_debug("%s: Exit in Release()\n", __func__);
> +	/* release uncompleted capsule upload */

That should be above the function.

> +	if (cap_info.index > 0) {
> +		pr_err("%s: capsule upload not complete\n", __func__);
> +		efi_free_all_buff_pages(NULL);
> +		ret = -ECANCELED;
> +	}
> +	mutex_unlock(&capsule_loader_lock);
> +
> +	/*
> +	 * we would not free the successful submitted buffer pages here due to
> +	 * efi update require system reboot with data maintained.
> +	 */

That too.

> +	return ret;
> +}
> +
> +static int efi_capsule_open(struct inode *inode, struct file *file)
> +{
> +	pr_debug("%s: Entering Open()\n", __func__);

Do we really need those?

> +	if (!mutex_trylock(&capsule_loader_lock))
> +		return -EBUSY;
> +
> +	memset(&cap_info, 0, sizeof(cap_info));
> +	return 0;
> +}
> +
> +static const struct file_operations efi_capsule_fops = {
> +	.owner = THIS_MODULE,
> +	.open = efi_capsule_open,
> +	.write = efi_capsule_write,
> +	.release = efi_capsule_release,
> +	.llseek = no_llseek,
> +};
> +
> +static struct miscdevice efi_capsule_misc = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = DEV_NAME,
> +	.fops = &efi_capsule_fops,
> +};
> +
> +static int __init efi_capsule_loader_init(void)
> +{
> +	int ret;
> +
> +	mutex_init(&capsule_loader_lock);
> +
> +	ret = misc_register(&efi_capsule_misc);
> +	if (ret)
> +		pr_err("%s: Failed to register misc char file note\n",
> +		       __func__);

mutex_destroy() on the error path.

> +
> +	return ret;
> +}
> +module_init(efi_capsule_loader_init);
> +
> +static void __exit efi_capsule_loader_exit(void)
> +{
> +	mutex_destroy(&capsule_loader_lock);
> +	misc_deregister(&efi_capsule_misc);

Those are in the wrong order - you need to destroy the mutex last.

> +}
> +module_exit(efi_capsule_loader_exit);
> +
> +MODULE_DESCRIPTION("EFI capsule firmware binary loader");
> +MODULE_LICENSE("GPL v2");
> -- 
> 1.7.9.5
> 
> 

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
