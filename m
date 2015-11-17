From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v2 1/5] x86/mm/pageattr: Ensure cpa->pfn only contains
 page frame numbers
Date: Tue, 17 Nov 2015 09:50:36 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1511170949150.3761@nanos>
References: <1447538451-5793-1-git-send-email-matt@codeblueprint.co.uk> <1447538451-5793-2-git-send-email-matt@codeblueprint.co.uk> <alpine.DEB.2.11.1511162010120.3761@nanos> <20151116212042.GE20435@pd.tnic> <alpine.DEB.2.11.1511162246420.3761@nanos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1511162246420.3761@nanos>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 16 Nov 2015, Thomas Gleixner wrote:
> On Mon, 16 Nov 2015, Borislav Petkov wrote:
> > On Mon, Nov 16, 2015 at 09:19:01PM +0100, Thomas Gleixner wrote:
> > > On Sat, 14 Nov 2015, Matt Fleming wrote:
> > > > The x86 pageattr code is confused about the data that is stored
> > > > cpa->pfn, sometimes it's treated as a page frame number, sometimes
> > > > it's treated as an unshifted physical address, and in one place it's
> > > > treated as a pte.
> > > 
> > > Yuck.
> > 
> > This paragraph should read like this instead:
> > 
> > "Boris used cpa->pfn as a scratch variable to contain the physical
> > address. He realizes now that he should've added a separate
> > cpa_data.phys_addr then, instead of confusing everybody."
> > 
> > > > The result of this is that the mapping functions do not map the
> > > > intended physical address.
> > > > 
> > > > This isn't a problem in practice because most of the addresses we're
> > > > mapping in the EFI code paths are already mapped in 'trampoline_pgd'
> > > > and so the pageattr mappings functions don't actually do anything in
> > > > this case. But when we move to using a separate page table for the EFI
> > > > runtime this will be an issue.
> > > 
> > > Are you sure that this does not affect existing kernel versions?
> > 
> > Shouldn't because with this new patchset we're copying all the PGDs from
> > the kernel page table before doing an EFI call, see
> > efi_sync_low_kernel_mappings() in patch 5.
> > 
> > > >  	while (num_pages-- && start < end) {
> > > > -
> > > > -		/* deal with the NX bit */
> > > > -		if (!(pgprot_val(pgprot) & _PAGE_NX))
> > > > -			cpa->pfn &= ~_PAGE_NX;
> > > 
> > > That should be a seperate patch because this is just bogus code and
> > > has nothing to do with the pfn confusion.
> > 
> > Why bogus?
> 
> Even with cpa->pfn used as an address it cannot ever be set as the
> address is page aligned ....

Gah. Misread it. _PAGE_NX is bit 63 and it can be set when cpa->pfn is
abused as an address. So yes, it should go away with that patch.

Thanks,

	tglx
