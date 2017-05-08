From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 3/3] arm/arm64: signal SIBGUS and inject SEA Error
Date: Mon, 8 May 2017 19:54:16 +0200
Message-ID: <20170508175416.GA32234@cbox>
References: <CAMj-D2BGTDKpOcMu2ip41_MTTj8VDwvs59Ds7yvLHcD8PeQzhg@mail.gmail.com>
 <5910AAA2.4030304@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5910AAA2.4030304@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: gengdongjiu <gengdj.1984@gmail.com>, Tyler Baicar <tbaicar@codeaurora.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, Len Brown <lenb@kernel.org>, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, Sandeepa Prabhu <sandeepa.s.prabhu@gmail.com>, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, Fu Wei <fu.wei@linaro.org>, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Mon, May 08, 2017 at 06:28:02PM +0100, James Morse wrote:

[...]

> 
> 
> >>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >>> index bb02909..1d2e2e7 100644
> >>> --- a/include/uapi/linux/kvm.h
> >>> +++ b/include/uapi/linux/kvm.h
> >>> @@ -1306,6 +1306,7 @@ struct kvm_s390_ucas_mapping {
> >>>  #define KVM_S390_GET_IRQ_STATE  _IOW(KVMIO, 0xb6, struct kvm_s390_irq_state)
> >>>  /* Available with KVM_CAP_X86_SMM */
> >>>  #define KVM_SMI                   _IO(KVMIO,   0xb7)
> >>> +#define KVM_ARM_SEA               _IO(KVMIO,   0xb8)
> >>>
> >>>  #define KVM_DEV_ASSIGN_ENABLE_IOMMU (1 << 0)
> >>>  #define KVM_DEV_ASSIGN_PCI_2_3 (1 << 1)
> >>>
> >>
> >> Why do we need a userspace API for SEA? It can also be done by using
> >> KVM_{G,S}ET_ONE_REG to change the vcpu registers. The advantage of doing it this
> >> way is you can choose which ESR value to use.
> >>
> >> Adding a new API call to do something you could do with an old one doesn't look
> >> right.
> > 
> > James, I considered your suggestion before that use the
> > KVM_{G,S}ET_ONE_REG to change the vcpu registers. but I found it does
> > not have difference to use the alread existed KVM API. 
> 
> (Only that is an in-kernel helper, not a published API)
> 
> 
> > so may be
> > changing the vcpu registers in qemu will duplicate with the KVM APIs.
> 
> That is true, but the alternative is a new API that doesn't do anything new, its
> just more convenient.
> 
> Marc and Christoffer are the people to convince.
> I argue the existing API is sufficient.
> 

I must admit I am losing track of exactly what this proposed API was
supposed to do.

However, if it's a question about setting up VCPU registers to a certain
state and potentially modifying memory, then I think experience has
shown us (psci) that emulating something in the kernel that userspace
can have fine-grained control over is a bad idea, and should be left to
userspace using as generic APIs as possible.

Furthermore, if I understand what injecting a SEA requires, it is very
similar to resetting the CPU and loading data into guest memory, which
QEMU already does today, and there is no reason to introduce additional
APIs if it can be done using KVM_GET/SET_ONE_REG ioctls.

Thanks,
-Christoffer
