From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v6 2/2] efi: a misc char interface for user to update efi firmware
Date: Sat, 3 Oct 2015 16:16:08 -0700
Message-ID: <CALCETrUxgw_MYVHQQvu+0ZnLE8BvZN-LgW5+H4jKqZgVQoH-=g@mail.gmail.com>
References: <1443733554-22743-1-git-send-email-hock.leong.kweh@intel.com> <1443733554-22743-3-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1443733554-22743-3-git-send-email-hock.leong.kweh@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Fleming Matt <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 1, 2015 at 2:05 PM, Kweh, Hock Leong
<hock.leong.kweh@intel.com> wrote:
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
>         bool
>
> +config EFI_CAPSULE_LOADER
> +       tristate "EFI capsule loader"
> +       depends on EFI
> +       help
> +         This option exposes a loader interface "/dev/efi_capsule_loader" for
> +         user to load EFI capsule binary and update the EFI firmware through
> +         system reboot.
> +
> +         If unsure, say N.
> +
>  endmenu
>
>  config UEFI_CPER
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 698846e..5ab031a 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_UEFI_CPER)                 += cper.o
>  obj-$(CONFIG_EFI_RUNTIME_MAP)          += runtime-map.o
>  obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)     += runtime-wrappers.o
>  obj-$(CONFIG_EFI_STUB)                 += libstub/
> +obj-$(CONFIG_EFI_CAPSULE_LOADER)       += efi-capsule-loader.o
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
> +       char            header_obtained;
> +       long            index;
> +       unsigned long   count;
> +       unsigned long   total_size;
> +       struct page     **pages;
> +       unsigned long   page_count_remain;
> +} cap_info;
> +

Why is this static?

> +static DEFINE_MUTEX(capsule_loader_lock);
> +
> +/*
> + * This function will free the current & all previous allocated buffer pages.
> + * The input parameter is the allocated buffer page for current execution which
> + * has not yet assigned to pages array. The input param can be NULL if the
> + * current execution has not allocated any buffer page.
> + */
> +static void efi_free_all_buff_pages(struct page *kbuff_page)
> +{
> +       if (!kbuff_page)
> +               __free_page(kbuff_page);
> +
> +       if (cap_info.index > 0)
> +               while (cap_info.index > 0)
> +                       __free_page(cap_info.pages[--cap_info.index]);
> +
> +       if (cap_info.header_obtained)
> +               kfree(cap_info.pages);
> +
> +       /* indicate to the next that error had occurred */
> +       cap_info.index = -2;

This -2 to too magical.

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
> +                                size_t count, loff_t *offp)
> +{
> +       int ret = 0;
> +       struct page *kbuff_page;
> +       void *kbuff;
> +       size_t write_byte;
> +
> +       pr_debug("%s: Entering Write()\n", __func__);

Unnecessary.

> +       if (count == 0)
> +               return 0;
> +
> +       /* return error while error had occurred or capsule uploading is done */
> +       if (cap_info.index < 0)
> +               return -EIO;
> +
> +       /* only alloc a new page when the current page is full */
> +       if (!cap_info.page_count_remain) {
> +               kbuff_page = alloc_page(GFP_KERNEL);
> +               if (!kbuff_page) {
> +                       pr_debug("%s: alloc_page() failed\n", __func__);
> +                       efi_free_all_buff_pages(NULL);
> +                       return -ENOMEM;
> +               }
> +               cap_info.page_count_remain = PAGE_SIZE;
> +       } else {
> +               kbuff_page = cap_info.pages[--cap_info.index];
> +       }
> +       kbuff = kmap(kbuff_page);
> +       if (!kbuff) {
> +               pr_debug("%s: kmap() failed\n", __func__);
> +               efi_free_all_buff_pages(kbuff_page);
> +               return -EFAULT;
> +       }
> +       kbuff += PAGE_SIZE - cap_info.page_count_remain;
> +
> +       /* copy capsule binary data from user space to kernel space buffer */
> +       write_byte = min_t(size_t, count, cap_info.page_count_remain);
> +       if (copy_from_user(kbuff, buff, write_byte)) {
> +               pr_debug("%s: copy_from_user() failed\n", __func__);
> +               kunmap(kbuff_page);
> +               efi_free_all_buff_pages(kbuff_page);
> +               return -EFAULT;
> +       }
> +       cap_info.page_count_remain -= write_byte;
> +
> +       /* setup capsule binary info structure */
> +       if (cap_info.header_obtained == 0 && cap_info.index == 0) {
> +               efi_capsule_header_t *cap_hdr = kbuff;
> +               int reset_type;
> +               size_t pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >>
> +                                       PAGE_SHIFT;
> +
> +               if (pages_needed == 0) {
> +                       pr_err("%s: pages count invalid\n", __func__);
> +                       kunmap(kbuff_page);
> +                       efi_free_all_buff_pages(kbuff_page);
> +                       return -EINVAL;
> +               }
> +
> +               /* check if the capsule binary supported */
> +               ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
> +                                           cap_hdr->imagesize, &reset_type);

And what if cap_hdr isn't written yet?

> +               if (ret) {
> +                       pr_err("%s: efi_capsule_supported() failed\n",
> +                              __func__);
> +                       kunmap(kbuff_page);
> +                       efi_free_all_buff_pages(kbuff_page);
> +                       return ret;
> +               }
> +
> +               cap_info.total_size = cap_hdr->imagesize;
> +               cap_info.pages = kmalloc_array(pages_needed, sizeof(void *),
> +                                               GFP_KERNEL);
> +               if (!cap_info.pages) {
> +                       pr_debug("%s: kmalloc_array() failed\n", __func__);
> +                       kunmap(kbuff_page);
> +                       efi_free_all_buff_pages(kbuff_page);
> +                       return -ENOMEM;
> +               }
> +
> +               cap_info.header_obtained = 1;

I don't see how you know that the header is obtained.

> +       }
> +
> +       cap_info.pages[cap_info.index++] = kbuff_page;

Huh?  You might now have allocated a whole page.

> +       cap_info.count += write_byte;
> +       kunmap(kbuff_page);
> +
> +       /* submit the full binary to efi_capsule_update() API */
> +       if (cap_info.count >= cap_info.total_size) {
> +               void *cap_hdr_temp;
> +
> +               cap_hdr_temp = kmap(cap_info.pages[0]);
> +               if (!cap_hdr_temp) {
> +                       pr_debug("%s: kmap() failed\n", __func__);
> +                       efi_free_all_buff_pages(NULL);
> +                       return -EFAULT;
> +               }
> +               ret = efi_capsule_update(cap_hdr_temp, cap_info.pages);
> +               kunmap(cap_info.pages[0]);
> +               if (ret) {
> +                       pr_err("%s: efi_capsule_update() failed\n", __func__);
> +                       efi_free_all_buff_pages(NULL);
> +                       return ret;
> +               }
> +               /* indicate capsule binary uploading is done */
> +               cap_info.index = -1;

Should count > cap_info.total_size be an error?

--Andy

> +static int efi_capsule_release(struct inode *inode, struct file *file)
> +{
> +       int ret = 0;
> +
> +       pr_debug("%s: Exit in Release()\n", __func__);
> +       /* release uncompleted capsule upload */
> +       if (cap_info.index > 0) {
> +               pr_err("%s: capsule upload not complete\n", __func__);
> +               efi_free_all_buff_pages(NULL);
> +               ret = -ECANCELED;
> +       }
> +       mutex_unlock(&capsule_loader_lock);

Holding mutexes in userspace seems like an error.  In fact, doesn't
lockdep warn when you do that?

--Andy
