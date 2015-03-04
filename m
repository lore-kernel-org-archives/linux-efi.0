From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi: stub: retrieve FDT size when loaded from UEFI
 config table
Date: Wed, 4 Mar 2015 10:06:39 -0800
Message-ID: <CAFECyb8dTq0U-jCgH2R0K=4415zTR998VozQF2aCZ9ednAACvA@mail.gmail.com>
References: <1425470549-7393-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425470549-7393-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 4, 2015 at 4:02 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> When allocating memory for the copy of the FDT that the stub
> modifies and passes to the kernel, it uses the current size as
> an estimate of how much memory to allocate, and increases it page
> by page if it turns out to be too small. However, when loading
> the FDT from a UEFI configuration table, the estimated size is
> left at its default value of zero, and the allocation loop runs
> starting from zero all the way up to the allocation size that
> finally fits the updated FDT.
>
> Instead, retrieve the size of the FDT from the FDT header when
> loading it from the UEFI config table.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/arm-stub.c | 7 +++----
>  drivers/firmware/efi/libstub/efistub.h  | 2 +-
>  drivers/firmware/efi/libstub/fdt.c      | 7 ++++++-
>  3 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index dcae482a9a17..e29560e6b40b 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -175,7 +175,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>         unsigned long initrd_addr;
>         u64 initrd_size = 0;
>         unsigned long fdt_addr = 0;  /* Original DTB */
> -       u64 fdt_size = 0;  /* We don't get size from configuration table */
> +       unsigned long fdt_size = 0;
>         char *cmdline_ptr = NULL;
>         int cmdline_size = 0;
>         unsigned long new_fdt_addr;
> @@ -239,8 +239,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>         } else {
>                 status = handle_cmdline_files(sys_table, image, cmdline_ptr,
>                                               "dtb=",
> -                                             ~0UL, (unsigned long *)&fdt_addr,
> -                                             (unsigned long *)&fdt_size);
> +                                             ~0UL, &fdt_addr, &fdt_size);
>
>                 if (status != EFI_SUCCESS) {
>                         pr_efi_err(sys_table, "Failed to load device tree!\n");
> @@ -252,7 +251,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>                 pr_efi(sys_table, "Using DTB from command line\n");
>         } else {
>                 /* Look for a device tree configuration table entry. */
> -               fdt_addr = (uintptr_t)get_fdt(sys_table);
> +               fdt_addr = (uintptr_t)get_fdt(sys_table, &fdt_size);
>                 if (fdt_addr)
>                         pr_efi(sys_table, "Using DTB from configuration table\n");
>         }
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index 47437b16b186..e334a01cf92f 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -41,7 +41,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>                                             unsigned long fdt_addr,
>                                             unsigned long fdt_size);
>
> -void *get_fdt(efi_system_table_t *sys_table);
> +void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size);
>
>  void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
>                      unsigned long desc_size, efi_memory_desc_t *runtime_map,
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index 91da56c4fd54..ef5d764e2a27 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -323,7 +323,7 @@ fail:
>         return EFI_LOAD_ERROR;
>  }
>
> -void *get_fdt(efi_system_table_t *sys_table)
> +void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
>  {
>         efi_guid_t fdt_guid = DEVICE_TREE_GUID;
>         efi_config_table_t *tables;
> @@ -336,6 +336,11 @@ void *get_fdt(efi_system_table_t *sys_table)
>         for (i = 0; i < sys_table->nr_tables; i++)
>                 if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
>                         fdt = (void *) tables[i].table;
> +                       if (fdt_check_header(fdt) != 0) {
> +                               pr_efi_err(sys_table, "Invalid header detected on UEFI supplied FDT, ignoring ...\n");
> +                               return NULL;
> +                       }
> +                       *fdt_size = fdt_totalsize(fdt);
>                         break;
>          }
>
> --
> 1.8.3.2
>

Looks good.

Reviewed-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
