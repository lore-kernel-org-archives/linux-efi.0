From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 2/3] arm64: efi: Ensure efi_create_mapping() does not map
 overlapping regions
Date: Tue, 28 Jun 2016 17:05:28 +0100
Message-ID: <20160628160528.GG4585@e104818-lin.cambridge.arm.com>
References: <1464707672-21882-1-git-send-email-catalin.marinas@arm.com>
 <1464707672-21882-3-git-send-email-catalin.marinas@arm.com>
 <CAKv+Gu-Kiq30-BtQ_aYamLyTB6d8WWmnBM6bOM-+c+WciUnUwA@mail.gmail.com>
 <20160606170950.GD29910@e104818-lin.cambridge.arm.com>
 <20160606174207.GH29910@e104818-lin.cambridge.arm.com>
 <CAKv+Gu_3uKgFtvMryROwTMeGs=uXYU-OPrUC6LaNQiAKP=PZ3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_3uKgFtvMryROwTMeGs=uXYU-OPrUC6LaNQiAKP=PZ3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Restarting the thread before I forget the entire discussion)

On Mon, Jun 06, 2016 at 11:18:14PM +0200, Ard Biesheuvel wrote:
> >> > On 31 May 2016 at 17:14, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> >> > > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> >> > > index 78f52488f9ff..0d5753c31c7f 100644
> >> > > --- a/arch/arm64/kernel/efi.c
> >> > > +++ b/arch/arm64/kernel/efi.c
> >> > > @@ -62,10 +62,26 @@ struct screen_info screen_info __section(.data);
> >> > >  int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
> >> > >  {
> >> > >         pteval_t prot_val = create_mapping_protection(md);
> >> > > +       phys_addr_t length = md->num_pages << EFI_PAGE_SHIFT;
> >> > > +       efi_memory_desc_t *next = md;
> >> > >
> >> > > -       create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
> >> > > -                          md->num_pages << EFI_PAGE_SHIFT,
> >> > > -                          __pgprot(prot_val | PTE_NG));
> >> > > +       /*
> >> > > +        * Search for the next EFI runtime map and check for any overlap with
> >> > > +        * the current map when aligned to PAGE_SIZE. In such case, defer
> >> > > +        * mapping the end of the current range until the next
> >> > > +        * efi_create_mapping() call.
> >> > > +        */
> >> > > +       for_each_efi_memory_desc_continue(next) {
> >> > > +               if (!(next->attribute & EFI_MEMORY_RUNTIME))
> >> > > +                       continue;
> >> > > +               if (next->phys_addr < PAGE_ALIGN(md->phys_addr + length))
> >> > > +                       length -= (md->phys_addr + length) & ~PAGE_MASK;
[...]
> Another thing I failed to mention is that the new Memory Attributes
> table support may map all of the RuntimeServicesCode regions a second
> time, but with a higher granularity, using RO for .text and .rodata
> and NX for .data and .bss (and the PE/COFF header).

Can this not be done in a single go without multiple passes? That's what
we did for the core arm64 code, the only one left being EFI run-time
mappings.

> Due to the higher
> granularity, regions that were mapped using the contiguous bit the
> first time around may be split into smaller regions. Your current code
> does not address that case.

If the above doesn't work, the only solution would be to permanently map
these ranges as individual pages, no large blocks.

> I wonder how the PT debug code deals with this, and whether there is
> anything we can reuse to inhibit cont and block mappings

Do you mean DEBUG_PAGEALLOC? When enabled, it defaults to single page
mappings for the kernel, no sections.

-- 
Catalin
