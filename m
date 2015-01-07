From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI
 stub
Date: Wed, 7 Jan 2015 12:06:08 +0000
Message-ID: <20150107120608.GJ3827@bivouac.eciton.net>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
 <1419245944-2424-7-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1419245944-2424-7-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 22, 2014 at 10:59:02AM +0000, Ard Biesheuvel wrote:
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
> 
> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> index 71291253114f..6cc668a378c5 100644
> --- a/arch/arm64/include/asm/efi.h
> +++ b/arch/arm64/include/asm/efi.h
> @@ -7,28 +7,36 @@
>  #ifdef CONFIG_EFI
>  extern void efi_init(void);
>  extern void efi_idmap_init(void);
> +extern void efi_virtmap_init(void);
>  #else
>  #define efi_init()
>  #define efi_idmap_init()
> +#define efi_virtmap_init
>  #endif
>  
>  #define efi_call_virt(f, ...)						\
>  ({									\
> -	efi_##f##_t *__f = efi.systab->runtime->f;			\
> +	efi_##f##_t *__f;						\
>  	efi_status_t __s;						\
>  									\
> -	kernel_neon_begin();						\
> +	kernel_neon_begin();	/* disables preemption */		\

Nitpick: adding comment to otherwise untouched source line.

> +	efi_virtmap_load();						\
> +	__f = efi.systab->runtime->f;					\
>  	__s = __f(__VA_ARGS__);						\
> +	efi_virtmap_unload();						\
>  	kernel_neon_end();						\
>  	__s;								\
>  })
>  
>  #define __efi_call_virt(f, ...)						\
>  ({									\
> -	efi_##f##_t *__f = efi.systab->runtime->f;			\
> +	efi_##f##_t *__f;						\
>  									\
> -	kernel_neon_begin();						\
> +	kernel_neon_begin();	/* disables preemption */		\

Same nitpick.

> +	efi_virtmap_load();						\
> +	__f = efi.systab->runtime->f;					\
>  	__f(__VA_ARGS__);						\
> +	efi_virtmap_unload();						\
>  	kernel_neon_end();						\
>  })
>  
> @@ -45,5 +53,9 @@ extern void efi_idmap_init(void);
>  #define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
>  
>  #define EFI_ALLOC_ALIGN		SZ_64K
> +#define EFI_VIRTMAP		EFI_ARCH_1
> +
> +void efi_virtmap_load(void);
> +void efi_virtmap_unload(void);
>  
>  #endif /* _ASM_EFI_H */
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 6fac253bc783..2ebe67ffb629 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -11,25 +11,30 @@
>   *
>   */
>  
> +#include <linux/atomic.h>
>  #include <linux/dmi.h>
>  #include <linux/efi.h>
>  #include <linux/export.h>
>  #include <linux/memblock.h>
> +#include <linux/mm_types.h>
>  #include <linux/bootmem.h>
>  #include <linux/of.h>
>  #include <linux/of_fdt.h>
> +#include <linux/rbtree.h>
> +#include <linux/rwsem.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> +#include <linux/spinlock.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/efi.h>
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
> +#include <asm/mmu.h>
> +#include <asm/pgtable.h>
>  
>  struct efi_memory_map memmap;
>  
> -static efi_runtime_services_t *runtime;
> -
>  static u64 efi_system_table;
>  
>  static int uefi_debug __initdata;
> @@ -69,9 +74,33 @@ static void __init efi_setup_idmap(void)
>  	}
>  }
>  
> +/*
> + * Translate a EFI virtual address into a physical address: this is necessary,
> + * as some data members of the EFI system table are virtually remapped after
> + * SetVirtualAddressMap() has been called.
> + */
> +static phys_addr_t efi_to_phys(unsigned long addr)
> +{
> +	efi_memory_desc_t *md;
> +
> +	for_each_efi_memory_desc(&memmap, md) {
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> +			continue;
> +		if (md->virt_addr == 0)
> +			/* no virtual mapping has been installed by the stub */
> +			break;
> +		if (md->virt_addr <= addr &&
> +		    (addr - md->virt_addr) < (md->num_pages << EFI_PAGE_SHIFT))
> +			return md->phys_addr + addr - md->virt_addr;
> +	}
> +	return addr;
> +}
> +
>  static int __init uefi_init(void)
>  {
>  	efi_char16_t *c16;
> +	void *config_tables;
> +	u64 table_size;
>  	char vendor[100] = "unknown";
>  	int i, retval;
>  
> @@ -99,7 +128,7 @@ static int __init uefi_init(void)
>  			efi.systab->hdr.revision & 0xffff);
>  
>  	/* Show what we know for posterity */
> -	c16 = early_memremap(efi.systab->fw_vendor,
> +	c16 = early_memremap(efi_to_phys(efi.systab->fw_vendor),
>  			     sizeof(vendor));
>  	if (c16) {
>  		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
> @@ -112,8 +141,14 @@ static int __init uefi_init(void)
>  		efi.systab->hdr.revision >> 16,
>  		efi.systab->hdr.revision & 0xffff, vendor);
>  
> -	retval = efi_config_init(NULL);
> +	table_size = sizeof(efi_config_table_64_t) * efi.systab->nr_tables;
> +	config_tables = early_memremap(efi_to_phys(efi.systab->tables),
> +				       table_size);
> +
> +	retval = efi_config_parse_tables(config_tables,
> +					 efi.systab->nr_tables, NULL);
>  
> +	early_memunmap(config_tables, table_size);
>  out:
>  	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
>  	return retval;
> @@ -328,51 +363,9 @@ void __init efi_idmap_init(void)
>  	efi_setup_idmap();
>  }
>  
> -static int __init remap_region(efi_memory_desc_t *md, void **new)
> -{
> -	u64 paddr, vaddr, npages, size;
> -
> -	paddr = md->phys_addr;
> -	npages = md->num_pages;
> -	memrange_efi_to_native(&paddr, &npages);
> -	size = npages << PAGE_SHIFT;
> -
> -	if (is_normal_ram(md))
> -		vaddr = (__force u64)ioremap_cache(paddr, size);
> -	else
> -		vaddr = (__force u64)ioremap(paddr, size);
> -
> -	if (!vaddr) {
> -		pr_err("Unable to remap 0x%llx pages @ %p\n",
> -		       npages, (void *)paddr);
> -		return 0;
> -	}
> -
> -	/* adjust for any rounding when EFI and system pagesize differs */
> -	md->virt_addr = vaddr + (md->phys_addr - paddr);
> -
> -	if (uefi_debug)
> -		pr_info("  EFI remap 0x%012llx => %p\n",
> -			md->phys_addr, (void *)md->virt_addr);
> -
> -	memcpy(*new, md, memmap.desc_size);
> -	*new += memmap.desc_size;
> -
> -	return 1;
> -}
> -
> -/*
> - * Switch UEFI from an identity map to a kernel virtual map
> - */

No function description at all?
Arguably this function could change name now as well, since UEFI will
already be in virtual mode. arm64_enable_runtime_map()?

>  static int __init arm64_enter_virtual_mode(void)
>  {
> -	efi_memory_desc_t *md;
> -	phys_addr_t virtmap_phys;
> -	void *virtmap, *virt_md;
> -	efi_status_t status;
>  	u64 mapsize;
> -	int count = 0;
> -	unsigned long flags;
>  
>  	if (!efi_enabled(EFI_BOOT)) {
>  		pr_info("EFI services will not be available.\n");
> @@ -395,79 +388,28 @@ static int __init arm64_enter_virtual_mode(void)
>  
>  	efi.memmap = &memmap;
>  
> -	/* Map the runtime regions */
> -	virtmap = kmalloc(mapsize, GFP_KERNEL);
> -	if (!virtmap) {
> -		pr_err("Failed to allocate EFI virtual memmap\n");
> -		return -1;
> -	}
> -	virtmap_phys = virt_to_phys(virtmap);
> -	virt_md = virtmap;
> -
> -	for_each_efi_memory_desc(&memmap, md) {
> -		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> -			continue;
> -		if (!remap_region(md, &virt_md))
> -			goto err_unmap;
> -		++count;
> -	}
> -
> -	efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
> +	efi.systab = (__force void *)ioremap_cache(efi_system_table,
> +						   sizeof(efi_system_table_t));
>  	if (!efi.systab) {
> -		/*
> -		 * If we have no virtual mapping for the System Table at this
> -		 * point, the memory map doesn't cover the physical offset where
> -		 * it resides. This means the System Table will be inaccessible
> -		 * to Runtime Services themselves once the virtual mapping is
> -		 * installed.
> -		 */
> -		pr_err("Failed to remap EFI System Table -- buggy firmware?\n");
> -		goto err_unmap;
> +		pr_err("Failed to remap EFI System Table\n");
> +		return -1;
>  	}
>  	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>  
> -	local_irq_save(flags);
> -	cpu_switch_mm(idmap_pg_dir, &init_mm);
> -
> -	/* Call SetVirtualAddressMap with the physical address of the map */
> -	runtime = efi.systab->runtime;
> -	efi.set_virtual_address_map = runtime->set_virtual_address_map;
> -
> -	status = efi.set_virtual_address_map(count * memmap.desc_size,
> -					     memmap.desc_size,
> -					     memmap.desc_version,
> -					     (efi_memory_desc_t *)virtmap_phys);
> -	cpu_set_reserved_ttbr0();
> -	flush_tlb_all();
> -	local_irq_restore(flags);
> -
> -	kfree(virtmap);
> -
>  	free_boot_services();
>  
> -	if (status != EFI_SUCCESS) {
> -		pr_err("Failed to set EFI virtual address map! [%lx]\n",
> -			status);
> +	if (!efi_enabled(EFI_VIRTMAP)) {
> +		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
>  		return -1;
>  	}
>  
>  	/* Set up runtime services function pointers */
> -	runtime = efi.systab->runtime;
>  	efi_native_runtime_setup();
>  	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>  
>  	efi.runtime_version = efi.systab->hdr.revision;
>  
>  	return 0;
> -
> -err_unmap:
> -	/* unmap all mappings that succeeded: there are 'count' of those */
> -	for (virt_md = virtmap; count--; virt_md += memmap.desc_size) {
> -		md = virt_md;
> -		iounmap((__force void __iomem *)md->virt_addr);
> -	}
> -	kfree(virtmap);
> -	return -1;
>  }
>  early_initcall(arm64_enter_virtual_mode);
>  
> @@ -484,3 +426,78 @@ static int __init arm64_dmi_init(void)
>  	return 0;
>  }
>  core_initcall(arm64_dmi_init);
> +
> +static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
> +
> +static struct mm_struct efi_mm = {
> +	.mm_rb			= RB_ROOT,
> +	.pgd			= efi_pgd,
> +	.mm_users		= ATOMIC_INIT(2),
> +	.mm_count		= ATOMIC_INIT(1),
> +	.mmap_sem		= __RWSEM_INITIALIZER(efi_mm.mmap_sem),
> +	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
> +	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
> +	INIT_MM_CONTEXT(efi_mm)
> +};
> +
> +static void efi_set_pgd(struct mm_struct *mm)
> +{
> +	cpu_switch_mm(mm->pgd, mm);
> +	flush_tlb_all();
> +	if (icache_is_aivivt())
> +		__flush_icache_all();
> +}
> +
> +void efi_virtmap_load(void)
> +{
> +	WARN_ON(preemptible());
> +	efi_set_pgd(&efi_mm);
> +}
> +
> +void efi_virtmap_unload(void)
> +{
> +	efi_set_pgd(current->active_mm);
> +}
> +
> +void __init efi_virtmap_init(void)
> +{
> +	efi_memory_desc_t *md;
> +
> +	if (!efi_enabled(EFI_BOOT))
> +		return;
> +
> +	for_each_efi_memory_desc(&memmap, md) {
> +		u64 paddr, npages, size;
> +		pgprot_t prot;
> +
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> +			continue;
> +		if (WARN(md->virt_addr == 0,
> +			 "UEFI virtual mapping incomplete or missing -- no entry found for 0x%llx\n",
> +			 md->phys_addr))
> +			return;
> +
> +		paddr = md->phys_addr;
> +		npages = md->num_pages;
> +		memrange_efi_to_native(&paddr, &npages);
> +		size = npages << PAGE_SHIFT;
> +
> +		pr_info("  EFI remap 0x%012llx => %p\n",
> +			md->phys_addr, (void *)md->virt_addr);
> +
> +		/*
> +		 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
> +		 * executable, everything else can be mapped with the XN bits
> +		 * set.
> +		 */
> +		if (!is_normal_ram(md))
> +			prot = __pgprot(PROT_DEVICE_nGnRE);
> +		else if (md->type == EFI_RUNTIME_SERVICES_CODE)
> +			prot = PAGE_KERNEL_EXEC;
> +		else
> +			prot = PAGE_KERNEL;
> +
> +		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
> +	}
> +	set_bit(EFI_VIRTMAP, &efi.flags);
> +}
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index b80991166754..d8390f507da0 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -402,6 +402,7 @@ void __init setup_arch(char **cmdline_p)
>  	request_standard_resources();
>  
>  	efi_idmap_init();
> +	efi_virtmap_init();

Could these two be merged together into one function?
Say efi_memmap_init()?

>  
>  	unflatten_device_tree();
>  
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
> +
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
>  /*
>   * Allocate memory for a new FDT, then add EFI, commandline, and
>   * initrd related fields to the FDT.  This routine increases the
> @@ -196,6 +284,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  	efi_memory_desc_t *memory_map;
>  	unsigned long new_fdt_size;
>  	efi_status_t status;
> +	int runtime_entry_count = 0;
>  
>  	/*
>  	 * Estimate size of new FDT, and allocate memory for it. We
> @@ -216,8 +305,8 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  		 * we can get the memory map key  needed for
>  		 * exit_boot_services().
>  		 */
> -		status = efi_get_memory_map(sys_table, &memory_map, &map_size,
> -					    &desc_size, &desc_ver, &mmap_key);
> +		status = get_memory_map(sys_table, &memory_map, &map_size,
> +					&desc_size, &desc_ver, &mmap_key);
>  		if (status != EFI_SUCCESS)
>  			goto fail_free_new_fdt;
>  
> @@ -248,12 +337,52 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  		}
>  	}
>  
> +	/*
> +	 * Update the memory map with virtual addresses. The function will also
> +	 * populate the spare second half of the memory_map allocation with
> +	 * copies of just the EFI_MEMORY_RUNTIME entries so that we can pass it
> +	 * straight into SetVirtualAddressMap()
> +	 */
> +	update_memory_map(memory_map, map_size, desc_size,
> +			  &runtime_entry_count);
> +
> +	pr_efi(sys_table,
> +	       "Exiting boot services and installing virtual address map...\n");
> +
>  	/* Now we are ready to exit_boot_services.*/
>  	status = sys_table->boottime->exit_boot_services(handle, mmap_key);
>  
> +	if (status == EFI_SUCCESS) {
> +		efi_set_virtual_address_map_t *svam;
>  
> -	if (status == EFI_SUCCESS)
> -		return status;
> +		/* Install the new virtual address map */
> +		svam = sys_table->runtime->set_virtual_address_map;
> +		status = svam(runtime_entry_count * desc_size, desc_size,
> +			      desc_ver, (void *)memory_map + map_size);
> +
> +		/*
> +		 * We are beyond the point of no return here, so if the call to
> +		 * SetVirtualAddressMap() failed, we need to signal that to the
> +		 * incoming kernel but proceed normally otherwise.
> +		 */
> +		if (status != EFI_SUCCESS) {
> +			int l;
> +
> +			/*
> +			 * Set the virtual address field of all
> +			 * EFI_MEMORY_RUNTIME entries to 0. This will signal
> +			 * the incoming kernel that no virtual translation has
> +			 * been installed.
> +			 */
> +			for (l = 0; l < map_size; l += desc_size) {
> +				efi_memory_desc_t *p = (void *)memory_map + l;
> +
> +				if (p->attribute & EFI_MEMORY_RUNTIME)
> +					p->virt_addr = 0;
> +			}
> +		}
> +		return EFI_SUCCESS;
> +	}
>  
>  	pr_efi_err(sys_table, "Exit boot services failed.\n");
>  
> -- 
> 1.8.3.2

Apart from this, and other comments in the thread, looks good.

/
    Leif
