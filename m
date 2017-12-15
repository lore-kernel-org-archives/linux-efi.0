From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to ACPI
 regions being no longer mapped as NOMAP
Date: Fri, 15 Dec 2017 10:35:10 +0100
Message-ID: <CAKv+Gu-W5VpVrgA=FVZCCevksaRGOVvPdE+B8WkpZc6AE1jOPw@mail.gmail.com>
References: <CAKv+Gu_eQ-s0J22tKeHKJme4qXcvxvDkS7vKrNW+o_XtMTkMhQ@mail.gmail.com>
 <3df4c6c5-0abe-01ee-730d-2edaa5f497d2@redhat.com> <20171116070005.GI29552@linaro.org>
 <CAFTCetQHmpprAVu6uYO+rc5Xi4EUVhmovbmSaU6nM1n1mAH62w@mail.gmail.com>
 <CAKv+Gu9oda1Ee8AoXsCEw+Bjn-XF3wZA_CsxvqhjtT6_bmJ7uA@mail.gmail.com>
 <CACi5LpOZ=WOx14gTwH5jfLozepT2Jw8JSY5x+bfEZ_YaiQvFpw@mail.gmail.com>
 <20171213102624.GC28046@linaro.org> <CAKv+Gu_BmFN9Zg861SCS+R=V4khFykjuOzkmfEknsL=NvWW3Eg@mail.gmail.com>
 <20171213121605.GE28046@linaro.org> <CAKv+Gu_G8kBEAdAznVauZVAdJOFkr1vmu0Gf6tOwJfH2CgdufA@mail.gmail.com>
 <20171215085924.sqlcwm4copzba5ag@fireball>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171215085924.sqlcwm4copzba5ag@fireball>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 15 December 2017 at 09:59, AKASHI Takahiro
<takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Dec 13, 2017 at 12:17:22PM +0000, Ard Biesheuvel wrote:
>> On 13 December 2017 at 12:16, AKASHI Takahiro
>> <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> > On Wed, Dec 13, 2017 at 10:49:27AM +0000, Ard Biesheuvel wrote:
>> >> On 13 December 2017 at 10:26, AKASHI Takahiro
>> >> <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> >> > Bhupesh, Ard,
>> >> >
>> >> > On Wed, Dec 13, 2017 at 03:21:59AM +0530, Bhupesh Sharma wrote:
>> >> >> Hi Ard, Akashi
>> >> >>
>> >> > (snip)
>> >> >
>> >> >> Looking deeper into the issue, since the arm64 kexec-tools uses the
>> >> >> 'linux,usable-memory-range' dt property to allow crash dump kernel to
>> >> >> identify its own usable memory and exclude, at its boot time, any
>> >> >> other memory areas that are part of the panicked kernel's memory.
>> >> >> (see https://www.kernel.org/doc/Documentation/devicetree/bindings/chosen.txt
>> >> >> , for details)
>> >> >
>> >> > Right.
>> >> >
>> >> >> 1). Now when 'kexec -p' is executed, this node is patched up only
>> >> >> with the crashkernel memory range:
>> >> >>
>> >> >>                 /* add linux,usable-memory-range */
>> >> >>                 nodeoffset = fdt_path_offset(new_buf, "/chosen");
>> >> >>                 result = fdt_setprop_range(new_buf, nodeoffset,
>> >> >>                                 PROP_USABLE_MEM_RANGE, &crash_reserved_mem,
>> >> >>                                 address_cells, size_cells);
>> >> >>
>> >> >> (see https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git/tree/kexec/arch/arm64/kexec-arm64.c#n465
>> >> >> , for details)
>> >> >>
>> >> >> 2). This excludes the ACPI reclaim regions irrespective of whether
>> >> >> they are marked as System RAM or as RESERVED. As,
>> >> >> 'linux,usable-memory-range' dt node is patched up only with
>> >> >> 'crash_reserved_mem' and not 'system_memory_ranges'
>> >> >>
>> >> >> 3). As a result when the crashkernel boots up it doesn't find this
>> >> >> ACPI memory and crashes while trying to access the same:
>> >> >>
>> >> >> # kexec -p /boot/vmlinuz-`uname -r` --initrd=/boot/initramfs-`uname
>> >> >> -r`.img --reuse-cmdline -d
>> >> >>
>> >> >> [snip..]
>> >> >>
>> >> >> Reserved memory range
>> >> >> 000000000e800000-000000002e7fffff (0)
>> >> >>
>> >> >> Coredump memory ranges
>> >> >> 0000000000000000-000000000e7fffff (0)
>> >> >> 000000002e800000-000000003961ffff (0)
>> >> >> 0000000039d40000-000000003ed2ffff (0)
>> >> >> 000000003ed60000-000000003fbfffff (0)
>> >> >> 0000001040000000-0000001ffbffffff (0)
>> >> >> 0000002000000000-0000002ffbffffff (0)
>> >> >> 0000009000000000-0000009ffbffffff (0)
>> >> >> 000000a000000000-000000affbffffff (0)
>> >> >>
>> >> >> 4). So if we revert Ard's patch or just comment the fixing up of the
>> >> >> memory cap'ing passed to the crash kernel inside
>> >> >> 'arch/arm64/mm/init.c' (see below):
>> >> >>
>> >> >> static void __init fdt_enforce_memory_region(void)
>> >> >> {
>> >> >>         struct memblock_region reg = {
>> >> >>                 .size = 0,
>> >> >>         };
>> >> >>
>> >> >>         of_scan_flat_dt(early_init_dt_scan_usablemem, &reg);
>> >> >>
>> >> >>         if (reg.size)
>> >> >>                 //memblock_cap_memory_range(reg.base, reg.size); /*
>> >> >> comment this out */
>> >> >> }
>> >> >
>> >> > Please just don't do that. It can cause a fatal damage on
>> >> > memory contents of the *crashed* kernel.
>> >> >
>> >> >> 5). Both the above temporary solutions fix the problem.
>> >> >>
>> >> >> 6). However exposing all System RAM regions to the crashkernel is not
>> >> >> advisable and may cause the crashkernel or some crashkernel drivers to
>> >> >> fail.
>> >> >>
>> >> >> 6a). I am trying an approach now, where the ACPI reclaim regions are
>> >> >> added to '/proc/iomem' separately as ACPI reclaim regions by the
>> >> >> kernel code and on the other hand the user-space 'kexec-tools' will
>> >> >> pick up the ACPI reclaim regions from '/proc/iomem' and add it to the
>> >> >> dt node 'linux,usable-memory-range'
>> >> >
>> >> > I still don't understand why we need to carry over the information
>> >> > about "ACPI Reclaim memory" to crash dump kernel. In my understandings,
>> >> > such regions are free to be reused by the kernel after some point of
>> >> > initialization. Why does crash dump kernel need to know about them?
>> >> >
>> >>
>> >> Not really. According to the UEFI spec, they can be reclaimed after
>> >> the OS has initialized, i.e., when it has consumed the ACPI tables and
>> >> no longer needs them. Of course, in order to be able to boot a kexec
>> >> kernel, those regions needs to be preserved, which is why they are
>> >> memblock_reserve()'d now.
>> >
>> > For my better understandings, who is actually accessing such regions
>> > during boot time, uefi itself or efistub?
>> >
>>
>> No, only the kernel. This is where the ACPI tables are stored. For
>> instance, on QEMU we have
>>
>>  ACPI: RSDP 0x0000000078980000 000024 (v02 BOCHS )
>>  ACPI: XSDT 0x0000000078970000 000054 (v01 BOCHS  BXPCFACP 00000001
>>   01000013)
>>  ACPI: FACP 0x0000000078930000 00010C (v05 BOCHS  BXPCFACP 00000001
>> BXPC 00000001)
>>  ACPI: DSDT 0x0000000078940000 0011DA (v02 BOCHS  BXPCDSDT 00000001
>> BXPC 00000001)
>>  ACPI: APIC 0x0000000078920000 000140 (v03 BOCHS  BXPCAPIC 00000001
>> BXPC 00000001)
>>  ACPI: GTDT 0x0000000078910000 000060 (v02 BOCHS  BXPCGTDT 00000001
>> BXPC 00000001)
>>  ACPI: MCFG 0x0000000078900000 00003C (v01 BOCHS  BXPCMCFG 00000001
>> BXPC 00000001)
>>  ACPI: SPCR 0x00000000788F0000 000050 (v02 BOCHS  BXPCSPCR 00000001
>> BXPC 00000001)
>>  ACPI: IORT 0x00000000788E0000 00007C (v00 BOCHS  BXPCIORT 00000001
>> BXPC 00000001)
>>
>> covered by
>>
>>  efi:   0x0000788e0000-0x00007894ffff [ACPI Reclaim Memory ...]
>>  ...
>>  efi:   0x000078970000-0x00007898ffff [ACPI Reclaim Memory ...]
>
> OK. I mistakenly understood those regions could be freed after exiting
> UEFI boot services.
>
>>
>> >> So it seems that kexec does not honour the memblock_reserve() table
>> >> when booting the next kernel.
>> >
>> > not really.
>> >
>> >> > (In other words, can or should we skip some part of ACPI-related init code
>> >> > on crash dump kernel?)
>> >> >
>> >>
>> >> I don't think so. And the change to the handling of ACPI reclaim
>> >> regions only revealed the bug, not created it (given that other
>> >> memblock_reserve regions may be affected as well)
>> >
>> > As whether we should honor such reserved regions over kexec'ing
>> > depends on each one's specific nature, we will have to take care one-by-one.
>> > As a matter of fact, no information about "reserved" memblocks is
>> > exposed to user space (via proc/iomem).
>> >
>>
>> That is why I suggested (somewhere in this thread?) to not expose them
>> as 'System RAM'. Do you think that could solve this?
>
> Memblock-reserv'ing them is necessary to prevent their corruption and
> marking them under another name in /proc/iomem would also be good in order
> not to allocate them as part of crash kernel's memory.
>

I agree. However, this may not be entirely trivial, since iterating
over the memblock_reserved table and creating iomem entries may result
in collisions.

> But I'm not still convinced that we should export them in useable-
> memory-range to crash dump kernel. They will be accessed through
> acpi_os_map_memory() and so won't be required to be part of system ram
> (or memblocks), I guess.

Agreed. They will be covered by the linear mapping in the boot kernel,
and be mapped explicitly via ioremap_cache() in the kexec kernel,
which is exactly what we want in this case.

> Just FYI, on x86, ACPI tables seems to be exposed to crash dump kernel
> via a kernel command line parameter, "memmap=".
>
