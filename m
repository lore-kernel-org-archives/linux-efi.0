From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from a
 write callback to hold multiple logs
Date: Thu, 25 Oct 2012 12:04:00 -0700
Message-ID: <CAGTjWtC=KBrgwH+UOxj0o8XhOfoH6QBGfxeJ-=-Muo+d2jb-gQ@mail.gmail.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Matthew Garrett (mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Acked-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Oct 24, 2012 at 6:54 PM, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org> wrote:
> [Issue]
>
> Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
> So, in the following scenario, we will lose 1st panic messages.
>
> 1. kernel panics.
> 2. efi_pstore is kicked and writes panic messages to NVRAM.
> 3. system reboots.
> 4. kernel panics again before a user checks the 1st panic messages in NVRAM.
>
> [Solution]
>
> A reasonable solution to fix the issue is just holding multiple logs without erasing
> existing entries.
> This patch removes a logic erasing existing entries in a write callback
> because the logic is not needed in the write callback to support holding multiple logs.
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
> ---
>  drivers/firmware/efivars.c |   39 ++-------------------------------------
>  1 files changed, 2 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index bee14cc..fbe9202 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -701,18 +701,13 @@ static int efi_pstore_write(enum pstore_type_id type,
>                 unsigned int part, size_t size, struct pstore_info *psi)
>  {
>         char name[DUMP_NAME_LEN];
> -       char stub_name[DUMP_NAME_LEN];
>         efi_char16_t efi_name[DUMP_NAME_LEN];
>         efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
>         struct efivars *efivars = psi->data;
> -       struct efivar_entry *entry, *found = NULL;
>         int i, ret = 0;
>         u64 storage_space, remaining_space, max_variable_size;
>         efi_status_t status = EFI_NOT_FOUND;
>
> -       sprintf(stub_name, "dump-type%u-%u-", type, part);
> -       sprintf(name, "%s%lu", stub_name, get_seconds());
> -
>         spin_lock(&efivars->lock);
>
>         /*
> @@ -730,35 +725,8 @@ static int efi_pstore_write(enum pstore_type_id type,
>                 return -ENOSPC;
>         }
>
> -       for (i = 0; i < DUMP_NAME_LEN; i++)
> -               efi_name[i] = stub_name[i];
> -
> -       /*
> -        * Clean up any entries with the same name
> -        */
> -
> -       list_for_each_entry(entry, &efivars->list, list) {
> -               get_var_data_locked(efivars, &entry->var);
> -
> -               if (efi_guidcmp(entry->var.VendorGuid, vendor))
> -                       continue;
> -               if (utf16_strncmp(entry->var.VariableName, efi_name,
> -                                 utf16_strlen(efi_name)))
> -                       continue;
> -               /* Needs to be a prefix */
> -               if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
> -                       continue;
> -
> -               /* found */
> -               found = entry;
> -               efivars->ops->set_variable(entry->var.VariableName,
> -                                          &entry->var.VendorGuid,
> -                                          PSTORE_EFI_ATTRIBUTES,
> -                                          0, NULL);
> -       }
> -
> -       if (found)
> -               list_del(&found->list);
> +       sprintf(name, "dump-type%u-%u-%lu", type, part,
> +               get_seconds());

Could you please also update Documentation/ABI/testing/pstore ?  It
seems it was never updated with the "dump*" file prefix.

>
>         for (i = 0; i < DUMP_NAME_LEN; i++)
>                 efi_name[i] = name[i];
> @@ -768,9 +736,6 @@ static int efi_pstore_write(enum pstore_type_id type,
>
>         spin_unlock(&efivars->lock);
>
> -       if (found)
> -               efivar_unregister(found);
> -
>         if (size)
>                 ret = efivar_create_sysfs_entry(efivars,
>                                           utf16_strsize(efi_name,
> -- 1.7.1
