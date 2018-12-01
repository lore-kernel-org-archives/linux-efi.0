From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] pstore: Convert buf_lock to semaphore
Date: Fri, 30 Nov 2018 18:42:30 -0800
Message-ID: <CAGXu5jKXEEHbxdG2VzYhUWEPEEJYdCLEY1oF+zm8wOUfdS0v+A@mail.gmail.com>
References: <20181130224736.GA38485@beast> <CAK8P3a0YGyKf_0wg_sNhN2z-zVvv1N1_Yc=+2AL=8FZT+CRLxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0YGyKf_0wg_sNhN2z-zVvv1N1_Yc=+2AL=8FZT+CRLxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, linux-efi <linux-efi@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 30, 2018 at 2:52 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Fri, Nov 30, 2018 at 11:48 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > Instead of running with interrupts disabled, use a semaphore. This should
> > make it easier for backends that may need to sleep (e.g. EFI) when
> > performing a write:
> >
> > |BUG: sleeping function called from invalid context at kernel/sched/completion.c:99
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
> > ...
> >
> > Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Fixes: 21b3ddd39fee ("efi: Don't use spinlocks for efi vars")
> > Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Hmm, I've actually been working on a patch set recently to deprecate
> all semaphores from the kernel and replace them with something
> else as much as possible.
>
> Why can't this be a mutex instead?

My understanding is that I can't use a mutex in interrupt context
(Documentation/kernel-hacking/locking.rst) and pstore_dump() needs to
handle being called from anywhere. I'm surprised it's managed to get
away with using a spinlock for this long. :P

-Kees

-- 
Kees Cook
