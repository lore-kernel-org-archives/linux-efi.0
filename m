From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 3/3] Update efi_thunk to use efi_call_virt_generic
Date: Thu, 2 Jun 2016 21:19:49 +0100
Message-ID: <20160602201949.GL2658@codeblueprint.co.uk>
References: <1463598701-178201-1-git-send-email-athorlton@sgi.com>
 <1463598701-178201-4-git-send-email-athorlton@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463598701-178201-4-git-send-email-athorlton-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 18 May, at 02:11:41PM, Alex Thorlton wrote:
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index f310f0b..6643f9b 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -68,6 +68,52 @@ struct efi_scratch {
>  	u64	phys_stack;
>  } __packed;
>  
> +#ifdef CONFIG_EFI_MIXED
> +extern efi_status_t efi64_thunk(u32, ...);
> +
> +#define runtime_service32(func)						 \
> +({									 \
> +	u32 table = (u32)(unsigned long)efi.systab;			 \
> +	u32 *rt, *___f;							 \
> +									 \
> +	rt = (u32 *)(table + offsetof(efi_system_table_32_t, runtime));	 \
> +	___f = (u32 *)(*rt + offsetof(efi_runtime_services_32_t, func)); \
> +	*___f;								 \
> +})
> +
> +/*
> + * Switch to the EFI page tables early so that we can access the 1:1
> + * runtime services mappings which are not mapped in any other page
> + * tables. This function must be called before runtime_service32().
> + *
> + * Also, disable interrupts because the IDT points to 64-bit handlers,
> + * which aren't going to function correctly when we switch to 32-bit.
> + */
> +#define arch_efi_call_virt_setup()					\
> +({									\
> +	efi_sync_low_kernel_mappings();					\
> +	local_irq_save(flags);						\
> +									\
> +	efi_scratch.prev_cr3 = read_cr3();				\
> +	write_cr3((unsigned long)efi_scratch.efi_pgt);			\
> +	__flush_tlb_all();						\
> +})
> +
> +#define arch_efi_call_virt(p, f, ...)					\
> +({									\
> +	u32 func = runtime_service32(f);				\
> +	efi64_thunk(func, __VA_ARGS__);					\
> +})
> +

This isn't correct because you're turning the runtime decision of
whether we're executing the thunking code into a build time one.

Users can enable CONFIG_EFI_MIXED in their builds but never actually
run that kernel on a mixed mode machine. One of the original design
intentions behind CONFIG_EFI_MIXED was that you can (and should!) turn
it on because it has no effect unless you run it on a machine with
32-bit EFI.

The switch to the thunk layer is done in efi_thunk_runtime_setup().

As a real world example of this, the openSUSE x86_64 kernel config has
CONFIG_EFI_MIXED enabled out of the box.

The thunk code should be able to reuse the regular x86_64
arch_efi_call_virt_setup() and arch_efi_call_virt_teardown(), since,

  a. We can also disable preemption without issue
  b. We can disable/reenable interrupts around those existing wrappers
  c. The "if (efi_scratch.use_pgd)" check is missing because we
     *always* use the EFI pgtables for mixed mode, it's a requirement

Would something like this work instead? It's not as neat as your
suggestion but it's a damn sight better than what we have today.

---

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6e7242be1c87..b976084e56ef 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -469,18 +469,13 @@ extern efi_status_t efi64_thunk(u32, ...);
 	unsigned long flags;						\
 	u32 func;							\
 									\
-	efi_sync_low_kernel_mappings();					\
 	local_irq_save(flags);						\
-									\
-	efi_scratch.prev_cr3 = read_cr3();				\
-	write_cr3((unsigned long)efi_scratch.efi_pgt);			\
-	__flush_tlb_all();						\
+	arch_efi_call_virt_setup();					\
 									\
 	func = runtime_service32(f);					\
 	__s = efi64_thunk(func, __VA_ARGS__);			\
 									\
-	write_cr3(efi_scratch.prev_cr3);				\
-	__flush_tlb_all();						\
+	arch_efi_call_virt_teardown();					\
 	local_irq_restore(flags);					\
 									\
 	__s;								\
