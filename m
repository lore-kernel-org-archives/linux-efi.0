From: Matt Fleming <matt@console-pimps.org>
Subject: Re: EFI mixed mode + perf = rampant triple faults
Date: Wed, 31 Dec 2014 18:37:39 +0000
Message-ID: <20141231183739.GA28946@console-pimps.org>
References: <5491B4A8.905@amacapital.net>
 <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 17 Dec, at 08:54:56AM, Andy Lutomirski wrote:
> [trying again with .org spelled correctly.  also cc: bpetkov]
> 
> On Wed, Dec 17, 2014 at 8:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > I figured I should send this email before I forget about this issue:
> >
> > If you run perf record across any EFI mixed mode call or otherwise
> > receive an NMI or MCE, the machine triple-faults.  The cause is
> > straightforward: there is no valid IDT when we have long mode disabled
> > for the duration of the EFI call.

Right, the lack of IDT is intentional since we disable interrupts while
making the EFI call and so far I have side-stepped (ignored) the NMI/MCE
issue.

Perf is an interesting use case. I've admittedly never used it with EFI
mixed mode, but yes, we should definitely get that working (if NMI/MCE
handling wasn't justification enough).

> > As far as I know, the only way to have continuously functional interrupt
> > handling across a long mode transition is to install an interrupt vector
> > table and hope that CPUs actually do something intelligent when
> > receiving an interrupt with LME=1, LMA=1, and PG=0.  Yuck.
> >
> > Could we get away with issuing 32-bit EFI calls in compat mode, i.e.
> > with a 32-bit CPL0 CS but while still in long mode?  I think that
> > delivery of an IST interrupt (which includes both NMI and MCE) will
> > correctly switch to a fully valid 64-bit state and would correctly
> > switch back when we execute IRET at the end.  (Am I missing some reason
> > that switching bitness without a privilege level change doesn't work
> > well?  I haven't thought of anything, other than the lack of SS/SP controls
> > on intra-ring interrupts, but that shouldn't be an issue here.)
> >
> > As an added benefit, this would considerably simplify the code.

I can't immediately think of a reason that this wouldn't work, but I've
Cc'd more x86 folks for additional insight.

I will schedule some time to look into this issue in the new year.
Thanks Andy.

-- 
Matt Fleming, Intel Open Source Technology Center
