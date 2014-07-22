From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: don't abort if base of DRAM is
 occupied
Date: Tue, 22 Jul 2014 18:08:18 +0100
Message-ID: <20140722170818.GD4179@bivouac.eciton.net>
References: <1405351521-12010-1-git-send-email-ard.biesheuvel@linaro.org>
 <1405363248.25580.12.camel@deneb.redhat.com>
 <20140715100221.GU4179@bivouac.eciton.net>
 <1405429860.25580.25.camel@deneb.redhat.com>
 <20140715135418.GV4179@bivouac.eciton.net>
 <1405434206.25580.31.camel@deneb.redhat.com>
 <20140715144944.GW4179@bivouac.eciton.net>
 <1405436677.25580.34.camel@deneb.redhat.com>
 <20140715152836.GX4179@bivouac.eciton.net>
 <1405516428.25580.58.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405516428.25580.58.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

(Argh, late reply due to broken mail filters.)

On Wed, Jul 16, 2014 at 09:13:48AM -0400, Mark Salter wrote:
> > > > > > > > Is the spin table area really allocated as BOOT_SERVICES_*?
> > > > > > > 
> > > > > > > No. It is EFI_RESERVED_TYPE. But if UEFI is allowed below the kernel,
> > > > > > > then there could be BS code/data memory which we'd want to ignore.
> > > > > > 
> > > > > > Well, if it is boot service code/data - then there is no need for us
> > > > > > to keep it around after ExitBootServices().
> > > > > 
> > > > > One would think, but EFI has proven to be less than strictly compliant
> > > > > in that regard in the past. I'm inclined to keep the boot services
> > > > > around until after SetVirtualAddressMap just in case.
> > > > 
> > > > But the function you add this clause to will still throw away all boot
> > > > services code/data regions - just with this modification it skips
> > > > those that happen to lie lower in the address space than the kernel.
> > 
> > Returning to the actual code we are discussing here:
> > The hunk above has no bearing on whether boot services regions are
> > generally unmapped or not. It only filters explicitly those boot
> > services regions that happen to be lower in memory than the kernel,
> > and keep them around for the duration of the system.
> 
> It doesn't filter them to keep them around, it filters them to avoid
> calling free_bootmem_late() with an invalid address. If there are UEFI
> regions below the kernel, we don't want to call memblock_reserve() or
> free_bootmem_late() for them.

Then why not just flip things around and do like the arm port and only
add the blocks we actually want to keep around to begin with?

> > > > (And I do agree with Mark R here - let's not work around bugs that
> > > > don't exist yet.)
> > > > 
> > > 
> > > I'm not sure if they still exist or not, but on Foundation, I saw a
> > > crash in SetVirtualAddressMap unless I kept BS regions around.
> > 
> > For the topic of keeping boot services code around:
> > I did also see issues with not keeping boot services regions on v7 -
> > ages ago. I have not seen it this year, and I _really_ want to see if
> > any such issues resurface. 
> 
> My view is that a problem has been seen in the past with tianocore for
> arm64. There is no harm in delaying the freeing of BS regions.

There is a huge harm.

> The
> memory becomes usable for general kernel use at early_initcall time.
> This issue has also been seen with x86 firmware and some of those same
> vendors will be providing arm64 firmware.

This issue has been seen with x86 firmware because in the early days
(last year) noone bothered validating anything other than CSM. They no
longer have that luxury.

The Linux kernel, currently being the most avid tester of existing
arm64 UEFI firmware, falling over itself to cater for hypothetical
broken implementations pretty much guarantees the situation will end
up just as bad as it ever was on x86 - without us even having CSM.

> The problem isn't reproducible
> now, but I'm not sure if there was a bug fix for it or if it just went
> underground for some reason. Kernel boot may succeed by chance if some
> needed BS memory isn't reused by kernel. 

And it may succeed by chance anyway.
I'm not saying we won't see broken firmware - I'm saying that this is
the window we have to try to _help_ people (and ourselves) by letting
broken firmware fail - before it happens in the data centre.

> > So post-3.16 I would quite like to see the
> > call to free_boot_services() moved earlier to flush out any such
> > issues before we see large-scale deployments.
> > 
> 
> You can just get rid of it altogether:

Well, clearly, that would not be my preference :)
 
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 453b7f8..06b59d9 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -177,9 +177,7 @@ static __init void reserve_regions(void)
>  		if (is_normal_ram(md))
>  			early_init_dt_add_memory_arch(paddr, size);
>  
> -		if (is_reserve_region(md) ||
> -		    md->type == EFI_BOOT_SERVICES_CODE ||
> -		    md->type == EFI_BOOT_SERVICES_DATA) {
> +		if (is_reserve_region(md)) {
>  			memblock_reserve(paddr, size);
>  			if (uefi_debug)
>  				pr_cont("*");
> @@ -191,122 +189,6 @@ static __init void reserve_regions(void)
>  }
>  
>  
> -static u64 __init free_one_region(u64 start, u64 end)
> -{
> -	u64 size = end - start;
> -
> -	if (uefi_debug)
> -		pr_info("  EFI freeing: 0x%012llx-0x%012llx\n",	start, end - 1);
> -
> -	free_bootmem_late(start, size);
> -	return size;
> -}
> -
> -static u64 __init free_region(u64 start, u64 end)
> -{
> -	u64 map_start, map_end, total = 0;
> -
> -	if (end <= start)
> -		return total;
> -
> -	map_start = (u64)memmap.phys_map;
> -	map_end = PAGE_ALIGN(map_start + (memmap.map_end - memmap.map));
> -	map_start &= PAGE_MASK;
> -
> -	if (start < map_end && end > map_start) {
> -		/* region overlaps UEFI memmap */
> -		if (start < map_start)
> -			total += free_one_region(start, map_start);
> -
> -		if (map_end < end)
> -			total += free_one_region(map_end, end);
> -	} else
> -		total += free_one_region(start, end);
> -
> -	return total;
> -}
> -
> -static void __init free_boot_services(void)
> -{
> -	u64 total_freed = 0;
> -	u64 keep_end, free_start, free_end;
> -	efi_memory_desc_t *md;
> -
> -	/*
> -	 * If kernel uses larger pages than UEFI, we have to be careful
> -	 * not to inadvertantly free memory we want to keep if there is
> -	 * overlap at the kernel page size alignment. We do not want to
> -	 * free is_reserve_region() memory nor the UEFI memmap itself.
> -	 *
> -	 * The memory map is sorted, so we keep track of the end of
> -	 * any previous region we want to keep, remember any region
> -	 * we want to free and defer freeing it until we encounter
> -	 * the next region we want to keep. This way, before freeing
> -	 * it, we can clip it as needed to avoid freeing memory we
> -	 * want to keep for UEFI.
> -	 */
> -
> -	keep_end = 0;
> -	free_start = 0;
> -
> -	for_each_efi_memory_desc(&memmap, md) {
> -		u64 paddr, npages, size;
> -
> -		if (is_reserve_region(md)) {
> -			/*
> -			 * We don't want to free any memory from this region.
> -			 */
> -			if (free_start) {
> -				/* adjust free_end then free region */
> -				if (free_end > md->phys_addr)
> -					free_end -= PAGE_SIZE;
> -				total_freed += free_region(free_start, free_end);
> -				free_start = 0;
> -			}
> -			keep_end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
> -			continue;
> -		}
> -
> -		if (md->type != EFI_BOOT_SERVICES_CODE &&
> -		    md->type != EFI_BOOT_SERVICES_DATA) {
> -			/* no need to free this region */
> -			continue;
> -		}
> -
> -		/*
> -		 * We want to free memory from this region.
> -		 */
> -		paddr = md->phys_addr;
> -		npages = md->num_pages;
> -		memrange_efi_to_native(&paddr, &npages);
> -		size = npages << PAGE_SHIFT;
> -
> -		if (free_start) {
> -			if (paddr <= free_end)
> -				free_end = paddr + size;
> -			else {
> -				total_freed += free_region(free_start, free_end);
> -				free_start = paddr;
> -				free_end = paddr + size;
> -			}
> -		} else {
> -			free_start = paddr;
> -			free_end = paddr + size;
> -		}
> -		if (free_start < keep_end) {
> -			free_start += PAGE_SIZE;
> -			if (free_start >= free_end)
> -				free_start = 0;
> -		}
> -	}
> -	if (free_start)
> -		total_freed += free_region(free_start, free_end);
> -
> -	if (total_freed)
> -		pr_info("Freed 0x%llx bytes of EFI boot services memory",
> -			total_freed);
> -}
> -
>  void __init efi_init(void)
>  {
>  	struct efi_fdt_params params;
> @@ -439,8 +321,6 @@ static int __init arm64_enter_virtual_mode(void)
>  
>  	kfree(virtmap);
>  
> -	free_boot_services();
> -
>  	if (status != EFI_SUCCESS) {
>  		pr_err("Failed to set EFI virtual address map! [%lx]\n",
>  			status);
> 
> 
> 
