From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V16 10/11] trace, ras: add ARM processor error trace event
Date: Tue, 16 May 2017 16:44:14 +0200
Message-ID: <20170516144414.7ym6o4psxw3lu5p2@pd.tnic>
References: <1494883680-25551-1-git-send-email-tbaicar@codeaurora.org>
 <1494883680-25551-11-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494883680-25551-11-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, May 15, 2017 at 03:27:59PM -0600, Tyler Baicar wrote:
> Currently there are trace events for the various RAS
> errors with the exception of ARM processor type errors.
> Add a new trace event for such errors so that the user
> will know when they occur. These trace events are
> consistent with the ARM processor error section type
> defined in UEFI 2.6 spec section N.2.4.4.
> 
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> Reviewed-by: Xie XiuQi <xiexiuqi@huawei.com>
> ---
>  drivers/acpi/apei/ghes.c    |  6 +++++-
>  drivers/firmware/efi/cper.c |  1 +
>  drivers/ras/ras.c           |  6 ++++++
>  include/linux/ras.h         |  3 +++
>  include/ras/ras_event.h     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 1106722..2dddb3b 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -518,7 +518,11 @@ static void ghes_do_proc(struct ghes *ghes,
>  
>  		}
>  #endif
> -		else {
> +		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARM)) {
> +			struct cper_sec_proc_arm *err = acpi_hest_get_payload(gdata);
> +
> +			call_arm_trace_event(err);
> +		} else {
>  			void *err = acpi_hest_get_payload(gdata);
>  
>  			call_non_standard_trace_event(&sec_type, fru_id,
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index d5a5855..48a8f69 100644
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
> index 57363be..8655ef4 100644
> --- a/drivers/ras/ras.c
> +++ b/drivers/ras/ras.c
> @@ -20,6 +20,11 @@ void call_non_standard_trace_event(const uuid_le *sec_type,
>  	trace_non_standard_event(sec_type, fru_id, fru_text, sev, err, len);
>  }
>  
> +void call_arm_trace_event(struct cper_sec_proc_arm *err)

log_arm_hw_error()

because it is exactly that - a hardware error.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
