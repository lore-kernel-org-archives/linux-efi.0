From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86: setup: extend low identity map to cover whole
 kernel range
Date: Wed, 14 Oct 2015 22:00:50 +0100
Message-ID: <20151014210050.GE2782@codeblueprint.co.uk>
References: <1444822245-6784-1-git-send-email-pbonzini@redhat.com>
 <20151014135211.GB2782@codeblueprint.co.uk>
 <CALCETrX=4NcbfnaQ7wf27v+xn8dY_=acJwX4EjWZVTTWZeJ_yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrX=4NcbfnaQ7wf27v+xn8dY_=acJwX4EjWZVTTWZeJ_yg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, stable <stable@vger.kernel.org>, Laszlo Ersek <lersek@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 14 Oct, at 09:22:03AM, Andy Lutomirski wrote:
> On Wed, Oct 14, 2015 at 6:52 AM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> > (Pulling in luto for low-level x86 fu)
> >
> > On Wed, 14 Oct, at 01:30:45PM, Paolo Bonzini wrote:
> >> On 32-bit systems, the initial_page_table is reused by
> >> efi_call_phys_prolog as an identity map to call
> >> SetVirtualAddressMap.  efi_call_phys_prolog takes care of
> >> converting the current CPU's GDT to a physical address too.
> >>
> >> For PAE kernels the identity mapping is achieved by aliasing the
> >> first PDPE for the kernel memory mapping into the first PDPE
> >> of initial_page_table.  This makes the EFI stub's trick "just work".
> >>
> >> However, for non-PAE kernels there is no guarantee that the identity
> >> mapping in the initial_page_table extends as far as the GDT; in this
> >> case, accesses to the GDT will cause a page fault (which quickly becomes
> >> a triple fault).  Fix this by copying the kernel mappings from
> >> swapper_pg_dir to initial_page_table twice, both at PAGE_OFFSET and at
> >> identity mapping.
> >
> > Oops, good catch guys. This is clearly a bug, but...
> >
> >> For some reason, this is only reproducible with QEMU's dynamic translation
> >> mode, and not for example with KVM.  However, even under KVM one can clearly
> >> see that the page table is bogus:
> 
> I haven't looked at the code, but it wouldn't surprise me if this is
> some kind of TLB issue.  With the hardware TLB (which is in use on
> KVM), it seems quite likely that the GDT is pretty much always in the
> TLB and, if nothing flushes global mappings, then it'll probably stick
> around.

>From some quick experiments it appears that you can skate past this
issue if you don't receive any interrupts while the bogus GDT pointer
is loaded, or if you avoid reloading the segment registers in general.
Which is interesting because I assumed that writing to GDTR took
immediate effect.

Up until commit 23a0d4e8fa6d ("efi: Disable interrupts around EFI
calls, not in the epilog/prolog calls") interrupts were disabled
around the prolog and epilog calls, and the functional GDT was
re-installed before interrupts were re-enabled. 

That does explain why no one has complained about this issue before.

-- 
Matt Fleming, Intel Open Source Technology Center
