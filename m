From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part1 PATCH v3 16/17] X86/KVM: Provide support to create
 Guest and HV shared per-CPU variables
Date: Tue, 29 Aug 2017 12:22:58 +0200
Message-ID: <20170829102258.gxk227js4yw47qi3@pd.tnic>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-17-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724190757.11278-17-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 24, 2017 at 02:07:56PM -0500, Brijesh Singh wrote:
> Some KVM specific MSR's (steal-time, asyncpf, avic_eio) allocates per-CPU

		   MSRs

> variable at compile time and share its physical address with hypervisor.

That sentence needs changing - the MSRs don't allocate - for them gets
allocated.

> It presents a challege when SEV is active in guest OS, when SEV is active,
> the guest memory is encrypted with guest key hence hypervisor will not
> able to modify the guest memory. When SEV is active, we need to clear the
> encryption attribute (aka C-bit) of shared physical addresses so that both
> guest and hypervisor can access the data.

This whole paragraph needs rewriting.

> To solve this problem, I have tried these three options:
> 
> 1) Convert the static per-CPU to dynamic per-CPU allocation and when SEV
> is detected clear the C-bit from the page table. But while doing so I
> found that per-CPU dynamic allocator was not ready when kvm_guest_cpu_init
> was called.
> 
> 2) Since the C-bit works on PAGE_SIZE hence add some extra padding to
> 'struct kvm-steal-time' to make it PAGE_SIZE and then at runtime

"to make it PAGE_SIZE"?

I know what it means but it reads strange and needs more restraint when
rewriting it. :)

> clear the encryption attribute of the full PAGE. The downside of this -
> we need to modify structure which may break the compatibility.
> 
> 3) Define a new per-CPU section (.data..percpu.hv_shared) which will be
> used to hold the compile time shared per-CPU variables. When SEV is
> detected we map this section without C-bit.
> 
> This patch implements #3.

>From Documentation/process/submitting-patches.rst:

 "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour."

Also, never say "This patch" in a commit message of a patch. It is
tautologically useless.

> It introduces a new DEFINE_PER_CPU_HV_SHAHRED

There's no DEFINE_PER_CPU_HV_SHAHRED. Typo.

> macro to create a compile time per-CPU variable. When SEV is detected we
> clear the C-bit from the shared per-CPU variable.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kernel/kvm.c             | 46 ++++++++++++++++++++++++++++++++++++---
>  include/asm-generic/vmlinux.lds.h |  3 +++
>  include/linux/percpu-defs.h       | 12 ++++++++++
>  3 files changed, 58 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 71c17a5..1f6fec8 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -75,8 +75,8 @@ static int parse_no_kvmclock_vsyscall(char *arg)
>  
>  early_param("no-kvmclock-vsyscall", parse_no_kvmclock_vsyscall);
>  
> -static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
> -static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
> +static DEFINE_PER_CPU_HV_SHARED(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
> +static DEFINE_PER_CPU_HV_SHARED(struct kvm_steal_time, steal_time) __aligned(64);
>  static int has_steal_clock = 0;
>  
>  /*
> @@ -303,7 +303,7 @@ static void kvm_register_steal_time(void)
>  		cpu, (unsigned long long) slow_virt_to_phys(st));
>  }
>  
> -static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
> +static DEFINE_PER_CPU_HV_SHARED(unsigned long, kvm_apic_eoi) = KVM_PV_EOI_DISABLED;
>  
>  static notrace void kvm_guest_apic_eoi_write(u32 reg, u32 val)
>  {
> @@ -319,11 +319,51 @@ static notrace void kvm_guest_apic_eoi_write(u32 reg, u32 val)
>  	apic->native_eoi_write(APIC_EOI, APIC_EOI_ACK);
>  }
>  
> +/* NOTE: function is marked as __ref because it is used by __init functions */

No need for that comment.

What should you look into is why do you need to call the early versions:

" * producing a warning (of course, no warning does not mean code is
 * correct, so optimally document why the __ref is needed and why it's OK)."

And we do have the normal set_memory_decrypted() etc helpers so why
aren't we using those?

If you need to use the early ones too, then you probably need to
differentiate this in the callers by passing a "bool early", which calls
the proper flavor.

> +static int __ref kvm_map_hv_shared_decrypted(void)
> +{
> +	static int once, ret;
> +	int cpu;
> +
> +	if (once)
> +		return ret;

So this function gets called per-CPU but you need to do this ugly "once"
thing - i.e., global function called in a per-CPU context.

Why can't you do that mapping only on the current CPU and then
when that function is called on the next CPU, it will do the same thing
on that next CPU?

> +	/*
> +	 * Iterate through all possible CPU's and clear the C-bit from
> +	 * percpu variables.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		struct kvm_vcpu_pv_apf_data *apf;
> +		unsigned long pa;
> +
> +		apf = &per_cpu(apf_reason, cpu);
> +		pa = slow_virt_to_phys(apf);
> +		sme_early_decrypt(pa & PAGE_MASK, PAGE_SIZE);
> +		ret = early_set_memory_decrypted(pa, PAGE_SIZE);
> +		if (ret)
> +			break;
> +	}
> +
> +	once = 1;
> +	return ret;
> +}
> +
>  static void kvm_guest_cpu_init(void)
>  {
>  	if (!kvm_para_available())
>  		return;
>  
> +	/*
> +	 * When SEV is active, map the shared percpu as unencrypted so that

			    ... map the share percpu area unecnrypted...

> +	 * both guest and hypervsior can access the data.
> +	 */
> +	if (sev_active()) {
> +		if (kvm_map_hv_shared_decrypted()) {
> +			printk(KERN_ERR "Failed to map percpu as unencrypted\n");
> +			return;
> +		}
> +	}
> +
>  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf) {
>  		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
>  
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index da0be9a..52854cf 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -783,6 +783,9 @@
>  	. = ALIGN(cacheline);						\
>  	*(.data..percpu)						\
>  	*(.data..percpu..shared_aligned)				\
> +	. = ALIGN(PAGE_SIZE);						\
> +	*(.data..percpu..hv_shared)					\
> +	. = ALIGN(PAGE_SIZE);						\
>  	VMLINUX_SYMBOL(__per_cpu_end) = .;

Yeah, no, you can't do that. That's adding this section unconditionally
on *every* arch. You need to do some ifdeffery like it is done at the
beginning of that file and have this only on the arch which supports SEV.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
