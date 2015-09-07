From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Map EFI memmap entries in-order at runtime
Date: Mon, 7 Sep 2015 12:07:52 +0800
Message-ID: <20150907040752.GW13182@linux-rxt1.site>
References: <1441372447-23439-1-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1441372447-23439-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi, 

On Fri, Sep 04, 2015 at 02:14:07PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Beginning with UEFI v2.5 EFI_PROPERTIES_TABLE was introduced that
> signals that the firmware PE/COFF loader supports splitting code and
> data sections of PE/COFF images into separate EFI memory map entries.
> This allows the kernel to map those regions with strict memory
> protections, e.g. EFI_MEMORY_RO for code, EFI_MEMORY_XP for data, etc.
> 
> Unfortunately, an unwritten requirement of this new feature is that
> the regions need to be mapped with the same offsets relative to each
> other as observed in the EFI memory map. If this is not done crashes
> like this may occur,
> 
>  [    0.006391] BUG: unable to handle kernel paging request at fffffffefe6086dd
>  [    0.006923] IP: [<fffffffefe6086dd>] 0xfffffffefe6086dd
>  [    0.007000] Call Trace:
>  [    0.007000]  [<ffffffff8104c90e>] efi_call+0x7e/0x100
>  [    0.007000]  [<ffffffff81602091>] ? virt_efi_set_variable+0x61/0x90
>  [    0.007000]  [<ffffffff8104c583>] efi_delete_dummy_variable+0x63/0x70
>  [    0.007000]  [<ffffffff81f4e4aa>] efi_enter_virtual_mode+0x383/0x392
>  [    0.007000]  [<ffffffff81f37e1b>] start_kernel+0x38a/0x417
>  [    0.007000]  [<ffffffff81f37495>] x86_64_start_reservations+0x2a/0x2c
>  [    0.007000]  [<ffffffff81f37582>] x86_64_start_kernel+0xeb/0xef
> 
> Here 0xfffffffefe6086dd refers to an address the firmware expects to
> be mapped but which the OS never claimed was mapped. The issue is that
> included in these regions are relative addresses to other regions
> which were emitted by the firmware toolchain before the "splitting" of
> sections occurred at runtime.
> 
> Needless to say, we don't satisfy this unwritten requirement on x86_64
> and instead map the EFI memory map entries in reverse order. The above
> crash is almost certainly triggerable with any kernel newer than v3.13
> because that's when we rewrote the EFI runtime region mapping code, in
> commit d2f7cbe7b26a ("x86/efi: Runtime services virtual mapping"). For
> kernel versions before v3.13 things may work by pure luck depending on
> the fragmentation of the kernel virtual address space at the time we
> map the EFI regions.
> 
> Instead of mapping the EFI memory map entries in reverse order, where
> entry N has a higher virtual address than entry N+1, map them in the
> same order as they appear in the EFI memory map to preserve this
> relative offset between regions.
> 
> This patch has been kept as small as possible with the intention that
> it should be applied aggressively to stable and distribution kernels.
> It is very much a bugfix rather than support for a new feature, since
> when EFI_PROPERTIES_TABLE is enabled we must map things as outlined
> above to even boot - we have no way of asking the firmware not to
> split the code/data regions.
> 
> In fact, this patch doesn't even make use of the more strict memory
> protections available in UEFI v2.5. That will come later.
> 
> Reported-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch works to me on Intel S1200V3RPS to fix issue:
DMI: Intel Corporation (uefidk.com) Intel Server Board S1200V3RPS UEFI Development Kit/ROMLEY, BIOS 2.0

Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>

> ---
>  arch/x86/include/asm/efi.h     |   1 +
>  arch/x86/platform/efi/efi.c    |   2 +
>  arch/x86/platform/efi/efi_32.c |   1 +
>  arch/x86/platform/efi/efi_64.c | 109 ++++++++++++++++++++++++++++++++++-------
>  4 files changed, 96 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 155162ea0e00..fe988599c5e1 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -96,6 +96,7 @@ extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
>  extern void __init efi_unmap_memmap(void);
>  extern void __init efi_memory_uc(u64 addr, unsigned long size);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
> +extern void __init efi_map_calculate_base(void);
>  extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
>  extern void efi_sync_low_kernel_mappings(void);
>  extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index e4308fe6afe8..5276ec6eefef 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -714,6 +714,8 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
>  	unsigned long left = 0;
>  	efi_memory_desc_t *md;
>  
> +	efi_map_calculate_base();
> +
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		md = p;
>  		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
> index ed5b67338294..8a80baa877fb 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -55,6 +55,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
>  
>  void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
>  void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
> +void __init efi_map_calculate_base(void) {}
>  
>  pgd_t * __init efi_call_phys_prolog(void)
>  {
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index a0ac0f9c307f..4c1d15984a79 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -214,14 +214,52 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
>  			   md->phys_addr, va);
>  }
>  
> +/**
> + * efi_map_start_addr - Find an address to map an EFI region
> + * @md: EFI memory map region descriptor
> + * @addr: Begin searching from this address
> + *
> + * Calculate the next highest virtual address at which to map
> + * @md->phys_addr while abiding by any alignment restrictions. For
> + * example, if @md->phys_addr is 2M-aligned we keep the virtual
> + * address 2M-aligned.
> + */
> +static u64 efi_map_start_addr(efi_memory_desc_t *md, u64 addr)
> +{
> +	u64 tail;
> +
> +	tail = md->phys_addr & (PMD_SIZE - 1);
> +
> +	/* Is physical address 2M-aligned? */
> +	if (!tail) {
> +		addr = roundup(addr, PMD_SIZE);
> +	} else {
> +		u64 prev_addr = addr;
> +
> +		/* get us the same offset within this 2M page */
> +		addr = (addr & PMD_MASK) + tail;
> +
> +		/*
> +		 * Roll forward to the next PMD.
> +		 */
> +		if (addr < prev_addr)
> +			addr += PMD_SIZE;
> +	}
> +
> +	return addr;
> +}
> +
>  void __init efi_map_region(efi_memory_desc_t *md)
>  {
>  	unsigned long size = md->num_pages << PAGE_SHIFT;
> -	u64 pa = md->phys_addr;
>  
>  	if (efi_enabled(EFI_OLD_MEMMAP))
>  		return old_map_region(md);
>  
> +	/* Has efi_map_calculate_base() been called? */
> +	if (WARN_ON_ONCE(efi_va == EFI_VA_START))
> +		return;
> +
>  	/*
>  	 * Make sure the 1:1 mappings are present as a catch-all for b0rked
>  	 * firmware which doesn't update all internal pointers after switching
> @@ -239,23 +277,9 @@ void __init efi_map_region(efi_memory_desc_t *md)
>  		return;
>  	}
>  
> -	efi_va -= size;
> -
> -	/* Is PA 2M-aligned? */
> -	if (!(pa & (PMD_SIZE - 1))) {
> -		efi_va &= PMD_MASK;
> -	} else {
> -		u64 pa_offset = pa & (PMD_SIZE - 1);
> -		u64 prev_va = efi_va;
> -
> -		/* get us the same offset within this 2M page */
> -		efi_va = (efi_va & PMD_MASK) + pa_offset;
> -
> -		if (efi_va > prev_va)
> -			efi_va -= PMD_SIZE;
> -	}
> +	efi_va = efi_map_start_addr(md, efi_va);
>  
> -	if (efi_va < EFI_VA_END) {
> +	if (efi_va > EFI_VA_START) {
>  		pr_warn(FW_WARN "VA address range overflow!\n");
>  		return;
>  	}
> @@ -263,6 +287,57 @@ void __init efi_map_region(efi_memory_desc_t *md)
>  	/* Do the VA map */
>  	__map_region(md, efi_va);
>  	md->virt_addr = efi_va;
> +	efi_va += size;
> +}
> +
> +/**
> + * efi_map_calculate_base - Find the base address to map EFI regions
> + *
> + * This function calculates how much virtual address space is required
> + * to map all the EFI regions for runtime. We map those regions as
> + * close to each other as possible while sticking with the PMD
> + * alignment and ensuring we end at EFI_VA_START.
> + *
> + * On return we set 'efi_va' to the start address of the virtual
> + * address space where efi_map_region() will begin mapping things.
> + *
> + * Beginning in UEFI v2.5 the EFI_PROPERTIES_TABLE config table
> + * feature requires us to map all entries in the same order as they
> + * appear in the EFI memory map. That is to say, entry N must have a
> + * lower virtual address than entry N+1. This is because the firmware
> + * toolchain leaves relative references in the code/data sections,
> + * which are split and become separate EFI memory regions. Mapping
> + * things out-of-order leads to the firmware accessing unmapped
> + * addresses.
> + *
> + * We need to map things this way whether or not we actually make use
> + * of the EFI_PROPERTIES_TABLE feature.
> + *
> + * Call this function before invoking efi_map_region().
> + */
> +void __init efi_map_calculate_base(void)
> +{
> +	efi_memory_desc_t *md;
> +	u64 size = 0;
> +
> +	/*
> +	 * We don't need to place the mappings this carefully for the
> +	 * old mapping scheme.
> +	 */
> +	if (efi_enabled(EFI_OLD_MEMMAP))
> +		return;
> +
> +	for_each_efi_memory_desc(&memmap, md) {
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> +		    md->type != EFI_BOOT_SERVICES_CODE &&
> +		    md->type != EFI_BOOT_SERVICES_DATA)
> +			continue;
> +
> +		size = efi_map_start_addr(md, size);
> +		size += md->num_pages << PAGE_SHIFT;
> +	}
> +
> +	efi_va -= size;
>  }
>  
>  /*
> -- 
> 2.1.0
> 
> --

Thanks a lot!
Joey Lee
