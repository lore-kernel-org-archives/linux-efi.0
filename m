From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] pstore: Convert buf_lock to semaphore
Date: Tue, 4 Dec 2018 09:23:13 -0800
Message-ID: <CAGXu5jLUMW3cCi1KVdSmOVn3O9BQ6ptYnyJbLHxojgzXd_YUxQ@mail.gmail.com>
References: <20181130224736.GA38485@beast> <20181204154056.iyf333bcxqwk3obe@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
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
> > diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
> > index cfe87b465819..0f7d97917197 100644
> > --- a/drivers/firmware/efi/efi-pstore.c
> > +++ b/drivers/firmware/efi/efi-pstore.c
> > @@ -259,8 +259,7 @@ static int efi_pstore_write(struct pstore_record *record)
> >               efi_name[i] = name[i];
> >
> >       ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
> > -                           !pstore_cannot_block_path(record->reason),
> > -                           record->size, record->psi->buf);
> > +                           preemptible(), record->size, record->psi->buf);
>
> Well. Better I think.
> might_sleep() / preempt_count_equals() checks for preemptible() + rcu_preempt_depth().
> kmsg_dump() starts with rcu_read_lock() which means with this patch applied I
> got:

Okay, so, if kmsg_dump() uses rcu_read_lock(), that means efi-pstore
can _never_ sleep, and it's nothing to do with pstore internals. :( I
guess we just hard-code it, then? And efi-pstore should probably only
attach to pstore if it has a nonblock implementation (and warn if one
isn't available).

-Kees

-- 
Kees Cook
