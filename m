From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V7 04/10] arm64: exception: handle Synchronous External
 Abort
Date: Tue, 24 Jan 2017 11:41:38 -0700
Message-ID: <4ee2633d-e4a9-6237-4298-4454e7d268ad@codeaurora.org>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-5-git-send-email-tbaicar@codeaurora.org>
 <587DF279.1010402@arm.com>
 <e8c0151e-2087-d49c-42fc-906755aca052@codeaurora.org>
 <5880FD8A.2000405@arm.com>
 <a2b1bcad-8d07-4d9d-a9ff-8a56814a8285@codeaurora.org>
 <5885D46A.7000304@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <5885D46A.7000304@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Po
List-Id: linux-efi@vger.kernel.org

On 1/23/2017 3:01 AM, James Morse wrote:
> Hi Tyler,
>
> On 20/01/17 20:35, Baicar, Tyler wrote:
>> On 1/19/2017 10:55 AM, James Morse wrote:
>>> On 18/01/17 23:26, Baicar, Tyler wrote:
>>>> On 1/17/2017 3:31 AM, James Morse wrote:
>>>>> On 12/01/17 18:15, Tyler Baicar wrote:
>>>>>> +    info.si_addr  = (void __user *)addr;
>>>>> addr here was read from FAR_EL1, but for some of the classes of exception you
>>>>> have listed below this register isn't updated with the faulting address.
>>>>>
>>>>> The ARM-ARM version 'k' in D1.10.5 "Summary of registers on faults taken to an
>>>>> Exception level that is using Aarch64" has:
>>>>>> The architecture permits that the FAR_ELx is UNKNOWN for Synchronous External
>>>>>> Aborts other than Synchronous External Aborts on Translation Table Walks. In
>>>>>> this case, the ISS.FnV bit returned in ESR_ELx  indicates whether FAR_ELx is
>>>>>> valid.
>>>>> This is a problem if we get 'synchronous external abort' or 'synchronous parity
>>>>> error' while a user space process was running.
>>>> It looks like this would just cause an incorrect address to be printed in the
>>>> above pr_err.
>>>> Unless I'm missing something, I don't see arm64_notify_die or anything that gets
>>>> called from
>>>> there using the info.si_addr variable.
>>> I may be misreading something here...
>>>
>>> This patch has:
>>>>      info.si_addr  = (void __user *)addr;
>>>>      arm64_notify_die("", regs, &info, esr);
>>>   From arch/arm64/kernel/traps.c:arm64_notify_die():
>>>>      if (user_mode(regs)) {
>>>>          current->thread.fault_address = 0;
>>>>          current->thread.fault_code = err;
>>>>          force_sig_info(info->si_signo, info, current);
>>>>      }
>>> So if the SEA interrupted userspace, we put maybe-unknown addr into
>>> force_sig_info() to deliver a signal to user space. User-space then gets a copy
>>> of the info struct containing the maybe-unknown addr.
>>>
>>> I think this is an existing bug, but if we are separating the synchronous
>>> external aborts from the generic do_bad handler, we should probably check the
>>> FnV bit. (I think we should still print it out)
>>>
>>>
>>>> What do you suggest I do here? The firmware should be reporting the physical and
>>>> virtual
>>>> address information if it is available in the HEST entry that the kernel will
>>>> parse.
>>> Its not just firmware that may trigger this, other SoCs may use it for parity or
>>> ECC errors, and they may not always have a valid address in FAR_EL1.
>>>
>>> I think we should check the FnV bit in the esr variable and set info.si_addr to
>>> 0 if the addr we have isn't valid:
>>> 'For some implementations, the value of si_addr may be inaccurate.' [0]
>> Okay, that makes sense, we don't want userspace to be notified with an incorrect
>> address.
>> I will add the check to verify it's valid. Which bit in the ESR is the FnV bit?
>> I'm not finding
>> the bit breakdown of the ISS that shows it.
> The bits in ISS vary depending on the EC, so a little digging is required.
> "D7.2.27 ESR_ELx, Exception Syndrome Register (ELx)" lists the EC values, from
> there 'Instruction Abort' and 'Data Abort' both list FnV as bit 10. Version 'k'
> of the ARM-ARM has this on pages D7-1953 to D7-1956.
Got it! I'll add the check for this in my next patchset.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

