From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH 1/2] x86/efi: Unmap efi boot services code/data regions
 from efi_pgd
Date: Mon, 22 Oct 2018 03:00:42 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485D5C53@ORSMSX114.amr.corp.intel.com>
References: <1540172145-17134-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1540172145-17134-2-git-send-email-sai.praneeth.prakhya@intel.com>
 <20181022015738.GB24095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181022015738.GB24095@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-efi@vger.kernel.org

> > +int kernel_unmap_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
> > +			      unsigned long numpages)
> > +{
> > +	int retval;
> > +
> > +	struct cpa_data cpa = {
> > +		.vaddr = &address,
> > +		.pfn = pfn,
> > +		.pgd = pgd,
> > +		.numpages = numpages,
> > +		.mask_set = __pgprot(0),
> > +		.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW),
> > +		.flags = 0,
> > +	};
> > +
> > +	retval = __change_page_attr_set_clr(&cpa, 0);
> > +	__flush_tlb_all();
> > +
> > +	return retval;
> > +}
> 
> That's certainly a creative use of __change_page_attr_set_clr() by EFI used for
> mapping in pages so far (kernel_map_pages_in_pgd()), and now used for
> unmapping as well. Doesn't look wrong, just a bit weird as part of CPA.
> 

Haha.. yes.. I copied from kernel_map_pages_in_pgd()

> Could you please write the initializer in an easier to read fashion:
> 
> 	struct cpa_data cpa = {
> 		.vaddr		= &address,
> 		.pfn		= pfn,
> 		.pgd		= pgd,
> 		.numpages	= numpages,
> 		.mask_set	= __pgprot(0),
> 		.mask_clr	= __pgprot(_PAGE_PRESENT | _PAGE_RW),
> 		.flags		= 0,
> 	};
> 
> ?

Sure!

> 
> The one bit that is odd is the cpa->pfn field - for unmapped pages that's totally
> uninteresting and I'm wondering whether setting it to 0 wouldn't be better.
> 
> Does the CPU _ever_ look look at the PFN if the page is !_PAGE_PRESENT, for
> example speculatively? If yes then what is the recommended value for the pfn -
> zero perhaps?
> 
> Also note that if for whatever reason the PFN range of the EFI boot area gets
> hot-unplugged, we'd have outright invalid PFNs - although this is probably very
> unlikely from a platform perspective.
> 
> > +/*
> > + * Apart from having VA mappings for efi boot services code/data
> > +regions,
> > + * (duplicate) 1:1 mappings were also created as a catch for buggy
> > +firmware. So,
> > + * unmap both 1:1 and VA mappings.
> > + */
> 
> Speling nits:
> 
> - please capitalize 'EFI' consistently.
> - s/catch/quirk ?
> 

Sure! I will fix them

> BTW., are the 1:1 'boot mappings' a buggy firmware quirk, or something
> required by the EFI spec? (or both? ;-)
> 

It's a quirk for buggy firmware.
According to EFI spec, EFI Boot Services code/data regions shouldn't be accessed 
after calling exit_boot_services(). This call is typically performed by bootloader 
(grub) or efi_stub.

> > +static void __init efi_unmap_pages(efi_memory_desc_t *md) {
> > +	pgd_t *pgd = efi_mm.pgd;
> > +	u64 pfn = md->phys_addr >> PAGE_SHIFT;
> 
> Note that this md->phys_addr isn't really meaningful once it gets unmapped.
> 

Yes, makes sense. In efi_free_boot_services(), after freeing up the memory and 
unmapping, a new memory map is created (which has only EFI Runtime regions) 
and hence we can safely assume that this memory descriptor and md->phys_addr 
would never be used.

> > +
> > +	if (kernel_unmap_pages_in_pgd(pgd, pfn, md->phys_addr, md-
> >num_pages))
> > +		pr_err("Failed to unmap 1:1 mapping: PA 0x%llx -> VA
> 0x%llx!\n",
> > +		       md->phys_addr, md->virt_addr);
> > +
> > +	if (kernel_unmap_pages_in_pgd(pgd, pfn, md->virt_addr, md-
> >num_pages))
> > +		pr_err("Failed to unmap VA mapping: PA 0x%llx -> VA
> 0x%llx!\n",
> > +		       md->phys_addr, md->virt_addr);
> 
> Please keep pr_err()'s in a single line. (and ignore checkpatch.)
>

Sure!

> > +}
> > +
> >  void __init efi_free_boot_services(void)  {
> >  	phys_addr_t new_phys, new_size;
> > @@ -415,6 +434,13 @@ void __init efi_free_boot_services(void)
> >  		}
> >
> >  		free_bootmem_late(start, size);
> > +
> > +		/*
> > +		 * Before calling set_virtual_address_map(), boot services
> > +		 * code/data regions were mapped as a catch for buggy
> firmware.
> > +		 * Unmap them from efi_pgd as they have already been freed.
> > +		 */
> > +		efi_unmap_pages(md);
> 
> Ditto.
> 
> BTW., the ordering here is wrong: we should unmap any virtual aliases from
> pagetables _before_ we free the underlying memory. The ordering is probably
> harmless in this case but overall a good practice.

Sure! Makes sense. I will fix it in V2.

Regards,
Sai
