From: Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH v2 09/16] arm/xen: Get event-channel irq
 through HVM_PARAM when booting with ACPI
Date: Mon, 18 Jan 2016 14:38:27 +0000
Message-ID: <alpine.DEB.2.02.1601181351400.16178@kaball.uk.xensource.com>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-10-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452840929-19612-10-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 15 Jan 2016, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> When booting with ACPI, it could get the event-channel irq through
> HVM_PARAM_CALLBACK_IRQ.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/xen/enlighten.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 6d90a62..4e78c49 100644
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
> @@ -270,7 +271,34 @@ static int __init xen_guest_init(void)
>  	if (!xen_domain())
>  		return 0;
>  
> -	xen_events_irq = irq_of_parse_and_map(xen_node, 0);
> +	if (!acpi_disabled) {
> +#ifdef CONFIG_ACPI

I think it would be best to move the acpi specific and DT specific
initializations out of xen_guest_init. Then at the beginning of
xen_guest_init, call only the one that applies.  The acpi init function
could be ifdef'ed CONFIG_ACPI. Making sure that acpi_disabled is 1 when
!CONFIG_ACPI, we could even avoid all ifdef's from xen_guest_init.

The rest is good, thanks.


> +		struct xen_hvm_param a;
> +		int interrupt, trigger, polarity;
> +
> +		a.domid = DOMID_SELF;
> +		a.index = HVM_PARAM_CALLBACK_IRQ;
> +		xen_events_irq = 0;
> +		if (!HYPERVISOR_hvm_op(HVMOP_get_param, &a)) {
> +			if ((a.value >> 56) == 3) {
> +				interrupt = a.value & 0xff;
> +				trigger = ((a.value >> 8) & 0x1)
> +					  ? ACPI_EDGE_SENSITIVE
> +					  : ACPI_LEVEL_SENSITIVE;
> +				polarity = ((a.value >> 8) & 0x2)
> +					  ? ACPI_ACTIVE_LOW
> +					  : ACPI_ACTIVE_HIGH;
> +				xen_events_irq = acpi_register_gsi(NULL,
> +								   interrupt,
> +								   trigger,
> +								   polarity);
> +			}
> +		}
> +
> +#endif
> +	} else {
> +		xen_events_irq = irq_of_parse_and_map(xen_node, 0);
> +	}
> +
>  	if (!xen_events_irq) {
>  		pr_err("Xen event channel interrupt not found\n");
>  		return -ENODEV;
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
