From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 08/17] Generalize relocate_kernel() for use by other
 architectures.
Date: Wed, 18 Sep 2013 13:12:40 +0100
Message-ID: <20130918121240.GJ3409@console-pimps.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
 <1379391093-27948-9-git-send-email-roy.franz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1379391093-27948-9-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 16 Sep, at 09:11:24PM, Roy Franz wrote:
> Rename relocate_kernel() to efi_relocate_kernel(), and take
> parameters rather than x86 specific structure.  Add max_addr
> argument as for ARM we have some address constraints that we
> need to enforce when relocating the kernel.  Add alloc_size
> parameter for use by ARM64 which uses an uncompressed kernel,
> and needs to allocate space for BSS.
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c       |   12 ++++--
>  drivers/firmware/efi/efi-stub-helper.c |   74 ++++++++++++++++++++++----------
>  2 files changed, 60 insertions(+), 26 deletions(-)
 
This commit breaks my ASUS machine.

> -	/*
> -	 * The EFI firmware loader could have placed the kernel image
> -	 * anywhere in memory, but the kernel has various restrictions
> -	 * on the max physical address it can run at. Attempt to move
> -	 * the kernel to boot_params.pref_address, or as low as
> -	 * possible.
> -	 */

[...]

> +
> +	/* The EFI firmware loader could have placed the kernel image
> +	 * anywhere in memory, but the kernel has restrictions on the
> +	 * anywhere in memory, but the kernel has restrictions on the
> +	 * max physical address it can run at.  Some architectures
> +	 * also have a prefered address, so first try to relocate
> +	 * to the preferred address.
> +	 */

Please don't change the comment style of code in the future.

> +	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
> +	status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
>  				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
> -				nr_pages, &start);
> +				nr_pages, &efi_addr);
> +	new_addr = efi_addr;
> +	/* If preferred address allocation failed allocate as low as
> +	 * possible. */
>  	if (status != EFI_SUCCESS) {
> -		status = efi_low_alloc(sys_table, hdr->init_size,
> -				   hdr->kernel_alignment, &start);
> -		if (status != EFI_SUCCESS)
> -			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
> +		status = efi_low_alloc(sys_table_arg, alloc_size, 0,
> +				       &new_addr);

This is wrong. You've dropped the hdr->kernel_alignment argument, and
the relaxed alignment of this allocation stops my machine from booting.

-- 
Matt Fleming, Intel Open Source Technology Center
