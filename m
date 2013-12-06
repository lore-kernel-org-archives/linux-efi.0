From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 2/3] arm: Add [U]EFI runtime services support
Date: Fri, 6 Dec 2013 02:59:48 +0100
Message-ID: <201312060259.48259.arnd@arndb.de>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org> <1385656883-4420-3-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1385656883-4420-3-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linaro-uefi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thursday 28 November 2013, Leif Lindholm wrote:
> @@ -898,6 +900,10 @@ void __init setup_arch(char **cmdline_p)
>  	sanity_check_meminfo();
>  	arm_memblock_init(&meminfo, mdesc);
>  
> +#ifdef CONFIG_EFI
> +	uefi_memblock_arm_reserve_range();
> +#endif
> +

Better use 

	if (IS_ENABLED(CONFIG_EFI))

here for readability and better build-time checking of the interface when
CONFIG_EFI is disabled.

> +/*
> + * Returns 1 if 'facility' is enabled, 0 otherwise.
> + */
> +int efi_enabled(int facility)
> +{
> +	return test_bit(facility, &arm_uefi_facility) != 0;
> +}
> +EXPORT_SYMBOL(efi_enabled);

I'd use EXPORT_SYMBOL_GPL() unless there is a documented reason why
a symbol should be available to GPL-incompatible modules.

> +static __init int is_discardable_region(efi_memory_desc_t *md)
> +{
> +#ifdef KEEP_ALL_REGIONS
> +	return 0;
> +#endif

IS_ENABLED() again.

> +	if (md->attribute & EFI_MEMORY_RUNTIME)
> +		return 0;
> +
> +	switch (md->type) {
> +#ifdef KEEP_BOOT_SERVICES_REGIONS
> +	case EFI_BOOT_SERVICES_CODE:
> +	case EFI_BOOT_SERVICES_DATA:
> +#endif

and I think it can be used here too:

	switch (md->type) {
	case EFI_BOOT_SERVICES_CODE:
	case EFI_BOOT_SERVICES_DATA:
		if (IS_ENABLED(KEEP_BOOT_SERVICES_REGIONS))
			return 1;
		/* fallthrough */
	case EFI_ACPI_RECLAIM_MEMORY:

> +	memmap.phys_map = early_memremap((phys_addr_t)(u32) uefi_boot_mmap,
> +					 uefi_boot_mmap_size);
> +	if (!memmap.phys_map)
> +		return 1;
> +
> +	p = memmap.phys_map;
> +	e = (void *)((u32)p + uefi_boot_mmap_size);

You are doing a lot of type casts here, which is normally an indication
that you have the types wrong in some way. I can't spot a mistake
here, but maybe you can give it some more thought and see if it can be
changed.

> +static int __init remap_region(efi_memory_desc_t *md, efi_memory_desc_t *entry)
> +{
> +	u64 va;
> +	u64 paddr;
> +	u64 size;
> +
> +	*entry = *md;
> +	paddr = entry->phys_addr;
> +	size = entry->num_pages << EFI_PAGE_SHIFT;
> +
> +	/*
> +	 * Map everything writeback-capable as coherent memory,
> +	 * anything else as device.
> +	 */
> +	if (md->attribute & EFI_MEMORY_WB)
> +		va = (u64)((u32)uefi_remap(paddr, size) & 0xffffffffUL);
> +	else
> +		va = (u64)((u32)uefi_ioremap(paddr, size) & 0xffffffffUL);

Same here. Why is 'va' a u64?

	Arnd
