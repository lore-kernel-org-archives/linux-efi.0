From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 04/11] KVM, arm, arm64: Offer PAs to IPAs idmapping to
 internal VMs
Date: Mon, 16 Oct 2017 22:45:05 +0200
Message-ID: <20171016204505.GN1845@lvm>
References: <1503649901-5834-1-git-send-email-florent.revest@arm.com>
 <1503649901-5834-5-git-send-email-florent.revest@arm.com>
 <20170831092305.GA13572@cbox> <1506460485.5507.57.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Content-Disposition: inline
In-Reply-To: <1506460485.5507.57.camel@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Florent Revest <revestflo@gmail.com>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, ard.biesheuvel@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@arm.com, marc.zyngier@arm.com, pbonzini@redhat.com, Florent Revest <florent.revest@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 26, 2017 at 11:14:45PM +0200, Florent Revest wrote:
> On Thu, 2017-08-31 at 11:23 +0200, Christoffer Dall wrote:
> > > diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> > > index 2ea21da..1d2d3df 100644
> > > --- a/virt/kvm/arm/mmu.c
> > > +++ b/virt/kvm/arm/mmu.c
> > > @@ -772,6 +772,11 @@ static void stage2_unmap_memslot(struct kvm
> > > *kvm,
> > > =A0=A0=A0=A0=A0=A0=A0=A0phys_addr_t size =3D PAGE_SIZE * memslot->npa=
ges;
> > > =A0=A0=A0=A0=A0=A0=A0=A0hva_t reg_end =3D hva + size;
> > > =

> > > +=A0=A0=A0=A0=A0=A0=A0if (unlikely(!kvm->mm)) {
> > I think you should consider using a predicate so that it's clear that
> > this is for in-kernel VMs and not just some random situation where mm
> > can be NULL.
> =

> Internal VMs should be the only usage when kvm->mm would be NULL.
> However if you'd prefer it otherwise, I'll make sure this condition
> will be made clearer.
> =


My point was then when I see (!kvm->mm) it looks like a bug, but if I
saw is_in_kernel_vm(kvm) then it looks like a feature.

> > So it's unclear to me why we don't need any special casing in
> > kvm_handle_guest_abort, related to MMIO exits etc.=A0=A0You probably
> > assume that we will never do emulation, but that should be described
> > and addressed somewhere before I can critically review this patch.
> =

> This is indeed what I was assuming. This RFC does not allow MMIO with
> internal VMs. I can not think of a usage when this would be useful. I'd
> make sure this would be documented in an eventual later RFC.
> =


OK, sounds good.  It's important for me as a reviewer to be able to tell
the differenc between 'assumed valid guest behavior' and 'limitations of
in-kernel VM support' which are handled in such and such way.


> > > +static int internal_vm_prep_mem(struct kvm *kvm,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0const struct
> > > kvm_userspace_memory_region *mem)
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0phys_addr_t addr, end;
> > > +=A0=A0=A0=A0=A0=A0=A0unsigned long pfn;
> > > +=A0=A0=A0=A0=A0=A0=A0int ret;
> > > +=A0=A0=A0=A0=A0=A0=A0struct kvm_mmu_memory_cache cache =3D { 0 };
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0end =3D mem->guest_phys_addr + mem->memory_size;
> > > +=A0=A0=A0=A0=A0=A0=A0pfn =3D __phys_to_pfn(mem->guest_phys_addr);
> > > +=A0=A0=A0=A0=A0=A0=A0addr =3D mem->guest_phys_addr;
> > My main concern here is that we don't do any checks on this region
> > and we could be mapping device memory here as well.=A0=A0Are we intendi=
ng
> > that to be ok, and are we then relying on the guest to use proper
> > memory attributes ?
> =

> Indeed, being able to map device memory is intended. It is needed for
> Runtime Services sandboxing. It also relies on the guest being
> correctly configured.
> =


So the reason why we wanted to enforce device attribute mappings in
stage 2 was to avoid a guest having the potential to do cached writes to
a device, which would hit at a later time while no longer running the
VM, potentially breaking isolation through manipulation of a device.

This seems to break with that level of isolation, and that property of
in-kernel VMs should be clearly pointed out somewhere.

> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0for (; addr < end; addr +=3D PAGE_SIZE) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pte_t pte =3D pfn_pte(p=
fn, PAGE_S2);
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pte =3D kvm_s2pte_mkwri=
te(pte);
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D mmu_topup_memor=
y_cache(&cache,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0KVM_MMU_C=
ACHE_MIN_PAGE
> > > S,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0KVM_NR_ME=
M_OBJS);
> > You should be able to allocate all you need up front instead of doing
> > it in sequences.
> =

> Ok.
> =

> > > =

> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0mmu_free_memory_cache(&cache);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0return ret;
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0spin_lock(&kvm->mmu_loc=
k);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D stage2_set_pte(=
kvm, &cache, addr, &pte, 0);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0spin_unlock(&kvm->mmu_l=
ock);
> > Since you're likely to allocate some large contiguous chunks here,
> > can you have a look at using section mappings?
> =

> Will do.
> =


Thanks!
-Christoffer
