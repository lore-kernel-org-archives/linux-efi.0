From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 3/3] efi: implement interruptible runtime services
Date: Thu, 11 Feb 2016 14:19:37 +0000
Message-ID: <20160211141937.GD4134@codeblueprint.co.uk>
References: <1452119637-10958-1-git-send-email-sylvain.chouleur@gmail.com>
 <1452702762-27216-1-git-send-email-sylvain.chouleur@gmail.com>
 <1452702762-27216-4-git-send-email-sylvain.chouleur@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452702762-27216-4-git-send-email-sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Jan, at 05:32:42PM, Sylvain Chouleur wrote:
> From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This patch adds an implementation of EFI runtime services wappers which
> allow interrupts and preemption during execution of BIOS code.
> 
> It's needed by Broxton platform which requires the OS to do the write
> of the non volatile variables. To do that, the OS will receive an
> interrupt coming from the firmware to notify that it must write the
> data.
> 
> BIOS code must be executed using a specific PGD. This is currently
> done by efi_call() which force value of CR3 before calling BIOS and
> restore previous value after.
> 
> We use a dedicated kthread which will execute all interruptible runtime
> services. This efi_kthread is special because it has it's own mm_struct
> whereas kthread should not have one. This mm_struct contains the EFI PGD
> so the scheduler will load it before running any BIOS code.
> 
> Obviously, an interruptible runtime service must never be called from an
> interrupt context. EFI pstore is the only use case here, that's why we
> require it to be disabled when activating interruptible runtime services.
> 
> Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/Kconfig                          |  17 +++
>  arch/x86/include/asm/efi.h                |   1 +
>  arch/x86/platform/efi/Makefile            |   1 +
>  arch/x86/platform/efi/efi_32.c            |   5 +
>  arch/x86/platform/efi/efi_64.c            |   5 +
>  arch/x86/platform/efi/efi_interruptible.c | 189 ++++++++++++++++++++++++++++++
>  6 files changed, 218 insertions(+)
>  create mode 100644 arch/x86/platform/efi/efi_interruptible.c

Last time Peter and I talked about this patch (sometime last year), he
said he had a different approach in mind.

Peter, do you have any comments on this patch?

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index db3622f22b61..37301516f4e6 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1720,6 +1720,23 @@ config EFI_MIXED
>  
>  	   If unsure, say N.
>  
> +if X86_64
> +config EFI_INTERRUPTIBLE
> +	bool "Interruptible Efi Runtime Services"
> +	depends on EFI && !EFI_VARS_PSTORE
> +	default n
> +	---help---
> +	  Only use this if you really know what you are doing, you
> +	  possibly risk to break your BIOS.
> +
> +	  This is an interruptible implementation of efi runtime
> +	  services wrappers. If you say Y, BIOS code could be
> +	  interrupted and preempted as a standard process. Enable this
> +	  only if you are sure that your BIOS will support
> +	  interruptible efi calls
> +	  In doubt, say "N".
> +endif
> +
>  config SECCOMP
>  	def_bool y
>  	prompt "Enable seccomp to safely compute untrusted bytecode"
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 8fd9e637629a..5b94d9dd9409 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -137,6 +137,7 @@ extern void __init efi_map_region(efi_memory_desc_t *md);
>  extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
>  extern void efi_sync_low_kernel_mappings(void);
>  extern int __init efi_alloc_page_tables(void);
> +extern pgd_t *efi_get_pgd(void);
>  extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
>  extern void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
>  extern void __init old_map_region(efi_memory_desc_t *md);
> diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
> index 2846aaab5103..ff57d3840842 100644
> --- a/arch/x86/platform/efi/Makefile
> +++ b/arch/x86/platform/efi/Makefile
> @@ -2,3 +2,4 @@ obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o efi_stub_$(BITS).o
>  obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
>  obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
>  obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
> +obj-$(CONFIG_EFI_INTERRUPTIBLE)	+= efi_interruptible.o
> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
> index 58d669bc8250..f2403e16a8bb 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -61,6 +61,11 @@ void __init efi_map_region(efi_memory_desc_t *md)
>  void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
>  void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
>  
> +pgd_t *efi_get_pgd(void)
> +{
> +	return initial_page_table;
> +}
> +
>  pgd_t * __init efi_call_phys_prolog(void)
>  {
>  	struct desc_ptr gdt_descr;

Shouldn't be necessary. You can't build this for 32-bit because of the
Kconfig magic.

> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index b492521503fe..7886c7527cdf 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -212,6 +212,11 @@ void efi_sync_low_kernel_mappings(void)
>  	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
>  }
>  
> +pgd_t *efi_get_pgd(void)
> +{
> +	return __va(efi_scratch.efi_pgt);
> +}
> +

You could make this easier and just return 'efi_pgd', since we now
have entirely separate EFI page tables.

> +static struct efivars interruptible_efivars;
> +
> +static int efi_interruptible_panic_notifier_call(
> +	struct notifier_block *notifier,
> +	unsigned long what, void *data)
> +{
> +	in_panic = true;
> +	return NOTIFY_DONE;
> +}

Please make the panic notifier changes a separate patch.

> +static struct notifier_block panic_nb = {
> +	.notifier_call = efi_interruptible_panic_notifier_call,
> +	.priority = 100,
> +};
> +
> +static struct task_struct *efi_kworker_task;
> +static struct efivar_operations interruptible_ops;
> +static __init int efi_interruptible_init(void)
> +{
> +	int ret;
> +
> +	efi_kworker_task = kthread_create(kthread_worker_fn, &efi_kworker,
> +					  "efi_kthread");
> +	if (IS_ERR(efi_kworker_task)) {
> +		pr_err("efi_interruptible: Failed to create kthread\n");
> +		ret = PTR_ERR(efi_kworker_task);
> +		efi_kworker_task = NULL;
> +		return ret;
> +	}
> +
> +	efi_kworker_task->mm = mm_alloc();
> +	efi_kworker_task->active_mm = efi_kworker_task->mm;
> +	efi_kworker_task->mm->pgd = efi_get_pgd();
> +	wake_up_process(efi_kworker_task);

Did you have any luck binding this driver to the other
Broxton-specific drivers?

Additionally, you're going to want to make sure that
efi_enabled(EFI_OLD_MEMMAP) is false in efi_interruptible_init(),
otherwise you can't use the new EFI page table scheme, e.g. if someone
boots with efi=old_map.
