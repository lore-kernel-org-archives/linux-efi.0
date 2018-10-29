From: Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH V2 1/2] x86/efi: Unmap EFI boot services code/data regions
 from efi_pgd
Date: Mon, 29 Oct 2018 19:18:50 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1810291911570.5984@nanos.tec.linutronix.de>
References: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com> <20181026213845.28166-2-sai.praneeth.prakhya@intel.com> <alpine.DEB.2.21.1810291809490.5984@nanos.tec.linutronix.de> <alpine.DEB.2.21.1810291820250.5984@nanos.tec.linutronix.de>
 <FFF73D592F13FD46B8700F0A279B802F485E5549@ORSMSX114.amr.corp.intel.com> <alpine.DEB.2.21.1810291907320.5984@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1810291907320.5984@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Sai,

On Mon, 29 Oct 2018, Thomas Gleixner wrote:
> On Mon, 29 Oct 2018, Prakhya, Sai Praneeth wrote:
> 
> > Hi Thomas and Peter,
> > 
> > [off the mailing list because I wasn't sure if it's a good idea to spam others with my questions]
> 
> In general it's good to do on list because others can learn from the
> answers as well.

So you somehow managed to keep everyone and the lists in CC
nevertheless. Did not pay attention to the CC list until I got my reply on
the list :)

> > > > > +	retval = __change_page_attr_set_clr(&cpa, 0);
> > > > > +	__flush_tlb_all();
> > > >
> > > > So this looks like you copied it from kernel_map_pages_in_pgd() which
> > > > has been discussed before to be not sufficient, but it can't be
> > > > changed right now due to locking issues.
> > >
> > > Managed to confuse myself. The place which cannot be changed is a different
> > > one, but still for your call site __flush_tlb_all() might not be sufficient.
> > 
> > Since the mappings are changed, I thought a flush_tlb() might be needed.
> > But, (to be honest), I don't completely understand the x86/mm code. So, could you 
> > please elaborate the issue more for my better understanding?
> > 
> > So some questions I have are,
> > 1. What did Peter Z mean here? "How is that not a TLB invalidation bug ?"
> 
> __flush_tlb_all() flushes only the mapping on the current CPU. So in a SMP
> environment it's not sufficient.
> 
> > 2. I assumed kernel_map_pages_in_pgd() to be a good code but you said that 
> > it has some locking issues. So, could you please elaborate more on that.
> 
> I corrected myself. It's the other function which cannot use the proper
> cpa_flush.*() functions.
> 
> > Or, could you please provide me some pointers in the source code that I
> > can take a look at so that I could understand the issue much better.
> 
> I'll have a second look at the whole thing and reply on list.

So actually for the problem at hand __flush_tlb_all() works, because that
is called way before the secondary CPUs are up.

Ditto for kernel_map_pages_in_pgd(). But both functions want to be marked
__init and aside of that they both should contain a warning when they are
called after the secondary CPUs have been brought up.

Thanks,

	tglx
