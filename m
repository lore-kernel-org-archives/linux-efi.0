From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH V13 10/10] arm/arm64: KVM: add guest SEA support
Date: Tue, 28 Mar 2017 11:57:52 +0100
Message-ID: <58DA41B0.8080203@arm.com>
References: <1490136425-4324-1-git-send-email-tbaicar@codeaurora.org>
 <1490136425-4324-11-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1490136425-4324-11-git-send-email-tbaicar@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, rostedt@goodmis.org, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, joe@perches.com, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

Hi Tyler,

On 21/03/17 22:47, Tyler Baicar wrote:
> Currently external aborts are unsupported by the guest abort
> handling. Add handling for SEAs so that the host kernel reports
> SEAs which occur in the guest kernel.

Looks good,

Can we squash the APEI changes into the patch that added them? This would be one
fewer patches that then need the ACPI maintainer to review.


> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 962616f..105b6ab 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1406,6 +1407,24 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  		kvm_set_pfn_accessed(pfn);
>  }
>  
> +static bool is_abort_synchronous(unsigned long fault_status) {

I missed kvm_vcpu_dabt_isextabt() when I suggested we would need a helper (my
fault). Can we use that instead?

(my argument that the unused encodings are reserved doesn't hold if KVM is
already doing this... )


> @@ -1426,23 +1445,31 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	unsigned long hva;
>  	bool is_iabt, write_fault, writable;
>  	gfn_t gfn;
> -	int ret, idx;
> +	int ret, idx, sea_status = 1;
> +
> +	/* Check the stage-2 fault is trans. fault or write fault */
> +	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
> +
> +	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> +
> +	/* The host kernel will handle the synchronous external abort. There
> +	 * is no need to pass the error into the guest.
> +	 */
> +	if (is_abort_synchronous(fault_status))
> +		sea_status = handle_guest_sea((unsigned long)fault_ipa,
> +				    kvm_vcpu_get_hsr(vcpu));


Why not return from here if the error has been handled?

You use sea_status to skip the next two things that KVM might do, but it goes on
to try and process this, possibly calling user_mem_abort(), surely all this is
unnecessary?


>  
>  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> -	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu))) {
> +	if (unlikely(!is_iabt && kvm_vcpu_dabt_isextabt(vcpu)) && sea_status) {
>  		kvm_inject_vabt(vcpu);
>  		return 1;
>  	}
>  
> -	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> -
>  	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
>  			      kvm_vcpu_get_hfar(vcpu), fault_ipa);
>  
> -	/* Check the stage-2 fault is trans. fault or write fault */
> -	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
>  	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
> -	    fault_status != FSC_ACCESS) {
> +	    fault_status != FSC_ACCESS && sea_status) {
>  		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>  			kvm_vcpu_trap_get_class(vcpu),
>  			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),


Thanks,

James
