From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: always map first physical page into EFI
 pagetables
Date: Fri, 27 Jan 2017 15:12:48 +0000
Message-ID: <20170127151248.GF31613@codeblueprint.co.uk>
References: <alpine.LSU.2.20.1701252048550.25515@cbobk.fhfr.pm>
 <alpine.LSU.2.20.1701252130410.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1701252130410.25515@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <waiman.long@hpe.com>, Borislav Petkov <bp@suse.de>, Laura Abbott <labbott@redhat.com>, Vojtech Pavlik <vojtech@ucw.cz>, Hanka Pavlikova <hanka@ucw.cz>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 25 Jan, at 09:31:53PM, Jiri Kosina wrote:
> 
> [ CCing mailinglists that got eaten by my newly configured mail setup, 
>   sorry for that ]
> 
> On Wed, 25 Jan 2017, Jiri Kosina wrote:
> 
> > From: Jiri Kosina <jkosina@suse.cz>
> > 
> > Commit 129766708 ("x86/efi: Only map RAM into EFI page tables if in 
> > mixed-mode") stopped creating 1:1 mapping for all RAM in case of running 
> > in native 64bit mode.
> > 
> > It turns out though that there are 64bit EFI implementations in the wild 
> > (this particular problem has been reported on Lenovo Yoga 710-11IKB) which 
> > still make use of first physical page for their own private use (which is 
> > what legacy BIOS used to do, but EFI specification doesn't grant any such 
> > right to EFI BIOS ... oh well).
> > 
> > In case there is no mapping for this particular frame in EFI pagetables, 
> > as soon as firmware tries to make use of it, triple fault occurs and the 
> > system reboots (in case of Yoga 710-11IKB this is very early during boot).
> > 

The thing missing from this paragraph is that the EFI memmap entry
type for this page is EFI_CONVENTIONAL_MEMORY on these Lenovo Yoga's,
i.e. the firmware is telling the kernel that the first page is "free
memory" but will write to it anyway.

> > Fix that by always mapping the first page of physical memory into EFI 
> > pagetables.
> > 
> > Note: just reverting 129766708 is not enough on v4.9-rc1+ to fix the 
> > regression on affected hardware, as commit ab72a27da ("x86/efi: 
> > Consolidate region mapping logic") later made the first physical frame not 
> > to be mapped anyway.
> > 
> > Fixes: 129766708 ("x86/efi: Only map RAM into EFI page tables if in mixed-mode")
> > Cc: stable@kernel.org # v4.8+
> > Cc: Waiman Long <waiman.long@hpe.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Laura Abbott <labbott@redhat.com>
> > Cc: Vojtech Pavlik <vojtech@ucw.cz>
> > Reported-by: Hanka Pavlikova <hanka@ucw.cz>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> > 
> > Thanks a lot to Matt for excellent hint how to debug EFI failures
> > 
> >  arch/x86/platform/efi/efi_64.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index 319148b..02ae2ab 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -269,6 +269,17 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
> >  	efi_scratch.use_pgd = true;
> >  
> >  	/*
> > +	 * Certain firmware versions are way too sentimental and still believe
> > +	 * they are exclusive and unquestionable owners of first physical page.
> > +	 * Create 1:1 mapping for this page to avoid triple faults during early
> > +	 * boot with such firmware.
> > +	 */
> > +	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, _PAGE_RW)) {
> > +		pr_err("Failed to create 1:1 mapping of first page\n");
> > +		return 1;
> > +	}
> > +
> > +	/*
> >  	 * When making calls to the firmware everything needs to be 1:1
> >  	 * mapped and addressable with 32-bit pointers. Map the kernel
> >  	 * text and allocate a new stack because we can't rely on the

Could you update the comment above to include two additional points:

  1) We've seen machines that mark the first page as
     EFI_CONVENTIONAL_MEMORY but the firmware will write to it
     during SetVirtualAddressMap() nevertheless.

  2) trim_bios_range() takes care of actually reserving the first page
     and making it unavailable to the memory allocators.
