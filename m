From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 4/4] efi/x86: make efi_memmap_reserve only insert into
 boot mem areas
Date: Wed, 18 Jan 2017 10:28:41 +0800
Message-ID: <20170118022841.GB3343@dhcp-128-65.nay.redhat.com>
References: <20170116024554.461236678@redhat.com>
 <20170116025026.586405871@redhat.com>
 <CAKv+Gu8C2btUOOO28LVUJ3umiS-BvEk6xi7a_OMTsuh28hoDbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8C2btUOOO28LVUJ3umiS-BvEk6xi7a_OMTsuh28hoDbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/17/17 at 05:13pm, Ard Biesheuvel wrote:
> On 16 January 2017 at 02:45, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > efi_mem_reserve cares only about boot services regions, for making sure
> > later efi_free_boot_services does not free areas which are still useful,
> > such as bgrt image buffer.
> >
> > So add a new argument to efi_memmap_insert for this purpose.
> >
> 
> So what happens is we try to efi_mem_reserve() a regions that is not
> bootservices code or data? We shouldn't simply ignore it, because it
> is a serious condition.

efi_mem_reserve is designed to address the boot service memory reservation
issue but I'm not sure if we could have other requirement in the future,
then the efi_mem_reserve itself at least the function comment need an
update also. Anyway I have no strong opinion about this patch..

> 
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > v1->v2: only check EFI_BOOT_SERVICES_CODE/_DATA
> >  arch/x86/platform/efi/quirks.c  |    2 +-
> >  drivers/firmware/efi/fake_mem.c |    3 ++-
> >  drivers/firmware/efi/memmap.c   |    6 +++++-
> >  include/linux/efi.h             |    4 ++--
> >  4 files changed, 10 insertions(+), 5 deletions(-)
> >
> > --- linux-x86.orig/drivers/firmware/efi/memmap.c
> > +++ linux-x86/drivers/firmware/efi/memmap.c
> > @@ -229,7 +229,7 @@ int __init efi_memmap_split_count(efi_me
> >   * to see how large @buf needs to be.
> >   */
> >  void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
> > -                             struct efi_mem_range *mem)
> > +                             struct efi_mem_range *mem, bool boot_only)
> >  {
> >         u64 m_start, m_end, m_attr;
> >         efi_memory_desc_t *md;
> > @@ -262,6 +262,10 @@ void __init efi_memmap_insert(struct efi
> >                 start = md->phys_addr;
> >                 end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
> >
> > +               if (boot_only && !(md->type == EFI_BOOT_SERVICES_CODE ||
> > +                                  md->type == EFI_BOOT_SERVICES_DATA))
> > +                       continue;
> > +
> >                 if (m_start <= start && end <= m_end)
> >                         md->attribute |= m_attr;
> >
> > --- linux-x86.orig/arch/x86/platform/efi/quirks.c
> > +++ linux-x86/arch/x86/platform/efi/quirks.c
> > @@ -226,7 +226,7 @@ void __init efi_arch_mem_reserve(phys_ad
> >                 return;
> >         }
> >
> > -       efi_memmap_insert(&efi.memmap, new, &mr);
> > +       efi_memmap_insert(&efi.memmap, new, &mr, true);
> >         early_memunmap(new, new_size);
> >
> >         efi_memmap_install(new_phys, num_entries);
> > --- linux-x86.orig/drivers/firmware/efi/fake_mem.c
> > +++ linux-x86/drivers/firmware/efi/fake_mem.c
> > @@ -85,7 +85,8 @@ void __init efi_fake_memmap(void)
> >         }
> >
> >         for (i = 0; i < nr_fake_mem; i++)
> > -               efi_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i]);
> > +               efi_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i],
> > +                                 false);
> >
> >         /* swap into new EFI memmap */
> >         early_memunmap(new_memmap, efi.memmap.desc_size * new_nr_map);
> > --- linux-x86.orig/include/linux/efi.h
> > +++ linux-x86/include/linux/efi.h
> > @@ -959,8 +959,8 @@ extern int __init efi_memmap_install(phy
> >  extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
> >                                          struct range *range);
> >  extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
> > -                                    void *buf, struct efi_mem_range *mem);
> > -
> > +                                    void *buf, struct efi_mem_range *mem,
> > +                                    bool boot_only);
> >  extern int efi_config_init(efi_config_table_type_t *arch_tables);
> >  #ifdef CONFIG_EFI_ESRT
> >  extern void __init efi_esrt_init(void);
> >
> >

Thanks
Dave
