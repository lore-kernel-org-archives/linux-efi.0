From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 04/11] KVM, arm, arm64: Offer PAs to IPAs idmapping to
 internal VMs
Date: Thu, 31 Aug 2017 11:23:05 +0200
Message-ID: <20170831092305.GA13572@cbox>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
 <1503649901-5834-5-git-send-email-florent.revest@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503649901-5834-5-git-send-email-florent.revest@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Florent Revest <florent.revest@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, leif.lindholm@arm.com, revestflo@gmail.com
List-Id: linux-efi@vger.kernel.org

Hi Florent,

I'd like for the UEFI folks and arm64 kernel maintainers to express
their views on this overall approach before I do an in-depth review, but
I have some random comments based on reading this patch:

On Fri, Aug 25, 2017 at 09:31:34AM +0100, Florent Revest wrote:
> Usual KVM virtual machines map guest's physical addresses from a process
> userspace memory. However, with the new concept of internal VMs, a virtual
> machine can be created from the kernel, without any link to a userspace
> context. Hence, some of the KVM's architecture-specific code needs to be
> modified to take this kind of VMs into account.
> 
> The approach chosen with this patch is to let internal VMs idmap physical
> addresses into intermediary physical addresses by calling
> kvm_set_memory_region with a kvm_userspace_memory_region where the
> guest_phys_addr field points both to the original PAs and to the IPAs. The
> userspace_addr field of this struct is therefore ignored with internal VMs.
> 
> This patch extends the capabilities of the arm and arm64 stage2 MMU code
> to handle internal VMs. Three things are changed:
> 
> - Various parts of the MMU code which are related to a userspace context
> are now only executed if kvm->mm is present.
> 
> - When this pointer is NULL, struct kvm_userspace_memory_regions are
> treated by internal_vm_prep_mem as idmaps of physical memory.
> 
> - A set of 256 additional private memslots is now reserved on arm64 for the
> usage of internal VMs memory idmapping.
> 
> Note: this patch should have pretty much no performance impact on the
> critical path of traditional VMs since only one unlikely branch had to be
> added to the page fault handler.
> 
> Signed-off-by: Florent Revest <florent.revest@arm.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  virt/kvm/arm/mmu.c                | 76 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 74 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d686300..65aab35 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -32,6 +32,7 @@
>  #define __KVM_HAVE_ARCH_INTC_INITIALIZED
> 
>  #define KVM_USER_MEM_SLOTS 512
> +#define KVM_PRIVATE_MEM_SLOTS 256
>  #define KVM_HALT_POLL_NS_DEFAULT 500000
> 
>  #include <kvm/arm_vgic.h>
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 2ea21da..1d2d3df 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -772,6 +772,11 @@ static void stage2_unmap_memslot(struct kvm *kvm,
>         phys_addr_t size = PAGE_SIZE * memslot->npages;
>         hva_t reg_end = hva + size;
> 
> +       if (unlikely(!kvm->mm)) {

I think you should consider using a predicate so that it's clear that
this is for in-kernel VMs and not just some random situation where mm
can be NULL.

> +               unmap_stage2_range(kvm, addr, size);
> +               return;
> +       }
> +
>         /*
>          * A memory region could potentially cover multiple VMAs, and any holes
>          * between them, so iterate over all of them to find out if we should
> @@ -819,7 +824,8 @@ void stage2_unmap_vm(struct kvm *kvm)
>         int idx;
> 
>         idx = srcu_read_lock(&kvm->srcu);
> -       down_read(&current->mm->mmap_sem);
> +       if (likely(kvm->mm))
> +               down_read(&current->mm->mmap_sem);
>         spin_lock(&kvm->mmu_lock);
> 
>         slots = kvm_memslots(kvm);
> @@ -827,7 +833,8 @@ void stage2_unmap_vm(struct kvm *kvm)
>                 stage2_unmap_memslot(kvm, memslot);
> 
>         spin_unlock(&kvm->mmu_lock);
> -       up_read(&current->mm->mmap_sem);
> +       if (likely(kvm->mm))
> +               up_read(&current->mm->mmap_sem);
>         srcu_read_unlock(&kvm->srcu, idx);
>  }
> 
> @@ -1303,6 +1310,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 return -EFAULT;
>         }
> 
> +       if (unlikely(!kvm->mm)) {
> +               kvm_err("Unexpected internal VM page fault\n");
> +               kvm_inject_vabt(vcpu);
> +               return 0;
> +       }
> +

So it's unclear to me why we don't need any special casing in
kvm_handle_guest_abort, related to MMIO exits etc.  You probably assume
that we will never do emulation, but that should be described and
addressed somewhere before I can critically review this patch.

>         /* Let's check if we will get back a huge page backed by hugetlbfs */
>         down_read(&current->mm->mmap_sem);
>         vma = find_vma_intersection(current->mm, hva, hva + 1);
> @@ -1850,6 +1863,54 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>                 kvm_mmu_wp_memory_region(kvm, mem->slot);
>  }
> 
> +/*
> + * internal_vm_prep_mem - maps a range of hpa to gpa at stage2
> + *
> + * While userspace VMs manage gpas using hvas, internal virtual machines need a
> + * way to map physical addresses to a guest. In order to avoid code duplication,
> + * the kvm_set_memory_region call is kept for internal VMs, however it usually
> + * expects a struct kvm_userspace_memory_region with a userspace_addr field.
> + * With internal VMs, this field is ignored and physical memory memory pointed
> + * by guest_phys_addr can only be idmapped.
> + */
> +static int internal_vm_prep_mem(struct kvm *kvm,
> +                               const struct kvm_userspace_memory_region *mem)
> +{
> +       phys_addr_t addr, end;
> +       unsigned long pfn;
> +       int ret;
> +       struct kvm_mmu_memory_cache cache = { 0 };
> +
> +       end = mem->guest_phys_addr + mem->memory_size;
> +       pfn = __phys_to_pfn(mem->guest_phys_addr);
> +       addr = mem->guest_phys_addr;

My main concern here is that we don't do any checks on this region and
we could be mapping device memory here as well.  Are we intending that
to be ok, and are we then relying on the guest to use proper memory
attributes ?

> +
> +       for (; addr < end; addr += PAGE_SIZE) {
> +               pte_t pte = pfn_pte(pfn, PAGE_S2);
> +
> +               pte = kvm_s2pte_mkwrite(pte);
> +
> +               ret = mmu_topup_memory_cache(&cache,
> +                                            KVM_MMU_CACHE_MIN_PAGES,
> +                                            KVM_NR_MEM_OBJS);

You should be able to allocate all you need up front instead of doing it
in sequences.

> +               if (ret) {
> +                       mmu_free_memory_cache(&cache);
> +                       return ret;
> +               }
> +               spin_lock(&kvm->mmu_lock);
> +               ret = stage2_set_pte(kvm, &cache, addr, &pte, 0);
> +               spin_unlock(&kvm->mmu_lock);

Since you're likely to allocate some large contiguous chunks here, can
you have a look at using section mappings?

> +               if (ret) {
> +                       mmu_free_memory_cache(&cache);
> +                       return ret;
> +               }
> +
> +               pfn++;
> +       }
> +
> +       return ret;
> +}
> +
>  int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                                    struct kvm_memory_slot *memslot,
>                                    const struct kvm_userspace_memory_region *mem,
> @@ -1872,6 +1933,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>             (KVM_PHYS_SIZE >> PAGE_SHIFT))
>                 return -EFAULT;
> 
> +       if (unlikely(!kvm->mm)) {
> +               ret = internal_vm_prep_mem(kvm, mem);
> +               if (ret)
> +                       goto out;
> +               goto out_internal_vm;
> +       }
> +
>         down_read(&current->mm->mmap_sem);
>         /*
>          * A memory region could potentially cover multiple VMAs, and any holes
> @@ -1930,6 +1998,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                 hva = vm_end;
>         } while (hva < reg_end);
> 
> +out_internal_vm:
>         if (change == KVM_MR_FLAGS_ONLY)
>                 goto out;
> 
> @@ -1940,7 +2009,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>                 stage2_flush_memslot(kvm, memslot);
>         spin_unlock(&kvm->mmu_lock);
>  out:
> -       up_read(&current->mm->mmap_sem);
> +       if (kvm->mm)
> +               up_read(&current->mm->mmap_sem);
>         return ret;
>  }
> 
> --
> 1.9.1
> 

Thanks,
-Christoffer
