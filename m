From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 1/5] x86/mm/pageattr: Ensure cpa->pfn only contains
 page frame numbers
Date: Tue, 17 Nov 2015 09:45:09 +0000
Message-ID: <20151117094509.GB2727@codeblueprint.co.uk>
References: <1447538451-5793-1-git-send-email-matt@codeblueprint.co.uk>
 <1447538451-5793-2-git-send-email-matt@codeblueprint.co.uk>
 <alpine.DEB.2.11.1511162010120.3761@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1511162010120.3761@nanos>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 16 Nov, at 09:19:01PM, Thomas Gleixner wrote:
> On Sat, 14 Nov 2015, Matt Fleming wrote:
> > The x86 pageattr code is confused about the data that is stored
> > cpa->pfn, sometimes it's treated as a page frame number, sometimes
> > it's treated as an unshifted physical address, and in one place it's
> > treated as a pte.
> 
> Yuck.
>  
> > The result of this is that the mapping functions do not map the
> > intended physical address.
> > 
> > This isn't a problem in practice because most of the addresses we're
> > mapping in the EFI code paths are already mapped in 'trampoline_pgd'
> > and so the pageattr mappings functions don't actually do anything in
> > this case. But when we move to using a separate page table for the EFI
> > runtime this will be an issue.
> 
> Are you sure that this does not affect existing kernel versions?
 
This code only gets called for the EFI code paths (because it's
guarded by the "if (cpa->pgd)" calls).

The code is so wrong that if people were hitting it we would have seen
reports of weird boot and runtime crashes. I'm not aware of any that
could be caused by this, which is why I didn't mark it for stable.

> >  	while (num_pages-- && start < end) {
> > -
> > -		/* deal with the NX bit */
> > -		if (!(pgprot_val(pgprot) & _PAGE_NX))
> > -			cpa->pfn &= ~_PAGE_NX;
> 
> That should be a seperate patch because this is just bogus code and
> has nothing to do with the pfn confusion.
 
I'm OK either way, but Boris asked me to fold this hunk into this
patch. It was originally a separate patch,

  https://lkml.kernel.org/r/1447342823-3612-3-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org

> > -
> > -		set_pte(pte, pfn_pte(cpa->pfn >> PAGE_SHIFT, pgprot));
> > +		set_pte(pte, pfn_pte(cpa->pfn, pgprot));
> 
> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index a0ac0f9c307f..c8b58ac47b77 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -143,7 +143,7 @@ void efi_sync_low_kernel_mappings(void)
> >  
> >  int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
> >  {
> > -	unsigned long text;
> > +	unsigned long pfn, text;
> >  	struct page *page;
> >  	unsigned npages;
> >  	pgd_t *pgd;
> > @@ -160,7 +160,8 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
> >  	 * and ident-map those pages containing the map before calling
> >  	 * phys_efi_set_virtual_address_map().
> >  	 */
> > -	if (kernel_map_pages_in_pgd(pgd, pa_memmap, pa_memmap, num_pages, _PAGE_NX)) {
> > +	pfn = pa_memmap >> PAGE_SHIFT;
> > +	if (kernel_map_pages_in_pgd(pgd, pfn, pa_memmap, num_pages, _PAGE_NX)) {
> >  		pr_err("Error ident-mapping new memmap (0x%lx)!\n", pa_memmap);
> >  		return 1;
> >  	}
> > @@ -176,21 +177,29 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
> >  	if (!IS_ENABLED(CONFIG_EFI_MIXED))
> >  		return 0;
> >  
> > +	npages = (_end - _text) >> PAGE_SHIFT;
> 
> You really need to PFN_ALIGN _end and _text. Has been wrong in the
> existing code as well.
 
Hmm... very good point.

> > +	text = __pa(_text);
> > +	pfn = text >> PAGE_SHIFT;
> > +
> > +	if (kernel_map_pages_in_pgd(pgd, pfn, text, npages, 0)) {
> > +		pr_err("Failed to map kernel text 1:1\n");
> > +		return 1;
> > +	}
> > +
> >  	page = alloc_page(GFP_KERNEL|__GFP_DMA32);
> >  	if (!page)
> >  		panic("Unable to allocate EFI runtime stack < 4GB\n");
> >  
> >  	efi_scratch.phys_stack = virt_to_phys(page_address(page));
> > -	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
> > -
> > -	npages = (_end - _text) >> PAGE_SHIFT;
> > -	text = __pa(_text);
> > +	pfn = page_to_pfn(page);
> >  
> > -	if (kernel_map_pages_in_pgd(pgd, text >> PAGE_SHIFT, text, npages, 0)) {
> > -		pr_err("Failed to map kernel text 1:1\n");
> > +	if (kernel_map_pages_in_pgd(pgd, pfn, efi_scratch.phys_stack, 1, 0)) {
> 
> This looks like an unrelated change, hmm?

Dave picked up on this too. Yeah, this hunk should really be part of
PATCH 2 (or a separate patch entirely) because it ensures that the
stack is mapped into the EFI page tables instead of relying on it
being around in 'trampoline_pgd'.
