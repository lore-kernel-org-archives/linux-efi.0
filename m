From: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Add missing 1:1 mappings to support buggy
 firmware
Date: Tue, 14 Feb 2017 19:42:00 -0800
Message-ID: <1487130120.2150.23.camel@intel.com>
References: <1486607948-1509-1-git-send-email-sai.praneeth.prakhya@intel.com>
         <20170214205139.GB28416@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214205139.GB28416-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ricardo Neri <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ravi Shankar <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2017-02-14 at 20:51 +0000, Matt Fleming wrote:
> On Wed, 08 Feb, at 06:39:08PM, Sai Praneeth Prakhya wrote:
> > From: Sai Praneeth <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > There are some machines with buggy firmware that access EFI regions in
> > 1:1 mode (or physical mode) rather than virtual mode even after kernel
> > being booted. On these machines, if we invoke an EFI runtime service
> > (that does these buggy accesses) then it causes a page fault and hence
> > results in kernel hang. The page fault happens because the requested
> 
> Could you include a small amount of the page fault output in the
> commit message? We don't need the callstack, but the IP of the
> faulting instruction and the rest of the page fault message would be
> good (along with which runtime service faulted).
> 

Sure, will add them in V2.

> > region doesn't have appropriate page attributes set or the mapping for
> > the region might be missing. This issue was introduced by commit
> > 67a9108ed431 ("x86/efi: Build our own page table structures"). Before
> > this commit, 1:1 mappings for EFI regions were in swapper_pgd and were
> > not needed to be synced, but this commit introduced efi_pgd which missed
> > these mappings.
>  
> Oops, good catch.
> 
> > Below shown are the efi_pgd dumps before and after the bad commit.
> > efi_dump_pagetable() is called before calling efi_merge_regions() in
> > __efi_enter_virtual_mode() and this kernel is booted on qemu to obtain
> > page table dumps.
> > 
> > +	/*
> > +	 * Sync 1:1 mappings to support buggy firmware which haven't updated
> > +	 * their addresses even after kernel has booted.
> > +	 */
> > +	num_pgds = pgd_index(VMALLOC_START) - pgd_index(PAGE_OFFSET);
> > +	memcpy(efi_pgd, pgd_offset_k(PAGE_OFFSET), sizeof(pgd_t) * num_pgds);
> > +
> >  	return 0;
> >  }
> 
> Is there a reason you didn't add this code to
> efi_sync_low_kernel_mappings()? That would seem like the logical place
> to put it because that's where we already do some PGD copying.

It makes sense that "efi_sync_low_kernel_mappings()" would be the best
place but I added them here for these reasons

1. These mappings refer to "direct mapping of all physical memory" and
thus in "efi_map_regions()" we update *these* mappings to create 1:1
mappings (to allow physical mode accesses by buggy firmware), so if we
copy these mappings in "efi_sync_low_kernel_mappings()" which is called
later than efi_map_regions(), we will overwrite previous 1:1 mappings
created by efi_map_regions() and hence kernel panics.

2. The other reason for adding these mappings in
"efi_alloc_page_tables()" is because that's the way mappings looked in
swapper_pgd before we shifted EFI stuff to efi_pgd.

I have tested this by moving this code to
"efi_sync_low_kernel_mappings()" and I see that kernel panics in
set_virtual_address_map().

Please do correct me if you think otherwise.

Thanks for the review, Matt

Regards,
Sai
