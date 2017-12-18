From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to ACPI
 regions being no longer mapped as NOMAP
Date: Tue, 19 Dec 2017 02:58:20 +0530
Message-ID: <CACi5LpOmeEMuoCkTC7MrBDaA1J5a4vZ_7bh3HSC0G5GoAMUCjw@mail.gmail.com>
References: <CAFTCetQHmpprAVu6uYO+rc5Xi4EUVhmovbmSaU6nM1n1mAH62w@mail.gmail.com>
 <CAKv+Gu9oda1Ee8AoXsCEw+Bjn-XF3wZA_CsxvqhjtT6_bmJ7uA@mail.gmail.com>
 <CACi5LpOZ=WOx14gTwH5jfLozepT2Jw8JSY5x+bfEZ_YaiQvFpw@mail.gmail.com>
 <20171213102624.GC28046@linaro.org> <CAKv+Gu_BmFN9Zg861SCS+R=V4khFykjuOzkmfEknsL=NvWW3Eg@mail.gmail.com>
 <20171213121605.GE28046@linaro.org> <CAKv+Gu_G8kBEAdAznVauZVAdJOFkr1vmu0Gf6tOwJfH2CgdufA@mail.gmail.com>
 <20171215085924.sqlcwm4copzba5ag@fireball> <CAKv+Gu-W5VpVrgA=FVZCCevksaRGOVvPdE+B8WkpZc6AE1jOPw@mail.gmail.com>
 <CACi5LpPDL0j4o3MuOZ3jRv3UOqM48yTgKtdm-hY+OWL8h-ETzQ@mail.gmail.com> <20171218051657.GA5998@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20171218051657.GA5998@dhcp-128-65.nay.redhat.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, kexec@lists.infradead.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, James Morse <james.morse@arm.com>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

Hi Dave,

On Mon, Dec 18, 2017 at 10:46 AM, Dave Young <dyoung@redhat.com> wrote:
> kexec@fedoraproject... is for Fedora kexec scripts discussion, changed it
> to kexec@lists.infradead.org
>
> Also add linux-acpi list
> On 12/18/17 at 02:31am, Bhupesh Sharma wrote:
>> On Fri, Dec 15, 2017 at 3:05 PM, Ard Biesheuvel
>> <ard.biesheuvel@linaro.org> wrote:
>> > On 15 December 2017 at 09:59, AKASHI Takahiro
>> > <takahiro.akashi@linaro.org> wrote:
>> >> On Wed, Dec 13, 2017 at 12:17:22PM +0000, Ard Biesheuvel wrote:
>> >>> On 13 December 2017 at 12:16, AKASHI Takahiro
>> >>> <takahiro.akashi@linaro.org> wrote:
>> >>> > On Wed, Dec 13, 2017 at 10:49:27AM +0000, Ard Biesheuvel wrote:
>> >>> >> On 13 December 2017 at 10:26, AKASHI Takahiro
>> >>> >> <takahiro.akashi@linaro.org> wrote:
>> >>> >> > Bhupesh, Ard,
>> >>> >> >
>> >>> >> > On Wed, Dec 13, 2017 at 03:21:59AM +0530, Bhupesh Sharma wrote:
>> >>> >> >> Hi Ard, Akashi
>> >>> >> >>
>> >>> >> > (snip)
>> >>> >> >
>> >>> >> >> Looking deeper into the issue, since the arm64 kexec-tools uses the
>> >>> >> >> 'linux,usable-memory-range' dt property to allow crash dump kernel to
>> >>> >> >> identify its own usable memory and exclude, at its boot time, any
>> >>> >> >> other memory areas that are part of the panicked kernel's memory.
>> >>> >> >> (see https://www.kernel.org/doc/Documentation/devicetree/bindings/chosen.txt
>> >>> >> >> , for details)
>> >>> >> >
>> >>> >> > Right.
>> >>> >> >
>> >>> >> >> 1). Now when 'kexec -p' is executed, this node is patched up only
>> >>> >> >> with the crashkernel memory range:
>> >>> >> >>
>> >>> >> >>                 /* add linux,usable-memory-range */
>> >>> >> >>                 nodeoffset = fdt_path_offset(new_buf, "/chosen");
>> >>> >> >>                 result = fdt_setprop_range(new_buf, nodeoffset,
>> >>> >> >>                                 PROP_USABLE_MEM_RANGE, &crash_reserved_mem,
>> >>> >> >>                                 address_cells, size_cells);
>> >>> >> >>
>> >>> >> >> (see https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git/tree/kexec/arch/arm64/kexec-arm64.c#n465
>> >>> >> >> , for details)
>> >>> >> >>
>> >>> >> >> 2). This excludes the ACPI reclaim regions irrespective of whether
>> >>> >> >> they are marked as System RAM or as RESERVED. As,
>> >>> >> >> 'linux,usable-memory-range' dt node is patched up only with
>> >>> >> >> 'crash_reserved_mem' and not 'system_memory_ranges'
>> >>> >> >>
>> >>> >> >> 3). As a result when the crashkernel boots up it doesn't find this
>> >>> >> >> ACPI memory and crashes while trying to access the same:
>> >>> >> >>
>> >>> >> >> # kexec -p /boot/vmlinuz-`uname -r` --initrd=/boot/initramfs-`uname
>> >>> >> >> -r`.img --reuse-cmdline -d
>> >>> >> >>
>> >>> >> >> [snip..]
>> >>> >> >>
>> >>> >> >> Reserved memory range
>> >>> >> >> 000000000e800000-000000002e7fffff (0)
>> >>> >> >>
>> >>> >> >> Coredump memory ranges
>> >>> >> >> 0000000000000000-000000000e7fffff (0)
>> >>> >> >> 000000002e800000-000000003961ffff (0)
>> >>> >> >> 0000000039d40000-000000003ed2ffff (0)
>> >>> >> >> 000000003ed60000-000000003fbfffff (0)
>> >>> >> >> 0000001040000000-0000001ffbffffff (0)
>> >>> >> >> 0000002000000000-0000002ffbffffff (0)
>> >>> >> >> 0000009000000000-0000009ffbffffff (0)
>> >>> >> >> 000000a000000000-000000affbffffff (0)
>> >>> >> >>
>> >>> >> >> 4). So if we revert Ard's patch or just comment the fixing up of the
>> >>> >> >> memory cap'ing passed to the crash kernel inside
>> >>> >> >> 'arch/arm64/mm/init.c' (see below):
>> >>> >> >>
>> >>> >> >> static void __init fdt_enforce_memory_region(void)
>> >>> >> >> {
>> >>> >> >>         struct memblock_region reg = {
>> >>> >> >>                 .size = 0,
>> >>> >> >>         };
>> >>> >> >>
>> >>> >> >>         of_scan_flat_dt(early_init_dt_scan_usablemem, &reg);
>> >>> >> >>
>> >>> >> >>         if (reg.size)
>> >>> >> >>                 //memblock_cap_memory_range(reg.base, reg.size); /*
>> >>> >> >> comment this out */
>> >>> >> >> }
>> >>> >> >
>> >>> >> > Please just don't do that. It can cause a fatal damage on
>> >>> >> > memory contents of the *crashed* kernel.
>> >>> >> >
>> >>> >> >> 5). Both the above temporary solutions fix the problem.
>> >>> >> >>
>> >>> >> >> 6). However exposing all System RAM regions to the crashkernel is not
>> >>> >> >> advisable and may cause the crashkernel or some crashkernel drivers to
>> >>> >> >> fail.
>> >>> >> >>
>> >>> >> >> 6a). I am trying an approach now, where the ACPI reclaim regions are
>> >>> >> >> added to '/proc/iomem' separately as ACPI reclaim regions by the
>> >>> >> >> kernel code and on the other hand the user-space 'kexec-tools' will
>> >>> >> >> pick up the ACPI reclaim regions from '/proc/iomem' and add it to the
>> >>> >> >> dt node 'linux,usable-memory-range'
>> >>> >> >
>> >>> >> > I still don't understand why we need to carry over the information
>> >>> >> > about "ACPI Reclaim memory" to crash dump kernel. In my understandings,
>> >>> >> > such regions are free to be reused by the kernel after some point of
>> >>> >> > initialization. Why does crash dump kernel need to know about them?
>> >>> >> >
>> >>> >>
>> >>> >> Not really. According to the UEFI spec, they can be reclaimed after
>> >>> >> the OS has initialized, i.e., when it has consumed the ACPI tables and
>> >>> >> no longer needs them. Of course, in order to be able to boot a kexec
>> >>> >> kernel, those regions needs to be preserved, which is why they are
>> >>> >> memblock_reserve()'d now.
>> >>> >
>> >>> > For my better understandings, who is actually accessing such regions
>> >>> > during boot time, uefi itself or efistub?
>> >>> >
>> >>>
>> >>> No, only the kernel. This is where the ACPI tables are stored. For
>> >>> instance, on QEMU we have
>> >>>
>> >>>  ACPI: RSDP 0x0000000078980000 000024 (v02 BOCHS )
>> >>>  ACPI: XSDT 0x0000000078970000 000054 (v01 BOCHS  BXPCFACP 00000001
>> >>>   01000013)
>> >>>  ACPI: FACP 0x0000000078930000 00010C (v05 BOCHS  BXPCFACP 00000001
>> >>> BXPC 00000001)
>> >>>  ACPI: DSDT 0x0000000078940000 0011DA (v02 BOCHS  BXPCDSDT 00000001
>> >>> BXPC 00000001)
>> >>>  ACPI: APIC 0x0000000078920000 000140 (v03 BOCHS  BXPCAPIC 00000001
>> >>> BXPC 00000001)
>> >>>  ACPI: GTDT 0x0000000078910000 000060 (v02 BOCHS  BXPCGTDT 00000001
>> >>> BXPC 00000001)
>> >>>  ACPI: MCFG 0x0000000078900000 00003C (v01 BOCHS  BXPCMCFG 00000001
>> >>> BXPC 00000001)
>> >>>  ACPI: SPCR 0x00000000788F0000 000050 (v02 BOCHS  BXPCSPCR 00000001
>> >>> BXPC 00000001)
>> >>>  ACPI: IORT 0x00000000788E0000 00007C (v00 BOCHS  BXPCIORT 00000001
>> >>> BXPC 00000001)
>> >>>
>> >>> covered by
>> >>>
>> >>>  efi:   0x0000788e0000-0x00007894ffff [ACPI Reclaim Memory ...]
>> >>>  ...
>> >>>  efi:   0x000078970000-0x00007898ffff [ACPI Reclaim Memory ...]
>> >>
>> >> OK. I mistakenly understood those regions could be freed after exiting
>> >> UEFI boot services.
>> >>
>> >>>
>> >>> >> So it seems that kexec does not honour the memblock_reserve() table
>> >>> >> when booting the next kernel.
>> >>> >
>> >>> > not really.
>> >>> >
>> >>> >> > (In other words, can or should we skip some part of ACPI-related init code
>> >>> >> > on crash dump kernel?)
>> >>> >> >
>> >>> >>
>> >>> >> I don't think so. And the change to the handling of ACPI reclaim
>> >>> >> regions only revealed the bug, not created it (given that other
>> >>> >> memblock_reserve regions may be affected as well)
>> >>> >
>> >>> > As whether we should honor such reserved regions over kexec'ing
>> >>> > depends on each one's specific nature, we will have to take care one-by-one.
>> >>> > As a matter of fact, no information about "reserved" memblocks is
>> >>> > exposed to user space (via proc/iomem).
>> >>> >
>> >>>
>> >>> That is why I suggested (somewhere in this thread?) to not expose them
>> >>> as 'System RAM'. Do you think that could solve this?
>> >>
>> >> Memblock-reserv'ing them is necessary to prevent their corruption and
>> >> marking them under another name in /proc/iomem would also be good in order
>> >> not to allocate them as part of crash kernel's memory.
>> >>
>> >
>> > I agree. However, this may not be entirely trivial, since iterating
>> > over the memblock_reserved table and creating iomem entries may result
>> > in collisions.
>>
>> I found a method (using the patch I shared earlier in this thread) to mark these
>> entries as 'ACPI reclaim memory' ranges rather than System RAM or
>> reserved regions.
>>
>> >> But I'm not still convinced that we should export them in useable-
>> >> memory-range to crash dump kernel. They will be accessed through
>> >> acpi_os_map_memory() and so won't be required to be part of system ram
>> >> (or memblocks), I guess.
>> >
>> > Agreed. They will be covered by the linear mapping in the boot kernel,
>> > and be mapped explicitly via ioremap_cache() in the kexec kernel,
>> > which is exactly what we want in this case.
>>
>> Now this is what is confusing me. I don't see the above happening.
>>
>> I see that the primary kernel boots up and adds the ACPI regions via:
>> acpi_os_ioremap
>>     -> ioremap_cache
>>
>> But during the crashkernel boot, ''acpi_os_ioremap' calls
>> 'ioremap' for the ACPI Reclaim Memory regions and not the _cache
>> variant.
>>
>> And it fails while accessing the ACPI tables:
>>
>> [    0.039205] ACPI: Core revision 20170728
>> pud=000000002e7d0003, *pmd=000000002e7c0003, *pte=00e8000039710707
>> [    0.095098] Internal error: Oops: 96000021 [#1] SMP
>> [    0.100022] Modules linked in:
>> [    0.103102] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.0-rc6 #1
>> [    0.109432] task: ffff000008d05180 task.stack: ffff000008cc0000
>> [    0.115414] PC is at acpi_ns_lookup+0x25c/0x3c0
>> [    0.119987] LR is at acpi_ds_load1_begin_op+0xa4/0x294
>> [    0.125175] pc : [<ffff0000084a6764>] lr : [<ffff00000849b4f8>]
>> pstate: 60000045
>> [    0.132647] sp : ffff000008ccfb40
>> [    0.135989] x29: ffff000008ccfb40 x28: ffff000008a9f2a4
>> [    0.141354] x27: ffff0000088be820 x26: 0000000000000000
>> [    0.146718] x25: 000000000000001b x24: 0000000000000001
>> [    0.152083] x23: 0000000000000001 x22: ffff000009710027
>> [    0.157447] x21: ffff000008ccfc50 x20: 0000000000000001
>> [    0.162812] x19: 000000000000001b x18: 0000000000000005
>> [    0.168176] x17: 0000000000000000 x16: 0000000000000000
>> [    0.173541] x15: 0000000000000000 x14: 000000000000038e
>> [    0.178905] x13: ffffffff00000000 x12: ffffffffffffffff
>> [    0.184270] x11: 0000000000000006 x10: 00000000ffffff76
>> [    0.189634] x9 : 000000000000005f x8 : ffff8000126d0140
>> [    0.194998] x7 : 0000000000000000 x6 : ffff000008ccfc50
>> [    0.200362] x5 : ffff80000fe62c00 x4 : 0000000000000001
>> [    0.205727] x3 : ffff000008ccfbe0 x2 : ffff0000095e3980
>> [    0.211091] x1 : ffff000009710027 x0 : 0000000000000000
>> [    0.216456] Process swapper/0 (pid: 0, stack limit = 0xffff000008cc0000)
>> [    0.223224] Call trace:
>> [    0.225688] Exception stack(0xffff000008ccfa00 to 0xffff000008ccfb40)
>> [    0.232194] fa00: 0000000000000000 ffff000009710027
>> ffff0000095e3980 ffff000008ccfbe0
>> [    0.240106] fa20: 0000000000000001 ffff80000fe62c00
>> ffff000008ccfc50 0000000000000000
>> [    0.248018] fa40: ffff8000126d0140 000000000000005f
>> 00000000ffffff76 0000000000000006
>> [    0.255931] fa60: ffffffffffffffff ffffffff00000000
>> 000000000000038e 0000000000000000
>> [    0.263843] fa80: 0000000000000000 0000000000000000
>> 0000000000000005 000000000000001b
>> [    0.271754] faa0: 0000000000000001 ffff000008ccfc50
>> ffff000009710027 0000000000000001
>> [    0.279667] fac0: 0000000000000001 000000000000001b
>> 0000000000000000 ffff0000088be820
>> [    0.287579] fae0: ffff000008a9f2a4 ffff000008ccfb40
>> ffff00000849b4f8 ffff000008ccfb40
>> [    0.295491] fb00: ffff0000084a6764 0000000060000045
>> ffff000008ccfb40 ffff000008260a18
>> [    0.303403] fb20: ffffffffffffffff ffff0000087f3fb0
>> ffff000008ccfb40 ffff0000084a6764
>> [    0.311316] [<ffff0000084a6764>] acpi_ns_lookup+0x25c/0x3c0
>> [    0.316943] [<ffff00000849b4f8>] acpi_ds_load1_begin_op+0xa4/0x294
>> [    0.323186] [<ffff0000084ad4ac>] acpi_ps_build_named_op+0xc4/0x198
>> [    0.329428] [<ffff0000084ad6cc>] acpi_ps_create_op+0x14c/0x270
>> [    0.335319] [<ffff0000084acfa8>] acpi_ps_parse_loop+0x188/0x5c8
>> [    0.341298] [<ffff0000084ae048>] acpi_ps_parse_aml+0xb0/0x2b8
>> [    0.347101] [<ffff0000084a8e10>] acpi_ns_one_complete_parse+0x144/0x184
>> [    0.353783] [<ffff0000084a8e98>] acpi_ns_parse_table+0x48/0x68
>> [    0.359675] [<ffff0000084a82cc>] acpi_ns_load_table+0x4c/0xdc
>> [    0.365479] [<ffff0000084b32f8>] acpi_tb_load_namespace+0xe4/0x264
>> [    0.371723] [<ffff000008baf9b4>] acpi_load_tables+0x48/0xc0
>> [    0.377350] [<ffff000008badc20>] acpi_early_init+0x9c/0xd0
>> [    0.382891] [<ffff000008b70d50>] start_kernel+0x3b4/0x43c
>> [    0.388343] Code: b9008fb9 2a000318 36380054 32190318 (b94002c0)
>> [    0.394500] ---[ end trace c46ed37f9651c58e ]---
>> [    0.399160] Kernel panic - not syncing: Fatal exception
>> [    0.404437] Rebooting in 10 seconds.
>>
>> So, I think the linear mapping done by the primary kernel does not
>> make these accessible in the crash kernel directly.
>>
>> Any pointers?
>
> Can you get the code line number for acpi_ns_lookup+0x25c?

gdb points to the following code line number:

(gdb) list *(acpi_ns_lookup+0x25c)
0xffff0000084aa250 is in acpi_ns_lookup (drivers/acpi/acpica/nsaccess.c:577).
572                }
573            }
574
575            /* Extract one ACPI name from the front of the pathname */
576
577            ACPI_MOVE_32_TO_32(&simple_name, path);
578
579            /* Try to find the single (4 character) ACPI name */
580
581            status =
(gdb)

i.e. ACPI_MOVE_32_TO_32(&simple_name, path);

addr2line also confirms the same:

# addr2line -e  vmlinux ffff0000084aa250
/root/git/kernel-alt/drivers/acpi/acpica/nsaccess.c:577


Regards,
Bhupesh


>>
>> Regards,
>> Bhupesh
>>
>> >> Just FYI, on x86, ACPI tables seems to be exposed to crash dump kernel
>> >> via a kernel command line parameter, "memmap=".
>> >>
>> _______________________________________________
>> kexec mailing list -- kexec@lists.fedoraproject.org
>> To unsubscribe send an email to kexec-leave@lists.fedoraproject.org
