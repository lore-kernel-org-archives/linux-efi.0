From: Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3 v2] arm/xen: Consolidate calls to shutdown hypercall
 in a single helper
Date: Mon, 24 Apr 2017 12:30:50 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1704241230090.16723@sstabellini-ThinkPad-X260>
References: <20170424175839.5262-1-julien.grall@arm.com> <20170424175839.5262-3-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170424175839.5262-3-julien.grall-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>
Cc: xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 24 Apr 2017, Julien Grall wrote:
> Signed-off-by: Julien Grall <julien.grall-5wv7dgnIgG8@public.gmane.org>

Reviewed-by: Stefano Stabellini <sstabellini-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>


> ---
>     Changes in v2:
>         - Patch added
> ---
>  arch/arm/xen/enlighten.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 81e3217b12d3..ba7f4c8f5c3e 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -191,20 +191,24 @@ static int xen_dying_cpu(unsigned int cpu)
>  	return 0;
>  }
>  
> -static void xen_restart(enum reboot_mode reboot_mode, const char *cmd)
> +void xen_reboot(int reason)
>  {
> -	struct sched_shutdown r = { .reason = SHUTDOWN_reboot };
> +	struct sched_shutdown r = { .reason = reason };
>  	int rc;
> +
>  	rc = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
>  	BUG_ON(rc);
>  }
>  
> +static void xen_restart(enum reboot_mode reboot_mode, const char *cmd)
> +{
> +	xen_reboot(SHUTDOWN_reboot);
> +}
> +
> +
>  static void xen_power_off(void)
>  {
> -	struct sched_shutdown r = { .reason = SHUTDOWN_poweroff };
> -	int rc;
> -	rc = HYPERVISOR_sched_op(SCHEDOP_shutdown, &r);
> -	BUG_ON(rc);
> +	xen_reboot(SHUTDOWN_poweroff);
>  }
>  
>  static irqreturn_t xen_arm_callback(int irq, void *arg)
> -- 
> 2.11.0
> 
