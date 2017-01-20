From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V7 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Fri, 20 Jan 2017 13:35:11 -0700
Message-ID: <a2b1bcad-8d07-4d9d-a9ff-8a56814a8285@codeaurora.org>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-5-git-send-email-tbaicar@codeaurora.org>
 <587DF279.1010402@arm.com>
 <e8c0151e-2087-d49c-42fc-906755aca052@codeaurora.org>
 <5880FD8A.2000405@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <5880FD8A.2000405@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

On 1/19/2017 10:55 AM, James Morse wrote:
> Hi Tyler,
>
> On 18/01/17 23:26, Baicar, Tyler wrote:
>> On 1/17/2017 3:31 AM, James Morse wrote:
>>> On 12/01/17 18:15, Tyler Baicar wrote:
>>>> SEA exceptions are often caused by an uncorrected hardware
>>>> error, and are handled when data abort and instruction abort
>>>> exception classes have specific values for their Fault Status
>>>> Code.
>>>> When SEA occurs, before killing the process, go through
>>>> the handlers registered in the notification list.
>>>> Update fault_info[] with specific SEA faults so that the
>>>> new SEA handler is used.
>>>> @@ -480,6 +496,28 @@ static int do_bad(unsigned long addr, unsigned int esr,
>>>> struct pt_regs *regs)
>>>>        return 1;
>>>>    }
>>>>    +/*
>>>> + * This abort handler deals with Synchronous External Abort.
>>>> + * It calls notifiers, and then returns "fault".
>>>> + */
>>>> +static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>>> +{
>>>> +    struct siginfo info;
>>>> +
>>>> +    atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
>>>> +
>>>> +    pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>>>> +         fault_name(esr), esr, addr);
>>>> +
>>>> +    info.si_signo = SIGBUS;
>>>> +    info.si_errno = 0;
>>>> +    info.si_code  = 0;
>>> Half of the other do_*() functions in this file read the signo and code from the
>>> fault_info table.
>>>
>>>
>>>> +    info.si_addr  = (void __user *)addr;
>>> addr here was read from FAR_EL1, but for some of the classes of exception you
>>> have listed below this register isn't updated with the faulting address.
>>>
>>> The ARM-ARM version 'k' in D1.10.5 "Summary of registers on faults taken to an
>>> Exception level that is using Aarch64" has:
>>>> The architecture permits that the FAR_ELx is UNKNOWN for Synchronous External
>>>> Aborts other than Synchronous External Aborts on Translation Table Walks. In
>>>> this case, the ISS.FnV bit returned in ESR_ELx  indicates whether FAR_ELx is
>>>> valid.
>>> This is a problem if we get 'synchronous external abort' or 'synchronous parity
>>> error' while a user space process was running.
>> It looks like this would just cause an incorrect address to be printed in the
>> above pr_err.
>> Unless I'm missing something, I don't see arm64_notify_die or anything that gets
>> called from
>> there using the info.si_addr variable.
> I may be misreading something here...
>
> This patch has:
>> 	info.si_addr  = (void __user *)addr;
>> 	arm64_notify_die("", regs, &info, esr);
>  From arch/arm64/kernel/traps.c:arm64_notify_die():
>> 	if (user_mode(regs)) {
>> 		current->thread.fault_address = 0;
>> 		current->thread.fault_code = err;
>> 		force_sig_info(info->si_signo, info, current);
>> 	}
> So if the SEA interrupted userspace, we put maybe-unknown addr into
> force_sig_info() to deliver a signal to user space. User-space then gets a copy
> of the info struct containing the maybe-unknown addr.
>
> I think this is an existing bug, but if we are separating the synchronous
> external aborts from the generic do_bad handler, we should probably check the
> FnV bit. (I think we should still print it out)
>
>
>> What do you suggest I do here? The firmware should be reporting the physical and
>> virtual
>> address information if it is available in the HEST entry that the kernel will
>> parse.
> Its not just firmware that may trigger this, other SoCs may use it for parity or
> ECC errors, and they may not always have a valid address in FAR_EL1.
>
> I think we should check the FnV bit in the esr variable and set info.si_addr to
> 0 if the addr we have isn't valid:
> 'For some implementations, the value of si_addr may be inaccurate.' [0]
>
>
> Thanks,
>
> James
>
>
> [0] http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/signal.h.html
Hello James,

Okay, that makes sense, we don't want userspace to be notified with an 
incorrect address.
I will add the check to verify it's valid. Which bit in the ESR is the 
FnV bit? I'm not finding
the bit breakdown of the ISS that shows it.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
