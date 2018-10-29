From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 1/2] x86/efi: Unmap EFI boot services code/data regions
 from efi_pgd
Date: Mon, 29 Oct 2018 18:21:41 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1810291820250.5984@nanos.tec.linutronix.de>
References: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com> <20181026213845.28166-2-sai.praneeth.prakhya@intel.com> <alpine.DEB.2.21.1810291809490.5984@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1810291809490.5984@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Sai,

On Mon, 29 Oct 2018, Thomas Gleixner wrote:
> On Fri, 26 Oct 2018, Sai Praneeth Prakhya wrote:
> >  
> > +int kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
> > +			      unsigned long numpages)
> > +{
> > +	int retval;
> > +
> > +	/*
> > +	 * The typical sequence for unmapping is to find a pte through
> > +	 * lookup_address_in_pgd() (ideally, it should never return NULL because
> > +	 * the address is already mapped) and change it's protections.
> > +	 * As pfn is the *target* of a mapping, it's not useful while unmapping.
> > +	 */
> > +	struct cpa_data cpa = {
> > +		.vaddr		= &address,
> > +		.pgd		= pgd,
> > +		.numpages	= numpages,
> > +		.mask_set	= __pgprot(0),
> > +		.mask_clr	= __pgprot(_PAGE_PRESENT | _PAGE_RW),
> > +		.flags		= 0,
> > +	};
> > +
> > +	retval = __change_page_attr_set_clr(&cpa, 0);
> > +	__flush_tlb_all();
> 
> So this looks like you copied it from kernel_map_pages_in_pgd() which has
> been discussed before to be not sufficient, but it can't be changed right
> now due to locking issues.

Managed to confuse myself. The place which cannot be changed is a different
one, but still for your call site __flush_tlb_all() might not be sufficient.

Thanks,

	tglx
