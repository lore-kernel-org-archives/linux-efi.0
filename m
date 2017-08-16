From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Wed, 16 Aug 2017 12:03:22 +0100
Message-ID: <20170816110321.GC17270@leverpostej>
References: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1502824706-30762-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com>
 <CAKv+Gu8AySQSXtRWfHA4y5DbH-DQ7jpqkp=tS+snSTar_sKBJw@mail.gmail.com>
 <20170816095338.GB17270@leverpostej>
 <20170816100709.GG12845@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170816100709.GG12845@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Lutomirski <luto@kernel.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Peter Zijlstra <peterz@infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, joeyli <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Michael S. Tsirkin" <mst@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Ravi V. Shankar" <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 16, 2017 at 11:07:10AM +0100, Will Deacon wrote:
> On Wed, Aug 16, 2017 at 10:53:38AM +0100, Mark Rutland wrote:
> > On Wed, Aug 16, 2017 at 10:31:12AM +0100, Ard Biesheuvel wrote:
> > > (+ Mark, Will)
> > > 
> > > On 15 August 2017 at 22:46, Andy Lutomirski <luto@kernel.org> wrote:
> > > > On Tue, Aug 15, 2017 at 12:18 PM, Sai Praneeth Prakhya
> > > > <sai.praneeth.prakhya@intel.com> wrote:
> > > >> +/*
> > > >> + * Makes the calling kernel thread switch to/from efi_mm context
> > > >> + * Can be used from SetVirtualAddressMap() or during efi runtime calls
> > > >> + * (Note: This routine is heavily inspired from use_mm)
> > > >> + */
> > > >> +void efi_switch_mm(struct mm_struct *mm)
> > > >> +{
> > > >> +       struct task_struct *tsk = current;
> > > >> +
> > > >> +       task_lock(tsk);
> > > >> +       efi_scratch.prev_mm = tsk->active_mm;
> > > >> +       if (efi_scratch.prev_mm != mm) {
> > > >> +               mmgrab(mm);
> > > >> +               tsk->active_mm = mm;
> > > >> +       }
> > > >> +       switch_mm(efi_scratch.prev_mm, mm, NULL);
> > > >> +       task_unlock(tsk);
> > > >> +
> > > >> +       if (efi_scratch.prev_mm != mm)
> > > >> +               mmdrop(efi_scratch.prev_mm);
> > > >
> > > > I'm confused.  You're mmdropping an mm that you are still keeping a
> > > > pointer to.  This is also a bit confusing in the case where you do
> > > > efi_switch_mm(efi_scratch.prev_mm).
> > > >
> > > > This whole manipulation seems fairly dangerous to me for another
> > > > reason -- you're taking a user thread (I think) and swapping out its
> > > > mm to something that the user in question should *not* have access to.
> > > > What if a perf interrupt happens while you're in the alternate mm?
> > > > What if you segfault and dump core?  Should we maybe just have a flag
> > > > that says "this cpu is using a funny mm", assert that the flag is
> > > > clear when scheduling, and teach perf, coredumps, etc not to touch
> > > > user memory when the flag is set?
> > > 
> > > It appears we may have introduced this exact issue on arm64 and ARM by
> > > starting to run the UEFI runtime services with interrupts enabled.
> > > (perf does not use NMI on ARM, so the issue did not exist beforehand)
> > > 
> > > Mark, Will, any thoughts?
> > 
> > Yup, I can cause perf to take samples from the EFI FW code, so that's
> > less than ideal.
> 
> But that should only happen if you're profiling EL1, right, which needs
> root privileges? (assuming the skid issue is solved -- not sure what
> happened to those patches after they broke criu).

I *think* that only needs perf_event_paranoid < 1, rather than root.

It's certianly not accessible by default to most users (e.g. my Ubuntu
fs sets this to 2, and IIRC Debian go to a much more stringent
non-upstream paranoid level).
 
> > The "funny mm" flag sounds like a good idea to me, though given recent
> > pain with sampling in the case of skid, I don't know exactly what we
> > should do if/when we take an overflow interrupt while in EFI.
> 
> I don't think special-casing perf interrupts is the right thing to do here.
> If we're concerned about user-accesses being made off the back of interrupts
> taken whilst in EFI, then we should probably either swizzle back in the
> user page table on the IRQ path or postpone handling it until we're done
> with the firmware.

Doing that for every IRQ feels odd, especially as the result would be
sampling something that wasn't executed, potentially repeatedly, giveing
bogus info.

> Having a flag feels a bit weird: would the uaccess routines return
> -EFAULT if it's set?

I'd expect we'd abort at a higher level, not taking any sample. i.e.
we'd have the core overflow handler check in_funny_mm(), and if so, skip
the sample, as with the skid case.

Thanks,
Mark.
