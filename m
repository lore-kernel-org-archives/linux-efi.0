From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] x86/efi: Correct ident mapping of efi old_map when
 kalsr enabled
Date: Fri, 5 May 2017 21:42:14 +0100
Message-ID: <20170505204214.GB5225@codeblueprint.co.uk>
References: <1493294823-9315-1-git-send-email-bhe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493294823-9315-1-git-send-email-bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Including the folks from SGI since this was hit on a UV system)

On Thu, 27 Apr, at 08:07:03PM, Baoquan He wrote:
> For EFI with old_map enabled, Kernel will panic when kaslr is enabled.
> 
> The root cause is the ident mapping is not built correctly in this case.
> 
> For nokaslr kernel, PAGE_OFFSET is 0xffff880000000000 which is PGDIR_SIZE
> aligned. We can borrow the pud table from direct mapping safely. Given a
> physical address X, we have pud_index(X) == pud_index(__va(X)). However,
> for kaslr kernel, PAGE_OFFSET is PUD_SIZE aligned. For a given physical
> address X, pud_index(X) != pud_index(__va(X)). We can't only copy pgd entry
> from direct mapping to build ident mapping, instead need copy pud entry
> one by one from direct mapping.
> 
> So fix it in this patch.
> 
> The panic message is like below, an emty PUD or a wrong PUD.
> 
> [    0.233007] BUG: unable to handle kernel paging request at 000000007febd57e
> [    0.233899] IP: 0x7febd57e
> [    0.234000] PGD 1025a067
> [    0.234000] PUD 0
> [    0.234000]
> [    0.234000] Oops: 0010 [#1] SMP
> [    0.234000] Modules linked in:
> [    0.234000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0-rc8+ #125
> [    0.234000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
> [    0.234000] task: ffffffffafe104c0 task.stack: ffffffffafe00000
> [    0.234000] RIP: 0010:0x7febd57e
> [    0.234000] RSP: 0000:ffffffffafe03d98 EFLAGS: 00010086
> [    0.234000] RAX: ffff8c9e3fff9540 RBX: 000000007c4b6000 RCX: 0000000000000480
> [    0.234000] RDX: 0000000000000030 RSI: 0000000000000480 RDI: 000000007febd57e
> [    0.234000] RBP: ffffffffafe03e40 R08: 0000000000000001 R09: 000000007c4b6000
> [    0.234000] R10: ffffffffafa71a40 R11: 20786c6c2478303d R12: 0000000000000030
> [    0.234000] R13: 0000000000000246 R14: ffff8c9e3c4198d8 R15: 0000000000000480
> [    0.234000] FS:  0000000000000000(0000) GS:ffff8c9e3fa00000(0000) knlGS:0000000000000000
> [    0.234000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.234000] CR2: 000000007febd57e CR3: 000000000fe09000 CR4: 00000000000406b0
> [    0.234000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.234000] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    0.234000] Call Trace:
> [    0.234000]  ? efi_call+0x58/0x90
> [    0.234000]  ? printk+0x58/0x6f
> [    0.234000]  efi_enter_virtual_mode+0x3c5/0x50d
> [    0.234000]  start_kernel+0x40f/0x4b8
> [    0.234000]  ? set_init_arg+0x55/0x55
> [    0.234000]  ? early_idt_handler_array+0x120/0x120
> [    0.234000]  x86_64_start_reservations+0x24/0x26
> [    0.234000]  x86_64_start_kernel+0x14c/0x16f
> [    0.234000]  start_cpu+0x14/0x14
> [    0.234000] Code:  Bad RIP value.
> [    0.234000] RIP: 0x7febd57e RSP: ffffffffafe03d98
> [    0.234000] CR2: 000000007febd57e
> [    0.234000] ---[ end trace d4ded46ab8ab8ba9 ]---
> [    0.234000] Kernel panic - not syncing: Attempted to kill the idle task!
> [    0.234000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> 
> Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> v1->v2:
>     Change code and add description according to Thomas's suggestion as below:
> 
>     1. Add checking if pud table is allocated successfully. If not just break
>     the for loop.
> 
>     2. Add code comment to explain how the 1:1 mapping is built in efi_call_phys_prolog
> 
>     3. Other minor change
> 
>  arch/x86/platform/efi/efi_64.c | 72 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 64 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 2ee7694..48de7fd 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -71,11 +71,13 @@ static void __init early_code_mapping_set_exec(int executable)
>  
>  pgd_t * __init efi_call_phys_prolog(void)
>  {
> -	unsigned long vaddress;
> +	unsigned long vaddr, left_vaddr;
> +	unsigned int num_entries;
>  	pgd_t *save_pgd;
> -
> -	int pgd;
> +	pud_t *pud, *pud_k;
> +	int pud_idx;
>  	int n_pgds;
> +	int i;
>  
>  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
>  		save_pgd = (pgd_t *)read_cr3();
> @@ -88,10 +90,51 @@ pgd_t * __init efi_call_phys_prolog(void)
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
>  	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
>  
> -	for (pgd = 0; pgd < n_pgds; pgd++) {
> -		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> -		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
> -		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
> +	/*
> +	 * We try to build 1:1 ident mapping for efi old_map usage. However,
> +	 * whether kaslr is enabled or not, PAGE_OFFSET must be PUD_SIZE
> +	 * aligned. Given a physical address X, we can copy its pud entry
> +	 * of __va(X) to fill in its pud entry of 1:1 mapping since both
> +	 * of them relate to the same physical memory position.
> +	 *
> +	 * And copying those pud entries one by one is inefficient. We copy
> +	 * memory. Assume PAGE_OFFSET is not PGDIR_SIZE aligned, say it's
> +	 * 0xffff880080000000, and we have memory bigger than 512G. Then the
> +	 * first 512G will cross two pgd entries. We need copy memory twice.
> +	 * The 1st pud entry will be in the 3rd slot of pud table, so we copy
> +	 * pud[2] to pud[511] of the 1st pud table pointed by the 1st pgd entry
> +	 * firstly, then copy pud[0] to pud[1] of the 2nd pud table pointed by
> +	 * 2nd pgd entry at the second time.
> +	 */
> +	for (i = 0; i < n_pgds; i++) {
> +		save_pgd[i] = *pgd_offset_k(i * PGDIR_SIZE);
> +
> +		vaddr = (unsigned long)__va(i * PGDIR_SIZE);
> +
> +		/*
> +		 * Though it may fail to allocate page in the middle, just
> +		 * leave those allocated pages there since 1:1 mapping has
> +		 * been built. And efi region could be located there, efi_call
> +		 * still can work.
> +		 */
> +		pud = pud_alloc_one(NULL, 0);
> +		if (!pud) {
> +			pr_err("Failed to allocate page for %d-th pud table "
> +				"to build 1:1 mapping!\n", i);
> +			break;
> +		}
> +
> +		pud_idx = pud_index(vaddr);
> +		num_entries = PTRS_PER_PUD - pud_idx;
> +		pud_k = pud_offset(pgd_offset_k(vaddr), vaddr);
> +		memcpy(pud, pud_k, num_entries);
> +		if (pud_idx > 0) {
> +			left_vaddr = vaddr + (num_entries * PUD_SIZE);
> +			pud_k = pud_offset(pgd_offset_k(left_vaddr),
> +					   left_vaddr);
> +			memcpy(pud + num_entries, pud_k, pud_idx);
> +		}
> +		pgd_populate(NULL, pgd_offset_k(i * PGDIR_SIZE), pud);
>  	}
>  out:
>  	__flush_tlb_all();
> @@ -106,6 +149,8 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  	 */
>  	int pgd_idx;
>  	int nr_pgds;
> +	pud_t *pud;
> +	pgd_t *pgd;
>  
>  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
>  		write_cr3((unsigned long)save_pgd);
> @@ -115,8 +160,19 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  
>  	nr_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
>  
> -	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++)
> +	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++) {
> +		pgd = pgd_offset_k(pgd_idx * PGDIR_SIZE);
> +
> +		/*
> +		 * We need check if the pud table was really allocated
> +		 * successfully. Otherwise no need to free.
> +		 * */
> +		if (pgd_val(*pgd) != pgd_val(save_pgd[pgd_idx])) {
> +			pud = (pud_t *)pgd_page_vaddr(*pgd);
> +			pud_free(NULL, pud);
> +		}
>  		set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE), save_pgd[pgd_idx]);
> +	}
>  
>  	kfree(save_pgd);

This seems like a lot of code for a really simple problem. Do other
1:1 users require this change? I'm thinking of the realmode trampoline
code.

If the SGI folks think this looks OK then I'll apply it with Thomas'
ACK.
