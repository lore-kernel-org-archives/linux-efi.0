From: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V3 10/10] arm64: KVM: add guest SEA support
Date: Thu, 13 Oct 2016 14:14:27 -0600
Message-ID: <afa9a3c6-7516-cf5c-2366-f826f914d582@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-11-git-send-email-tbaicar@codeaurora.org>
 <87h98gs853.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87h98gs853.fsf-Z9gB6HwUD+TZROr8t4l/smS4ubULX0JqMm0uRHvK7Nw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Punit Agrawal <punit.agrawal-5wv7dgnIgG8@public.gmane.org>
Cc: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tomasz.nowicki-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Dkvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hello Punit,

On 10/13/2016 7:14 AM, Punit Agrawal wrote:
> Hi Tyler,
>
> I know I've had my last comment already ;), but I thought I'd rather
> raise the question than stay confused...
>
> Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> writes:
>
>> Currently external aborts are unsupported by the guest abort
>> handling. Add handling for SEAs so that the host kernel reports
>> SEAs which occur in the guest kernel.
>>
>> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>   arch/arm/include/asm/kvm_arm.h       |  1 +
>>   arch/arm/include/asm/system_misc.h   |  5 +++++
>>   arch/arm/kvm/mmu.c                   | 15 +++++++++++++--
>>   arch/arm64/include/asm/kvm_arm.h     |  1 +
>>   arch/arm64/include/asm/system_misc.h |  2 ++
>>   arch/arm64/mm/fault.c                | 13 +++++++++++++
>>   6 files changed, 35 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
>> index e22089f..33a77509 100644
>> --- a/arch/arm/include/asm/kvm_arm.h
>> +++ b/arch/arm/include/asm/kvm_arm.h
>> @@ -187,6 +187,7 @@
>>   #define FSC_FAULT	(0x04)
>>   #define FSC_ACCESS	(0x08)
>>   #define FSC_PERM	(0x0c)
>> +#define FSC_EXTABT	(0x10)
>>   
>>   /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>>   #define HPFAR_MASK	(~0xf)
>> diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
>> index a3d61ad..86e1faa 100644
>> --- a/arch/arm/include/asm/system_misc.h
>> +++ b/arch/arm/include/asm/system_misc.h
>> @@ -24,4 +24,9 @@ extern unsigned int user_debug;
>>   
>>   #endif /* !__ASSEMBLY__ */
>>   
>> +inline int handle_guest_sea(unsigned long addr, unsigned int esr)
>> +{
>> +	return -1;
>> +}
>> +
>>   #endif /* __ASM_ARM_SYSTEM_MISC_H */
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index e9a5c0e..24cde84 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -29,6 +29,7 @@
>>   #include <asm/kvm_asm.h>
>>   #include <asm/kvm_emulate.h>
>>   #include <asm/virt.h>
>> +#include <asm/system_misc.h>
>>   
>>   #include "trace.h"
>>   
>> @@ -1441,8 +1442,18 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   
>>   	/* Check the stage-2 fault is trans. fault or write fault */
>>   	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>> -	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>> -	    fault_status != FSC_ACCESS) {
>> +
>> +	if (fault_status == FSC_EXTABT) {
>> +		if(handle_guest_sea((unsigned long)fault_ipa,
>> +				    kvm_vcpu_get_hsr(vcpu))) {
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
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 4b5c977..be0efb6 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -201,6 +201,7 @@
>>   #define FSC_FAULT	ESR_ELx_FSC_FAULT
>>   #define FSC_ACCESS	ESR_ELx_FSC_ACCESS
>>   #define FSC_PERM	ESR_ELx_FSC_PERM
>> +#define FSC_EXTABT	ESR_ELx_FSC_EXTABT
>>   
>>   /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>>   #define HPFAR_MASK	(~UL(0xf))
>> diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
>> index 90daf4a..8522fff 100644
>> --- a/arch/arm64/include/asm/system_misc.h
>> +++ b/arch/arm64/include/asm/system_misc.h
>> @@ -77,4 +77,6 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
>>   int sea_register_handler_chain(struct notifier_block *nb);
>>   void sea_unregister_handler_chain(struct notifier_block *nb);
>>   
>> +int handle_guest_sea(unsigned long addr, unsigned int esr);
>> +
>>   #endif	/* __ASM_SYSTEM_MISC_H */
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 81cb7ad..d714432 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -597,6 +597,19 @@ static const char *fault_name(unsigned int esr)
>>   }
>>   
>>   /*
>> + * Handle Synchronous External Aborts that occur in a guest kernel.
>> + */
>> +int handle_guest_sea(unsigned long addr, unsigned int esr)
>> +{
>> +	atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
>> +
>> +	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>> +		fault_name(esr), esr, addr);
>> +
>> +	return 0;
>> +}
> Don't we need to pass the abort to the guest?
This requires some infrastructure to implement virtual "ACPI platform 
error interface" to expose the details of the abort to the guest. This 
patchset does not cover that and focuses on feature parity with other 
architectures that support APEI. There are discussions among Linaro 
partners about how this can be achieved in the long term, but that work 
is outside the scope of this patchset. This patch will ensure that if a 
guest encounters one of these errors then it will be reported before 
getting killed. Before this patch we would just get an unsupported FSC 
print out and then the guest would be killed.

Thanks,
Tyler
>
> Thanks,
> Punit
>
>> +
>> +/*
>>    * Dispatch a data abort to the relevant handler.
>>    */
>>   asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
