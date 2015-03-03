From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: Disable interrupts around EFI calls, not in the
 epilog/prolog calls
Date: Tue, 3 Mar 2015 07:34:33 +0100
Message-ID: <20150303063433.GA30468@gmail.com>
References: <20150303025804.GA24587@kt-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150303025804.GA24587@kt-Inspiron-3542>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tapasweni Pathak <tapaswenipathak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Tapasweni Pathak <tapaswenipathak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Disabling interrupts around kmalloc() is less than ideal. Move it
> after the kmalloc().
> 
> Found using Coccinelle.
> 
> Signed-off-by: Tapasweni Pathak <tapaswenipathak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Suggested-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi_64.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 17e80d8..5d6af59 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -88,10 +88,10 @@ void __init efi_call_phys_prolog(void)
>  		return;
> 
>  	early_code_mapping_set_exec(1);
> -	local_irq_save(efi_flags);
> 
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
>  	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
> +	local_irq_save(efi_flags);
> 
>  	for (pgd = 0; pgd < n_pgds; pgd++) {
>  		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);

So why are interrupts disabled around page table operations to begin 
with? It's not like any of this can execute on two CPUs at once, nor 
can this be executed from interrupt context.

So, shouldn't we only protect the EFI calls themselves? If we did that 
we could save the efi_flags global variable ugliness as well.

I.e. something like the attached patch. (not tested and all that)

Thanks,

	Ingo

===================>
>From 160eef628f9e803ba62707ec7f610ea9f0f13984 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 3 Mar 2015 07:31:56 +0100
Subject: [PATCH] efi: Disable interrupts around EFI calls, not in the epilog/prolog calls

Tapasweni Pathak reported that we do a kmalloc() in efi_call_phys_prolog()
on x86-64 while having interrupts disabled, which is a big no-no, as
kmalloc() can sleep.

Solve this by removing the irq disabling from the prolog/epilog calls
around EFI calls: it's unnecessary, as in this stage we are single
threaded in the boot thread, and we don't ever execute this from
interrupt contexts.

Reported-by: Tapasweni Pathak <tapaswenipathak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/efi.c    |  7 +++++++
 arch/x86/platform/efi/efi_32.c | 11 +++--------
 arch/x86/platform/efi/efi_64.c |  3 ---
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index dbc8627a5cdf..2490a15d18f1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -85,12 +85,19 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	efi_memory_desc_t *virtual_map)
 {
 	efi_status_t status;
+	unsigned long flags;
 
 	efi_call_phys_prolog();
+
+	/* Disable interrupts around EFI calls: */
+	local_irq_save(flags);
 	status = efi_call_phys(efi_phys.set_virtual_address_map,
 			       memory_map_size, descriptor_size,
 			       descriptor_version, virtual_map);
+	local_irq_restore(flags);
+
 	efi_call_phys_epilog();
+
 	return status;
 }
 
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 40e7cda52936..abecc6e1dc90 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -33,11 +33,10 @@
 
 /*
  * To make EFI call EFI runtime service in physical addressing mode we need
- * prolog/epilog before/after the invocation to disable interrupt, to
- * claim EFI runtime service handler exclusively and to duplicate a memory in
- * low memory space say 0 - 3G.
+ * prolog/epilog before/after the invocation to claim the EFI runtime service
+ * handler exclusively and to duplicate a memory mapping in low memory space,
+ * say 0 - 3G.
  */
-static unsigned long efi_rt_eflags;
 
 void efi_sync_low_kernel_mappings(void) {}
 void __init efi_dump_pagetable(void) {}
@@ -61,8 +60,6 @@ void __init efi_call_phys_prolog(void)
 {
 	struct desc_ptr gdt_descr;
 
-	local_irq_save(efi_rt_eflags);
-
 	load_cr3(initial_page_table);
 	__flush_tlb_all();
 
@@ -81,8 +78,6 @@ void __init efi_call_phys_epilog(void)
 
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
-
-	local_irq_restore(efi_rt_eflags);
 }
 
 void __init efi_runtime_mkexec(void)
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 17e80d829df0..427eb3540e5f 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -42,7 +42,6 @@
 #include <asm/time.h>
 
 static pgd_t *save_pgd __initdata;
-static unsigned long efi_flags __initdata;
 
 /*
  * We allocate runtime services regions bottom-up, starting from -4G, i.e.
@@ -88,7 +87,6 @@ void __init efi_call_phys_prolog(void)
 		return;
 
 	early_code_mapping_set_exec(1);
-	local_irq_save(efi_flags);
 
 	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
 	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
@@ -116,7 +114,6 @@ void __init efi_call_phys_epilog(void)
 		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), save_pgd[pgd]);
 	kfree(save_pgd);
 	__flush_tlb_all();
-	local_irq_restore(efi_flags);
 	early_code_mapping_set_exec(0);
 }
 
