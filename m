From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V3 10/10] arm64: KVM: add guest SEA support
Date: Fri, 14 Oct 2016 14:58:18 -0700
Message-ID: <4f99e989-cb7b-2bf3-a947-6f6713e55b6f@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-11-git-send-email-tbaicar@codeaurora.org>
 <87h98gs853.fsf@e105922-lin.cambridge.arm.com>
 <afa9a3c6-7516-cf5c-2366-f826f914d582@codeaurora.org>
 <878ttrs22f.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <878ttrs22f.fsf@e105922-lin.cambridge.arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, shijie.huang@arm.com, lenb@kernel.org, marc.zyngier@arm.com, tomasz.nowicki@linaro.org, rostedt@goodmis.org, sandeepa.s.prabhu@gmail.com, Dkvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

On 10/14/2016 2:38 AM, Punit Agrawal wrote:
> "Baicar, Tyler" <tbaicar@codeaurora.org> writes:
>
>> Hello Punit,
>>
>> On 10/13/2016 7:14 AM, Punit Agrawal wrote:
>>> Hi Tyler,
>>>
>>> I know I've had my last comment already ;), but I thought I'd rather
>>> raise the question than stay confused...
>>>
>>> Tyler Baicar <tbaicar@codeaurora.org> writes:
>>>
>>>> Currently external aborts are unsupported by the guest abort
>>>> handling. Add handling for SEAs so that the host kernel reports
>>>> SEAs which occur in the guest kernel.
>>>>
>>>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>>>> ---
>>>>    arch/arm/include/asm/kvm_arm.h       |  1 +
>>>>    arch/arm/include/asm/system_misc.h   |  5 +++++
>>>>    arch/arm/kvm/mmu.c                   | 15 +++++++++++++--
>>>>    arch/arm64/include/asm/kvm_arm.h     |  1 +
>>>>    arch/arm64/include/asm/system_misc.h |  2 ++
>>>>    arch/arm64/mm/fault.c                | 13 +++++++++++++
>>>>    6 files changed, 35 insertions(+), 2 deletions(-)
[...]
>>>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>>>> index 81cb7ad..d714432 100644
>>>> --- a/arch/arm64/mm/fault.c
>>>> +++ b/arch/arm64/mm/fault.c
>>>> @@ -597,6 +597,19 @@ static const char *fault_name(unsigned int esr)
>>>>    }
>>>>      /*
>>>> + * Handle Synchronous External Aborts that occur in a guest kernel.
>>>> + */
>>>> +int handle_guest_sea(unsigned long addr, unsigned int esr)
>>>> +{
>>>> +	atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
>>>> +
>>>> +	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>>>> +		fault_name(esr), esr, addr);
>>>> +
>>>> +	return 0;
>>>> +}
>>> Don't we need to pass the abort to the guest?
>> This requires some infrastructure to implement virtual "ACPI platform
>> error interface" to expose the details of the abort to the guest. This
>> patchset does not cover that and focuses on feature parity with other
>> architectures that support APEI. There are discussions among Linaro
>> partners about how this can be achieved in the long term, but that
>> work is outside the scope of this patchset. This patch will ensure
>> that if a guest encounters one of these errors then it will be
>> reported before getting killed. Before this patch we would just get an
>> unsupported FSC print out and then the guest would be killed.
> OK.
>
> I think we might be talking about different things though.
>
> I am referring to the injection of the synchronous external abort into
> the guest - similar to what's been done for prefetch abort in the
> kvm_guest_handle_abort.
>
> Maybe there is no benefit in passing the abort to the guest. In that
> case, can you please add a comment where you handle external abort
> (FSC_EXTABT) in kvm_guest_handle_abort.
Yes, I will add a comment there in the next version.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

