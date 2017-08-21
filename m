From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Mon, 21 Aug 2017 16:08:13 +0200
Message-ID: <20170821140813.idloyrk4lowann3j@hirez.programming.kicks-ass.net>
References: <20170816095338.GB17270@leverpostej>
 <20170816100709.GG12845@arm.com>
 <20170816110321.GC17270@leverpostej>
 <20170816125715.GB3384@codeblueprint.co.uk>
 <CALCETrVSHuz=hcAgGxYHBmpiNcP4ECrJh885cR4X17QsJVj8+w@mail.gmail.com>
 <20170815223541.GA25778@remoulade>
 <20170817103514.GC27872@arm.com>
 <CALCETrVhLmntPArQiuOcQeNf9Y2kDxa+mUY=v1P8rVOkeCZn4Q@mail.gmail.com>
 <20170821103359.jt2xf2cx5wxjldau@hirez.programming.kicks-ass.net>
 <E5C753C8-1B92-4B4F-B95D-32DCC5C0AF5F@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E5C753C8-1B92-4B4F-B95D-32DCC5C0AF5F@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, joeyli <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Michael S. Tsirkin" <mst@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Ravi V. Shankar" <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 21, 2017 at 06:56:01AM -0700, Andy Lutomirski wrote:
> 
> 
> > On Aug 21, 2017, at 3:33 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> >> 
> >> Using a kernel thread solves the problem for real.  Anything that
> >> blindly accesses user memory in kernel thread context is terminally
> >> broken no matter what.
> > 
> > So perf-callchain doesn't do it 'blindly', it wants either:
> > 
> > - user_mode(regs) true, or
> > - task_pt_regs() set.
> > 
> > However I'm thinking that if the kernel thread has ->mm == &efi_mm, the
> > EFI code running could very well have user_mode(regs) being true.
> > 
> > intel_pmu_pebs_fixup() OTOH 'blindly' assumes that the LBR addresses are
> > accessible. It bails on error though. So while its careful, it does
> > attempt to access the 'user' mapping directly. Which should also trigger
> > with the EFI code.
> > 
> > And I'm not seeing anything particularly broken with either. The PEBS
> > fixup relies on the CPU having just executed the code, and if it could
> > fetch and execute the code, why shouldn't it be able to fetch and read?
> 
> There are two ways this could be a problem.  One is that u privileged
> user apps shouldn't be able to read from EFI memory.

Ah, but only root can create per-cpu events or attach events to kernel
threads (with sensible paranoia levels).

> The other is that, if EFI were to have IO memory mapped at a "user"
> address, perf could end up reading it.

Ah, but in neither mode does perf assume much, the LBR follows branches
the CPU took and thus we _know_ there was code there, not MMIO. And the
stack unwind simply follows the stack up, although I suppose it could be
'tricked' into probing MMIO. We can certainly add an "->mm !=
->active_mm" escape clause to the unwind code.

Although I don't see how we're currently avoiding the same problem with
existing userspace unwinds, userspace can equally have MMIO mapped.

But neither will use pre-existing user addresses in the efi_mm I think.
