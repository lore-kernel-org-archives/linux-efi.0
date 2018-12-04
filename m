From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] pstore: Convert buf_lock to semaphore
Date: Mon, 3 Dec 2018 16:28:15 -0800
Message-ID: <CAGXu5jLsHU0sRsnoynt==bZuagvohfAOGUu_i54Jy8BCFTvitQ@mail.gmail.com>
References: <20181130224736.GA38485@beast> <CAK8P3a0YGyKf_0wg_sNhN2z-zVvv1N1_Yc=+2AL=8FZT+CRLxQ@mail.gmail.com>
 <CAGXu5jKXEEHbxdG2VzYhUWEPEEJYdCLEY1oF+zm8wOUfdS0v+A@mail.gmail.com>
 <CAK8P3a3xUMnWrSsW6gNwc5y0z-wR23v8Q6TGH+yNpDJq65FeMw@mail.gmail.com>
 <20181203111826.ri2csbxs33j34dvo@linutronix.de> <CAK8P3a1mAg-XDie7ekN36WQGwVLoPW_nYCkcGmCDMmscCSRFNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1mAg-XDie7ekN36WQGwVLoPW_nYCkcGmCDMmscCSRFNA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, linux-efi <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 3, 2018 at 8:26 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Mon, Dec 3, 2018 at 12:18 PM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> >
> > On 2018-12-01 09:42:38 [+0100], Arnd Bergmann wrote:
> > > You are right that you can't take (or release) a mutex from interrupt
> > > context. However, I don't think converting a spinlock to a semaphore
> > > is going to help here either.
> >
> > you can acquire a semaphore with a try_lock from interrupts context but
> > you can't do that with a mutex. You can also a acquire a semaphore in
> > one context and release in another.
>
> Right, that is the obvious part.
>
> > I haven't looked a general picture yet, will try to do so later today or
> > tomorrow.
>
> To speed this up, the problem I'm referring to is in
> virt_efi_query_variable_info() and efi_queue_work(),
> as in the original BUG_ON() that Kees quoted:
>
> > BUG: sleeping function called from invalid context at kernel/sched/completion.c:99
> > |in_atomic(): 1, irqs_disabled(): 1, pid: 2236, name: sig-xstate-bum
> > |Preemption disabled at:
> > |[<ffffffff99d60512>] pstore_dump+0x72/0x330
> > |CPU: 26 PID: 2236 Comm: sig-xstate-bum Tainted: G      D           4.20.0-rc3 #45
> > |Call Trace:
> > | dump_stack+0x4f/0x6a
> > | ___might_sleep.cold.91+0xd3/0xe4
> > | __might_sleep+0x50/0x90
> > | wait_for_completion+0x32/0x130
> > | virt_efi_query_variable_info+0x14e/0x160
> > | efi_query_variable_store+0x51/0x1a0
> > | efivar_entry_set_safe+0xa3/0x1b0
> > | efi_pstore_write+0x109/0x140
> > | pstore_dump+0x11c/0x330
> > | kmsg_dump+0xa4/0xd0
> > | oops_exit+0x22/0x30
>
> This will no longer happen when pstore is called from process
> context with his patch, but we still get the same thing if we call
> pstore from interrupt context, unless both the down_interruptible
> and wait_for_completion in there are also changed to
> nonblocking calls. However, once they are no longer blocking,
> we don't need the outer lock to be changed from spinlock
> to semaphore any more either.

My proposed patch was trying to do two things:

- have pstore not make things _worse_ (do not hold a spin lock)
- use preemptible() in efi pstore backend to get it right:

        ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
-                             !pstore_cannot_block_path(record->reason),
-                             record->size, record->psi->buf);
+                             preemptible(), record->size, record->psi->buf);

IIUC, that would make efi-vars take the nonblocking path so we don't
trip over the might_sleep().

-Kees

-- 
Kees Cook
