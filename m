From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V8 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Fri, 3 Feb 2017 13:24:38 -0700
Message-ID: <12162620-6b88-50af-ec05-8173a0ce59f0@codeaurora.org>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
 <1485969413-23577-5-git-send-email-tbaicar@codeaurora.org>
 <5894A8E5.6000803@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <5894A8E5.6000803@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Po
List-Id: linux-efi@vger.kernel.org

Hello James,


On 2/3/2017 8:59 AM, James Morse wrote:
> On 01/02/17 17:16, Tyler Baicar wrote:
>> SEA exceptions are often caused by an uncorrected hardware
>> error, and are handled when data abort and instruction abort
>> exception classes have specific values for their Fault Status
>> Code.
>> When SEA occurs, before killing the process, report the error
>> in the kernel logs.
>> Update fault_info[] with specific SEA faults so that the
>> new SEA handler is used.
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 156169c..9ae7e65 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -487,6 +487,31 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   	return 1;
>>   }
>>   
>> +#define SEA_FnV_MASK	0x00000400
> There are a glut of ESR_ELx_ macros in arch/arm64/include/asm/esr.h, could this
> be fitted in there in a similar format?
>
>
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -83,6 +83,7 @@
>   #define ESR_ELx_WNR            (UL(1) << 6)
>
>   /* Shared ISS field definitions for Data/Instruction aborts */
> +#define ESR_ELx_FnV            (UL(1) << 10)
>   #define ESR_ELx_EA             (UL(1) << 9)
>   #define ESR_ELx_S1PTW          (UL(1) << 7)
I'll make this change in the next version.
>> +
>> +/*
>> + * This abort handler deals with Synchronous External Abort.
>> + * It calls notifiers, and then returns "fault".
>> + */
>> +static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>> +{
>> +	struct siginfo info;
>> +
>> +	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>> +		 fault_name(esr), esr, addr);
>> +
>> +	info.si_signo = SIGBUS;
>> +	info.si_errno = 0;
>> +	info.si_code  = 0;
>> +	if (esr & SEA_FnV_MASK)
>> +		info.si_addr = 0;
>> +	else
>> +		info.si_addr  = (void __user *)addr;
>> +	arm64_notify_die("", regs, &info, esr);
>> +
>> +	return 0;
>> +}
>> +
>>   static const struct fault_info {
>>   	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
>>   	int	sig;
>> @@ -509,22 +534,22 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
>> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
>> +	{ do_sea,		SIGBUS,  0,		"synchronous external abort"	},
> This will print:
>> Synchronous External Abort: synchronous external abort
> It looks odd, but I can't think of anything better to put there.
>
>
>>   	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
>> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 0 (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 1 (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 2 (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 3 (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"synchronous parity or ECC error" },
>>   	{ do_bad,		SIGBUS,  0,		"unknown 25"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 27"			},
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
>> +	{ do_sea,		SIGBUS,  0,		"level 0 synchronous parity error (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 1 synchronous parity error (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 2 synchronous parity error (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 3 synchronous parity error (translation table walk)"	},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 32"			},
>>   	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 34"			},
>>
>
> With the ESR_ELx_FnV change above,
> Reviewed-by: James Morse <james.morse@arm.com>
>
Great, thanks!

Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

