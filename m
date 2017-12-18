From: Bhupesh Sharma <bhsharma@redhat.com>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to ACPI
 regions being no longer mapped as NOMAP
Date: Tue, 19 Dec 2017 03:58:28 +0530
Message-ID: <CACi5LpP_acpMT8B7xAHVJF31b8PrSLUovdXRLMn2+OuOHv8TgQ@mail.gmail.com>
References: <20171213102624.GC28046@linaro.org> <CAKv+Gu_BmFN9Zg861SCS+R=V4khFykjuOzkmfEknsL=NvWW3Eg@mail.gmail.com>
 <20171213121605.GE28046@linaro.org> <CAKv+Gu_G8kBEAdAznVauZVAdJOFkr1vmu0Gf6tOwJfH2CgdufA@mail.gmail.com>
 <20171215085924.sqlcwm4copzba5ag@fireball> <CAKv+Gu-W5VpVrgA=FVZCCevksaRGOVvPdE+B8WkpZc6AE1jOPw@mail.gmail.com>
 <CACi5LpPDL0j4o3MuOZ3jRv3UOqM48yTgKtdm-hY+OWL8h-ETzQ@mail.gmail.com>
 <20171218051657.GA5998@dhcp-128-65.nay.redhat.com> <20171218055356.mq4coiibh3frii54@fireball>
 <CAFTCetQ55zUKe25jSku0DHp8uVZA4hB32d5W6MSCNsTVpxu7Gw@mail.gmail.com> <20171218111844.xyed3bel2wl6el3p@fireball>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171218111844.xyed3bel2wl6el3p@fireball>
Sender: linux-kernel-owner@vger.kernel.org
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Bhupesh SHARMA <bhupesh.linux@gmail.com>, Dave Young <dyoung@redhat.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kexec@lists.infradead.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, James Morse <james.morse@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On Mon, Dec 18, 2017 at 4:48 PM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> Bhupesh,
>
> On Mon, Dec 18, 2017 at 02:29:05PM +0530, Bhupesh SHARMA wrote:
>> On Mon, Dec 18, 2017 at 11:24 AM, AKASHI Takahiro
>> <takahiro.akashi@linaro.org> wrote:
>> > On Mon, Dec 18, 2017 at 01:16:57PM +0800, Dave Young wrote:
>> >> kexec@fedoraproject... is for Fedora kexec scripts discussion, changed it
>> >> to kexec@lists.infradead.org
>> >>
>> >> Also add linux-acpi list
>> >
>> > Thank you.
>> >
>> >> On 12/18/17 at 02:31am, Bhupesh Sharma wrote:
>> >> > On Fri, Dec 15, 2017 at 3:05 PM, Ard Biesheuvel
>> >> > <ard.biesheuvel@linaro.org> wrote:
>> >> > > On 15 December 2017 at 09:59, AKASHI Takahiro
>> >> > > <takahiro.akashi@linaro.org> wrote:
>> >> > >> On Wed, Dec 13, 2017 at 12:17:22PM +0000, Ard Biesheuvel wrote:
>> >> > >>> On 13 December 2017 at 12:16, AKASHI Takahiro
>> >> > >>> <takahiro.akashi@linaro.org> wrote:
>> >> > >>> > On Wed, Dec 13, 2017 at 10:49:27AM +0000, Ard Biesheuvel wrote:
>> >> > >>> >> On 13 December 2017 at 10:26, AKASHI Takahiro
>> >> > >>> >> <takahiro.akashi@linaro.org> wrote:
>> >> > >>> >> > Bhupesh, Ard,
>> >> > >>> >> >
>> >> > >>> >> > On Wed, Dec 13, 2017 at 03:21:59AM +0530, Bhupesh Sharma wrote:
>> >> > >>> >> >> Hi Ard, Akashi
>> >> > >>> >> >>
>> >> > >>> >> > (snip)
>> >> > >>> >> >
>> >> > >>> >> >> Looking deeper into the issue, since the arm64 kexec-tools uses the
>> >> > >>> >> >> 'linux,usable-memory-range' dt property to allow crash dump kernel to
>> >> > >>> >> >> identify its own usable memory and exclude, at its boot time, any
>> >> > >>> >> >> other memory areas that are part of the panicked kernel's memory.
>> >> > >>> >> >> (see https://www.kernel.org/doc/Documentation/devicetree/bindings/chosen.txt
>> >> > >>> >> >> , for details)
>> >> > >>> >> >
>> >> > >>> >> > Right.
>> >> > >>> >> >
>> >> > >>> >> >> 1). Now when 'kexec -p' is executed, this node is patched up only
>> >> > >>> >> >> with the crashkernel memory range:
>> >> > >>> >> >>
>> >> > >>> >> >>                 /* add linux,usable-memory-range */
>> >> > >>> >> >>                 nodeoffset = fdt_path_offset(new_buf, "/chosen");
>> >> > >>> >> >>                 result = fdt_setprop_range(new_buf, nodeoffset,
>> >> > >>> >> >>                                 PROP_USABLE_MEM_RANGE, &crash_reserved_mem,
>> >> > >>> >> >>                                 address_cells, size_cells);
>> >> > >>> >> >>
>> >> > >>> >> >> (see https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git/tree/kexec/arch/arm64/kexec-arm64.c#n465
>> >> > >>> >> >> , for details)
>> >> > >>> >> >>
>> >> > >>> >> >> 2). This excludes the ACPI reclaim regions irrespective of whether
>> >> > >>> >> >> they are marked as System RAM or as RESERVED. As,
>> >> > >>> >> >> 'linux,usable-memory-range' dt node is patched up only with
>> >> > >>> >> >> 'crash_reserved_mem' and not 'system_memory_ranges'
>> >> > >>> >> >>
>> >> > >>> >> >> 3). As a result when the crashkernel boots up it doesn't find this
>> >> > >>> >> >> ACPI memory and crashes while trying to access the same:
>> >> > >>> >> >>
>> >> > >>> >> >> # kexec -p /boot/vmlinuz-`uname -r` --initrd=/boot/initramfs-`uname
>> >> > >>> >> >> -r`.img --reuse-cmdline -d
>> >> > >>> >> >>
>> >> > >>> >> >> [snip..]
>> >> > >>> >> >>
>> >> > >>> >> >> Reserved memory range
>> >> > >>> >> >> 000000000e800000-000000002e7fffff (0)
>> >> > >>> >> >>
>> >> > >>> >> >> Coredump memory ranges
>> >> > >>> >> >> 0000000000000000-000000000e7fffff (0)
>> >> > >>> >> >> 000000002e800000-000000003961ffff (0)
>> >> > >>> >> >> 0000000039d40000-000000003ed2ffff (0)
>> >> > >>> >> >> 000000003ed60000-000000003fbfffff (0)
>> >> > >>> >> >> 0000001040000000-0000001ffbffffff (0)
>> >> > >>> >> >> 0000002000000000-0000002ffbffffff (0)
>> >> > >>> >> >> 0000009000000000-0000009ffbffffff (0)
>> >> > >>> >> >> 000000a000000000-000000affbffffff (0)
>> >> > >>> >> >>
>> >> > >>> >> >> 4). So if we revert Ard's patch or just comment the fixing up of the
>> >> > >>> >> >> memory cap'ing passed to the crash kernel inside
>> >> > >>> >> >> 'arch/arm64/mm/init.c' (see below):
>> >> > >>> >> >>
>> >> > >>> >> >> static void __init fdt_enforce_memory_region(void)
>> >> > >>> >> >> {
>> >> > >>> >> >>         struct memblock_region reg = {
>> >> > >>> >> >>                 .size = 0,
>> >> > >>> >> >>         };
>> >> > >>> >> >>
>> >> > >>> >> >>         of_scan_flat_dt(early_init_dt_scan_usablemem, &reg);
>> >> > >>> >> >>
>> >> > >>> >> >>         if (reg.size)
>> >> > >>> >> >>                 //memblock_cap_memory_range(reg.base, reg.size); /*
>> >> > >>> >> >> comment this out */
>> >> > >>> >> >> }
>> >> > >>> >> >
>> >> > >>> >> > Please just don't do that. It can cause a fatal damage on
>> >> > >>> >> > memory contents of the *crashed* kernel.
>> >> > >>> >> >
>> >> > >>> >> >> 5). Both the above temporary solutions fix the problem.
>> >> > >>> >> >>
>> >> > >>> >> >> 6). However exposing all System RAM regions to the crashkernel is not
>> >> > >>> >> >> advisable and may cause the crashkernel or some crashkernel drivers to
>> >> > >>> >> >> fail.
>> >> > >>> >> >>
>> >> > >>> >> >> 6a). I am trying an approach now, where the ACPI reclaim regions are
>> >> > >>> >> >> added to '/proc/iomem' separately as ACPI reclaim regions by the
>> >> > >>> >> >> kernel code and on the other hand the user-space 'kexec-tools' will
>> >> > >>> >> >> pick up the ACPI reclaim regions from '/proc/iomem' and add it to the
>> >> > >>> >> >> dt node 'linux,usable-memory-range'
>> >> > >>> >> >
>> >> > >>> >> > I still don't understand why we need to carry over the information
>> >> > >>> >> > about "ACPI Reclaim memory" to crash dump kernel. In my understandings,
>> >> > >>> >> > such regions are free to be reused by the kernel after some point of
>> >> > >>> >> > initialization. Why does crash dump kernel need to know about them?
>> >> > >>> >> >
>> >> > >>> >>
>> >> > >>> >> Not really. According to the UEFI spec, they can be reclaimed after
>> >> > >>> >> the OS has initialized, i.e., when it has consumed the ACPI tables and
>> >> > >>> >> no longer needs them. Of course, in order to be able to boot a kexec
>> >> > >>> >> kernel, those regions needs to be preserved, which is why they are
>> >> > >>> >> memblock_reserve()'d now.
>> >> > >>> >
>> >> > >>> > For my better understandings, who is actually accessing such regions
>> >> > >>> > during boot time, uefi itself or efistub?
>> >> > >>> >
>> >> > >>>
>> >> > >>> No, only the kernel. This is where the ACPI tables are stored. For
>> >> > >>> instance, on QEMU we have
>> >> > >>>
>> >> > >>>  ACPI: RSDP 0x0000000078980000 000024 (v02 BOCHS )
>> >> > >>>  ACPI: XSDT 0x0000000078970000 000054 (v01 BOCHS  BXPCFACP 00000001
>> >> > >>>   01000013)
>> >> > >>>  ACPI: FACP 0x0000000078930000 00010C (v05 BOCHS  BXPCFACP 00000001
>> >> > >>> BXPC 00000001)
>> >> > >>>  ACPI: DSDT 0x0000000078940000 0011DA (v02 BOCHS  BXPCDSDT 00000001
>> >> > >>> BXPC 00000001)
>> >> > >>>  ACPI: APIC 0x0000000078920000 000140 (v03 BOCHS  BXPCAPIC 00000001
>> >> > >>> BXPC 00000001)
>> >> > >>>  ACPI: GTDT 0x0000000078910000 000060 (v02 BOCHS  BXPCGTDT 00000001
>> >> > >>> BXPC 00000001)
>> >> > >>>  ACPI: MCFG 0x0000000078900000 00003C (v01 BOCHS  BXPCMCFG 00000001
>> >> > >>> BXPC 00000001)
>> >> > >>>  ACPI: SPCR 0x00000000788F0000 000050 (v02 BOCHS  BXPCSPCR 00000001
>> >> > >>> BXPC 00000001)
>> >> > >>>  ACPI: IORT 0x00000000788E0000 00007C (v00 BOCHS  BXPCIORT 00000001
>> >> > >>> BXPC 00000001)
>> >> > >>>
>> >> > >>> covered by
>> >> > >>>
>> >> > >>>  efi:   0x0000788e0000-0x00007894ffff [ACPI Reclaim Memory ...]
>> >> > >>>  ...
>> >> > >>>  efi:   0x000078970000-0x00007898ffff [ACPI Reclaim Memory ...]
>> >> > >>
>> >> > >> OK. I mistakenly understood those regions could be freed after exiting
>> >> > >> UEFI boot services.
>> >> > >>
>> >> > >>>
>> >> > >>> >> So it seems that kexec does not honour the memblock_reserve() table
>> >> > >>> >> when booting the next kernel.
>> >> > >>> >
>> >> > >>> > not really.
>> >> > >>> >
>> >> > >>> >> > (In other words, can or should we skip some part of ACPI-related init code
>> >> > >>> >> > on crash dump kernel?)
>> >> > >>> >> >
>> >> > >>> >>
>> >> > >>> >> I don't think so. And the change to the handling of ACPI reclaim
>> >> > >>> >> regions only revealed the bug, not created it (given that other
>> >> > >>> >> memblock_reserve regions may be affected as well)
>> >> > >>> >
>> >> > >>> > As whether we should honor such reserved regions over kexec'ing
>> >> > >>> > depends on each one's specific nature, we will have to take care one-by-one.
>> >> > >>> > As a matter of fact, no information about "reserved" memblocks is
>> >> > >>> > exposed to user space (via proc/iomem).
>> >> > >>> >
>> >> > >>>
>> >> > >>> That is why I suggested (somewhere in this thread?) to not expose them
>> >> > >>> as 'System RAM'. Do you think that could solve this?
>> >> > >>
>> >> > >> Memblock-reserv'ing them is necessary to prevent their corruption and
>> >> > >> marking them under another name in /proc/iomem would also be good in order
>> >> > >> not to allocate them as part of crash kernel's memory.
>> >> > >>
>> >> > >
>> >> > > I agree. However, this may not be entirely trivial, since iterating
>> >> > > over the memblock_reserved table and creating iomem entries may result
>> >> > > in collisions.
>> >> >
>> >> > I found a method (using the patch I shared earlier in this thread) to mark these
>> >> > entries as 'ACPI reclaim memory' ranges rather than System RAM or
>> >> > reserved regions.
>> >> >
>> >> > >> But I'm not still convinced that we should export them in useable-
>> >> > >> memory-range to crash dump kernel. They will be accessed through
>> >> > >> acpi_os_map_memory() and so won't be required to be part of system ram
>> >> > >> (or memblocks), I guess.
>> >> > >
>> >> > > Agreed. They will be covered by the linear mapping in the boot kernel,
>> >> > > and be mapped explicitly via ioremap_cache() in the kexec kernel,
>> >> > > which is exactly what we want in this case.
>> >> >
>> >> > Now this is what is confusing me. I don't see the above happening.
>> >> >
>> >> > I see that the primary kernel boots up and adds the ACPI regions via:
>> >> > acpi_os_ioremap
>> >> >     -> ioremap_cache
>> >> >
>> >> > But during the crashkernel boot, ''acpi_os_ioremap' calls
>> >> > 'ioremap' for the ACPI Reclaim Memory regions and not the _cache
>> >> > variant.
>> >
>> > It is natural if that region is out of memblocks.
>>
>> Thanks for the confirmation. This was my understanding as well.
>>
>> >> > And it fails while accessing the ACPI tables:
>> >> >
>> >> > [    0.039205] ACPI: Core revision 20170728
>> >> > pud=000000002e7d0003, *pmd=000000002e7c0003, *pte=00e8000039710707
>> >> > [    0.095098] Internal error: Oops: 96000021 [#1] SMP
>> >
>> > this (ESR = 0x96000021) means that Data Abort and Alignment fault happened.
>> > As ioremap() makes the mapping as "Device memory", unaligned memory
>> > access won't be allowed.
>> >
>> >> > [    0.100022] Modules linked in:
>> >> > [    0.103102] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.0-rc6 #1
>> >> > [    0.109432] task: ffff000008d05180 task.stack: ffff000008cc0000
>> >> > [    0.115414] PC is at acpi_ns_lookup+0x25c/0x3c0
>> >> > [    0.119987] LR is at acpi_ds_load1_begin_op+0xa4/0x294
>> >> > [    0.125175] pc : [<ffff0000084a6764>] lr : [<ffff00000849b4f8>]
>> >> > pstate: 60000045
>> >> > [    0.132647] sp : ffff000008ccfb40
>> >> > [    0.135989] x29: ffff000008ccfb40 x28: ffff000008a9f2a4
>> >> > [    0.141354] x27: ffff0000088be820 x26: 0000000000000000
>> >> > [    0.146718] x25: 000000000000001b x24: 0000000000000001
>> >> > [    0.152083] x23: 0000000000000001 x22: ffff000009710027
>> >> > [    0.157447] x21: ffff000008ccfc50 x20: 0000000000000001
>> >> > [    0.162812] x19: 000000000000001b x18: 0000000000000005
>> >> > [    0.168176] x17: 0000000000000000 x16: 0000000000000000
>> >> > [    0.173541] x15: 0000000000000000 x14: 000000000000038e
>> >> > [    0.178905] x13: ffffffff00000000 x12: ffffffffffffffff
>> >> > [    0.184270] x11: 0000000000000006 x10: 00000000ffffff76
>> >> > [    0.189634] x9 : 000000000000005f x8 : ffff8000126d0140
>> >> > [    0.194998] x7 : 0000000000000000 x6 : ffff000008ccfc50
>> >> > [    0.200362] x5 : ffff80000fe62c00 x4 : 0000000000000001
>> >> > [    0.205727] x3 : ffff000008ccfbe0 x2 : ffff0000095e3980
>> >> > [    0.211091] x1 : ffff000009710027 x0 : 0000000000000000
>> >> > [    0.216456] Process swapper/0 (pid: 0, stack limit = 0xffff000008cc0000)
>> >> > [    0.223224] Call trace:
>> >> > [    0.225688] Exception stack(0xffff000008ccfa00 to 0xffff000008ccfb40)
>> >> > [    0.232194] fa00: 0000000000000000 ffff000009710027
>> >> > ffff0000095e3980 ffff000008ccfbe0
>> >> > [    0.240106] fa20: 0000000000000001 ffff80000fe62c00
>> >> > ffff000008ccfc50 0000000000000000
>> >> > [    0.248018] fa40: ffff8000126d0140 000000000000005f
>> >> > 00000000ffffff76 0000000000000006
>> >> > [    0.255931] fa60: ffffffffffffffff ffffffff00000000
>> >> > 000000000000038e 0000000000000000
>> >> > [    0.263843] fa80: 0000000000000000 0000000000000000
>> >> > 0000000000000005 000000000000001b
>> >> > [    0.271754] faa0: 0000000000000001 ffff000008ccfc50
>> >> > ffff000009710027 0000000000000001
>> >> > [    0.279667] fac0: 0000000000000001 000000000000001b
>> >> > 0000000000000000 ffff0000088be820
>> >> > [    0.287579] fae0: ffff000008a9f2a4 ffff000008ccfb40
>> >> > ffff00000849b4f8 ffff000008ccfb40
>> >> > [    0.295491] fb00: ffff0000084a6764 0000000060000045
>> >> > ffff000008ccfb40 ffff000008260a18
>> >> > [    0.303403] fb20: ffffffffffffffff ffff0000087f3fb0
>> >> > ffff000008ccfb40 ffff0000084a6764
>> >> > [    0.311316] [<ffff0000084a6764>] acpi_ns_lookup+0x25c/0x3c0
>> >> > [    0.316943] [<ffff00000849b4f8>] acpi_ds_load1_begin_op+0xa4/0x294
>> >> > [    0.323186] [<ffff0000084ad4ac>] acpi_ps_build_named_op+0xc4/0x198
>> >> > [    0.329428] [<ffff0000084ad6cc>] acpi_ps_create_op+0x14c/0x270
>> >> > [    0.335319] [<ffff0000084acfa8>] acpi_ps_parse_loop+0x188/0x5c8
>> >> > [    0.341298] [<ffff0000084ae048>] acpi_ps_parse_aml+0xb0/0x2b8
>> >> > [    0.347101] [<ffff0000084a8e10>] acpi_ns_one_complete_parse+0x144/0x184
>> >> > [    0.353783] [<ffff0000084a8e98>] acpi_ns_parse_table+0x48/0x68
>> >> > [    0.359675] [<ffff0000084a82cc>] acpi_ns_load_table+0x4c/0xdc
>> >> > [    0.365479] [<ffff0000084b32f8>] acpi_tb_load_namespace+0xe4/0x264
>> >> > [    0.371723] [<ffff000008baf9b4>] acpi_load_tables+0x48/0xc0
>> >> > [    0.377350] [<ffff000008badc20>] acpi_early_init+0x9c/0xd0
>> >> > [    0.382891] [<ffff000008b70d50>] start_kernel+0x3b4/0x43c
>> >> > [    0.388343] Code: b9008fb9 2a000318 36380054 32190318 (b94002c0)
>> >> > [    0.394500] ---[ end trace c46ed37f9651c58e ]---
>> >> > [    0.399160] Kernel panic - not syncing: Fatal exception
>> >> > [    0.404437] Rebooting in 10 seconds.
>> >> >
>> >> > So, I think the linear mapping done by the primary kernel does not
>> >> > make these accessible in the crash kernel directly.
>> >> >
>> >> > Any pointers?
>> >>
>> >> Can you get the code line number for acpi_ns_lookup+0x25c?
>> >
>> > So should we always avoid ioremap() in acpi_os_ioremap() entirely, or
>> > modify acpi_ns_lookup() (or any acpi functions') to prevent unaligned
>> > accesses?
>> > (I didn't find out how unaligned accesses could happen there.)
>> >
>>
>> Right. Like I captured somewhere in this thread (perhaps the first
>> email on this subject),
>> this is indeed an unaligned address access.
>>
>> Now, modifying acpi_os_ioremap() to not ioremap() and thus avoiding
>> assigning this memory range
>> as device memory doesn't seem a neat solution as it means we are not
>> marking some thing with the right memory attribute and we can fall in
>> similar/related issues later.
>>
>> Regarding the later suggestion, what I am seeing now is that the acpi
>> table access functions are perhaps reused from the earlier x86
>> implementation, but on the arm64 (or even arm) arch we should not be
>> allowing unaligned accesses which might cause UNDEFINED behaviour and
>> resultant crash.
>>
>> So I can try going this approach and see if it works for me.
>>
>> However, I am still not very sure as to why the crashkernel ranges
>> historically do not include the System RAM regions (which may include
>> the ACPI regions as well). These regions are available for the kernel
>> usage and perhaps should be exported to the crashkernel as well.
>>
>> I am not fully aware of the previous discussions on capp'ing the
>> crashkernel memory being passed to the kdump kernel, but did we run
>> into any issues while doing so?
>>
>> Also, even if I extend the kexec-tools to modify the
>> linux,usable-memory-range and add the ACPI regions to it, the
>> crashkernel fails to boot with the below message (I have added some
>> logic to print the DTB on the crash kernel boot start):
>>
>> [    0.000000]     chosen {
>> [    0.000000]         linux,usable-memory-range
>> [    0.000000]  = <
>> [    0.000000] 0x00000000
>> [    0.000000] 0x0e800000
>> [    0.000000] 0x00000000
>> [    0.000000] 0x20000000
>> [    0.000000] 0x00000000
>> [    0.000000] 0x396c0000
>> [    0.000000] 0x00000000
>> [    0.000000] 0x000a0000
>> [    0.000000] 0x00000000
>> [    0.000000] 0x39770000
>> [    0.000000] 0x00000000
>> [    0.000000] 0x00040000
>> [    0.000000] 0x00000000
>> [    0.000000] 0x398a0000
>> [    0.000000] 0x00000000
>> [    0.000000] 0x00020000
>> [    0.000000] >
>> [    0.000000] ;
>>
>> [snip..]
>>
>> [    0.000000] linux,usable-memory-range base e800000, size 20000000
>> [    0.000000]  - e800000 ,  20000000
>> [    0.000000] linux,usable-memory-range base 396c0000, size a0000
>> [    0.000000]  - 396c0000 ,  a0000
>> [    0.000000] linux,usable-memory-range base 39770000, size 40000
>> [    0.000000]  - 39770000 ,  40000
>> [    0.000000] linux,usable-memory-range base 398a0000, size 20000
>> [    0.000000]  - 398a0000 ,  20000
>> [    0.000000] initrd not fully accessible via the linear mapping --
>> please check your bootloader ...
>> [    0.000000] ------------[ cut here ]------------
>> [    0.000000] WARNING: CPU: 0 PID: 0 at arch/arm64/mm/init.c:597
>> arm64_memblock_init+0x210/0x484
>> [    0.000000] Modules linked in:
>> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.14.0+ #7
>> [    0.000000] task: ffff000008d05580 task.stack: ffff000008cc0000
>> [    0.000000] PC is at arm64_memblock_init+0x210/0x484
>> [    0.000000] LR is at arm64_memblock_init+0x210/0x484
>> [    0.000000] pc : [<ffff000008b76984>] lr : [<ffff000008b76984>]
>> pstate: 600000c5
>> [    0.000000] sp : ffff000008ccfe80
>> [    0.000000] x29: ffff000008ccfe80 x28: 000000000f370018
>> [    0.000000] x27: 0000000011230000 x26: 00000000013b0000
>> [    0.000000] x25: 000000000fe80000 x24: ffff000008cf3000
>> [    0.000000] x23: ffff000008ec0000 x22: ffff000009680000
>> [    0.000000] x21: ffff000008afa000 x20: ffff000008080000
>> [    0.000000] x19: ffff000008afa000 x18: 000000000c283806
>> [    0.000000] x17: 0000000000000000 x16: ffff000008d05580
>> [    0.000000] x15: 000000002be00842 x14: 79206b6365686320
>> [    0.000000] x13: 657361656c70202d x12: 2d20676e69707061
>> [    0.000000] x11: 6d207261656e696c x10: 2065687420616976
>> [    0.000000] x9 : 00000000000000f4 x8 : ffff000008517414
>> [    0.000000] x7 : 746f6f622072756f x6 : 000000000000000d
>> [    0.000000] x5 : ffff000008c96360 x4 : 0000000000000001
>> [    0.000000] x3 : 0000000000000000 x2 : 0000000000000000
>> [    0.000000] x1 : 0000000000000000 x0 : 0000000000000056
>> [    0.000000] Call trace:
>> [    0.000000] Exception stack(0xffff000008ccfd40 to 0xffff000008ccfe80)
>> [    0.000000] fd40: 0000000000000056 0000000000000000
>> 0000000000000000 0000000000000000
>> [    0.000000] fd60: 0000000000000001 ffff000008c96360
>> 000000000000000d 746f6f622072756f
>> [    0.000000] fd80: ffff000008517414 00000000000000f4
>> 2065687420616976 6d207261656e696c
>> [    0.000000] fda0: 2d20676e69707061 657361656c70202d
>> 79206b6365686320 000000002be00842
>> [    0.000000] fdc0: ffff000008d05580 0000000000000000
>> 000000000c283806 ffff000008afa000
>> [    0.000000] fde0: ffff000008080000 ffff000008afa000
>> ffff000009680000 ffff000008ec0000
>> [    0.000000] fe00: ffff000008cf3000 000000000fe80000
>> 00000000013b0000 0000000011230000
>> [    0.000000] fe20: 000000000f370018 ffff000008ccfe80
>> ffff000008b76984 ffff000008ccfe80
>> [    0.000000] fe40: ffff000008b76984 00000000600000c5
>> ffff00000959b7a8 ffff000008ec0000
>> [    0.000000] fe60: ffffffffffffffff 0000000000000005
>> ffff000008ccfe80 ffff000008b76984
>> [    0.000000] [<ffff000008b76984>] arm64_memblock_init+0x210/0x484
>> [    0.000000] [<ffff000008b7398c>] setup_arch+0x1b8/0x5f4
>> [    0.000000] [<ffff000008b70a10>] start_kernel+0x74/0x43c
>> [    0.000000] random: get_random_bytes called from
>> print_oops_end_marker+0x50/0x6c with crng_init=0
>> [    0.000000] ---[ end trace 0000000000000000 ]---
>> [    0.000000] Reserving 4KB of memory at 0x2e7f0000 for elfcorehdr
>> [    0.000000] cma: Failed to reserve 512 MiB
>> [    0.000000] Kernel panic - not syncing: ERROR: Failed to allocate
>> 0x0000000000010000 bytes below 0x0000000000000000.
>> [    0.000000]
>> [    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W
>> ------------   4.14.0+ #7
>> [    0.000000] Call trace:
>> [    0.000000] [<ffff000008088da8>] dump_backtrace+0x0/0x23c
>> [    0.000000] [<ffff000008089008>] show_stack+0x24/0x2c
>> [    0.000000] [<ffff0000087f647c>] dump_stack+0x84/0xa8
>> [    0.000000] [<ffff0000080cfd44>] panic+0x138/0x2a0
>> [    0.000000] [<ffff000008b95c88>] memblock_alloc_base+0x44/0x4c
>> [    0.000000] [<ffff000008b95cbc>] memblock_alloc+0x2c/0x38
>> [    0.000000] [<ffff000008b772dc>] early_pgtable_alloc+0x20/0x74
>> [    0.000000] [<ffff000008b7755c>] paging_init+0x28/0x544
>> [    0.000000] [<ffff000008b73990>] setup_arch+0x1bc/0x5f4
>> [    0.000000] [<ffff000008b70a10>] start_kernel+0x74/0x43c
>> [    0.000000] ---[ end Kernel panic - not syncing: ERROR: Failed to
>> allocate 0x0000000000010000 bytes below 0x0000000000000000.
>> [    0.000000]
>>
>> I guess it is because of the 1G alignment requirement between the
>> kernel image and the initrd and how we populate the holes between the
>> kernel image, segments (including dtb) and the initrd from the
>> kexec-tools.
>>
>> Akashi, any pointers on this will be helpful as well.
>
> Please show me:
>  * "Virtual kernel memory layout" in dmesg
>  * /proc/iomem
>  * debug messages from kexec-tools (kexec -d)

So here are the changes which I have done so far in the kernel and
kexec-tools to allow mapping ACPI reclaim regions as identifiable
regions in '/proc/iomem' and to append them to the DTB property:
linux,usable-memory-range:

Linux patch: <https://github.com/bhupesh-sharma/linux/commit/88d2ff6a1c16f5aa107b567a9d9c60343e52f263>,
and

<https://github.com/bhupesh-sharma/linux/commit/23262febd29a6665d483a707a05f8869757b8848>

kexec-tools patch:
<https://github.com/bhupesh-sharma/kexec-tools/commit/3e3d7c50648b1195674d1b7667cbbfd8d899b650>

Note that I am not very clear about the hole margins that the
kexec-tools adds (so that the crashkernel's expectation that the
kernel image and initrd lie within a 1G boundary), so I have not added
my temporary changes to the github code - but any suggestions on how
to correctly put them in place would be appreciated.

And here are the rest of the inputs you asked for:

(1) # dmesg | grep -A 15 -B 4 -i "Virtual kernel memory layout"

[    0.000000] Kernel command line:
BOOT_IMAGE=/vmlinuz-4.15.0-rc2-next-20171207+
root=/dev/mapper/rhelaa_huawei--t2280--01-root ro
earlycon=pl011,mmio,0x602B0000 efi=debug memblock_debug=1
pcie_aspm=off crashkernel=512M rd.lvm.lv=rhelaa_huawei-t2280-01/root
rd.lvm.lv=rhelaa_huawei-t2280-01/swap acpi=force
console=ttyAMA0,115200
[    0.000000] PCIe ASPM is disabled
[    0.000000] software IO TLB [mem 0x35620000-0x39620000] (64MB)
mapped at [        (ptrval)-        (ptrval)]
[    0.000000] Memory: 267251520K/268169216K available (7868K kernel
code, 1764K rwdata, 3328K rodata, 1280K init, 7727K bss, 917696K
reserved, 0K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000
(   128 MB)
[    0.000000]     vmalloc : 0xffff000008000000 - 0xffff7bdfffff0000
(126847 GB)
[    0.000000]       .text : 0x        (ptrval) - 0x        (ptrval)
(  7872 KB)
[    0.000000]     .rodata : 0x        (ptrval) - 0x        (ptrval)
(  3392 KB)
[    0.000000]       .init : 0x        (ptrval) - 0x        (ptrval)
(  1280 KB)
[    0.000000]       .data : 0x        (ptrval) - 0x        (ptrval)
(  1765 KB)
[    0.000000]        .bss : 0x        (ptrval) - 0x        (ptrval)
(  7728 KB)
[    0.000000]     fixed   : 0xffff7fdffe7b0000 - 0xffff7fdffec00000
(  4416 KB)
[    0.000000]     PCI I/O : 0xffff7fdffee00000 - 0xffff7fdfffe00000
(    16 MB)
[    0.000000]     vmemmap : 0xffff7fe000000000 - 0xffff800000000000
(   128 GB maximum)
[    0.000000]               0xffff7fe000000000 - 0xffff7fe02bff0000
(   703 MB actual)
[    0.000000]     memory  : 0xffff800000000000 - 0xffff80affc000000
(720832 MB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=64, Nodes=4
[    0.000000] ftrace: allocating 29903 entries in 8 pages
[    0.000000] Hierarchical RCU implementation.

(2) # cat /proc/iomem
00000000-3961ffff : System RAM
  00080000-00b7ffff : Kernel code
  00cc0000-0166ffff : Kernel data
  0e800000-2e7fffff : Crash kernel
39620000-396bffff : reserved
396c0000-3975ffff : ACPI reclaim region
39760000-3976ffff : reserved
39770000-397affff : ACPI reclaim region
397b0000-3989ffff : reserved
398a0000-398bffff : ACPI reclaim region
398c0000-39d3ffff : reserved
39d40000-3ed2ffff : System RAM
3ed30000-3ed5ffff : reserved
3ed60000-3fbfffff : System RAM
40500000-40500fff : sbsa-gwdt.0
  40500000-40500fff : sbsa-gwdt.0
40600000-40600fff : sbsa-gwdt.0
  40600000-40600fff : sbsa-gwdt.0
60080000-6008ffff : HISI0152:00
602b0000-602b0fff : ARMH0011:00
  602b0000-602b0fff : ARMH0011:00
603c0000-603cffff : HISI0141:00
  603c0000-603cffff : HISI0141:00
a0080000-a008ffff : HISI0152:05
  a0080000-a008ffff : HISI0152:04
    a0080000-a008ffff : HISI0152:03
a00a0000-a00affff : pnp 00:01
a01b0000-a01b0fff : HISI0191:00
a2000000-a200ffff : HISI0162:01
  a2000000-a200ffff : HISI0162:01
a3000000-a300ffff : HISI0162:02
  a3000000-a300ffff : HISI0162:02
a7020000-a702ffff : PNP0D20:00
  a7020000-a702ffff : PNP0D20:00
b0000000-be7fffff : PCI Bus 0002:e8
  b0000000-b06fffff : PCI Bus 0002:e9
    b0000000-b00fffff : 0002:e9:00.0
      b0000000-b00fffff : igb
    b0100000-b01fffff : 0002:e9:00.0
    b0200000-b02fffff : 0002:e9:00.1
      b0200000-b02fffff : igb
    b0300000-b03fffff : 0002:e9:00.1
    b0400000-b04fffff : 0002:e9:00.2
      b0400000-b04fffff : igb
    b0500000-b05fffff : 0002:e9:00.3
      b0500000-b05fffff : igb
    b0600000-b0603fff : 0002:e9:00.0
      b0600000-b0603fff : igb
    b0604000-b0607fff : 0002:e9:00.1
      b0604000-b0607fff : igb
    b0608000-b060bfff : 0002:e9:00.2
      b0608000-b060bfff : igb
    b060c000-b060ffff : 0002:e9:00.3
      b060c000-b060ffff : igb
  b0700000-b0afffff : PCI Bus 0002:e9
    b0700000-b077ffff : 0002:e9:00.0
    b0780000-b07fffff : 0002:e9:00.0
    b0800000-b087ffff : 0002:e9:00.1
    b0880000-b08fffff : 0002:e9:00.1
    b0900000-b097ffff : 0002:e9:00.2
    b0980000-b09fffff : 0002:e9:00.2
    b0a00000-b0a7ffff : 0002:e9:00.3
    b0a80000-b0afffff : 0002:e9:00.3
  b0b00000-b0b0ffff : 0002:e8:00.0
be800000-beffffff : PCI ECAM
c0080000-c008ffff : HISI0152:02
  c0080000-c008ffff : HISI0152:01
c3000000-c300ffff : HISI0162:00
  c3000000-c300ffff : HISI0162:00
c5000000-c588ffff : HISI00B2:00
  c5000000-c588ffff : HISI00B2:00
c7000000-c705ffff : HISI00B2:00
  c7000000-c705ffff : HISI00B2:00
d0080000-d008ffff : HISI0152:07
  d0080000-d008ffff : HISI0152:06
d0100000-d010ffff : HISI02A1:00
  d0100000-d010ffff : HISI02A1:00
400000000-4007fffff : PCI ECAM
440000000-4ffffffff : PCI Bus 0005:00
  440000000-4407fffff : PCI Bus 0005:01
    440000000-4403fffff : 0005:01:00.0
    440400000-4407fffff : 0005:01:00.1
  440800000-4421fffff : PCI Bus 0005:01
    440800000-440bfffff : 0005:01:00.0
      440800000-440bfffff : ixgbe
    440c00000-440ffffff : 0005:01:00.1
      440c00000-440ffffff : ixgbe
    441000000-4413fffff : 0005:01:00.0
    441400000-4417fffff : 0005:01:00.0
    441800000-441bfffff : 0005:01:00.1
    441c00000-441ffffff : 0005:01:00.1
    442000000-442003fff : 0005:01:00.0
      442000000-442003fff : ixgbe
    442004000-442007fff : 0005:01:00.1
      442004000-442007fff : ixgbe
  442200000-442200fff : 0005:00:00.0
700090000-70009ffff : pnp 00:03
7000a0000-7000affff : pnp 00:05
7000b0000-7000bffff : pnp 00:06
700200000-70020ffff : pnp 00:04
740800000-740ffffff : PCI ECAM
741000000-77ffeffff : PCI Bus 0006:08
  741000000-74100ffff : 0006:08:00.0
784000000-7847fffff : PCI ECAM
784800000-7bffeffff : PCI Bus 0007:40
  784800000-7849fffff : PCI Bus 0007:41
    784800000-7849fffff : 0007:41:00.0
  786000000-787ffffff : PCI Bus 0007:41
    786000000-787ffffff : 0007:41:00.0
7c4800000-7c4ffffff : PCI ECAM
7c5000000-7fffeffff : PCI Bus 0004:48
  7c5000000-7c51fffff : PCI Bus 0004:49
    7c5000000-7c50fffff : 0004:49:00.0
    7c5100000-7c513ffff : 0004:49:00.0
      7c5100000-7c513ffff : mpt3sas
    7c5140000-7c514ffff : 0004:49:00.0
      7c5140000-7c514ffff : mpt3sas
  7c5200000-7c520ffff : 0004:48:00.0
1040000000-1ffbffffff : System RAM
2000000000-2ffbffffff : System RAM
9000000000-9ffbffffff : System RAM
a000000000-affbffffff : System RAM
400c0080000-400c008ffff : HISI0152:08
600a00a0000-600a00affff : pnp 00:08
64001000000-64001ffffff : PCI ECAM
65040000000-650ffffffff : PCI Bus 000a:10
  65040000000-6504000ffff : 000a:10:00.0
700a0090000-700a009ffff : pnp 00:0a
700a0200000-700a020ffff : pnp 00:0b
74002000000-74002ffffff : PCI ECAM
75040000000-750ffffffff : PCI Bus 000c:20
  75040000000-7504000ffff : 000c:20:00.0
78003000000-78003ffffff : PCI ECAM
79040000000-790ffffffff : PCI Bus 000d:30
  79040000000-79040000fff : 000d:30:00.0

(3)

# kexec -p /boot/vmlinuz-`uname -r` --initrd=/boot/initramfs-`uname
-r`.img --reuse-cmdline -d
arch_process_options:149: command_line:
root=/dev/mapper/rhelaa_huawei--t2280--01-root ro
earlycon=pl011,mmio,0x602B0000 efi=debug memblock_debug=1
pcie_aspm=off rd.lvm.lv=rhelaa_huawei-t2280-01/root
rd.lvm.lv=rhelaa_huawei-t2280-01/swap acpi=force
console=ttyAMA0,115200
arch_process_options:151: initrd: /boot/initramfs-4.15.0-rc2-next-20171207+.img
arch_process_options:152: dtb: (null)
Try gzip decompression.
kernel: 0xffff968d0010 kernel_size: 0xdf9200
get_memory_ranges_iomem_cb: 0000000000000000 - 000000003961ffff : System RAM
get_memory_ranges_iomem_cb: 0000000039620000 - 00000000396bffff : reserved
get_memory_ranges_iomem_cb: 0000000039760000 - 000000003976ffff : reserved
get_memory_ranges_iomem_cb: 00000000397b0000 - 000000003989ffff : reserved
get_memory_ranges_iomem_cb: 00000000398c0000 - 0000000039d3ffff : reserved
get_memory_ranges_iomem_cb: 0000000039d40000 - 000000003ed2ffff : System RAM
get_memory_ranges_iomem_cb: 000000003ed30000 - 000000003ed5ffff : reserved
get_memory_ranges_iomem_cb: 000000003ed60000 - 000000003fbfffff : System RAM
get_memory_ranges_iomem_cb: 0000001040000000 - 0000001ffbffffff : System RAM
get_memory_ranges_iomem_cb: 0000002000000000 - 0000002ffbffffff : System RAM
get_memory_ranges_iomem_cb: 0000009000000000 - 0000009ffbffffff : System RAM
get_memory_ranges_iomem_cb: 000000a000000000 - 000000affbffffff : System RAM
elf_arm64_probe: Not an ELF executable.
image_arm64_load: kernel_segment: 000000000e800000
image_arm64_load: text_offset:    0000000000080000
image_arm64_load: image_size:     00000000015f0000
image_arm64_load: phys_offset:    0000000000000000
image_arm64_load: vp_offset:      ffffffffffffffff
image_arm64_load: PE format:      yes
Reserved memory range
000000000e800000-000000002e7fffff (0)
Coredump memory ranges
0000000000000000-000000000e7fffff (0)
000000002e800000-000000003961ffff (0)
0000000039d40000-000000003ed2ffff (0)
000000003ed60000-000000003fbfffff (0)
0000001040000000-0000001ffbffffff (0)
0000002000000000-0000002ffbffffff (0)
0000009000000000-0000009ffbffffff (0)
000000a000000000-000000affbffffff (0)
ACPI reclaim memory ranges
00000000396c0000-000000003975ffff (0)
0000000039770000-00000000397affff (0)
00000000398a0000-00000000398bffff (0)
crashkernel memory ranges
000000000e800000-000000002e7fffff (0)
00000000396c0000-000000003975ffff (0)
0000000039770000-00000000397affff (0)
00000000398a0000-00000000398bffff (0)
kernel symbol _text vaddr = ffff000008080000
load_crashdump_segments: page_offset:   ffff800000000000
get_crash_notes_per_cpu: crash_notes addr = 1ff7cf3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7cf3200 p_paddr = 0x1ff7cf3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7d23200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7d23200 p_paddr = 0x1ff7d23200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7d53200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7d53200 p_paddr = 0x1ff7d53200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7d83200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7d83200 p_paddr = 0x1ff7d83200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7db3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7db3200 p_paddr = 0x1ff7db3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7de3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7de3200 p_paddr = 0x1ff7de3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7e13200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7e13200 p_paddr = 0x1ff7e13200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7e43200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7e43200 p_paddr = 0x1ff7e43200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7e73200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7e73200 p_paddr = 0x1ff7e73200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7ea3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7ea3200 p_paddr = 0x1ff7ea3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7ed3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7ed3200 p_paddr = 0x1ff7ed3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7f03200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7f03200 p_paddr = 0x1ff7f03200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7f33200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7f33200 p_paddr = 0x1ff7f33200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7f63200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7f63200 p_paddr = 0x1ff7f63200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7f93200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7f93200 p_paddr = 0x1ff7f93200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7fc3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7fc3200 p_paddr = 0x1ff7fc3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7d13200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7d13200 p_paddr = 0x2ff7d13200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7d43200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7d43200 p_paddr = 0x2ff7d43200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7d73200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7d73200 p_paddr = 0x2ff7d73200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7da3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7da3200 p_paddr = 0x2ff7da3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7dd3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7dd3200 p_paddr = 0x2ff7dd3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7e03200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7e03200 p_paddr = 0x2ff7e03200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7e33200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7e33200 p_paddr = 0x2ff7e33200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7e63200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7e63200 p_paddr = 0x2ff7e63200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7e93200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7e93200 p_paddr = 0x2ff7e93200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7ec3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7ec3200 p_paddr = 0x2ff7ec3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7ef3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7ef3200 p_paddr = 0x2ff7ef3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7f23200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7f23200 p_paddr = 0x2ff7f23200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7f53200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7f53200 p_paddr = 0x2ff7f53200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7f83200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7f83200 p_paddr = 0x2ff7f83200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7fb3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7fb3200 p_paddr = 0x2ff7fb3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7fe3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7fe3200 p_paddr = 0x2ff7fe3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7d03200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7d03200 p_paddr = 0x9ff7d03200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7d33200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7d33200 p_paddr = 0x9ff7d33200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7d63200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7d63200 p_paddr = 0x9ff7d63200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7d93200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7d93200 p_paddr = 0x9ff7d93200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7dc3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7dc3200 p_paddr = 0x9ff7dc3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7df3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7df3200 p_paddr = 0x9ff7df3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7e23200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7e23200 p_paddr = 0x9ff7e23200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7e53200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7e53200 p_paddr = 0x9ff7e53200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7e83200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7e83200 p_paddr = 0x9ff7e83200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7eb3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7eb3200 p_paddr = 0x9ff7eb3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7ee3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7ee3200 p_paddr = 0x9ff7ee3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7f13200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7f13200 p_paddr = 0x9ff7f13200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7f43200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7f43200 p_paddr = 0x9ff7f43200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7f73200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7f73200 p_paddr = 0x9ff7f73200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7fa3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7fa3200 p_paddr = 0x9ff7fa3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7fd3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7fd3200 p_paddr = 0x9ff7fd3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7883200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7883200 p_paddr = 0xaff7883200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff78b3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff78b3200 p_paddr = 0xaff78b3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff78e3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff78e3200 p_paddr = 0xaff78e3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7913200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7913200 p_paddr = 0xaff7913200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7943200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7943200 p_paddr = 0xaff7943200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7973200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7973200 p_paddr = 0xaff7973200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff79a3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff79a3200 p_paddr = 0xaff79a3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff79d3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff79d3200 p_paddr = 0xaff79d3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7a03200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7a03200 p_paddr = 0xaff7a03200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7a33200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7a33200 p_paddr = 0xaff7a33200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7a63200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7a63200 p_paddr = 0xaff7a63200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7a93200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7a93200 p_paddr = 0xaff7a93200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7ac3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7ac3200 p_paddr = 0xaff7ac3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7af3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7af3200 p_paddr = 0xaff7af3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7b23200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7b23200 p_paddr = 0xaff7b23200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7b53200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7b53200 p_paddr = 0xaff7b53200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
vmcoreinfo header: p_type = 4, p_offset = 0x9fc4720000 p_paddr =
0x9fc4720000 p_vaddr = 0x0 p_filesz = 0x10024 p_memsz = 0x10024
Kernel text Elf header: p_type = 1, p_offset = 0x80000 p_paddr =
0x80000 p_vaddr = 0xffff000008080000 p_filesz = 0x15f0000 p_memsz =
0x15f0000
Elf header: p_type = 1, p_offset = 0x0 p_paddr = 0x0 p_vaddr =
0xffff800000000000 p_filesz = 0xe800000 p_memsz = 0xe800000
Elf header: p_type = 1, p_offset = 0x2e800000 p_paddr = 0x2e800000
p_vaddr = 0xffff80002e800000 p_filesz = 0xae20000 p_memsz = 0xae20000
Elf header: p_type = 1, p_offset = 0x39d40000 p_paddr = 0x39d40000
p_vaddr = 0xffff800039d40000 p_filesz = 0x4ff0000 p_memsz = 0x4ff0000
Elf header: p_type = 1, p_offset = 0x3ed60000 p_paddr = 0x3ed60000
p_vaddr = 0xffff80003ed60000 p_filesz = 0xea0000 p_memsz = 0xea0000
Elf header: p_type = 1, p_offset = 0x1040000000 p_paddr = 0x1040000000
p_vaddr = 0xffff801040000000 p_filesz = 0xfbc000000 p_memsz =
0xfbc000000
Elf header: p_type = 1, p_offset = 0x2000000000 p_paddr = 0x2000000000
p_vaddr = 0xffff802000000000 p_filesz = 0xffc000000 p_memsz =
0xffc000000
Elf header: p_type = 1, p_offset = 0x9000000000 p_paddr = 0x9000000000
p_vaddr = 0xffff809000000000 p_filesz = 0xffc000000 p_memsz =
0xffc000000
Elf header: p_type = 1, p_offset = 0xa000000000 p_paddr = 0xa000000000
p_vaddr = 0xffff80a000000000 p_filesz = 0xffc000000 p_memsz =
0xffc000000
get_crash_notes_per_cpu: crash_notes addr = 1ff7cf3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7cf3200 p_paddr = 0x1ff7cf3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7d23200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7d23200 p_paddr = 0x1ff7d23200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7d53200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7d53200 p_paddr = 0x1ff7d53200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7d83200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7d83200 p_paddr = 0x1ff7d83200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7db3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7db3200 p_paddr = 0x1ff7db3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7de3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7de3200 p_paddr = 0x1ff7de3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7e13200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7e13200 p_paddr = 0x1ff7e13200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7e43200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7e43200 p_paddr = 0x1ff7e43200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7e73200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7e73200 p_paddr = 0x1ff7e73200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7ea3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7ea3200 p_paddr = 0x1ff7ea3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7ed3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7ed3200 p_paddr = 0x1ff7ed3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7f03200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7f03200 p_paddr = 0x1ff7f03200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7f33200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7f33200 p_paddr = 0x1ff7f33200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7f63200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7f63200 p_paddr = 0x1ff7f63200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7f93200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7f93200 p_paddr = 0x1ff7f93200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 1ff7fc3200, size = 424
Elf header: p_type = 4, p_offset = 0x1ff7fc3200 p_paddr = 0x1ff7fc3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7d13200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7d13200 p_paddr = 0x2ff7d13200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7d43200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7d43200 p_paddr = 0x2ff7d43200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7d73200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7d73200 p_paddr = 0x2ff7d73200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7da3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7da3200 p_paddr = 0x2ff7da3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7dd3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7dd3200 p_paddr = 0x2ff7dd3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7e03200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7e03200 p_paddr = 0x2ff7e03200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7e33200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7e33200 p_paddr = 0x2ff7e33200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7e63200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7e63200 p_paddr = 0x2ff7e63200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7e93200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7e93200 p_paddr = 0x2ff7e93200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7ec3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7ec3200 p_paddr = 0x2ff7ec3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7ef3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7ef3200 p_paddr = 0x2ff7ef3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7f23200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7f23200 p_paddr = 0x2ff7f23200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7f53200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7f53200 p_paddr = 0x2ff7f53200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7f83200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7f83200 p_paddr = 0x2ff7f83200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7fb3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7fb3200 p_paddr = 0x2ff7fb3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 2ff7fe3200, size = 424
Elf header: p_type = 4, p_offset = 0x2ff7fe3200 p_paddr = 0x2ff7fe3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7d03200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7d03200 p_paddr = 0x9ff7d03200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7d33200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7d33200 p_paddr = 0x9ff7d33200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7d63200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7d63200 p_paddr = 0x9ff7d63200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7d93200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7d93200 p_paddr = 0x9ff7d93200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7dc3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7dc3200 p_paddr = 0x9ff7dc3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7df3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7df3200 p_paddr = 0x9ff7df3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7e23200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7e23200 p_paddr = 0x9ff7e23200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7e53200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7e53200 p_paddr = 0x9ff7e53200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7e83200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7e83200 p_paddr = 0x9ff7e83200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7eb3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7eb3200 p_paddr = 0x9ff7eb3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7ee3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7ee3200 p_paddr = 0x9ff7ee3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7f13200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7f13200 p_paddr = 0x9ff7f13200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7f43200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7f43200 p_paddr = 0x9ff7f43200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7f73200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7f73200 p_paddr = 0x9ff7f73200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7fa3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7fa3200 p_paddr = 0x9ff7fa3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = 9ff7fd3200, size = 424
Elf header: p_type = 4, p_offset = 0x9ff7fd3200 p_paddr = 0x9ff7fd3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7883200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7883200 p_paddr = 0xaff7883200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff78b3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff78b3200 p_paddr = 0xaff78b3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff78e3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff78e3200 p_paddr = 0xaff78e3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7913200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7913200 p_paddr = 0xaff7913200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7943200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7943200 p_paddr = 0xaff7943200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7973200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7973200 p_paddr = 0xaff7973200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff79a3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff79a3200 p_paddr = 0xaff79a3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff79d3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff79d3200 p_paddr = 0xaff79d3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7a03200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7a03200 p_paddr = 0xaff7a03200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7a33200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7a33200 p_paddr = 0xaff7a33200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7a63200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7a63200 p_paddr = 0xaff7a63200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7a93200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7a93200 p_paddr = 0xaff7a93200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7ac3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7ac3200 p_paddr = 0xaff7ac3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7af3200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7af3200 p_paddr = 0xaff7af3200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7b23200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7b23200 p_paddr = 0xaff7b23200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
get_crash_notes_per_cpu: crash_notes addr = aff7b53200, size = 424
Elf header: p_type = 4, p_offset = 0xaff7b53200 p_paddr = 0xaff7b53200
p_vaddr = 0x0 p_filesz = 0x1a8 p_memsz = 0x1a8
vmcoreinfo header: p_type = 4, p_offset = 0x9fc4720000 p_paddr =
0x9fc4720000 p_vaddr = 0x0 p_filesz = 0x10024 p_memsz = 0x10024
Kernel text Elf header: p_type = 1, p_offset = 0x80000 p_paddr =
0x80000 p_vaddr = 0xffff000008080000 p_filesz = 0x15f0000 p_memsz =
0x15f0000
Elf header: p_type = 1, p_offset = 0x396c0000 p_paddr = 0x396c0000
p_vaddr = 0xffff8000396c0000 p_filesz = 0xa0000 p_memsz = 0xa0000
Elf header: p_type = 1, p_offset = 0x39770000 p_paddr = 0x39770000
p_vaddr = 0xffff800039770000 p_filesz = 0x40000 p_memsz = 0x40000
Elf header: p_type = 1, p_offset = 0x398a0000 p_paddr = 0x398a0000
p_vaddr = 0xffff8000398a0000 p_filesz = 0x20000 p_memsz = 0x20000
load_crashdump_segments: elfcorehdr 0x2e7f0000-0x2e7f0fff
read_1st_dtb: found /sys/firmware/fdt
get_cells_size: #address-cells:2 #size-cells:2
cells_size_fitted: 2e7f0000-2e7f0fff
cells_size_fitted: e800000-2e7fffff
cells_size_fitted: 396c0000-3975ffff
cells_size_fitted: 39770000-397affff
cells_size_fitted: 398a0000-398bffff
 / {
    #size-cells = <0x00000002>;
    #address-cells = <0x00000002>;
    chosen {
        linux,usable-memory-range = <0x00000000 0x0e800000 0x00000000
0x20000000 0x00000000 0x396c0000 0x00000000 0x000a0000 0x00000000
0x39770000 0x00000000 0x00040000 0x00000000 0x398a0000 0x00000000
0x00020000>;
        linux,elfcorehdr = <0x00000000 0x2e7f0000 0x00000000 0x00001000>;
        linux,uefi-mmap-desc-ver = <0x00000001>;
        linux,uefi-mmap-desc-size = <0x00000030>;
        linux,uefi-mmap-size = <0x00000e40>;
        linux,uefi-mmap-start = <0x00000000 0x30288018>;
        linux,uefi-system-table = <0x00000000 0x3ed50018>;
        bootargs = "root=/dev/mapper/rhelaa_huawei--t2280--01-root ro
earlycon=pl011,mmio,0x602B0000 efi=debug memblock_debug=1
pcie_aspm=off rd.lvm.lv=rhelaa_huawei-t2280-01/root
rd.lvm.lv=rhelaa_huawei-t2280-01/swap acpi=force
console=ttyAMA0,115200";
        linux,initrd-end = <0x00000000 0x2fbff9e0>;
        linux,initrd-start = <0x00000000 0x2e84d000>;
    };
 };
initrd: base fe70000, size 13b29e0h (20654560), end 112229e0

[snip..]

sym: sha256_starts info: 12 other: 00 shndx: 1 value: eb0 size: 6c
sym: sha256_starts value: 11240eb0 addr: 11240018
machine_apply_elf_rel: CALL26 580006b394000000->580006b3940003a6
sym: sha256_update info: 12 other: 00 shndx: 1 value: 5158 size: c
sym: sha256_update value: 11245158 addr: 11240034
machine_apply_elf_rel: CALL26 9100427394000000->9100427394001449
sym: sha256_finish info: 12 other: 00 shndx: 1 value: 5164 size: 1cc
sym: sha256_finish value: 11245164 addr: 11240050
machine_apply_elf_rel: CALL26 aa1403e094000000->aa1403e094001445
sym:     memcmp info: 12 other: 00 shndx: 1 value: 634 size: 34
sym: memcmp value: 11240634 addr: 11240060
machine_apply_elf_rel: CALL26 340003c094000000->340003c094000175
sym:     printf info: 12 other: 00 shndx: 1 value: 544 size: 90
sym: printf value: 11240544 addr: 11240070
machine_apply_elf_rel: CALL26 5800046094000000->5800046094000135
sym:     printf info: 12 other: 00 shndx: 1 value: 544 size: 90
sym: printf value: 11240544 addr: 11240078
machine_apply_elf_rel: CALL26 5800047594000000->5800047594000133
sym:     printf info: 12 other: 00 shndx: 1 value: 544 size: 90
sym: printf value: 11240544 addr: 11240088
machine_apply_elf_rel: CALL26 9100067394000000->910006739400012f
sym:     printf info: 12 other: 00 shndx: 1 value: 544 size: 90
sym: printf value: 11240544 addr: 112400a8
machine_apply_elf_rel: CALL26 5800036094000000->5800036094000127
sym:     printf info: 12 other: 00 shndx: 1 value: 544 size: 90
sym: printf value: 11240544 addr: 112400b0
machine_apply_elf_rel: CALL26 910402e194000000->910402e194000125
sym:     printf info: 12 other: 00 shndx: 1 value: 544 size: 90
sym: printf value: 11240544 addr: 112400c0
machine_apply_elf_rel: CALL26 9100067394000000->9100067394000121
sym:     printf info: 12 other: 00 shndx: 1 value: 544 size: 90
sym: printf value: 11240544 addr: 112400d4
machine_apply_elf_rel: CALL26 5280002094000000->528000209400011c
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 112453a8 addr: 112400f0
machine_apply_elf_rel: ABS64 0000000000000000->00000000112453a8
sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.1 value: 11245338 addr: 112400f8
machine_apply_elf_rel: ABS64 0000000000000000->0000000011245338
sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.1 value: 11245358 addr: 11240100
machine_apply_elf_rel: ABS64 0000000000000000->0000000011245358
sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.1 value: 11245368 addr: 11240108
machine_apply_elf_rel: ABS64 0000000000000000->0000000011245368
sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.1 value: 1124536e addr: 11240110
machine_apply_elf_rel: ABS64 0000000000000000->000000001124536e
sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.1 value: 11245370 addr: 11240118
machine_apply_elf_rel: ABS64 0000000000000000->0000000011245370
sym:     printf info: 12 other: 00 shndx: 1 value: 544 size: 90
sym: printf value: 11240544 addr: 1124012c
machine_apply_elf_rel: CALL26 9400000094000000->9400000094000106
sym: setup_arch info: 12 other: 00 shndx: 1 value: ea8 size: 4
sym: setup_arch value: 11240ea8 addr: 11240130
machine_apply_elf_rel: CALL26 9400000094000000->940000009400035e
sym: verify_sha256_digest info: 12 other: 00 shndx: 1 value: 0 size: f0
sym: verify_sha256_digest value: 11240000 addr: 11240134
machine_apply_elf_rel: CALL26 3400004094000000->3400004097ffffb3
sym: post_verification_setup_arch info: 12 other: 00 shndx: 1 value: ea4 size: 4
sym: post_verification_setup_arch value: 11240ea4 addr: 11240144
machine_apply_elf_rel: JUMP26 0000000014000000->0000000014000358
sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.1 value: 11245380 addr: 11240148
machine_apply_elf_rel: ABS64 0000000000000000->0000000011245380
sym:    putchar info: 12 other: 00 shndx: 1 value: ea0 size: 4
sym: putchar value: 11240ea0 addr: 112401ac
machine_apply_elf_rel: CALL26 f94037a194000000->f94037a19400033d
sym:    putchar info: 12 other: 00 shndx: 1 value: ea0 size: 4
sym: putchar value: 11240ea0 addr: 11240220
machine_apply_elf_rel: CALL26 910006f794000000->910006f794000320
sym:    putchar info: 12 other: 00 shndx: 1 value: ea0 size: 4
sym: putchar value: 11240ea0 addr: 11240478
machine_apply_elf_rel: CALL26 9100073994000000->910007399400028a
sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.1 value: 11245392 addr: 112404b8
machine_apply_elf_rel: ABS64 0000000000000000->0000000011245392
sym:   vsprintf info: 12 other: 00 shndx: 1 value: 150 size: 364
sym: vsprintf value: 11240150 addr: 11240538
machine_apply_elf_rel: CALL26 a8d07bfd94000000->a8d07bfd97ffff06
sym:   vsprintf info: 12 other: 00 shndx: 1 value: 150 size: 364
sym: vsprintf value: 11240150 addr: 112405c8
machine_apply_elf_rel: CALL26 a8d17bfd94000000->a8d17bfd97fffee2
sym:  purgatory info: 12 other: 00 shndx: 1 value: 120 size: 28
sym: purgatory value: 11240120 addr: 11240678
machine_apply_elf_rel: CALL26 5800001194000000->5800001197fffeaa
sym: arm64_kernel_entry info: 10 other: 00 shndx: 4 value: 120 size: 8
sym: arm64_kernel_entry value: 112454c8 addr: 1124067c
machine_apply_elf_rel: LD_PREL_LO19 5800000058000011->5800000058027271
sym: arm64_dtb_addr info: 10 other: 00 shndx: 4 value: 128 size: 8
sym: arm64_dtb_addr value: 112454d0 addr: 11240680
machine_apply_elf_rel: LD_PREL_LO19 aa1f03e158000000->aa1f03e158027280
sym: sha256_process info: 12 other: 00 shndx: 1 value: f1c size: 4134
sym: sha256_process value: 11240f1c addr: 112450bc
machine_apply_elf_rel: CALL26 d101029494000000->d101029497ffef98
sym:     memcpy info: 12 other: 00 shndx: 1 value: 614 size: 20
sym: memcpy value: 11240614 addr: 11245118
machine_apply_elf_rel: JUMP26 b4fffc5814000000->b4fffc5817ffed3f
sym:     memcpy info: 12 other: 00 shndx: 1 value: 614 size: 20
sym: memcpy value: 11240614 addr: 11245130
machine_apply_elf_rel: CALL26 aa1503e094000000->aa1503e097ffed39
sym: sha256_process info: 12 other: 00 shndx: 1 value: f1c size: 4134
sym: sha256_process value: 11240f1c addr: 1124513c
machine_apply_elf_rel: CALL26 cb1302d694000000->cb1302d697ffef78
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 112454d8 addr: 11245330
machine_apply_elf_rel: ABS64 0000000000000000->00000000112454d8
kexec_load: entry = 0x11240670 flags = 0xb70001
nr_segments = 5
segment[0].buf   = 0xffff968d0010
segment[0].bufsz = 0xdf9200
segment[0].mem   = 0xe880000
segment[0].memsz = 0x15f0000
segment[1].buf   = 0xffff950e0010
segment[1].bufsz = 0x13b29e0
segment[1].mem   = 0xfe70000
segment[1].memsz = 0x13c0000
segment[2].buf   = 0x1115b440
segment[2].bufsz = 0x33d
segment[2].mem   = 0x11230000
segment[2].memsz = 0x10000
segment[3].buf   = 0x1115bb70
segment[3].bufsz = 0x5518
segment[3].mem   = 0x11240000
segment[3].memsz = 0x10000
segment[4].buf   = 0x11159ca0
segment[4].bufsz = 0x1000
segment[4].mem   = 0x2e7f0000
segment[4].memsz = 0x10000

Regards,
Bhupesh

>
>
>> Regards,
>> Bhupesh
>>
>>
>> >> >
>> >> > Regards,
>> >> > Bhupesh
>> >> >
>> >> > >> Just FYI, on x86, ACPI tables seems to be exposed to crash dump kernel
>> >> > >> via a kernel command line parameter, "memmap=".
>> >> > >>
>> >> > _______________________________________________
>> >> > kexec mailing list -- kexec@lists.fedoraproject.org
>> >> > To unsubscribe send an email to kexec-leave@lists.fedoraproject.org
