From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [PATCH v3 10/17] arm/xen: Get event-channel irq through HVM_PARAM
 when booting with ACPI
Date: Mon, 25 Jan 2016 15:19:37 +0000
Message-ID: <alpine.DEB.2.02.1601251512580.9687@kaball.uk.xensource.com>
References: <1453519184-11908-1-git-send-email-zhaoshenglong@huawei.com>
 <1453519184-11908-11-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453519184-11908-11-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, 23 Jan 2016, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> When booting with ACPI, it could get the event-channel irq through
> HVM_PARAM_CALLBACK_IRQ.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/xen/enlighten.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 6d90a62..0e010bb 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -29,6 +29,7 @@
>  #include <linux/time64.h>
>  #include <linux/timekeeping.h>
>  #include <linux/timekeeper_internal.h>
> +#include <linux/acpi.h>
>  
>  #include <linux/mm.h>
>  
> @@ -262,6 +263,35 @@ void __init xen_early_init(void)
>  		add_preferred_console("hvc", 0, NULL);
>  }
>  
> +static void __init xen_acpi_guest_init_events_irq(void)

please rename it to "xen_acpi_guest_init"


> +{
> +#ifdef CONFIG_ACPI
> +	struct xen_hvm_param a;
> +	int interrupt, trigger, polarity;
> +
> +	a.domid = DOMID_SELF;
> +	a.index = HVM_PARAM_CALLBACK_IRQ;
> +	xen_events_irq = 0;
> +
> +	if (!HYPERVISOR_hvm_op(HVMOP_get_param, &a)) {
> +		if ((a.value >> 56) == HVM_PARAM_CALLBACK_TYPE_EVENT) {
> +			interrupt = a.value & 0xff;
> +			trigger = ((a.value >> 8) & 0x1) ? ACPI_EDGE_SENSITIVE
> +							 : ACPI_LEVEL_SENSITIVE;
> +			polarity = ((a.value >> 8) & 0x2) ? ACPI_ACTIVE_LOW
> +							  : ACPI_ACTIVE_HIGH;
> +			xen_events_irq = acpi_register_gsi(NULL, interrupt,
> +							   trigger, polarity);
> +		}
> +	}
> +#endif
> +}
> +
> +static void __init xen_dt_guest_init_events_irq(void)

"xen_dt_guest_init"

Provided that you make these two changes:

Reviewed-by: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>



> +{
> +	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
> +}
> +
>  static int __init xen_guest_init(void)
>  {
>  	struct xen_add_to_physmap xatp;
> @@ -270,7 +300,11 @@ static int __init xen_guest_init(void)
>  	if (!xen_domain())
>  		return 0;
>  
> -	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
> +	if (!acpi_disabled)
> +		xen_acpi_guest_init_events_irq();
> +	else
> +		xen_dt_guest_init_events_irq();
> +
>  	if (!xen_events_irq) {
>  		pr_err("Xen event channel interrupt not found\n");
>  		return -ENODEV;
> -- 
> 2.0.4
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
