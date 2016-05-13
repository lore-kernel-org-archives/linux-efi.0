From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] Xen: EFI: Parse DT parameters for Xen specific UEFI
Date: Fri, 13 May 2016 23:09:23 +0100
Message-ID: <20160513220923.GA5178@codeblueprint.co.uk>
References: <1463055594-14980-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463055594-14980-1-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Including more folks, quoting entire patch)

On Thu, 12 May, at 08:19:54PM, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> The EFI DT parameters for bare metal are located under /chosen node,
> while for Xen Dom0 they are located under /hyperviosr/uefi node. These
> parameters under /chosen and /hyperviosr/uefi are not expected to appear
> at the same time.
> Parse these EFI parameters and initialize EFI like the way for bare
> metal except the runtime services because the runtime services for Xen
> Dom0 are available through hypercalls and they are always enabled. So it
> sets the EFI_RUNTIME_SERVICES flag if it finds /hyperviosr/uefi node and
> bails out in arm_enable_runtime_services() when EFI_RUNTIME_SERVICES
> flag is set already.
> 
> CC: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> v2: rebase it on top of EFI and Xen next branch, add some comments to
> explain the codes. 
> ---
>  arch/arm/xen/enlighten.c           | 22 +++++++++++
>  drivers/firmware/efi/arm-runtime.c |  5 +++
>  drivers/firmware/efi/efi.c         | 81 ++++++++++++++++++++++++++++++--------
>  3 files changed, 92 insertions(+), 16 deletions(-)
 
This looks good to me. Thanks for all the work Shannon.

Stefan, OK, let's figure out how to deal with this.

What I've done is merge xen/linux-next into the 'efi/xen-arm' topic
branch and applied this patch here,

  https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=efi/arm-xen

Yes, the merge includes some Xen patches that are not actually needed
for any of the EFI patches, but Linus has complained about picking
random commits of a tree to merge. At least this way this is all the
Xen linux-next material.

If you're OK with this, and assuming no one else has any preferred
methods, I'll send out a pull request to tip over the weekend.

> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 13e3e9f..d4f36eb 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -15,7 +15,9 @@
>  #include <asm/paravirt.h>
>  #include <asm/xen/hypervisor.h>
>  #include <asm/xen/hypercall.h>
> +#include <asm/xen/xen-ops.h>
>  #include <asm/system_misc.h>
> +#include <asm/efi.h>
>  #include <linux/interrupt.h>
>  #include <linux/irqreturn.h>
>  #include <linux/module.h>
> @@ -261,6 +263,19 @@ static int __init fdt_find_hyper_node(unsigned long node, const char *uname,
>  	    !strncmp(hyper_node.prefix, s, strlen(hyper_node.prefix)))
>  		hyper_node.version = s + strlen(hyper_node.prefix);
>  
> +	/*
> +	 * Check if Xen supports EFI by checking whether there is the
> +	 * "/hypervisor/uefi" node in DT. If so, runtime services are available
> +	 * through proxy functions (e.g. in case of Xen dom0 EFI implementation
> +	 * they call special hypercall which executes relevant EFI functions)
> +	 * and that is why they are always enabled.
> +	 */
> +	if (IS_ENABLED(CONFIG_XEN_EFI)) {
> +		if ((of_get_flat_dt_subnode_by_name(node, "uefi") > 0) &&
> +		    !efi_runtime_disabled())
> +			set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -352,6 +367,13 @@ static int __init xen_guest_init(void)
>  		return -ENODEV;
>  	}
>  
> +	/*
> +	 * The fdt parsing codes have set EFI_RUNTIME_SERVICES if Xen EFI
> +	 * parameters are found. Force enable runtime services.
> +	 */
> +	if (efi_enabled(EFI_RUNTIME_SERVICES))
> +		xen_efi_runtime_setup();
> +
>  	shared_info_page = (struct shared_info *)get_zeroed_page(GFP_KERNEL);
>  
>  	if (!shared_info_page) {
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> index 17ccf0a..c394b81 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -107,6 +107,11 @@ static int __init arm_enable_runtime_services(void)
>  		return 0;
>  	}
>  
> +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> +		pr_info("EFI runtime services access via paravirt.\n");
> +		return 0;
> +	}
> +
>  	pr_info("Remapping and enabling EFI services.\n");
>  
>  	mapsize = efi.memmap.map_end - efi.memmap.map;
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 05509f3..1c6f9dd 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -472,12 +472,14 @@ device_initcall(efi_load_efivars);
>  		FIELD_SIZEOF(struct efi_fdt_params, field) \
>  	}
>  
> -static __initdata struct {
> +struct params {
>  	const char name[32];
>  	const char propname[32];
>  	int offset;
>  	int size;
> -} dt_params[] = {
> +};
> +
> +static __initdata struct params fdt_params[] = {
>  	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
>  	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
>  	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
> @@ -485,44 +487,91 @@ static __initdata struct {
>  	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
>  };
>  
> +static __initdata struct params xen_fdt_params[] = {
> +	UEFI_PARAM("System Table", "xen,uefi-system-table", system_table),
> +	UEFI_PARAM("MemMap Address", "xen,uefi-mmap-start", mmap),
> +	UEFI_PARAM("MemMap Size", "xen,uefi-mmap-size", mmap_size),
> +	UEFI_PARAM("MemMap Desc. Size", "xen,uefi-mmap-desc-size", desc_size),
> +	UEFI_PARAM("MemMap Desc. Version", "xen,uefi-mmap-desc-ver", desc_ver)
> +};
> +
> +#define EFI_FDT_PARAMS_SIZE	ARRAY_SIZE(fdt_params)
> +
> +static __initdata struct {
> +	const char *uname;
> +	const char *subnode;
> +	struct params *params;
> +} dt_params[] = {
> +	{ "hypervisor", "uefi", xen_fdt_params },
> +	{ "chosen", NULL, fdt_params },
> +};
> +
>  struct param_info {
>  	int found;
>  	void *params;
> +	const char *missing;
>  };
>  
> -static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
> -				       int depth, void *data)
> +static int __init __find_uefi_params(unsigned long node,
> +				     struct param_info *info,
> +				     struct params *params)
>  {
> -	struct param_info *info = data;
>  	const void *prop;
>  	void *dest;
>  	u64 val;
>  	int i, len;
>  
> -	if (depth != 1 || strcmp(uname, "chosen") != 0)
> -		return 0;
> -
> -	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
> -		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
> -		if (!prop)
> +	for (i = 0; i < EFI_FDT_PARAMS_SIZE; i++) {
> +		prop = of_get_flat_dt_prop(node, params[i].propname, &len);
> +		if (!prop) {
> +			info->missing = params[i].name;
>  			return 0;
> -		dest = info->params + dt_params[i].offset;
> +		}
> +
> +		dest = info->params + params[i].offset;
>  		info->found++;
>  
>  		val = of_read_number(prop, len / sizeof(u32));
>  
> -		if (dt_params[i].size == sizeof(u32))
> +		if (params[i].size == sizeof(u32))
>  			*(u32 *)dest = val;
>  		else
>  			*(u64 *)dest = val;
>  
>  		if (efi_enabled(EFI_DBG))
> -			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
> -				dt_params[i].size * 2, val);
> +			pr_info("  %s: 0x%0*llx\n", params[i].name,
> +				params[i].size * 2, val);
>  	}
> +
>  	return 1;
>  }
>  
> +static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
> +				       int depth, void *data)
> +{
> +	struct param_info *info = data;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
> +		const char *subnode = dt_params[i].subnode;
> +
> +		if (depth != 1 || strcmp(uname, dt_params[i].uname) != 0) {
> +			info->missing = dt_params[i].params[0].name;
> +			continue;
> +		}
> +
> +		if (subnode) {
> +			node = of_get_flat_dt_subnode_by_name(node, subnode);
> +			if (node < 0)
> +				return 0;
> +		}
> +
> +		return __find_uefi_params(node, info, dt_params[i].params);
> +	}
> +
> +	return 0;
> +}
> +
>  int __init efi_get_fdt_params(struct efi_fdt_params *params)
>  {
>  	struct param_info info;
> @@ -538,7 +587,7 @@ int __init efi_get_fdt_params(struct efi_fdt_params *params)
>  		pr_info("UEFI not found.\n");
>  	else if (!ret)
>  		pr_err("Can't find '%s' in device tree!\n",
> -		       dt_params[info.found].name);
> +		       info.missing);
>  
>  	return ret;
>  }
> -- 
> 2.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
