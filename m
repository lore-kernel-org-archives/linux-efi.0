From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V13 10/10] arm/arm64: KVM: add guest SEA support
Date: Tue, 28 Mar 2017 10:35:22 -0600
Message-ID: <ba39628f-f389-afe2-ea45-4b1e2de5c2e9@codeaurora.org>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-11-git-send-email-tbaicar@codeaurora.org>
 <bb4b4608-85ba-fd20-53b1-c19d99019de1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <bb4b4608-85ba-fd20-53b1-c19d99019de1@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, christoffer.dall@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Poulose@arm.com, punit.agrawal@arm.com, astone@redhat.com
List-Id: linux-efi@vger.kernel.org

Hello Marc,


On 3/24/2017 8:03 AM, Marc Zyngier wrote:
> On 21/03/17 22:47, Tyler Baicar wrote:
>> Currently external aborts are unsupported by the guest abort
>> handling. Add handling for SEAs so that the host kernel reports
>> SEAs which occur in the guest kernel.
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> ---
>>   arch/arm/include/asm/kvm_arm.h       | 10 +++++++++
>>   arch/arm/include/asm/system_misc.h   |  5 +++++
>>   arch/arm/kvm/mmu.c                   | 41 ++++++++++++++++++++++++++++++------
>>   arch/arm64/include/asm/kvm_arm.h     | 10 +++++++++
>>   arch/arm64/include/asm/system_misc.h |  2 ++
>>   arch/arm64/mm/fault.c                | 19 +++++++++++++++--
>>   drivers/acpi/apei/ghes.c             | 13 ++++++------
>>   include/acpi/ghes.h                  |  2 +-
>>   8 files changed, 86 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
>> index a3f0b3d..ebf020b 100644
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
>> +#define FSC_SECC_TTW1	(0x1d)
>> +#define FSC_SECC_TTW2	(0x1e)
>> +#define FSC_SECC_TTW3	(0x1f)
>>   
>>   /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>>   #define HPFAR_MASK	(~0xf)
>> diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
>> index a3d61ad..ea45d94 100644
>> --- a/arch/arm/include/asm/system_misc.h
>> +++ b/arch/arm/include/asm/system_misc.h
>> @@ -24,4 +24,9 @@
>>   
>>   #endif /* !__ASSEMBLY__ */
>>   
>> +static inline int handle_guest_sea(unsigned long addr, unsigned int esr)
>> +{
>> +	return -1;
>> +}
>> +
> Shouldn't this be in the #ifndef __ASSEMBLY__ block? The assembler is
> definitely going to barf on that...
I will move this in the next patch set.
>>   #endif /* __ASM_ARM_SYSTEM_MISC_H */
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 962616f..105b6ab 100644
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
>> @@ -1406,6 +1407,24 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>>   		kvm_set_pfn_accessed(pfn);
>>   }
>>   
>> +static bool is_abort_synchronous(unsigned long fault_status) {
>> +	switch (fault_status) {
>> +	case FSC_SEA:
>> +	case FSC_SEA_TTW0:
>> +	case FSC_SEA_TTW1:
>> +	case FSC_SEA_TTW2:
>> +	case FSC_SEA_TTW3:
>> +	case FSC_SECC:
>> +	case FSC_SECC_TTW0:
>> +	case FSC_SECC_TTW1:
>> +	case FSC_SECC_TTW2:
>> +	case FSC_SECC_TTW3:
>> +		return true;
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>>   /**
>>    * kvm_handle_guest_abort - handles all 2nd stage aborts
>>    * @vcpu:	the VCPU pointer
>> @@ -1426,23 +1445,31 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>   	unsigned long hva;
>>   	bool is_iabt, write_fault, writable;
>>   	gfn_t gfn;
>> -	int ret, idx;
>> +	int ret, idx, sea_status = 1;
>> +
>> +	/* Check the stage-2 fault is trans. fault or write fault */
>> +	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>> +
>> +	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>> +
>> +	/* The host kernel will handle the synchronous external abort. There
>> +	 * is no need to pass the error into the guest.
>> +	 */
>> +	if (is_abort_synchronous(fault_status))
>> +		sea_status = handle_guest_sea((unsigned long)fault_ipa,
>> +				    kvm_vcpu_get_hsr(vcpu));
>>   
>>   	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
>> -	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
>> +	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu)) && sea_status) {
>>   		kvm_inject_vabt(vcpu);
>>   		return 1;
>>   	}
>>   
>> -	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
>> -
>>   	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
>>   			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
>>   
>> -	/* Check the stage-2 fault is trans. fault or write fault */
>> -	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>>   	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
>> -	    fault_status != FSC_ACCESS) {
>> +	    fault_status != FSC_ACCESS && sea_status) {
>>   		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>>   			kvm_vcpu_trap_get_class(vcpu),
>>   			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index 6e99978..61d694c 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -204,6 +204,16 @@
>>   #define FSC_FAULT	ESR_ELx_FSC_FAULT
>>   #define FSC_ACCESS	ESR_ELx_FSC_ACCESS
>>   #define FSC_PERM	ESR_ELx_FSC_PERM
>> +#define FSC_SEA		ESR_ELx_FSC_EXTABT
>> +#define FSC_SEA_TTW0	(0x14)
>> +#define FSC_SEA_TTW1	(0x15)
>> +#define FSC_SEA_TTW2	(0x16)
>> +#define FSC_SEA_TTW3	(0x17)
>> +#define FSC_SECC	(0x18)
>> +#define FSC_SECC_TTW0	(0x1c)
>> +#define FSC_SECC_TTW1	(0x1d)
>> +#define FSC_SECC_TTW2	(0x1e)
>> +#define FSC_SECC_TTW3	(0x1f)
>>   
>>   /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>>   #define HPFAR_MASK	(~UL(0xf))
>> diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
>> index bc81243..5b2cecd 100644
>> --- a/arch/arm64/include/asm/system_misc.h
>> +++ b/arch/arm64/include/asm/system_misc.h
>> @@ -58,4 +58,6 @@ void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
>>   
>>   #endif	/* __ASSEMBLY__ */
>>   
>> +int handle_guest_sea(unsigned long addr, unsigned int esr);
> Same remark here.
Same here.
>
>> +
>>   #endif	/* __ASM_SYSTEM_MISC_H */
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index f7372ce..ee96307 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -497,6 +497,7 @@ static int do_bad(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   {
>>   	struct siginfo info;
>> +	int ret = 0;
>>   
>>   	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>>   		 fault_name(esr), esr, addr);
>> @@ -508,7 +509,7 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   	 */
>>   	if (IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
>>   		nmi_enter();
>> -		ghes_notify_sea();
>> +		ret = ghes_notify_sea();
>>   		nmi_exit();
>>   	}
>>   
>> @@ -521,7 +522,7 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   		info.si_addr  = (void __user *)addr;
>>   	arm64_notify_die("", regs, &info, esr);
>>   
>> -	return 0;
>> +	return ret;
>>   }
>>   
>>   static const struct fault_info {
>> @@ -603,6 +604,20 @@ static const char *fault_name(unsigned int esr)
>>   }
>>   
>>   /*
>> + * Handle Synchronous External Aborts that occur in a guest kernel.
>> + */
>> +int handle_guest_sea(unsigned long addr, unsigned int esr)
>> +{
>> +	int ret = -ENOENT;
>> +
>> +	if(IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
>> +		ret = ghes_notify_sea();
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/*
>>    * Dispatch a data abort to the relevant handler.
>>    */
>>   asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 230b095..81eabc6 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -810,17 +810,18 @@ static int ghes_notify_sci(struct notifier_block *this,
>>   #ifdef CONFIG_ACPI_APEI_SEA
>>   static LIST_HEAD(ghes_sea);
>>   
>> -void ghes_notify_sea(void)
>> +int ghes_notify_sea(void)
>>   {
>>   	struct ghes *ghes;
>> +	int ret = -ENOENT;
>>   
>> -	/*
>> -	 * synchronize_rcu() will wait for nmi_exit(), so no need to
>> -	 * rcu_read_lock().
>> -	 */
>> +	rcu_read_lock();
>>   	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
>> -		ghes_proc(ghes);
>> +		if(!ghes_proc(ghes))
>> +			ret = 0;
>>   	}
>> +	rcu_read_unlock();
>> +	return ret;
>>   }
>>   
>>   static void ghes_sea_add(struct ghes *ghes)
>> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
>> index 18bc935..2a727dc 100644
>> --- a/include/acpi/ghes.h
>> +++ b/include/acpi/ghes.h
>> @@ -99,6 +99,6 @@ static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data
>>   		gdata + 1;
>>   }
>>   
>> -void ghes_notify_sea(void);
>> +int ghes_notify_sea(void);
>>   
>>   #endif /* GHES_H */
>>
> Otherwise, the KVM changes look good to me. Assuming you fix the two
> nits above:
>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Thanks!
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
