From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v9 1/2] efi: Introduce efi_early_memdesc_ptr to get
 pointer to memmap descriptor
Date: Wed, 16 Aug 2017 12:37:26 +0100
Message-ID: <20170816113726.GA3384@codeblueprint.co.uk>
References: <1502722464-20614-1-git-send-email-bhe@redhat.com>
 <1502722464-20614-2-git-send-email-bhe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502722464-20614-2-git-send-email-bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org, fanc.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 14 Aug, at 10:54:23PM, Baoquan He wrote:
> The existing map iteration helper for_each_efi_memory_desc_in_map can
> only be used after OS initializes EFI to fill data of struct efi_memory_map.

Should this say "EFI subsystem"? The firmware doesn't care about the
kernel's internal data structures.

> Before that we also need iterate map descriptors which are stored in several
> intermediate structures, like struct efi_boot_memmap for arch independent
> usage and struct efi_info for x86 arch only.
> 
> Introduce efi_early_memdesc_ptr to get pointer to a map descriptor, and
> replace several places of open code with it.
> 
> Suggested-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c               |  2 +-
>  drivers/firmware/efi/libstub/efi-stub-helper.c |  4 ++--
>  include/linux/efi.h                            | 21 +++++++++++++++++++++
>  3 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index c3e869eaef0c..e007887a33b0 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -767,7 +767,7 @@ static efi_status_t setup_e820(struct boot_params *params,
>  		m |= (u64)efi->efi_memmap_hi << 32;
>  #endif
>  
> -		d = (efi_memory_desc_t *)(m + (i * efi->efi_memdesc_size));
> +		d = efi_early_memdesc_ptr(m, efi->efi_memdesc_size, i);
>  		switch (d->type) {
>  		case EFI_RESERVED_TYPE:
>  		case EFI_RUNTIME_SERVICES_CODE:
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index b0184360efc6..50a9cab5a834 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -205,7 +205,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
>  		unsigned long m = (unsigned long)map;
>  		u64 start, end;
>  
> -		desc = (efi_memory_desc_t *)(m + (i * desc_size));
> +		desc = efi_early_memdesc_ptr(m, desc_size, i);
>  		if (desc->type != EFI_CONVENTIONAL_MEMORY)
>  			continue;
>  
> @@ -298,7 +298,7 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>  		unsigned long m = (unsigned long)map;
>  		u64 start, end;
>  
> -		desc = (efi_memory_desc_t *)(m + (i * desc_size));
> +		desc = efi_early_memdesc_ptr(m, desc_size, i);
>  
>  		if (desc->type != EFI_CONVENTIONAL_MEMORY)
>  			continue;
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 8269bcb8ccf7..9783d9e4a4b2 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1020,6 +1020,27 @@ extern int efi_memattr_init(void);
>  extern int efi_memattr_apply_permissions(struct mm_struct *mm,
>  					 efi_memattr_perm_setter fn);
>  
> +/*
> + * efi_early_memdesc_ptr - get the n-th efi memmap descriptor
> + * @map: the start of efi memmap
> + * @desc_size: the size of space for each efi memmap descriptor
> + * @n: the index of efi memmap descriptor
> + *
> + * EFI boot service provides function GetMemoryMap() to get a copy of the
> + * current memory map which is an array of memory descriptors, each of
> + * which describes a contiguous block of memory. And also get the size of
> + * map, and the size of each descriptor, etc. Note that per section 6.2 of
> + * UEFI Spec 2.6 Errata A, the returned size of each descriptor might not
> + * be equal to sizeof(efi_memory_memdesc_t) since efi_memory_memdesc_t may
> + * be extended in the future in response to hardware innovation. Thus OS
> + * MUST use the returned size of descriptor to find the start of each
> + * efi_memory_memdesc_t in the memory map array. This should only be used
> + * during bootup since for_each_efi_memory_desc_xxx is suggested after OS
> + * initializes EFI to fill data of struct efi_memory_map.
> + */

Again, please use "EFI subsystem" here.

> +#define efi_early_memdesc_ptr(map, desc_size, n)			\
> +	(efi_memory_desc_t *)((void *)(map) + ((n) * (desc_size)))
> +
>  /* Iterate through an efi_memory_map */
>  #define for_each_efi_memory_desc_in_map(m, md)				   \
>  	for ((md) = (m)->map;						   \

Otherwise, this looks OK to me.
