From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] arm64: extra entries in /proc/iomem for kexec
Date: Wed, 14 Mar 2018 08:39:23 +0000
Message-ID: <CAKv+Gu9AMS4sGoRsw0KNv6+3WZPXCJRfbxBnjaqnZugiZe4o9w@mail.gmail.com>
References: <20180314082941.GM25863@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20180314082941.GM25863-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jeff Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 14 March 2018 at 08:29, AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> In the last couples of months, there were some problems reported [1],[2]
> around arm64 kexec/kdump. Where those phenomenon look different,
> the root cause would be that kexec/kdump doesn't take into account
> crucial "reserved" regions of system memory and unintentionally corrupts
> them.
>
> Given that kexec-tools looks for all the information by seeking the file,
> /proc/iomem, the first step to address said problems is to expand this file's
> format so that it will have enough information about system memory and
> its usage.
>
> Attached is my experimental code: With this patch applied, /proc/iomem sees
> something like the below:
>
> (format A)
> 40000000-5871ffff : System RAM
>   40080000-40f1ffff : Kernel code
>   41040000-411e8fff : Kernel data
>   54400000-583fffff : Crash kernel
>   58590000-585effff : EFI Resources
>   58700000-5871ffff : EFI Resources
> 58720000-58b5ffff : System RAM
>   58720000-58b5ffff : EFI Resources
> 58b60000-5be3ffff : System RAM
>   58b61018-58b61947 : EFI Memory Map
>   59a7b118-59a7b667 : EFI Configuration Tables
> 5be40000-5becffff : System RAM                  <== (A-1)
>   5be40000-5becffff : EFI Resources
> 5bed0000-5bedffff : System RAM
> 5bee0000-5bffffff : System RAM
>   5bee0000-5bffffff : EFI Resources
> 5c000000-5fffffff : System RAM
> 8000000000-ffffffffff : PCI Bus 0000:00
>
> Meanwhile, the workaround I suggested in [3] gave us a simpler view:
>
> (format B)
> 40000000-5871ffff : System RAM
>   40080000-40f1ffff : Kernel code
>   41040000-411e9fff : Kernel data
>   54400000-583fffff : Crash kernel
>   58590000-585effff : reserved
>   58700000-5871ffff : reserved
> 58720000-58b5ffff : reserved
> 58b60000-5be3ffff : System RAM
>   58b61000-58b61fff : reserved
>   59a7b318-59a7b867 : reserved
> 5be40000-5becffff : reserved                    <== (B-1)
> 5bed0000-5bedffff : System RAM
> 5bee0000-5bffffff : reserved
> 5c000000-5fffffff : System RAM
>   5ec00000-5edfffff : reserved
> 8000000000-ffffffffff : PCI Bus 0000:00
>
> Here all the regions to be protected are named just "reserved" whether
> they are NOMAP regions or simply-memblock_reserve'd. They are not very
> useful for anything but kexec/kdump which knows what they mean.
>
> Alternatively, we may want to give them more specific names, based on
> related efi memory map descriptors and else, that will characterize
> their contents:
>
> (format C)
> 40000000-5871ffff : System RAM
>   40080000-40f1ffff : Kernel code
>   41040000-411e9fff : Kernel data
>   54400000-583fffff : Crash kernel
>   58590000-585effff : ACPI Reclaim Memory
>   58700000-5871ffff : ACPI Reclaim Memory
> 58720000-58b5ffff : System RAM
>   58720000-5878ffff : Runtime Data
>   58790000-587dffff : Runtime Code
>   587e0000-5882ffff : Runtime Data
>   58830000-5887ffff : Runtime Code
>   58880000-588cffff : Runtime Data
>   588d0000-5891ffff : Runtime Code
>   58920000-5896ffff : Runtime Data
>   58970000-589bffff : Runtime Code
>   589c0000-58a5ffff : Runtime Data
>   58a60000-58abffff : Runtime Code
>   58ac0000-58b0ffff : Runtime Data
>   58b10000-58b5ffff : Runtime Code
> 58b60000-5be3ffff : System RAM
>   58b61000-58b61fff : EFI Memory Map
>   59a7b118-59a7b667 : EFI Memory Attributes Table
> 5be40000-5becffff : System RAM
>   5be40000-5becffff : Runtime Code
> 5bed0000-5bedffff : System RAM
> 5bee0000-5bffffff : System RAM
>   5bee0000-5bffffff : Runtime Data
> 5c000000-5fffffff : System RAM
> 8000000000-ffffffffff : PCI Bus 0000:00
>
> I once created a patch for this format, but it looks quite noisy and
> names are a sort of mixture of memory attributes( ACPI Reclaim memory,
> Conventional Memory, Persistent Memory etc.) vs.
> function/usages ([Loader|Boot Service|Runtime] Code/Data).
> (As a matter of fact, (C-1) consists of various ACPI tables.)
> Anyhow, they seem not so useful for most of other applications.
>
> Those observations lead to format A, where some entries with the same
> attributes are squeezed into a single entry under a simple name if they
> are neighbouring.
>
>
> So my questions here are:
>
> 1. Which format, A, B, or C, is the most appropriate for the moment?
>    or any other suggestions?
>

I think some variant of B should be sufficient. The only meaningful
distinction between these reserved regions at a general level is
whether they are NOMAP or not, so perhaps we can incorporate that.

As for identifying things like EFI configuration tables: this is a
moving target, and we also define our own config tables for the TPM
log, screeninfo on ARM etc. Also, for EFI memory types, you can boot
with efi=debug and look at the entire memory map. So I think adding
all that information may be overkill.

> Currently, there is a inconsistent view between (A) and the mainline's:
> see (A-1) and (B-1). If this is really a matter, I can fix it.
> Kexec-tools can be easily modified to accept both formats, though.
>
>
> 2. How should we determine which regions be exported in /proc/iomem?
>
>  a. Trust all the memblock_reserve'd regions as my previous patch [3] does.
>
>     As I said, it's a kind of "overkill." Some of regions, say fdt, are
>     not required to be preserved across kexec.
>

I don't think there is anything wrong with listing all
memblock_reserve()'d regions here, even if kexec has other means of
ensuring that they are not touched. But as I said, I think it would be
useful to distinguish them from NOMAP regions (even if the nesting
below System RAM already shows that as well)


>  b. List regions separately and exhaustively later on at a single point
>     as my patch attached does.
>
>     I'm afraid of any possibility that some regions may be doubly counted,
>     one from efi memory map search and another from other efi/acpi code
>     (various type of "tables" in most cases).
>
>  c. Expand efi_mem_reserve() with an argument of "resource descriptor" and
>     replace memblock_reserve() in efi code wherever necessary so as to
>     maintain an export list.
>
>     efi_mem_reserve() was first introduced for specific needs at kexec
>     on x86, but I believe that its coverage over efi code is far from perfect.
>
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-November/541831.html
> [2] http://lkml.iu.edu//hypermail/linux/kernel/1802.2/06745.html
> [3] http://lkml.iu.edu//hypermail/linux/kernel/1803.0/04658.html
>     http://lkml.iu.edu//hypermail/linux/kernel/1803.0/04659.html
>
> -Takahiro AKASHI
>
> ===8<===
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 30ad2f085d1f..feda5cbdc6bf 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -214,13 +214,8 @@ static void __init request_standard_resources(void)
>
>         for_each_memblock(memory, region) {
>                 res = alloc_bootmem_low(sizeof(*res));
> -               if (memblock_is_nomap(region)) {
> -                       res->name  = "reserved";
> -                       res->flags = IORESOURCE_MEM;
> -               } else {
> -                       res->name  = "System RAM";
> -                       res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
> -               }
> +               res->name  = "System RAM";
> +               res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
>                 res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
>                 res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
>
> @@ -239,6 +234,9 @@ static void __init request_standard_resources(void)
>                         request_resource(res, &crashk_res);
>  #endif
>         }
> +
> +       /* Add firmware-reserved memory */
> +       efi_arch_request_resources();
>  }
>
>  u64 __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index 80d1a885def5..308143e69db4 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -13,8 +13,10 @@
>
>  #define pr_fmt(fmt)    "efi: " fmt
>
> +#include <linux/bootmem.h>
>  #include <linux/efi.h>
>  #include <linux/init.h>
> +#include <linux/ioport.h>
>  #include <linux/memblock.h>
>  #include <linux/mm_types.h>
>  #include <linux/of.h>
> @@ -280,3 +282,97 @@ static int __init register_gop_device(void)
>         return PTR_ERR_OR_ZERO(pd);
>  }
>  subsys_initcall(register_gop_device);
> +
> +static unsigned long __init efi_memattr_to_iores_type(u64 addr)
> +{
> +       if (efi_mem_attributes(addr) &
> +                       (EFI_MEMORY_WB|EFI_MEMORY_WT|EFI_MEMORY_WC))
> +               return IORESOURCE_SYSTEM_RAM;
> +       else
> +               return IORESOURCE_MEM;
> +}
> +
> +static unsigned long __init efi_type_to_iores_desc(u64 addr)
> +{
> +       /* TODO */
> +       return IORES_DESC_NONE;
> +}
> +
> +static struct resource * __init _efi_arch_request_resource(u64 start, u64 end,
> +                                       char *name, struct resource *prev)
> +{
> +       struct resource *conflict, *res;
> +
> +       res = alloc_bootmem_low(sizeof(*res));
> +
> +       res->start = start;
> +       res->end = end;
> +       res->flags = efi_memattr_to_iores_type(res->start);
> +       res->desc = efi_type_to_iores_desc(res->start);
> +       res->name = name;
> +
> +       conflict = request_resource_conflict(&iomem_resource, res);
> +       if (conflict) {
> +               if (prev && (prev->parent == conflict) &&
> +                               ((prev->end + 1) == start)) {
> +                       /* merge consecutive regions */
> +                       adjust_resource(prev, prev->start,
> +                                                       end - prev->start + 1);
> +                       free_bootmem((unsigned long)res, sizeof(*res));
> +                       res = prev;
> +               } else
> +                       insert_resource(conflict, res);
> +       }
> +
> +       return res;
> +}
> +
> +/* Kexec expects those resources to be preserved */
> +void __init efi_arch_request_resources(void)
> +{
> +       struct resource *res = NULL;
> +       efi_memory_desc_t *md;
> +       u64 paddr, npages, size;
> +
> +       /* EFI Memory Map */
> +       /* FIXME */
> +       _efi_arch_request_resource(efi.memmap.phys_map,
> +                       efi.memmap.phys_map
> +                       + efi.memmap.desc_size * efi.memmap.nr_map - 1,
> +                       "EFI Memory Map", res);
> +
> +       /* generic EFI Configuration Tables */
> +       efi_request_config_table_resources(_efi_arch_request_resource);
> +
> +       /* architecture-specifc Configuration Tables */
> +       if (screen_info.lfb_size)
> +               _efi_arch_request_resource(screen_info.lfb_base,
> +                               screen_info.lfb_base + screen_info.lfb_size - 1,
> +                               "EFI Screen Info Table", res);
> +
> +       /* architecture-specific EFI resources */
> +       /* FIXME */
> +       efi_memmap_install(efi.memmap.phys_map, efi.memmap.nr_map);
> +
> +       res = NULL;
> +       for_each_efi_memory_desc(md) {
> +               paddr = md->phys_addr;
> +               npages = md->num_pages;
> +
> +               memrange_efi_to_native(&paddr, &npages);
> +               size = npages << PAGE_SHIFT;
> +
> +               if (is_memory(md)) {
> +                       if (!is_usable_memory(md))
> +                               res = _efi_arch_request_resource(paddr,
> +                                               paddr + size - 1,
> +                                               "EFI Resources", res);
> +
> +                       if (md->type == EFI_ACPI_RECLAIM_MEMORY)
> +                               res = _efi_arch_request_resource(paddr,
> +                                               paddr + size - 1,
> +                                               "EFI Resources", res);
> +               }
> +       }
> +       efi_memmap_unmap();
> +}
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index cd42f66a7c85..b13c9461278b 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -603,6 +603,33 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
>         return ret;
>  }
>
> +void __init efi_request_config_table_resources(struct resource *(*fn)(u64 start,
> +                               u64 end, char *name, struct resource *prev))
> +{
> +       struct resource *prev = NULL;
> +       char *name = "EFI Configuration Tables";
> +
> +       if (efi.config_table_size)
> +               prev = fn(efi.config_table,
> +                       efi.config_table + efi.config_table_size - 1, name,
> +                                                                       prev);
> +
> +       if (efi.mem_attr_table_size)
> +               prev = fn(efi.mem_attr_table,
> +                       efi.mem_attr_table + efi.mem_attr_table_size - 1, name,
> +                                                                       prev);
> +
> +       if (efi.esrt_size)
> +               prev = fn(efi.esrt, efi.esrt + efi.esrt_size - 1, name, prev);
> +
> +       if (efi.tpm_log_size)
> +               prev = fn(efi.tpm_log, efi.tpm_log + efi.tpm_log_size - 1, name,
> +                                                                       prev);
> +
> +
> +       /* TODO: BGRT */
> +}
> +
>  #ifdef CONFIG_EFI_VARS_MODULE
>  static int __init efi_load_efivars(void)
>  {
> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> index c47e0c6ec00f..61f66c139afb 100644
> --- a/drivers/firmware/efi/esrt.c
> +++ b/drivers/firmware/efi/esrt.c
> @@ -330,6 +330,7 @@ void __init efi_esrt_init(void)
>
>         esrt_data = (phys_addr_t)efi.esrt;
>         esrt_data_size = size;
> +       efi.esrt_size = size;
>
>         end = esrt_data + size;
>         pr_info("Reserving ESRT space from %pa to %pa.\n", &esrt_data, &end);
> diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
> index 8986757eafaf..dc2c7608793a 100644
> --- a/drivers/firmware/efi/memattr.c
> +++ b/drivers/firmware/efi/memattr.c
> @@ -42,6 +42,7 @@ int __init efi_memattr_init(void)
>         }
>
>         tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
> +       efi.mem_attr_table_size = tbl_size;
>         memblock_reserve(efi.mem_attr_table, tbl_size);
>         set_bit(EFI_MEM_ATTR, &efi.flags);
>
> diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
> index 0cbeb3d46b18..53cfb12513fa 100644
> --- a/drivers/firmware/efi/tpm.c
> +++ b/drivers/firmware/efi/tpm.c
> @@ -33,6 +33,7 @@ int __init efi_tpm_eventlog_init(void)
>         }
>
>         tbl_size = sizeof(*log_tbl) + log_tbl->size;
> +       efi.tpm_log_size = tbl_size;
>         memblock_reserve(efi.tpm_log, tbl_size);
>         early_memunmap(log_tbl, sizeof(*log_tbl));
>         return 0;
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index f5083aa72eae..9c3f8d284b36 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -942,11 +942,15 @@ extern struct efi {
>         unsigned long fw_vendor;        /* fw_vendor */
>         unsigned long runtime;          /* runtime table */
>         unsigned long config_table;     /* config tables */
> +       unsigned long config_table_size;
>         unsigned long esrt;             /* ESRT table */
> +       unsigned long esrt_size;
>         unsigned long properties_table; /* properties table */
>         unsigned long mem_attr_table;   /* memory attributes table */
> +       unsigned long mem_attr_table_size;
>         unsigned long rng_seed;         /* UEFI firmware random seed */
>         unsigned long tpm_log;          /* TPM2 Event Log table */
> +       unsigned long tpm_log_size;
>         efi_get_time_t *get_time;
>         efi_set_time_t *set_time;
>         efi_get_wakeup_time_t *get_wakeup_time;
> @@ -980,6 +984,9 @@ efi_guid_to_str(efi_guid_t *guid, char *out)
>  }
>
>  extern void efi_init (void);
> +extern void efi_arch_request_resources(void);
> +extern void efi_request_config_table_resources(struct resource *
> +               (*fn)(u64 start, u64 end, char *name, struct resource *prev));
>  extern void *efi_get_pal_addr (void);
>  extern void efi_map_pal_code (void);
>  extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
