From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 5/6] x86/efi: Build our own page table structures
Date: Thu, 12 Nov 2015 19:38:13 +0100
Message-ID: <20151112183813.GF3838@pd.tnic>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-6-git-send-email-matt@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447342823-3612-6-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 12, 2015 at 03:40:22PM +0000, Matt Fleming wrote:
> With commit e1a58320a38d ("x86/mm: Warn on W^X mappings") all users
> booting on 64-bit UEFI machines see the following warning,
> 
>   ------------[ cut here ]------------
>   WARNING: CPU: 7 PID: 1 at arch/x86/mm/dump_pagetables.c:225 note_page+0x5dc/0x780()
>   x86/mm: Found insecure W+X mapping at address ffff88000005f000/0xffff88000005f000
>   ...
>   x86/mm: Checked W+X mappings: FAILED, 165660 W+X pages found.
>   ...
> 
> This is caused by mapping EFI regions with RWX permissions. There
> isn't much we can do to restrict the permissions for these regions due
> to the way the firmware toolchains mix code and data, but we can at
> least isolate these mappings so that they do not appear in the regular
> kernel page tables.
> 
> In commit d2f7cbe7b26a ("x86/efi: Runtime services virtual mapping")
> we started using 'trampoline_pgd' to map the EFI regions because there
> was an existing identity mapping there which we use during the
> SetVirtualAddressMap() call and for broken firmware that accesses
> those addresses.
> 
> But 'trampoline_pgd' shares some PGD entries with 'swapper_pg_dir' and
> does not provide the isolation we require. Notaby the virtual address

					     Notably

> for __START_KERNEL_map and MODULES_START are mapped by the same PGD
> entry so we need to be more careful when copying changes over in
> efi_sync_low_kernel_mappings().
> 
> This patch doesn't go the full mile, we still want to share some PGD
> entries with 'swapper_pg_dir'. Having completely separate page tables
> brings its own issues such as sychronising new mappings after memory
> hotplug and module loading. Sharing also keeps memory usage down.

Cool idea!

...

> @@ -831,6 +831,12 @@ static void __init __efi_enter_virtual_mode(void)
>  	efi.systab = NULL;
>  
>  	efi_merge_regions();
> +	if (efi_alloc_page_tables()) {
> +		pr_err("Failed to allocate EFI page tables\n");
> +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +		return;
> +	}

This should happen before efi_merge_regions() - no need to merge if we
can't alloc PGT.

> +
>  	new_memmap = efi_map_regions(&count, &pg_shift);
>  	if (!new_memmap) {
>  		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
> @@ -888,29 +894,12 @@ static void __init __efi_enter_virtual_mode(void)
>  
>  	efi_runtime_mkexec();
>  
> -	/*
> -	 * We mapped the descriptor array into the EFI pagetable above but we're
> -	 * not unmapping it here. Here's why:
> -	 *
> -	 * We're copying select PGDs from the kernel page table to the EFI page
> -	 * table and when we do so and make changes to those PGDs like unmapping
> -	 * stuff from them, those changes appear in the kernel page table and we
> -	 * go boom.
> -	 *
> -	 * From setup_real_mode():
> -	 *
> -	 * ...
> -	 * trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
> -	 *
> -	 * In this particular case, our allocation is in PGD 0 of the EFI page
> -	 * table but we've copied that PGD from PGD[272] of the EFI page table:
> -	 *
> -	 *	pgd_index(__PAGE_OFFSET = 0xffff880000000000) = 272
> -	 *
> -	 * where the direct memory mapping in kernel space is.
> -	 *
> -	 * new_memmap's VA comes from that direct mapping and thus clearing it,
> -	 * it would get cleared in the kernel page table too.
> +        /*

ERROR: code indent should use tabs where possible
#149: FILE: arch/x86/platform/efi/efi.c:897:
+        /*$

...

>  void efi_sync_low_kernel_mappings(void)
>  {
> -	unsigned num_pgds;
> -	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> +	unsigned num_entries;
> +	pgd_t *pgd_k, *pgd_efi;
> +	pud_t *pud_k, *pud_efi;
>  
>  	if (efi_enabled(EFI_OLD_MEMMAP))
>  		return;
>  
> -	num_pgds = pgd_index(MODULES_END - 1) - pgd_index(PAGE_OFFSET);
> +	/*
> +	 * We can share all PGD entries apart from the one entry that
> +	 * covers the EFI runtime mapping space.
> +	 *
> +	 * Make sure the EFI runtime region mappings are guaranteed to
> +	 * only span a single PGD entry and that the entry also maps
> +	 * other important kernel regions.
> +	 */
> +	BUILD_BUG_ON(pgd_index(EFI_VA_END) != pgd_index(MODULES_END));
> +	BUILD_BUG_ON((EFI_VA_START & PGDIR_MASK) !=
> +				(EFI_VA_END & PGDIR_MASK));

You can align them in a more readable way:

	BUILD_BUG_ON((EFI_VA_START & PGDIR_MASK) !=
		       (EFI_VA_END & PGDIR_MASK));
> +
> +	pgd_efi = efi_pgd + pgd_index(PAGE_OFFSET);
> +	pgd_k = pgd_offset_k(PAGE_OFFSET);
> +
> +	num_entries = pgd_index(EFI_VA_END) - pgd_index(PAGE_OFFSET);
> +	memcpy(pgd_efi, pgd_k, sizeof(pgd_t) * num_entries);
>  
> -	memcpy(pgd + pgd_index(PAGE_OFFSET),
> -		init_mm.pgd + pgd_index(PAGE_OFFSET),
> -		sizeof(pgd_t) * num_pgds);
> +	/*
> +	 * We share all the PUD entries apart from those that map the
> +	 * EFI regions. Copy around them.
> +	 */
> +	BUILD_BUG_ON((EFI_VA_START & ~PUD_MASK) != 0);
> +	BUILD_BUG_ON((EFI_VA_END & ~PUD_MASK) != 0);
> +
> +	pgd_efi = efi_pgd + pgd_index(EFI_VA_END);
> +	pud_efi = pud_offset(pgd_efi, 0);
> +
> +	pgd_k = pgd_offset_k(EFI_VA_END);
> +	pud_k = pud_offset(pgd_k, 0);
> +
> +	num_entries = pud_index(EFI_VA_END);
> +	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
> +
> +	pud_efi = pud_offset(pgd_efi, EFI_VA_START);
> +	pud_k = pud_offset(pgd_k, EFI_VA_START);
> +
> +	num_entries = PTRS_PER_PUD - pud_index(EFI_VA_START);
> +	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
>  }

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
