From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/5] efi: move FDT handling to separate object file
Date: Wed, 26 Aug 2015 15:47:39 +0100
Message-ID: <20150826144739.GB10728@bivouac.eciton.net>
References: <1440576391-25725-1-git-send-email-ard.biesheuvel@linaro.org>
 <1440576391-25725-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440576391-25725-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leo.yan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 26, 2015 at 10:06:28AM +0200, Ard Biesheuvel wrote:
> The EFI specific FDT handling is compiled conditionally, and is
> logically independent of the rest of efi.o. So move it to a separate
> file before making changes to it in subsequent patches.
> 
> Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/Makefile  |  1 +
>  drivers/firmware/efi/efi-fdt.c | 93 ++++++++++++++++++++
>  drivers/firmware/efi/efi.c     | 86 ------------------
>  3 files changed, 94 insertions(+), 86 deletions(-)

Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 6fd3da938717..d9140208fc1c 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_UEFI_CPER)			+= cper.o
>  obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
>  obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
>  obj-$(CONFIG_EFI_STUB)			+= libstub/
> +obj-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= efi-fdt.o
> diff --git a/drivers/firmware/efi/efi-fdt.c b/drivers/firmware/efi/efi-fdt.c
> new file mode 100644
> index 000000000000..f0e7ef2ae0e9
> --- /dev/null
> +++ b/drivers/firmware/efi/efi-fdt.c
> @@ -0,0 +1,93 @@
> +/*
> + * Copyright (C) 2013 - 2015 Linaro Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/efi.h>
> +#include <linux/of.h>
> +#include <linux/of_fdt.h>
> +
> +#define UEFI_PARAM(name, prop, field)			   \
> +	{						   \
> +		{ name },				   \
> +		{ prop },				   \
> +		offsetof(struct efi_fdt_params, field),    \
> +		FIELD_SIZEOF(struct efi_fdt_params, field) \
> +	}
> +
> +static __initdata struct {
> +	const char name[32];
> +	const char propname[32];
> +	int offset;
> +	int size;
> +} dt_params[] = {
> +	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
> +	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
> +	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
> +	UEFI_PARAM("MemMap Desc. Size", "linux,uefi-mmap-desc-size", desc_size),
> +	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
> +};
> +
> +struct param_info {
> +	int verbose;
> +	int found;
> +	void *params;
> +};
> +
> +static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
> +				       int depth, void *data)
> +{
> +	struct param_info *info = data;
> +	const void *prop;
> +	void *dest;
> +	u64 val;
> +	int i, len;
> +
> +	if (depth != 1 || strcmp(uname, "chosen") != 0)
> +		return 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
> +		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
> +		if (!prop)
> +			return 0;
> +		dest = info->params + dt_params[i].offset;
> +		info->found++;
> +
> +		val = of_read_number(prop, len / sizeof(u32));
> +
> +		if (dt_params[i].size == sizeof(u32))
> +			*(u32 *)dest = val;
> +		else
> +			*(u64 *)dest = val;
> +
> +		if (info->verbose)
> +			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
> +				dt_params[i].size * 2, val);
> +	}
> +	return 1;
> +}
> +
> +int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
> +{
> +	struct param_info info;
> +	int ret;
> +
> +	pr_info("Getting EFI parameters from FDT:\n");
> +
> +	info.verbose = verbose;
> +	info.found = 0;
> +	info.params = params;
> +
> +	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
> +	if (!info.found)
> +		pr_info("UEFI not found.\n");
> +	else if (!ret)
> +		pr_err("Can't find '%s' in device tree!\n",
> +		       dt_params[info.found].name);
> +
> +	return ret;
> +}
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 9fa8084a7c8d..f975a1a45b80 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -20,8 +20,6 @@
>  #include <linux/init.h>
>  #include <linux/device.h>
>  #include <linux/efi.h>
> -#include <linux/of.h>
> -#include <linux/of_fdt.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
>  
> @@ -460,90 +458,6 @@ static int __init efi_load_efivars(void)
>  device_initcall(efi_load_efivars);
>  #endif
>  
> -#ifdef CONFIG_EFI_PARAMS_FROM_FDT
> -
> -#define UEFI_PARAM(name, prop, field)			   \
> -	{						   \
> -		{ name },				   \
> -		{ prop },				   \
> -		offsetof(struct efi_fdt_params, field),    \
> -		FIELD_SIZEOF(struct efi_fdt_params, field) \
> -	}
> -
> -static __initdata struct {
> -	const char name[32];
> -	const char propname[32];
> -	int offset;
> -	int size;
> -} dt_params[] = {
> -	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
> -	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
> -	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
> -	UEFI_PARAM("MemMap Desc. Size", "linux,uefi-mmap-desc-size", desc_size),
> -	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
> -};
> -
> -struct param_info {
> -	int verbose;
> -	int found;
> -	void *params;
> -};
> -
> -static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
> -				       int depth, void *data)
> -{
> -	struct param_info *info = data;
> -	const void *prop;
> -	void *dest;
> -	u64 val;
> -	int i, len;
> -
> -	if (depth != 1 || strcmp(uname, "chosen") != 0)
> -		return 0;
> -
> -	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
> -		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
> -		if (!prop)
> -			return 0;
> -		dest = info->params + dt_params[i].offset;
> -		info->found++;
> -
> -		val = of_read_number(prop, len / sizeof(u32));
> -
> -		if (dt_params[i].size == sizeof(u32))
> -			*(u32 *)dest = val;
> -		else
> -			*(u64 *)dest = val;
> -
> -		if (info->verbose)
> -			pr_info("  %s: 0x%0*llx\n", dt_params[i].name,
> -				dt_params[i].size * 2, val);
> -	}
> -	return 1;
> -}
> -
> -int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
> -{
> -	struct param_info info;
> -	int ret;
> -
> -	pr_info("Getting EFI parameters from FDT:\n");
> -
> -	info.verbose = verbose;
> -	info.found = 0;
> -	info.params = params;
> -
> -	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
> -	if (!info.found)
> -		pr_info("UEFI not found.\n");
> -	else if (!ret)
> -		pr_err("Can't find '%s' in device tree!\n",
> -		       dt_params[info.found].name);
> -
> -	return ret;
> -}
> -#endif /* CONFIG_EFI_PARAMS_FROM_FDT */
> -
>  static __initdata char memory_type_name[][20] = {
>  	"Reserved",
>  	"Loader Code",
> -- 
> 1.9.1
