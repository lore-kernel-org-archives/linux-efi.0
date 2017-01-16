From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V7 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Mon, 16 Jan 2017 11:53:10 +0000
Message-ID: <20170116115309.GE1510@arm.com>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-5-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484244924-24786-5-git-send-email-tbaicar@codeaurora.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, S
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 12, 2017 at 11:15:18AM -0700, Tyler Baicar wrote:
> SEA exceptions are often caused by an uncorrected hardware
> error, and are handled when data abort and instruction abort
> exception classes have specific values for their Fault Status
> Code.
> When SEA occurs, before killing the process, go through
> the handlers registered in the notification list.
> Update fault_info[] with specific SEA faults so that the
> new SEA handler is used.
> 
> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
> ---
>  arch/arm64/include/asm/system_misc.h | 13 ++++++++
>  arch/arm64/mm/fault.c                | 58 +++++++++++++++++++++++++++++-------
>  2 files changed, 61 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
> index 57f110b..e7f3440 100644
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
> +int register_sea_notifier(struct notifier_block *nb);
> +void unregister_sea_notifier(struct notifier_block *nb);

I still don't understand why you need notifiers for this. You register
precisely one hook in the series.

>  #endif	/* __ASM_SYSTEM_MISC_H */
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 05d2bd7..81039c7 100644
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
> +int register_sea_notifier(struct notifier_block *nb)
> +{
> +	return atomic_notifier_chain_register(&sea_handler_chain, nb);
> +}
> +
> +void unregister_sea_notifier(struct notifier_block *nb)
> +{
> +	atomic_notifier_chain_unregister(&sea_handler_chain, nb);
> +}
> +
>  static const char *fault_name(unsigned int esr);
>  
>  #ifdef CONFIG_KPROBES
> @@ -480,6 +496,28 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
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
> +
> +	return 0;
> +}
> +
>  static const struct fault_info {
>  	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
>  	int	sig;
> @@ -502,22 +540,22 @@ static const struct fault_info {
>  	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
>  	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
>  	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
> +	{ do_sea,		SIGBUS,  0,		"synchronous external abort"	},
>  	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
>  	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
>  	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
> +	{ do_sea,		SIGBUS,  0,		"level 0 SEA (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"level 1 SEA (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"level 2 SEA (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"level 3 SEA (translation table walk)"	},

Perhaps I wasn't clear enough in my previous review, but please expand the
acronym for strings and comments.

> +	{ do_sea,		SIGBUS,  0,		"synchronous parity or ECC err" },

s/err/error/

Will
