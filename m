From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH V2 2/3] efi: Introduce efi_rts_workqueue and some
 infrastructure to invoke all efi_runtime_services()
Date: Tue, 6 Mar 2018 11:13:41 +0000
Message-ID: <20180306111339.xjrugce553f2egzh@lakrids.cambridge.arm.com>
References: <1520292190-5027-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520292190-5027-3-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Lee@lakrids.cambridge.arm.com, Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Zijlstra <peter.zijlstra@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 05, 2018 at 03:23:09PM -0800, Sai Praneeth Prakhya wrote:
> @@ -329,6 +331,19 @@ static int __init efisubsys_init(void)
>  		return 0;
>  
>  	/*
> +	 * Since we process only one efi_runtime_service() at a time, an
> +	 * ordered workqueue (which creates only one execution context)
> +	 * should suffice all our needs.
> +	 */
> +	efi_rts_wq = alloc_ordered_workqueue("efi_rts_workqueue", 0);
> +	if (!efi_rts_wq) {
> +		pr_err("Failed to create efi_rts_workqueue, EFI runtime services "
> +		       "disabled.\n");
> +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +		return 0;
> +	}

I'm a little worried that something might sample this flag between it
being set in an early_initcall (arm_enable_runtime_services), and
cleared in a subsys_initcall here.

However, nothing seems to do that so far, so maybe that's ok...

[...]

> +/* efi_runtime_service() function identifiers */
> +enum {
> +	GET_TIME,
> +	SET_TIME,
> +	GET_WAKEUP_TIME,
> +	SET_WAKEUP_TIME,
> +	GET_VARIABLE,
> +	GET_NEXT_VARIABLE,
> +	SET_VARIABLE,
> +	SET_VARIABLE_NONBLOCKING,
> +	QUERY_VARIABLE_INFO,
> +	QUERY_VARIABLE_INFO_NONBLOCKING,
> +	GET_NEXT_HIGH_MONO_COUNT,
> +	RESET_SYSTEM,
> +	UPDATE_CAPSULE,
> +	QUERY_CAPSULE_CAPS,
> +};

Can we please give this enum a name....

[...]

> +/*
> + * efi_runtime_work:	Details of EFI Runtime Service work
> + * @func:		EFI Runtime Service function identifier
> + * @arg<1-5>:		EFI Runtime Service function arguments
> + * @status:		Status of executing EFI Runtime Service
> + */
> +struct efi_runtime_work {
> +	u8 func;

... and use it here rather than an opaque u8? I realise that means
placing the enum in <linux/efi.h>.

> +	void *arg1;
> +	void *arg2;
> +	void *arg3;
> +	void *arg4;
> +	void *arg5;
> +	efi_status_t status;
> +	struct work_struct work;
> +};

Thanks,
Mark.
