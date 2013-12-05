From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 3/3] arm64: add EFI runtime services
Date: Thu, 5 Dec 2013 15:25:10 +0000
Message-ID: <20131205152510.GB974@darko.cambridge.arm.com>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
 <1385762712-17043-4-git-send-email-msalter@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385762712-17043-4-git-send-email-msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 29, 2013 at 10:05:12PM +0000, Mark Salter wrote:
> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> new file mode 100644
> index 0000000..7384048
> --- /dev/null
> +++ b/arch/arm64/include/asm/efi.h
> @@ -0,0 +1,18 @@
> +#ifndef _ASM_ARM64_EFI_H
> +#define _ASM_ARM64_EFI_H
> +
> +#include <asm/io.h>
> +
> +#ifdef CONFIG_EFI
> +extern void efi_init(void);
> +#else
> +#define efi_init()
> +#endif
> +
> +#define efi_remap(cookie, size) __ioremap((cookie), (size), PAGE_KERNEL_EXEC)
> +#define efi_ioremap(cookie, size) __ioremap((cookie), (size), \
> +                                           __pgprot(PROT_DEVICE_nGnRE))
> +#define efi_unmap(cookie) __iounmap((cookie))
> +#define efi_iounmap(cookie) __iounmap((cookie))

I prefer to use the ioremap_*() functions rather than the lower-level
__ioremap(). The ioremap_cache() should give us executable memory.

Looking at the code, I think we have a bug with ioremap_cache() using
MT_NORMAL since it doesn't have the shareability bit (Device memory does
not require this on AArch64). PROT_DEFAULT should change to
pgprot_default | PTE_DIRTY.

> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> new file mode 100644
> index 0000000..1bad8a7
> --- /dev/null
> +++ b/arch/arm64/kernel/efi.c
> @@ -0,0 +1,507 @@
> +/*
> + * Extensible Firmware Interface
> + *
> + * Based on Extensible Firmware Interface Specification version 2.3.1
> + *
> + * Copyright (C) 2013 Linaro Ltd.
> + *
> + * Adapted for arm64 from arch/arm/kernel/efi.c code
> + */
> +
> +#include <linux/efi.h>
> +#include <linux/export.h>
> +#include <linux/memblock.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/bootmem.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/efi.h>
> +#include <asm/tlbflush.h>
> +#include <asm/mmu_context.h>
> +
> +#define efi_early_remap(a, b) \
> +       ((__force void *)early_ioremap((a), (b)))
> +#define efi_early_unmap(a, b) \
> +       early_iounmap((void __iomem *)(a), (b))

I lost track of the early_ioremap status for arm/arm64? Was there more
progress since October (I think)?

> +static int __init fdt_find_efi_params(unsigned long node, const char *uname,
> +                                     int depth, void *data)
> +{
> +       unsigned long len, size;
> +       __be32 *prop;
> +
> +       if (depth != 1 ||
> +           (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
> +               return 0;
> +
> +       pr_info("Getting EFI parameters from FDT.\n");
> +
> +       prop = of_get_flat_dt_prop(node, "linux,uefi-system-table", &len);
> +       if (!prop) {
> +               pr_err("No EFI system table in FDT\n");
> +               return 0;
> +       }
> +       efi_system_table = of_read_ulong(prop, len/4);
> +
> +       prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-start", &len);
> +       if (!prop) {
> +               pr_err("No EFI memmap in FDT\n");
> +               return 0;
> +       }
> +       memmap.phys_map = (void *)of_read_ulong(prop, len/4);
> +
> +       prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-size", &len);
> +       if (!prop) {
> +               pr_err("No EFI memmap size in FDT\n");
> +               return 0;
> +       }
> +       size = of_read_ulong(prop, len/4);
> +       memmap.map_end = memmap.phys_map + size;
> +
> +       /* reserve memmap */
> +       memblock_reserve((u64)memmap.phys_map, size);
> +
> +       prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-desc-size", &len);
> +       if (!prop) {
> +               pr_err("No EFI memmap descriptor size in FDT\n");
> +               return 0;
> +       }
> +       memmap.desc_size = of_read_ulong(prop, len/4);
> +
> +       memmap.nr_map = size / memmap.desc_size;
> +
> +       prop = of_get_flat_dt_prop(node, "linux,uefi-mmap-desc-ver", &len);
> +       if (!prop) {
> +               pr_err("No EFI memmap descriptor version in FDT\n");
> +               return 0;
> +       }
> +       memmap.desc_version = of_read_ulong(prop, len/4);
> +
> +       if (uefi_debug) {
> +               pr_info("  EFI system table @ %p\n", (void *)efi_system_table);
> +               pr_info("  EFI mmap @ %p-%p\n", memmap.phys_map,
> +                       memmap.map_end);
> +               pr_info("  EFI mmap descriptor size = 0x%lx\n",
> +                       memmap.desc_size);
> +               pr_info("  EFI mmap descriptor version = 0x%lx\n",
> +                       memmap.desc_version);
> +       }
> +
> +       return 1;
> +}

Are these checks generic to other architectures? We may do with some
helpers to avoid duplication.

> +
> +#define PGD_END  (&idmap_pg_dir[sizeof(idmap_pg_dir)/sizeof(pgd_t)])

Just &idmap_pg_dir[PTRS_PER_PGD] would do (or idmap_pg_dir +
ARRAY_SIZE(idmap_pg_dir)).

> +#ifndef CONFIG_SMP
> +#define PMD_FLAGS  (PMD_ATTRINDX(MT_NORMAL) | PMD_TYPE_SECT | PMD_SECT_AF)
> +#else
> +#define PMD_FLAGS  (PMD_ATTRINDX(MT_NORMAL) | PMD_TYPE_SECT | PMD_SECT_AF | \
> +                   PMD_SECT_S)
> +#endif
> +
> +static void __init create_idmap(unsigned long addr, unsigned long len)

I would change this to use the existing create_mapping() function which
takes care of allocating pud/pmd/ptes. We shouldn't duplicate this
functionality in two places. create_mapping() may need a slight change
since it assumes swapper_pg_dir but it's not much. It also uses
memblock_alloc() for early allocations.

> +static __init int memmap_walk(struct efi_memory_map *memmap,
> +                             int (*func)(efi_memory_desc_t *, void *),
> +                             void *private_data, int early)

Is this generic enough as a common helper between arm and arm64 (and
maybe x86)?

> +static __init int reserve_region(efi_memory_desc_t *md, void *priv)
[...]
> +static __init void reserve_regions(void)
[...]
> +static int __init remap_region(efi_memory_desc_t *md, void *priv)
[...]
> +static int __init remap_regions(efi_memory_desc_t *map)

Same here (I haven't looked at the other implementations).

> +/*
> + * Called from setup_arch with interrupts disabled.
> + */
> +void __init efi_enter_virtual_mode(void)
> +{
> +       void *newmap;
> +       efi_status_t status;
> +       u64 mapsize, total_freed = 0;
> +       int count;
> +
> +       if (!efi_enabled(EFI_BOOT)) {
> +               pr_info("EFI services will not be available.\n");
> +               return;
> +       }
> +
> +       pr_info("Remapping and enabling EFI services.\n");
> +
> +       mapsize = memmap.map_end - memmap.phys_map;
> +       memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
> +                                                  mapsize);
> +       memmap.map_end = memmap.map + mapsize;
> +
> +       /* Map the regions we reserved earlier */
> +       newmap = alloc_bootmem(mapsize);

memblock_alloc() (also check the other bootmem uses in this patch, arm64
is using memblock).

> +       if (newmap == NULL) {
> +               pr_err("Failed to allocate new EFI memmap\n");
> +               return;
> +       }
> +
> +       count = remap_regions(newmap);
> +       if (count <= 0) {
> +               pr_err("Failed to remap EFI regions.\n");
> +               return;
> +       }
> +
> +       efi.memmap = &memmap;
> +
> +       efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
> +       if (efi.systab)
> +               set_bit(EFI_SYSTEM_TABLES, &arm_efi_facility);
> +
> +       /*
> +        * efi.systab->runtime is a pointer to something guaranteed by
> +        * the UEFI specification to be 1:1 mapped.
> +        */
> +       runtime = (__force void *)efi_lookup_mapped_addr((u64)efi.systab->runtime);
> +
> +       /* Call SetVirtualAddressMap with the physical address of the map */
> +       efi.set_virtual_address_map = runtime->set_virtual_address_map;
> +
> +       /* boot time idmap_pg_dir is incomplete, so fill in missing parts */
> +       efi_setup_idmap();
> +
> +       cpu_switch_mm(idmap_pg_dir, &init_mm);
> +       flush_tlb_all();
> +       flush_cache_all();
> +
> +       status = efi.set_virtual_address_map(count * memmap.desc_size,
> +                                            memmap.desc_size,
> +                                            memmap.desc_version,
> +                                            newmap);
> +       cpu_set_reserved_ttbr0();
> +       flush_tlb_all();
> +       flush_cache_all();

What is the point of cache flusing here? See my comment in the first
patch about this not being guaranteed.

> +
> +       free_bootmem((unsigned long)newmap, mapsize);

memblock.

-- 
Catalin
