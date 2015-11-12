From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 3/6] x86/efi: Map RAM into the identity page table for
 mixed mode
Date: Thu, 12 Nov 2015 19:45:09 +0000
Message-ID: <20151112194509.GE2681@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-4-git-send-email-matt@codeblueprint.co.uk>
 <20151112180126.GD3838@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151112180126.GD3838@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 12 Nov, at 07:01:26PM, Borislav Petkov wrote:
> On Thu, Nov 12, 2015 at 03:40:20PM +0000, Matt Fleming wrote:
> > We are relying on the pre-existing mappings in 'trampoline_pgd' when
> > accessing function arguments in the EFI mixed mode thunking code.
> > 
> > Instead let's map memory explicitly so that things will continue to
> > work when we move to a separate page table in the future.
> > 
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> > Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> > ---
> >  arch/x86/platform/efi/efi_64.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index c8b58ac47b77..634536034e32 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -144,6 +144,7 @@ void efi_sync_low_kernel_mappings(void)
> >  int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
> >  {
> >  	unsigned long pfn, text;
> > +	efi_memory_desc_t *md;
> >  	struct page *page;
> >  	unsigned npages;
> >  	pgd_t *pgd;
> > @@ -200,6 +201,25 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
> >  
> >  	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
> >  
> > +	/*
> > +	 * Map all of RAM so that we can access arguments in the 1:1
> 
> Why "all of RAM"?
 
Because the pointers to arguments we pass to the thunk code can point
anywhere in RAM.

> > +	 * mapping when making EFI runtime calls.
> > +	 */
> > +	for_each_efi_memory_desc(&memmap, md) {
> > +		if (md->type != EFI_CONVENTIONAL_MEMORY &&
> > +		    md->type != EFI_LOADER_DATA &&
> > +		    md->type != EFI_LOADER_CODE)
> 
> That's mapping all those EFI_* types...

Hmm? This is mapping only those regions that are usable by the kernel
for general allocations. See the table in setup_e820() in the EFI boot
stub code - these types map to E820_RAM.
