From: Florent Revest <revestflo@gmail.com>
Subject: Re: [RFC 04/11] KVM, arm, arm64: Offer PAs to IPAs idmapping to
 internal VMs
Date: Tue, 26 Sep 2017 23:14:45 +0200
Message-ID: <1506460485.5507.57.camel@gmail.com>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
         <1503649901-5834-5-git-send-email-florent.revest@arm.com>
         <20170831092305.GA13572@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170831092305.GA13572@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, Florent Revest <florent.revest@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, marc.zyngier@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, leif.lindholm@arm.com
List-Id: linux-efi@vger.kernel.org

On Thu, 2017-08-31 at 11:23 +0200, Christoffer Dall wrote:
> > diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> > index 2ea21da..1d2d3df 100644
> > --- a/virt/kvm/arm/mmu.c
> > +++ b/virt/kvm/arm/mmu.c
> > @@ -772,6 +772,11 @@ static void stage2_unmap_memslot(struct kvm
> > *kvm,
> >         phys_addr_t size = PAGE_SIZE * memslot->npages;
> >         hva_t reg_end = hva + size;
> > 
> > +       if (unlikely(!kvm->mm)) {
> I think you should consider using a predicate so that it's clear that
> this is for in-kernel VMs and not just some random situation where mm
> can be NULL.

Internal VMs should be the only usage when kvm->mm would be NULL.
However if you'd prefer it otherwise, I'll make sure this condition
will be made clearer.

> So it's unclear to me why we don't need any special casing in
> kvm_handle_guest_abort, related to MMIO exits etc.  You probably
> assume that we will never do emulation, but that should be described
> and addressed somewhere before I can critically review this patch.

This is indeed what I was assuming. This RFC does not allow MMIO with
internal VMs. I can not think of a usage when this would be useful. I'd
make sure this would be documented in an eventual later RFC.

> > +static int internal_vm_prep_mem(struct kvm *kvm,
> > +                               const struct
> > kvm_userspace_memory_region *mem)
> > +{
> > +       phys_addr_t addr, end;
> > +       unsigned long pfn;
> > +       int ret;
> > +       struct kvm_mmu_memory_cache cache = { 0 };
> > +
> > +       end = mem->guest_phys_addr + mem->memory_size;
> > +       pfn = __phys_to_pfn(mem->guest_phys_addr);
> > +       addr = mem->guest_phys_addr;
> My main concern here is that we don't do any checks on this region
> and we could be mapping device memory here as well.  Are we intending
> that to be ok, and are we then relying on the guest to use proper
> memory attributes ?

Indeed, being able to map device memory is intended. It is needed for
Runtime Services sandboxing. It also relies on the guest being
correctly configured.

> > +
> > +       for (; addr < end; addr += PAGE_SIZE) {
> > +               pte_t pte = pfn_pte(pfn, PAGE_S2);
> > +
> > +               pte = kvm_s2pte_mkwrite(pte);
> > +
> > +               ret = mmu_topup_memory_cache(&cache,
> > +                                            KVM_MMU_CACHE_MIN_PAGE
> > S,
> > +                                            KVM_NR_MEM_OBJS);
> You should be able to allocate all you need up front instead of doing
> it in sequences.

Ok.

> > 
> > +               if (ret) {
> > +                       mmu_free_memory_cache(&cache);
> > +                       return ret;
> > +               }
> > +               spin_lock(&kvm->mmu_lock);
> > +               ret = stage2_set_pte(kvm, &cache, addr, &pte, 0);
> > +               spin_unlock(&kvm->mmu_lock);
> Since you're likely to allocate some large contiguous chunks here,
> can you have a look at using section mappings?

Will do.

Thank you very much,
    Florent
