From: Mike Waychison <mikew@google.com>
Subject: Re: [PATCH v2 3/5] efi_pstore: Remove a logic erasing entries from a
 write callback to hold multiple logs
Date: Thu, 25 Oct 2012 12:18:05 -0700
Message-ID: <CAGTjWtDVZGq7VKou10xC-zJXGmane_kKjGo1xMjgPUkKAedFqQ@mail.gmail.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D4138889AD@USINDEM103.corp.hds.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>, "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>, "dzickus@redhat.com" <dzickus@redhat.com>, "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 24, 2012 at 6:54 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
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
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
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

Actually, nothing seems to be ensuring that the value used here ends
up being the same as the ctime :\  Consider what happens if the
get_seconds() call here happens at second N, and the i_ctime is
collected at time N+1. The object wouldn't be able to be deleted after
patch 4/5 is applied.  How can we better ensure that the i_ctime is
the same value as serialized into the efi var name here?

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
