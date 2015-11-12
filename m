From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/6] x86/efi: Build our own page table structures
Date: Thu, 12 Nov 2015 21:38:57 +0000
Message-ID: <20151112213857.GH2681@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-6-git-send-email-matt@codeblueprint.co.uk>
 <20151112183813.GF3838@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151112183813.GF3838-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 12 Nov, at 07:38:13PM, Borislav Petkov wrote:
> > @@ -831,6 +831,12 @@ static void __init __efi_enter_virtual_mode(void)
> >  	efi.systab = NULL;
> >  
> >  	efi_merge_regions();
> > +	if (efi_alloc_page_tables()) {
> > +		pr_err("Failed to allocate EFI page tables\n");
> > +		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> > +		return;
> > +	}
> 
> This should happen before efi_merge_regions() - no need to merge if we
> can't alloc PGT.
 
Fair point.

> > +
> >  	new_memmap = efi_map_regions(&count, &pg_shift);
> >  	if (!new_memmap) {
> >  		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
> > @@ -888,29 +894,12 @@ static void __init __efi_enter_virtual_mode(void)
> >  
> >  	efi_runtime_mkexec();
> >  
> > -	/*
> > -	 * We mapped the descriptor array into the EFI pagetable above but we're
> > -	 * not unmapping it here. Here's why:
> > -	 *
> > -	 * We're copying select PGDs from the kernel page table to the EFI page
> > -	 * table and when we do so and make changes to those PGDs like unmapping
> > -	 * stuff from them, those changes appear in the kernel page table and we
> > -	 * go boom.
> > -	 *
> > -	 * From setup_real_mode():
> > -	 *
> > -	 * ...
> > -	 * trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
> > -	 *
> > -	 * In this particular case, our allocation is in PGD 0 of the EFI page
> > -	 * table but we've copied that PGD from PGD[272] of the EFI page table:
> > -	 *
> > -	 *	pgd_index(__PAGE_OFFSET = 0xffff880000000000) = 272
> > -	 *
> > -	 * where the direct memory mapping in kernel space is.
> > -	 *
> > -	 * new_memmap's VA comes from that direct mapping and thus clearing it,
> > -	 * it would get cleared in the kernel page table too.
> > +        /*
> 
> ERROR: code indent should use tabs where possible
> #149: FILE: arch/x86/platform/efi/efi.c:897:
> +        /*$
> 
> ...
 
Dammit vim. I'll fix this.

> >  void efi_sync_low_kernel_mappings(void)
> >  {
> > -	unsigned num_pgds;
> > -	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> > +	unsigned num_entries;
> > +	pgd_t *pgd_k, *pgd_efi;
> > +	pud_t *pud_k, *pud_efi;
> >  
> >  	if (efi_enabled(EFI_OLD_MEMMAP))
> >  		return;
> >  
> > -	num_pgds = pgd_index(MODULES_END - 1) - pgd_index(PAGE_OFFSET);
> > +	/*
> > +	 * We can share all PGD entries apart from the one entry that
> > +	 * covers the EFI runtime mapping space.
> > +	 *
> > +	 * Make sure the EFI runtime region mappings are guaranteed to
> > +	 * only span a single PGD entry and that the entry also maps
> > +	 * other important kernel regions.
> > +	 */
> > +	BUILD_BUG_ON(pgd_index(EFI_VA_END) != pgd_index(MODULES_END));
> > +	BUILD_BUG_ON((EFI_VA_START & PGDIR_MASK) !=
> > +				(EFI_VA_END & PGDIR_MASK));
> 
> You can align them in a more readable way:
> 
> 	BUILD_BUG_ON((EFI_VA_START & PGDIR_MASK) !=
> 		       (EFI_VA_END & PGDIR_MASK));

Sure.
