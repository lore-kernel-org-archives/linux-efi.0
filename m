From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V2 1/2] x86/efi: Unmap EFI boot services code/data
 regions from efi_pgd
Date: Mon, 29 Oct 2018 18:01:27 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485E5549@ORSMSX114.amr.corp.intel.com>
References: <20181026213845.28166-1-sai.praneeth.prakhya@intel.com>
 <20181026213845.28166-2-sai.praneeth.prakhya@intel.com>
 <alpine.DEB.2.21.1810291809490.5984@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1810291820250.5984@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1810291820250.5984@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Hi Thomas and Peter,

[off the mailing list because I wasn't sure if it's a good idea to spam others with my questions]

> > > +	/*
> > > +	 * The typical sequence for unmapping is to find a pte through
> > > +	 * lookup_address_in_pgd() (ideally, it should never return NULL
> because
> > > +	 * the address is already mapped) and change it's protections.
> > > +	 * As pfn is the *target* of a mapping, it's not useful while unmapping.
> > > +	 */
> > > +	struct cpa_data cpa = {
> > > +		.vaddr		= &address,
> > > +		.pgd		= pgd,
> > > +		.numpages	= numpages,
> > > +		.mask_set	= __pgprot(0),
> > > +		.mask_clr	= __pgprot(_PAGE_PRESENT | _PAGE_RW),
> > > +		.flags		= 0,
> > > +	};
> > > +
> > > +	retval = __change_page_attr_set_clr(&cpa, 0);
> > > +	__flush_tlb_all();
> >
> > So this looks like you copied it from kernel_map_pages_in_pgd() which
> > has been discussed before to be not sufficient, but it can't be
> > changed right now due to locking issues.
>
> Managed to confuse myself. The place which cannot be changed is a different
> one, but still for your call site __flush_tlb_all() might not be sufficient.

Since the mappings are changed, I thought a flush_tlb() might be needed.
But, (to be honest), I don't completely understand the x86/mm code. So, could you 
please elaborate the issue more for my better understanding?

So some questions I have are,
1. What did Peter Z mean here? "How is that not a TLB invalidation bug ?"
2. I assumed kernel_map_pages_in_pgd() to be a good code but you said that 
it has some locking issues. So, could you please elaborate more on that.

Or, could you please provide me some pointers in the source code that I can take a look at so that I could understand the issue much better.

Regards,
Sai
