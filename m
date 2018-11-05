From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 1/2] efi/fdt: Indentation fix
Date: Mon, 5 Nov 2018 13:37:58 +0100
Message-ID: <CAKv+Gu-LogTWHsjPcJDt1PLp0E1kspQoOrkregknp9NXY9nfdg@mail.gmail.com>
References: <1540808142-33208-1-git-send-email-julien.thierry@arm.com> <1540808142-33208-2-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540808142-33208-2-git-send-email-julien.thierry@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
List-Id: linux-efi@vger.kernel.org

On 29 October 2018 at 11:15, Julien Thierry <julien.thierry@arm.com> wrote:
> Closing bracket seems to end a for statement when it is actually ending
> the contained if. Add some brackets to have clear delimitation of each
> scope.
>
> No functional change/fix, just fix the indentation.
>
> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/firmware/efi/libstub/fdt.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index 8830fa6..8b6696e 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -372,7 +372,7 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
>         tables = (efi_config_table_t *) sys_table->tables;
>         fdt = NULL;
>
> -       for (i = 0; i < sys_table->nr_tables; i++)
> +       for (i = 0; i < sys_table->nr_tables; i++) {
>                 if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
>                         fdt = (void *) tables[i].table;
>                         if (fdt_check_header(fdt) != 0) {
> @@ -381,7 +381,8 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
>                         }
>                         *fdt_size = fdt_totalsize(fdt);
>                         break;
> -        }
> +               }
> +       }
>
>         return fdt;
>  }
> --
> 1.9.1
>


Queued in efi/next

Thanks.
