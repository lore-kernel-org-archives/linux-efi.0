From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/3] arm64: efi: Ensure efi_create_mapping() does not map
 overlapping regions
Date: Mon, 6 Jun 2016 18:09:50 +0100
Message-ID: <20160606170950.GD29910@e104818-lin.cambridge.arm.com>
References: <1464707672-21882-1-git-send-email-catalin.marinas@arm.com>
 <1464707672-21882-3-git-send-email-catalin.marinas@arm.com>
 <CAKv+Gu-Kiq30-BtQ_aYamLyTB6d8WWmnBM6bOM-+c+WciUnUwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-Kiq30-BtQ_aYamLyTB6d8WWmnBM6bOM-+c+WciUnUwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jun 06, 2016 at 11:43:01AM +0200, Ard Biesheuvel wrote:
> On 31 May 2016 at 17:14, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> > Since the EFI page size is 4KB, it is possible for a !4KB page kernel to
> > align an EFI runtime map boundaries in a way that they can overlap
> > within the same page. This requires the current create_pgd_mapping()
> > code to be able to split existing larger mappings when an overlapping
> > region needs to be mapped.
> >
> > With this patch, efi_create_mapping() scans the EFI memory map for
> > overlapping regions and trims the length of the current map to avoid a
> > large block mapping and subsequent split.
> 
> I remember the discussion, but IIRC this was about failure to do
> break-before-make in general rather than a problem with splitting in
> particular.

In this instance, we don't have break-before-make issue since the pgd
used for EFI runtime services is not active. So it's just about
splitting a larger block and simplifying the arch code.

> So first of all, I would like to point out that this failure to do
> break-before-make is not a problem in practice, given that the EFI
> page tables are not live until much later. The reason we want to fix
> this is because the EFI page tables routines are shared with the
> swapper, where it /is/ a concern, and there is a desire to make those
> routines more strict when it comes to architectural rules regarding
> page table manipulation.

Exactly.

> Also, the reference to block mappings on !4K pages kernels is a bit
> misleading here: such block mappings are at least 32 MB in size, and
> we never map runtime code or data regions that big.

Jeremy has some patches in flight to use the contiguous bit on such
mappings. With 64KB x 32 pages, we get a 2MB block. I want to avoid code
splitting such contiguous block as well (which with the contiguous bit
means going back and clearing it).

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
> >         pteval_t prot_val = create_mapping_protection(md);
> > +       phys_addr_t length = md->num_pages << EFI_PAGE_SHIFT;
> > +       efi_memory_desc_t *next = md;
> >
> > -       create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
> > -                          md->num_pages << EFI_PAGE_SHIFT,
> > -                          __pgprot(prot_val | PTE_NG));
> > +       /*
> > +        * Search for the next EFI runtime map and check for any overlap with
> > +        * the current map when aligned to PAGE_SIZE. In such case, defer
> > +        * mapping the end of the current range until the next
> > +        * efi_create_mapping() call.
> > +        */
> > +       for_each_efi_memory_desc_continue(next) {
> > +               if (!(next->attribute & EFI_MEMORY_RUNTIME))
> > +                       continue;
> > +               if (next->phys_addr < PAGE_ALIGN(md->phys_addr + length))
> > +                       length -= (md->phys_addr + length) & ~PAGE_MASK;
> 
> This looks fishy. We could have more than two runtime regions sharing
> a 64 KB page frame, for instance, and the middle regions will have
> unaligned start and end addresses, and sizes smaller than 64 KB. This
> subtraction may wrap in that case, producing a bogus length.

I don't think I get it. This subtraction is meant to reduce the length
of the current md so that it is page aligned, deferring the mapping of
the last page to the next efi_create_mapping() call. Note that there is
a "break" just after the hunk you quoted, so we only care about the next
runtime map.

-- 
Catalin
