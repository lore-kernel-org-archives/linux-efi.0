From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v10 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Thu, 21 Jan 2016 11:51:51 +0000
Message-ID: <20160121115151.GB2510@codeblueprint.co.uk>
References: <1450440782-5446-1-git-send-email-hock.leong.kweh@intel.com>
 <1450440782-5446-2-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1450440782-5446-2-git-send-email-hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anvin H Peter <h.peter.anvin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 18 Dec, at 08:13:01PM, Kweh Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Introducing a kernel module to expose capsule loader interface
> (misc char device file note) for user to upload capsule binaries.
> 
> Example method to load the capsule binary:
> cat firmware.bin > /dev/efi_capsule_loader
> 
> This patch also export efi_capsule_supported() function symbol for
> verifying the submitted capsule header in this kernel module.
> 
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/Kconfig          |   10
>  drivers/firmware/efi/Makefile         |    1
>  drivers/firmware/efi/capsule-loader.c |  355 +++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/capsule.c        |    1
>  4 files changed, 367 insertions(+)
>  create mode 100644 drivers/firmware/efi/capsule-loader.c

[...]

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

This mutex is not needed. It doesn't protect anything in your code.

> +/**
> + * efi_free_all_buff_pages - free all previous allocated buffer pages
> + * @cap_info: pointer to current instance of capsule_info structure
> + *
> + *	Besides freeing the buffer pages, it also flagged an
> + *	NO_FURTHER_WRITE_ACTION flag for indicating to the next write entries
> + *	that there is a flaw happened and any subsequence actions are not
> + *	valid unless close(2).
> + **/
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
> + * efi_capsule_setup_info - to obtain the efi capsule header in the binary and
> + *			    setup capsule_info structure
> + * @cap_info: pointer to current instance of capsule_info structure
> + * @kbuff: a mapped 1st page buffer pointer
> + * @hdr_bytes: the total bytes of received efi header
> + **/
> +static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
> +				      void *kbuff, size_t hdr_bytes)
> +{
> +	int ret;
> +	void *temp_page;
> +
> +	/* Handling 1st block is less than header size */
> +	if (hdr_bytes < sizeof(efi_capsule_header_t)) {
> +		if (!cap_info->pages) {
> +			cap_info->pages = kzalloc(sizeof(void *), GFP_KERNEL);
> +			if (!cap_info->pages) {
> +				pr_debug("%s: kzalloc() failed\n", __func__);
> +				return -ENOMEM;
> +			}
> +		}

This function would be much more simple if you handled the above
condition differently.

Instead of having code in efi_capsule_setup_info() to allocate the
initial ->pages memory, why not just allocate it in efi_capsule_open()
at the same time as you allocate the private_data? You can then
free it in efi_capsule_release() (you're leaking it at the moment).

You are always going to need at least one element in ->pages for
successful operation, so you might as well allocate it up front.

> +	} else {
> +		/* Reset back to the correct offset of header */
> +		efi_capsule_header_t *cap_hdr = kbuff - cap_info->count;
> +		size_t pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >>
> +					    PAGE_SHIFT;
> +
> +		if (pages_needed == 0) {
> +			pr_err("%s: pages count invalid\n", __func__);
> +			return -EINVAL;
> +		}
> +
> +		/* Check if the capsule binary supported */
> +		mutex_lock(&capsule_loader_lock);
> +		ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
> +					    cap_hdr->imagesize,
> +					    &cap_info->reset_type);
> +		mutex_unlock(&capsule_loader_lock);
> +		if (ret) {
> +			pr_err("%s: efi_capsule_supported() failed\n",
> +			       __func__);
> +			return ret;
> +		}
> +
> +		cap_info->total_size = cap_hdr->imagesize;
> +		temp_page = krealloc(cap_info->pages,
> +				     pages_needed * sizeof(void *),
> +				     GFP_KERNEL | __GFP_ZERO);
> +		if (!temp_page) {
> +			pr_debug("%s: krealloc() failed\n", __func__);
> +			return -ENOMEM;
> +		}
> +
> +		cap_info->pages = temp_page;
> +		cap_info->header_obtained = 1;

This should be 'true', not 1.

> +	}
> +
> +	return 0;
> +}
>
> +
> +/**
> + * efi_capsule_submit_update - invoke the efi_capsule_update API once binary
> + *			       upload done
> + * @cap_info: pointer to current instance of capsule_info structure
> + **/
> +static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
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
> +		pr_err("%s: efi_capsule_update() failed\n", __func__);
> +		return ret;
> +	}
> +
> +	/* Indicate capsule binary uploading is done */
> +	cap_info->index = NO_FURTHER_WRITE_ACTION;
> +	pr_info("%s: Successfully upload capsule file with reboot type '%s'\n",
> +		__func__, !cap_info->reset_type ? "RESET_COLD" :
> +		cap_info->reset_type == 1 ? "RESET_WARM" :
> +		"RESET_SHUTDOWN");
> +	return 0;
> +}
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
> + *	- User space tool should start at the beginning of capsule binary and
> + *	  pass data in sequential.
> + *	- User should close and re-open this file note in order to upload more
> + *	  capsules.
> + *	- Any error occurred, user should close the file and restart the
> + *	  operation for the next try otherwise -EIO will be returned until the
> + *	  file is closed.
> + *	- EFI capsule header must be located at the beginning of capsule binary
> + *	  file and passed in as 1st block write.
> + **/
> +static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
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
> +			pr_debug("%s: alloc_page() failed\n", __func__);
> +			ret = -ENOMEM;
> +			goto failed;
> +		}
> +		cap_info->page_bytes_remain = PAGE_SIZE;
> +	} else {
> +		kbuff_page = cap_info->pages[--cap_info->index];
> +	}

This shuffling and unshuffling of cap_info->index seems kinda crazy to
me because you're treating the current page differently from the rest,
which complicates the error paths too (you shouldn't need
__free_page() *and* efi_free_all_buff_pages()).

Why not make cap_info->index always index the last page? That way you
could do,

	if (!cap_info->page_bytes_remain) {
		cap_info->pages[++cap_info->index] = alloc_page()
		cap_info->page_bytes_remain = PAGE_SIZE;
	}

	kbuff_page = cap_info->pages[cap_info->index];

?

> +
> +	kbuff = kmap(kbuff_page);
> +	if (!kbuff) {
> +		pr_debug("%s: kmap() failed\n", __func__);
> +		ret = -EFAULT;
> +		goto fail_freepage;
> +	}
> +	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
> +
> +	/* Copy capsule binary data from user space to kernel space buffer */
> +	write_byte = min_t(size_t, count, cap_info->page_bytes_remain);
> +	if (copy_from_user(kbuff, buff, write_byte)) {
> +		pr_debug("%s: copy_from_user() failed\n", __func__);
> +		ret = -EFAULT;
> +		goto fail_unmap;
> +	}
> +	cap_info->page_bytes_remain -= write_byte;
> +
> +	/* Setup capsule binary info structure */
> +	if (!cap_info->header_obtained) {
> +		ret = efi_capsule_setup_info(cap_info, kbuff,
> +					     cap_info->count + write_byte);
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
> +			pr_err("%s: upload size exceeded header defined size\n",
> +			       __func__);
> +			ret = -EINVAL;
> +			goto failed;
> +		}
> +
> +		ret = efi_capsule_submit_update(cap_info);
> +		if (ret)
> +			goto failed;
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
> + *	If capsule being uploaded partially, calling this function will be
> + *	treated as uploading canceled and will free up those completed buffer
> + *	pages and then return -ECANCELED.
> + **/
> +static int efi_capsule_flush(struct file *file, fl_owner_t id)
> +{
> +	int ret = 0;
> +	struct capsule_info *cap_info = file->private_data;
> +
> +	if (cap_info->index > 0) {
> +		pr_err("%s: capsule upload not complete\n", __func__);
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
> + *	We would not free the successful submitted buffer pages here due to
> + *	efi update require system reboot with data maintained.
> + **/
> +static int efi_capsule_release(struct inode *inode, struct file *file)
> +{
> +	kfree(file->private_data);
> +	file->private_data = NULL;
> +	return 0;
> +}
> +
> +/**
> + * efi_capsule_open - called by file open
> + * @inode: not used
> + * @file: file pointer
> + *
> + *	Will allocate each capsule_info memory for each file open call.
> + *	This provided the capability to support multiple file open feature
> + *	where user is not needed to wait for others to finish in order to
> + *	upload their capsule binary.
> + **/
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

Please allocate one ->pages element here (void *). You need at least
one for this code to work and you can easily free it in
efi_capsule_release() if it still exists. It would also simplfy
efi_capsule_setup_info() immensely.
