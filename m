From: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: arm64 crashkernel fails to boot on acpi-only machines due to
 ACPI regions being no longer mapped as NOMAP
Date: Mon, 18 Dec 2017 20:18:50 +0900
Message-ID: <20171218111844.xyed3bel2wl6el3p@fireball>
References: <20171213102624.GC28046@linaro.org>
 <CAKv+Gu_BmFN9Zg861SCS+R=V4khFykjuOzkmfEknsL=NvWW3Eg@mail.gmail.com>
 <20171213121605.GE28046@linaro.org>
 <CAKv+Gu_G8kBEAdAznVauZVAdJOFkr1vmu0Gf6tOwJfH2CgdufA@mail.gmail.com>
 <20171215085924.sqlcwm4copzba5ag@fireball>
 <CAKv+Gu-W5VpVrgA=FVZCCevksaRGOVvPdE+B8WkpZc6AE1jOPw@mail.gmail.com>
 <CACi5LpPDL0j4o3MuOZ3jRv3UOqM48yTgKtdm-hY+OWL8h-ETzQ@mail.gmail.com>
 <20171218051657.GA5998@dhcp-128-65.nay.redhat.com>
 <20171218055356.mq4coiibh3frii54@fireball>
 <CAFTCetQ55zUKe25jSku0DHp8uVZA4hB32d5W6MSCNsTVpxu7Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFTCetQ55zUKe25jSku0DHp8uVZA4hB32d5W6MSCNsTVpxu7Gw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Bhupesh,

On Mon, Dec 18, 2017 at 02:29:05PM +0530, Bhupesh SHARMA wrote:
> On Mon, Dec 18, 2017 at 11:24 AM, AKASHI Takahiro
> <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> > On Mon, Dec 18, 2017 at 01:16:57PM +0800, Dave Young wrote:
> >> kexec@fedoraproject... is for Fedora kexec scripts discussion, changed it
> >> to kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> >>
> >> Also add linux-acpi list
> >
> > Thank you.
> >
> >> On 12/18/17 at 02:31am, Bhupesh Sharma wrote:
> >> > On Fri, Dec 15, 2017 at 3:05 PM, Ard Biesheuvel
> >> > <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> >> > > On 15 December 2017 at 09:59, AKASHI Takahiro
> >> > > <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> >> > >> On Wed, Dec 13, 2017 at 12:17:22PM +0000, Ard Biesheuvel wrote:
> >> > >>> On 13 December 2017 at 12:16, AKASHI Takahiro
> >> > >>> <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> >> > >>> > On Wed, Dec 13, 2017 at 10:49:27AM +0000, Ard Biesheuvel wrote:
> >> > >>> >> On 13 December 2017 at 10:26, AKASHI Takahiro
> >> > >>> >> <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> >> > >>> >> > Bhupesh, Ard,
> >> > >>> >> >
> >> > >>> >> > On Wed, Dec 13, 2017 at 03:21:59AM +0530, Bhupesh Sharma wrote:
> >> > >>> >> >> Hi Ard, Akashi
> >> > >>> >> >>
> >> > >>> >> > (snip)
> >> > >>> >> >
> >> > >>> >> >> Looking deeper into the issue, since the arm64 kexec-tools uses the
> >> > >>> >> >> 'linux,usable-memory-range' dt property to allow crash dump kernel to
> >> > >>> >> >> identify its own usable memory and exclude, at its boot time, any
> >> > >>> >> >> other memory areas that are part of the panicked kernel's memory.
> >> > >>> >> >> (see https://www.kernel.org/doc/Documentation/devicetree/bindings/chosen.txt
> >> > >>> >> >> , for details)
> >> > >>> >> >
> >> > >>> >> > Right.
> >> > >>> >> >
> >> > >>> >> >> 1). Now when 'kexec -p' is executed, this node is patched up only
> >> > >>> >> >> with the crashkernel memory range:
> >> > >>> >> >>
> >> > >>> >> >>                 /* add linux,usable-memory-range */
> >> > >>> >> >>                 nodeoffset = fdt_path_offset(new_buf, "/chosen");
> >> > >>> >> >>                 result = fdt_setprop_range(new_buf, nodeoffset,
> >> > >>> >> >>                                 PROP_USABLE_MEM_RANGE, &crash_reserved_mem,
> >> > >>> >> >>                                 address_cells, size_cells);
> >> > >>> >> >>
> >> > >>> >> >> (see https://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git/tree/kexec/arch/arm64/kexec-arm64.c#n465
> >> > >>> >> >> , for details)
> >> > >>> >> >>
> >> > >>> >> >> 2). This excludes the ACPI reclaim regions irrespective of whether
> >> > >>> >> >> they are marked as System RAM or as RESERVED. As,
> >> > >>> >> >> 'linux,usable-memory-range' dt node is patched up only with
> >> > >>> >> >> 'crash_reserved_mem' and not 'system_memory_ranges'
> >> > >>> >> >>
> >> > >>> >> >> 3). As a result when the crashkernel boots up it doesn't find this
> >> > >>> >> >> ACPI memory and crashes while trying to access the same:
> >> > >>> >> >>
> >> > >>> >> >> # kexec -p /boot/vmlinuz-`uname -r` --initrd=/boot/initramfs-`uname
> >> > >>> >> >> -r`.img --reuse-cmdline -d
> >> > >>> >> >>
> >> > >>> >> >> [snip..]
> >> > >>> >> >>
> >> > >>> >> >> Reserved memory range
> >> > >>> >> >> 000000000e800000-000000002e7fffff (0)
> >> > >>> >> >>
> >> > >>> >> >> Coredump memory ranges
> >> > >>> >> >> 0000000000000000-000000000e7fffff (0)
> >> > >>> >> >> 000000002e800000-000000003961ffff (0)
> >> > >>> >> >> 0000000039d40000-000000003ed2ffff (0)
> >> > >>> >> >> 000000003ed60000-000000003fbfffff (0)
> >> > >>> >> >> 0000001040000000-0000001ffbffffff (0)
> >> > >>> >> >> 0000002000000000-0000002ffbffffff (0)
> >> > >>> >> >> 0000009000000000-0000009ffbffffff (0)
> >> > >>> >> >> 000000a000000000-000000affbffffff (0)
> >> > >>> >> >>
> >> > >>> >> >> 4). So if we revert Ard's patch or just comment the fixing up of the
> >> > >>> >> >> memory cap'ing passed to the crash kernel inside
> >> > >>> >> >> 'arch/arm64/mm/init.c' (see below):
> >> > >>> >> >>
> >> > >>> >> >> static void __init fdt_enforce_memory_region(void)
> >> > >>> >> >> {
> >> > >>> >> >>         struct memblock_region reg = {
> >> > >>> >> >>                 .size = 0,
> >> > >>> >> >>         };
> >> > >>> >> >>
> >> > >>> >> >>         of_scan_flat_dt(early_init_dt_scan_usablemem, &reg);
> >> > >>> >> >>
> >> > >>> >> >>         if (reg.size)
> >> > >>> >> >>                 //memblock_cap_memory_range(reg.base, reg.size); /*
> >> > >>> >> >> comment this out */
> >> > >>> >> >> }
> >> > >>> >> >
> >> > >>> >> > Please just don't do that. It can cause a fatal damage on
> >> > >>> >> > memory contents of the *crashed* kernel.
> >> > >>> >> >
> >> > >>> >> >> 5). Both the above temporary solutions fix the problem.
> >> > >>> >> >>
> >> > >>> >> >> 6). However exposing all System RAM regions to the crashkernel is not
> >> > >>> >> >> advisable and may cause the crashkernel or some crashkernel drivers to
> >> > >>> >> >> fail.
> >> > >>> >> >>
> >> > >>> >> >> 6a). I am trying an approach now, where the ACPI reclaim regions are
> >> > >>> >> >> added to '/proc/iomem' separately as ACPI reclaim regions by the
> >> > >>> >> >> kernel code and on the other hand the user-space 'kexec-tools' will
> >> > >>> >> >> pick up the ACPI reclaim regions from '/proc/iomem' and add it to the
> >> > >>> >> >> dt node 'linux,usable-memory-range'
> >> > >>> >> >
> >> > >>> >> > I still don't understand why we need to carry over the information
> >> > >>> >> > about "ACPI Reclaim memory" to crash dump kernel. In my understandings,
> >> > >>> >> > such regions are free to be reused by the kernel after some point of
> >> > >>> >> > initialization. Why does crash dump kernel need to know about them?
> >> > >>> >> >
> >> > >>> >>
> >> > >>> >> Not really. According to the UEFI spec, they can be reclaimed after
> >> > >>> >> the OS has initialized, i.e., when it has consumed the ACPI tables and
> >> > >>> >> no longer needs them. Of course, in order to be able to boot a kexec
> >> > >>> >> kernel, those regions needs to be preserved, which is why they are
> >> > >>> >> memblock_reserve()'d now.
> >> > >>> >
> >> > >>> > For my better understandings, who is actually accessing such regions
> >> > >>> > during boot time, uefi itself or efistub?
> >> > >>> >
> >> > >>>
> >> > >>> No, only the kernel. This is where the ACPI tables are stored. For
> >> > >>> instance, on QEMU we have
> >> > >>>
> >> > >>>  ACPI: RSDP 0x0000000078980000 000024 (v02 BOCHS )
> >> > >>>  ACPI: XSDT 0x0000000078970000 000054 (v01 BOCHS  BXPCFACP 00000001
> >> > >>>   01000013)
> >> > >>>  ACPI: FACP 0x0000000078930000 00010C (v05 BOCHS  BXPCFACP 00000001
> >> > >>> BXPC 00000001)
> >> > >>>  ACPI: DSDT 0x0000000078940000 0011DA (v02 BOCHS  BXPCDSDT 00000001
> >> > >>> BXPC 00000001)
> >> > >>>  ACPI: APIC 0x0000000078920000 000140 (v03 BOCHS  BXPCAPIC 00000001
> >> > >>> BXPC 00000001)
> >> > >>>  ACPI: GTDT 0x0000000078910000 000060 (v02 BOCHS  BXPCGTDT 00000001
> >> > >>> BXPC 00000001)
> >> > >>>  ACPI: MCFG 0x0000000078900000 00003C (v01 BOCHS  BXPCMCFG 00000001
> >> > >>> BXPC 00000001)
> >> > >>>  ACPI: SPCR 0x00000000788F0000 000050 (v02 BOCHS  BXPCSPCR 00000001
> >> > >>> BXPC 00000001)
> >> > >>>  ACPI: IORT 0x00000000788E0000 00007C (v00 BOCHS  BXPCIORT 00000001
> >> > >>> BXPC 00000001)
> >> > >>>
> >> > >>> covered by
> >> > >>>
> >> > >>>  efi:   0x0000788e0000-0x00007894ffff [ACPI Reclaim Memory ...]
> >> > >>>  ...
> >> > >>>  efi:   0x000078970000-0x00007898ffff [ACPI Reclaim Memory ...]
> >> > >>
> >> > >> OK. I mistakenly understood those regions could be freed after exiting
> >> > >> UEFI boot services.
> >> > >>
> >> > >>>
> >> > >>> >> So it seems that kexec does not honour the memblock_reserve() table
> >> > >>> >> when booting the next kernel.
> >> > >>> >
> >> > >>> > not really.
> >> > >>> >
> >> > >>> >> > (In other words, can or should we skip some part of ACPI-related init code
> >> > >>> >> > on crash dump kernel?)
> >> > >>> >> >
> >> > >>> >>
> >> > >>> >> I don't think so. And the change to the handling of ACPI reclaim
> >> > >>> >> regions only revealed the bug, not created it (given that other
> >> > >>> >> memblock_reserve regions may be affected as well)
> >> > >>> >
> >> > >>> > As whether we should honor such reserved regions over kexec'ing
> >> > >>> > depends on each one's specific nature, we will have to take care one-by-one.
> >> > >>> > As a matter of fact, no information about "reserved" memblocks is
> >> > >>> > exposed to user space (via proc/iomem).
> >> > >>> >
> >> > >>>
> >> > >>> That is why I suggested (somewhere in this thread?) to not expose them
> >> > >>> as 'System RAM'. Do you think that could solve this?
> >> > >>
> >> > >> Memblock-reserv'ing them is necessary to prevent their corruption and
> >> > >> marking them under another name in /proc/iomem would also be good in order
> >> > >> not to allocate them as part of crash kernel's memory.
> >> > >>
> >> > >
> >> > > I agree. However, this may not be entirely trivial, since iterating
> >> > > over the memblock_reserved table and creating iomem entries may result
> >> > > in collisions.
> >> >
> >> > I found a method (using the patch I shared earlier in this thread) to mark these
> >> > entries as 'ACPI reclaim memory' ranges rather than System RAM or
> >> > reserved regions.
> >> >
> >> > >> But I'm not still convinced that we should export them in useable-
> >> > >> memory-range to crash dump kernel. They will be accessed through
> >> > >> acpi_os_map_memory() and so won't be required to be part of system ram
> >> > >> (or memblocks), I guess.
> >> > >
> >> > > Agreed. They will be covered by the linear mapping in the boot kernel,
> >> > > and be mapped explicitly via ioremap_cache() in the kexec kernel,
> >> > > which is exactly what we want in this case.
> >> >
> >> > Now this is what is confusing me. I don't see the above happening.
> >> >
> >> > I see that the primary kernel boots up and adds the ACPI regions via:
> >> > acpi_os_ioremap
> >> >     -> ioremap_cache
> >> >
> >> > But during the crashkernel boot, ''acpi_os_ioremap' calls
> >> > 'ioremap' for the ACPI Reclaim Memory regions and not the _cache
> >> > variant.
> >
> > It is natural if that region is out of memblocks.
> 
> Thanks for the confirmation. This was my understanding as well.
> 
> >> > And it fails while accessing the ACPI tables:
> >> >
> >> > [    0.039205] ACPI: Core revision 20170728
> >> > pud=000000002e7d0003, *pmd=000000002e7c0003, *pte=00e8000039710707
> >> > [    0.095098] Internal error: Oops: 96000021 [#1] SMP
> >
> > this (ESR = 0x96000021) means that Data Abort and Alignment fault happened.
> > As ioremap() makes the mapping as "Device memory", unaligned memory
> > access won't be allowed.
> >
> >> > [    0.100022] Modules linked in:
> >> > [    0.103102] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.14.0-rc6 #1
> >> > [    0.109432] task: ffff000008d05180 task.stack: ffff000008cc0000
> >> > [    0.115414] PC is at acpi_ns_lookup+0x25c/0x3c0
> >> > [    0.119987] LR is at acpi_ds_load1_begin_op+0xa4/0x294
> >> > [    0.125175] pc : [<ffff0000084a6764>] lr : [<ffff00000849b4f8>]
> >> > pstate: 60000045
> >> > [    0.132647] sp : ffff000008ccfb40
> >> > [    0.135989] x29: ffff000008ccfb40 x28: ffff000008a9f2a4
> >> > [    0.141354] x27: ffff0000088be820 x26: 0000000000000000
> >> > [    0.146718] x25: 000000000000001b x24: 0000000000000001
> >> > [    0.152083] x23: 0000000000000001 x22: ffff000009710027
> >> > [    0.157447] x21: ffff000008ccfc50 x20: 0000000000000001
> >> > [    0.162812] x19: 000000000000001b x18: 0000000000000005
> >> > [    0.168176] x17: 0000000000000000 x16: 0000000000000000
> >> > [    0.173541] x15: 0000000000000000 x14: 000000000000038e
> >> > [    0.178905] x13: ffffffff00000000 x12: ffffffffffffffff
> >> > [    0.184270] x11: 0000000000000006 x10: 00000000ffffff76
> >> > [    0.189634] x9 : 000000000000005f x8 : ffff8000126d0140
> >> > [    0.194998] x7 : 0000000000000000 x6 : ffff000008ccfc50
> >> > [    0.200362] x5 : ffff80000fe62c00 x4 : 0000000000000001
> >> > [    0.205727] x3 : ffff000008ccfbe0 x2 : ffff0000095e3980
> >> > [    0.211091] x1 : ffff000009710027 x0 : 0000000000000000
> >> > [    0.216456] Process swapper/0 (pid: 0, stack limit = 0xffff000008cc0000)
> >> > [    0.223224] Call trace:
> >> > [    0.225688] Exception stack(0xffff000008ccfa00 to 0xffff000008ccfb40)
> >> > [    0.232194] fa00: 0000000000000000 ffff000009710027
> >> > ffff0000095e3980 ffff000008ccfbe0
> >> > [    0.240106] fa20: 0000000000000001 ffff80000fe62c00
> >> > ffff000008ccfc50 0000000000000000
> >> > [    0.248018] fa40: ffff8000126d0140 000000000000005f
> >> > 00000000ffffff76 0000000000000006
> >> > [    0.255931] fa60: ffffffffffffffff ffffffff00000000
> >> > 000000000000038e 0000000000000000
> >> > [    0.263843] fa80: 0000000000000000 0000000000000000
> >> > 0000000000000005 000000000000001b
> >> > [    0.271754] faa0: 0000000000000001 ffff000008ccfc50
> >> > ffff000009710027 0000000000000001
> >> > [    0.279667] fac0: 0000000000000001 000000000000001b
> >> > 0000000000000000 ffff0000088be820
> >> > [    0.287579] fae0: ffff000008a9f2a4 ffff000008ccfb40
> >> > ffff00000849b4f8 ffff000008ccfb40
> >> > [    0.295491] fb00: ffff0000084a6764 0000000060000045
> >> > ffff000008ccfb40 ffff000008260a18
> >> > [    0.303403] fb20: ffffffffffffffff ffff0000087f3fb0
> >> > ffff000008ccfb40 ffff0000084a6764
> >> > [    0.311316] [<ffff0000084a6764>] acpi_ns_lookup+0x25c/0x3c0
> >> > [    0.316943] [<ffff00000849b4f8>] acpi_ds_load1_begin_op+0xa4/0x294
> >> > [    0.323186] [<ffff0000084ad4ac>] acpi_ps_build_named_op+0xc4/0x198
> >> > [    0.329428] [<ffff0000084ad6cc>] acpi_ps_create_op+0x14c/0x270
> >> > [    0.335319] [<ffff0000084acfa8>] acpi_ps_parse_loop+0x188/0x5c8
> >> > [    0.341298] [<ffff0000084ae048>] acpi_ps_parse_aml+0xb0/0x2b8
> >> > [    0.347101] [<ffff0000084a8e10>] acpi_ns_one_complete_parse+0x144/0x184
> >> > [    0.353783] [<ffff0000084a8e98>] acpi_ns_parse_table+0x48/0x68
> >> > [    0.359675] [<ffff0000084a82cc>] acpi_ns_load_table+0x4c/0xdc
> >> > [    0.365479] [<ffff0000084b32f8>] acpi_tb_load_namespace+0xe4/0x264
> >> > [    0.371723] [<ffff000008baf9b4>] acpi_load_tables+0x48/0xc0
> >> > [    0.377350] [<ffff000008badc20>] acpi_early_init+0x9c/0xd0
> >> > [    0.382891] [<ffff000008b70d50>] start_kernel+0x3b4/0x43c
> >> > [    0.388343] Code: b9008fb9 2a000318 36380054 32190318 (b94002c0)
> >> > [    0.394500] ---[ end trace c46ed37f9651c58e ]---
> >> > [    0.399160] Kernel panic - not syncing: Fatal exception
> >> > [    0.404437] Rebooting in 10 seconds.
> >> >
> >> > So, I think the linear mapping done by the primary kernel does not
> >> > make these accessible in the crash kernel directly.
> >> >
> >> > Any pointers?
> >>
> >> Can you get the code line number for acpi_ns_lookup+0x25c?
> >
> > So should we always avoid ioremap() in acpi_os_ioremap() entirely, or
> > modify acpi_ns_lookup() (or any acpi functions') to prevent unaligned
> > accesses?
> > (I didn't find out how unaligned accesses could happen there.)
> >
> 
> Right. Like I captured somewhere in this thread (perhaps the first
> email on this subject),
> this is indeed an unaligned address access.
> 
> Now, modifying acpi_os_ioremap() to not ioremap() and thus avoiding
> assigning this memory range
> as device memory doesn't seem a neat solution as it means we are not
> marking some thing with the right memory attribute and we can fall in
> similar/related issues later.
> 
> Regarding the later suggestion, what I am seeing now is that the acpi
> table access functions are perhaps reused from the earlier x86
> implementation, but on the arm64 (or even arm) arch we should not be
> allowing unaligned accesses which might cause UNDEFINED behaviour and
> resultant crash.
> 
> So I can try going this approach and see if it works for me.
> 
> However, I am still not very sure as to why the crashkernel ranges
> historically do not include the System RAM regions (which may include
> the ACPI regions as well). These regions are available for the kernel
> usage and perhaps should be exported to the crashkernel as well.
> 
> I am not fully aware of the previous discussions on capp'ing the
> crashkernel memory being passed to the kdump kernel, but did we run
> into any issues while doing so?
> 
> Also, even if I extend the kexec-tools to modify the
> linux,usable-memory-range and add the ACPI regions to it, the
> crashkernel fails to boot with the below message (I have added some
> logic to print the DTB on the crash kernel boot start):
> 
> [    0.000000]     chosen {
> [    0.000000]         linux,usable-memory-range
> [    0.000000]  = <
> [    0.000000] 0x00000000
> [    0.000000] 0x0e800000
> [    0.000000] 0x00000000
> [    0.000000] 0x20000000
> [    0.000000] 0x00000000
> [    0.000000] 0x396c0000
> [    0.000000] 0x00000000
> [    0.000000] 0x000a0000
> [    0.000000] 0x00000000
> [    0.000000] 0x39770000
> [    0.000000] 0x00000000
> [    0.000000] 0x00040000
> [    0.000000] 0x00000000
> [    0.000000] 0x398a0000
> [    0.000000] 0x00000000
> [    0.000000] 0x00020000
> [    0.000000] >
> [    0.000000] ;
> 
> [snip..]
> 
> [    0.000000] linux,usable-memory-range base e800000, size 20000000
> [    0.000000]  - e800000 ,  20000000
> [    0.000000] linux,usable-memory-range base 396c0000, size a0000
> [    0.000000]  - 396c0000 ,  a0000
> [    0.000000] linux,usable-memory-range base 39770000, size 40000
> [    0.000000]  - 39770000 ,  40000
> [    0.000000] linux,usable-memory-range base 398a0000, size 20000
> [    0.000000]  - 398a0000 ,  20000
> [    0.000000] initrd not fully accessible via the linear mapping --
> please check your bootloader ...
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at arch/arm64/mm/init.c:597
> arm64_memblock_init+0x210/0x484
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.14.0+ #7
> [    0.000000] task: ffff000008d05580 task.stack: ffff000008cc0000
> [    0.000000] PC is at arm64_memblock_init+0x210/0x484
> [    0.000000] LR is at arm64_memblock_init+0x210/0x484
> [    0.000000] pc : [<ffff000008b76984>] lr : [<ffff000008b76984>]
> pstate: 600000c5
> [    0.000000] sp : ffff000008ccfe80
> [    0.000000] x29: ffff000008ccfe80 x28: 000000000f370018
> [    0.000000] x27: 0000000011230000 x26: 00000000013b0000
> [    0.000000] x25: 000000000fe80000 x24: ffff000008cf3000
> [    0.000000] x23: ffff000008ec0000 x22: ffff000009680000
> [    0.000000] x21: ffff000008afa000 x20: ffff000008080000
> [    0.000000] x19: ffff000008afa000 x18: 000000000c283806
> [    0.000000] x17: 0000000000000000 x16: ffff000008d05580
> [    0.000000] x15: 000000002be00842 x14: 79206b6365686320
> [    0.000000] x13: 657361656c70202d x12: 2d20676e69707061
> [    0.000000] x11: 6d207261656e696c x10: 2065687420616976
> [    0.000000] x9 : 00000000000000f4 x8 : ffff000008517414
> [    0.000000] x7 : 746f6f622072756f x6 : 000000000000000d
> [    0.000000] x5 : ffff000008c96360 x4 : 0000000000000001
> [    0.000000] x3 : 0000000000000000 x2 : 0000000000000000
> [    0.000000] x1 : 0000000000000000 x0 : 0000000000000056
> [    0.000000] Call trace:
> [    0.000000] Exception stack(0xffff000008ccfd40 to 0xffff000008ccfe80)
> [    0.000000] fd40: 0000000000000056 0000000000000000
> 0000000000000000 0000000000000000
> [    0.000000] fd60: 0000000000000001 ffff000008c96360
> 000000000000000d 746f6f622072756f
> [    0.000000] fd80: ffff000008517414 00000000000000f4
> 2065687420616976 6d207261656e696c
> [    0.000000] fda0: 2d20676e69707061 657361656c70202d
> 79206b6365686320 000000002be00842
> [    0.000000] fdc0: ffff000008d05580 0000000000000000
> 000000000c283806 ffff000008afa000
> [    0.000000] fde0: ffff000008080000 ffff000008afa000
> ffff000009680000 ffff000008ec0000
> [    0.000000] fe00: ffff000008cf3000 000000000fe80000
> 00000000013b0000 0000000011230000
> [    0.000000] fe20: 000000000f370018 ffff000008ccfe80
> ffff000008b76984 ffff000008ccfe80
> [    0.000000] fe40: ffff000008b76984 00000000600000c5
> ffff00000959b7a8 ffff000008ec0000
> [    0.000000] fe60: ffffffffffffffff 0000000000000005
> ffff000008ccfe80 ffff000008b76984
> [    0.000000] [<ffff000008b76984>] arm64_memblock_init+0x210/0x484
> [    0.000000] [<ffff000008b7398c>] setup_arch+0x1b8/0x5f4
> [    0.000000] [<ffff000008b70a10>] start_kernel+0x74/0x43c
> [    0.000000] random: get_random_bytes called from
> print_oops_end_marker+0x50/0x6c with crng_init=0
> [    0.000000] ---[ end trace 0000000000000000 ]---
> [    0.000000] Reserving 4KB of memory at 0x2e7f0000 for elfcorehdr
> [    0.000000] cma: Failed to reserve 512 MiB
> [    0.000000] Kernel panic - not syncing: ERROR: Failed to allocate
> 0x0000000000010000 bytes below 0x0000000000000000.
> [    0.000000]
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Tainted: G        W
> ------------   4.14.0+ #7
> [    0.000000] Call trace:
> [    0.000000] [<ffff000008088da8>] dump_backtrace+0x0/0x23c
> [    0.000000] [<ffff000008089008>] show_stack+0x24/0x2c
> [    0.000000] [<ffff0000087f647c>] dump_stack+0x84/0xa8
> [    0.000000] [<ffff0000080cfd44>] panic+0x138/0x2a0
> [    0.000000] [<ffff000008b95c88>] memblock_alloc_base+0x44/0x4c
> [    0.000000] [<ffff000008b95cbc>] memblock_alloc+0x2c/0x38
> [    0.000000] [<ffff000008b772dc>] early_pgtable_alloc+0x20/0x74
> [    0.000000] [<ffff000008b7755c>] paging_init+0x28/0x544
> [    0.000000] [<ffff000008b73990>] setup_arch+0x1bc/0x5f4
> [    0.000000] [<ffff000008b70a10>] start_kernel+0x74/0x43c
> [    0.000000] ---[ end Kernel panic - not syncing: ERROR: Failed to
> allocate 0x0000000000010000 bytes below 0x0000000000000000.
> [    0.000000]
> 
> I guess it is because of the 1G alignment requirement between the
> kernel image and the initrd and how we populate the holes between the
> kernel image, segments (including dtb) and the initrd from the
> kexec-tools.
> 
> Akashi, any pointers on this will be helpful as well.

Please show me:
 * "Virtual kernel memory layout" in dmesg
 * /proc/iomem
 * debug messages from kexec-tools (kexec -d)

-Takahiro AKASHI


> Regards,
> Bhupesh
> 
> 
> >> >
> >> > Regards,
> >> > Bhupesh
> >> >
> >> > >> Just FYI, on x86, ACPI tables seems to be exposed to crash dump kernel
> >> > >> via a kernel command line parameter, "memmap=".
> >> > >>
> >> > _______________________________________________
> >> > kexec mailing list -- kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
> >> > To unsubscribe send an email to kexec-leave-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org
