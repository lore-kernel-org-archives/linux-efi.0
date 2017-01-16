From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V7 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Mon, 16 Jan 2017 13:09:22 -0700
Message-ID: <0ca6c70e-6033-4cca-8833-15cb8573a939@codeaurora.org>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-5-git-send-email-tbaicar@codeaurora.org>
 <20170116115309.GE1510@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20170116115309.GE1510@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hello Will,


On 1/16/2017 4:53 AM, Will Deacon wrote:
> On Thu, Jan 12, 2017 at 11:15:18AM -0700, Tyler Baicar wrote:
>> SEA exceptions are often caused by an uncorrected hardware
>> error, and are handled when data abort and instruction abort
>> exception classes have specific values for their Fault Status
>> Code.
>> When SEA occurs, before killing the process, go through
>> the handlers registered in the notification list.
>> Update fault_info[] with specific SEA faults so that the
>> new SEA handler is used.
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
>> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
>> ---
>>   arch/arm64/include/asm/system_misc.h | 13 ++++++++
>>   arch/arm64/mm/fault.c                | 58 +++++++++++++++++++++++++++++-------
>>   2 files changed, 61 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
>> index 57f110b..e7f3440 100644
>> --- a/arch/arm64/include/asm/system_misc.h
>> +++ b/arch/arm64/include/asm/system_misc.h
>> @@ -64,4 +64,17 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
>>   
>>   #endif	/* __ASSEMBLY__ */
>>   
>> +/*
>> + * The functions below are used to register and unregister callbacks
>> + * that are to be invoked when a Synchronous External Abort (SEA)
>> + * occurs. An SEA is raised by certain fault status codes that have
>> + * either data or instruction abort as the exception class, and
>> + * callbacks may be registered to parse or handle such hardware errors.
>> + *
>> + * Registered callbacks are run in an interrupt/atomic context. They
>> + * are not allowed to block or sleep.
>> + */
>> +int register_sea_notifier(struct notifier_block *nb);
>> +void unregister_sea_notifier(struct notifier_block *nb);
> I still don't understand why you need notifiers for this. You register
> precisely one hook in the series.
I didn't see a response to my last comment on the previous series so I 
just left it in for this series.
The notifier usage is consistent with the GHES code for SCI errors which 
are also only used a single
time in the code. If you think making the call directly is a better 
option I will remove the notifiers.
>>   #endif	/* __ASM_SYSTEM_MISC_H */
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 05d2bd7..81039c7 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -39,6 +39,22 @@
>>   #include <asm/pgtable.h>
>>   #include <asm/tlbflush.h>
>>   
>> +/*
>> + * GHES SEA handler code may register a notifier call here to
>> + * handle HW error record passed from platform.
>> + */
>> +static ATOMIC_NOTIFIER_HEAD(sea_handler_chain);
>> +
>> +int register_sea_notifier(struct notifier_block *nb)
>> +{
>> +	return atomic_notifier_chain_register(&sea_handler_chain, nb);
>> +}
>> +
>> +void unregister_sea_notifier(struct notifier_block *nb)
>> +{
>> +	atomic_notifier_chain_unregister(&sea_handler_chain, nb);
>> +}
>> +
>>   static const char *fault_name(unsigned int esr);
>>   
>>   #ifdef CONFIG_KPROBES
>> @@ -480,6 +496,28 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   	return 1;
>>   }
>>   
>> +/*
>> + * This abort handler deals with Synchronous External Abort.
>> + * It calls notifiers, and then returns "fault".
>> + */
>> +static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>> +{
>> +	struct siginfo info;
>> +
>> +	atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
>> +
>> +	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>> +		 fault_name(esr), esr, addr);
>> +
>> +	info.si_signo = SIGBUS;
>> +	info.si_errno = 0;
>> +	info.si_code  = 0;
>> +	info.si_addr  = (void __user *)addr;
>> +	arm64_notify_die("", regs, &info, esr);
>> +
>> +	return 0;
>> +}
>> +
>>   static const struct fault_info {
>>   	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
>>   	int	sig;
>> @@ -502,22 +540,22 @@ static const struct fault_info {
>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
>> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
>> +	{ do_sea,		SIGBUS,  0,		"synchronous external abort"	},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 0 SEA (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 1 SEA (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 2 SEA (translation table walk)"	},
>> +	{ do_sea,		SIGBUS,  0,		"level 3 SEA (translation table walk)"	},
> Perhaps I wasn't clear enough in my previous review, but please expand the
> acronym for strings and comments.
Sorry, I will expand these.
>> +	{ do_sea,		SIGBUS,  0,		"synchronous parity or ECC err" },
> s/err/error/
>
> Will
Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
