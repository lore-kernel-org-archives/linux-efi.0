From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V15 10/11] trace, ras: add ARM processor error trace event
Date: Mon, 8 May 2017 19:34:08 +0200
Message-ID: <20170508173408.njiuvnqf3zi5pinm@pd.tnic>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-11-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <1492556723-9189-11-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, rafael@kernel.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, gengdongjiu@huawei.com, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, tony.luck@intel.com, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 18, 2017 at 05:05:22PM -0600, Tyler Baicar wrote:
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
>  drivers/acpi/apei/ghes.c    |  8 +++++++-
>  drivers/firmware/efi/cper.c |  1 +
>  drivers/ras/ras.c           |  1 +
>  include/ras/ras_event.h     | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 3d9f63b..612deb3 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -518,7 +518,13 @@ static void ghes_do_proc(struct ghes *ghes,
>  		}
>  #endif
>  #ifdef CONFIG_RAS
> -		else if (trace_unknown_sec_event_enabled()) {
> +		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARM) &&
> +			 trace_arm_event_enabled()) {
> +			struct cper_sec_proc_arm *arm_err;
> +
> +			arm_err = acpi_hest_get_payload(gdata);
> +			trace_arm_event(arm_err);
> +		} else if (trace_unknown_sec_event_enabled()) {
>  			void *unknown_err = acpi_hest_get_payload(gdata);
>  
>  			trace_unknown_sec_event(&sec_type,

As with the previous patch, move that code to ras.c so that you can get rid of
the ifdeffery here.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
