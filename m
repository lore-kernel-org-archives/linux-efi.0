From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Wed, 23 Aug 2017 15:52:22 -0700
Message-ID: <1503528742.30475.17.camel@intel.com>
References: <20170816095338.GB17270@leverpostej>
         <20170816100709.GG12845@arm.com> <20170816110321.GC17270@leverpostej>
         <20170816125715.GB3384@codeblueprint.co.uk>
         <CALCETrVSHuz=hcAgGxYHBmpiNcP4ECrJh885cR4X17QsJVj8+w@mail.gmail.com>
         <20170815223541.GA25778@remoulade> <20170817103514.GC27872@arm.com>
         <CALCETrVhLmntPArQiuOcQeNf9Y2kDxa+mUY=v1P8rVOkeCZn4Q@mail.gmail.com>
         <20170821103359.jt2xf2cx5wxjldau@hirez.programming.kicks-ass.net>
         <E5C753C8-1B92-4B4F-B95D-32DCC5C0AF5F@amacapital.net>
         <20170821140813.idloyrk4lowann3j@hirez.programming.kicks-ass.net>
         <6E0248C9-19AB-474E-A901-2A0422337DD0@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6E0248C9-19AB-474E-A901-2A0422337DD0-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Shankar, Ravi V" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2017-08-21 at 08:23 -0700, Andy Lutomirski wrote:
> 
> > On Aug 21, 2017, at 7:08 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > 
> >> On Mon, Aug 21, 2017 at 06:56:01AM -0700, Andy Lutomirski wrote:
> >> 
> >> 
> >>> On Aug 21, 2017, at 3:33 AM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > 
> >>>> 
> >>>> Using a kernel thread solves the problem for real.  Anything that
> >>>> blindly accesses user memory in kernel thread context is terminally
> >>>> broken no matter what.
> >>> 
> >>> So perf-callchain doesn't do it 'blindly', it wants either:
> >>> 
> >>> - user_mode(regs) true, or
> >>> - task_pt_regs() set.
> >>> 
> >>> However I'm thinking that if the kernel thread has ->mm == &efi_mm, the
> >>> EFI code running could very well have user_mode(regs) being true.
> >>> 
> >>> intel_pmu_pebs_fixup() OTOH 'blindly' assumes that the LBR addresses are
> >>> accessible. It bails on error though. So while its careful, it does
> >>> attempt to access the 'user' mapping directly. Which should also trigger
> >>> with the EFI code.
> >>> 
> >>> And I'm not seeing anything particularly broken with either. The PEBS
> >>> fixup relies on the CPU having just executed the code, and if it could
> >>> fetch and execute the code, why shouldn't it be able to fetch and read?
> >> 
> >> There are two ways this could be a problem.  One is that u privileged
> >> user apps shouldn't be able to read from EFI memory.
> > 
> > Ah, but only root can create per-cpu events or attach events to kernel
> > threads (with sensible paranoia levels).
> 
> But this may not need to be percpu.  If a non root user can trigger, say, an EFI variable read in their own thread context, boom.
> 
+ Tony

Hi Andi,

I am trying to reproduce the issue that we are discussing and hence
tried an experiment like this:
A user process continuously reads efi variable by
"cat /sys/firmware/efi/efivars/Boot0000-8be4df61-93ca-11d2-aa0d-00e098032b8c" for specified time (Eg: 100 seconds) and simultaneously I ran "perf top" as root (which I suppose should trigger NMI's). I see that everything is fine, no lockups, no kernel crash, no warnings/errors in dmesg.

I see that perf top reports 50% of time is spent in efi function
(probably efi_get_variable()).
Overhead	Shared Object	Symbol
50%		[unknown]	[k] 0xfffffffeea967416

50% is max, on avg it's 35%.

I have tested this on two kernels v4.12 and v3.19. My machine has 8
cores and to stress test, I further offlined all cpus except cpu0.

Could you please let me know a way to reproduce the issue that we are
discussing here.
I think the issue we are concerned here is, when kernel is in efi
context and an NMI happens and if the NMI handler tries to access user
space, boom! we don't have user space in efi context. Am I right in
understanding the issue or is it something else?

Regards,
Sai
