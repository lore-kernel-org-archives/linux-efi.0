From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2] arm64/efi: don't pad between EFI_MEMORY_RUNTIME
 regions
Date: Thu, 10 Sep 2015 14:22:12 +0100
Message-ID: <20150910132211.GF29293@leverpostej>
References: <1441371986-4554-1-git-send-email-ard.biesheuvel@linaro.org>
 <1441782414-16284-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1441782414-16284-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

FWIW I gave this a spin on Seattle and Juno and saw no regressions (both
are pre-2.5 EFI though).

I have some concerns below.

On Wed, Sep 09, 2015 at 08:06:54AM +0100, Ard Biesheuvel wrote:
> The new Properties Table feature introduced in UEFIv2.5 may split
> memory regions that cover PE/COFF memory images into separate code
> and data regions. Since these regions only differ in the type (runtime
> code vs runtime data) and the permission bits, but not in the memory
> type attributes (UC/WC/WT/WB), the spec does not require them to be
> aligned to 64 KB.

We should require those to be 64k-aligned for permissions too. I can
imagine vendors getting permissions wrong but things happening to work
for a 64k kernel (where I assume we have to use the superset of all
permissions within a 64k page).

> As the relative offset of PE/COFF .text and .data segments cannot be
> changed on the fly, this means that we can no longer pad out those
> regions to be mappable using 64 KB pages.
> Unfortunately, there is no annotation in the UEFI memory map that
> identifies data regions that were split off from a code region, so we
> must apply this logic to all adjacent runtime regions whose attributes
> only differ in the permission bits.
> 
> So instead of rounding each memory region to 64 KB alignment at both
> ends, only round down regions that are not directly preceded by another
> runtime region with the same type attributes. Since the UEFI spec does
> not mandate that the memory map be sorted, this means we also need to
> sort it first.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> 
> As discussed off list, this is the arm64 side of what we should backport
> to stable to prevent firmware that adheres to the current version of the
> UEFI v2.5 spec with the memprotect feature enabled from blowing up the system
> upon the first OS call into the runtime services.
> 
> For arm64, we already map things in order, but since the spec does not mandate
> a sorted memory map, we need to sort it to be sure. This also allows us to
> easily find adjacent regions with < 64 KB granularity, which the current version
> of the spec allows if they only differ in permission bits (which the spec says
> are 'unused' on AArch64, which could be interpreted as 'allowed but ignored').
> 
> Changes since v1:
> - Ensure that we don't inadvertently set the XN bit on the preceding region at
>   mapping time if we the OS is running with >4 KB pages.
>   
>  arch/arm64/kernel/efi.c                 |  3 +-
>  drivers/firmware/efi/libstub/arm-stub.c | 62 +++++++++++++++-----
>  2 files changed, 49 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index e8ca6eaedd02..13671a9cf016 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -258,7 +258,8 @@ static bool __init efi_virtmap_init(void)
>  		 */
>  		if (!is_normal_ram(md))
>  			prot = __pgprot(PROT_DEVICE_nGnRE);
> -		else if (md->type == EFI_RUNTIME_SERVICES_CODE)
> +		else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
> +			 !PAGE_ALIGNED(md->phys_addr))
>  			prot = PAGE_KERNEL_EXEC;

This looks coarser than necessary. For memory organised like:

0x00000000 - 0x0000F000 (60KiB) : EFI_RUNTIME_SERVICES_CODE 
0x0000F000 - 0x00020000 (68KiB) : EFI_RUNTIME_SERVICES_DATA

We should be able to make the last 64K non-executable, but with this all
128K is executable, unless I've missed something?

Maybe we could do a two-step pass, first mapping the data as
not-executable, then mapping any code pages executable (overriding any
overlapping portions, but only for the overlapping parts).

>  		else
>  			prot = PAGE_KERNEL;
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index e29560e6b40b..cb4e9c4de952 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -13,6 +13,7 @@
>   */
>  
>  #include <linux/efi.h>
> +#include <linux/sort.h>

Sort isn't an inline in this header. I thought it wasn't safe to call
arbitary kernel functions from the stub?

>  #include <asm/efi.h>
>  
>  #include "efistub.h"
> @@ -305,6 +306,13 @@ fail:
>   */
>  #define EFI_RT_VIRTUAL_BASE	0x40000000
>  
> +static int cmp_mem_desc(const void *a, const void *b)
> +{
> +	const efi_memory_desc_t *left = a, *right = b;
> +
> +	return (left->phys_addr > right->phys_addr) ? 1 : -1;
> +}

Nit: please chose names to make the relationship between these clearer.
e.g. s/left/mem_a/, s/right/mem_b/.

> +
>  /*
>   * efi_get_virtmap() - create a virtual mapping for the EFI memory map
>   *
> @@ -316,34 +324,58 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
>  		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
>  		     int *count)
>  {
> +	static const u64 mem_type_mask = EFI_MEMORY_WB | EFI_MEMORY_WT |
> +					 EFI_MEMORY_WC | EFI_MEMORY_UC |
> +					 EFI_MEMORY_RUNTIME;
> +
>  	u64 efi_virt_base = EFI_RT_VIRTUAL_BASE;
> -	efi_memory_desc_t *out = runtime_map;
> +	efi_memory_desc_t *in, *prev = NULL, *out = runtime_map;
>  	int l;
>  
> -	for (l = 0; l < map_size; l += desc_size) {
> -		efi_memory_desc_t *in = (void *)memory_map + l;
> +	/*
> +	 * To work around potential issues with the Properties Table feature
> +	 * introduced in UEFI 2.5, which may split PE/COFF executable images
> +	 * in memory into several RuntimeServicesCode and RuntimeServicesData
> +	 * regions, we need to preserve the relative offsets between adjacent
> +	 * EFI_MEMORY_RUNTIME regions with the same memory type attributes.
> +	 * The easiest way to find adjacent regions is to sort the memory map
> +	 * before traversing it.
> +	 */
> +	sort(memory_map, map_size / desc_size, desc_size, cmp_mem_desc, NULL);
> +
> +	for (l = 0; l < map_size; l += desc_size, prev = in) {
>  		u64 paddr, size;
>  
> +		in = (void *)memory_map + l;
>  		if (!(in->attribute & EFI_MEMORY_RUNTIME))
>  			continue;
>  
> +		paddr = in->phys_addr;
> +		size = in->num_pages * EFI_PAGE_SIZE;
> +
>  		/*
>  		 * Make the mapping compatible with 64k pages: this allows
>  		 * a 4k page size kernel to kexec a 64k page size kernel and
>  		 * vice versa.
>  		 */
> -		paddr = round_down(in->phys_addr, SZ_64K);
> -		size = round_up(in->num_pages * EFI_PAGE_SIZE +
> -				in->phys_addr - paddr, SZ_64K);
> -
> -		/*
> -		 * Avoid wasting memory on PTEs by choosing a virtual base that
> -		 * is compatible with section mappings if this region has the
> -		 * appropriate size and physical alignment. (Sections are 2 MB
> -		 * on 4k granule kernels)
> -		 */
> -		if (IS_ALIGNED(in->phys_addr, SZ_2M) && size >= SZ_2M)
> -			efi_virt_base = round_up(efi_virt_base, SZ_2M);
> +		if (!prev ||
> +		    ((prev->attribute ^ in->attribute) & mem_type_mask) != 0 ||
> +		    paddr != (prev->phys_addr + prev->num_pages * EFI_PAGE_SIZE)) {
> +

This looks correct, though slightly painful to read. It might be nicer
with helpers helpers like descs_have_same_attrs and
descs_are_contiguous.

Thanks,
Mark.
