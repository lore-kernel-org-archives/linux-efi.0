From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 09/10] arm64/efi: ignore unusable regions instead of
 reserving them
Date: Sun, 09 Nov 2014 23:11:35 -0500
Message-ID: <1415592695.32311.91.camel@deneb.redhat.com>
References: <1415283206-14713-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1415283206-14713-10-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415283206-14713-10-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-11-06 at 15:13 +0100, Ard Biesheuvel wrote:
> This changes the way memblocks are installed based on the contents of
> the UEFI memory map. Formerly, all regions would be memblock_add()'ed,
> after which unusable regions would be memblock_reserve()'d as well.
> To simplify things, but also to allow access to the unusable regions
> through mmap(/dev/mem), even with CONFIG_STRICT_DEVMEM set, change
> this so that only usable regions are memblock_add()'ed in the first
> place.

This patch is crashing 64K pagesize kernels during boot. I'm not exactly
sure why, though. Here is what I get on an APM Mustang box:

[    0.046262] Unhandled fault: alignment fault (0x96000021) at 0xfffffc000004f026
[    0.053863] Internal error: : 96000021 [#1] SMP
[    0.058566] Modules linked in:
[    0.061736] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc3+ #11
[    0.068418] Hardware name: APM X-Gene Mustang board (DT)
[    0.073942] task: fffffe0000f46a20 ti: fffffe0000f10000 task.ti: fffffe0000f10000
[    0.081735] PC is at acpi_ns_lookup+0x520/0x734
[    0.086448] LR is at acpi_ns_lookup+0x4ac/0x734
[    0.091151] pc : [<fffffe0000460458>] lr : [<fffffe00004603e4>] pstate: 60000245
[    0.098843] sp : fffffe0000f13b00
[    0.102293] x29: fffffe0000f13b10 x28: 000000000000000a 
[    0.107810] x27: 0000000000000008 x26: 0000000000000000 
[    0.113345] x25: fffffe0000f13c38 x24: fffffe0000fae000 
[    0.118862] x23: 0000000000000008 x22: 0000000000000001 
[    0.124406] x21: fffffe0000972000 x20: 000000000000000a 
[    0.129940] x19: fffffc000004f026 x18: 000000000000000b 
[    0.135483] x17: 0000000000000023 x16: 000000000000059f 
[    0.141026] x15: 0000000000007fff x14: 000000000000038e 
[    0.146543] x13: ff00000000000000 x12: ffffffffffffffff 
[    0.152060] x11: 0000000000000010 x10: 00000000fffffff6 
[    0.157585] x9 : 0000000000000050 x8 : fffffe03fa7401b0 
[    0.163111] x7 : fffffe0001115a00 x6 : fffffe0001115a00 
[    0.168620] x5 : fffffe0001115000 x4 : 0000000000000010 
[    0.174146] x3 : 0000000000000010 x2 : 000000000000000b 
[    0.179689] x1 : 00000000fffffff5 x0 : 0000000000000000 
[    0.185215] 
[    0.186765] Process swapper/0 (pid: 0, stack limit = 0xfffffe0000f10058)
[    0.193724] Stack: (0xfffffe0000f13b00 to 0xfffffe0000f14000)
[    0.199707] 3b00: 00000000 fffffe03 00000666 00000000 00f13bd0 fffffe00 0044f388 fffffe00
...
[    0.539605] Call trace:
[    0.542150] [<fffffe0000460458>] acpi_ns_lookup+0x520/0x734
[    0.547935] [<fffffe000044f384>] acpi_ds_load1_begin_op+0x384/0x4b4
[    0.554445] [<fffffe0000469594>] acpi_ps_build_named_op+0xfc/0x228
[    0.560868] [<fffffe00004698c8>] acpi_ps_create_op+0x208/0x340
[    0.566945] [<fffffe0000468ea8>] acpi_ps_parse_loop+0x208/0x7f8
[    0.573092] [<fffffe000046a6b8>] acpi_ps_parse_aml+0x1c0/0x434
[    0.579153] [<fffffe0000463cb0>] acpi_ns_one_complete_parse+0x1a4/0x1ec
[    0.586017] [<fffffe0000463d88>] acpi_ns_parse_table+0x90/0x130
[    0.592181] [<fffffe0000462f94>] acpi_ns_load_table+0xc8/0x1b0
[    0.598243] [<fffffe0000e71848>] acpi_load_tables+0xf4/0x234
[    0.604122] [<fffffe0000e70a0c>] acpi_early_init+0x78/0xc8
[    0.609828] [<fffffe0000e40928>] start_kernel+0x334/0x3ac
[    0.615431] Code: 2a00037b b9009fbc 36180057 321d037b (b9400260) 
[    0.621777] ---[ end trace cb88537fdc8fa200 ]---
[    0.626586] Kernel panic - not syncing: Attempted to kill the idle task!

I also get a different crash when booting with device tree instead of ACPI.

One thing is that early_init_dt_add_memory_arch() is called with UEFI
(4K) pagesize alignment and size and it clips the passed in range such
that what is added is the 64K aligned range which fits completely within
the given range. This may mean nothing gets added if the given range is
smaller than 64K. And only a subset of the desired range is added in
other cases. This could theoretically leave bits of devicetree and/or
initrd unmapped, but that doesn't seem to be the case here. I'll keep
poking at it...

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c | 69 +++++++++++++++++++------------------------------
>  1 file changed, 26 insertions(+), 43 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 3009c22e2620..af2214c692d3 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -40,13 +40,6 @@ static int __init uefi_debug_setup(char *str)
>  }
>  early_param("uefi_debug", uefi_debug_setup);
>  
> -static int __init is_normal_ram(efi_memory_desc_t *md)
> -{
> -	if (md->attribute & EFI_MEMORY_WB)
> -		return 1;
> -	return 0;
> -}
> -
>  static int __init uefi_init(void)
>  {
>  	efi_char16_t *c16;
> @@ -105,28 +98,11 @@ out:
>  	return retval;
>  }
>  
> -/*
> - * Return true for RAM regions we want to permanently reserve.
> - */
> -static __init int is_reserve_region(efi_memory_desc_t *md)
> -{
> -	switch (md->type) {
> -	case EFI_LOADER_CODE:
> -	case EFI_LOADER_DATA:
> -	case EFI_BOOT_SERVICES_CODE:
> -	case EFI_BOOT_SERVICES_DATA:
> -	case EFI_CONVENTIONAL_MEMORY:
> -		return 0;
> -	default:
> -		break;
> -	}
> -	return is_normal_ram(md);
> -}
> -
> -static __init void reserve_regions(void)
> +static __init void process_memory_map(void)
>  {
>  	efi_memory_desc_t *md;
>  	u64 paddr, npages, size;
> +	u32 lost = 0;
>  
>  	if (uefi_debug)
>  		pr_info("Processing EFI memory map:\n");
> @@ -134,31 +110,38 @@ static __init void reserve_regions(void)
>  	for_each_efi_memory_desc(&memmap, md) {
>  		paddr = md->phys_addr;
>  		npages = md->num_pages;
> +		size = npages << EFI_PAGE_SHIFT;
>  
>  		if (uefi_debug) {
>  			char buf[64];
>  
> -			pr_info("  0x%012llx-0x%012llx %s",
> -				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
> +			pr_info("  0x%012llx-0x%012llx %s\n",
> +				paddr, paddr + size - 1,
>  				efi_md_typeattr_format(buf, sizeof(buf), md));
>  		}
>  
> -		memrange_efi_to_native(&paddr, &npages);
> -		size = npages << PAGE_SHIFT;
> -
> -		if (is_normal_ram(md))
> -			early_init_dt_add_memory_arch(paddr, size);
> -
> -		if (is_reserve_region(md)) {
> -			memblock_reserve(paddr, size);
> -			if (uefi_debug)
> -				pr_cont("*");
> -		}
> -
> -		if (uefi_debug)
> -			pr_cont("\n");
> +		if (!efi_mem_is_usable_region(md))
> +			continue;
> +
> +		early_init_dt_add_memory_arch(paddr, size);
> +
> +		/*
> +		 * Keep a tally of how much memory we are losing due to
> +		 * rounding of regions that are not aligned to the page
> +		 * size. We cannot easily recover this memory without
> +		 * sorting the memory map and attempting to merge adjacent
> +		 * usable regions.
> +		 */
> +		if (PAGE_SHIFT != EFI_PAGE_SHIFT)
> +			lost += (npages << EFI_PAGE_SHIFT) -
> +				round_down(max_t(s64, size - PAGE_ALIGN(paddr) +
> +						 md->phys_addr, 0),
> +					   PAGE_SIZE);
>  	}
>  
> +	if (lost > SZ_1K)
> +		pr_warn("efi: lost %u KB of RAM to rounding\n", lost / SZ_1K);
> +
>  	set_bit(EFI_MEMMAP, &efi.flags);
>  }
>  
> @@ -182,7 +165,7 @@ void __init efi_init(void)
>  
>  	WARN_ON(uefi_init() < 0);
>  
> -	reserve_regions();
> +	process_memory_map();
>  }
>  
>  static int __init arm64_enter_virtual_mode(void)
