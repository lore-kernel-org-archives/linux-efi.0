From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] EFI/BGRT: use efi_mem_type()
Date: Thu, 24 Aug 2017 10:19:50 +0100
Message-ID: <CAKv+Gu-Osbq1JtdUd2bMLtGBgj3=0MUb6wQzu8L11iiOfMGw4w@mail.gmail.com>
References: <599EB4B302000078001730B4@prv-mh.provo.novell.com> <599EB4B302000078001730B4@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <599EB4B302000078001730B4-rw/UEucdPrvD8XXLLHKrIiOjQekVJEpY@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 August 2017 at 10:12, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org> wrote:
> Avoid effectively open-coding the function.
>
> Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
> ---
>  drivers/firmware/efi/efi-bgrt.c |   22 +---------------------
>  1 file changed, 1 insertion(+), 21 deletions(-)
>
> --- 4.13-rc6-EFI.orig/drivers/firmware/efi/efi-bgrt.c
> +++ 4.13-rc6-EFI/drivers/firmware/efi/efi-bgrt.c
> @@ -27,26 +27,6 @@ struct bmp_header {
>         u32 size;
>  } __packed;
>
> -static bool efi_bgrt_addr_valid(u64 addr)
> -{
> -       efi_memory_desc_t *md;
> -
> -       for_each_efi_memory_desc(md) {
> -               u64 size;
> -               u64 end;
> -
> -               if (md->type != EFI_BOOT_SERVICES_DATA)
> -                       continue;
> -
> -               size = md->num_pages << EFI_PAGE_SHIFT;
> -               end = md->phys_addr + size;
> -               if (addr >= md->phys_addr && addr < end)
> -                       return true;
> -       }
> -
> -       return false;
> -}
> -
>  void __init efi_bgrt_init(struct acpi_table_header *table)
>  {
>         void *image;
> @@ -85,7 +65,7 @@ void __init efi_bgrt_init(struct acpi_ta
>                 goto out;
>         }
>
> -       if (!efi_bgrt_addr_valid(bgrt->image_address)) {
> +       if (efi_mem_type(bgrt->image_address) != EFI_BOOT_SERVICES_DATA) {
>                 pr_notice("Ignoring BGRT: invalid image address\n");
>                 goto out;
>         }
>
>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
