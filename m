From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH 08/13] Xen: EFI: Parse DT parameters for Xen specific
 UEFI
Date: Fri, 20 Nov 2015 17:04:36 +0000
Message-ID: <alpine.DEB.2.02.1511201704170.1107@kaball.uk.xensource.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>
 <1447754231-7772-9-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447754231-7772-9-git-send-email-shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hangaohuai-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 17 Nov 2015, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Add a new function to parse DT parameters for Xen specific UEFI just
> like the way for normal UEFI. Then it could reuse the existing codes.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c | 67 ++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 62 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index d6144e3..629bd06 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -24,6 +24,7 @@
>  #include <linux/of_fdt.h>
>  #include <linux/io.h>
>  #include <linux/platform_device.h>
> +#include <xen/xen.h>
>  
>  struct efi __read_mostly efi = {
>  	.mps        = EFI_INVALID_TABLE_ADDR,
> @@ -488,12 +489,60 @@ static __initdata struct {
>  	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
>  };
>  
> +static __initdata struct {
> +	const char name[32];
> +	const char propname[32];
> +	int offset;
> +	int size;
> +} xen_dt_params[] = {
> +	UEFI_PARAM("System Table", "xen,uefi-system-table", system_table),
> +	UEFI_PARAM("MemMap Address", "xen,uefi-mmap-start", mmap),
> +	UEFI_PARAM("MemMap Size", "xen,uefi-mmap-size", mmap_size),
> +	UEFI_PARAM("MemMap Desc. Size", "xen,uefi-mmap-desc-size", desc_size),
> +	UEFI_PARAM("MemMap Desc. Version", "xen,uefi-mmap-desc-ver", desc_ver)
> +};
> +
>  struct param_info {
>  	int verbose;
>  	int found;
>  	void *params;
>  };
>  
> +static int __init fdt_find_xen_uefi_params(unsigned long node,
> +					   const char *uname, int depth,
> +					   void *data)
> +{
> +	struct param_info *info = data;
> +	const void *prop;
> +	void *dest;
> +	u64 val;
> +	int i, len;
> +
> +	if (xen_initial_domain() && (depth != 2 || strcmp(uname, "uefi") != 0))
> +		return 0;
> +
> +	for (i = 0; i < ARRAY_SIZE(xen_dt_params); i++) {
> +		prop = of_get_flat_dt_prop(node, xen_dt_params[i].propname,
> +					   &len);
> +		if (!prop)
> +			return 0;
> +		dest = info->params + xen_dt_params[i].offset;
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
> +			pr_info("  %s: 0x%0*llx\n", xen_dt_params[i].name,
> +				xen_dt_params[i].size * 2, val);
> +	}
> +
> +	return 1;
> +}
>  static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
>  				       int depth, void *data)
>  {
> @@ -538,12 +587,20 @@ int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
>  	info.found = 0;
>  	info.params = params;
>  
> -	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
> -	if (!info.found)
> +	if (xen_initial_domain())
> +		ret = of_scan_flat_dt(fdt_find_xen_uefi_params, &info);
> +	else
> +		ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
> +	if (!info.found) {
>  		pr_info("UEFI not found.\n");
> -	else if (!ret)
> -		pr_err("Can't find '%s' in device tree!\n",
> -		       dt_params[info.found].name);
> +	} else if (!ret) {
> +		if (xen_initial_domain())
> +			pr_err("Can't find '%s' in device tree!\n",
> +			       xen_dt_params[info.found].name);
> +		else
> +			pr_err("Can't find '%s' in device tree!\n",
> +			       xen_dt_params[info.found].name);

xen_dt_params is obviously wrong here
