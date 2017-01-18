From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V7 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Wed, 18 Jan 2017 15:52:03 -0700
Message-ID: <9185f5f2-7bc4-5727-af3a-920dd22578dc@codeaurora.org>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-5-git-send-email-tbaicar@codeaurora.org>
 <20170116115309.GE1510@arm.com> <587DF0B6.4060000@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <587DF0B6.4060000@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk, catalin.marinas@arm.com, Will Deacon <will.deacon@arm.com>, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, tn@semihalf.com, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, Suzuki.Poulose@arm.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.orgb
List-Id: linux-efi@vger.kernel.org

On 1/17/2017 3:23 AM, James Morse wrote:
> Hi Tyler,
>
> On 16/01/17 11:53, Will Deacon wrote:
>> On Thu, Jan 12, 2017 at 11:15:18AM -0700, Tyler Baicar wrote:
>>> SEA exceptions are often caused by an uncorrected hardware
>>> error, and are handled when data abort and instruction abort
>>> exception classes have specific values for their Fault Status
>>> Code.
>>> When SEA occurs, before killing the process, go through
>>> the handlers registered in the notification list.
>>> Update fault_info[] with specific SEA faults so that the
>>> new SEA handler is used.
>>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>>> index 05d2bd7..81039c7 100644
>>> --- a/arch/arm64/mm/fault.c
>>> +++ b/arch/arm64/mm/fault.c
>>> @@ -480,6 +496,28 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>>   	return 1;
>>>   }
>>>   
>>> +/*
>>> + * This abort handler deals with Synchronous External Abort.
>>> + * It calls notifiers, and then returns "fault".
>>> + */
>>> +static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>> +{
>>> +	struct siginfo info;
>>> +
>>> +	atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
>>> +
>>> +	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>>> +		 fault_name(esr), esr, addr);
>>> +
>>> +	info.si_signo = SIGBUS;
>>> +	info.si_errno = 0;
>>> +	info.si_code  = 0;
>>> +	info.si_addr  = (void __user *)addr;
>>> +	arm64_notify_die("", regs, &info, esr);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>   static const struct fault_info {
>>>   	int	(*fn)(unsigned long addr, unsigned int esr, struct pt_regs *regs);
>>>   	int	sig;
>>> @@ -502,22 +540,22 @@ static const struct fault_info {
>>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 1 permission fault"	},
>>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 2 permission fault"	},
>>>   	{ do_page_fault,	SIGSEGV, SEGV_ACCERR,	"level 3 permission fault"	},
>>> -	{ do_bad,		SIGBUS,  0,		"synchronous external abort"	},
>>> +	{ do_sea,		SIGBUS,  0,		"synchronous external abort"	},
>>>   	{ do_bad,		SIGBUS,  0,		"unknown 17"			},
>>>   	{ do_bad,		SIGBUS,  0,		"unknown 18"			},
>>>   	{ do_bad,		SIGBUS,  0,		"unknown 19"			},
>>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>>> -	{ do_bad,		SIGBUS,  0,		"synchronous abort (translation table walk)" },
>>> -	{ do_bad,		SIGBUS,  0,		"synchronous parity error"	},
>>> +	{ do_sea,		SIGBUS,  0,		"level 0 SEA (translation table walk)"	},
>>> +	{ do_sea,		SIGBUS,  0,		"level 1 SEA (translation table walk)"	},
>>> +	{ do_sea,		SIGBUS,  0,		"level 2 SEA (translation table walk)"	},
>>> +	{ do_sea,		SIGBUS,  0,		"level 3 SEA (translation table walk)"	},
>> Perhaps I wasn't clear enough in my previous review, but please expand the
>> acronym for strings and comments.
>
> The 'SEA' in this user-string doesn't add anything. Now that these use do_sea()
> instead of do_bad(), when they are printed won't it be:
>> Synchronous External Abort: level 3 SEA (translation table walk) (...) at ....

Good point, yes they will:

+	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
+		 fault_name(esr), esr, addr);

I can just remove SEA here then.

Thanks,
Tyler


-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
