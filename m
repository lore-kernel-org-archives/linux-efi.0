From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Clean up efi CR3 save/restore
Date: Tue, 14 Feb 2017 21:03:03 +0000
Message-ID: <20170214210303.GC28416@codeblueprint.co.uk>
References: <b75b8bdcfbf020d9fa2b69d824c2c01cc620b26a.1486765715.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b75b8bdcfbf020d9fa2b69d824c2c01cc620b26a.1486765715.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 10 Feb, at 02:30:39PM, Andy Lutomirski wrote:
> efi_call_phys_prolog() used to return a "pgd_t *" that meant one of
> three different things depending on kernel and system configuration.
> Clean it up so it uses a union and is more explicit about what's
> going on.
> 
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> 
> Matt, this is at best a minor cleanup, and I don't really need it for
> anything.  I wrote it while trying to udnerstand this code for my
> PCID series, and I think it's a bit cleaner.
 
I'm fairly sure Ingo was the last sucker^Wdeveloper to touch this
code, so I'd like to give him a chance to respond.

But it seems like a fair change to me. If no one complains I'll apply
it for v4.12.

> arch/x86/include/asm/efi.h     | 17 +++++++++++++++--
>  arch/x86/platform/efi/efi.c    |  6 +++---
>  arch/x86/platform/efi/efi_32.c | 12 ++++++------
>  arch/x86/platform/efi/efi_64.c | 22 ++++++++++++----------
>  4 files changed, 36 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index e99675b9c861..ada9d49f7874 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -111,11 +111,24 @@ extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
>  
>  #endif /* CONFIG_X86_32 */
>  
> +union efi_saved_pgd {
> +	/*
> +	 * If !EFI_OLD_MEMMAP or we're 32-bit, this is a verbatim saved CR3
> +	 * value.
> +	 */
> +	unsigned long cr3;
> +
> +#ifdef CONFIG_X86_64
> +	/* If EFI_OLD_MEMMAP, this is a kmalloced copy of the pgd. */
> +	pgd_t *pgd;
> +#endif
> +};
> +
>  extern struct efi_scratch efi_scratch;
>  extern void __init efi_set_executable(efi_memory_desc_t *md, bool executable);
>  extern int __init efi_memblock_x86_reserve_range(void);
> -extern pgd_t * __init efi_call_phys_prolog(void);
> -extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
> +extern union efi_saved_pgd __init efi_call_phys_prolog(void);
> +extern void __init efi_call_phys_epilog(union efi_saved_pgd saved_pgd);
>  extern void __init efi_print_memmap(void);
>  extern void __init efi_memory_uc(u64 addr, unsigned long size);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 274dfc481849..c25795066ec2 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -81,9 +81,9 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
>  {
>  	efi_status_t status;
>  	unsigned long flags;
> -	pgd_t *save_pgd;
> +	union efi_saved_pgd saved_pgd;
>  
> -	save_pgd = efi_call_phys_prolog();
> +	saved_pgd = efi_call_phys_prolog();
>  
>  	/* Disable interrupts around EFI calls: */
>  	local_irq_save(flags);
> @@ -92,7 +92,7 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
>  			       descriptor_version, virtual_map);
>  	local_irq_restore(flags);
>  
> -	efi_call_phys_epilog(save_pgd);
> +	efi_call_phys_epilog(saved_pgd);
>  
>  	return status;
>  }
> diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
> index cef39b097649..9b1abcf6e7bb 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -58,13 +58,13 @@ void __init efi_map_region(efi_memory_desc_t *md)
>  void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
>  void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
>  
> -pgd_t * __init efi_call_phys_prolog(void)
> +union efi_saved_pgd __init efi_call_phys_prolog(void)
>  {
>  	struct desc_ptr gdt_descr;
> -	pgd_t *save_pgd;
> +	union efi_saved_pgd saved_pgd;
>  
>  	/* Current pgd is swapper_pg_dir, we'll restore it later: */
> -	save_pgd = swapper_pg_dir;
> +	saved_pgd.cr3 = __pa(swapper_pg_dir);
>  	load_cr3(initial_page_table);
>  	__flush_tlb_all();
>  
> @@ -72,10 +72,10 @@ pgd_t * __init efi_call_phys_prolog(void)
>  	gdt_descr.size = GDT_SIZE - 1;
>  	load_gdt(&gdt_descr);
>  
> -	return save_pgd;
> +	return saved_pgd;
>  }
>  
> -void __init efi_call_phys_epilog(pgd_t *save_pgd)
> +void __init efi_call_phys_epilog(union efi_saved_pgd saved_pgd)
>  {
>  	struct desc_ptr gdt_descr;
>  
> @@ -83,7 +83,7 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  	gdt_descr.size = GDT_SIZE - 1;
>  	load_gdt(&gdt_descr);
>  
> -	load_cr3(save_pgd);
> +	write_cr3(saved_pgd.cr3);
>  	__flush_tlb_all();
>  }
>  
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 2f25a363068c..95318822b99f 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -69,16 +69,16 @@ static void __init early_code_mapping_set_exec(int executable)
>  	}
>  }
>  
> -pgd_t * __init efi_call_phys_prolog(void)
> +union efi_saved_pgd __init efi_call_phys_prolog(void)
>  {
>  	unsigned long vaddress;
> -	pgd_t *save_pgd;
> +	union efi_saved_pgd saved_pgd;
>  
>  	int pgd;
>  	int n_pgds;
>  
>  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
> -		save_pgd = (pgd_t *)read_cr3();
> +		saved_pgd.cr3 = read_cr3();
>  		write_cr3((unsigned long)efi_scratch.efi_pgt);
>  		goto out;
>  	}
> @@ -86,20 +86,21 @@ pgd_t * __init efi_call_phys_prolog(void)
>  	early_code_mapping_set_exec(1);
>  
>  	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
> -	save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
> +	saved_pgd.pgd = kmalloc_array(n_pgds, sizeof(*saved_pgd.pgd),
> +				      GFP_KERNEL);
>  
>  	for (pgd = 0; pgd < n_pgds; pgd++) {
> -		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> +		saved_pgd.pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
>  		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
>  		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
>  	}
>  out:
>  	__flush_tlb_all();
>  
> -	return save_pgd;
> +	return saved_pgd;
>  }
>  
> -void __init efi_call_phys_epilog(pgd_t *save_pgd)
> +void __init efi_call_phys_epilog(union efi_saved_pgd saved_pgd)
>  {
>  	/*
>  	 * After the lock is released, the original page table is restored.
> @@ -108,7 +109,7 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  	int nr_pgds;
>  
>  	if (!efi_enabled(EFI_OLD_MEMMAP)) {
> -		write_cr3((unsigned long)save_pgd);
> +		write_cr3(saved_pgd.cr3);
>  		__flush_tlb_all();
>  		return;
>  	}
> @@ -116,9 +117,10 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  	nr_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
>  
>  	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++)
> -		set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE), save_pgd[pgd_idx]);
> +		set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE),
> +			saved_pgd.pgd[pgd_idx]);
>  
> -	kfree(save_pgd);
> +	kfree(saved_pgd.pgd);
>  
>  	__flush_tlb_all();
>  	early_code_mapping_set_exec(0);
> -- 
> 2.9.3
> 
