From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/10] arm64/efi: use UEFI memory map unconditionally if available
Date: Thu, 23 Oct 2014 21:23:19 +0200
Message-ID: <CAKv+Gu_MMCMd58PGQ1f2Ahm-rYDPU1oJ8XA6mNFi0qKCx0C9fA@mail.gmail.com>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
	<1413987713-30528-7-git-send-email-ard.biesheuvel@linaro.org>
	<1413997616.2985.74.camel@deneb.redhat.com>
	<20141023155428.GA977@leverpostej>
	<1414081198.6829.12.camel@deneb.redhat.com>
	<20141023191433.GB20121@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141023191433.GB20121@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 October 2014 21:14, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> [...]
>
>> > > It also looks like EFI_BOOT flag will be set even if uefi_init fails.
>> > > If uefi_init fails, we only need reserve_regions() for the purpose
>> > > of adding memblocks. Otherwise, we end up wasting a lot of memory.
>> >
>> > What memory are we wasting in that case? Surely the only items that we
>> > could choose to throw away if we failed uefi_init are
>> > EFI_ACPI_RECLAIM_MEMORY and EFI_MEMORY_RUNTIME?
>> >
>> > We might want to keep those around so we can kexec into a kernel where
>> > we can make use of them. Surely they shouldn't take up a significant
>> > proportion of the available memory?
>>
>> In addition, reserve_regions() also reserves BOOT_SERVICES (which gets
>> freed up later after set_virtual_address_map(). That won't happen if
>> uefi_init() fails. In any case, if uefi_init() fails, we won't be able
>> to find the ACPI tables kexec kernel won't be able to either.
>
> If you need the ACPI tables, the first kernel won't boot. However, if we
> fail to map the runtime services data and code, that doesn't mean the
> next kernel can't. We might have failed to map the runtime services due
> to an early_ioremap bug or similar, and that could be fixed in the
> kernel we're about to kexec to.
>
> If we're going to nuke runtime regions, we should nuke them in the
> memory map descriptors as a courtesy to the next kernel. Otherwise we
> could be more courteous and simply leave them be (which is my
> preference).
>
>> The BOOT_SERVICES stuff is the big chunk. There was some discussion of
>> not reserving that but no one has gotten around to writing the patch
>> to clean out the code that does it.
>
> I've just spent some time doing so; patch below. It boots happily on my
> Juno (with 4KiB pages at least), but I haven't given it much of a stress
> test.
>
> I wasn't sure if unusable memory could show up with EFI_MEMORY_WB
> attributes. If so, this patch still won't prevent that from being mapped
> as cacheable, but that should be easy to fix.
>
> Thanks,
> Mark.
>
> ---->8----
> From 581d5bac5b4a6f93e23737012b71c58d809af6bb Mon Sep 17 00:00:00 2001
> From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Date: Thu, 23 Oct 2014 19:41:55 +0100
> Subject: [PATCH] arm64: efi: Simplify memory descriptor handling
>
> Currently discovering the memory map from UEFI is a multi-stage affair,
> where the boot services code and data are kept around for much longer
> than necessary. Additionally, potential overlap between memory and IO
> mappings at kernel page granularity is not handled.
>
> This patch attempts to solve both of these issues, with the addition and
> filtering of memory regions being handled in a single function.
>
> First, all normal memory (i.e. anything which can be mapped writeback
> cacheable) is added to memblock. Second, IO and reserved regions are
> filtered out of memblock at kernel page granularity, to prevent
> potential conflicting mappings.
>

Fortunately, this is being addressed in an upcoming UEFI spec
revision: it will not be allowed for memory regions that could
potentially conflict in terms of cache attributes to share the same 64
KB page frame.

As I mentioned, my kexec patches will move SetVirtualAddressMap() to
the stub, which means we will also be able to drop the id map bits
entirely. As I said, let's revisit this in that context, and drop it
for now.

-- 
Ard.


> As some reserved regions must be present in the idmap these are
> reserved. Everything else that's not normal memory is removed,
> preventing the possibility of a cacheable mapping covering something it
> shouldn't.
>
> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
> Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
> Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c | 181 +++++++++++-------------------------------------
>  1 file changed, 42 insertions(+), 139 deletions(-)
>
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 03aaa99..8873c28 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -154,161 +154,66 @@ static __init int is_reserve_region(efi_memory_desc_t *md)
>         return 0;
>  }
>
> -static __init void reserve_regions(void)
> +static __init void efi_add_memory(void)
>  {
>         efi_memory_desc_t *md;
> -       u64 paddr, npages, size;
> +       u64 paddr, size;
>
>         if (uefi_debug)
> -               pr_info("Processing EFI memory map:\n");
> +               pr_info("EFI: adding normal memory:\n");
>
>         for_each_efi_memory_desc(&memmap, md) {
> +               if (!is_normal_ram(md))
> +                       continue;
> +
>                 paddr = md->phys_addr;
> -               npages = md->num_pages;
> +               size = md->num_pages << EFI_PAGE_SHIFT;
>
>                 if (uefi_debug)
> -                       pr_info("  0x%012llx-0x%012llx [%s]",
> -                               paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
> +                       pr_info("  0x%012llx-0x%012llx [%s]\n",
> +                               paddr, size - 1,
>                                 memory_type_name[md->type]);
>
> -               memrange_efi_to_native(&paddr, &npages);
> -               size = npages << PAGE_SHIFT;
> +               early_init_dt_add_memory_arch(paddr, size);
> +       }
> +
> +       /*
> +        * Regions describe in an EFI_MEMORY_DESCRIPTOR are only guaranteed to
> +        * be 4KiB aligned but the kernel page size could be larger, and
> +        * regions with different attributes could fall into the same kernel
> +        * page. Thus we must remove any memory in the same kernel page as an
> +        * IO region.
> +        *
> +        * Reserved regions of memory need to be in the idmap, so just reserve
> +        * them.
> +        */
> +       if (uefi_debug)
> +               pr_info("EFI: correcting for overlapping regions:\n");
> +
> +       for_each_efi_memory_desc(&memmap, md) {
> +               if (!is_reserve_region(md) && is_normal_ram(md))
> +                       continue;
> +
> +               paddr = md->phys_addr;
> +               size = md->num_pages << EFI_PAGE_SHIFT;
> +
> +               size = PAGE_ALIGN(size + (paddr & ~PAGE_MASK));
> +               paddr &= PAGE_MASK;
>
> -               if (is_normal_ram(md))
> -                       early_init_dt_add_memory_arch(paddr, size);
> +               if (uefi_debug)
> +                       pr_info("  0x%012llx-0x%012llx [%s]\n",
> +                               paddr, size - 1,
> +                               memory_type_name[md->type]);
>
> -               if (is_reserve_region(md) ||
> -                   md->type == EFI_BOOT_SERVICES_CODE ||
> -                   md->type == EFI_BOOT_SERVICES_DATA) {
> +               if (is_reserve_region(md))
>                         memblock_reserve(paddr, size);
> -                       if (uefi_debug)
> -                               pr_cont("*");
> -               }
> -
> -               if (uefi_debug)
> -                       pr_cont("\n");
> +               else
> +                       memblock_remove(paddr, size);
>         }
>
>         set_bit(EFI_MEMMAP, &efi.flags);
>  }
>
> -
> -static u64 __init free_one_region(u64 start, u64 end)
> -{
> -       u64 size = end - start;
> -
> -       if (uefi_debug)
> -               pr_info("  EFI freeing: 0x%012llx-0x%012llx\n", start, end - 1);
> -
> -       free_bootmem_late(start, size);
> -       return size;
> -}
> -
> -static u64 __init free_region(u64 start, u64 end)
> -{
> -       u64 map_start, map_end, total = 0;
> -
> -       if (end <= start)
> -               return total;
> -
> -       map_start = (u64)memmap.phys_map;
> -       map_end = PAGE_ALIGN(map_start + (memmap.map_end - memmap.map));
> -       map_start &= PAGE_MASK;
> -
> -       if (start < map_end && end > map_start) {
> -               /* region overlaps UEFI memmap */
> -               if (start < map_start)
> -                       total += free_one_region(start, map_start);
> -
> -               if (map_end < end)
> -                       total += free_one_region(map_end, end);
> -       } else
> -               total += free_one_region(start, end);
> -
> -       return total;
> -}
> -
> -static void __init free_boot_services(void)
> -{
> -       u64 total_freed = 0;
> -       u64 keep_end, free_start, free_end;
> -       efi_memory_desc_t *md;
> -
> -       /*
> -        * If kernel uses larger pages than UEFI, we have to be careful
> -        * not to inadvertantly free memory we want to keep if there is
> -        * overlap at the kernel page size alignment. We do not want to
> -        * free is_reserve_region() memory nor the UEFI memmap itself.
> -        *
> -        * The memory map is sorted, so we keep track of the end of
> -        * any previous region we want to keep, remember any region
> -        * we want to free and defer freeing it until we encounter
> -        * the next region we want to keep. This way, before freeing
> -        * it, we can clip it as needed to avoid freeing memory we
> -        * want to keep for UEFI.
> -        */
> -
> -       keep_end = 0;
> -       free_start = 0;
> -
> -       for_each_efi_memory_desc(&memmap, md) {
> -               u64 paddr, npages, size;
> -
> -               if (is_reserve_region(md)) {
> -                       /*
> -                        * We don't want to free any memory from this region.
> -                        */
> -                       if (free_start) {
> -                               /* adjust free_end then free region */
> -                               if (free_end > md->phys_addr)
> -                                       free_end -= PAGE_SIZE;
> -                               total_freed += free_region(free_start, free_end);
> -                               free_start = 0;
> -                       }
> -                       keep_end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
> -                       continue;
> -               }
> -
> -               if (md->type != EFI_BOOT_SERVICES_CODE &&
> -                   md->type != EFI_BOOT_SERVICES_DATA) {
> -                       /* no need to free this region */
> -                       continue;
> -               }
> -
> -               /*
> -                * We want to free memory from this region.
> -                */
> -               paddr = md->phys_addr;
> -               npages = md->num_pages;
> -               memrange_efi_to_native(&paddr, &npages);
> -               size = npages << PAGE_SHIFT;
> -
> -               if (free_start) {
> -                       if (paddr <= free_end)
> -                               free_end = paddr + size;
> -                       else {
> -                               total_freed += free_region(free_start, free_end);
> -                               free_start = paddr;
> -                               free_end = paddr + size;
> -                       }
> -               } else {
> -                       free_start = paddr;
> -                       free_end = paddr + size;
> -               }
> -               if (free_start < keep_end) {
> -                       free_start += PAGE_SIZE;
> -                       if (free_start >= free_end)
> -                               free_start = 0;
> -               }
> -       }
> -       if (free_start)
> -               total_freed += free_region(free_start, free_end);
> -
> -       if (total_freed)
> -               pr_info("Freed 0x%llx bytes of EFI boot services memory",
> -                       total_freed);
> -}
> -
>  void __init efi_init(void)
>  {
>         struct efi_fdt_params params;
> @@ -330,7 +235,7 @@ void __init efi_init(void)
>         if (uefi_init() < 0)
>                 return;
>
> -       reserve_regions();
> +       efi_add_memory();
>  }
>
>  void __init efi_idmap_init(void)
> @@ -452,8 +357,6 @@ static int __init arm64_enter_virtual_mode(void)
>
>         kfree(virtmap);
>
> -       free_boot_services();
> -
>         if (status != EFI_SUCCESS) {
>                 pr_err("Failed to set EFI virtual address map! [%lx]\n",
>                         status);
> --
> 1.9.1
>
