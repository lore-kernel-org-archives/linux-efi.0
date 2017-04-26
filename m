From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Correct ident mapping of efi old_map when
 kalsr enabled
Date: Wed, 26 Apr 2017 18:43:19 +0800
Message-ID: <20170426104319.GC2794@x1>
References: <1493203160-20148-1-git-send-email-bhe@redhat.com>
 <1493203160-20148-2-git-send-email-bhe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493203160-20148-2-git-send-email-bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xlpang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This bug will cause SGI uv 100 boot failure since SGI uv 100 can only
use efi old_map because of hardware. On rhel it failed all SGI uv series
since we haven't back ported fix for SGI uv 200/300.

On 04/26/17 at 06:39pm, Baoquan He wrote:
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
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/x86/platform/efi/efi_64.c | 35 +++++++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 2ee7694..2e7baff 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -71,11 +71,12 @@ static void __init early_code_mapping_set_exec(int executable)
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
>  	int n_pgds;
> +	int i;
>  
>  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
>  		save_pgd = (pgd_t *)read_cr3();
> @@ -88,10 +89,22 @@ pgd_t * __init efi_call_phys_prolog(void)
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
>  	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
>  
> -	for (pgd = 0; pgd < n_pgds; pgd++) {
> -		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> -		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
> -		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
> +	for (i = 0; i < n_pgds; i++) {
> +		save_pgd[i] = *pgd_offset_k(i * PGDIR_SIZE);
> +
> +		vaddr = (unsigned long)__va(i * PGDIR_SIZE);
> +		pud = pud_alloc_one(NULL, 0);
> +
> +		num_entries = PTRS_PER_PUD - pud_index(vaddr);
> +		pud_k = pud_offset(pgd_offset_k(vaddr), vaddr);
> +		memcpy(pud, pud_k, num_entries);
> +		if (pud_index(vaddr) > 0) {
> +			left_vaddr = vaddr + (num_entries * PUD_SIZE);
> +			pud_k = pud_offset(pgd_offset_k(left_vaddr),
> +					   left_vaddr);
> +			memcpy(pud + num_entries, pud_k, pud_index(vaddr));
> +		}
> +		pgd_populate(NULL, pgd_offset_k(i * PGDIR_SIZE), pud);
>  	}
>  out:
>  	__flush_tlb_all();
> @@ -106,6 +119,8 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  	 */
>  	int pgd_idx;
>  	int nr_pgds;
> +	pud_t *pud;
> +	pgd_t *pgd;
>  
>  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
>  		write_cr3((unsigned long)save_pgd);
> @@ -115,8 +130,12 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  
>  	nr_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
>  
> -	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++)
> +	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++) {
> +		pgd = pgd_offset_k(pgd_idx * PGDIR_SIZE);
> +		pud = (pud_t *)pgd_page_vaddr(*pgd);
> +		pud_free(NULL, pud);
>  		set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE), save_pgd[pgd_idx]);
> +	}
>  
>  	kfree(save_pgd);
>  
> -- 
> 2.5.5
> 
