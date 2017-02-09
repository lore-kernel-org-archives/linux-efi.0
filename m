From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V8 06/10] acpi: apei: panic OS with fatal error status
 block
Date: Thu, 09 Feb 2017 10:48:42 +0000
Message-ID: <589C490A.9080109@arm.com>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
 <1485969413-23577-7-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1485969413-23577-7-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tyler Baicar <tbaicar@codeaurora.org>, zjzhang@codeaurora.org
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hi Jonathan, Tyler,

On 01/02/17 17:16, Tyler Baicar wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
> 
> Even if an error status block's severity is fatal, the kernel does not
> honor the severity level and panic.
> 
> With the firmware first model, the platform could inform the OS about a
> fatal hardware error through the non-NMI GHES notification type. The OS
> should panic when a hardware error record is received with this
> severity.
> 
> Call panic() after CPER data in error status block is printed if
> severity is fatal, before each error section is handled.

> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 8756172..86c1f15 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -687,6 +689,13 @@ static int ghes_ack_error(struct acpi_hest_generic_v2 *generic_v2)
>  	return rc;
>  }
>  
> +static void __ghes_call_panic(void)
> +{
> +	if (panic_timeout == 0)
> +		panic_timeout = ghes_panic_timeout;
> +	panic("Fatal hardware error!");
> +}
> +

__ghes_panic() also has:
>	__ghes_print_estatus(KERN_EMERG, ghes->generic, ghes->estatus);

Which prints this estatus regardless of rate limiting and cache-ing.

[ ... ]

> @@ -698,6 +707,10 @@ static int ghes_proc(struct ghes *ghes)
>  		if (ghes_print_estatus(NULL, ghes->generic, ghes->estatus))

ghes_print_estatus() uses some custom rate limiting '2 messages every 5
seconds', GHES_SEV_PANIC shares the same limit as GHES_SEV_RECOVERABLE.

I think its possible to get 2 recoverable messages, then a panic in a 5 second
window. The rate limit will kick in to stop the panic estatus block being
printed, but we still go on to call panic() without the real reason being printed...

(the caching thing only seems to consider identical messages, given we would
never see two panic messages, I don't think that will cause any problems.)

>  			ghes_estatus_cache_add(ghes->generic, ghes->estatus);
>  	}
> +	if (ghes_severity(ghes->estatus->error_severity) >= GHES_SEV_PANIC) {
> +		__ghes_call_panic();
> +	}
> +

I think this ghes_severity() then panic() should go above the:
>	if (!ghes_estatus_cached(ghes->estatus)) {
and we should call __ghes_print_estatus() here too, to make sure the message
definitely got out!


With that,
Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
