From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V12 10/10] arm/arm64: KVM: add guest SEA support
Date: Tue, 7 Mar 2017 10:58:38 -0700
Message-ID: <783e18ac-9495-aaf6-8fbd-5a48c0b68f5b@codeaurora.org>
References: <1488833103-21082-1-git-send-email-tbaicar@codeaurora.org>
 <1488833103-21082-11-git-send-email-tbaicar@codeaurora.org>
 <58BE9E14.6040208@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <58BE9E14.6040208@arm.com>
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


On 3/7/2017 4:48 AM, James Morse wrote:
> On 06/03/17 20:45, Tyler Baicar wrote:
>> Currently external aborts are unsupported by the guest abort
>> handling. Add handling for SEAs so that the host kernel reports
>> SEAs which occur in the guest kernel.
>> diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
>> index e22089f..a1a3dff 100644
>> --- a/arch/arm/include/asm/kvm_arm.h
>> +++ b/arch/arm/include/asm/kvm_arm.h
>> @@ -187,6 +187,16 @@
>>   #define FSC_FAULT	(0x04)
>>   #define FSC_ACCESS	(0x08)
>>   #define FSC_PERM	(0x0c)
>> +#define FSC_SEA		(0x10)
>> +#define FSC_SEA_TTW0	(0x14)
>> +#define FSC_SEA_TTW1	(0x15)
>> +#define FSC_SEA_TTW2	(0x16)
>> +#define FSC_SEA_TTW3	(0x17)
>> +#define FSC_SECC	(0x18)
>> +#define FSC_SECC_TTW0	(0x1c)
> aarch32 doesn't have either of these 'TW0' values, it's an unused encoding.
> (However ...)
>
>> +#define FSC_SECC_TTW1	(0x1d)
>> +#define FSC_SECC_TTW2	(0x1e)
>> +#define FSC_SECC_TTW3	(0x1f)
>>   
>>   /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>>   #define HPFAR_MASK	(~0xf)
>>   #endif /* __ASM_ARM_SYSTEM_MISC_H */
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index a5265ed..f3608c9 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -1444,8 +1463,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   
>>   	/* Check the stage-2 fault is trans. fault or write fault */
>>   	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>> -	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>> -	    fault_status != FSC_ACCESS) {
>> +
>> +	/* The host kernel will handle the synchronous external abort. There
>> +	 * is no need to pass the error into the guest.
>> +	 */
>> +	if (is_abort_synchronous(fault_status)) {
>> +		if(handle_guest_sea((unsigned long)fault_ipa,
>> +				    kvm_vcpu_get_hsr(vcpu))) {
>
> ... Looking further up in this function:
>> 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>> 	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
>> 		kvm_inject_vabt(vcpu);
>> 		return 1;
>> 	}
> ... so external data aborts will have already been 'claimed' by kvm and dealt
> with, and we already have a helper for spotting external aborts. (sorry I didn't
> spot it earlier).
>
> We need to do the handle_guest_sea() before this code.
>
> kvm_inject_vabt() makes an SError interrupt pending for the guest. This makes a
> synchronous error asynchronous as the guest may have SError interrupts masked.
>
> I guess this was the best that could be done at the time of (4055710baca8
> "arm/arm64: KVM: Inject virtual abort when guest exits on external abort"), but
> in the light of this firmware-first handling, I'm not sure its the right thing
> to do.
>
> Is it possible for handle_guest_sea() to return whether it actually found any
> work to do? If there was none I think we should keep this kvm_inject_vabt() as
> it is the existing behaviour.
Yes, I'll move the handle_guest_sea() call above this. My testing didn't 
call into that if statement for some reason...it made it to the 
handle_guest_sea() call successfully.

If there is no work for the GHES code to do it will return and could 
still make the kvm_inject_vabt() call. It will also return and do that 
same thing if the error was not fatal in GHES...would that be an issue?
>
>> +			kvm_err("Failed to handle guest SEA, FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>> +				kvm_vcpu_trap_get_class(vcpu),
>> +				(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
>> +				(unsigned long)kvm_vcpu_get_hsr(vcpu));
>> +			return -EFAULT;
>> +		}
>> +	} else if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>> +		   fault_status != FSC_ACCESS) {
>>   		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>>   			kvm_vcpu_trap_get_class(vcpu),
>>   			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
>
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index b2d57fc..31c5171 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -602,6 +602,24 @@ static const char *fault_name(unsigned int esr)
>>   }
>>   
>>   /*
>> + * Handle Synchronous External Aborts that occur in a guest kernel.
>> + */
>> +int handle_guest_sea(unsigned long addr, unsigned int esr)
>> +{
>> +	/*
>> +	 * synchronize_rcu() will wait for nmi_exit(), so no need to
>> +	 * rcu_read_lock().
>> +	 */
> This comment has a life of its own! Given we don't always call ghes_notify_sea()
> when we interrupted un-interruptable code its not always true. I think the
> rcu_read_{,un}lock() should go against the list walk (so it looks like the
> examples), and ditch the comment!
:) Okay I will move the rcu calls into ghes_notify_sea() and remove the 
comments.

Thanks,
Tyler
>
>> +	if(IS_ENABLED(ACPI_APEI_SEA)) {
>> +		rcu_read_lock();
>> +		ghes_notify_sea();
>> +		rcu_read_unlock();
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>>    * Dispatch a data abort to the relevant handler.
>>    */
>>   asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
>>

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
