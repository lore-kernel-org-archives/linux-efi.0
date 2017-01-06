From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V6 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Fri, 6 Jan 2017 09:58:54 -0700
Message-ID: <05841914-183d-f2b6-37d8-4c34ea42b135@codeaurora.org>
References: <1481147303-7979-1-git-send-email-tbaicar@codeaurora.org>
 <1481147303-7979-5-git-send-email-tbaicar@codeaurora.org>
 <20170104135413.GE18193@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20170104135413.GE18193@arm.com>
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

Hi Will,

On 1/4/2017 6:54 AM, Will Deacon wrote:
> On Wed, Dec 07, 2016 at 02:48:17PM -0700, Tyler Baicar wrote:
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
>> index 57f110b..9040e1d 100644
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
>> +int register_synchronous_ext_abort_notifier(struct notifier_block *nb);
>> +void unregister_synchronous_ext_abort_notifier(struct notifier_block *nb);
> I think that we may as well use the "SEA" acronym consistently in code,
> expanding it only for strings and comments, so these can be renamed to
> {register,unregister}_sea_notifier. That said, what is the use of having a
> notifier chain here as well as in the ghes code? If the ghes code is the
> only place to register a notifier, we may as well start simple and call that
> code directly, like we call handle_mm_fault directly for data aborts.
I originally used the acronym and got feedback to expand it, but I'll 
revert back to just using the acronym.
Using a notifier here is consistent with the SCI error type in the GHES 
code which is also only registered in
the GHES code. I can remove the notifier for SEA if you think making the 
call directly is better here.
>>   static const struct fault_info {
>>   	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
>>   	int	sig;
>> @@ -502,22 +540,22 @@ static const struct fault_info {
>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
>> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"synchronous external abort"	},
> Again, just stick with do_sea for the function name...
>
>>   	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"level 0 SEA (trans tbl walk)"	},
> ... but there's no need to abbreviate "translation table walk" here. Long
> strings that run over 80 chars are fine. Similarly for "SEA".
I will expand this in the next patchset.
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"level 1 SEA (trans tbl walk)"	},
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"level 2 SEA (trans tbl walk)"	},
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"level 3 SEA (trans tbl walk)"	},
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"synchronous parity or ECC err" },
>>   	{ do_bad,		SIGBUS,  0,		"unknown 25"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 26"			},
>>   	{ do_bad,		SIGBUS,  0,		"unknown 27"			},
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error (translation table walk)" },
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"level 0 synch parity error"	},
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"level 1 synch parity error"	},
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"level 2 synch parity error"	},
>> +	{ do_synch_ext_abort,	SIGBUS,  0,		"level 3 synch parity error"	},
> Please keep mention of "translation table walk", since we have exception
> levels too and it's confusing just saying "level n".
I will add them back in the next patchset.

Thanks,
Tyler
> Will

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
