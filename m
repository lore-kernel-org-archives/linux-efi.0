From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V2 1/2] x86/efi: Unmap EFI boot services code/data
 regions from efi_pgd
Date: Mon, 29 Oct 2018 07:26:30 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485E101E@ORSMSX114.amr.corp.intel.com>
References: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com>
 <20181026213845.28166-2-sai.praneeth.prakhya@intel.com>
 <20181029060708.GB128403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029060708.GB128403@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> > +int kernel_unmap_pages_in_pgd(pgd_t *pgd, unsigned long address,
> > +			      unsigned long numpages)
> > +{
> > +	int retval;
> > +
> > +	/*
> > +	 * The typical sequence for unmapping is to find a pte through
> > +	 * lookup_address_in_pgd() (ideally, it should never return NULL
> because
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
> So, just to clarify, 'pfn' is kept at 0 here? Might make sense to write it out
> explicitly like 'flags', even if it's not used by __change_page_attr_set_clr().

Sure! Makes sense. I will add it.

Regards,
Sai
