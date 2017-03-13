From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V12 09/10] trace, ras: add ARM processor error trace
 event
Date: Mon, 13 Mar 2017 09:58:52 -0400
Message-ID: <20170313095852.0c424d53@gandalf.local.home>
References: <1488833103-21082-1-git-send-email-tbaicar@codeaurora.org>
        <1488833103-21082-10-git-send-email-tbaicar@codeaurora.org>
        <58C12342.2090701@huawei.com>
        <14545228-7ff1-b31c-1fa5-daacf89a44b9@codeaurora.org>
        <58C60485.2070509@huawei.com>
        <58C65FCB.3040508@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <58C65FCB.3040508@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: "Baicar, Tyler" <tbaicar@codeaurora.org>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Mon, 13 Mar 2017 17:00:59 +0800
Xie XiuQi <xiexiuqi@huawei.com> wrote:

> ---
>  drivers/acpi/apei/ghes.c |  8 +++++
>  include/linux/cper.h     |  5 +++
>  include/ras/ras_event.h  | 87 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 100 insertions(+)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 251d7e0..6d34c26 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -518,9 +518,17 @@ static void ghes_do_proc(struct ghes *ghes,
>  		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARM) &&
>  			 trace_arm_event_enabled()) {
>  			struct cper_sec_proc_arm *arm_err;
> +			struct cper_arm_err_info *err_info;
> +			int i;
> 
>  			arm_err = acpi_hest_generic_data_payload(gdata);
>  			trace_arm_event(arm_err);
> +

		if (trace_arm_proc_err_enabled()) {

> +			err_info = (struct cper_arm_err_info *)(arm_err + 1);
> +			for (i = 0; i < arm_err->err_info_num; i++) {
> +				trace_arm_proc_err(err_info);
> +				err_info += 1;
> +			}

		}

-- Steve

>  		} else if (trace_unknown_sec_event_enabled()) {
>  			void *unknown_err = acpi_hest_generic_data_payload(gdata);
>  			trace_unknown_sec_event(&sec_type,
> diff --git a/include/linux/cper.h b/include/linux/cper.h
