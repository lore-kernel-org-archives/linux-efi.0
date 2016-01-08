From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: implement interruptible runtime services
Date: Fri, 8 Jan 2016 10:38:37 +0000
Message-ID: <20160108103837.GB2532@codeblueprint.co.uk>
References: <1450434591-31104-1-git-send-email-sylvain.chouleur@gmail.com>
 <1450434591-31104-2-git-send-email-sylvain.chouleur@gmail.com>
 <20160106125846.GC2671@codeblueprint.co.uk>
 <CAD_mUW3gLnCV6NW0V-HPNUoMd9dS0wQnecXotpS4Vvij9ZrObg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAD_mUW3gLnCV6NW0V-HPNUoMd9dS0wQnecXotpS4Vvij9ZrObg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 06 Jan, at 04:57:41PM, Sylvain Chouleur wrote:
> 2016-01-06 13:58 GMT+01:00 Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>:
> > On Fri, 18 Dec, at 11:29:51AM, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >> From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>
> >> +static int efi_interruptible_panic_notifier_call(
> >> +     struct notifier_block *notifier,
> >> +     unsigned long what, void *data)
> >> +{
> >> +     static struct efivars generic_efivars;
> >> +     static struct efivar_operations generic_ops;
> >> +
> >> +     generic_ops.get_variable = efi.get_variable;
> >> +     generic_ops.set_variable = efi.set_variable;
> >> +     generic_ops.get_next_variable = efi.get_next_variable;
> >> +     generic_ops.query_variable_store = efi_query_variable_store;
> >> +
> >> +     efivars_register(&generic_efivars, &generic_ops, efivars_kobject());
> >> +
> >> +     return NOTIFY_DONE;
> >> +}
> >> +
> >> +static struct notifier_block panic_nb = {
> >> +     .notifier_call = efi_interruptible_panic_notifier_call,
> >> +     .priority = 100,
> >> +};
> >> +
> >
> > What's the purpose of this? The only reason you'd want to do this that
> > I can think of is because you'd want efi-pstore to run and attempt to
> > save some crash data for you. But you can't build with efi-pstore
> > enable and CONFIG_EFI_INTERRUPTIBLE.
> >
> > I'd be tempted to just delete this notifier code.
> 
> This is indeed to be able to try write some crash data when we
> are in a panic context.  In fact with this restoration of legacy
> efi handlers on a panic we should be able to have pstore working
> with CONFIG_EFI_INTERRUPTIBLE.
 
This makes the efivar registration more complicated because now it can
fail if someone else is holding efivars_lock. Which is a strange
semantic for a registration function.

> I say should because there is still issues with BIOS to have the
> panic flow working.

How would it work though? You'd need the kernel thread controlling
access to the flash to be run in order for any data to appear in the
EFI variable store. Except you're in the middle of a panic and all
bets are off regarding which tasks are going to be run by the
scheduler.

Until those issues are resolved, please delete the notifier code. But
honestly, I doubt this will ever be useful in practice. Setting up
panic handlers *once* you've crashed is far too late.

> >> +static struct task_struct *efi_kworker_task;
> >> +static struct efivar_operations interruptible_ops;
> >> +static __init int efi_interruptible_init(void)
> >> +{
> >> +     int ret;
> >> +
> >> +     efi_kworker_task = kthread_create(kthread_worker_fn, &efi_kworker,
> >> +                                       "efi_kthread");
> >> +     if (IS_ERR(efi_kworker_task)) {
> >> +             pr_err("efi_interruptible: Failed to create kthread\n");
> >> +             ret = PTR_ERR(efi_kworker_task);
> >> +             efi_kworker_task = NULL;
> >> +             return ret;
> >> +     }
> >> +
> >> +     efi_kworker_task->mm = mm_alloc();
> >> +     efi_kworker_task->active_mm = efi_kworker_task->mm;
> >> +     efi_kworker_task->mm->pgd = efi_get_pgd();
> >> +     wake_up_process(efi_kworker_task);
> >> +
> >> +     atomic_notifier_chain_register(&panic_notifier_list, &panic_nb);
> >> +
> >> +     interruptible_ops.get_variable = get_variable_interruptible;
> >> +     interruptible_ops.set_variable = set_variable_interruptible;
> >> +     interruptible_ops.set_variable_nonblocking = non_blocking_not_allowed;
> >> +     interruptible_ops.get_next_variable = get_next_variable_interruptible;
> >> +     interruptible_ops.query_variable_store = efi_query_variable_store;
> >> +     return efivars_register(&interruptible_efivars, &interruptible_ops,
> >> +                             efivars_kobject());
> >> +}
> >> +
> >
> > Is there some way we can match DMI/PCI identifiers for Broxton so that
> > we don't start seeing people accidentally running with preemptible EFI
> > services on non-BXT hardware?
> 
> I don't see how since this depends on a storage strategy more
> than the SoC itself, it can be used on future platforms or we can
> also get rid of it on BXT if an other storage is used for efi
> variables.
> Can't the KConfig protection be enough?

Kconfig is a last resort because it's a build-time decision and
greatly limits the flexibility of the kernel. It becomes no longer
possible to run a single kernel image with various CONFIG_* enabled on
x86 hardware - you now need a special EFI_INTERRUPTIBLE build.

Which apart from being a major headache for distributions in general
is generally frowned upon for the x86 architecture.

If there's any way at all of making this a runtime decision that would
be much better.
