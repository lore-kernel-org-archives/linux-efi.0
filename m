From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 04/12] arm64/efi: split off EFI init and runtime code
 for reuse by 32-bit ARM
Date: Fri, 20 Nov 2015 07:31:35 +0100
Message-ID: <CAKv+Gu8X5RCb+yZhLhxFsWZX=Pcrv=44v5w=3Gynwws8ucSPsQ@mail.gmail.com>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
	<1447698757-8762-5-git-send-email-ard.biesheuvel@linaro.org>
	<20151119223430.GB2577@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151119223430.GB2577-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

Thanks for taking a look. Note that this patch only moves code from
one file to the other, and I am reluctant to fix bugs at the same
time. Most of your comments deserve a followup however, so I will make
sure this gets addressed at some point.


On 19 November 2015 at 23:34, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Mon, 16 Nov, at 07:32:29PM, Ard Biesheuvel wrote:
>> +
>> +     pr_info("EFI v%u.%.02u by %s\n",
>> +             efi.systab->hdr.revision >> 16,
>> +             efi.systab->hdr.revision & 0xffff, vendor);
>> +
>> +     table_size = sizeof(efi_config_table_64_t) * efi.systab->nr_tables;
>> +     config_tables = early_memremap(efi_to_phys(efi.systab->tables),
>> +                                    table_size);
>
> You should probably check the return value of early_memremap().
>

Indeed.

>> +
>> +     retval = efi_config_parse_tables(config_tables, efi.systab->nr_tables,
>> +                                      sizeof(efi_config_table_64_t), NULL);
>> +
>> +     early_memunmap(config_tables, table_size);
>> +out:
>> +     early_memunmap(efi.systab,  sizeof(efi_system_table_t));
>> +     return retval;
>> +}
>> +
>> +/*
>> + * Return true for RAM regions we want to permanently reserve.
>> + */
>> +static __init int is_reserve_region(efi_memory_desc_t *md)
>> +{
>> +     switch (md->type) {
>> +     case EFI_LOADER_CODE:
>> +     case EFI_LOADER_DATA:
>> +     case EFI_BOOT_SERVICES_CODE:
>> +     case EFI_BOOT_SERVICES_DATA:
>> +     case EFI_CONVENTIONAL_MEMORY:
>> +     case EFI_PERSISTENT_MEMORY:
>> +             return 0;
>> +     default:
>> +             break;
>> +     }
>> +     return is_normal_ram(md);
>> +}
>> +
>> +static __init void reserve_regions(void)
>> +{
>> +     efi_memory_desc_t *md;
>> +     u64 paddr, npages, size;
>> +
>> +     if (efi_enabled(EFI_DBG))
>> +             pr_info("Processing EFI memory map:\n");
>> +
>> +     for_each_efi_memory_desc(&memmap, md) {
>> +             paddr = md->phys_addr;
>> +             npages = md->num_pages;
>> +
>> +             if (efi_enabled(EFI_DBG)) {
>> +                     char buf[64];
>> +
>> +                     pr_info("  0x%012llx-0x%012llx %s",
>> +                             paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
>> +                             efi_md_typeattr_format(buf, sizeof(buf), md));
>> +             }
>> +
>> +             memrange_efi_to_native(&paddr, &npages);
>> +             size = npages << PAGE_SHIFT;
>
> The use of EFI_PAGE_SHIFT and PAGE_SHIFT seem to get mingled in this
> code. What's the correct constant to use throughout, because it
> doesn't look like PAGE_SHIFT == EFI_PAGE_SHIFT always?
>

No, this is correct (although confusing). npages has been converted to
native page size, so PAGE_SHIFT is appropriate here

>> +
>> +             if (is_normal_ram(md))
>> +                     early_init_dt_add_memory_arch(paddr, size);
>> +
>> +             if (is_reserve_region(md)) {
>> +                     memblock_mark_nomap(paddr, size);
>
> Hmm.. I was going to point out the fact that you're not checking the
> return value of memblock_mark_nomap() which can fail if you run out of
> memory when resizing the memblock arrays, until I realised that you
> haven't called memblock_allow_resize() yet. Oh well.
>

Hmm, right. I wasn't even aware that memblock could resize itself in
the first place.

>> +                     if (efi_enabled(EFI_DBG))
>> +                             pr_cont("*");
>> +             }
>> +
>> +             if (efi_enabled(EFI_DBG))
>> +                     pr_cont("\n");
>> +     }
>> +
>> +     set_bit(EFI_MEMMAP, &efi.flags);
>> +}
>> +
>> +void __init efi_init(void)
>> +{
>> +     struct efi_fdt_params params;
>> +
>> +     /* Grab UEFI information placed in FDT by stub */
>> +     if (!efi_get_fdt_params(&params))
>> +             return;
>> +
>> +     efi_system_table = params.system_table;
>> +
>> +     memmap.phys_map = params.mmap;
>> +     memmap.map = early_memremap(params.mmap, params.mmap_size);
>
> Better check the return value?

Yep,

Thanks,
Ard.
