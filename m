From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] efi/x86: make efi_memmap_reserve only insert into
 boot mem areas
Date: Thu, 12 Jan 2017 16:15:59 +0000
Message-ID: <CAKv+Gu-cdhvAM2Vkqv8uokZAqD3k0kLbGu1UYwgQOYj5Es0g=g@mail.gmail.com>
References: <20170112094118.815108042@redhat.com> <20170112094214.860924858@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112094214.860924858-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hello Dave,

On 12 January 2017 at 09:41, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> There are memory ranges like below when I testing early efi_mem_reserve:
>
> efi: mem62: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> efi: mem63: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> efi: mem64: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> efi: mem65: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> efi: mem66: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
> efi: mem67: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
>

Did you spot Peter's patch to prune invalid memmap entries?

https://git.kernel.org/cgit/linux/kernel/git/efi/efi.git/commit/?h=next&id=b2a91a35445229

I would expect this patch to no longer be necessary with that in place, no?


> So efi_memmap_insert will run into inserting same region multiple times,
> also because efi_memmap_insert does not consider the duplicate ranges it will
> cause memmap buffer overflow due to the size is pre-calculated, and kernel boot
> fail with a panic.  We did not detect such issue because current users of
> efi_mem_insert do it very late after switching to virtual mode, at that time
> the new cooked efi.memmap contains only runtime needed memory ranges.
>
> efi_mem_reserve cares only about boot services regions and maybe loader areas.
> So add a new argument to efi_memmap_insert for this purpose.
>
> Later patches depend on this one for moving bgrt reservation to early code.
>
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/quirks.c  |    2 +-
>  drivers/firmware/efi/fake_mem.c |    3 ++-
>  drivers/firmware/efi/memmap.c   |    8 +++++++-
>  include/linux/efi.h             |    4 ++--
>  4 files changed, 12 insertions(+), 5 deletions(-)
>
> --- linux-x86.orig/drivers/firmware/efi/memmap.c
> +++ linux-x86/drivers/firmware/efi/memmap.c
> @@ -213,7 +213,7 @@ int __init efi_memmap_split_count(efi_me
>   * to see how large @buf needs to be.
>   */
>  void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
> -                             struct efi_mem_range *mem)
> +                             struct efi_mem_range *mem, bool boot_only)
>  {
>         u64 m_start, m_end, m_attr;
>         efi_memory_desc_t *md;
> @@ -246,6 +246,12 @@ void __init efi_memmap_insert(struct efi
>                 start = md->phys_addr;
>                 end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
>
> +               if (boot_only && !(md->type == EFI_LOADER_DATA ||
> +                   md->type == EFI_LOADER_CODE ||
> +                   md->type == EFI_BOOT_SERVICES_CODE ||
> +                   md->type == EFI_BOOT_SERVICES_DATA))
> +                       continue;
> +
>                 if (m_start <= start && end <= m_end)
>                         md->attribute |= m_attr;
>
> --- linux-x86.orig/arch/x86/platform/efi/quirks.c
> +++ linux-x86/arch/x86/platform/efi/quirks.c
> @@ -226,7 +226,7 @@ void __init efi_arch_mem_reserve(phys_ad
>                 return;
>         }
>
> -       efi_memmap_insert(&efi.memmap, new, &mr);
> +       efi_memmap_insert(&efi.memmap, new, &mr, true);
>         early_memunmap(new, new_size);
>
>         efi_memmap_install(new_phys, num_entries);
> --- linux-x86.orig/drivers/firmware/efi/fake_mem.c
> +++ linux-x86/drivers/firmware/efi/fake_mem.c
> @@ -85,7 +85,8 @@ void __init efi_fake_memmap(void)
>         }
>
>         for (i = 0; i < nr_fake_mem; i++)
> -               efi_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i]);
> +               efi_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i],
> +                                 false);
>
>         /* swap into new EFI memmap */
>         early_memunmap(new_memmap, efi.memmap.desc_size * new_nr_map);
> --- linux-x86.orig/include/linux/efi.h
> +++ linux-x86/include/linux/efi.h
> @@ -957,8 +957,8 @@ extern int __init efi_memmap_install(phy
>  extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
>                                          struct range *range);
>  extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
> -                                    void *buf, struct efi_mem_range *mem);
> -
> +                                    void *buf, struct efi_mem_range *mem,
> +                                    bool boot_only);
>  extern int efi_config_init(efi_config_table_type_t *arch_tables);
>  #ifdef CONFIG_EFI_ESRT
>  extern void __init efi_esrt_init(void);
>
>
