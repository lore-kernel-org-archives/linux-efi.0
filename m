From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] Fix allocation size calculations
Date: Tue, 25 Oct 2016 08:37:18 +0100
Message-ID: <CAKv+Gu_7xGi4RhZW1P=NMoTWSmCrMqYYb9x9g8+nrgsH7ivFow@mail.gmail.com>
References: <20161024190613.8010-1-roy.franz@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161024190613.8010-1-roy.franz-ZPxbGqLxI0U@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roy Franz <roy.franz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hey Roy,

On 24 October 2016 at 20:06, Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org> wrote:
> Adjust the size used in calculations to match the actual size of allocation
> that will be performed based on EFI size/alignment constraints.
> efi_high_alloc() and efi_low_alloc() used the passed size in bytes directly
> to find space in the memory map for the allocation, rather than the actual
> allocation size that has been adjusted for size and alignment constraints.
> This results in failed allocations and retries in efi_high_alloc().  The
> same error is present in efi_low_alloc(), although failure will only happen
> if the lowest memory block is small.
> Adjust allocation size computation to respect EFI_ALLOC_ALIGN, which is
> the minimum alignment that should always be enforced, and at 64k on arm64
> is bigger than EFI_PAGE_SIZE.

Apologies for confusing you (and myself), but I was wrong here.
EFI_ALLOC_ALIGN already reflects the minimum base *and* size alignment
for OS visible allocations, and so it is not necessary to round up the
size to 'align', only to EFI_ALLOC_ALIGN. For instance, the 2 MB
aligned allocation we do for the kernel image on arm64 does not need
to be rounded up to 2 MB, only to 64 KB.

So your v1 was actually correct, although I would prefer the notation
below, if you don't mind

> Also use EFI_PAGE_SIZE consistently and remove use of EFI_PAGE_SHIFT to
> calculate page size.
>
> Signed-off-by: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 28 +++++++++++++++++---------
>  1 file changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index aded106..b97dfac 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -161,6 +161,7 @@ unsigned long get_dram_base(efi_system_table_t *sys_table_arg)
>
>  /*
>   * Allocate at the highest possible address that is not above 'max'.
> + * Align the allocation address and size to 'align'.
>   */
>  efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
>                             unsigned long size, unsigned long align,
> @@ -186,14 +187,17 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
>                 goto fail;
>
>         /*
> -        * Enforce minimum alignment that EFI requires when requesting
> -        * a specific address.  We are doing page-based allocations,
> -        * so we must be aligned to a page.
> +        * Enforce minimum alignment that EFI or Linux requires when
> +        * requesting a specific address.  We are doing page-based (or
> +        * larger) allocations, and both the address and size must meet
> +        * alignment constraints. Arm64 requires 64k alignment, while other
> +        * arches simply require 4k.
>          */
>         if (align < EFI_ALLOC_ALIGN)
>                 align = EFI_ALLOC_ALIGN;
>
> -       nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
> +       nr_pages = round_up(size, align) / EFI_PAGE_SIZE;
> +       size = nr_pages * EFI_PAGE_SIZE;

Please simplify to

size = round_up(size, EFI_ALLOC_ALIGN);
nr_pages = size / EFI_PAGE_SIZE;

Thanks,
Ard.


>  again:
>         for (i = 0; i < map_size / desc_size; i++) {
>                 efi_memory_desc_t *desc;
> @@ -208,7 +212,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
>                         continue;
>
>                 start = desc->phys_addr;
> -               end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
> +               end = start + desc->num_pages * EFI_PAGE_SIZE;
>
>                 if (end > max)
>                         end = max;
> @@ -254,6 +258,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
>
>  /*
>   * Allocate at the lowest possible address.
> + * Align the allocation address and size to 'align'.
>   */
>  efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>                            unsigned long size, unsigned long align,
> @@ -278,14 +283,17 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>                 goto fail;
>
>         /*
> -        * Enforce minimum alignment that EFI requires when requesting
> -        * a specific address.  We are doing page-based allocations,
> -        * so we must be aligned to a page.
> +        * Enforce minimum alignment that EFI or Linux requires when
> +        * requesting a specific address.  We are doing page-based (or
> +        * larger) allocations, and both the address and size must meet
> +        * alignment constraints. Arm64 requires 64k alignment, while other
> +        * arches simply require 4k.
>          */
>         if (align < EFI_ALLOC_ALIGN)
>                 align = EFI_ALLOC_ALIGN;
>
> -       nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
> +       nr_pages = round_up(size, align) / EFI_PAGE_SIZE;
> +       size = nr_pages * EFI_PAGE_SIZE;
>         for (i = 0; i < map_size / desc_size; i++) {
>                 efi_memory_desc_t *desc;
>                 unsigned long m = (unsigned long)map;
> @@ -300,7 +308,7 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>                         continue;
>
>                 start = desc->phys_addr;
> -               end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
> +               end = start + desc->num_pages * EFI_PAGE_SIZE;
>
>                 /*
>                  * Don't allocate at 0x0. It will confuse code that
> --
> 2.9.3
>
