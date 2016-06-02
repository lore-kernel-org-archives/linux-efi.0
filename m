From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/3] arm64: efi: Ensure efi_create_mapping() does not map
 overlapping regions
Date: Thu, 2 Jun 2016 17:56:21 +0100
Message-ID: <20160602165621.GD24938@e104818-lin.cambridge.arm.com>
References: <1464707672-21882-1-git-send-email-catalin.marinas@arm.com>
 <1464707672-21882-3-git-send-email-catalin.marinas@arm.com>
 <20160602145246.GH2658@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160602145246.GH2658-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 02, 2016 at 03:52:46PM +0100, Matt Fleming wrote:
> On Tue, 31 May, at 04:14:31PM, Catalin Marinas wrote:
> > Since the EFI page size is 4KB, it is possible for a !4KB page kernel to
> > align an EFI runtime map boundaries in a way that they can overlap
> > within the same page. This requires the current create_pgd_mapping()
> > code to be able to split existing larger mappings when an overlapping
> > region needs to be mapped.
> > 
> > With this patch, efi_create_mapping() scans the EFI memory map for
> > overlapping regions and trims the length of the current map to avoid a
> > large block mapping and subsequent split.
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> > ---
> >  arch/arm64/kernel/efi.c | 22 +++++++++++++++++++---
> >  1 file changed, 19 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > index 78f52488f9ff..0d5753c31c7f 100644
> > --- a/arch/arm64/kernel/efi.c
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -62,10 +62,26 @@ struct screen_info screen_info __section(.data);
> >  int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
> >  {
> >  	pteval_t prot_val = create_mapping_protection(md);
> > +	phys_addr_t length = md->num_pages << EFI_PAGE_SHIFT;
> > +	efi_memory_desc_t *next = md;
> >  
> > -	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
> > -			   md->num_pages << EFI_PAGE_SHIFT,
> > -			   __pgprot(prot_val | PTE_NG));
> > +	/*
> > +	 * Search for the next EFI runtime map and check for any overlap with
> > +	 * the current map when aligned to PAGE_SIZE. In such case, defer
> > +	 * mapping the end of the current range until the next
> > +	 * efi_create_mapping() call.
> > +	 */
> > +	for_each_efi_memory_desc_continue(next) {
> > +		if (!(next->attribute & EFI_MEMORY_RUNTIME))
> > +			continue;
> > +		if (next->phys_addr < PAGE_ALIGN(md->phys_addr + length))
> > +			length -= (md->phys_addr + length) & ~PAGE_MASK;
> > +		break;
> > +	}
> > +
> > +	if (length)
> > +		create_pgd_mapping(mm, md->phys_addr, md->virt_addr, length,
> > +				   __pgprot(prot_val | PTE_NG));
> >  	return 0;
> >  }
> >  
> 
> Is this mapping in chunks scheme required because of the EFI
> Properties Table restriction whereby relative offsets between regions
> must be maintained?
> 
> Because if that's not the reason, I'm wondering why you can't simply
> update efi_get_virtmap() to align the virtual addresses to 64K?

Ard to confirm but I think the reason is the relative offset between
code and data regions that must be preserved. For example, on Juno I
get:

[    0.000000] efi:   0x0009fff6e000-0x0009fffaefff [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] efi:   0x0009fffaf000-0x0009ffffefff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*

Since the code may assume relative loads from the data section, we need
to preserve this offset (which doesn't seem 64KB aligned).

-- 
Catalin
