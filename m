From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V16 09/11] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Tue, 16 May 2017 16:38:02 +0200
Message-ID: <20170516143802.tywhlubcg43h6iqe@pd.tnic>
References: <1494883680-25551-1-git-send-email-tbaicar@codeaurora.org>
 <1494883680-25551-10-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494883680-25551-10-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, May 15, 2017 at 03:27:58PM -0600, Tyler Baicar wrote:
> The UEFI spec includes non-standard section type support in the
> Common Platform Error Record. This is defined in section N.2.3 of
> UEFI version 2.5.
> 
> Currently if the CPER section's type (UUID) does not match any
> section type that the kernel knows how to parse, a trace event is
> not generated.
> 
> Generate a trace event which contains the raw error data for
> non-standard section type error records.
> 
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Tested-by: Shiju Jose <shiju.jose@huawei.com>
> ---
>  drivers/acpi/apei/ghes.c  | 27 +++++++++++++++++++++++----
>  drivers/ras/ras.c         |  9 +++++++++
>  include/linux/ras.h       | 12 ++++++++++++
>  include/ras/ras_event.h   | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/uuid.h |  6 ++++--
>  5 files changed, 93 insertions(+), 6 deletions(-)

This patch doesn't apply cleanly against 4.12-rc1. Please rediff it.

> diff --git a/drivers/ras/ras.c b/drivers/ras/ras.c
> index b67dd36..57363be 100644
> --- a/drivers/ras/ras.c
> +++ b/drivers/ras/ras.c
> @@ -7,11 +7,19 @@
>  
>  #include <linux/init.h>
>  #include <linux/ras.h>
> +#include <linux/uuid.h>
>  
>  #define CREATE_TRACE_POINTS
>  #define TRACE_INCLUDE_PATH ../../include/ras
>  #include <ras/ras_event.h>
>  
> +void call_non_standard_trace_event(const uuid_le *sec_type,

You are not calling a non-standard trace event - you're logging it:

log_non_standard_event()

> +		 const uuid_le *fru_id, const char *fru_text, const u8 sev,
> +		 const u8 *err, const u32 len)

Align arguments at opening brace.

> +{
> +	trace_non_standard_event(sec_type, fru_id, fru_text, sev, err, len);
> +}
> +
>  static int __init ras_init(void)
>  {
>  	int rc = 0;

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
