From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 1/2] x86/efi: Unmap efi boot services code/data regions
 from efi_pgd
Date: Sun, 21 Oct 2018 21:58:00 -0700
Message-ID: <CALCETrW=M8u=F6USUk3t_sucGnU-8K6sLYOq6BGK1JhPdgjzdw@mail.gmail.com>
References: <1540172145-17134-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1540172145-17134-2-git-send-email-sai.praneeth.prakhya@intel.com> <20181022015738.GB24095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181022015738.GB24095@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, linux-efi <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Andrew Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-efi@vger.kernel.org

On Sun, Oct 21, 2018 at 6:57 PM Ingo Molnar <mingo@kernel.org> wrote:
>
>
> * Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com> wrote:
>
> > Ideally, after kernel assumes control of the platform firmware shouldn't
> > access EFI Boot Services Code/Data regions. But, it's noticed that this
> > is not so true in many x86 platforms. Hence, during boot, kernel
> > reserves efi boot services code/data regions [1] and maps [2] them to
> > efi_pgd so that call to set_virtual_address_map() doesn't fail. After
> > returning from set_virtual_address_map(), kernel frees the reserved
> > regions [3] but they still remain mapped.
> >
> > This means that any code that's running in efi_pgd address space (e.g:
> > any efi runtime service) would still be able to access efi boot services
> > code/data regions but the contents of these regions would have long been
> > over written by someone else as they are freed by efi_free_boot_services().
> > So, it's important to unmap these regions. After unmapping boot services
> > code/data regions, any illegal access by buggy firmware to these regions
> > would result in page fault which will be handled by efi specific fault
> > handler.
> >
> > [1] Please see efi_reserve_boot_services()
> > [2] Please see efi_map_region() -> __map_region()
> > [3] Please see efi_free_boot_services()
> >
> > Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Dave Hansen <dave.hansen@intel.com>
> > Cc: Bhupesh Sharma <bhsharma@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/x86/include/asm/pgtable_types.h |  2 ++
> >  arch/x86/mm/pageattr.c               | 21 +++++++++++++++++++++
> >  arch/x86/platform/efi/quirks.c       | 26 ++++++++++++++++++++++++++
> >  3 files changed, 49 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> > index b64acb08a62b..796476f11151 100644
> > --- a/arch/x86/include/asm/pgtable_types.h
> > +++ b/arch/x86/include/asm/pgtable_types.h
> > @@ -566,6 +566,8 @@ extern pmd_t *lookup_pmd_address(unsigned long address);
> >  extern phys_addr_t slow_virt_to_phys(void *__address);
> >  extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
> >                                  unsigned numpages, unsigned long page_flags);
> > +extern int kernel_unmap_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
> > +                                  unsigned long numpages);
> >  #endif       /* !__ASSEMBLY__ */
> >
> >  #endif /* _ASM_X86_PGTABLE_DEFS_H */
> > diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> > index 51a5a69ecac9..b88ed8e91790 100644
> > --- a/arch/x86/mm/pageattr.c
> > +++ b/arch/x86/mm/pageattr.c
> > @@ -2147,6 +2147,27 @@ int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
> >       return retval;
> >  }
> >
> > +int kernel_unmap_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
> > +                           unsigned long numpages)
> > +{
> > +     int retval;
> > +
> > +     struct cpa_data cpa = {
> > +             .vaddr = &address,
> > +             .pfn = pfn,
> > +             .pgd = pgd,
> > +             .numpages = numpages,
> > +             .mask_set = __pgprot(0),
> > +             .mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW),
> > +             .flags = 0,
> > +     };
> > +
> > +     retval = __change_page_attr_set_clr(&cpa, 0);
> > +     __flush_tlb_all();
> > +
> > +     return retval;
> > +}
>
> That's certainly a creative use of __change_page_attr_set_clr() by EFI
> used for mapping in pages so far (kernel_map_pages_in_pgd()), and now
> used for unmapping as well. Doesn't look wrong, just a bit weird as part
> of CPA.
>
> Could you please write the initializer in an easier to read fashion:
>
>         struct cpa_data cpa = {
>                 .vaddr          = &address,
>                 .pfn            = pfn,
>                 .pgd            = pgd,
>                 .numpages       = numpages,
>                 .mask_set       = __pgprot(0),
>                 .mask_clr       = __pgprot(_PAGE_PRESENT | _PAGE_RW),
>                 .flags          = 0,
>         };
>
> ?
>
> The one bit that is odd is the cpa->pfn field - for unmapped pages that's
> totally uninteresting and I'm wondering whether setting it to 0 wouldn't
> be better.
>
> Does the CPU _ever_ look look at the PFN if the page is !_PAGE_PRESENT,
> for example speculatively? If yes then what is the recommended value for
> the pfn - zero perhaps?
>

This is L1TF, right?  Isn't all ones the recommended value?

I would love to see EFI start treating its mm just like any other mm
at some point, though.  That is, it should not modify any mappings in
the kernel range, and it could use the regular mm modification APIs
for the user range.  But maybe this is a pipe dream.
