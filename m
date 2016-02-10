From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V1 4/6] arm64: exception: handle Synchronous External
 Abort
Date: Wed, 10 Feb 2016 18:03:45 +0000
Message-ID: <20160210180344.GV1052@arm.com>
References: <1454699608-22760-1-git-send-email-tbaicar@codeaurora.org>
 <1454699608-22760-5-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454699608-22760-5-git-send-email-tbaicar@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: fu.wei@linaro.org, timur@codeaurora.org, harba@codeaurora.org, rruigrok@codeaurora.org, ahs3@redhat.com, Catalin Marinas <catalin.marinas@arm.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Naveen Kaje <nkaje@codeaurora.org>, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 05, 2016 at 12:13:26PM -0700, Tyler Baicar wrote:
> SEA exceptions are often caused by an uncorrected hardware
> error and are handled when data abort and instruction abort
> exception classes have specific values for their Fault Status
> Code.
> 
> When SEA occurs, before killing the process, go through
> the handlers registered in the notification list.
> 
> Update fault_info[] with specific SEA faults so that the
> new SEA handler is used.
> 
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
> ---
>  arch/arm64/include/asm/system_misc.h | 13 ++++++++
>  arch/arm64/mm/fault.c                | 58 +++++++++++++++++++++++++++++-------
>  2 files changed, 61 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
> index 57f110b..90daf4a 100644
> --- a/arch/arm64/include/asm/system_misc.h
> +++ b/arch/arm64/include/asm/system_misc.h
> @@ -64,4 +64,17 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
>  
>  #endif	/* __ASSEMBLY__ */
>  
> +/*
> + * The functions below are used to register and unregister callbacks
> + * that are to be invoked when a Synchronous External Abort (SEA)
> + * occurs. An SEA is raised by certain fault status codes that have
> + * either data or instruction abort as the exception class, and
> + * callbacks may be registered to parse or handle such hardware errors.
> + *
> + * Registered callbacks are run in an interrupt/atomic context. They
> + * are not allowed to block or sleep.
> + */
> +int sea_register_handler_chain(struct notifier_block *nb);
> +void sea_unregister_handler_chain(struct notifier_block *nb);
> +
>  #endif	/* __ASM_SYSTEM_MISC_H */
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 92ddac1..d6fa691 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -39,6 +39,22 @@
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
>  
> +/*
> + * GHES SEA handler code may register a notifier call here to
> + * handle HW error record passed from platform.
> + */
> +static ATOMIC_NOTIFIER_HEAD(sea_handler_chain);
> +
> +int sea_register_handler_chain(struct notifier_block *nb)
> +{
> +	return atomic_notifier_chain_register(&sea_handler_chain, nb);
> +}
> +
> +void sea_unregister_handler_chain(struct notifier_block *nb)
> +{
> +	atomic_notifier_chain_unregister(&sea_handler_chain, nb);
> +}
> +
>  static const char *fault_name(unsigned int esr);
>  
>  /*
> @@ -379,6 +395,28 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>  	return 1;
>  }
>  
> +/*
> + * This abort handler deals with Synchronous External Abort.
> + * It calls notifiers, and then returns "fault".
> + */
> +static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
> +{
> +	struct siginfo info;
> +
> +	atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
> +
> +	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
> +		 fault_name(esr), esr, addr);
> +
> +	info.si_signo = SIGBUS;
> +	info.si_errno = 0;
> +	info.si_code  = 0;
> +	info.si_addr  = (void __user *)addr;
> +	arm64_notify_die("", regs, &info, esr);

Surely we don't want to call this if the notifier chain handled the
exception?

Will
