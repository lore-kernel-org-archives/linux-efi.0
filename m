From: Xiongfeng Wang <wangxiongfeng2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V11 10/10] arm/arm64: KVM: add guest SEA support
Date: Sat, 25 Feb 2017 15:15:47 +0800
Message-ID: <df6ba5dc-d93f-925a-46bf-1e1e209d17f3@huawei.com>
References: <1487712121-16688-1-git-send-email-tbaicar@codeaurora.org>
 <1487712121-16688-11-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487712121-16688-11-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm@vg
List-Id: linux-efi@vger.kernel.org

Hi Tyler,


On 2017/2/22 5:22, Tyler Baicar wrote:
> Currently external aborts are unsupported by the guest abort
> handling. Add handling for SEAs so that the host kernel reports
> SEAs which occur in the guest kernel.
> 
> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  arch/arm/include/asm/kvm_arm.h       |  1 +
>  arch/arm/include/asm/system_misc.h   |  5 +++++
>  arch/arm/kvm/mmu.c                   | 18 ++++++++++++++++--
>  arch/arm64/include/asm/kvm_arm.h     |  1 +
>  arch/arm64/include/asm/system_misc.h |  2 ++
>  arch/arm64/mm/fault.c                | 18 ++++++++++++++++++
>  6 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
> index e22089f..33a77509 100644
> --- a/arch/arm/include/asm/kvm_arm.h
> +++ b/arch/arm/include/asm/kvm_arm.h
> @@ -187,6 +187,7 @@
>  #define FSC_FAULT	(0x04)
>  #define FSC_ACCESS	(0x08)
>  #define FSC_PERM	(0x0c)
> +#define FSC_EXTABT	(0x10)
>  
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~0xf)
> diff --git a/arch/arm/include/asm/system_misc.h b/arch/arm/include/asm/system_misc.h
> index a3d61ad..ea45d94 100644
> --- a/arch/arm/include/asm/system_misc.h
> +++ b/arch/arm/include/asm/system_misc.h
> @@ -24,4 +24,9 @@
>  
>  #endif /* !__ASSEMBLY__ */
>  
> +static inline int handle_guest_sea(unsigned long addr, unsigned int esr)
> +{
> +	return -1;
> +}
> +
>  #endif /* __ASM_ARM_SYSTEM_MISC_H */
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index a5265ed..04f1dd50 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -29,6 +29,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/virt.h>
> +#include <asm/system_misc.h>
>  
>  #include "trace.h"
>  
> @@ -1444,8 +1445,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	/* Check the stage-2 fault is trans. fault or write fault */
>  	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
> -	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
> -	    fault_status != FSC_ACCESS) {
> +
> +	/* The host kernel will handle the synchronous external abort. There
> +	 * is no need to pass the error into the guest.
> +	 */

Can we inject an sea into the guest, so that the guest can kill the
application which causes the error if the guest won't be terminated
later. I'm not sure whether ghes_handle_memory_failure() called in
ghes_do_proc() will kill the qemu process. I think it only kill user
processes marked with PF_MCE_PROCESS & PF_MCE_EARLY.

> +	if (fault_status == FSC_EXTABT) {
> +		if(handle_guest_sea((unsigned long)fault_ipa,
> +				    kvm_vcpu_get_hsr(vcpu))) {
> +			kvm_err("Failed to handle guest SEA, FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
> +				kvm_vcpu_trap_get_class(vcpu),
> +				(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
> +				(unsigned long)kvm_vcpu_get_hsr(vcpu));
> +			return -EFAULT;
> +		}
> +	} else if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
> +		   fault_status != FSC_ACCESS) {
>  		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>  			kvm_vcpu_trap_get_class(vcpu),
>  			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 2a2752b..2b11d59 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -201,6 +201,7 @@
>  #define FSC_FAULT	ESR_ELx_FSC_FAULT
>  #define FSC_ACCESS	ESR_ELx_FSC_ACCESS
>  #define FSC_PERM	ESR_ELx_FSC_PERM
> +#define FSC_EXTABT	ESR_ELx_FSC_EXTABT
>  
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
>  #define HPFAR_MASK	(~UL(0xf))
> diff --git a/arch/arm64/include/asm/system_misc.h b/arch/arm64/include/asm/system_misc.h
> index bc81243..5b2cecd1 100644
> --- a/arch/arm64/include/asm/system_misc.h
> +++ b/arch/arm64/include/asm/system_misc.h
> @@ -58,4 +58,6 @@ void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
>  
>  #endif	/* __ASSEMBLY__ */
>  
> +int handle_guest_sea(unsigned long addr, unsigned int esr);
> +
>  #endif	/* __ASM_SYSTEM_MISC_H */
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index b2d57fc..403277b 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -602,6 +602,24 @@ static const char *fault_name(unsigned int esr)
>  }
>  
>  /*
> + * Handle Synchronous External Aborts that occur in a guest kernel.
> + */
> +int handle_guest_sea(unsigned long addr, unsigned int esr)
> +{
> +	/*
> +	 * synchronize_rcu() will wait for nmi_exit(), so no need to
> +	 * rcu_read_lock().
> +	 */
> +	if(IS_ENABLED(HAVE_ACPI_APEI_SEA)) {
> +		nmi_enter();
> +		ghes_notify_sea();
> +		nmi_exit();
> +	}
> +
> +	return 0;
> +}
> +
> +/*
>   * Dispatch a data abort to the relevant handler.
>   */
>  asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
> 

Thanks,
Wang Xiongfeng
