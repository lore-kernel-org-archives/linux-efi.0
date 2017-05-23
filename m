From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH v4] x86/efi: Correct ident mapping of efi old_map when
 kalsr enabled
Date: Tue, 23 May 2017 22:07:15 +0800
Message-ID: <20170523140715.GD2295@x1>
References: <1495089570-21005-1-git-send-email-bhe@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495089570-21005-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Thomas Garnier <thgarnie@google.com>, mike.travis@hpe.com, dyoung@redhat.com
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Russ Anderson <rja@sgi.com>, Frank Ramsay <frank.ramsay@hpe.com>, Borislav Petkov <bp@alien8.de>, Bhupesh Sharma <bhsharma@redhat.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi Thomas,

Could you help check again if this patch is OK to you?

Last time you acked v2 post, however the pgd_populate become unavailable
in non-p4d case when p4d relatd code merged into linus's tree, I have to
change accordingly and repost. And with p4d code adding, the memory copying
way is not easy to understand, so I step back to take the pud entry copy
one by one method.


Hi Mike and Dave,

Could you also help review this patch?

If possible, it can still catch the latest version of RHEL GA.

Thanks
Baoquan

On 05/18/17 at 02:39pm, Baoquan He wrote:
> For EFI with 'efi=old_map' kernel option specified, Kernel will panic
> when kaslr is enabled.
> 
> The back trace is:
> 
> BUG: unable to handle kernel paging request at 000000007febd57e
> IP: 0x7febd57e
> PGD 1025a067
> PUD 0
> 
> Oops: 0010 [#1] SMP
> [ ... ]
> Call Trace:
>  ? efi_call+0x58/0x90
>  ? printk+0x58/0x6f
>  efi_enter_virtual_mode+0x3c5/0x50d
>  start_kernel+0x40f/0x4b8
>  ? set_init_arg+0x55/0x55
>  ? early_idt_handler_array+0x120/0x120
>  x86_64_start_reservations+0x24/0x26
>  x86_64_start_kernel+0x14c/0x16f
>  start_cpu+0x14/0x14
> 
> The root cause is the ident mapping is not built correctly in old_map case.
> 
> For nokaslr kernel, PAGE_OFFSET is 0xffff880000000000 which is PGDIR_SIZE
> aligned. We can borrow the pud table from direct mapping safely. Given a
> physical address X, we have pud_index(X) == pud_index(__va(X)). However,
> for kaslr kernel, PAGE_OFFSET is PUD_SIZE aligned. For a given physical
> address X, pud_index(X) != pud_index(__va(X)). We can't only copy pgd entry
> from direct mapping to build ident mapping, instead need copy pud entry
> one by one from direct mapping.
> 
> Fix it.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Dave Young <dyoung@redhat.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Garnier <thgarnie@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Russ Anderson <rja@sgi.com>
> Cc: Frank Ramsay <frank.ramsay@hpe.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Bhupesh Sharma <bhsharma@redhat.com>
> Cc: x86@kernel.org
> Cc: linux-efi@vger.kernel.org
> ---
> v3->v4:
>     1. Forget running scripts/checkpatch.pl to check patch, there are several
>     code stype issue. Correct them in this version.
> 
> v2->v3:
>     1. Rewrite code to copy pud entry one by one so that code can be understood
>     better. Usually we only have less than 1TB or several TB memory, pud entry
>     copy one by one won't impact efficiency.
> 
>     2. Adding p4d page table handling.
> 
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
>  arch/x86/platform/efi/efi_64.c | 70 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 62 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index c488625..087aafc 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -71,11 +71,13 @@ static void __init early_code_mapping_set_exec(int executable)
>  
>  pgd_t * __init efi_call_phys_prolog(void)
>  {
> -	unsigned long vaddress;
> -	pgd_t *save_pgd;
> +	unsigned long vaddr, addr_pgd, addr_p4d, addr_pud;
> +	pgd_t *save_pgd, *pgd_k, *pgd_efi;
> +	p4d_t *p4d, *p4d_k, *p4d_efi;
> +	pud_t *pud;
>  
>  	int pgd;
> -	int n_pgds;
> +	int n_pgds, i, j;
>  
>  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
>  		save_pgd = (pgd_t *)read_cr3();
> @@ -88,10 +90,44 @@ pgd_t * __init efi_call_phys_prolog(void)
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
>  	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
>  
> +	/*
> +	 * Build 1:1 ident mapping for old_map usage. It needs to be noticed
> +	 * that PAGE_OFFSET is PGDIR_SIZE aligned with KASLR disabled, while
> +	 * PUD_SIZE ALIGNED with KASLR enabled. So for a given physical
> +	 * address X, the pud_index(X) != pud_index(__va(X)), we can only copy
> +	 * pud entry of __va(X) to fill in pud entry of X to build 1:1 mapping
> +	 * . Means here we can only reuse pmd table of direct mapping.
> +	 */
>  	for (pgd = 0; pgd < n_pgds; pgd++) {
> -		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> -		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
> -		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
> +		addr_pgd = (unsigned long)(pgd * PGDIR_SIZE);
> +		vaddr = (unsigned long)__va(pgd * PGDIR_SIZE);
> +		pgd_efi = pgd_offset_k(addr_pgd);
> +		save_pgd[pgd] = *pgd_efi;
> +		p4d =  p4d_alloc(&init_mm, pgd_efi, addr_pgd);
> +
> +		if (!p4d) {
> +			pr_err("Failed to allocate p4d table!\n");
> +			goto out;
> +		}
> +		for (i = 0; i < PTRS_PER_P4D; i++) {
> +			addr_p4d = addr_pgd + i * P4D_SIZE;
> +			p4d_efi = p4d + p4d_index(addr_p4d);
> +			pud = pud_alloc(&init_mm, p4d_efi, addr_p4d);
> +			if (!pud) {
> +				pr_err("Failed to allocate pud table!\n");
> +				goto out;
> +			}
> +			for (j = 0; j < PTRS_PER_PUD; j++) {
> +				addr_pud = addr_p4d + j * PUD_SIZE;
> +				if (addr_pud > (max_pfn << PAGE_SHIFT))
> +					break;
> +				vaddr = (unsigned long)__va(addr_pud);
> +
> +				pgd_k = pgd_offset_k(vaddr);
> +				p4d_k = p4d_offset(pgd_k, vaddr);
> +				pud[j] = *pud_offset(p4d_k, vaddr);
> +			}
> +		}
>  	}
>  out:
>  	__flush_tlb_all();
> @@ -104,8 +140,11 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  	/*
>  	 * After the lock is released, the original page table is restored.
>  	 */
> -	int pgd_idx;
> +	int pgd_idx, i;
>  	int nr_pgds;
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud;
>  
>  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
>  		write_cr3((unsigned long)save_pgd);
> @@ -115,9 +154,24 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  
>  	nr_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
>  
> -	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++)
> +	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++) {
> +		pgd = pgd_offset_k(pgd_idx * PGDIR_SIZE);
>  		set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE), save_pgd[pgd_idx]);
>  
> +		if (!(pgd_val(*pgd) & _PAGE_PRESENT))
> +			continue;
> +		for (i = 0; i < PTRS_PER_P4D; i++) {
> +			p4d = p4d_offset(pgd,
> +					 pgd_idx * PGDIR_SIZE + i * P4D_SIZE);
> +			if (!(p4d_val(*p4d) & _PAGE_PRESENT))
> +				continue;
> +			pud = (pud_t *)p4d_page_vaddr(*p4d);
> +			pud_free(&init_mm, pud);
> +		}
> +		p4d = (p4d_t *)pgd_page_vaddr(*pgd);
> +		p4d_free(&init_mm, p4d);
> +	}
> +
>  	kfree(save_pgd);
>  
>  	__flush_tlb_all();
> -- 
> 2.5.5
> 
