From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v3 3/3] arm/arm64: signal SIBGUS and inject SEA Error
Date: Wed, 10 May 2017 16:44:53 +0800
Message-ID: <75907fb5-440f-2cbe-762a-d139c4bfdd2d@huawei.com>
References: <CAMj-D2BGTDKpOcMu2ip41_MTTj8VDwvs59Ds7yvLHcD8PeQzhg@mail.gmail.com>
 <5910AAA2.4030304@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5910AAA2.4030304@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>, gengdongjiu <gengdj.1984@gmail.com>
Cc: Tyler Baicar <tbaicar@codeaurora.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, Len Brown <lenb@kernel.org>, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, Sandeepa Prabhu <sandeepa.s.prabhu@gmail.com>, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, Fu Wei <fu.wei@linaro.org>, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infra
List-Id: linux-efi@vger.kernel.org

Hi James,
  thanks a lot for your answer.

On 2017/5/9 1:28, James Morse wrote:
> Hi gengdongjiu,
> 
> On 04/05/17 17:52, gengdongjiu wrote:
>> 2017-05-04 23:42 GMT+08:00 gengdongjiu <gengdj.1984@gmail.com>:
>>> On 30/04/17 06:37, Dongjiu Geng wrote:
>>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>>>> index 105b6ab..a96594f 100644
>>>> --- a/arch/arm/kvm/mmu.c
>>>> +++ b/arch/arm/kvm/mmu.c
>>>> +static void kvm_handle_bad_page(unsigned long address,
>>>> + bool hugetlb, bool hwpoison)
>>>> +{
>>>> + /* handle both hwpoison and other synchronous external Abort */
>>>> + if (hwpoison)
>>>> + kvm_send_signal(address, hugetlb, true);
>>>> + else
>>>> + kvm_send_signal(address, hugetlb, false);
>>>> +}
>>>
>>> Why the extra level of indirection? We only want to signal userspace like this
>>> from KVM for hwpoison. Signals for RAS related reasons should come from the bits
>>> of the kernel that decoded the error.
>>
>> For the SEA, the are maily two types:
>> 0b010000 Synchronous External Abort on memory access.
>> 0b0101xx Synchronous External Abort on page table walk. DFSC[1:0]
>> encode the level.
> 
> (KVM shouldn't have to make decisions about this)
> 
> 
>> hwpoison should belong to the  "Synchronous External Abort on memory access"
>> if the SEA type is not hwpoison, such as page table walk, do you mean
>> KVM do not deliver the SIGBUS?
> 
> 
> The flow of events should be SEI/SEA from firmware to the hosts's APEI code. KVM
> should only be involved to get us back to the host if we were running a guest.
> The APEI/hwpoison code may cause a set of processes to be sent signals. The code
> in mm/memory-failure.c does this by walking the process rmaps using the physical
> addresses in the CPER records.
> 
> We want user space to be sent signals as this can (and should) work in exactly
> the same way on arm64 as it does on x86 or any other architecture. If a
> web-browser can handle SIGBUS notifications for memory-corruption, it shouldn't
> have to care what architecture it is running on.
 Ok, James, understand.

> 
> So what is that KVM+SIGBUS patch about?...
> 
>>> (hwpoison for KVM is a corner case as Qemu's memory effectively has two users,
>>> Qemu and KVM. This isn't the example of how user-space gets signalled.)
> 
> KVM creates guests as if they were additional users of Qemu's memory. The code
> in mm/memory-failure.c may find that Qemu didn't have the affected page mapped
> to user-space - but it may have been in use by stage2.
> 
> The KVM+SIGBUS patch hides this difference, meaning Qemu gets a signal when the
> guest touches the hwpoison page as if Qemu had touched the page itself.
> 
> Signals from KVM is a corner case, for firmware-first decisions should happen in
> the APEI code based on CPER records.
> 
> 
>> If so, how the KVM handle the SEA type other than hwpoison?
> 
> To deliver to a guest? It shouldn't have to know, user space should use a KVM
> API to drive this.
> 
> When received from hardware? It shouldn't have to care, these things should be
> passed into the APEI code for handling. KVM just needs to put the host registers
> back.
Recently I confirmed with the hardware team. they said almost all the SEA errors have the
Poison flag, so may be there is no need to consider other SEA errors other than  hwPoison.
only consider SEA hwpoison errors can be enough.

> 
> 
>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>> index bb02909..1d2e2e7 100644
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -1306,6 +1306,7 @@ struct kvm_s390_ucas_mapping {
>>>>  #define KVM_S390_GET_IRQ_STATE  _IOW(KVMIO, 0xb6, struct kvm_s390_irq_state)
>>>>  /* Available with KVM_CAP_X86_SMM */
>>>>  #define KVM_SMI                   _IO(KVMIO,   0xb7)
>>>> +#define KVM_ARM_SEA               _IO(KVMIO,   0xb8)
>>>>
>>>>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU (1 << 0)
>>>>  #define KVM_DEV_ASSIGN_PCI_2_3 (1 << 1)
>>>>
>>>
>>> Why do we need a userspace API for SEA? It can also be done by using
>>> KVM_{G,S}ET_ONE_REG to change the vcpu registers. The advantage of doing it this
>>> way is you can choose which ESR value to use.
>>>
>>> Adding a new API call to do something you could do with an old one doesn't look
>>> right.
>>
>> James, I considered your suggestion before that use the
>> KVM_{G,S}ET_ONE_REG to change the vcpu registers. but I found it does
>> not have difference to use the alread existed KVM API. 
> 
> (Only that is an in-kernel helper, not a published API)

yes, the kvm_inject_dabt is an in-kernel API.

> 
> 
>> so may be
>> changing the vcpu registers in qemu will duplicate with the KVM APIs.
> 
> That is true, but the alternative is a new API that doesn't do anything new, its
> just more convenient.
> 
> Marc and Christoffer are the people to convince.
> I argue the existing API is sufficient.
> 
> 
>> injection a SEA is no more than setting some registers: elr_el1, PC,
>> PSTATE, SPSR_el1, far_el1, esr_el1
>> I seen this KVM API do the same thing as Qemu.  do you found call this
>> API will have issue and necessary to choose another ESR value?
> 
> Should we let user-space pick the ESR to deliver to the guest? Yes, letting
> user-space specify the ESR gives the most flexibility to do something clever in
> the future. An obvious choice for SEA is between the external-abort and 'parity
> or ECC error' codes. If we tell user-space which of these happened (I don't
> think Linux does today) then Qemu can relay that information to the guest.

may be the ESR is delivered by the KVM.
(1) guest OS EL0 happen SEA due to hwpoison
(2) CPU traps to EL3 firmware, and update the ESR_EL3
(3) the EL3 firmware copies the ESR_EL3 to ESR_EL2
(4) then jump to EL2 hypervisor, hypervisor uses the ESR_EL2 to inject the SEA.

May be the esr_el2 can provide the accurate error information.
or do you think user-space specify the ESR instead of esr_el2 is better?


> 
> 
> 
> Thanks,
> 
> James
> 
> .
> 
