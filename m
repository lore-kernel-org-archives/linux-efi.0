From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Correct ident mapping of efi old_map when
 kalsr enabled
Date: Thu, 27 Apr 2017 18:47:01 +0800
Message-ID: <20170427104701.GB2627@x1>
References: <1493203160-20148-1-git-send-email-bhe@redhat.com>
 <1493203160-20148-2-git-send-email-bhe@redhat.com>
 <20170426104319.GC2794@x1>
 <CAJcbSZHjQ2_MrvtdaSq8Nic+GWQGCbX_LvN7zEWcdk631=iYGQ@mail.gmail.com>
 <20170427103112.GA2627@x1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170427103112.GA2627@x1>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Xunlei Pang <xlpang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 04/27/17 at 06:31pm, Baoquan He wrote:
> Hi Thomas,
> 
> Thanks for reviewing!
> 
> On 04/26/17 at 07:49am, Thomas Garnier wrote:
> > On Wed, Apr 26, 2017 at 3:43 AM, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > >  arch/x86/platform/efi/efi_64.c | 35 +++++++++++++++++++++++++++--------
> > > >  1 file changed, 27 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > > > index 2ee7694..2e7baff 100644
> > > > --- a/arch/x86/platform/efi/efi_64.c
> > > > +++ b/arch/x86/platform/efi/efi_64.c
> > > > @@ -71,11 +71,12 @@ static void __init early_code_mapping_set_exec(int executable)
> > > >
> > > >  pgd_t * __init efi_call_phys_prolog(void)
> > > >  {
> > > > -     unsigned long vaddress;
> > > > +     unsigned long vaddr, left_vaddr;
> > > > +     unsigned int num_entries;
> > > >       pgd_t *save_pgd;
> > > > -
> > > > +     pud_t *pud, *pud_k;
> > > >       int n_pgds;
> > > > +     int i;
> > > >
> > > >       if (!efi_enabled(EFI_OLD_MEMMAP)) {
> > > >               save_pgd = (pgd_t *)read_cr3();
> > > > @@ -88,10 +89,22 @@ pgd_t * __init efi_call_phys_prolog(void)
> > > >       n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
> > > >       save_pgd = kmalloc_array(n_pgds, sizeof(*save_pgd), GFP_KERNEL);
> > > >
> > > > -     for (pgd = 0; pgd < n_pgds; pgd++) {
> > > > -             save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
> > > > -             vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
> > > > -             set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
> > > > +     for (i = 0; i < n_pgds; i++) {
> > > > +             save_pgd[i] = *pgd_offset_k(i * PGDIR_SIZE);
> > > > +
> > > > +             vaddr = (unsigned long)__va(i * PGDIR_SIZE);
> > > > +             pud = pud_alloc_one(NULL, 0);
> > 
> > Please check if pud is NULL.

Or panic if pud_alloc_one failed since kernel won't function well
anyway.
> 
> I considered it a while. I didn't check because I thought it's still in
> kernel init stage,  and at most 128 page frames are cost for 64TB,
> namely 512KB. If kernel can't give 512KB at this time, it will die soon.
> I would like to hear what people are suggesting. Since you have pointed
> it out, I will add checking here.
> 
> However I think we can keep those allocated page and try our best to
> build as much ident mapping as possible. E.g if we have 10TB memory, but
> failed to allocate page for 11th pud table, we can break the for loop,
> leave those built ident mapping there since efi region could be located
> inside those 0~5TB region.
> 
> Then inefi_call_phys_epilog() only free these allocated pud tables in
> efi_call_phys_prolog, check and avoid freeing those pud tables from
> direct mapping which still existed because of allocation failure in
> efi_call_phys_prolog.
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 2e7baff..67920d4 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -94,6 +94,11 @@ pgd_t * __init efi_call_phys_prolog(void)
>  
>  		vaddr = (unsigned long)__va(i * PGDIR_SIZE);
>  		pud = pud_alloc_one(NULL, 0);
> +		if (!pud) {
> +			pr_err("Failed to allocate page for %d-th pud table "
> +				"to build 1:1 mapping!\n", i);
> +			break;
> +		}
>  
>  		num_entries = PTRS_PER_PUD - pud_index(vaddr);
>  		pud_k = pud_offset(pgd_offset_k(vaddr), vaddr);
> @@ -132,8 +137,10 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
>  
>  	for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++) {
>  		pgd = pgd_offset_k(pgd_idx * PGDIR_SIZE);
> -		pud = (pud_t *)pgd_page_vaddr(*pgd);
> -		pud_free(NULL, pud);
> +		if (*pgd != save_pgd[pgd_idx]) {
> +			pud = (pud_t *)pgd_page_vaddr(*pgd);
> +			pud_free(NULL, pud);
> +		}
>  		set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE), save_pgd[pgd_idx]);
>  	}
>  
> 
> > 
> > > > +
> > > > +             num_entries = PTRS_PER_PUD - pud_index(vaddr);
> > > > +             pud_k = pud_offset(pgd_offset_k(vaddr), vaddr);
> > > > +             memcpy(pud, pud_k, num_entries);
> > > > +             if (pud_index(vaddr) > 0) {
> > 
> > You are using pud_index(vaddr) 3 times, might be worth using a local variable.
> 
> Sure, will do, thanks.
> 
> > 
> > > > +                     left_vaddr = vaddr + (num_entries * PUD_SIZE);
> > > > +                     pud_k = pud_offset(pgd_offset_k(left_vaddr),
> > > > +                                        left_vaddr);
> > > > +                     memcpy(pud + num_entries, pud_k, pud_index(vaddr));
> > 
> > I think this section (or the overall for loop) would benefit with a
> > comment explaining explaining why you are shifting the new PUD like
> > this.
> 
> Will write a paragraph.
> > 
> > > > +             }
> > > > +             pgd_populate(NULL, pgd_offset_k(i * PGDIR_SIZE), pud);
> > > >       }
> > > >  out:
> > > >       __flush_tlb_all();
> > > > @@ -106,6 +119,8 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
> > > >        */
> > > >       int pgd_idx;
> > > >       int nr_pgds;
> > > > +     pud_t *pud;
> > > > +     pgd_t *pgd;
> > > >
> > > >       if (!efi_enabled(EFI_OLD_MEMMAP)) {
> > > >               write_cr3((unsigned long)save_pgd);
> > > > @@ -115,8 +130,12 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
> > > >
> > > >       nr_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
> > > >
> > > > -     for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++)
> > > > +     for (pgd_idx = 0; pgd_idx < nr_pgds; pgd_idx++) {
> > > > +             pgd = pgd_offset_k(pgd_idx * PGDIR_SIZE);
> > > > +             pud = (pud_t *)pgd_page_vaddr(*pgd);
> > > > +             pud_free(NULL, pud);
> > > >               set_pgd(pgd_offset_k(pgd_idx * PGDIR_SIZE), save_pgd[pgd_idx]);
> > > > +     }
> > > >
> > > >       kfree(save_pgd);
> > > >
> > > > --
> > > > 2.5.5
> > > >
> > 
> > 
> > 
> > 
> > -- 
> > Thomas
