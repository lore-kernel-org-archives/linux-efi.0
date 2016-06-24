From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/11] efi: Refactor efi_memmap_init_early() into
 arch-neutral code
Date: Fri, 24 Jun 2016 13:44:48 +0200
Message-ID: <CAKv+Gu_n9eVL6mNtrLQWdCwde9oLfkGYV5CnqLhSPO31Aehpzw@mail.gmail.com>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk> <1466681690-5850-4-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466681690-5850-4-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

On 23 June 2016 at 13:34, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> Every EFI architecture apart from ia64 needs to setup the EFI memory
> map at efi.memmap, and the code for doing that is essentially the same
> across all implementations. Therefore, it makes sense to factor this
> out into the common code under drivers/firmware/efi/.
>
> The only slight variation is the data structure out of which we pull
> the initial memory map information, such as physical address, memory
> descriptor size and version, etc. We can address this by passing a
> generic data structure (struct efi_memory_map_data) as the argument to
> efi_memmap_init_early() which contains the minimum info required for
> initialising the memory map.
>
> In the process, this patch also fixes a few undesirable implementation
> differences:
>
>  - ARM and arm64 were failing to clear the EFI_MEMMAP bit when
>    unmapping the early EFI memory map. EFI_MEMMAP indicates whether
>    the EFI memory map is mapped (not the regions contained within) and
>    can be traversed.  It's more correct to set the bit as soon as we
>    memremap() the passed in EFI memmap.
>

This patch (and the series) looks mostly fine to me, but this patch
does break ARM currently, please see below.

>  - Rename efi_unmmap_memmap() to efi_memmap_unmap() to adhere to the
>    regular naming scheme.
>
> This patch also uses a read-write mapping for the memory map instead
> of the read-only mapping currently used on ARM and arm64. x86 needs
> the ability to update the memory map in-place when assigning virtual
> addresses to regions (efi_map_region()) and tagging regions when
> reserving boot services (efi_reserve_boot_services()).
>
> There's no way for the generic fake_mem code to know which mapping to
> use without introducing some arch-specific constant/hook, so just use
> read-write since read-only is of dubious value for the EFI memory map.
>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h      |  1 -
>  arch/x86/platform/efi/efi.c     | 66 +++++++++++------------------------------
>  arch/x86/platform/efi/quirks.c  |  4 +--
>  drivers/firmware/efi/arm-init.c | 17 +++++------
>  drivers/firmware/efi/efi.c      | 46 ++++++++++++++++++++++++++++
>  drivers/firmware/efi/fake_mem.c | 15 ++++++----
>  include/linux/efi.h             | 16 ++++++++++
>  7 files changed, 98 insertions(+), 67 deletions(-)
>
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 78d1e7467eae..67983035bd7b 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -118,7 +118,6 @@ extern int __init efi_memblock_x86_reserve_range(void);
>  extern pgd_t * __init efi_call_phys_prolog(void);
>  extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
>  extern void __init efi_print_memmap(void);
> -extern void __init efi_unmap_memmap(void);
>  extern void __init efi_memory_uc(u64 addr, unsigned long size);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
>  extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 7c3d9092c668..b434c887229c 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -188,7 +188,9 @@ static void __init do_add_efi_memmap(void)
>  int __init efi_memblock_x86_reserve_range(void)
>  {
>         struct efi_info *e = &boot_params.efi_info;
> +       struct efi_memory_map_data data;
>         phys_addr_t pmap;
> +       int rv;
>
>         if (efi_enabled(EFI_PARAVIRT))
>                 return 0;
> @@ -203,11 +205,17 @@ int __init efi_memblock_x86_reserve_range(void)
>  #else
>         pmap = (e->efi_memmap | ((__u64)e->efi_memmap_hi << 32));
>  #endif
> -       efi.memmap.phys_map     = pmap;
> -       efi.memmap.nr_map       = e->efi_memmap_size /
> -                                 e->efi_memdesc_size;
> -       efi.memmap.desc_size    = e->efi_memdesc_size;
> -       efi.memmap.desc_version = e->efi_memdesc_version;
> +       data.phys_map           = pmap;
> +       data.size               = e->efi_memmap_size;
> +       data.desc_size          = e->efi_memdesc_size;
> +       data.desc_version       = e->efi_memdesc_version;
> +
> +       rv = efi_memmap_init_early(&data);
> +       if (rv)
> +               return rv;
> +
> +       if (add_efi_memmap)
> +               do_add_efi_memmap();
>
>         WARN(efi.memmap.desc_version != 1,
>              "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
> @@ -234,19 +242,6 @@ void __init efi_print_memmap(void)
>         }
>  }
>
> -void __init efi_unmap_memmap(void)
> -{
> -       unsigned long size;
> -
> -       clear_bit(EFI_MEMMAP, &efi.flags);
> -
> -       size = efi.memmap.nr_map * efi.memmap.desc_size;
> -       if (efi.memmap.map) {
> -               early_memunmap(efi.memmap.map, size);
> -               efi.memmap.map = NULL;
> -       }
> -}
> -
>  static int __init efi_systab_init(void *phys)
>  {
>         if (efi_enabled(EFI_64BIT)) {
> @@ -430,33 +425,6 @@ static int __init efi_runtime_init(void)
>         return 0;
>  }
>
> -static int __init efi_memmap_init(void)
> -{
> -       unsigned long addr, size;
> -
> -       if (efi_enabled(EFI_PARAVIRT))
> -               return 0;
> -
> -       /* Map the EFI memory map */
> -       size = efi.memmap.nr_map * efi.memmap.desc_size;
> -       addr = (unsigned long)efi.memmap.phys_map;
> -
> -       efi.memmap.map = early_memremap(addr, size);
> -       if (efi.memmap.map == NULL) {
> -               pr_err("Could not map the memory map!\n");
> -               return -ENOMEM;
> -       }
> -
> -       efi.memmap.map_end = efi.memmap.map + size;
> -
> -       if (add_efi_memmap)
> -               do_add_efi_memmap();
> -
> -       set_bit(EFI_MEMMAP, &efi.flags);
> -
> -       return 0;
> -}
> -
>  void __init efi_init(void)
>  {
>         efi_char16_t *c16;
> @@ -514,11 +482,11 @@ void __init efi_init(void)
>         if (!efi_runtime_supported())
>                 pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
>         else {
> -               if (efi_runtime_disabled() || efi_runtime_init())
> +               if (efi_runtime_disabled() || efi_runtime_init()) {
> +                       efi_memmap_unmap();
>                         return;
> +               }
>         }
> -       if (efi_memmap_init())
> -               return;
>
>         if (efi_enabled(EFI_DBG))
>                 efi_print_memmap();
> @@ -855,7 +823,7 @@ static void __init kexec_enter_virtual_mode(void)
>          * non-native EFI
>          */
>         if (!efi_is_native()) {
> -               efi_unmap_memmap();
> +               efi_memmap_unmap();
>                 clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>                 return;
>         }
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 4480c06cade7..0af180004e74 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -266,7 +266,7 @@ void __init efi_free_boot_services(void)
>                 free_bootmem_late(start, size);
>         }
>
> -       efi_unmap_memmap();
> +       efi_memmap_unmap();
>  }
>
>  /*
> @@ -344,7 +344,7 @@ void __init efi_apply_memmap_quirks(void)
>          */
>         if (!efi_runtime_supported()) {
>                 pr_info("Setup done, disabling due to 32/64-bit mismatch\n");
> -               efi_unmap_memmap();
> +               efi_memmap_unmap();
>         }
>
>         /* UV2+ BIOS has a fix for this issue.  UV1 still needs the quirk. */
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index c49d50e68aee..5a2df3fefccc 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -211,12 +211,11 @@ static __init void reserve_regions(void)
>                         memblock_mark_nomap(paddr, size);
>
>         }
> -
> -       set_bit(EFI_MEMMAP, &efi.flags);
>  }
>
>  void __init efi_init(void)
>  {
> +       struct efi_memory_map_data data;
>         struct efi_fdt_params params;
>
>         /* Grab UEFI information placed in FDT by stub */
> @@ -225,9 +224,12 @@ void __init efi_init(void)
>
>         efi_system_table = params.system_table;
>
> -       efi.memmap.phys_map = params.mmap;
> -       efi.memmap.map = early_memremap_ro(params.mmap, params.mmap_size);
> -       if (efi.memmap.map == NULL) {
> +       data.desc_version = params.desc_ver;
> +       data.desc_size = params.desc_size;
> +       data.size = params.mmap_size;
> +       data.phys_map = params.mmap;
> +
> +       if (efi_memmap_init_early(&data) < 0) {
>                 /*
>                 * If we are booting via UEFI, the UEFI memory map is the only
>                 * description of memory we have, so there is little point in
> @@ -235,9 +237,6 @@ void __init efi_init(void)
>                 */
>                 panic("Unable to map EFI memory map.\n");
>         }
> -       efi.memmap.map_end = efi.memmap.map + params.mmap_size;
> -       efi.memmap.desc_size = params.desc_size;
> -       efi.memmap.desc_version = params.desc_ver;
>
>         WARN(efi.memmap.desc_version != 1,
>              "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
> @@ -248,7 +247,7 @@ void __init efi_init(void)
>
>         reserve_regions();
>         efi_memattr_init();
> -       early_memunmap(efi.memmap.map, params.mmap_size);
> +       efi_memmap_unmap();
>
>         memblock_reserve(params.mmap & PAGE_MASK,
>                          PAGE_ALIGN(params.mmap_size +
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 05509f3aaee8..3e6dce71f54d 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -448,6 +448,52 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
>         return ret;
>  }
>
> +/**
> + * efi_memmap_init_early - Map the EFI memory map data structure
> + * @data: EFI memory map data
> + *
> + * Use early_memremap() to map the passed in EFI memory map and assign
> + * it to efi.memmap.
> + */
> +int __init efi_memmap_init_early(struct efi_memory_map_data *data)
> +{
> +       struct efi_memory_map map;
> +
> +       if (efi_enabled(EFI_PARAVIRT))
> +               return 0;
> +
> +       map.phys_map = data->phys_map;
> +
> +       map.map = early_memremap(data->phys_map, data->size);
> +       if (!map.map) {
> +               pr_err("Could not map the memory map!\n");
> +               return -ENOMEM;
> +       }
> +
> +       map.nr_map = data->size / data->desc_size;
> +       map.map_end = map.map + data->size;
> +
> +       map.desc_version = data->desc_version;
> +       map.desc_size = data->desc_size;
> +
> +       set_bit(EFI_MEMMAP, &efi.flags);
> +
> +       efi.memmap = map;
> +
> +       return 0;
> +}
> +
> +void __init efi_memmap_unmap(void)
> +{
> +       unsigned long size;
> +
> +       size = efi.memmap.desc_size * efi.memmap.nr_map;
> +
> +       early_memunmap(efi.memmap.map, size);
> +       efi.memmap.map = NULL;

This assignment breaks the calculation of mapsize in
arm_enable_runtime_services(), so you should probably fold the
following hunk into this patch.

diff --git a/drivers/firmware/efi/arm-runtime.c
b/drivers/firmware/efi/arm-runtime.c
index ce1424672d89..1884347a3ef6 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -109,7 +109,7 @@ static int __init arm_enable_runtime_services(void)

        pr_info("Remapping and enabling EFI services.\n");

-       mapsize = efi.memmap.map_end - efi.memmap.map;
+       mapsize = efi.memmap.desc_size * efi.memmap.nr_map;

        if (efi_memmap_init_late(efi.memmap.phys_map, mapsize)) {
                pr_err("Failed to remap EFI memory map\n");


With that change (or an equivalent one):

Tested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
