From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to ACPI
 regions being no longer mapped as NOMAP
Date: Wed, 13 Dec 2017 10:49:27 +0000
Message-ID: <CAKv+Gu_BmFN9Zg861SCS+R=V4khFykjuOzkmfEknsL=NvWW3Eg@mail.gmail.com>
References: <CACi5LpM_95ebYFguPTyjWk+qHT5rDJVXiYDkNWbszo6Zw41zRA@mail.gmail.com>
 <CACi5LpNV_E9pvhTwLcy6vtEj9qbL1ZEHe-5sv=iiW0k9JxPD1Q@mail.gmail.com>
 <20171113092730.GA29552@linaro.org> <CAKv+Gu_eQ-s0J22tKeHKJme4qXcvxvDkS7vKrNW+o_XtMTkMhQ@mail.gmail.com>
 <3df4c6c5-0abe-01ee-730d-2edaa5f497d2@redhat.com> <20171116070005.GI29552@linaro.org>
 <CAFTCetQHmpprAVu6uYO+rc5Xi4EUVhmovbmSaU6nM1n1mAH62w@mail.gmail.com>
 <CAKv+Gu9oda1Ee8AoXsCEw+Bjn-XF3wZA_CsxvqhjtT6_bmJ7uA@mail.gmail.com>
 <CACi5LpOZ=WOx14gTwH5jfLozepT2Jw8JSY5x+bfEZ_YaiQvFpw@mail.gmail.com> <20171213102624.GC28046@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171213102624.GC28046-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 13 December 2017 at 10:26, AKASHI Takahiro
<takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Bhupesh, Ard,
>
> On Wed, Dec 13, 2017 at 03:21:59AM +0530, Bhupesh Sharma wrote:
>> Hi Ard, Akashi
>>
> (snip)
>
>> Looking deeper into the issue, since the arm64 kexec-tools uses the
>> 'linux,usable-memory-range' dt property to allow crash dump kernel to
>> identify its own usable memory and exclude, at its boot time, any
>> other memory areas that are part of the panicked kernel's memory.
>> (see https://www.kernel.org/doc/Documentation/devicetree/bindings/chosen.txt
>> , for details)
>
> Right.
>
>> 1). Now when 'kexec -p' is executed, this node is patched up only
>> with the crashkernel memory range:
>>
>>                 /* add linux,usable-memory-range */
>>                 nodeoffset = fdt_path_offset(new_buf, "/chosen");
>>                 result = fdt_setprop_range(new_buf, nodeoffset,
>>                                 PROP_USABLE_MEM_RANGE, &crash_reserved_mem,
>>                                 address_cells, size_cells);
>>
>> (see https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git/tree/kexec/arch/arm64/kexec-arm64.c#n465
>> , for details)
>>
>> 2). This excludes the ACPI reclaim regions irrespective of whether
>> they are marked as System RAM or as RESERVED. As,
>> 'linux,usable-memory-range' dt node is patched up only with
>> 'crash_reserved_mem' and not 'system_memory_ranges'
>>
>> 3). As a result when the crashkernel boots up it doesn't find this
>> ACPI memory and crashes while trying to access the same:
>>
>> # kexec -p /boot/vmlinuz-`uname -r` --initrd=/boot/initramfs-`uname
>> -r`.img --reuse-cmdline -d
>>
>> [snip..]
>>
>> Reserved memory range
>> 000000000e800000-000000002e7fffff (0)
>>
>> Coredump memory ranges
>> 0000000000000000-000000000e7fffff (0)
>> 000000002e800000-000000003961ffff (0)
>> 0000000039d40000-000000003ed2ffff (0)
>> 000000003ed60000-000000003fbfffff (0)
>> 0000001040000000-0000001ffbffffff (0)
>> 0000002000000000-0000002ffbffffff (0)
>> 0000009000000000-0000009ffbffffff (0)
>> 000000a000000000-000000affbffffff (0)
>>
>> 4). So if we revert Ard's patch or just comment the fixing up of the
>> memory cap'ing passed to the crash kernel inside
>> 'arch/arm64/mm/init.c' (see below):
>>
>> static void __init fdt_enforce_memory_region(void)
>> {
>>         struct memblock_region reg = {
>>                 .size = 0,
>>         };
>>
>>         of_scan_flat_dt(early_init_dt_scan_usablemem, &reg);
>>
>>         if (reg.size)
>>                 //memblock_cap_memory_range(reg.base, reg.size); /*
>> comment this out */
>> }
>
> Please just don't do that. It can cause a fatal damage on
> memory contents of the *crashed* kernel.
>
>> 5). Both the above temporary solutions fix the problem.
>>
>> 6). However exposing all System RAM regions to the crashkernel is not
>> advisable and may cause the crashkernel or some crashkernel drivers to
>> fail.
>>
>> 6a). I am trying an approach now, where the ACPI reclaim regions are
>> added to '/proc/iomem' separately as ACPI reclaim regions by the
>> kernel code and on the other hand the user-space 'kexec-tools' will
>> pick up the ACPI reclaim regions from '/proc/iomem' and add it to the
>> dt node 'linux,usable-memory-range'
>
> I still don't understand why we need to carry over the information
> about "ACPI Reclaim memory" to crash dump kernel. In my understandings,
> such regions are free to be reused by the kernel after some point of
> initialization. Why does crash dump kernel need to know about them?
>

Not really. According to the UEFI spec, they can be reclaimed after
the OS has initialized, i.e., when it has consumed the ACPI tables and
no longer needs them. Of course, in order to be able to boot a kexec
kernel, those regions needs to be preserved, which is why they are
memblock_reserve()'d now.

So it seems that kexec does not honour the memblock_reserve() table
when booting the next kernel.

> (In other words, can or should we skip some part of ACPI-related init code
> on crash dump kernel?)
>

I don't think so. And the change to the handling of ACPI reclaim
regions only revealed the bug, not created it (given that other
memblock_reserve regions may be affected as well)


>> 6b). The kernel code currently looks like the following:
>>
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index 30ad2f085d1f..867bdec7c692 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -206,6 +206,7 @@ static void __init request_standard_resources(void)
>>  {
>>      struct memblock_region *region;
>>      struct resource *res;
>> +    phys_addr_t addr_start, addr_end;
>>
>>      kernel_code.start   = __pa_symbol(_text);
>>      kernel_code.end     = __pa_symbol(__init_begin - 1);
>> @@ -218,9 +219,17 @@ static void __init request_standard_resources(void)
>>              res->name  = "reserved";
>>              res->flags = IORESOURCE_MEM;
>>          } else {
>> -            res->name  = "System RAM";
>> -            res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
>> +            addr_start =
>> __pfn_to_phys(memblock_region_reserved_base_pfn(region));
>> +            addr_end =
>> __pfn_to_phys(memblock_region_reserved_end_pfn(region)) - 1;
>> +            if ((efi_mem_type(addr_start) == EFI_ACPI_RECLAIM_MEMORY)
>> || (efi_mem_type(addr_end) == EFI_ACPI_RECLAIM_MEMORY)) {
>> +                res->name  = "ACPI reclaim region";
>> +                res->flags = IORESOURCE_MEM;
>> +            } else {
>> +                res->name  = "System RAM";
>> +                res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
>> +            }
>>          }
>> +
>>          res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
>>          res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
>>
>> @@ -292,6 +301,7 @@ void __init setup_arch(char **cmdline_p)
>>
>>      request_standard_resources();
>>
>> +    efi_memmap_unmap();
>>      early_ioremap_reset();
>>
>>      if (acpi_disabled)
>> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
>> index 80d1a885def5..a7c522eac640 100644
>> --- a/drivers/firmware/efi/arm-init.c
>> +++ b/drivers/firmware/efi/arm-init.c
>> @@ -259,7 +259,6 @@ void __init efi_init(void)
>>
>>      reserve_regions();
>>      efi_esrt_init();
>> -    efi_memmap_unmap();
>>
>>      memblock_reserve(params.mmap & PAGE_MASK,
>>               PAGE_ALIGN(params.mmap_size +
>>
>>
>> After this change the ACPI reclaim regions are properly recognized in
>> '/proc/iomem':
>>
>> # cat /proc/iomem | grep -i ACPI
>> 396c0000-3975ffff : ACPI reclaim region
>> 39770000-397affff : ACPI reclaim region
>> 398a0000-398bffff : ACPI reclaim region
>>
>> 6c). I am currently changing the 'kexec-tools' and will finish the
>> testing over the next few days.
>>
>> I just wanted to know your opinion on this issue, so that I will be
>> able to propose a fix on the above lines.
>>
>> Also Cc'ing kexec mailing list for more inputs on changes proposed to
>> kexec-tools.
>>
>> Thanks,
>> Bhupesh
