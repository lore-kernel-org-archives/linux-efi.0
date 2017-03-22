From: Xie XiuQi <xiexiuqi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V13 09/10] trace, ras: add ARM processor error trace event
Date: Wed, 22 Mar 2017 10:48:58 +0800
Message-ID: <e1e63cbb-a75e-af11-4fa0-446b40999ee8__43392.8081453361$1490151099$gmane$org@huawei.com>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-10-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490136425-4324-10-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm@vg
List-Id: linux-efi@vger.kernel.org

Reviewed-by: Xie XiuQi <xiexiuqi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 2017/3/22 6:47, Tyler Baicar wrote:
> Currently there are trace events for the various RAS
> errors with the exception of ARM processor type errors.
> Add a new trace event for such errors so that the user
> will know when they occur. These trace events are
> consistent with the ARM processor error section type
> defined in UEFI 2.6 spec section N.2.4.4.
> 
> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Acked-by: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> ---
>  drivers/acpi/apei/ghes.c    |  8 +++++++-
>  drivers/firmware/efi/cper.c |  1 +
>  drivers/ras/ras.c           |  1 +
>  include/ras/ras_event.h     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 3ecbacc..230b095 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -515,7 +515,13 @@ static void ghes_do_proc(struct ghes *ghes,
>  		}
>  #endif
>  #ifdef CONFIG_RAS
> -		else if (trace_unknown_sec_event_enabled()) {
> +		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARM) &&
> +			 trace_arm_event_enabled()) {
> +			struct cper_sec_proc_arm *arm_err;
> +
> +			arm_err = acpi_hest_generic_data_payload(gdata);
> +			trace_arm_event(arm_err);
> +		} else if (trace_unknown_sec_event_enabled()) {
>  			void *unknown_err = acpi_hest_generic_data_payload(gdata);
>  			trace_unknown_sec_event(&sec_type,
>  					fru_id, fru_text, sec_sev,
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index d263bc8..37a39af 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -35,6 +35,7 @@
>  #include <linux/printk.h>
>  #include <linux/bcd.h>
>  #include <acpi/ghes.h>
> +#include <ras/ras_event.h>
>  
>  #define INDENT_SP	" "
>  
> diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
> index fb2500b..8ba5a94 100644
> --- a/drivers/ras/ras.c
> +++ b/drivers/ras/ras.c
> @@ -28,3 +28,4 @@ static int __init ras_init(void)
>  #endif
>  EXPORT_TRACEPOINT_SYMBOL_GPL(mc_event);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(unknown_sec_event);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(arm_event);
> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
> index 5861b6f..13befad 100644
> --- a/include/ras/ras_event.h
> +++ b/include/ras/ras_event.h
> @@ -162,6 +162,51 @@
>  );
>  
>  /*
> + * ARM Processor Events Report
> + *
> + * This event is generated when hardware detects an ARM processor error
> + * has occurred. UEFI 2.6 spec section N.2.4.4.
> + */
> +TRACE_EVENT(arm_event,
> +
> +	TP_PROTO(const struct cper_sec_proc_arm *proc),
> +
> +	TP_ARGS(proc),
> +
> +	TP_STRUCT__entry(
> +		__field(u64, mpidr)
> +		__field(u64, midr)
> +		__field(u32, running_state)
> +		__field(u32, psci_state)
> +		__field(u8, affinity)
> +	),
> +
> +	TP_fast_assign(
> +		if (proc->validation_bits & CPER_ARM_VALID_AFFINITY_LEVEL)
> +			__entry->affinity = proc->affinity_level;
> +		else
> +			__entry->affinity = ~0;
> +		if (proc->validation_bits & CPER_ARM_VALID_MPIDR)
> +			__entry->mpidr = proc->mpidr;
> +		else
> +			__entry->mpidr = 0ULL;
> +		__entry->midr = proc->midr;
> +		if (proc->validation_bits & CPER_ARM_VALID_RUNNING_STATE) {
> +			__entry->running_state = proc->running_state;
> +			__entry->psci_state = proc->psci_state;
> +		} else {
> +			__entry->running_state = ~0;
> +			__entry->psci_state = ~0;
> +		}
> +	),
> +
> +	TP_printk("affinity level: %d; MPIDR: %016llx; MIDR: %016llx; "
> +		  "running state: %d; PSCI state: %d",
> +		  __entry->affinity, __entry->mpidr, __entry->midr,
> +		  __entry->running_state, __entry->psci_state)
> +);
> +
> +/*
>   * Unknown Section Report
>   *
>   * This event is generated when hardware detected a hardware
> 

-- 
Thanks,
Xie XiuQi
