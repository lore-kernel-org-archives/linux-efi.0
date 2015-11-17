From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 04/12] arm64/efi: split off EFI init and runtime code
 for reuse by 32-bit ARM
Date: Tue, 17 Nov 2015 10:21:44 +0100
Message-ID: <CAKv+Gu8+0ezm-8En6MGkjRmb1VkU8tN38rSRixqf0JjL8nDVsg@mail.gmail.com>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
	<1447698757-8762-5-git-send-email-ard.biesheuvel@linaro.org>
	<20151116184821.GC8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151116184821.GC8644-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 November 2015 at 19:48, Russell King - ARM Linux
<linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org> wrote:
> On Mon, Nov 16, 2015 at 07:32:29PM +0100, Ard Biesheuvel wrote:
>> +/*
>> + * Enable the UEFI Runtime Services if all prerequisites are in place, i.e.,
>> + * non-early mapping of the UEFI system table and virtual mappings for all
>> + * EFI_MEMORY_RUNTIME regions.
>> + */
>> +static int __init arm64_enable_runtime_services(void)
>> +{
>> +     u64 mapsize;
>> +
>> +     if (!efi_enabled(EFI_BOOT)) {
>> +             pr_info("EFI services will not be available.\n");
>> +             return -1;
>> +     }
>> +
>> +     if (efi_runtime_disabled()) {
>> +             pr_info("EFI runtime services will be disabled.\n");
>> +             return -1;
>> +     }
>> +
>> +     pr_info("Remapping and enabling EFI services.\n");
>> +
>> +     mapsize = memmap.map_end - memmap.map;
>> +     memmap.map = (__force void *)ioremap_cache(memmap.phys_map,
>> +                                                mapsize);
>> +     if (!memmap.map) {
>> +             pr_err("Failed to remap EFI memory map\n");
>> +             return -1;
>> +     }
>> +     memmap.map_end = memmap.map + mapsize;
>> +     efi.memmap = &memmap;
>> +
>> +     efi.systab = (__force void *)ioremap_cache(efi_system_table,
>> +                                                sizeof(efi_system_table_t));
>> +     if (!efi.systab) {
>> +             pr_err("Failed to remap EFI System Table\n");
>> +             return -1;
>> +     }
>> +     set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>> +
>> +     if (!efi_virtmap_init()) {
>> +             pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
>> +             return -1;
>> +     }
>> +
>> +     /* Set up runtime services function pointers */
>> +     efi_native_runtime_setup();
>> +     set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>> +
>> +     efi.runtime_version = efi.systab->hdr.revision;
>> +
>> +     return 0;
>> +}
>> +early_initcall(arm64_enable_runtime_services);
>
> The above ought to be fixed - initcalls return negative errno numbers,
> so returning -1 from them is really not acceptable.  (The original code
> was doing the same - so it should be fixed as a separate patch.)
>

Indeed. I will add a patch to v3 to address this.
