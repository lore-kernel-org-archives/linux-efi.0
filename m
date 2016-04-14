From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] efi: Remove global 'memmap'
Date: Thu, 14 Apr 2016 15:53:55 +0200
Message-ID: <CAKv+Gu9DUo9ahdf0XgFDpvNKV5bmiwDJOSemgLOkV7BT+r0mCw@mail.gmail.com>
References: <1460636019-18593-1-git-send-email-matt@codeblueprint.co.uk>
	<1460636019-18593-3-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460636019-18593-3-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 14 April 2016 at 14:13, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> Abolish the poorly named EFI memory map, 'memmap'. It is shadowed by a
> bunch of local definitions in various files and having two ways to
> access the EFI memory map ('efi.memmap' vs 'memmap') is rather
> confusing.
>
> Furthermore, ia64 doesn't even provide this global object, which has
> caused issues when trying to write generic EFI memmap code.
>
> Replace all occurrences with efi.memmap, and convert the remaining
> iterator code to use for_each_efi_mem_desc().
>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
> Changes in v2:
>  - Do not introduce new 'phys_map' variable per Ard

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

>
>  arch/x86/platform/efi/efi.c        | 84 +++++++++++++++++++++-----------------
>  drivers/firmware/efi/arm-init.c    | 20 ++++-----
>  drivers/firmware/efi/arm-runtime.c | 12 +++---
>  drivers/firmware/efi/efi.c         |  2 +-
>  drivers/firmware/efi/fake_mem.c    | 40 +++++++++---------
>  include/linux/efi.h                |  5 +--
>  6 files changed, 85 insertions(+), 78 deletions(-)
>
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 6f499819a27f..88d2fb2cb3ef 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -56,8 +56,6 @@
>
>  #define EFI_DEBUG
>
> -struct efi_memory_map memmap;
> -
>  static struct efi efi_phys __initdata;
>  static efi_system_table_t efi_systab __initdata;
>
> @@ -207,15 +205,13 @@ int __init efi_memblock_x86_reserve_range(void)
>  #else
>         pmap = (e->efi_memmap | ((__u64)e->efi_memmap_hi << 32));
>  #endif
> -       memmap.phys_map         = pmap;
> -       memmap.nr_map           = e->efi_memmap_size /
> +       efi.memmap.phys_map     = pmap;
> +       efi.memmap.nr_map       = e->efi_memmap_size /
>                                   e->efi_memdesc_size;
> -       memmap.desc_size        = e->efi_memdesc_size;
> -       memmap.desc_version     = e->efi_memdesc_version;
> -
> -       memblock_reserve(pmap, memmap.nr_map * memmap.desc_size);
> +       efi.memmap.desc_size    = e->efi_memdesc_size;
> +       efi.memmap.desc_version = e->efi_memdesc_version;
>
> -       efi.memmap = &memmap;
> +       memblock_reserve(pmap, efi.memmap.nr_map * efi.memmap.desc_size);
>
>         return 0;
>  }
> @@ -240,10 +236,14 @@ void __init efi_print_memmap(void)
>
>  void __init efi_unmap_memmap(void)
>  {
> +       unsigned long size;
> +
>         clear_bit(EFI_MEMMAP, &efi.flags);
> -       if (memmap.map) {
> -               early_memunmap(memmap.map, memmap.nr_map * memmap.desc_size);
> -               memmap.map = NULL;
> +
> +       size = efi.memmap.nr_map * efi.memmap.desc_size;
> +       if (efi.memmap.map) {
> +               early_memunmap(efi.memmap.map, size);
> +               efi.memmap.map = NULL;
>         }
>  }
>
> @@ -432,17 +432,22 @@ static int __init efi_runtime_init(void)
>
>  static int __init efi_memmap_init(void)
>  {
> +       unsigned long addr, size;
> +
>         if (efi_enabled(EFI_PARAVIRT))
>                 return 0;
>
>         /* Map the EFI memory map */
> -       memmap.map = early_memremap((unsigned long)memmap.phys_map,
> -                                  memmap.nr_map * memmap.desc_size);
> -       if (memmap.map == NULL) {
> +       size = efi.memmap.nr_map * efi.memmap.desc_size;
> +       addr = (unsigned long)efi.memmap.phys_map;
> +
> +       efi.memmap.map = early_memremap(addr, size);
> +       if (efi.memmap.map == NULL) {
>                 pr_err("Could not map the memory map!\n");
>                 return -ENOMEM;
>         }
> -       memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
> +
> +       efi.memmap.map_end = efi.memmap.map + size;
>
>         if (add_efi_memmap)
>                 do_add_efi_memmap();
> @@ -638,6 +643,7 @@ static void __init get_systab_virt_addr(efi_memory_desc_t *md)
>  static void __init save_runtime_map(void)
>  {
>  #ifdef CONFIG_KEXEC_CORE
> +       unsigned long desc_size;
>         efi_memory_desc_t *md;
>         void *tmp, *q = NULL;
>         int count = 0;
> @@ -645,21 +651,23 @@ static void __init save_runtime_map(void)
>         if (efi_enabled(EFI_OLD_MEMMAP))
>                 return;
>
> +       desc_size = efi.memmap.desc_size;
> +
>         for_each_efi_memory_desc(md) {
>                 if (!(md->attribute & EFI_MEMORY_RUNTIME) ||
>                     (md->type == EFI_BOOT_SERVICES_CODE) ||
>                     (md->type == EFI_BOOT_SERVICES_DATA))
>                         continue;
> -               tmp = krealloc(q, (count + 1) * memmap.desc_size, GFP_KERNEL);
> +               tmp = krealloc(q, (count + 1) * desc_size, GFP_KERNEL);
>                 if (!tmp)
>                         goto out;
>                 q = tmp;
>
> -               memcpy(q + count * memmap.desc_size, md, memmap.desc_size);
> +               memcpy(q + count * desc_size, md, desc_size);
>                 count++;
>         }
>
> -       efi_runtime_map_setup(q, count, memmap.desc_size);
> +       efi_runtime_map_setup(q, count, desc_size);
>         return;
>
>  out:
> @@ -699,10 +707,10 @@ static inline void *efi_map_next_entry_reverse(void *entry)
>  {
>         /* Initial call */
>         if (!entry)
> -               return memmap.map_end - memmap.desc_size;
> +               return efi.memmap.map_end - efi.memmap.desc_size;
>
> -       entry -= memmap.desc_size;
> -       if (entry < memmap.map)
> +       entry -= efi.memmap.desc_size;
> +       if (entry < efi.memmap.map)
>                 return NULL;
>
>         return entry;
> @@ -744,10 +752,10 @@ static void *efi_map_next_entry(void *entry)
>
>         /* Initial call */
>         if (!entry)
> -               return memmap.map;
> +               return efi.memmap.map;
>
> -       entry += memmap.desc_size;
> -       if (entry >= memmap.map_end)
> +       entry += efi.memmap.desc_size;
> +       if (entry >= efi.memmap.map_end)
>                 return NULL;
>
>         return entry;
> @@ -761,8 +769,11 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
>  {
>         void *p, *new_memmap = NULL;
>         unsigned long left = 0;
> +       unsigned long desc_size;
>         efi_memory_desc_t *md;
>
> +       desc_size = efi.memmap.desc_size;
> +
>         p = NULL;
>         while ((p = efi_map_next_entry(p))) {
>                 md = p;
> @@ -777,7 +788,7 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
>                 efi_map_region(md);
>                 get_systab_virt_addr(md);
>
> -               if (left < memmap.desc_size) {
> +               if (left < desc_size) {
>                         new_memmap = realloc_pages(new_memmap, *pg_shift);
>                         if (!new_memmap)
>                                 return NULL;
> @@ -786,10 +797,9 @@ static void * __init efi_map_regions(int *count, int *pg_shift)
>                         (*pg_shift)++;
>                 }
>
> -               memcpy(new_memmap + (*count * memmap.desc_size), md,
> -                      memmap.desc_size);
> +               memcpy(new_memmap + (*count * desc_size), md, desc_size);
>
> -               left -= memmap.desc_size;
> +               left -= desc_size;
>                 (*count)++;
>         }
>
> @@ -833,10 +843,10 @@ static void __init kexec_enter_virtual_mode(void)
>
>         BUG_ON(!efi.systab);
>
> -       num_pages = ALIGN(memmap.nr_map * memmap.desc_size, PAGE_SIZE);
> +       num_pages = ALIGN(efi.memmap.nr_map * efi.memmap.desc_size, PAGE_SIZE);
>         num_pages >>= PAGE_SHIFT;
>
> -       if (efi_setup_page_tables(memmap.phys_map, num_pages)) {
> +       if (efi_setup_page_tables(efi.memmap.phys_map, num_pages)) {
>                 clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>                 return;
>         }
> @@ -920,16 +930,16 @@ static void __init __efi_enter_virtual_mode(void)
>
>         if (efi_is_native()) {
>                 status = phys_efi_set_virtual_address_map(
> -                               memmap.desc_size * count,
> -                               memmap.desc_size,
> -                               memmap.desc_version,
> +                               efi.memmap.desc_size * count,
> +                               efi.memmap.desc_size,
> +                               efi.memmap.desc_version,
>                                 (efi_memory_desc_t *)__pa(new_memmap));
>         } else {
>                 status = efi_thunk_set_virtual_address_map(
>                                 efi_phys.set_virtual_address_map,
> -                               memmap.desc_size * count,
> -                               memmap.desc_size,
> -                               memmap.desc_version,
> +                               efi.memmap.desc_size * count,
> +                               efi.memmap.desc_size,
> +                               efi.memmap.desc_version,
>                                 (efi_memory_desc_t *)__pa(new_memmap));
>         }
>
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index 96e7fe548164..275187a86a19 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -20,8 +20,6 @@
>
>  #include <asm/efi.h>
>
> -struct efi_memory_map memmap;
> -
>  u64 efi_system_table;
>
>  static int __init is_normal_ram(efi_memory_desc_t *md)
> @@ -40,7 +38,7 @@ static phys_addr_t efi_to_phys(unsigned long addr)
>  {
>         efi_memory_desc_t *md;
>
> -       for_each_efi_memory_desc_in_map(&memmap, md) {
> +       for_each_efi_memory_desc(md) {
>                 if (!(md->attribute & EFI_MEMORY_RUNTIME))
>                         continue;
>                 if (md->virt_addr == 0)
> @@ -145,7 +143,7 @@ static __init void reserve_regions(void)
>         if (efi_enabled(EFI_DBG))
>                 pr_info("Processing EFI memory map:\n");
>
> -       for_each_efi_memory_desc_in_map(&memmap, md) {
> +       for_each_efi_memory_desc(md) {
>                 paddr = md->phys_addr;
>                 npages = md->num_pages;
>
> @@ -186,9 +184,9 @@ void __init efi_init(void)
>
>         efi_system_table = params.system_table;
>
> -       memmap.phys_map = params.mmap;
> -       memmap.map = early_memremap_ro(params.mmap, params.mmap_size);
> -       if (memmap.map == NULL) {
> +       efi.memmap.phys_map = params.mmap;
> +       efi.memmap.map = early_memremap_ro(params.mmap, params.mmap_size);
> +       if (efi.memmap.map == NULL) {
>                 /*
>                 * If we are booting via UEFI, the UEFI memory map is the only
>                 * description of memory we have, so there is little point in
> @@ -196,15 +194,15 @@ void __init efi_init(void)
>                 */
>                 panic("Unable to map EFI memory map.\n");
>         }
> -       memmap.map_end = memmap.map + params.mmap_size;
> -       memmap.desc_size = params.desc_size;
> -       memmap.desc_version = params.desc_ver;
> +       efi.memmap.map_end = efi.memmap.map + params.mmap_size;
> +       efi.memmap.desc_size = params.desc_size;
> +       efi.memmap.desc_version = params.desc_ver;
>
>         if (uefi_init() < 0)
>                 return;
>
>         reserve_regions();
> -       early_memunmap(memmap.map, params.mmap_size);
> +       early_memunmap(efi.memmap.map, params.mmap_size);
>         memblock_mark_nomap(params.mmap & PAGE_MASK,
>                             PAGE_ALIGN(params.mmap_size +
>                                        (params.mmap & ~PAGE_MASK)));
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> index 1cfbfaf57a2d..55a9ea041068 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -103,15 +103,15 @@ static int __init arm_enable_runtime_services(void)
>
>         pr_info("Remapping and enabling EFI services.\n");
>
> -       mapsize = memmap.map_end - memmap.map;
> -       memmap.map = (__force void *)ioremap_cache(memmap.phys_map,
> -                                                  mapsize);
> -       if (!memmap.map) {
> +       mapsize = efi.memmap.map_end - efi.memmap.map;
> +
> +       efi.memmap.map = (__force void *)ioremap_cache(efi.memmap.phys_map,
> +                                                      mapsize);
> +       if (!efi.memmap.map) {
>                 pr_err("Failed to remap EFI memory map\n");
>                 return -ENOMEM;
>         }
> -       memmap.map_end = memmap.map + mapsize;
> -       efi.memmap = &memmap;
> +       efi.memmap.map_end = efi.memmap.map + mapsize;
>
>         if (!efi_virtmap_init()) {
>                 pr_err("UEFI virtual mapping missing or invalid -- runtime services will not be available\n");
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 4b533ce73374..f7d36c6cc1ad 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -256,7 +256,7 @@ subsys_initcall(efisubsys_init);
>   */
>  int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
>  {
> -       struct efi_memory_map *map = efi.memmap;
> +       struct efi_memory_map *map = &efi.memmap;
>         phys_addr_t p, e;
>
>         if (!efi_enabled(EFI_MEMMAP)) {
> diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
> index f55b75b2e1f4..48430aba13c1 100644
> --- a/drivers/firmware/efi/fake_mem.c
> +++ b/drivers/firmware/efi/fake_mem.c
> @@ -57,7 +57,7 @@ static int __init cmp_fake_mem(const void *x1, const void *x2)
>  void __init efi_fake_memmap(void)
>  {
>         u64 start, end, m_start, m_end, m_attr;
> -       int new_nr_map = memmap.nr_map;
> +       int new_nr_map = efi.memmap.nr_map;
>         efi_memory_desc_t *md;
>         phys_addr_t new_memmap_phy;
>         void *new_memmap;
> @@ -94,25 +94,25 @@ void __init efi_fake_memmap(void)
>         }
>
>         /* allocate memory for new EFI memmap */
> -       new_memmap_phy = memblock_alloc(memmap.desc_size * new_nr_map,
> +       new_memmap_phy = memblock_alloc(efi.memmap.desc_size * new_nr_map,
>                                         PAGE_SIZE);
>         if (!new_memmap_phy)
>                 return;
>
>         /* create new EFI memmap */
>         new_memmap = early_memremap(new_memmap_phy,
> -                                   memmap.desc_size * new_nr_map);
> +                                   efi.memmap.desc_size * new_nr_map);
>         if (!new_memmap) {
> -               memblock_free(new_memmap_phy, memmap.desc_size * new_nr_map);
> +               memblock_free(new_memmap_phy, efi.memmap.desc_size * new_nr_map);
>                 return;
>         }
>
> -       for (old = memmap.map, new = new_memmap;
> -            old < memmap.map_end;
> -            old += memmap.desc_size, new += memmap.desc_size) {
> +       for (old = efi.memmap.map, new = new_memmap;
> +            old < efi.memmap.map_end;
> +            old += efi.memmap.desc_size, new += efi.memmap.desc_size) {
>
>                 /* copy original EFI memory descriptor */
> -               memcpy(new, old, memmap.desc_size);
> +               memcpy(new, old, efi.memmap.desc_size);
>                 md = new;
>                 start = md->phys_addr;
>                 end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
> @@ -133,8 +133,8 @@ void __init efi_fake_memmap(void)
>                                 md->num_pages = (m_end - md->phys_addr + 1) >>
>                                         EFI_PAGE_SHIFT;
>                                 /* latter part */
> -                               new += memmap.desc_size;
> -                               memcpy(new, old, memmap.desc_size);
> +                               new += efi.memmap.desc_size;
> +                               memcpy(new, old, efi.memmap.desc_size);
>                                 md = new;
>                                 md->phys_addr = m_end + 1;
>                                 md->num_pages = (end - md->phys_addr + 1) >>
> @@ -146,16 +146,16 @@ void __init efi_fake_memmap(void)
>                                 md->num_pages = (m_start - md->phys_addr) >>
>                                         EFI_PAGE_SHIFT;
>                                 /* middle part */
> -                               new += memmap.desc_size;
> -                               memcpy(new, old, memmap.desc_size);
> +                               new += efi.memmap.desc_size;
> +                               memcpy(new, old, efi.memmap.desc_size);
>                                 md = new;
>                                 md->attribute |= m_attr;
>                                 md->phys_addr = m_start;
>                                 md->num_pages = (m_end - m_start + 1) >>
>                                         EFI_PAGE_SHIFT;
>                                 /* last part */
> -                               new += memmap.desc_size;
> -                               memcpy(new, old, memmap.desc_size);
> +                               new += efi.memmap.desc_size;
> +                               memcpy(new, old, efi.memmap.desc_size);
>                                 md = new;
>                                 md->phys_addr = m_end + 1;
>                                 md->num_pages = (end - m_end) >>
> @@ -168,8 +168,8 @@ void __init efi_fake_memmap(void)
>                                 md->num_pages = (m_start - md->phys_addr) >>
>                                         EFI_PAGE_SHIFT;
>                                 /* latter part */
> -                               new += memmap.desc_size;
> -                               memcpy(new, old, memmap.desc_size);
> +                               new += efi.memmap.desc_size;
> +                               memcpy(new, old, efi.memmap.desc_size);
>                                 md = new;
>                                 md->phys_addr = m_start;
>                                 md->num_pages = (end - md->phys_addr + 1) >>
> @@ -181,10 +181,10 @@ void __init efi_fake_memmap(void)
>
>         /* swap into new EFI memmap */
>         efi_unmap_memmap();
> -       memmap.map = new_memmap;
> -       memmap.phys_map = new_memmap_phy;
> -       memmap.nr_map = new_nr_map;
> -       memmap.map_end = memmap.map + memmap.nr_map * memmap.desc_size;
> +       efi.memmap.map = new_memmap;
> +       efi.memmap.phys_map = new_memmap_phy;
> +       efi.memmap.nr_map = new_nr_map;
> +       efi.memmap.map_end = efi.memmap.map + efi.memmap.nr_map * efi.memmap.desc_size;
>         set_bit(EFI_MEMMAP, &efi.flags);
>
>         /* print new EFI memmap */
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 17ef4471e603..c2c0da49876e 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -883,7 +883,7 @@ extern struct efi {
>         efi_get_next_high_mono_count_t *get_next_high_mono_count;
>         efi_reset_system_t *reset_system;
>         efi_set_virtual_address_map_t *set_virtual_address_map;
> -       struct efi_memory_map *memmap;
> +       struct efi_memory_map memmap;
>         unsigned long flags;
>  } efi;
>
> @@ -945,7 +945,6 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
>  extern void efi_get_time(struct timespec *now);
>  extern void efi_reserve_boot_services(void);
>  extern int efi_get_fdt_params(struct efi_fdt_params *params);
> -extern struct efi_memory_map memmap;
>  extern struct kobject *efi_kobj;
>
>  extern int efi_reboot_quirk_mode;
> @@ -970,7 +969,7 @@ static inline void efi_fake_memmap(void) { }
>   * Once the loop finishes @md must not be accessed.
>   */
>  #define for_each_efi_memory_desc(md) \
> -       for_each_efi_memory_desc_in_map(efi.memmap, md)
> +       for_each_efi_memory_desc_in_map(&efi.memmap, md)
>
>  /*
>   * Format an EFI memory descriptor's type and attributes to a user-provided
> --
> 2.7.3
>
