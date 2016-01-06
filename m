From: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: implement interruptible runtime services
Date: Wed, 6 Jan 2016 16:57:41 +0100
Message-ID: <CAD_mUW3gLnCV6NW0V-HPNUoMd9dS0wQnecXotpS4Vvij9ZrObg@mail.gmail.com>
References: <1450434591-31104-1-git-send-email-sylvain.chouleur@gmail.com>
 <1450434591-31104-2-git-send-email-sylvain.chouleur@gmail.com> <20160106125846.GC2671@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106125846.GC2671-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

2016-01-06 13:58 GMT+01:00 Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>:
> On Fri, 18 Dec, at 11:29:51AM, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> This patch adds an implementation of EFI runtime services wappers which
>> allow interrupts and preemption during execution of BIOS code.
>>
>> It's needed by Broxton platform which requires the OS to do the write
>> of the non volatile variables. To do that, the OS will receive an
>> interrupt coming from the firmware to notify that it must write the
>> data.
>>
>> BIOS code must be executed using a specific PGD. This is currently
>> done by efi_call() which force value of CR3 before calling BIOS and
>> restore previous value after.
>>
>> We use a dedicated kthread which will execute all interruptible runtime
>> services. This efi_kthread is special because it has it's own mm_struct
>> whereas kthread should not have one. This mm_struct contains the EFI PGD
>> so the scheduler will load it before running any BIOS code.
>>
>> Obviously, an interruptible runtime service must never be called from an
>> interrupt context. EFI pstore is the only use case here, that's why we
>> require it to be disabled when activating interruptible runtime services.
>>
>> Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>  arch/x86/Kconfig                          |  14 +++
>>  arch/x86/include/asm/efi.h                |   1 +
>>  arch/x86/platform/efi/Makefile            |   1 +
>>  arch/x86/platform/efi/efi_32.c            |   5 +
>>  arch/x86/platform/efi/efi_64.c            |   5 +
>>  arch/x86/platform/efi/efi_interruptible.c | 191 ++++++++++++++++++++++++++++++
>>  6 files changed, 217 insertions(+)
>>  create mode 100644 arch/x86/platform/efi/efi_interruptible.c
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index db3622f22b61..3ddd5a9cab30 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1720,6 +1720,20 @@ config EFI_MIXED
>>
>>          If unsure, say N.
>>
>> +if X86_64
>> +config EFI_INTERRUPTIBLE
>> +     bool "Interruptible Efi Runtime Services"
>> +     depends on EFI && !EFI_VARS_PSTORE
>> +     default n
>> +     help
>> +          This is an interruptible implementation of efi runtime
>> +       services wrappers. If you say Y, BIOS code could be
>> +       interrupted and preempted as a standard process. Enable this
>> +       only if you are sure that your BIOS will support
>> +       interruptible efi calls
>> +       In doubt, say "N".
>> +endif
>> +
>
> These words should be a little more assertive. Almost everyone is
> going to want to turn this feature off.
>
>> +static efi_status_t
>> +non_blocking_not_allowed(__attribute__((unused)) efi_char16_t *name,
>> +                      __attribute__((unused)) efi_guid_t *vendor,
>> +                      __attribute__((unused)) u32 attr,
>> +                      __attribute__((unused)) unsigned long data_size,
>> +                      __attribute__((unused)) void *data)
>> +{
>> +     pr_err("efi_interruptible: non bloking operation is not allowed\n");
>> +     return EFI_UNSUPPORTED;
>> +}
>
> Typo, s/bloking/blocking/
>
>> +static int efi_interruptible_panic_notifier_call(
>> +     struct notifier_block *notifier,
>> +     unsigned long what, void *data)
>> +{
>> +     static struct efivars generic_efivars;
>> +     static struct efivar_operations generic_ops;
>> +
>> +     generic_ops.get_variable = efi.get_variable;
>> +     generic_ops.set_variable = efi.set_variable;
>> +     generic_ops.get_next_variable = efi.get_next_variable;
>> +     generic_ops.query_variable_store = efi_query_variable_store;
>> +
>> +     efivars_register(&generic_efivars, &generic_ops, efivars_kobject());
>> +
>> +     return NOTIFY_DONE;
>> +}
>> +
>> +static struct notifier_block panic_nb = {
>> +     .notifier_call = efi_interruptible_panic_notifier_call,
>> +     .priority = 100,
>> +};
>> +
>
> What's the purpose of this? The only reason you'd want to do this that
> I can think of is because you'd want efi-pstore to run and attempt to
> save some crash data for you. But you can't build with efi-pstore
> enable and CONFIG_EFI_INTERRUPTIBLE.
>
> I'd be tempted to just delete this notifier code.

This is indeed to be able to try write some crash data when we
are in a panic context.  In fact with this restoration of legacy
efi handlers on a panic we should be able to have pstore working
with CONFIG_EFI_INTERRUPTIBLE.

I say should because there is still issues with BIOS to have the
panic flow working.

>
>> +static struct task_struct *efi_kworker_task;
>> +static struct efivar_operations interruptible_ops;
>> +static __init int efi_interruptible_init(void)
>> +{
>> +     int ret;
>> +
>> +     efi_kworker_task = kthread_create(kthread_worker_fn, &efi_kworker,
>> +                                       "efi_kthread");
>> +     if (IS_ERR(efi_kworker_task)) {
>> +             pr_err("efi_interruptible: Failed to create kthread\n");
>> +             ret = PTR_ERR(efi_kworker_task);
>> +             efi_kworker_task = NULL;
>> +             return ret;
>> +     }
>> +
>> +     efi_kworker_task->mm = mm_alloc();
>> +     efi_kworker_task->active_mm = efi_kworker_task->mm;
>> +     efi_kworker_task->mm->pgd = efi_get_pgd();
>> +     wake_up_process(efi_kworker_task);
>> +
>> +     atomic_notifier_chain_register(&panic_notifier_list, &panic_nb);
>> +
>> +     interruptible_ops.get_variable = get_variable_interruptible;
>> +     interruptible_ops.set_variable = set_variable_interruptible;
>> +     interruptible_ops.set_variable_nonblocking = non_blocking_not_allowed;
>> +     interruptible_ops.get_next_variable = get_next_variable_interruptible;
>> +     interruptible_ops.query_variable_store = efi_query_variable_store;
>> +     return efivars_register(&interruptible_efivars, &interruptible_ops,
>> +                             efivars_kobject());
>> +}
>> +
>
> Is there some way we can match DMI/PCI identifiers for Broxton so that
> we don't start seeing people accidentally running with preemptible EFI
> services on non-BXT hardware?

I don't see how since this depends on a storage strategy more
than the SoC itself, it can be used on future platforms or we can
also get rid of it on BXT if an other storage is used for efi
variables.
Can't the KConfig protection be enough?

-- 
Sylvain
