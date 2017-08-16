From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Wed, 16 Aug 2017 10:53:38 +0100
Message-ID: <20170816095338.GB17270@leverpostej>
References: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1502824706-30762-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com>
 <CAKv+Gu8AySQSXtRWfHA4y5DbH-DQ7jpqkp=tS+snSTar_sKBJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8AySQSXtRWfHA4y5DbH-DQ7jpqkp=tS+snSTar_sKBJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Ravi V. Shankar" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 16, 2017 at 10:31:12AM +0100, Ard Biesheuvel wrote:
> (+ Mark, Will)
> 
> On 15 August 2017 at 22:46, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Tue, Aug 15, 2017 at 12:18 PM, Sai Praneeth Prakhya
> > <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >> +/*
> >> + * Makes the calling kernel thread switch to/from efi_mm context
> >> + * Can be used from SetVirtualAddressMap() or during efi runtime calls
> >> + * (Note: This routine is heavily inspired from use_mm)
> >> + */
> >> +void efi_switch_mm(struct mm_struct *mm)
> >> +{
> >> +       struct task_struct *tsk = current;
> >> +
> >> +       task_lock(tsk);
> >> +       efi_scratch.prev_mm = tsk->active_mm;
> >> +       if (efi_scratch.prev_mm != mm) {
> >> +               mmgrab(mm);
> >> +               tsk->active_mm = mm;
> >> +       }
> >> +       switch_mm(efi_scratch.prev_mm, mm, NULL);
> >> +       task_unlock(tsk);
> >> +
> >> +       if (efi_scratch.prev_mm != mm)
> >> +               mmdrop(efi_scratch.prev_mm);
> >
> > I'm confused.  You're mmdropping an mm that you are still keeping a
> > pointer to.  This is also a bit confusing in the case where you do
> > efi_switch_mm(efi_scratch.prev_mm).
> >
> > This whole manipulation seems fairly dangerous to me for another
> > reason -- you're taking a user thread (I think) and swapping out its
> > mm to something that the user in question should *not* have access to.
> > What if a perf interrupt happens while you're in the alternate mm?
> > What if you segfault and dump core?  Should we maybe just have a flag
> > that says "this cpu is using a funny mm", assert that the flag is
> > clear when scheduling, and teach perf, coredumps, etc not to touch
> > user memory when the flag is set?
> 
> It appears we may have introduced this exact issue on arm64 and ARM by
> starting to run the UEFI runtime services with interrupts enabled.
> (perf does not use NMI on ARM, so the issue did not exist beforehand)
> 
> Mark, Will, any thoughts?

Yup, I can cause perf to take samples from the EFI FW code, so that's
less than ideal.

The "funny mm" flag sounds like a good idea to me, though given recent
pain with sampling in the case of skid, I don't know exactly what we
should do if/when we take an overflow interrupt while in EFI.

Mark.
