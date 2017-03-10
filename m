From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V12 10/10] arm/arm64: KVM: add guest SEA support
Date: Fri, 10 Mar 2017 11:15:29 -0700
Message-ID: <9e2dee3d-afb3-72f6-a8f2-4fa090e87ee8@codeaurora.org>
References: <1488833103-21082-1-git-send-email-tbaicar@codeaurora.org>
 <1488833103-21082-11-git-send-email-tbaicar@codeaurora.org>
 <58BE9E14.6040208@arm.com>
 <783e18ac-9495-aaf6-8fbd-5a48c0b68f5b@codeaurora.org>
 <58C02CA2.4030601@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <58C02CA2.4030601@arm.com>
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
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hello James,


On 3/8/2017 9:09 AM, James Morse wrote:
> On 07/03/17 17:58, Baicar, Tyler wrote:
>> On 3/7/2017 4:48 AM, James Morse wrote:
>>> On 06/03/17 20:45, Tyler Baicar wrote:
>>>> Currently external aborts are unsupported by the guest abort
>>>> handling. Add handling for SEAs so that the host kernel reports
>>>> SEAs which occur in the guest kernel.
>>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>>>> index a5265ed..f3608c9 100644
>>>> --- a/arch/arm/kvm/mmu.c
>>>> +++ b/arch/arm/kvm/mmu.c
>>>> @@ -1444,8 +1463,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu,
>>>> struct kvm_run *run)
>>>>          /* Check the stage-2 fault is trans. fault or write fault */
>>>>        fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>>>> -    if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>>>> -        fault_status != FSC_ACCESS) {
>>>> +
>>>> +    /* The host kernel will handle the synchronous external abort. There
>>>> +     * is no need to pass the error into the guest.
>>>> +     */
>>>> +    if (is_abort_synchronous(fault_status)) {
>>>> +        if(handle_guest_sea((unsigned long)fault_ipa,
>>>> +                    kvm_vcpu_get_hsr(vcpu))) {
>>> ... Looking further up in this function:
>>>>      is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>>>>      if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
>>>>          kvm_inject_vabt(vcpu);
>>>>          return 1;
>>>>      }
>>> ... so external data aborts will have already been 'claimed' by kvm and dealt
>>> with, and we already have a helper for spotting external aborts. (sorry I didn't
>>> spot it earlier).
>>>
>>> We need to do the handle_guest_sea() before this code.
>>>
>>> kvm_inject_vabt() makes an SError interrupt pending for the guest. This makes a
>>> synchronous error asynchronous as the guest may have SError interrupts masked.
>>>
>>> I guess this was the best that could be done at the time of (4055710baca8
>>> "arm/arm64: KVM: Inject virtual abort when guest exits on external abort"), but
>>> in the light of this firmware-first handling, I'm not sure its the right thing
>>> to do.
>>>
>>> Is it possible for handle_guest_sea() to return whether it actually found any
>>> work to do? If there was none I think we should keep this kvm_inject_vabt() as
>>> it is the existing behaviour.
>> Yes, I'll move the handle_guest_sea() call above this. My testing didn't call
>> into that if statement for some reason...it made it to the handle_guest_sea()
>> call successfully.
> I guess you're not using data aborts for testing then.
>
>
>> If there is no work for the GHES code to do it will return and could still make
>> the kvm_inject_vabt() call. It will also return and do that same thing if the
>> error was not fatal in GHES...would that be an issue?
> We might inject a superfluous SError Interrupt in that case.
>
> For memory errors we may do the whole unmapping and signalling thing to handle
> the fault. For recoverable faults, QEMU can generate its own CPER records for
> the guest and do the work to notify the guest. Everything looks fine until the
> guest gets the extra SError interrupt.
>
> If there is firmware-first RAS data, we should skip the injected SError
> Interrupt as the host's RAS code should choose what to do. If this Synchronous
> External Abort was nothing to do with RAS, we should inject the SError interrupt
> as it's the existing behaviour, and not all platforms will have this Synchronous
> External Abort mechanism.
>
> x86's APEI NMI needs to know if the NMI was due to RAS, so we can probably
> borrow the same trick. ghes_notify_nmi() calls ghes_read_estatus() for each
> struct ghes. If they all return an error, there was no work to do.
>
>
> (I assume firmware will only generate one of these at a time, so there is no
> risk of one list-walker processing two entries, then the second finding nothing
> to do?)
>
Okay, I will add in this functionality to avoid injecting an SEI if 
there is actually a GHES error populated.

Firmware that supports the new specs should only generate one of these 
at a time, it will wait for the ack from kernel before sending a second 
error (patch 1 of this series).

Thanks,
Tyler
>
>
>>>> +            kvm_err("Failed to handle guest SEA, FSC: EC=%#x xFSC=%#lx
>>>> ESR_EL2=%#lx\n",
>>>> +                kvm_vcpu_trap_get_class(vcpu),
>>>> +                (unsigned long)kvm_vcpu_trap_get_fault(vcpu),
>>>> +                (unsigned long)kvm_vcpu_get_hsr(vcpu));
>>>> +            return -EFAULT;
>>>> +        }
>>>> +    } else if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>>>> +           fault_status != FSC_ACCESS) {
>>>>            kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>>>>                kvm_vcpu_trap_get_class(vcpu),
>>>>                (unsigned long)kvm_vcpu_trap_get_fault(vcpu),

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
