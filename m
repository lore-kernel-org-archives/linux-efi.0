From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 2/2] efi/fdt: Simplify get_fdt flow
Date: Mon, 5 Nov 2018 13:41:27 +0100
Message-ID: <CAKv+Gu9tERHAibZ+0rE=xAYtKa5M4ZdNudwe3_VpW0ic56FdwA@mail.gmail.com>
References: <1540808142-33208-1-git-send-email-julien.thierry@arm.com> <1540808142-33208-3-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540808142-33208-3-git-send-email-julien.thierry@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-efi@vger.kernel.org

On 29 October 2018 at 11:15, Julien Thierry <julien.thierry@arm.com> wrote:
> Reorganize get_fdt lookup loop, clearly showing that:
> - Nothing is done for table entries that do not have fdt_guid
> - Once an entry with fdt_guid is found, break out of the loop
>
> No functional changes.
>
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Suggested-by: Joe Perches <joe@perches.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/libstub/fdt.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index 8b6696e..5b7e2b3 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -366,23 +366,24 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
>  {
>         efi_guid_t fdt_guid = DEVICE_TREE_GUID;
>         efi_config_table_t *tables;
> -       void *fdt;
>         int i;
>
> -       tables = (efi_config_table_t *) sys_table->tables;
> -       fdt = NULL;
> +       tables = (efi_config_table_t *)sys_table->tables;
>
>         for (i = 0; i < sys_table->nr_tables; i++) {
> -               if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
> -                       fdt = (void *) tables[i].table;
> -                       if (fdt_check_header(fdt) != 0) {
> -                               pr_efi_err(sys_table, "Invalid header detected on UEFI supplied FDT, ignoring ...\n");
> -                               return NULL;
> -                       }
> -                       *fdt_size = fdt_totalsize(fdt);
> -                       break;
> +               void *fdt;
> +
> +               if (efi_guidcmp(tables[i].guid, fdt_guid) != 0)
> +                       continue;
> +
> +               fdt = (void *) tables[i].table;
> +               if (fdt_check_header(fdt) != 0) {
> +                       pr_efi_err(sys_table, "Invalid header detected on UEFI supplied FDT, ignoring ...\n");
> +                       return NULL;
>                 }
> +               *fdt_size = fdt_totalsize(fdt);
> +               return fdt;
>         }
>
> -       return fdt;
> +       return NULL;
>  }
> --
> 1.9.1
>

Queued in efi/next

Thanks.
