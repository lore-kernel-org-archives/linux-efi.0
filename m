From: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH V7 10/10] arm/arm64: KVM: add guest SEA support
Date: Mon, 16 Jan 2017 11:58:34 +0000
Message-ID: <98ed774f-fcc1-e10d-05ef-ebea52e916d2@arm.com>
References: <1484244924-24786-1-git-send-email-tbaicar@codeaurora.org>
 <1484244924-24786-11-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484244924-24786-11-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi@vger.k
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 12/01/17 18:15, Tyler Baicar wrote:
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
>  arch/arm64/mm/fault.c                | 13 +++++++++++++
>  6 files changed, 38 insertions(+), 2 deletions(-)
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
> @@ -24,4 +24,9 @@ extern unsigned int user_debug;
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
> index e9a5c0e..1152966 100644
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
> @@ -1441,8 +1442,21 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	/* Check the stage-2 fault is trans. fault or write fault */
>  	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
> -	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
> -	    fault_status != FSC_ACCESS) {
> +
> +	/* The host kernel will handle the synchronous external abort. There
> +	 * is no need to pass the error into the guest.
> +	 */
> +	if (fault_status == FSC_EXTABT) {
> +		if(handle_guest_sea((unsigned long)fault_ipa,
> +				    kvm_vcpu_get_hsr(vcpu))) {
> +			kvm_err("Failed to handle guest SEA, FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
> +				kvm_vcpu_trap_get_class(vcpu),
> +				(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
> +				(unsigned long)kvm_vcpu_get_hsr(vcpu));

So there's one thing I don't like here, which is that we just gave the
guest a very nice way to pollute the host's kernel log with spurious
messages. So I'd rather make it silent, or at the very least rate limited.

> +			return -EFAULT;
> +		}
> +	} else if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
> +		   fault_status != FSC_ACCESS) {
>  		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>  			kvm_vcpu_trap_get_class(vcpu),
>  			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 4b5c977..be0efb6 100644
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
> index e7f3440..27816cb 100644
> --- a/arch/arm64/include/asm/system_misc.h
> +++ b/arch/arm64/include/asm/system_misc.h
> @@ -77,4 +77,6 @@ extern void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
>  int register_sea_notifier(struct notifier_block *nb);
>  void unregister_sea_notifier(struct notifier_block *nb);
>  
> +int handle_guest_sea(unsigned long addr, unsigned int esr);
> +
>  #endif	/* __ASM_SYSTEM_MISC_H */
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 81039c7..fa8d4d7 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -597,6 +597,19 @@ static const char *fault_name(unsigned int esr)
>  }
>  
>  /*
> + * Handle Synchronous External Aborts that occur in a guest kernel.
> + */
> +int handle_guest_sea(unsigned long addr, unsigned int esr)
> +{
> +	atomic_notifier_call_chain(&sea_handler_chain, 0, NULL);
> +
> +	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
> +		fault_name(esr), esr, addr);

Same here.

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

	M.
-- 
Jazz is not dead. It just smells funny...
