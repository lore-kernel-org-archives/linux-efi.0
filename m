From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 2/4] efi/x86: move efi_print_memmap to drivers/firmware/efi/memmap.c
Date: Tue, 17 Jan 2017 17:11:32 +0000
Message-ID: <CAKv+Gu9VUptPQYHbH7YZNJAkApqrOx0TyQHSda6ejLPxdaof1g@mail.gmail.com>
References: <20170116024554.461236678@redhat.com> <20170116025026.486040805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170116025026.486040805-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 January 2017 at 02:45, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> ---
> v1->v2: move efi_print_memmap declaration to general header file
>  arch/x86/include/asm/efi.h    |    1 -
>  arch/x86/platform/efi/efi.c   |   16 ----------------
>  drivers/firmware/efi/memmap.c |   16 ++++++++++++++++
>  include/linux/efi.h           |    1 +
>  4 files changed, 17 insertions(+), 17 deletions(-)
>
> --- linux-x86.orig/arch/x86/platform/efi/efi.c
> +++ linux-x86/arch/x86/platform/efi/efi.c
> @@ -278,22 +278,6 @@ static void __init efi_clean_memmap(void
>         }
>  }
>
> -void __init efi_print_memmap(void)
> -{
> -       efi_memory_desc_t *md;
> -       int i = 0;
> -
> -       for_each_efi_memory_desc(md) {
> -               char buf[64];
> -
> -               pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
> -                       i++, efi_md_typeattr_format(buf, sizeof(buf), md),
> -                       md->phys_addr,
> -                       md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
> -                       (md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> -       }
> -}
> -
>  static int __init efi_systab_init(void *phys)
>  {
>         if (efi_enabled(EFI_64BIT)) {
> --- linux-x86.orig/drivers/firmware/efi/memmap.c
> +++ linux-x86/drivers/firmware/efi/memmap.c
> @@ -10,6 +10,22 @@
>  #include <linux/io.h>
>  #include <asm/early_ioremap.h>
>
> +void __init efi_print_memmap(void)
> +{
> +       efi_memory_desc_t *md;
> +       int i = 0;
> +
> +       for_each_efi_memory_desc(md) {
> +               char buf[64];
> +
> +               pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
> +                       i++, efi_md_typeattr_format(buf, sizeof(buf), md),
> +                       md->phys_addr,
> +                       md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
> +                       (md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> +       }
> +}
> +
>  /**
>   * __efi_memmap_init - Common code for mapping the EFI memory map
>   * @data: EFI memory map data
> --- linux-x86.orig/arch/x86/include/asm/efi.h
> +++ linux-x86/arch/x86/include/asm/efi.h
> @@ -116,7 +116,6 @@ extern void __init efi_set_executable(ef
>  extern int __init efi_memblock_x86_reserve_range(void);
>  extern pgd_t * __init efi_call_phys_prolog(void);
>  extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
> -extern void __init efi_print_memmap(void);
>  extern void __init efi_memory_uc(u64 addr, unsigned long size);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
>  extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
> --- linux-x86.orig/include/linux/efi.h
> +++ linux-x86/include/linux/efi.h
> @@ -949,6 +949,7 @@ static inline efi_status_t efi_query_var
>         return EFI_SUCCESS;
>  }
>  #endif
> +extern void __init efi_print_memmap(void);
>  extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
>
>  extern int __init efi_memmap_init_early(struct efi_memory_map_data *data);
>
>
