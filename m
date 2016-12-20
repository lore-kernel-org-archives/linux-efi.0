From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH V6 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Tue, 20 Dec 2016 15:29:38 +0000
Message-ID: <58594E62.3050003@arm.com>
References: <1481147303-7979-1-git-send-email-tbaicar@codeaurora.org> <1481147303-7979-6-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481147303-7979-6-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, Suzuki.Po
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 07/12/16 21:48, Tyler Baicar wrote:
> ARM APEI extension proposal added SEA (Synchrounous External
> Abort) notification type for ARMv8.
> Add a new GHES error source handling function for SEA. If an error
> source's notification type is SEA, then this function can be registered
> into the SEA exception handler. That way GHES will parse and report
> SEA exceptions when they occur.

> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 2acbc60..66ab3fd 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -767,6 +771,62 @@ static struct notifier_block ghes_notifier_sci = {
>  	.notifier_call = ghes_notify_sci,
>  };
>  
> +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
> +static LIST_HEAD(ghes_sea);
> +
> +static int ghes_notify_sea(struct notifier_block *this,
> +				  unsigned long event, void *data)
> +{
> +	struct ghes *ghes;
> +	int ret = NOTIFY_DONE;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
> +		if (!ghes_proc(ghes))
> +			ret = NOTIFY_OK;
> +	}
> +	rcu_read_unlock();
> +
> +	return ret;
> +}

What stops this from being re-entrant?

ghes_copy_tofrom_phs() takes the ghes_ioremap_lock_irq spinlock, but there is
nothing to stop a subsequent instruction fetch or memory access causing another
(maybe different) Synchronous External Abort which deadlocks trying to take the
same lock.

ghes_notify_sea() looks to be based on ghes_notify_sci(), which (if I've found
the right part of the ACPI spec) is a level-low interrupt. spin_lock_irqsave()
would mask interrupts so there is no risk of a different notification firing on
the same CPU, (it looks like they are almost all ultimately an irq).

NMI is the odd one out because its not maskable like this, but ghes_notify_nmi()
has:
>	if (!atomic_add_unless(&ghes_in_nmi, 1, 1))
> 		return ret;

To ensure there is only ever one thread poking around in this code.

What happens if a system describes two GHES sources, one using an irq the other
SEA? The SEA error can interrupt the irq error while its holding the above lock.
I guess this is also why all the NMI code in that file is separate.


Thanks,

James
