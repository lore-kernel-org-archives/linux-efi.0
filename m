From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] pstore: Convert buf_lock to semaphore
Date: Tue, 4 Dec 2018 08:17:02 -0800
Message-ID: <CAGXu5jJ2zTsouLorcBFjamaxXpdX4CUAeXD6-ZiEM9jd+=WDDA@mail.gmail.com>
References: <20181130224736.GA38485@beast> <20181204154056.iyf333bcxqwk3obe@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181204154056.iyf333bcxqwk3obe@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, linux-efi <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 4, 2018 at 7:41 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2018-11-30 14:47:36 [-0800], Kees Cook wrote:
> > diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/e=
fi-pstore.c
> > index cfe87b465819..0f7d97917197 100644
> > --- a/drivers/firmware/efi/efi-pstore.c
> > +++ b/drivers/firmware/efi/efi-pstore.c
> > @@ -259,8 +259,7 @@ static int efi_pstore_write(struct pstore_record *r=
ecord)
> >               efi_name[i] =3D name[i];
> >
> >       ret =3D efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIB=
UTES,
> > -                           !pstore_cannot_block_path(record->reason),
> > -                           record->size, record->psi->buf);
> > +                           preemptible(), record->size, record->psi->b=
uf);
>
> Well. Better I think.
> might_sleep() / preempt_count_equals() checks for preemptible() + rcu_pre=
empt_depth().
> kmsg_dump() starts with rcu_read_lock() which means with this patch appli=
ed I
> got:
>
> | BUG: sleeping function called from invalid context at kernel/sched/comp=
letion.c:99
> | in_atomic(): 0, irqs_disabled(): 0, pid: 2286, name: sig-xstate-bum PC:=
 0 RCU: 1
> | Preemption disabled at:
> | [<ffffffff9b959085>] __queue_work+0x95/0x440
> | CPU: 30 PID: 2286 Comm: sig-xstate-bum Tainted: G      D           4.20=
.0-rc3+ #90
> | Call Trace:
> |  dump_stack+0x4f/0x6a
> |  ___might_sleep.cold.91+0xef/0x100
> |  __might_sleep+0x50/0x90
> |  wait_for_completion+0x32/0x130
> |  virt_efi_query_variable_info+0x14e/0x160
> |  efi_query_variable_store+0x51/0x1a0
> |  efivar_entry_set_safe+0xa3/0x1b0
> |  efi_pstore_write+0x110/0x140
> |  pstore_dump+0x114/0x320
> |  kmsg_dump+0xa4/0xd0
> |  oops_exit+0x7f/0x90
> |  oops_end+0x67/0xd0
> |  die+0x41/0x4a
> |  do_general_protection+0xc1/0x150
> |  general_protection+0x1e/0x30
> | RIP: 0010:__fpu__restore_sig+0x1c1/0x540
>
> just in case you wonder why both counter are zero and it still creates
> this backtrace.

Oh, hmm. That didn't show up in my testing. Any thoughts on a solution?

>
> >       if (record->reason =3D=3D KMSG_DUMP_OOPS)
> >               efivar_run_worker();
> > diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> > index 2387cb74f729..afdfd3687f94 100644
> > --- a/fs/pstore/platform.c
> > +++ b/fs/pstore/platform.c
> > @@ -400,23 +401,20 @@ static void pstore_dump(struct kmsg_dumper *dumpe=
r,
> >       unsigned long   total =3D 0;
> >       const char      *why;
> >       unsigned int    part =3D 1;
> > -     unsigned long   flags =3D 0;
> > -     int             is_locked;
> >       int             ret;
> >
> >       why =3D get_reason_str(reason);
> >
> > -     if (pstore_cannot_block_path(reason)) {
> > -             is_locked =3D spin_trylock_irqsave(&psinfo->buf_lock, fla=
gs);
> > -             if (!is_locked) {
> > -                     pr_err("pstore dump routine blocked in %s path, m=
ay corrupt error record\n"
> > -                                    , in_nmi() ? "NMI" : why);
> > +     if (down_trylock(&psinfo->buf_lock)) {
> > +             /* Failed to acquire lock: give up if we cannot wait. */
> > +             if (pstore_cannot_wait(reason)) {
> > +                     pr_err("dump skipped in %s path: may corrupt erro=
r record\n",
> > +                             in_nmi() ? "NMI" : why);
> >                       return;
> >               }
> > -     } else {
> > -             spin_lock_irqsave(&psinfo->buf_lock, flags);
> > -             is_locked =3D 1;
> > +             down_interruptible(&psinfo->buf_lock);
>
>  In function =E2=80=98pstore_dump=E2=80=99:
> fs/pstore/platform.c:393:3: warning: ignoring return value of =E2=80=98do=
wn_interruptible=E2=80=99, declared with attribute warn_unused_result [-Wun=
used-result]
>    down_interruptible(&psinfo->buf_lock);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>

Thanks, yes. I've fixed this in the version in -next.

-Kees

--=20
Kees Cook
