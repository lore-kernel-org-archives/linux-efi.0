From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v5 2/2] efi: a misc char interface for user to update efi
 firmware
Date: Thu, 27 Aug 2015 15:43:17 +0100
Message-ID: <20150827144317.GA3596@codeblueprint.co.uk>
References: <1440156888-25796-1-git-send-email-hock.leong.kweh@intel.com>
 <1440156888-25796-3-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1440156888-25796-3-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 21 Aug, at 07:34:48PM, Kweh Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> 
> Introducing a kernel module to expose capsule loader interface
> (misc char device file note) for user to upload capsule binaries.
> 
> Example method to load the capsule binary:
> cat firmware.bin > /dev/efi_capsule_loader
 
OK interesting, we're going down the misc char device route - Andy
might be happier, even if there is no ioctl(2) support.

> Cc: Matt Fleming <matt.fleming@intel.com>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> ---
>  drivers/firmware/efi/Kconfig              |   10 ++
>  drivers/firmware/efi/Makefile             |    1 +
>  drivers/firmware/efi/efi-capsule-loader.c |  218 +++++++++++++++++++++++++++++
>  3 files changed, 229 insertions(+)
>  create mode 100644 drivers/firmware/efi/efi-capsule-loader.c

[...]

> diff --git a/drivers/firmware/efi/efi-capsule-loader.c b/drivers/firmware/efi/efi-capsule-loader.c
> new file mode 100644
> index 0000000..1da8608
> --- /dev/null
> +++ b/drivers/firmware/efi/efi-capsule-loader.c
> @@ -0,0 +1,218 @@
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
> +struct capsule_info {
> +	int		curr_index;
> +	int		curr_size;
> +	int		total_size;

It's totally conceivable that a capsule might be greater than 2GB in
size. In which case, 'int' is the wrong data type for these size
fields. Perhaps 'unsigned long' ?

I'd suggest swapping 'curr_index' for simply 'index' and 'curr_size'
for 'count' or 'bytes'.

> +	struct page	**pages;
> +};
> +
> +static DEFINE_MUTEX(capsule_loader_lock);
> +
> +/*
> + * This function will store the capsule binary and pass it to
> + * efi_capsule_update() API in capsule.c
> + */
> +static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
> +				 size_t count, loff_t *offp)
> +{
> +	int ret = 0;
> +	struct capsule_info *cap_info = file->private_data;
> +	struct page *kbuff_page;
> +	void *kbuff;
> +
> +	pr_debug("%s: Entering Write()\n", __func__);
> +	if (count == 0)
> +		return 0;
> +
> +	if (cap_info->curr_index == -1)
> +		return count;

Shouldn't we be returning an error here to signal that the driver
wasn't expecting any more data to be sent? Otherwise the caller will
think everything worked out fine, but it didn't. See my comments below
about the success/failure design.

> +
> +	kbuff_page = alloc_page(GFP_KERNEL);
> +	if (!kbuff_page) {
> +		pr_err("%s: alloc_page() failed\n", __func__);
> +		if (!cap_info->curr_index)
> +			return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto failed;
> +	}

If the caller writes less than PAGE_SIZE bytes at a time this could be
incredibly wasteful. We should use the remaining space from any
previous page allocations.

> +
> +	kbuff = kmap(kbuff_page);
> +	if (!kbuff) {
> +		pr_err("%s: kmap() failed\n", __func__);
> +		if (cap_info->curr_index)
> +			cap_info->pages[cap_info->curr_index++] = kbuff_page;
> +		ret = -EFAULT;
> +		goto failed;
> +	}
> +
> +	/* copy capsule binary data from user space to kernel space buffer */
> +	if (copy_from_user(kbuff, buff, min_t(size_t, count, PAGE_SIZE))) {
> +		pr_err("%s: copy_from_user() failed\n", __func__);
> +		if (cap_info->curr_index)
> +			cap_info->pages[cap_info->curr_index++] = kbuff_page;

Huh? Is this to satisfy the requirements of the code at the 'failed'
label? The error handling could do with some cleanup because it's very
difficult to follow the code flow.

Please try and get rid of the housekeeping code where you add
kbuff_page to the pages array just to make the 'failed' code work.

I'd also ditch the pr_err() calls for all but the most fatal of error
conditions because they make the code harder to read.

> +		kunmap(kbuff_page);
> +		ret = -EFAULT;
> +		goto failed;
> +	}
> +
> +	/* setup capsule binary info structure */
> +	if (cap_info->curr_index == 0) {
> +		efi_capsule_header_t *cap_hdr = kbuff;
> +		int reset_type;
> +		int pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >>
> +					PAGE_SHIFT;
> +
> +		if (pages_needed <= 0) {

Can ALIGN() even return a genuine negative value? 'pages_needed'
should be 'size_t'.

> +			pr_err("%s: pages count invalid\n", __func__);
> +			ret = -EINVAL;
> +			kunmap(kbuff_page);
> +			goto failed;
> +		}
> +
> +		/* check if the capsule binary supported */
> +		ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
> +					    cap_hdr->imagesize, &reset_type);
> +		if (ret) {
> +			pr_err("%s: efi_capsule_supported() failed\n",
> +			       __func__);
> +			kunmap(kbuff_page);
> +			goto failed;
> +		}
> +
> +		cap_info->total_size = cap_hdr->imagesize;
> +		cap_info->pages = kmalloc_array(pages_needed, sizeof(void *),
> +						GFP_KERNEL);
> +		if (!cap_info->pages) {
> +			pr_err("%s: kmalloc_array() failed\n", __func__);
> +			ret = -ENOMEM;
> +			kunmap(kbuff_page);
> +			goto failed;
> +		}
> +	}
> +
> +	cap_info->pages[cap_info->curr_index++] = kbuff_page;
> +	cap_info->curr_size += count;
> +	kunmap(kbuff_page);
> +
> +	/* submit the full binary to efi_capsule_update() API */
> +	if (cap_info->curr_size >= cap_info->total_size) {
> +		ret = efi_capsule_update(kmap(cap_info->pages[0]),
> +					 cap_info->pages);

But kmap() can fail, so you need to handle that.

> +		kunmap(cap_info->pages[0]);
> +		if (ret) {
> +			pr_err("%s: efi_capsule_update() failed\n", __func__);
> +			goto failed;
> +		}
> +		/* indicate capsule binary uploading is done */
> +		cap_info->curr_index = -1;
> +	}
> +
> +	/*
> +	 * we cannot free the pages here due to reboot need that data
> +	 * maintained.
> +	 */
> +	return count;
> +
> +failed:
> +	if (!cap_info->curr_index) {
> +		__free_page(kbuff_page);
> +	} else {
> +		while (cap_info->curr_index > 0)
> +			__free_page(cap_info->pages[--cap_info->curr_index]);
> +		kfree(cap_info->pages);
> +	}
> +
> +	return ret;

Let's explicitly discuss the failure mode. If we fail in this function
we need to decide what happens if the userspace tool continues writing
data instead of closing the file.

It looks like we expect the userspace tool to start at the beginning
of the capsule data again, but you explicitly prohibit calling
lseek(2) by using the 'no_llseek' file_operations function. That makes
it difficult to verify that the app is starting at the beginning of
the file (I also notice that 'ppos' isn't being updated).

In the success case we expect the user to close/open this file to
write more capsules.

Personally, I think these two approaches are backwards. You should be
able to continue writing capsule data as long as write(2) returns
success, but should have to close/re-open the device file as soon as
an error is encountered. If you don't close/re-open on failure I'd
expect write(2) to return -EIO or somesuch error until you do.

It's worth explicitly documenting these two scenarios in the code.

> +}
> +
> +static int efi_capsule_release(struct inode *inode, struct file *file)
> +{
> +	int ret = 0;
> +	struct capsule_info *cap_info = file->private_data;
> +
> +	pr_debug("%s: Exit in Release()\n", __func__);
> +	/* release those uncompleted uploaded block */
> +	if (cap_info->curr_index > 0) {
> +		pr_err("%s: capsule upload not complete\n", __func__);
> +		while (cap_info->curr_index > 0)
> +			__free_page(cap_info->pages[--cap_info->curr_index]);
> +		kfree(cap_info->pages);
> +		ret = -ECANCELED;

Interestingly the return value from ->release() isn't propagated to
userspace, look at __fput(). This is because the actual put'ing of the
file is delayed.

Notice how James used ->flush() in his patch series, which *does*
propagate the return value and most importantly, does so at close(2)
time (and also if the task exits for any reason, like being killed by
a fatal signal).

> +	}
> +	kfree(file->private_data);
> +	file->private_data = NULL;
> +	mutex_unlock(&capsule_loader_lock);
> +	return ret;
> +}
> +
> +static int efi_capsule_open(struct inode *inode, struct file *file)
> +{
> +	int ret = -EBUSY;
> +	struct capsule_info *cap_info;
> +
> +	pr_debug("%s: Entering Open()\n", __func__);
> +	if (mutex_trylock(&capsule_loader_lock)) {
> +		cap_info = kzalloc(sizeof(*cap_info), GFP_KERNEL);
> +		file->private_data = cap_info;
> +		ret = 0;
> +	}
> +	return ret;
> +}

I think this would be more readable like this,

	if (mutex_trylock(&capsule_loader_lock))
		return -EBUSY;

	cap_info = kzalloc(sizeof(*cap_info), GFP_KERNEL);
	file->private_data = cap_info;

	return 0;

Also, if we only allow one open at a time, why not make 'cap_info'
statically allocated so that you don't need to handle the kzalloc()
failure in this function?

-- 
Matt Fleming, Intel Open Source Technology Center
