From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 13/16] ARM: XEN: Set EFI_PARAVIRT if Xen supports EFI
Date: Mon, 18 Jan 2016 10:57:32 +0000
Message-ID: <20160118105732.GE21067@leverpostej>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-14-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452840929-19612-14-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 15, 2016 at 02:55:26PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Check if there is "uefi" node in the DT. If so, set EFI_PARAVIRT flag.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/xen/enlighten.c | 23 +++++++++++++++++++++++
>  arch/arm64/kernel/efi.c  |  5 +++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 5d0fe68..485e117 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -31,6 +31,7 @@
>  #include <linux/timekeeping.h>
>  #include <linux/timekeeper_internal.h>
>  #include <linux/acpi.h>
> +#include <linux/efi.h>
>  
>  #include <linux/mm.h>
>  
> @@ -248,6 +249,19 @@ static int __init fdt_find_xen_node(unsigned long node, const char *uname,
>  	return 0;
>  }
>  
> +static int __init fdt_find_uefi_node(unsigned long node, const char *uname,
> +				     int depth, void *data)
> +{
> +	bool *found = data;
> +
> +	if (depth != 2 || strcmp(uname, "uefi") != 0)
> +		return 0;
> +
> +	*found = true;
> +
> +	return 1;
> +}

I don't like this. What if we had to add a uefi node in the !Xen case
for some reason?

You want to look for /hypervisor/uefi, specifically when the hypervisor
compatible contains "xen,xen".

It would be better to find the "/hypervisor" node, checking for the
compatible string, then walk within that in the Xen-specific init
routine.

> +
>  /*
>   * see Documentation/devicetree/bindings/arm/xen.txt for the
>   * documentation of the Xen Device Tree format.
> @@ -255,6 +269,8 @@ static int __init fdt_find_xen_node(unsigned long node, const char *uname,
>  #define GRANT_TABLE_PHYSADDR 0
>  void __init xen_early_init(void)
>  {
> +	bool uefi_found = false;
> +
>  	of_scan_flat_dt(fdt_find_xen_node, NULL);
>  	if (!xen_node.found) {
>  		pr_debug("No Xen support\n");
> @@ -279,6 +295,13 @@ void __init xen_early_init(void)
>  
>  	if (!console_set_on_cmdline && !xen_initial_domain())
>  		add_preferred_console("hvc", 0, NULL);
> +
> +	if (IS_ENABLED(CONFIG_XEN_EFI)) {
> +		/* Check if Xen support UEFI */
> +		of_scan_flat_dt(fdt_find_uefi_node, &uefi_found);
> +		if (uefi_found)
> +			set_bit(EFI_PARAVIRT, &efi.flags);
> +	}
>  }

This alone is insufficient given that we haven't parsed the rest of the
/hypervisor/uefi properties. Is the kernel resilient such that this
patch alone will not result in a panic?

I think it would be best for this to be in the same patch as the rest of
the hypervisor UEFI property parsing, being unified with that.

Mark.

>  static int __init xen_guest_init(void)
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 4eeb171..16c6b72 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -288,6 +288,11 @@ static int __init arm64_enable_runtime_services(void)
>  		return 0;
>  	}
>  
> +	if (efi_enabled(EFI_PARAVIRT)) {
> +		pr_info("EFI runtime services access via paravirt.\n");
> +		return -1;
> +	}
> +
>  	pr_info("Remapping and enabling EFI services.\n");
>  
>  	mapsize = memmap.map_end - memmap.map;
> -- 
> 2.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
