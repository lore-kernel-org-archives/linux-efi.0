From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Tue, 15 Aug 2017 17:23:59 -0700
Message-ID: <1502843039.9150.19.camel@intel.com>
References: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com>
         <1502824706-30762-4-git-send-email-sai.praneeth.prakhya@intel.com>
         <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Ravi V. Shankar" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2017-08-15 at 14:46 -0700, Andy Lutomirski wrote:
> On Tue, Aug 15, 2017 at 12:18 PM, Sai Praneeth Prakhya
> <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > +/*
> > + * Makes the calling kernel thread switch to/from efi_mm context
> > + * Can be used from SetVirtualAddressMap() or during efi runtime calls
> > + * (Note: This routine is heavily inspired from use_mm)
> > + */
> > +void efi_switch_mm(struct mm_struct *mm)
> > +{
> > +       struct task_struct *tsk = current;
> > +
> > +       task_lock(tsk);
> > +       efi_scratch.prev_mm = tsk->active_mm;
> > +       if (efi_scratch.prev_mm != mm) {
> > +               mmgrab(mm);
> > +               tsk->active_mm = mm;
> > +       }
> > +       switch_mm(efi_scratch.prev_mm, mm, NULL);
> > +       task_unlock(tsk);
> > +
> > +       if (efi_scratch.prev_mm != mm)
> > +               mmdrop(efi_scratch.prev_mm);
> 

Thanks for the quick review Andy,

> I'm confused.  You're mmdropping an mm that you are still keeping a
> pointer to.  This is also a bit confusing in the case where you do
> efi_switch_mm(efi_scratch.prev_mm).
> 

This makes sense, I will look into it.

> This whole manipulation seems fairly dangerous to me for another
> reason -- you're taking a user thread (I think) and swapping out its
> mm to something that the user in question should *not* have access to.

We are switching to efi_mm from user mm_struct because
EFI_RUNTIME_SERVICES like efi_set_variable()/efi_get_variable() are
accessible only through efi_pgd. The user thread calls ioctl() which in
turn calls efi_call() and thus efi_switch_mm(). So, I think, the user
still does not have direct access to EFI_RUNTIME_SERVICES memory regions
but accesses them through sys call.

> What if a perf interrupt happens while you're in the alternate mm?

Since we are disabling/enabling interrupts around switching, I think we
are safe. We do these in following functions
phys_efi_set_virtual_address_map()
efi_thunk_set_virtual_address_map()
efi_call_virt_pointer()

> What if you segfault and dump core?

We could seg fault only if firmware touches regions which it shouldn't.
i.e. Firmware touching regions outside EFI_RUNTIME_SERVICES (this is a
UEFI Spec violation). So, in this case of buggy firmware, we panic (this
is an existing problem). We also map EFI_BOOT_TIME_SERVICES into efi_pgd
because we know some buggy firmware touches these regions.

>  Should we maybe just have a flag
> that says "this cpu is using a funny mm", assert that the flag is
> clear when scheduling, and teach perf, coredumps, etc not to touch
> user memory when the flag is set?
> 
> Admittedly, the latter problem may well have existed even before these patches.

Please let me know if you think otherwise.

Matt,
Please feel free to correct my understanding.

Regards,
Sai
