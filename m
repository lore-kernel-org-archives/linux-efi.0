From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: Re: [PATCH v10 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Mon, 21 Dec 2015 17:04:11 +0000
Message-ID: <1450717451.8767.69.camel@nexus-software.ie>
References: <1450440782-5446-1-git-send-email-hock.leong.kweh@intel.com>
	 <1450440782-5446-2-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450440782-5446-2-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Anvin H Peter <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

Small nit.

On Fri, 2015-12-18 at 20:13 +0800, Kweh, Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> 
> Introducing a kernel module to expose capsule loader interface
> (misc char device file note) for user to upload capsule binaries.

This patch ? introduces a kernel module to expose a capsule loader
interface... for a user ...

> 
> Example method to load the capsule binary:

Example:

> cat firmware.bin > /dev/efi_capsule_loader
> 
> This patch also export efi_capsule_supported() function symbol for
> verifying the submitted capsule header in this kernel module.

1. Should be a separate patch 
2. Suggested, rewording for that patch log

2/2 Title
This patch exports efi_capsule_supported to enable verification of the
capsule header.

That said - who is the user of this symbol ? Why is it needed ? Anyway
please consider splitting and rewording.

> 
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> ---
>  drivers/firmware/efi/Kconfig          |   10
>  drivers/firmware/efi/Makefile         |    1
>  drivers/firmware/efi/capsule-loader.c |  355
> +++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/capsule.c        |    1
>  4 files changed, 367 insertions(+)
>  create mode 100644 drivers/firmware/efi/capsule-loader.c
> 
> diff --git a/drivers/firmware/efi/Kconfig
> b/drivers/firmware/efi/Kconfig
> index e1670d5..dc2a912 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -87,6 +87,16 @@ config EFI_RUNTIME_WRAPPERS
>  config EFI_ARMSTUB
>  	bool
>  
> +config EFI_CAPSULE_LOADER
> +	tristate "EFI capsule loader"
> +	depends on EFI
> +	help
> +	  This option exposes a loader interface
> "/dev/efi_capsule_loader" for
> +	  user to load EFI capsule binary and update the EFI
> firmware. After
> +	  a successful loading, a system reboot is required.
> +
> +	  If unsure, say N.
> +

This option exposes a loader interface... for a user to load an EFI
capsule.

A capsule isn't necessarily exclusively for updating of firmware either
AFAIK - so I suggest dropping. 

http://www.intel.com/content/www/us/en/architecture-and-technology/unif
ied-extensible-firmware-interface/efi-capsule-specification.html

Quote "Capsules were designed for and are intended to be the major
vehicle for delivering firmware volume changes. There is no requirement
that capsules be limited to that function."

>  endmenu
>  
>  config UEFI_CPER
> diff --git a/drivers/firmware/efi/Makefile
> b/drivers/firmware/efi/Makefile
> index fabf801..cf9d9d3 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -18,3 +18,4 @@ obj-$(CONFIG_EFI_RUNTIME_MAP)		+=
> runtime-map.o
>  obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
>  obj-$(CONFIG_EFI_STUB)			+= libstub/
>  obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
> +obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= capsule-loader.o
> diff --git a/drivers/firmware/efi/capsule-loader.c
> b/drivers/firmware/efi/capsule-loader.c
> new file mode 100644
> index 0000000..e1214bb
> --- /dev/null
> +++ b/drivers/firmware/efi/capsule-loader.c
> @@ -0,0 +1,355 @@
> +/*
> + * EFI capsule loader driver.
> + *
> + * Copyright 2015 Intel Corporation
> + *
> + * This file is part of the Linux kernel, and is made available
> under
> + * the terms of the GNU General Public License version 2.
> + */
> +
> +#define pr_fmt(fmt) "EFI: " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/miscdevice.h>
> +#include <linux/highmem.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/efi.h>
> +
> +#define NO_FURTHER_WRITE_ACTION -1
> +
> +struct capsule_info {
> +	bool		header_obtained;
> +	int		reset_type;
> +	long		index;
> +	size_t		count;
> +	size_t		total_size;
> +	struct page	**pages;
> +	size_t		page_bytes_remain;
> +};
> +
> +static DEFINE_MUTEX(capsule_loader_lock);
> +
> +/**
> + * efi_free_all_buff_pages - free all previous allocated buffer
> pages
> + * @cap_info: pointer to current instance of capsule_info structure
> + *
> + *	Besides freeing the buffer pages, it also flagged an
> + *	NO_FURTHER_WRITE_ACTION flag for indicating to the next
> write entries
> + *	that there is a flaw happened and any subsequence actions
> are not
> + *	valid unless close(2).
> + **/

The description needs to be reworded.

In addition to freeing buffer pages, we flag NO_FURTHER_WRITE_ACTION on
error and will cease to process data in subsequent efi_capsule_write()
calls.

(or similar)

> +static void efi_free_all_buff_pages(struct capsule_info *cap_info)
> +{
> +	while (cap_info->index > 0)
> +		__free_page(cap_info->pages[--cap_info->index]);
> +
> +	kfree(cap_info->pages);
> +
> +	cap_info->index = NO_FURTHER_WRITE_ACTION;
> +}
> +
> +/**
> + * efi_capsule_setup_info - to obtain the efi capsule header in the
> binary and
> + *			    setup capsule_info structure
> + * @cap_info: pointer to current instance of capsule_info structure
> + * @kbuff: a mapped 1st page buffer pointer

first not 1st

> + * @hdr_bytes: the total bytes of received efi header

the total number of received bytes of the EFI header

> + **/
> +static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
> +				      void *kbuff, size_t hdr_bytes)
> +{
> +	int ret;
> +	void *temp_page;
> +
> +	/* Handling 1st block is less than header size */
first or initial
I think you mean to say "Ensure first 

> +
> +		/* Check if the capsule binary supported */
> +		mutex_lock(&capsule_loader_lock);
> +		ret = efi_capsule_supported(cap_hdr->guid, cap_hdr
> ->flags,
> +					    cap_hdr->imagesize,
> +					    &cap_info->reset_type);
> +		mutex_unlock(&capsule_loader_lock);

What does this mutex really do ? You hold it here around
efi_capsule_supported() in the call

chain efi_capsule_write() => efi_capsule_setup_info()

and then again inside of efi_capsule_submit_update() the call chain 

chain efi_capsule_write() => efi_capsule_submit_update()

So if its valid to ensure you are synchronizing parallel contexts with
-respect to calls into efi_capsule_supported() and
efi_capsule_submit_update() why aren't you holding that lock for the
duration of efi_capsule_write() - couldn't cap_info->page_bytes_remain
as an example equally be racy ?


> +
> +/**
> + * efi_capsule_submit_update - invoke the efi_capsule_update API
> once binary
> + *			       upload done
> + * @cap_info: pointer to current instance of capsule_info structure
> + **/
> +static ssize_t efi_capsule_submit_update(struct capsule_info
> *cap_info)
> +{
> +	int ret;
> +	void *cap_hdr_temp;
> +
> +	cap_hdr_temp = kmap(cap_info->pages[0]);
> +	if (!cap_hdr_temp) {
> +		pr_debug("%s: kmap() failed\n", __func__);
> +		return -EFAULT;
> +	}
> +
> +	mutex_lock(&capsule_loader_lock);
> +	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
> +	mutex_unlock(&capsule_loader_lock);
> +	kunmap(cap_info->pages[0]);
> +	if (ret) {
> +		pr_err("%s: efi_capsule_update() failed\n",
> __func__);
> +		return ret;
> +	}
> +
> +	/* Indicate capsule binary uploading is done */
> +	cap_info->index = NO_FURTHER_WRITE_ACTION;

Again - if you need a mutex for efi_capsule_update() why don't you need
a mutex for cap_info->index updates looks racy...

+}
> +
> +/**
> + * efi_capsule_write - store the capsule binary and pass it to
> + *		       efi_capsule_update() API
> + * @file: file pointer
> + * @buff: buffer pointer
> + * @count: number of bytes in @buff
> + * @offp: not used
> + *
> + *	Expectation:
> + *	- User space tool should start at the beginning of capsule
> binary and
> + *	  pass data in sequential.

A user-space tool.. sequentially

> + *	- User should close and re-open this file note in order to
> upload more
> + *	  capsules.

A user should..

> + *	- Any error occurred, user should close the file and
> restart the
> + *	  operation for the next try otherwise -EIO will be
> returned until the
> + *	  file is closed.

On error -EIO will be returned and capsule loading will be abandoned.


> + *	- EFI capsule header must be located at the beginning of
> capsule binary
> + *	  file and passed in as 1st block write.

An EFI capsule header.... in as the first data in the first write
operation


> + **/
> +static ssize_t efi_capsule_write(struct file *file, const char
> __user *buff,
> +				 size_t count, loff_t *offp)
> +{
> +	int ret = 0;
> +	struct capsule_info *cap_info = file->private_data;
> +	struct page *kbuff_page = NULL;
> +	void *kbuff = NULL;
> +	size_t write_byte;
> +
> +	if (count == 0)
> +		return 0;
> +
> +	/* Return error while NO_FURTHER_WRITE_ACTION is flagged */
> +	if (cap_info->index < 0)
> +		return -EIO;
> +
> +	/* Only alloc a new page when previous page is full */
> +	if (!cap_info->page_bytes_remain) {
> +		kbuff_page = alloc_page(GFP_KERNEL);
> +		if (!kbuff_page) {
> +			pr_debug("%s: alloc_page() failed\n",
> __func__);

Shouldn't this be a pr_err() ?

> +			ret = -ENOMEM;
> +			goto failed;
> +		}
> +		cap_info->page_bytes_remain = PAGE_SIZE;
> +	} else {
> +		kbuff_page = cap_info->pages[--cap_info->index];

How are you guaranteeing this index doesn't go negative ? You compare
index < 0 above so the pre-decrement could be negative ... right ?

> +	}
> +
> +	kbuff = kmap(kbuff_page);
> +	if (!kbuff) {
> +		pr_debug("%s: kmap() failed\n", __func__);

and here ?

> +		ret = -EFAULT;
> +		goto fail_freepage;
> +	}
> +	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
> +
> +	/* Copy capsule binary data from user space to kernel space
> buffer */
> +	write_byte = min_t(size_t, count, cap_info
> ->page_bytes_remain);
> +	if (copy_from_user(kbuff, buff, write_byte)) {
> +		pr_debug("%s: copy_from_user() failed\n", __func__);

ditto

> +		ret = -EFAULT;
> +		goto fail_unmap;
> +	}
> +	cap_info->page_bytes_remain -= write_byte;
> +
> +	/* Setup capsule binary info structure */
> +	if (!cap_info->header_obtained) {
> +		ret = efi_capsule_setup_info(cap_info, kbuff,
> +					     cap_info->count +
> write_byte);
> +		if (ret)
> +			goto fail_unmap;
> +	}
> +
> +	cap_info->pages[cap_info->index++] = kbuff_page;
> +	cap_info->count += write_byte;
> +	kunmap(kbuff_page);
> +
> +	/* Submit the full binary to efi_capsule_update() API */
> +	if (cap_info->header_obtained &&
> +	    cap_info->count >= cap_info->total_size) {
> +		if (cap_info->count > cap_info->total_size) {
> +			pr_err("%s: upload size exceeded header
> defined size\n",
> +			       __func__);
> +			ret = -EINVAL;
> +			goto failed;

Shouldn't this be fail_freepage ?

> +		}
> +
> +		ret = efi_capsule_submit_update(cap_info);
> +		if (ret)
> +			goto failed;

Shouldn't this be fail_freepage ?

> +	}
> +
> +	return write_byte;
> +
> +fail_unmap:
> +	kunmap(kbuff_page);
> +fail_freepage:
> +	__free_page(kbuff_page);
> +failed:
> +	efi_free_all_buff_pages(cap_info);
> +	return ret;
> +}
> +
> +/**
> + * efi_capsule_flush - called by file close or file flush
> + * @file: file pointer
> + * @id: not used
> + *
> + *	If capsule being uploaded partially, calling this function
> will be
> + *	treated as uploading canceled and will free up those



> completed buffer
> + *	pages and then return -ECANCELED.

If a capsule is being partially updated then calling this function will
be treated as upload termination and will free completed buffer pages;
in this case -ECANCELLED will be returned.


> + **/
> +static int efi_capsule_flush(struct file *file, fl_owner_t id)
> +{
> +	int ret = 0;
> +	struct capsule_info *cap_info = file->private_data;
> +
> +	if (cap_info->index > 0) {
> +		pr_err("%s: capsule upload not complete\n",
> __func__);
> +		efi_free_all_buff_pages(cap_info);
> +		ret = -ECANCELED;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * efi_capsule_release - called by file close
> + * @inode: not used
> + * @file: file pointer
> + *
> + *	We would not free the successful submitted buffer pages
> here due to
> + *	efi update require system reboot with data maintained.
> + **/

We will not free successfully submitted pages since EFI update requires
data to be maintained across boot. 


> +static int efi_capsule_open(struct inode *inode, struct file *file)
> +{
> +	struct capsule_info *cap_info;
> +
> +	cap_info = kzalloc(sizeof(*cap_info), GFP_KERNEL);
> +	if (!cap_info)
> +		return -ENOMEM;
> +
> +	file->private_data = cap_info;
> +
> +	return 0;
> +}

You have a memory leak here don't you ?

if I do 
for (i = 0; i < N; i++) {
	fd = open(/dev/your_node);
	close(fd);
}

You'll leak that kzalloc...
