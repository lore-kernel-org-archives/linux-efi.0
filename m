From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Mon, 21 Aug 2017 12:33:59 +0200
Message-ID: <20170821103359.jt2xf2cx5wxjldau@hirez.programming.kicks-ass.net>
References: <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com>
 <CAKv+Gu8AySQSXtRWfHA4y5DbH-DQ7jpqkp=tS+snSTar_sKBJw@mail.gmail.com>
 <20170816095338.GB17270@leverpostej>
 <20170816100709.GG12845@arm.com>
 <20170816110321.GC17270@leverpostej>
 <20170816125715.GB3384@codeblueprint.co.uk>
 <CALCETrVSHuz=hcAgGxYHBmpiNcP4ECrJh885cR4X17QsJVj8+w@mail.gmail.com>
 <20170815223541.GA25778@remoulade>
 <20170817103514.GC27872@arm.com>
 <CALCETrVhLmntPArQiuOcQeNf9Y2kDxa+mUY=v1P8rVOkeCZn4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVhLmntPArQiuOcQeNf9Y2kDxa+mUY=v1P8rVOkeCZn4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ravi V. Shankar" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 17, 2017 at 08:52:38AM -0700, Andy Lutomirski wrote:
> On Thu, Aug 17, 2017 at 3:35 AM, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:

> > I'm still concerned that we're treating perf specially here -- are we
> > absolutely sure that nobody else is going to attempt user accesses off the
> > back of an interrupt?
> 
> Reasonably sure?  If nothing else, an interrupt taken while mmap_sem()
> is held for write that tries to access user memory is asking for
> serious trouble.  There are still a few callers of pagefault_disable()
> and copy...inatomic(), though.

I'm not immediately seeing how holding mmap_sem for writing is a
problem.

> > If not, then I'd much prefer a solution that catches
> > anybody doing that with the EFI page table installed, rather than trying
> > to play whack-a-mole like this.
> 
> Using a kernel thread solves the problem for real.  Anything that
> blindly accesses user memory in kernel thread context is terminally
> broken no matter what.

So perf-callchain doesn't do it 'blindly', it wants either:

 - user_mode(regs) true, or
 - task_pt_regs() set.

However I'm thinking that if the kernel thread has ->mm == &efi_mm, the
EFI code running could very well have user_mode(regs) being true.

intel_pmu_pebs_fixup() OTOH 'blindly' assumes that the LBR addresses are
accessible. It bails on error though. So while its careful, it does
attempt to access the 'user' mapping directly. Which should also trigger
with the EFI code.

And I'm not seeing anything particularly broken with either. The PEBS
fixup relies on the CPU having just executed the code, and if it could
fetch and execute the code, why shouldn't it be able to fetch and read?
(eXecute implies Read assumed). And like said, it if triggers a fault,
it bails, no worries.

It really doesn't care if the task is a kernel thread or not. Same for
the unwinder, if we get an interrupt register set that points into
'userspace' we try and unwind it.
