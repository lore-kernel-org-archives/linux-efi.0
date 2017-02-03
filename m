From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V8 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Fri, 03 Feb 2017 15:59:33 +0000
Message-ID: <5894A8E5.6000803@arm.com>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
 <1485969413-23577-5-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1485969413-23577-5-git-send-email-tbaicar@codeaurora.org>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 01/02/17 17:16, Tyler Baicar wrote:
> SEA exceptions are often caused by an uncorrected hardware
> error, and are handled when data abort and instruction abort
> exception classes have specific values for their Fault Status
> Code.
> When SEA occurs, before killing the process, report the error
> in the kernel logs.
> Update fault_info[] with specific SEA faults so that the
> new SEA handler is used.

> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 156169c..9ae7e65 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -487,6 +487,31 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>  	return 1;
>  }
>  
> +#define SEA_FnV_MASK	0x00000400

There are a glut of ESR_ELx_ macros in arch/arm64/include/asm/esr.h, could this
be fitted in there in a similar format?


--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -83,6 +83,7 @@
 #define ESR_ELx_WNR            (UL(1) << 6)

 /* Shared ISS field definitions for Data/Instruction aborts */
+#define ESR_ELx_FnV            (UL(1) << 10)
 #define ESR_ELx_EA             (UL(1) << 9)
 #define ESR_ELx_S1PTW          (UL(1) << 7)


> +
> +/*
> + * This abort handler deals with Synchronous External Abort.
> + * It calls notifiers, and then returns "fault".
> + */
> +static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
> +{
> +	struct siginfo info;
> +
> +	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
> +		 fault_name(esr), esr, addr);
> +
> +	info.si_signo = SIGBUS;
> +	info.si_errno = 0;
> +	info.si_code  = 0;
> +	if (esr & SEA_FnV_MASK)
> +		info.si_addr = 0;
> +	else
> +		info.si_addr  = (void __user *)addr;
> +	arm64_notify_die("", regs, &info, esr);
> +
> +	return 0;
> +}
> +
>  static const struct fault_info {
>  	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
>  	int	sig;
> @@ -509,22 +534,22 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>  	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
>  	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
>  	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
> +	{ do_sea,		SIGBUS,  0,		"synchronous external abort"	},

This will print:
> Synchronous External Abort: synchronous external abort

It looks odd, but I can't think of anything better to put there.


>  	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
>  	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
>  	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
> +	{ do_sea,		SIGBUS,  0,		"level 0 (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"level 1 (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"level 2 (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"level 3 (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"synchronous parity or ECC error" },
>  	{ do_bad,		SIGBUS,  0,		"unknown 25"			},
>  	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
>  	{ do_bad,		SIGBUS,  0,		"unknown 27"			},
> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
> +	{ do_sea,		SIGBUS,  0,		"level 0 synchronous parity error (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"level 1 synchronous parity error (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"level 2 synchronous parity error (translation table walk)"	},
> +	{ do_sea,		SIGBUS,  0,		"level 3 synchronous parity error (translation table walk)"	},
>  	{ do_bad,		SIGBUS,  0,		"unknown 32"			},
>  	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
>  	{ do_bad,		SIGBUS,  0,		"unknown 34"			},
> 


With the ESR_ELx_FnV change above,
Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
