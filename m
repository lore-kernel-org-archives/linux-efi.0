From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/5] arm64/efi: move EFI init before early FDT
 processing
Date: Wed, 26 Aug 2015 16:16:27 +0100
Message-ID: <20150826151627.GC10728@bivouac.eciton.net>
References: <1440576391-25725-1-git-send-email-ard.biesheuvel@linaro.org>
 <1440576391-25725-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440576391-25725-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leo.yan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 26, 2015 at 10:06:29AM +0200, Ard Biesheuvel wrote:
> The early FDT processing is responsible for enumerating the
> DT memory nodes and installing them as memblocks. This should
> only be done if we are not booting via EFI, but at this point,
> we don't know yet if that is the case or not.
> 
> So move the EFI init to before the early FDT processing. This involves
> making some changes to the way EFI discovers the locations of the
> EFI system table and the memory map, since those values are retrieved
> from the FDT as well. Instead the of_scan infrastructure, it now uses
> libfdt directly to access the /chosen node.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/include/asm/efi.h   |  4 +-
>  arch/arm64/kernel/efi.c        | 14 ++--
>  arch/arm64/kernel/setup.c      |  4 +-
>  drivers/firmware/efi/efi-fdt.c | 74 ++++++++------------
>  include/linux/efi.h            |  3 +-
>  5 files changed, 40 insertions(+), 59 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> index ef572206f1c3..635101f36720 100644
> --- a/arch/arm64/include/asm/efi.h
> +++ b/arch/arm64/include/asm/efi.h
> @@ -5,9 +5,9 @@
>  #include <asm/neon.h>
>  
>  #ifdef CONFIG_EFI
> -extern void efi_init(void);
> +extern void efi_init_fdt(void *fdt);
>  #else
> -#define efi_init()
> +#define efi_init_fdt(x)
>  #endif
>  
>  #define efi_call_virt(f, ...)						\
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 9d4aa18f2a82..0e3dbe2cb752 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -51,14 +51,7 @@ static struct mm_struct efi_mm = {
>  	INIT_MM_CONTEXT(efi_mm)
>  };
>  
> -static int uefi_debug __initdata;
> -static int __init uefi_debug_setup(char *str)
> -{
> -	uefi_debug = 1;
> -
> -	return 0;
> -}
> -early_param("uefi_debug", uefi_debug_setup);
> +static bool uefi_debug __initdata;

So, this obviously clashes with the patches I sent out recently, but
then they were triggered by the awkwardness of the interface passing
the verbosity flag around...
  
>  static int __init is_normal_ram(efi_memory_desc_t *md)
>  {
> @@ -205,14 +198,15 @@ static __init void reserve_regions(void)
>  	set_bit(EFI_MEMMAP, &efi.flags);
>  }
>  
> -void __init efi_init(void)
> +void __init efi_init_fdt(void *fdt)

(Nitpick: efi_init_fdt here, efi_virtmap_init below - naming consistency)

>  {
>  	struct efi_fdt_params params;
>  
>  	/* Grab UEFI information placed in FDT by stub */
> -	if (!efi_get_fdt_params(&params, uefi_debug))
> +	if (!efi_get_fdt_params(fdt, &params))
>  		return;
>  
> +	uefi_debug = params.verbose;
>  	efi_system_table = params.system_table;

Here is where it gets problematic.
Because this is now called before parse_early_params(), we lose the
ability to do debug output. Now, the details in the DT parsing is
maybe not that critical, but what follow is:
  
>  	memblock_reserve(params.mmap & PAGE_MASK,

... and we _really_ need to be able to dump the memory regions, with
attributes, for debugging purposes.

> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index fddae2c15ad2..8fdde97c975c 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -298,6 +298,9 @@ static void __init setup_machine_fdt(phys_addr_t dt_phys)
>  {
>  	void *dt_virt = fixmap_remap_fdt(dt_phys);
>  
> +	if (dt_virt)
> +		efi_init_fdt(dt_virt);
> +
>  	if (!dt_virt || !early_init_dt_scan(dt_virt)) {
>  		pr_crit("\n"
>  			"Error: invalid device tree blob at physical address %pa (virtual address 0x%p)\n"
> @@ -366,7 +369,6 @@ void __init setup_arch(char **cmdline_p)
>  	 */
>  	local_async_enable();
>  
> -	efi_init();

So can we just keep this call and terminate efi_init_fdt before
memblock_reserve?

>  	arm64_memblock_init();
>  
>  	/* Parse the ACPI tables for possible boot-time configuration */
> diff --git a/drivers/firmware/efi/efi-fdt.c b/drivers/firmware/efi/efi-fdt.c
> index f0e7ef2ae0e9..2e0e1a5a3fbb 100644
> --- a/drivers/firmware/efi/efi-fdt.c
> +++ b/drivers/firmware/efi/efi-fdt.c
> @@ -8,8 +8,7 @@
>  
>  #include <linux/init.h>
>  #include <linux/efi.h>
> -#include <linux/of.h>
> -#include <linux/of_fdt.h>
> +#include <linux/libfdt.h>
>  
>  #define UEFI_PARAM(name, prop, field)			   \
>  	{						   \
> @@ -32,62 +31,47 @@ static __initdata struct {
>  	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
>  };
>  
> -struct param_info {
> -	int verbose;
> -	int found;
> -	void *params;
> -};
> -
> -static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
> -				       int depth, void *data)
> +bool __init efi_get_fdt_params(void *fdt, struct efi_fdt_params *params)
>  {
> -	struct param_info *info = data;
>  	const void *prop;
> -	void *dest;
> -	u64 val;
> -	int i, len;
> +	int node, i;
> +
> +	pr_info("Getting EFI parameters from FDT:\n");
>  
> -	if (depth != 1 || strcmp(uname, "chosen") != 0)
> -		return 0;
> +	node = fdt_path_offset(fdt, "/chosen");
> +	if (node < 0) {
> +		pr_err("/chosen node not found!\n");
> +		return false;
> +	}
> +
> +	prop = fdt_getprop(fdt, node, "bootargs", NULL);
> +	params->verbose = prop && strstr(prop, "uefi_debug");
>  
>  	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
> -		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
> -		if (!prop)
> -			return 0;
> -		dest = info->params + dt_params[i].offset;
> -		info->found++;
> +		void *dest;
> +		int len;
> +		u64 val;
>  
> -		val = of_read_number(prop, len / sizeof(u32));
> +		prop = fdt_getprop(fdt, node, dt_params[i].propname, &len);
> +		if (!prop)
> +			goto not_found;
> +		dest = (void *)params + dt_params[i].offset;
>  
>  		if (dt_params[i].size == sizeof(u32))
> -			*(u32 *)dest = val;
> +			val = *(u32 *)dest = be32_to_cpup(prop);
>  		else
> -			*(u64 *)dest = val;
> +			val = *(u64 *)dest = be64_to_cpup(prop);
>  
> -		if (info->verbose)
> +		if (params->verbose)
>  			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
>  				dt_params[i].size * 2, val);
>  	}
> -	return 1;
> -}
> -
> -int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
> -{
> -	struct param_info info;
> -	int ret;
> +	return true;
>  
> -	pr_info("Getting EFI parameters from FDT:\n");
> -
> -	info.verbose = verbose;
> -	info.found = 0;
> -	info.params = params;
> -
> -	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
> -	if (!info.found)
> +not_found:
> +	if (i == 0)
>  		pr_info("UEFI not found.\n");
> -	else if (!ret)
> -		pr_err("Can't find '%s' in device tree!\n",
> -		       dt_params[info.found].name);
> -
> -	return ret;
> +	else
> +		pr_err("Can't find '%s' in device tree!\n", dt_params[i].name);
> +	return false;
>  }
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 85ef051ac6fb..faafa1ad6ea7 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -690,6 +690,7 @@ struct efi_fdt_params {
>  	u32 mmap_size;
>  	u32 desc_size;
>  	u32 desc_ver;
> +	bool verbose;
>  };
>  
>  typedef struct {
> @@ -901,7 +902,7 @@ extern void efi_initialize_iomem_resources(struct resource *code_resource,
>  		struct resource *data_resource, struct resource *bss_resource);
>  extern void efi_get_time(struct timespec *now);
>  extern void efi_reserve_boot_services(void);
> -extern int efi_get_fdt_params(struct efi_fdt_params *params, int verbose);
> +extern bool efi_get_fdt_params(void *fdt, struct efi_fdt_params *params);
>  extern struct efi_memory_map memmap;
>  extern struct kobject *efi_kobj;
>  
> -- 
> 1.9.1
> 
