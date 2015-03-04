From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: stub: retrieve FDT size when loaded from UEFI config table
Date: Wed, 4 Mar 2015 12:28:49 +0100
Message-ID: <CAKv+Gu_vRtuYu0TFNUY4XOucuxCTh8pxtLkZdh4JQzgE-itd7Q@mail.gmail.com>
References: <1425373699-16321-1-git-send-email-ard.biesheuvel@linaro.org>
	<CAFECyb-9Uv4AFrPjrj-6zYqyFkEe_YaA3HUBiec_4SeLwwfAjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFECyb-9Uv4AFrPjrj-6zYqyFkEe_YaA3HUBiec_4SeLwwfAjQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 3 March 2015 at 19:03, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Mar 3, 2015 at 1:08 AM, Ard Biesheuvel
> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> When allocating memory for the copy of the FDT that the stub
>> modifies and passes to the kernel, it uses the current size as
>> an estimate of how much memory to allocate, and increases it page
>> by page if it turns out to be too small. However, when loading
>> the FDT from a UEFI configuration table, the estimated size is
>> left at its default value of zero, and the allocation loop runs
>> starting from zero all the way up to the allocation size that
>> finally fits the updated FDT.
>>
>> Instead, retrieve the size of the FDT when loading it from the
>> UEFI config table.
> minor nit - maybe say "retrieve the size of the FDT from the FDT
> header" to make clear
> the size is provided by the FDT, and not the EFI configuration table entry.
>

Yes, good point.

>
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/libstub/arm-stub.c | 4 ++--
>>  drivers/firmware/efi/libstub/efistub.h  | 2 +-
>>  drivers/firmware/efi/libstub/fdt.c      | 4 +++-
>>  3 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
>> index b98f0fcb4c6a..84d0a0b4ac4f 100644
>> --- a/drivers/firmware/efi/libstub/arm-stub.c
>> +++ b/drivers/firmware/efi/libstub/arm-stub.c
>> @@ -175,7 +175,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>>         unsigned long initrd_addr;
>>         u64 initrd_size = 0;
>>         unsigned long fdt_addr = 0;  /* Original DTB */
>> -       u64 fdt_size = 0;  /* We don't get size from configuration table */
>> +       unsigned long fdt_size = 0;
>>         char *cmdline_ptr = NULL;
>>         int cmdline_size = 0;
>>         unsigned long new_fdt_addr;
>> @@ -252,7 +252,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>>                 pr_efi(sys_table, "Using DTB from command line\n");
>>         } else {
>>                 /* Look for a device tree configuration table entry. */
>> -               fdt_addr = (uintptr_t)get_fdt(sys_table);
>> +               fdt_addr = (uintptr_t)get_fdt(sys_table, &fdt_size);
>>                 if (fdt_addr)
>>                         pr_efi(sys_table, "Using DTB from configuration table\n");
>>         }
>> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
>> index 47437b16b186..e334a01cf92f 100644
>> --- a/drivers/firmware/efi/libstub/efistub.h
>> +++ b/drivers/firmware/efi/libstub/efistub.h
>> @@ -41,7 +41,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>>                                             unsigned long fdt_addr,
>>                                             unsigned long fdt_size);
>>
>> -void *get_fdt(efi_system_table_t *sys_table);
>> +void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size);
>>
>>  void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
>>                      unsigned long desc_size, efi_memory_desc_t *runtime_map,
>
> It looks like there are some old casts of fdt_size/fdt_addr to unsigned long
> around line 240:
> if (efi_secureboot_enabled(sys_table)) {
>         pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
> } else {
>         status = handle_cmdline_files(sys_table, image, cmdline_ptr,
>                                       "dtb=",
>                                       ~0UL, (unsigned long *)&fdt_addr,
>                                       (unsigned long *)&fdt_size);
> It looks like both casts to unsigned long can go, as both fdt_size and fdt_addr
> are unsigned long. (fdt_addr already has the right type, but still has a cast.)
> I don't see any reason for fdt_size to be u64, so the type change itself seems
> fine.
>

Yes, and mixing u64* and unsigned long* is going to cause trouble
potentially when we upstream the 32-bit ARM EFI support.

>
>> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
>> index 378196944e66..21aca05448d4 100644
>> --- a/drivers/firmware/efi/libstub/fdt.c
>> +++ b/drivers/firmware/efi/libstub/fdt.c
>> @@ -320,7 +320,7 @@ fail:
>>         return EFI_LOAD_ERROR;
>>  }
>>
>> -void *get_fdt(efi_system_table_t *sys_table)
>> +void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
>>  {
>>         efi_guid_t fdt_guid = DEVICE_TREE_GUID;
>>         efi_config_table_t *tables;
>> @@ -333,6 +333,8 @@ void *get_fdt(efi_system_table_t *sys_table)
>>         for (i = 0; i < sys_table->nr_tables; i++)
>>                 if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
>>                         fdt = (void *) tables[i].table;
>> +                       if (!fdt_check_header(fdt))
>> +                               *fdt_size = fdt_totalsize(fdt);
>>                         break;
>
> Should we return NULL (with an error message) here if the FDT header
> check fails? We'll eventually do that
> when we try to update the FDT, but it seems nicer to not propagate
> data that we know is bad.

Yes, that makes sense. I will add that.

-- 
Ard.
