From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/5] efi: implement generic support for the Memory
 Attributes table
Date: Mon, 11 Apr 2016 16:09:11 +0200
Message-ID: <CAKv+Gu-TMb0MTnzXXjczvxaWvZphu7M1-MMdjCrZ7A2CvCc2WQ@mail.gmail.com>
References: <1459355933-13529-1-git-send-email-ard.biesheuvel@linaro.org>
	<1459355933-13529-5-git-send-email-ard.biesheuvel@linaro.org>
	<20160408155608.GQ2701@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160408155608.GQ2701-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Prakhya, Sai Praneeth" <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 8 April 2016 at 17:56, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Wed, 30 Mar, at 06:38:52PM, Ard Biesheuvel wrote:
>> This implements shared support for discovering the presence of the
>> Memory Attributes table, and for parsing and validating its contents.
>>
>> The table is validated against the construction rules in the UEFI spec.
>> Since this is a new table, it makes sense to complain if we encounter
>> a table that does not follow those rules.
>>
>> The parsing and validation routine takes a callback that can be specified
>> per architecture, that gets passed each unique validated region, with the
>> virtual address retrieved from the ordinary memory map.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/Makefile  |   2 +-
>>  drivers/firmware/efi/memattr.c | 170 ++++++++++++++++++++
>>  include/linux/efi.h            |  13 ++
>>  3 files changed, 184 insertions(+), 1 deletion(-)
>
> This commit breaks ia64 because it doesn't provide the global 'memmap'
> variable,
>
>   drivers/built-in.o: In function `efi_memattr_apply_permissions':
>   (.init.text+0x1f2b0): undefined reference to `memmap'
>   drivers/built-in.o: In function `efi_memattr_apply_permissions':
>   (.init.text+0x1f2b1): undefined reference to `memmap'
>
> I was surprised that the kbuild bot didn't let you know, but then I
> noticed that LKML isn't on Cc. This is yet another reminder that we
> need to drop 'memmap' on the floor. I'll send out the two patches I
> have to do that.
>
> Apart from that, this looks pretty good. There are a few comments
> below, but they're trivial changes that, if you agree, I can just fold
> in when applying this patch. If not, feel free to rework it.
>
>> diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
>> new file mode 100644
>> index 000000000000..c55683937f4a
>> --- /dev/null
>> +++ b/drivers/firmware/efi/memattr.c
>> @@ -0,0 +1,170 @@
>> +/*
>> + * Copyright (C) 2016 Linaro Ltd. <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#define pr_fmt(fmt)  "efi: " fmt
>> +
>> +#include <linux/efi.h>
>> +#include <linux/init.h>
>> +#include <linux/io.h>
>> +#include <linux/memblock.h>
>> +
>> +#include <asm/early_ioremap.h>
>> +
>> +static int __initdata tbl_size;
>> +
>> +/*
>> + * Reserve the memory associated with the Memory Attributes configuration
>> + * table, if it exists.
>> + */
>> +int __init efi_memattr_init(void)
>> +{
>> +     efi_memory_attributes_table_t *tbl;
>> +
>> +     if (efi.mem_attr_table == EFI_INVALID_TABLE_ADDR)
>> +             return 0;
>> +
>> +     tbl = early_memremap(efi.mem_attr_table, sizeof(*tbl));
>> +     if (!tbl) {
>> +             pr_err("Failed to map EFI Memory Attribute table @ 0x%lx\n",
>> +                    efi.mem_attr_table);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     if (tbl->version > 1) {
>> +             pr_warn("Unexpected EFI Memory Attribute table version %d\n",
>> +                     tbl->version);
>> +             tbl_size = 0;
>
> Isn't it unnecessary to reset 'tbl_size'?
>

Indeed.

>> +             goto unmap;
>> +     }
>
> We should check that the desc_size values match between
> efi_memory_attributes_table_t and efi_memory_desc_t while we're here
> validating the table anyway.
>

The spec does not actually mandate that, and I do know that the
Tianocore code deliberately uses a larger value for desc_size in
GetMemoryMap() to catch inadvertent uses of sizeof(). I am not sure if
the memory attribute table code does the same, and it seems dangerous
to assume that to be the case in general.

>> +
>> +     tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
>> +     memblock_reserve(efi.mem_attr_table, tbl_size);
>> +
>> +unmap:
>> +     early_memunmap(tbl, sizeof(*tbl));
>> +     return 0;
>> +}
>> +
>> +/*
>> + * Returns a copy @out of the UEFI memory descriptor @in if it is covered
>> + * entirely by a UEFI memory map entry with matching attributes. The virtual
>> + * address of @out is set according to the matching entry that was found.
>> + */
>> +static bool entry_is_valid(const efi_memory_desc_t *in, efi_memory_desc_t *out)
>> +{
>> +     u64 in_paddr = in->phys_addr;
>> +     u64 in_size = in->num_pages << EFI_PAGE_SHIFT;
>> +     efi_memory_desc_t *md;
>> +
>> +     if (in->type != EFI_RUNTIME_SERVICES_CODE &&
>> +         in->type != EFI_RUNTIME_SERVICES_DATA) {
>> +             pr_warn("MEMATTR table entry type should be RuntimeServiceCode/Data\n");
>> +             return false;
>> +     }
>> +
>> +     if (!(in->attribute & (EFI_MEMORY_RO | EFI_MEMORY_XP))) {
>> +             pr_warn("MEMATTR table entry attributes invalid: RO and XP bits both cleared\n");
>> +             return false;
>> +     }
>> +
>> +     if (PAGE_SIZE > EFI_PAGE_SIZE &&
>> +         (!PAGE_ALIGNED(in->phys_addr) ||
>> +          !PAGE_ALIGNED(in->num_pages << EFI_PAGE_SHIFT))) {
>> +             /*
>> +              * Since arm64 may execute with page sizes of up to 64 KB, the
>> +              * UEFI spec mandates that RuntimeServices memory regions must
>> +              * be 64 KB aligned. We need to validate this here since we will
>> +              * not be able to tighten permissions on such regions without
>> +              * affecting adjacent regions.
>> +              */
>> +             pr_warn("MEMATTR table entry misaligned\n");
>> +             return false;
>> +     }
>
> Out of curiosity did you check whether the compiler optimises this out
> when PAGE_SIZE <= EFI_PAGE_SIZE? I would expect so, and if you haven't
> already done it already I can check.
>

Yes, it does.

>> +
>> +     for_each_efi_memory_desc(&memmap, md) {
>> +             u64 md_paddr = md->phys_addr;
>> +             u64 md_size = md->num_pages << EFI_PAGE_SHIFT;
>> +
>> +             if (!(md->attribute & EFI_MEMORY_RUNTIME))
>> +                     continue;
>> +             if (md->virt_addr == 0) {
>> +                     /* no virtual mapping has been installed by the stub */
>> +                     break;
>> +             }
>> +
>> +             if (md_paddr > in_paddr || (in_paddr - md_paddr) >= md_size)
>> +                     continue;
>> +
>> +             /*
>> +              * This entry covers the start of @in, check whether
>> +              * it covers the end as well.
>> +              */
>> +             if (md_paddr + md_size < in_paddr + in_size) {
>> +                     pr_warn("MEMATTR table entry covers multiple UEFI memory map regions\n");
>> +                     return false;
>> +             }
>
> Here's an interesting tidbit: We never use "UEFI" in strings on x86,
> we always use "EFI", and of particular relevance to this feature is
> that "EFI" is used to describe both the memory and memory attribute
> table in the spec.
>
> How do you feel about the patch at the end of this email?
>

The patch looks fine to me, other than my concern above.

> While I'm OK with breaking the 80 column rule in exceptional
> circumstances, it was pretty straight forward to update the pr_fmt()
> macro and cut out a few words from the strings to keep this all within
> 80 columns.
>

I think there may be a cultural difference here between team-ARM and
team-x86 (i.e., your upstream). I don't remember ever getting any
complaints about overlong lines, even for actual code, and for user
visible strings, we tend to follow the documented coding style to
never break them up for the sole purpose of line length.

But I don't mind the shorter strings at all, so please don't hesitate
to fold in your changes.

>> +
>> +             if (md->type != in->type) {
>> +                     pr_warn("MEMATTR table entry type deviates from UEFI memory map region type\n");
>> +                     return false;
>> +             }
>> +
>> +             *out = *in;
>> +             out->virt_addr = in_paddr +
>> +                              (md->virt_addr - md->phys_addr);
>
> For the benefit of future search-and-replace patches, we should use
> md_paddr here instead of md->phys_addr.
>

OK

>> +             return true;
>> +     }
>> +     return false;
>> +}
>> +
>> +/*
>> + * To be called after the EFI page tables have been populated. If a memory
>> + * attributes table is available, its contents will be used to update the
>> + * mappings with tightened permissions as described by the table.
>> + * This requires the UEFI memory map to have already been populated with
>> + * virtual addresses.
>> + */
>> +int __init efi_memattr_apply_permissions(struct mm_struct *mm,
>> +                                      efi_memattr_perm_setter fn)
>> +{
>> +     efi_memory_attributes_table_t *tbl;
>> +     int i, ret;
>> +
>> +     if (tbl_size <= sizeof(*tbl))
>> +             return 0;
>
> We need to check efi_enabled(EFI_MEMMAP) before we start traversing
> the memory map in entry_is_valid().
>
>> +
>> +     tbl = memremap(efi.mem_attr_table, tbl_size, MEMREMAP_WB);
>> +     if (!tbl) {
>> +             pr_err("Failed to map EFI Memory Attribute table @ 0x%lx\n",
>> +                    efi.mem_attr_table);
>> +             return -ENOMEM;
>> +     }
>> +
>> +     if (efi_enabled(EFI_DBG))
>> +             pr_info("Processing UEFI Memory Attributes table:\n");
>> +
>> +     for (i = ret = 0; ret == 0 && i < tbl->num_entries; i++) {
>> +             efi_memory_desc_t md;
>> +             unsigned long size;
>> +             bool valid;
>> +             char buf[64];
>> +
>> +             valid = entry_is_valid((void *)tbl->entry + i * tbl->desc_size,
>> +                                    &md);
>> +             size = md.num_pages << EFI_PAGE_SHIFT;
>> +             if (efi_enabled(EFI_DBG) || !valid)
>> +                     pr_info("  0x%012llx-0x%012llx %s\n", md.phys_addr,
>> +                             md.phys_addr + size - 1,
>> +                             efi_md_typeattr_format(buf, sizeof(buf), &md));
>
> This needs to include some indication of whether we printed this
> because it was invalid or debug EFI_DBG is set. I've inserted a "!" at
> the start of the line if it's invalid but if you've got other ideas
> let me know.
>

OK

>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index 346d01ad7cca..277a9bb4e587 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -970,6 +970,19 @@ extern void __init efi_fake_memmap(void);
>>  static inline void efi_fake_memmap(void) { }
>>  #endif
>>
>> +/*
>> + * efi_memattr_perm_setter - arch specific callback function passed into
>> + *                           efi_memattr_apply_permissions() that updates the
>> + *                           mapping permissions described by the second
>> + *                           argument in the page tables referrred to by the
>
> Too many 'r's in referred.
>
> ---
>
> diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
> index 23973868e186..a983c1b63f07 100644
> --- a/drivers/firmware/efi/memattr.c
> +++ b/drivers/firmware/efi/memattr.c
> @@ -6,7 +6,7 @@
>   * published by the Free Software Foundation.
>   */
>
> -#define pr_fmt(fmt)    "efi: " fmt
> +#define pr_fmt(fmt)    "efi: memattr: " fmt
>
>  #include <linux/efi.h>
>  #include <linux/init.h>
> @@ -30,15 +30,20 @@ int __init efi_memattr_init(void)
>
>         tbl = early_memremap(efi.mem_attr_table, sizeof(*tbl));
>         if (!tbl) {
> -               pr_err("Failed to map EFI Memory Attribute table @ 0x%lx\n",
> +               pr_err("Failed to map EFI Memory Attributes table @ 0x%lx\n",
>                        efi.mem_attr_table);
>                 return -ENOMEM;
>         }
>
>         if (tbl->version > 1) {
> -               pr_warn("Unexpected EFI Memory Attribute table version %d\n",
> +               pr_warn("Unexpected EFI Memory Attributes table version %d\n",
>                         tbl->version);
> -               tbl_size = 0;
> +               goto unmap;
> +       }
> +
> +       if (tbl->desc_size != efi.memmap->desc_size) {
> +               pr_warn("Descriptor size different from EFI memory map %d\n",
> +                       tbl->desc_size);
>                 goto unmap;
>         }
>
> @@ -65,12 +70,12 @@ static bool entry_is_valid(const efi_memory_desc_t *in, efi_memory_desc_t *out)
>
>         if (in->type != EFI_RUNTIME_SERVICES_CODE &&
>             in->type != EFI_RUNTIME_SERVICES_DATA) {
> -               pr_warn("MEMATTR table entry type should be RuntimeServiceCode/Data\n");
> +               pr_warn("Entry type should be RuntimeServiceCode/Data\n");
>                 return false;
>         }
>
>         if (!(in->attribute & (EFI_MEMORY_RO | EFI_MEMORY_XP))) {
> -               pr_warn("MEMATTR table entry attributes invalid: RO and XP bits both cleared\n");
> +               pr_warn("Entry attributes invalid: RO and XP bits both cleared\n");
>                 return false;
>         }
>
> @@ -84,7 +89,7 @@ static bool entry_is_valid(const efi_memory_desc_t *in, efi_memory_desc_t *out)
>                  * not be able to tighten permissions on such regions without
>                  * affecting adjacent regions.
>                  */
> -               pr_warn("MEMATTR table entry misaligned\n");
> +               pr_warn("Entry address region misaligned\n");
>                 return false;
>         }
>
> @@ -107,22 +112,21 @@ static bool entry_is_valid(const efi_memory_desc_t *in, efi_memory_desc_t *out)
>                  * it covers the end as well.
>                  */
>                 if (md_paddr + md_size < in_paddr + in_size) {
> -                       pr_warn("MEMATTR table entry covers multiple UEFI memory map regions\n");
> +                       pr_warn("Entry covers multiple EFI memory map regions\n");
>                         return false;
>                 }
>
>                 if (md->type != in->type) {
> -                       pr_warn("MEMATTR table entry type deviates from UEFI memory map region type\n");
> +                       pr_warn("Entry type deviates from EFI memory map region type\n");
>                         return false;
>                 }
>
> -               out->virt_addr = in_paddr +
> -                                (md->virt_addr - md->phys_addr);
> +               out->virt_addr = in_paddr + (md->virt_addr - md_paddr);
> +
>                 return true;
>         }
>
> -       pr_warn("MEMATTR table entry does not having a matching entry in the memory map\n");
> -
> +       pr_warn("No matching entry found in the EFI memory map\n");
>         return false;
>  }
>
> @@ -142,15 +146,24 @@ int __init efi_memattr_apply_permissions(struct mm_struct *mm,
>         if (tbl_size <= sizeof(*tbl))
>                 return 0;
>
> +       /*
> +        * We need the EFI memory map to be setup so we can use it to
> +        * lookup the virtual addresses of all entries in the  of EFI
> +        * Memory Attributes table. If it isn't available, this
> +        * function should not be called.
> +        */
> +       if (WARN_ON(!efi_enabled(EFI_MEMMAP)))
> +               return 0;
> +
>         tbl = memremap(efi.mem_attr_table, tbl_size, MEMREMAP_WB);
>         if (!tbl) {
> -               pr_err("Failed to map EFI Memory Attribute table @ 0x%lx\n",
> +               pr_err("Failed to map EFI Memory Attributes table @ 0x%lx\n",
>                        efi.mem_attr_table);
>                 return -ENOMEM;
>         }
>
>         if (efi_enabled(EFI_DBG))
> -               pr_info("Processing UEFI Memory Attributes table:\n");
> +               pr_info("Processing EFI Memory Attributes table:\n");
>
>         for (i = ret = 0; ret == 0 && i < tbl->num_entries; i++) {
>                 efi_memory_desc_t md;
> @@ -162,7 +175,8 @@ int __init efi_memattr_apply_permissions(struct mm_struct *mm,
>                                        &md);
>                 size = md.num_pages << EFI_PAGE_SHIFT;
>                 if (efi_enabled(EFI_DBG) || !valid)
> -                       pr_info("  0x%012llx-0x%012llx %s\n", md.phys_addr,
> +                       pr_info("%s 0x%012llx-0x%012llx %s\n",
> +                               valid ? "" : "!", md.phys_addr,
>                                 md.phys_addr + size - 1,
>                                 efi_md_typeattr_format(buf, sizeof(buf), &md));
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index bb404979f4bd..c80895e4e505 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -974,8 +974,8 @@ static inline void efi_fake_memmap(void) { }
>   * efi_memattr_perm_setter - arch specific callback function passed into
>   *                           efi_memattr_apply_permissions() that updates the
>   *                           mapping permissions described by the second
> - *                           argument in the page tables referrred to by the
> - *                           first argument
> + *                           argument in the page tables referred to by the
> + *                           first argument.
>   */
>  typedef int (*efi_memattr_perm_setter)(struct mm_struct *, efi_memory_desc_t *);
>
