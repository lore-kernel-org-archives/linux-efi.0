From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v3 11/17] ARM: XEN: Move xen_early_init() before
 efi_init()
Date: Mon, 25 Jan 2016 15:25:01 +0000
Message-ID: <alpine.DEB.2.02.1601251524470.9687@kaball.uk.xensource.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
 <1453519184-11908-12-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453519184-11908-12-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 23 Jan 2016, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> Move xen_early_init() before efi_init(), then when calling efi_init()
> could initialize Xen specific UEFI.
> 
> Check if it runs on Xen hypervisor through the flat dts.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>


>  arch/arm/xen/enlighten.c  | 56 ++++++++++++++++++++++++++++++++++-------------
>  arch/arm64/kernel/setup.c |  2 +-
>  2 files changed, 42 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 0e010bb..cdc0bd2 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -19,6 +19,7 @@
>  #include <linux/irqreturn.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_fdt.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_address.h>
>  #include <linux/cpuidle.h>
> @@ -52,8 +53,6 @@ struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initdata;
>  
>  static __read_mostly unsigned int xen_events_irq;
>  
> -static __initdata struct device_node *xen_node;
> -
>  int xen_remap_domain_gfn_array(struct vm_area_struct *vma,
>  			       unsigned long addr,
>  			       xen_pfn_t *gfn, int nr,
> @@ -222,6 +221,33 @@ static irqreturn_t xen_arm_callback(int irq, void *arg)
>  	return IRQ_HANDLED;
>  }
>  
> +static __initdata struct {
> +	const char *compat;
> +	const char *prefix;
> +	const char *version;
> +	bool found;
> +} hyper_node = {"xen,xen", "xen,xen-", NULL, false};
> +
> +static int __init fdt_find_hyper_node(unsigned long node, const char *uname,
> +				      int depth, void *data)
> +{
> +	const void *s = NULL;
> +	int len;
> +
> +	if (depth != 1 || strcmp(uname, "hypervisor") != 0)
> +		return 0;
> +
> +	if (of_flat_dt_is_compatible(node, hyper_node.compat))
> +		hyper_node.found = true;
> +
> +	s = of_get_flat_dt_prop(node, "compatible", &len);
> +	if (strlen(hyper_node.prefix) + 3  < len &&
> +	    !strncmp(hyper_node.prefix, s, strlen(hyper_node.prefix)))
> +		hyper_node.version = s + strlen(hyper_node.prefix);
> +
> +	return 0;
> +}
> +
>  /*
>   * see Documentation/devicetree/bindings/arm/xen.txt for the
>   * documentation of the Xen Device Tree format.
> @@ -229,26 +255,18 @@ static irqreturn_t xen_arm_callback(int irq, void *arg)
>  #define GRANT_TABLE_PHYSADDR 0
>  void __init xen_early_init(void)
>  {
> -	int len;
> -	const char *s = NULL;
> -	const char *version = NULL;
> -	const char *xen_prefix = "xen,xen-";
> -
> -	xen_node = of_find_compatible_node(NULL, NULL, "xen,xen");
> -	if (!xen_node) {
> +	of_scan_flat_dt(fdt_find_hyper_node, NULL);
> +	if (!hyper_node.found) {
>  		pr_debug("No Xen support\n");
>  		return;
>  	}
> -	s = of_get_property(xen_node, "compatible", &len);
> -	if (strlen(xen_prefix) + 3  < len &&
> -			!strncmp(xen_prefix, s, strlen(xen_prefix)))
> -		version = s + strlen(xen_prefix);
> -	if (version == NULL) {
> +
> +	if (hyper_node.version == NULL) {
>  		pr_debug("Xen version not found\n");
>  		return;
>  	}
>  
> -	pr_info("Xen %s support found\n", version);
> +	pr_info("Xen %s support found\n", hyper_node.version);
>  
>  	xen_domain_type = XEN_HVM_DOMAIN;
>  
> @@ -289,6 +307,14 @@ static void __init xen_acpi_guest_init_events_irq(void)
>  
>  static void __init xen_dt_guest_init_events_irq(void)
>  {
> +	struct device_node *xen_node;
> +
> +	xen_node = of_find_compatible_node(NULL, NULL, "xen,xen");
> +	if (!xen_node) {
> +		pr_err("Xen support was detected before, but it has disappeared\n");
> +		return;
> +	}
> +
>  	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
>  }
>  
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index 8119479..a4a2878 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -313,6 +313,7 @@ void __init setup_arch(char **cmdline_p)
>  	 */
>  	local_async_enable();
>  
> +	xen_early_init();
>  	efi_init();
>  	arm64_memblock_init();
>  
> @@ -334,7 +335,6 @@ void __init setup_arch(char **cmdline_p)
>  	} else {
>  		psci_acpi_init();
>  	}
> -	xen_early_init();
>  
>  	cpu_read_bootcpu_ops();
>  	smp_init_cpus();
> -- 
> 2.0.4
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
