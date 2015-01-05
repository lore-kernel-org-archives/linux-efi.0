From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI
 stub
Date: Mon, 5 Jan 2015 16:54:02 +0000
Message-ID: <20150105165402.GE3163@console-pimps.org>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
 <1419245944-2424-7-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1419245944-2424-7-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 22 Dec, at 10:59:02AM, Ard Biesheuvel wrote:
> In order to support kexec, the kernel needs to be able to deal with the
> state of the UEFI firmware after SetVirtualAddressMap() has been called.
> To avoid having separate code paths for non-kexec and kexec, let's move
> the call to SetVirtualAddressMap() to the stub: this will guarantee us
> that it will only be called once (since the stub is not executed during
> kexec), and ensures that the UEFI state is identical between kexec and
> normal boot.
> 
> This implies that the layout of the virtual mapping needs to be created
> by the stub as well. All regions are rounded up to a naturally aligned
> multiple of 64 KB (for compatibility with 64k pages kernels) and recorded
> in the UEFI memory map. The kernel proper reads those values and installs
> the mappings in a dedicated set of page tables that are swapped in during
> UEFI Runtime Services calls.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/include/asm/efi.h       |  20 +++-
>  arch/arm64/kernel/efi.c            | 223 ++++++++++++++++++++-----------------
>  arch/arm64/kernel/setup.c          |   1 +
>  drivers/firmware/efi/libstub/fdt.c | 137 ++++++++++++++++++++++-
>  4 files changed, 270 insertions(+), 111 deletions(-)

[...]

> @@ -45,5 +53,9 @@ extern void efi_idmap_init(void);
>  #define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
>  
>  #define EFI_ALLOC_ALIGN		SZ_64K
> +#define EFI_VIRTMAP		EFI_ARCH_1

Any chance of documenting what EFI_VIRTMAP means for posterity and why
you want to use one of the EFI arch config bits? How is this different
from EFI_RUNTIME_SERVICES?

Take a look at EFI_OLD_MEMMAP in arch/x86/include/asm/efi.h for a
crackingly well documented example from Borislav.

[...]
  
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index c846a9608cbd..76bc8abf41d1 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -167,6 +167,94 @@ fdt_set_fail:
>  #define EFI_FDT_ALIGN EFI_PAGE_SIZE
>  #endif
>  
> +static efi_status_t get_memory_map(efi_system_table_t *sys_table_arg,
> +				   efi_memory_desc_t **map,
> +				   unsigned long *map_size,
> +				   unsigned long *desc_size,
> +				   u32 *desc_ver, unsigned long *key_ptr)
> +{
> +	efi_status_t status;
> +
> +	/*
> +	 * Call get_memory_map() with 0 size to retrieve the size of the
> +	 * required allocation.
> +	 */
> +	*map_size = 0;
> +	status = efi_call_early(get_memory_map, map_size, NULL,
> +				key_ptr, desc_size, desc_ver);
> +	if (status != EFI_BUFFER_TOO_SMALL)
> +		return EFI_LOAD_ERROR;
> +
> +	/*
> +	 * Add an additional efi_memory_desc_t to map_size because we're doing
> +	 * an allocation which may be in a new descriptor region. Then double it
> +	 * to give us some scratch space to prepare the input virtmap to give
> +	 * to SetVirtualAddressMap(). Note that this is EFI_LOADER_DATA memory,
> +	 * and the kernel memblock_reserve()'s only the size of the actual
> +	 * memory map, so the scratch space is freed again automatically.
> +	 */
> +	*map_size += *desc_size;
> +	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> +				*map_size * 2, (void **)map);
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	status = efi_call_early(get_memory_map, map_size, *map,
> +				key_ptr, desc_size, desc_ver);
> +	if (status != EFI_SUCCESS)
> +		efi_call_early(free_pool, *map);
> +	return status;
> +}

We've now got two (slightly different) versions of this function. Is
there any way we could make do with just one?

> +/*
> + * This is the base address at which to start allocating virtual memory ranges
> + * for UEFI Runtime Services. This is a userland range so that we can use any
> + * allocation we choose, and eliminate the risk of a conflict after kexec.
> + */
> +#define EFI_RT_VIRTUAL_BASE	0x40000000
> +
> +static void update_memory_map(efi_memory_desc_t *memory_map,
> +			      unsigned long map_size, unsigned long desc_size,
> +			      int *count)
> +{
> +	u64 efi_virt_base = EFI_RT_VIRTUAL_BASE;
> +	efi_memory_desc_t *out = (void *)memory_map + map_size;
> +	int l;
> +
> +	for (l = 0; l < map_size; l += desc_size) {
> +		efi_memory_desc_t *in = (void *)memory_map + l;
> +		u64 paddr, size;
> +
> +		if (!(in->attribute & EFI_MEMORY_RUNTIME))
> +			continue;
> +
> +		/*
> +		 * Make the mapping compatible with 64k pages: this allows
> +		 * a 4k page size kernel to kexec a 64k page size kernel and
> +		 * vice versa.
> +		 */
> +		paddr = round_down(in->phys_addr, SZ_64K);
> +		size = round_up(in->num_pages * EFI_PAGE_SIZE +
> +				in->phys_addr - paddr, SZ_64K);
> +
> +		/*
> +		 * Avoid wasting memory on PTEs by choosing a virtual base that
> +		 * is compatible with section mappings if this region has the
> +		 * appropriate size and physical alignment. (Sections are 2 MB
> +		 * on 4k granule kernels)
> +		 */
> +		if (IS_ALIGNED(in->phys_addr, SZ_2M) && size >= SZ_2M)
> +			efi_virt_base = round_up(efi_virt_base, SZ_2M);
> +
> +		in->virt_addr = efi_virt_base + in->phys_addr - paddr;
> +		efi_virt_base += size;
> +
> +		memcpy(out, in, desc_size);
> +		out = (void *)out + desc_size;
> +		++*count;
> +	}
> +}
> +

fdt.c is starting to become a dumping ground for arm*-specific stuff :-(

Is there no general solution for sharing code between arm and aarch64 in
the kernel so we don't have to stick things like this in
drivers/firmware/efi/?

-- 
Matt Fleming, Intel Open Source Technology Center
