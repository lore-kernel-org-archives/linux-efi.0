From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/7] Move common EFI stub code from x86 arch code to
 common location
Date: Tue, 6 Aug 2013 14:53:27 +0100
Message-ID: <20130806135327.GY2515@console-pimps.org>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-3-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1375478948-22562-3-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 02 Aug, at 02:29:03PM, Roy Franz wrote:
> No code changes made, just moving functions from x86 arch directory
> to common location.
> Code is shared using #include, similar to how decompression code
> is shared among architectures.
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |  442 +-----------------------------
>  arch/x86/boot/compressed/eboot.h       |    6 -
>  drivers/firmware/efi/efi-stub-helper.c |  463 ++++++++++++++++++++++++++++++++
>  include/linux/efi.h                    |    8 +
>  4 files changed, 472 insertions(+), 447 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi-stub-helper.c

[...]

> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> new file mode 100644
> index 0000000..47891bd
> --- /dev/null
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -0,0 +1,463 @@
> +/*
> + * Helper functions used by the EFI stub on multiple
> + * architectures. This should be #included by the EFI stub
> + * implementation files.
> + *
> + * Copyright 2011 Intel Corporation; author Matt Fleming
> + *
> + * This file is part of the Linux kernel, and is made available
> + * under the terms of the GNU General Public License version 2.
> + *
> + */
> +
> +
> +struct initrd {
> +	efi_file_handle_t *handle;
> +	u64 size;
> +};

This should really be renamed in a later patch, like 'struct efi_file'
or similar because the dtb case has nothing to do with initrds.

> +/*
> + * Check the cmdline for a LILO-style initrd= arguments.
> + *
> + * We only support loading an initrd from the same filesystem as the
> + * kernel image.
> + */
> +static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
> +				    struct setup_header *hdr)
> +{
> +	struct initrd *initrds;

[...]

> +free_initrds:
> +	efi_call_phys1(sys_table->boottime->free_pool, initrds);
> +fail:
> +	hdr->ramdisk_image = 0;
> +	hdr->ramdisk_size = 0;
> +
> +	return status;
> +}

Likewise, this function would benefit from getting rid of the references
to initrd in a later patch.

-- 
Matt Fleming, Intel Open Source Technology Center
