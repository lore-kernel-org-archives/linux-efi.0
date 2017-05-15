From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH 4.11 00/28] 4.11.1-stable review
Date: Mon, 15 May 2017 11:28:16 -0600
Message-ID: <e95d7992-6343-1a36-46e7-630b8874bdfa@osg.samsung.com>
References: <20170511141221.109842231@linuxfoundation.org>
 <465c70c9-1dbc-7c57-c6aa-b6df740663ed@osg.samsung.com>
 <efa3b911-93f6-29b4-a9ca-e0d9b480a4ef@osg.samsung.com>
 <20170515143601.GF2935@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B03647AB76172C3E8BD88FB9"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170515143601.GF2935@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, patches@kernelci.org, ben.hutchings@codethink.co.uk, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-efi@vger.kernel.org

This is a multi-part message in MIME format.
--------------B03647AB76172C3E8BD88FB9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

Hi Matt,

On 05/15/2017 08:36 AM, Matt Fleming wrote:
> On Fri, 12 May, at 10:01:41AM, Shuah Khan wrote:
>>
>> Greg/Matt,
>>
>> I started seeing this maybe since 4.11, so it isn't really a 4.11.1
>> issue, however sounds like this shouldn't be an error message, since
>> it is showing up on an older platform.
>>
>> efi: EFI_MEMMAP is not enabled.
>> efi: Failed to lookup EFI memory descriptor for 0x00000000d9e0f018
>>
>>
>> From 816e76129ed5fadd28e526c43397c79775194b5c Mon Sep 17 00:00:00 2001
>> From: Matt Fleming <matt@codeblueprint.co.uk>
>> Date: Mon, 29 Feb 2016 21:22:52 +0000
>> Subject: [PATCH] efi: Allow drivers to reserve boot services forever
>>
>> This change was introduced in Commit: 816e76129ed5fadd28e526c43397c79775194b5c
>>
>> Matt!
>>
>> Shouldn't this be a debug message?? Is this a really an error??
> 
> Yes, it's most likely an error. We shouldn't be trying to reserve
> EFI regions if we can't find them in the memory map.
> 
> Can you provide the full dmesg, please?
> 

Please see attached dmesg and dmidecode output. Please let me know if you need
any other information.

thanks,
-- Shuah


--------------B03647AB76172C3E8BD88FB9
Content-Type: text/plain; charset=UTF-8;
 name="dmesg_full"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg_full"

[    0.000000] Linux version 4.11.1-rc1+ (shuah@mazurka) (gcc version 6.2=
=2E0 20161005 (Ubuntu 6.2.0-5ubuntu12) ) #10 SMP Thu May 11 16:46:05 MDT =
2017
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-4.11.1-rc1+ root=3D=
UUID=3D9f7f1c57-70a6-480b-a021-67d4eee99e78 ro earlyprintk=3Dvga trace_ev=
ent=3Dio_page_fault,unmap,map,detach_device_from_domain,attach_device_to_=
domain,remove_device_from_group,add_device_to_group,kobject_init,kobject_=
add,kobject_init_and_add,kobject_create_and_add,kobject_set_name,kobject_=
get,kobject_put,kobject_del,kobject_cleanup,kobject_move,kobject_rename
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating poi=
nt registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 =
bytes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000c3df4fff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000c3df5000-0x00000000c3dfbfff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000c3dfc000-0x00000000c4246fff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000c4247000-0x00000000c4659fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000c465a000-0x00000000d86c2fff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000d86c3000-0x00000000d88cafff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000d88cb000-0x00000000d88e0fff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000d88e1000-0x00000000d8e21fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000d8e22000-0x00000000d9ffefff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000d9fff000-0x00000000d9ffffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df1fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fdfffff] usa=
ble
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: System76, Inc. Wild Dog Performance/H87-PLUS, BIOS 07=
05 12/05/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x41fe00 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7C00000000 write-back
[    0.000000]   1 base 0400000000 mask 7FE0000000 write-back
[    0.000000]   2 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   3 base 00DC000000 mask 7FFC000000 uncachable
[    0.000000]   4 base 00DB000000 mask 7FFF000000 uncachable
[    0.000000]   5 base 041FE00000 mask 7FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- =
WT =20
[    0.000000] total RAM covered: 16302M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 9  	lose cover=
 RAM: 0G
[    0.000000] e820: update [mem 0xdb000000-0xffffffff] usable =3D=3D> re=
served
[    0.000000] e820: last_pfn =3D 0xda000 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd840-0x000fd84f] mapped a=
t [ffff8800000fd840]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24=
576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x04ed8000, 0x04ed8fff] PGTABLE
[    0.000000] BRK [0x04ed9000, 0x04ed9fff] PGTABLE
[    0.000000] BRK [0x04eda000, 0x04edafff] PGTABLE
[    0.000000] BRK [0x04edb000, 0x04edbfff] PGTABLE
[    0.000000] BRK [0x04edc000, 0x04edcfff] PGTABLE
[    0.000000] BRK [0x04edd000, 0x04eddfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x11a8a000-0x24d3cfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000D88CF080 00007C (v01 ALASKA A M I    =
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000D88DBE98 00010C (v05 ALASKA A M I    =
01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000D88CF198 00CCFD (v02 ALASKA A M I    =
00000024 INTL 20091112)
[    0.000000] ACPI: FACS 0x00000000D8E20080 000040
[    0.000000] ACPI: APIC 0x00000000D88DBFA8 000092 (v03 ALASKA A M I    =
01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000D88DC040 000044 (v01 ALASKA A M I    =
01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000D88DC088 000539 (v01 PmRef  Cpu0Ist  =
00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000D88DC5C8 000AD8 (v01 PmRef  CpuPm    =
00003000 INTL 20051117)
[    0.000000] ACPI: MCFG 0x00000000D88DD0A0 00003C (v01 ALASKA A M I    =
01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000D88DD0E0 000038 (v01 ALASKA A M I    =
01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000D88DD118 00036D (v01 SataRe SataTabl =
00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000D88DD488 003482 (v01 SaSsdt SaSsdt   =
00003000 INTL 20091112)
[    0.000000] ACPI: DMAR 0x00000000D88E09A0 0000B8 (v01 INTEL  HSW      =
00000001 INTL 00000001)
[    0.000000] ACPI: BGRT 0x00000000D88E0968 000038 (v00 ALASKA A M I    =
01072009 AMI  00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fdffff=
f]
[    0.000000] NODE_DATA(0) allocated [mem 0x41fdf8000-0x41fdfbfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000041fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009cfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000c3df4fff]
[    0.000000]   node   0: [mem 0x00000000c3dfc000-0x00000000c4246fff]
[    0.000000]   node   0: [mem 0x00000000c465a000-0x00000000d86c2fff]
[    0.000000]   node   0: [mem 0x00000000d9fff000-0x00000000d9ffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000041fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000041fd=
fffff]
[    0.000000] On node 0 totalpages: 4161606
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13771 pages used for memmap
[    0.000000]   DMA32 zone: 881322 pages, LIFO batch:31
[    0.000000]   Normal zone: 51192 pages used for memmap
[    0.000000]   Normal zone: 3276288 pages, LIFO batch:31
[    0.000000] [ffffed00187bf800-ffffed00187fffff] potential offnode page=
_structs
[    0.000000] [ffffed00188cb400-ffffed00189fffff] potential offnode page=
_structs
[    0.000000] kasan: KernelAddressSanitizer initialized
[    0.000000] Reserving Intel graphics memory at 0x00000000db200000-0x00=
000000df1fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] efi: EFI_MEMMAP is not enabled.
[    0.000000] efi: Failed to lookup EFI memory descriptor for 0x00000000=
d9e0f018
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xc3df5000-0xc3dfbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xc4247000-0xc4659fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd86c3000-0xd88cafff]
[    0.000000] PM: Registered nosave memory: [mem 0xd88cb000-0xd88e0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd88e1000-0xd8e21fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd8e22000-0xd9ffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xda000000-0xdaffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdf1fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf200000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf200000-0xf7ffffff] available for PCI device=
s
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles:=
 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8=
 nr_node_ids:1
[    0.000000] percpu: Embedded 46 pages/cpu @ffff88038f800000 s150344 r8=
192 d29880 u262144
[    0.000000] pcpu-alloc: s150344 r8192 d29880 u262144 alloc=3D1*2097152=

[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7=20
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  To=
tal pages: 4096558
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-4.11.1-rc1=
+ root=3DUUID=3D9f7f1c57-70a6-480b-a021-67d4eee99e78 ro earlyprintk=3Dvga=
 trace_event=3Dio_page_fault,unmap,map,detach_device_from_domain,attach_d=
evice_to_domain,remove_device_from_group,add_device_to_group,kobject_init=
,kobject_add,kobject_init_and_add,kobject_create_and_add,kobject_set_name=
,kobject_get,kobject_put,kobject_del,kobject_cleanup,kobject_move,kobject=
_rename
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - baili=
ng!
[    0.000000] Memory: 13843112K/16646424K available (26599K kernel code,=
 5317K rwdata, 6216K rodata, 1920K init, 22256K bss, 2803312K reserved, 0=
K cma-reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8,=
 Nodes=3D1
[    0.000000] Running RCU self tests
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D256 to nr_cpu_ids=3D8=
=2E
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D64, nr_cpu_i=
ds=3D8
[    0.000000] Failed to enable trace event: kobject_init
[    0.000000] Failed to enable trace event: kobject_add
[    0.000000] Failed to enable trace event: kobject_init_and_add
[    0.000000] Failed to enable trace event: kobject_create_and_add
[    0.000000] Failed to enable trace event: kobject_set_name
[    0.000000] Failed to enable trace event: kobject_get
[    0.000000] Failed to enable trace event: kobject_put
[    0.000000] Failed to enable trace event: kobject_del
[    0.000000] Failed to enable trace event: kobject_cleanup
[    0.000000] Failed to enable trace event: kobject_move
[    0.000000] Failed to enable trace event: kobject_rename
[    0.000000] NR_IRQS:16640 nr_irqs:488 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8159 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff=
, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 3391.987 MHz processor
[    0.004000] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 6783.97 BogoMIPS (lpj=3D13567948)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] ACPI: Core revision 20170119
[    0.095275] ACPI: 5 ACPI AML tables successfully acquired and loaded
[    0.095379] Security Framework initialized
[    0.095397] Yama: becoming mindful.
[    0.095511] AppArmor: AppArmor initialized
[    0.096728] Dentry cache hash table entries: 2097152 (order: 12, 16777=
216 bytes)
[    0.099869] Inode-cache hash table entries: 1048576 (order: 11, 838860=
8 bytes)
[    0.101222] Mount-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.101269] Mountpoint-cache hash table entries: 32768 (order: 6, 2621=
44 bytes)
[    0.102055] CPU: Physical Processor ID: 0
[    0.102072] CPU: Processor Core ID: 0
[    0.102090] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.102110] ENERGY_PERF_BIAS: View and update with x86_energy_perf_pol=
icy(8)
[    0.102134] mce: CPU supports 9 MCE banks
[    0.102169] CPU0: Thermal monitoring enabled (TM1)
[    0.102199] process: using mwait in idle threads
[    0.102218] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.102238] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB=
 4
[    0.102521] Freeing SMP alternatives memory: 28K
[    0.104007] ftrace: allocating 31289 entries in 123 pages
[    0.112249] smpboot: Max logical packages: 2
[    0.112273] DMAR: Host address width 39
[    0.112291] DMAR: DRHD base: 0x000000fed90000 flags: 0x0
[    0.112354] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap c000002066=
0462 ecap f0101a
[    0.112385] DMAR: DRHD base: 0x000000fed91000 flags: 0x1
[    0.112430] DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d200802066=
0462 ecap f010da
[    0.112460] DMAR: RMRR base: 0x000000d8852000 end: 0x000000d885efff
[    0.112494] DMAR: RMRR base: 0x000000db000000 end: 0x000000df1fffff
[    0.112528] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
[    0.112550] DMAR-IR: HPET id 0 under DRHD base 0xfed91000
[    0.112570] DMAR-IR: Queued invalidation will be enabled to support x2=
apic and Intr-remapping.
[    0.112899] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.112919] x2apic enabled
[    0.112938] Switched APIC routing to cluster x2apic.
[    0.113866] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.154986] TSC deadline timer enabled
[    0.154993] smpboot: CPU0: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (fa=
mily: 0x6, model: 0x3c, stepping: 0x3)
[    0.155366] Performance Events: PEBS fmt2+, Haswell events, 16-deep LB=
R, full-width counters, Intel PMU driver.
[    0.155433] ... version:                3
[    0.155449] ... bit width:              48
[    0.155465] ... generic registers:      4
[    0.155481] ... value mask:             0000ffffffffffff
[    0.155501] ... max period:             00007fffffffffff
[    0.155520] ... fixed-purpose events:   3
[    0.155536] ... event mask:             000000070000000f
[    0.156000] Failed to enable trace event: kobject_init
[    0.156000] Failed to enable trace event: kobject_add
[    0.156000] Failed to enable trace event: kobject_init_and_add
[    0.156000] Failed to enable trace event: kobject_create_and_add
[    0.156000] Failed to enable trace event: kobject_set_name
[    0.156000] Failed to enable trace event: kobject_get
[    0.156000] Failed to enable trace event: kobject_put
[    0.156000] Failed to enable trace event: kobject_del
[    0.156000] Failed to enable trace event: kobject_cleanup
[    0.156000] Failed to enable trace event: kobject_move
[    0.156000] Failed to enable trace event: kobject_rename
[    0.156000] smp: Bringing up secondary CPUs ...
[    0.157501] x86: Booting SMP configuration:
[    0.157526] .... node  #0, CPUs:      #1
[    0.236163] NMI watchdog: enabled on all CPUs, permanently consumes on=
e hw-PMU counter.
[    0.238182]  #2 #3 #4 #5 #6 #7
[    0.716132] smp: Brought up 1 node, 8 CPUs
[    0.716132] smpboot: Total of 8 processors activated (54336.18 BogoMIP=
S)
[    0.720925] sched_clock: Marking stable (720000000, 0)->(726106287, -6=
106287)
[    0.721862] devtmpfs: initialized
[    0.721948] device: 'platform': device_add
[    0.721996] PM: Adding info for No Bus:platform
[    0.722057] bus: 'platform': registered
[    0.722102] bus: 'cpu': registered
[    0.722113] device: 'cpu': device_add
[    0.722174] PM: Adding info for No Bus:cpu
[    0.722220] bus: 'container': registered
[    0.722231] device: 'container': device_add
[    0.722276] PM: Adding info for No Bus:container
[    0.724491] evm: security.selinux
[    0.724508] evm: security.SMACK64
[    0.724523] evm: security.capability
[    0.724716] PM: Registering ACPI NVS region [mem 0xc3df5000-0xc3dfbfff=
] (28672 bytes)
[    0.724769] PM: Registering ACPI NVS region [mem 0xd88e1000-0xd8e21fff=
] (5509120 bytes)
[    0.728559] bus: 'workqueue': registered
[    0.728569] device: 'workqueue': device_add
[    0.728610] PM: Adding info for No Bus:workqueue
[    0.729659] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffff=
fff, max_idle_ns: 7645041785100000 ns
[    0.729736] futex hash table entries: 2048 (order: 6, 262144 bytes)
[    0.730232] bus: 'gpio': registered
[    0.730284] bus: 'virtio': registered
[    0.730287] device class 'regulator': registering
[    0.730421] Registering platform device 'reg-dummy'. Parent at platfor=
m
[    0.730428] device: 'reg-dummy': device_add
[    0.730441] bus: 'platform': add device reg-dummy
[    0.730502] PM: Adding info for platform:reg-dummy
[    0.730532] bus: 'platform': add driver reg-dummy
[    0.730545] bus: 'platform': driver_probe_device: matched device reg-d=
ummy with driver reg-dummy
[    0.730559] bus: 'platform': really_probe: probing driver reg-dummy wi=
th device reg-dummy
[    0.730575] devices_kset: Moving reg-dummy to end of list
[    0.730618] device: 'regulator.0': device_add
[    0.730736] PM: Adding info for No Bus:regulator.0
[    0.730813] driver: 'reg-dummy': driver_bound: bound to device 'reg-du=
mmy'
[    0.730823] bus: 'platform': really_probe: bound device reg-dummy to d=
river reg-dummy
[    0.730884] RTC time: 16:28:01, date: 05/15/17
[    0.732258] NET: Registered protocol family 16
[    0.732841] device class 'bdi': registering
[    0.732907] device class 'gpio': registering
[    0.732939] device class 'pci_bus': registering
[    0.733004] bus: 'pci': registered
[    0.733007] device class 'rapidio_port': registering
[    0.733073] bus: 'rapidio': registered
[    0.733079] device class 'backlight': registering
[    0.733103] device class 'tty': registering
[    0.733127] device class 'vtconsole': registering
[    0.733159] device: 'vtcon0': device_add
[    0.733228] PM: Adding info for No Bus:vtcon0
[    0.733252] device class 'iommu': registering
[    0.733314] bus: 'mipi-dsi': registered
[    0.733369] bus: 'node': registered
[    0.733379] device: 'node': device_add
[    0.733432] PM: Adding info for No Bus:node
[    0.733449] bus: 'platform': add driver syscon
[    0.733525] bus: 'spi': registered
[    0.733527] device class 'spi_master': registering
[    0.733594] bus: 'i2c': registered
[    0.733607] bus: 'i2c': add driver dummy
[    0.733769] cpuidle: using governor ladder
[    0.733897] cpuidle: using governor menu
[    0.733918] PCCT header not found.
[    0.734004] ACPI FADT declares the system doesn't support PCIe ASPM, s=
o disable it
[    0.734040] ACPI: bus type PCI registered
[    0.734124] device class 'dma': registering
[    0.734162] device class 'dmi': registering
[    0.734191] device: 'id': device_add
[    0.734304] PM: Adding info for No Bus:id
[    0.734425] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf80000=
00-0xfbffffff] (base 0xf8000000)
[    0.734461] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E=
820
[    0.734508] PCI: Using configuration type 1 for base access
[    0.734661] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is =
on
[    0.734697] device: 'node0': device_add
[    0.734730] bus: 'node': add device node0
[    0.734772] PM: Adding info for node:node0
[    0.734813] device: 'cpu0': device_add
[    0.734831] bus: 'cpu': add device cpu0
[    0.734874] PM: Adding info for cpu:cpu0
[    0.734980] device: 'cpu1': device_add
[    0.735000] bus: 'cpu': add device cpu1
[    0.735040] PM: Adding info for cpu:cpu1
[    0.735110] device: 'cpu2': device_add
[    0.735130] bus: 'cpu': add device cpu2
[    0.735170] PM: Adding info for cpu:cpu2
[    0.735237] device: 'cpu3': device_add
[    0.735256] bus: 'cpu': add device cpu3
[    0.735298] PM: Adding info for cpu:cpu3
[    0.735366] device: 'cpu4': device_add
[    0.735385] bus: 'cpu': add device cpu4
[    0.735426] PM: Adding info for cpu:cpu4
[    0.735492] device: 'cpu5': device_add
[    0.735511] bus: 'cpu': add device cpu5
[    0.735553] PM: Adding info for cpu:cpu5
[    0.735619] device: 'cpu6': device_add
[    0.735638] bus: 'cpu': add device cpu6
[    0.735679] PM: Adding info for cpu:cpu6
[    0.735749] device: 'cpu7': device_add
[    0.735768] bus: 'cpu': add device cpu7
[    0.735810] PM: Adding info for cpu:cpu7
[    0.745917] device: 'writeback': device_add
[    0.745929] bus: 'workqueue': add device writeback
[    0.745980] PM: Adding info for workqueue:writeback
[    0.746095] HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    0.746118] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.746932] device class 'block': registering
[    0.747134] bus: 'platform': add driver rc5t583-gpio
[    0.747171] bus: 'platform': add driver tps65910-gpio
[    0.747232] device class 'graphics': registering
[    0.747375] ACPI: Added _OSI(Module Device)
[    0.747394] ACPI: Added _OSI(Processor Device)
[    0.747413] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.747431] ACPI: Added _OSI(Processor Aggregator Device)
[    0.748474] ACPI: Executed 1 blocks of module-level executable AML cod=
e
[    0.805273] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.814280] ACPI: Dynamic OEM Table Load:
[    0.814313] ACPI: SSDT 0xFFFF88038BF82880 0003D3 (v01 PmRef  Cpu0Cst  =
00003001 INTL 20051117)
[    0.818953] ACPI: Dynamic OEM Table Load:
[    0.818985] ACPI: SSDT 0xFFFF88038CCB1980 0005AA (v01 PmRef  ApIst    =
00003000 INTL 20051117)
[    0.827094] ACPI: Dynamic OEM Table Load:
[    0.827125] ACPI: SSDT 0xFFFF88038CDC1B80 000119 (v01 PmRef  ApCst    =
00003000 INTL 20051117)
[    0.858057] ACPI: Interpreter enabled
[    0.858191] ACPI: (supports S0 S3 S4 S5)
[    0.858208] ACPI: Using IOAPIC for interrupt routing
[    0.858428] bus: 'acpi': registered
[    0.858434] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.863391] device: 'LNXSYSTM:00': device_add
[    0.863417] bus: 'acpi': add device LNXSYSTM:00
[    0.863468] PM: Adding info for acpi:LNXSYSTM:00
[    0.863759] device: 'LNXCPU:00': device_add
[    0.863772] bus: 'acpi': add device LNXCPU:00
[    0.863822] PM: Adding info for acpi:LNXCPU:00
[    0.864112] device: 'LNXCPU:01': device_add
[    0.864125] bus: 'acpi': add device LNXCPU:01
[    0.864172] PM: Adding info for acpi:LNXCPU:01
[    0.864442] device: 'LNXCPU:02': device_add
[    0.864455] bus: 'acpi': add device LNXCPU:02
[    0.864502] PM: Adding info for acpi:LNXCPU:02
[    0.864748] device: 'LNXCPU:03': device_add
[    0.864760] bus: 'acpi': add device LNXCPU:03
[    0.864807] PM: Adding info for acpi:LNXCPU:03
[    0.865048] device: 'LNXCPU:04': device_add
[    0.865061] bus: 'acpi': add device LNXCPU:04
[    0.865107] PM: Adding info for acpi:LNXCPU:04
[    0.865350] device: 'LNXCPU:05': device_add
[    0.865362] bus: 'acpi': add device LNXCPU:05
[    0.865410] PM: Adding info for acpi:LNXCPU:05
[    0.865651] device: 'LNXCPU:06': device_add
[    0.865664] bus: 'acpi': add device LNXCPU:06
[    0.865711] PM: Adding info for acpi:LNXCPU:06
[    0.865957] device: 'LNXCPU:07': device_add
[    0.865970] bus: 'acpi': add device LNXCPU:07
[    0.866018] PM: Adding info for acpi:LNXCPU:07
[    0.866626] device: 'LNXSYBUS:00': device_add
[    0.866638] bus: 'acpi': add device LNXSYBUS:00
[    0.866685] PM: Adding info for acpi:LNXSYBUS:00
[    0.867313] device: 'PNP0A08:00': device_add
[    0.867326] bus: 'acpi': add device PNP0A08:00
[    0.867375] PM: Adding info for acpi:PNP0A08:00
[    0.868338] device: 'PNP0C01:00': device_add
[    0.868351] bus: 'acpi': add device PNP0C01:00
[    0.868399] PM: Adding info for acpi:PNP0C01:00
[    0.868911] device: 'device:00': device_add
[    0.868924] bus: 'acpi': add device device:00
[    0.868973] PM: Adding info for acpi:device:00
[    0.869482] device: 'PNP0200:00': device_add
[    0.869494] bus: 'acpi': add device PNP0200:00
[    0.869541] PM: Adding info for acpi:PNP0200:00
[    0.870027] device: 'INT0800:00': device_add
[    0.870040] bus: 'acpi': add device INT0800:00
[    0.870089] PM: Adding info for acpi:INT0800:00
[    0.871125] device: 'PNP0103:00': device_add
[    0.871138] bus: 'acpi': add device PNP0103:00
[    0.871186] PM: Adding info for acpi:PNP0103:00
[    0.871689] device: 'PNP0000:00': device_add
[    0.871702] bus: 'acpi': add device PNP0000:00
[    0.871751] PM: Adding info for acpi:PNP0000:00
[    0.872986] device: 'PNP0C04:00': device_add
[    0.872999] bus: 'acpi': add device PNP0C04:00
[    0.873047] PM: Adding info for acpi:PNP0C04:00
[    0.873561] device: 'PNP0C02:00': device_add
[    0.873573] bus: 'acpi': add device PNP0C02:00
[    0.873621] PM: Adding info for acpi:PNP0C02:00
[    0.874114] device: 'PNP0B00:00': device_add
[    0.874127] bus: 'acpi': add device PNP0B00:00
[    0.874174] PM: Adding info for acpi:PNP0B00:00
[    0.874661] device: 'PNP0100:00': device_add
[    0.874674] bus: 'acpi': add device PNP0100:00
[    0.874721] PM: Adding info for acpi:PNP0100:00
[    0.875560] device: 'INT3F0D:00': device_add
[    0.875573] bus: 'acpi': add device INT3F0D:00
[    0.875621] PM: Adding info for acpi:INT3F0D:00
[    0.876144] device: 'PNP0C02:01': device_add
[    0.876157] bus: 'acpi': add device PNP0C02:01
[    0.876204] PM: Adding info for acpi:PNP0C02:01
[    0.876908] device: 'PNP0C02:02': device_add
[    0.876923] bus: 'acpi': add device PNP0C02:02
[    0.876970] PM: Adding info for acpi:PNP0C02:02
[    0.881604] device: 'PNP0501:00': device_add
[    0.881618] bus: 'acpi': add device PNP0501:00
[    0.881666] PM: Adding info for acpi:PNP0501:00
[    0.883945] device: 'PNP0303:00': device_add
[    0.883961] bus: 'acpi': add device PNP0303:00
[    0.884009] PM: Adding info for acpi:PNP0303:00
[    0.886296] device: 'PNP0F03:00': device_add
[    0.886310] bus: 'acpi': add device PNP0F03:00
[    0.886358] PM: Adding info for acpi:PNP0F03:00
[    0.887200] device: 'PNP0C09:00': device_add
[    0.887215] bus: 'acpi': add device PNP0C09:00
[    0.887262] PM: Adding info for acpi:PNP0C09:00
[    0.888005] device: 'PNP0C0A:00': device_add
[    0.888018] bus: 'acpi': add device PNP0C0A:00
[    0.888066] PM: Adding info for acpi:PNP0C0A:00
[    0.888755] device: 'PNP0C0A:01': device_add
[    0.888770] bus: 'acpi': add device PNP0C0A:01
[    0.888818] PM: Adding info for acpi:PNP0C0A:01
[    0.889495] device: 'PNP0C0A:02': device_add
[    0.889508] bus: 'acpi': add device PNP0C0A:02
[    0.889555] PM: Adding info for acpi:PNP0C0A:02
[    0.891810] device: 'device:01': device_add
[    0.891824] bus: 'acpi': add device device:01
[    0.891872] PM: Adding info for acpi:device:01
[    0.893545] device: 'device:02': device_add
[    0.893559] bus: 'acpi': add device device:02
[    0.893607] PM: Adding info for acpi:device:02
[    0.895840] device: 'device:03': device_add
[    0.895854] bus: 'acpi': add device device:03
[    0.895903] PM: Adding info for acpi:device:03
[    0.897576] device: 'device:04': device_add
[    0.897590] bus: 'acpi': add device device:04
[    0.897638] PM: Adding info for acpi:device:04
[    0.899881] device: 'device:05': device_add
[    0.899894] bus: 'acpi': add device device:05
[    0.899944] PM: Adding info for acpi:device:05
[    0.901617] device: 'device:06': device_add
[    0.901630] bus: 'acpi': add device device:06
[    0.901678] PM: Adding info for acpi:device:06
[    0.903912] device: 'device:07': device_add
[    0.903926] bus: 'acpi': add device device:07
[    0.903975] PM: Adding info for acpi:device:07
[    0.905642] device: 'device:08': device_add
[    0.905655] bus: 'acpi': add device device:08
[    0.905703] PM: Adding info for acpi:device:08
[    0.907934] device: 'device:09': device_add
[    0.907948] bus: 'acpi': add device device:09
[    0.907995] PM: Adding info for acpi:device:09
[    0.909670] device: 'device:0a': device_add
[    0.909683] bus: 'acpi': add device device:0a
[    0.909731] PM: Adding info for acpi:device:0a
[    0.911964] device: 'device:0b': device_add
[    0.911978] bus: 'acpi': add device device:0b
[    0.912025] PM: Adding info for acpi:device:0b
[    0.913700] device: 'device:0c': device_add
[    0.913713] bus: 'acpi': add device device:0c
[    0.913763] PM: Adding info for acpi:device:0c
[    0.915991] device: 'device:0d': device_add
[    0.916005] bus: 'acpi': add device device:0d
[    0.916052] PM: Adding info for acpi:device:0d
[    0.917724] device: 'device:0e': device_add
[    0.917738] bus: 'acpi': add device device:0e
[    0.917787] PM: Adding info for acpi:device:0e
[    0.918289] device: 'device:0f': device_add
[    0.918302] bus: 'acpi': add device device:0f
[    0.918348] PM: Adding info for acpi:device:0f
[    0.918830] device: 'device:10': device_add
[    0.918842] bus: 'acpi': add device device:10
[    0.918891] PM: Adding info for acpi:device:10
[    0.919371] device: 'device:11': device_add
[    0.919384] bus: 'acpi': add device device:11
[    0.919430] PM: Adding info for acpi:device:11
[    0.919916] device: 'device:12': device_add
[    0.919934] bus: 'acpi': add device device:12
[    0.919980] PM: Adding info for acpi:device:12
[    0.922223] device: 'device:13': device_add
[    0.922238] bus: 'acpi': add device device:13
[    0.922286] PM: Adding info for acpi:device:13
[    0.923951] device: 'device:14': device_add
[    0.923964] bus: 'acpi': add device device:14
[    0.924012] PM: Adding info for acpi:device:14
[    0.925632] device: 'device:15': device_add
[    0.925645] bus: 'acpi': add device device:15
[    0.925695] PM: Adding info for acpi:device:15
[    0.927888] device: 'device:16': device_add
[    0.927902] bus: 'acpi': add device device:16
[    0.927949] PM: Adding info for acpi:device:16
[    0.928465] device: 'device:17': device_add
[    0.928478] bus: 'acpi': add device device:17
[    0.928527] PM: Adding info for acpi:device:17
[    0.929008] device: 'device:18': device_add
[    0.929020] bus: 'acpi': add device device:18
[    0.929067] PM: Adding info for acpi:device:18
[    0.929554] device: 'device:19': device_add
[    0.929567] bus: 'acpi': add device device:19
[    0.929613] PM: Adding info for acpi:device:19
[    0.930107] device: 'device:1a': device_add
[    0.930122] bus: 'acpi': add device device:1a
[    0.930168] PM: Adding info for acpi:device:1a
[    0.930653] device: 'device:1b': device_add
[    0.930666] bus: 'acpi': add device device:1b
[    0.930712] PM: Adding info for acpi:device:1b
[    0.931197] device: 'device:1c': device_add
[    0.931209] bus: 'acpi': add device device:1c
[    0.931257] PM: Adding info for acpi:device:1c
[    0.931745] device: 'device:1d': device_add
[    0.931758] bus: 'acpi': add device device:1d
[    0.931805] PM: Adding info for acpi:device:1d
[    0.932297] device: 'device:1e': device_add
[    0.932309] bus: 'acpi': add device device:1e
[    0.932371] PM: Adding info for acpi:device:1e
[    0.932862] device: 'device:1f': device_add
[    0.932875] bus: 'acpi': add device device:1f
[    0.932922] PM: Adding info for acpi:device:1f
[    0.933414] device: 'device:20': device_add
[    0.933427] bus: 'acpi': add device device:20
[    0.933475] PM: Adding info for acpi:device:20
[    0.935676] device: 'device:21': device_add
[    0.935689] bus: 'acpi': add device device:21
[    0.935737] PM: Adding info for acpi:device:21
[    0.936238] device: 'device:22': device_add
[    0.936251] bus: 'acpi': add device device:22
[    0.936298] PM: Adding info for acpi:device:22
[    0.936796] device: 'device:23': device_add
[    0.936809] bus: 'acpi': add device device:23
[    0.936859] PM: Adding info for acpi:device:23
[    0.937343] device: 'device:24': device_add
[    0.937356] bus: 'acpi': add device device:24
[    0.937403] PM: Adding info for acpi:device:24
[    0.937888] device: 'device:25': device_add
[    0.937900] bus: 'acpi': add device device:25
[    0.937948] PM: Adding info for acpi:device:25
[    0.938441] device: 'device:26': device_add
[    0.938453] bus: 'acpi': add device device:26
[    0.938500] PM: Adding info for acpi:device:26
[    0.938989] device: 'device:27': device_add
[    0.939002] bus: 'acpi': add device device:27
[    0.939050] PM: Adding info for acpi:device:27
[    0.939535] device: 'device:28': device_add
[    0.939548] bus: 'acpi': add device device:28
[    0.939594] PM: Adding info for acpi:device:28
[    0.940080] device: 'device:29': device_add
[    0.940092] bus: 'acpi': add device device:29
[    0.940139] PM: Adding info for acpi:device:29
[    0.942013] device: 'device:2a': device_add
[    0.942029] bus: 'acpi': add device device:2a
[    0.942076] PM: Adding info for acpi:device:2a
[    0.942854] device: 'device:2b': device_add
[    0.942867] bus: 'acpi': add device device:2b
[    0.942915] PM: Adding info for acpi:device:2b
[    0.943422] device: 'device:2c': device_add
[    0.943434] bus: 'acpi': add device device:2c
[    0.943483] PM: Adding info for acpi:device:2c
[    0.943997] device: 'device:2d': device_add
[    0.944009] bus: 'acpi': add device device:2d
[    0.944056] PM: Adding info for acpi:device:2d
[    0.944586] device: 'device:2e': device_add
[    0.944599] bus: 'acpi': add device device:2e
[    0.944649] PM: Adding info for acpi:device:2e
[    0.945160] device: 'device:2f': device_add
[    0.945173] bus: 'acpi': add device device:2f
[    0.945220] PM: Adding info for acpi:device:2f
[    0.945731] device: 'device:30': device_add
[    0.945744] bus: 'acpi': add device device:30
[    0.945792] PM: Adding info for acpi:device:30
[    0.946306] device: 'device:31': device_add
[    0.946319] bus: 'acpi': add device device:31
[    0.946366] PM: Adding info for acpi:device:31
[    0.946876] device: 'device:32': device_add
[    0.946888] bus: 'acpi': add device device:32
[    0.946935] PM: Adding info for acpi:device:32
[    0.947448] device: 'device:33': device_add
[    0.947461] bus: 'acpi': add device device:33
[    0.947508] PM: Adding info for acpi:device:33
[    0.948017] device: 'device:34': device_add
[    0.948029] bus: 'acpi': add device device:34
[    0.948076] PM: Adding info for acpi:device:34
[    0.949247] device: 'device:35': device_add
[    0.949262] bus: 'acpi': add device device:35
[    0.949310] PM: Adding info for acpi:device:35
[    0.950456] device: 'device:36': device_add
[    0.950470] bus: 'acpi': add device device:36
[    0.950517] PM: Adding info for acpi:device:36
[    0.951660] device: 'device:37': device_add
[    0.951673] bus: 'acpi': add device device:37
[    0.951722] PM: Adding info for acpi:device:37
[    0.952884] device: 'device:38': device_add
[    0.952898] bus: 'acpi': add device device:38
[    0.952945] PM: Adding info for acpi:device:38
[    0.953878] device: 'device:39': device_add
[    0.953891] bus: 'acpi': add device device:39
[    0.953941] PM: Adding info for acpi:device:39
[    0.954872] device: 'device:3a': device_add
[    0.954885] bus: 'acpi': add device device:3a
[    0.954933] PM: Adding info for acpi:device:3a
[    0.955662] device: 'device:3b': device_add
[    0.955675] bus: 'acpi': add device device:3b
[    0.955725] PM: Adding info for acpi:device:3b
[    0.956473] device: 'device:3c': device_add
[    0.956487] bus: 'acpi': add device device:3c
[    0.956534] PM: Adding info for acpi:device:3c
[    0.957270] device: 'device:3d': device_add
[    0.957284] bus: 'acpi': add device device:3d
[    0.957333] PM: Adding info for acpi:device:3d
[    0.958065] device: 'device:3e': device_add
[    0.958078] bus: 'acpi': add device device:3e
[    0.958125] PM: Adding info for acpi:device:3e
[    0.959054] device: 'device:3f': device_add
[    0.959067] bus: 'acpi': add device device:3f
[    0.959114] PM: Adding info for acpi:device:3f
[    0.960046] device: 'device:40': device_add
[    0.960059] bus: 'acpi': add device device:40
[    0.960107] PM: Adding info for acpi:device:40
[    0.961738] device: 'device:41': device_add
[    0.961752] bus: 'acpi': add device device:41
[    0.961800] PM: Adding info for acpi:device:41
[    0.962300] device: 'device:42': device_add
[    0.962313] bus: 'acpi': add device device:42
[    0.962362] PM: Adding info for acpi:device:42
[    0.962849] device: 'device:43': device_add
[    0.962862] bus: 'acpi': add device device:43
[    0.962909] PM: Adding info for acpi:device:43
[    0.963393] device: 'device:44': device_add
[    0.963405] bus: 'acpi': add device device:44
[    0.963454] PM: Adding info for acpi:device:44
[    0.964591] device: 'device:45': device_add
[    0.964605] bus: 'acpi': add device device:45
[    0.964653] PM: Adding info for acpi:device:45
[    0.965157] device: 'device:46': device_add
[    0.965170] bus: 'acpi': add device device:46
[    0.965219] PM: Adding info for acpi:device:46
[    0.965702] device: 'device:47': device_add
[    0.965714] bus: 'acpi': add device device:47
[    0.965762] PM: Adding info for acpi:device:47
[    0.966246] device: 'device:48': device_add
[    0.966259] bus: 'acpi': add device device:48
[    0.966306] PM: Adding info for acpi:device:48
[    0.966786] device: 'device:49': device_add
[    0.966801] bus: 'acpi': add device device:49
[    0.966848] PM: Adding info for acpi:device:49
[    0.967333] device: 'device:4a': device_add
[    0.967346] bus: 'acpi': add device device:4a
[    0.967393] PM: Adding info for acpi:device:4a
[    0.967874] device: 'device:4b': device_add
[    0.967887] bus: 'acpi': add device device:4b
[    0.967936] PM: Adding info for acpi:device:4b
[    0.968444] device: 'device:4c': device_add
[    0.968457] bus: 'acpi': add device device:4c
[    0.968505] PM: Adding info for acpi:device:4c
[    0.968995] device: 'device:4d': device_add
[    0.969007] bus: 'acpi': add device device:4d
[    0.969056] PM: Adding info for acpi:device:4d
[    0.969653] device: 'PNP0C02:03': device_add
[    0.969666] bus: 'acpi': add device PNP0C02:03
[    0.969713] PM: Adding info for acpi:PNP0C02:03
[    0.970415] device: 'ABCD0000:00': device_add
[    0.970428] bus: 'acpi': add device ABCD0000:00
[    0.970475] PM: Adding info for acpi:ABCD0000:00
[    0.972608] device: 'device:4e': device_add
[    0.972622] bus: 'acpi': add device device:4e
[    0.972674] PM: Adding info for acpi:device:4e
[    0.974300] device: 'device:4f': device_add
[    0.974313] bus: 'acpi': add device device:4f
[    0.974360] PM: Adding info for acpi:device:4f
[    0.976454] device: 'device:50': device_add
[    0.976471] bus: 'acpi': add device device:50
[    0.976518] PM: Adding info for acpi:device:50
[    0.978630] device: 'device:51': device_add
[    0.978643] bus: 'acpi': add device device:51
[    0.978691] PM: Adding info for acpi:device:51
[    0.979579] device: 'device:52': device_add
[    0.979592] bus: 'acpi': add device device:52
[    0.979642] PM: Adding info for acpi:device:52
[    0.980292] device: 'LNXVIDEO:00': device_add
[    0.980304] bus: 'acpi': add device LNXVIDEO:00
[    0.980351] PM: Adding info for acpi:LNXVIDEO:00
[    0.981573] device: 'device:53': device_add
[    0.981586] bus: 'acpi': add device device:53
[    0.981636] PM: Adding info for acpi:device:53
[    0.982537] device: 'device:54': device_add
[    0.982551] bus: 'acpi': add device device:54
[    0.982598] PM: Adding info for acpi:device:54
[    0.983474] device: 'device:55': device_add
[    0.983488] bus: 'acpi': add device device:55
[    0.983537] PM: Adding info for acpi:device:55
[    0.984407] device: 'device:56': device_add
[    0.984420] bus: 'acpi': add device device:56
[    0.984481] PM: Adding info for acpi:device:56
[    0.985355] device: 'device:57': device_add
[    0.985368] bus: 'acpi': add device device:57
[    0.985415] PM: Adding info for acpi:device:57
[    0.986286] device: 'device:58': device_add
[    0.986301] bus: 'acpi': add device device:58
[    0.986348] PM: Adding info for acpi:device:58
[    0.987217] device: 'device:59': device_add
[    0.987230] bus: 'acpi': add device device:59
[    0.987277] PM: Adding info for acpi:device:59
[    0.988147] device: 'device:5a': device_add
[    0.988160] bus: 'acpi': add device device:5a
[    0.988209] PM: Adding info for acpi:device:5a
[    0.989026] device: 'device:5b': device_add
[    0.989040] bus: 'acpi': add device device:5b
[    0.989087] PM: Adding info for acpi:device:5b
[    0.989881] device: 'device:5c': device_add
[    0.989894] bus: 'acpi': add device device:5c
[    0.989943] PM: Adding info for acpi:device:5c
[    0.990739] device: 'device:5d': device_add
[    0.990752] bus: 'acpi': add device device:5d
[    0.990799] PM: Adding info for acpi:device:5d
[    0.991598] device: 'device:5e': device_add
[    0.991611] bus: 'acpi': add device device:5e
[    0.991658] PM: Adding info for acpi:device:5e
[    0.992467] device: 'device:5f': device_add
[    0.992483] bus: 'acpi': add device device:5f
[    0.992530] PM: Adding info for acpi:device:5f
[    0.993329] device: 'device:60': device_add
[    0.993343] bus: 'acpi': add device device:60
[    0.993390] PM: Adding info for acpi:device:60
[    0.994185] device: 'device:61': device_add
[    0.994198] bus: 'acpi': add device device:61
[    0.994248] PM: Adding info for acpi:device:61
[    0.994982] device: 'device:62': device_add
[    0.994995] bus: 'acpi': add device device:62
[    0.995042] PM: Adding info for acpi:device:62
[    0.996263] device: 'PNP0C0F:00': device_add
[    0.996276] bus: 'acpi': add device PNP0C0F:00
[    0.996325] PM: Adding info for acpi:PNP0C0F:00
[    0.997218] device: 'PNP0C0F:01': device_add
[    0.997232] bus: 'acpi': add device PNP0C0F:01
[    0.997280] PM: Adding info for acpi:PNP0C0F:01
[    0.998162] device: 'PNP0C0F:02': device_add
[    0.998175] bus: 'acpi': add device PNP0C0F:02
[    0.998225] PM: Adding info for acpi:PNP0C0F:02
[    0.999109] device: 'PNP0C0F:03': device_add
[    0.999122] bus: 'acpi': add device PNP0C0F:03
[    0.999170] PM: Adding info for acpi:PNP0C0F:03
[    1.000055] device: 'PNP0C0F:04': device_add
[    1.000068] bus: 'acpi': add device PNP0C0F:04
[    1.000118] PM: Adding info for acpi:PNP0C0F:04
[    1.001018] device: 'PNP0C0F:05': device_add
[    1.001031] bus: 'acpi': add device PNP0C0F:05
[    1.001079] PM: Adding info for acpi:PNP0C0F:05
[    1.001961] device: 'PNP0C0F:06': device_add
[    1.001974] bus: 'acpi': add device PNP0C0F:06
[    1.002024] PM: Adding info for acpi:PNP0C0F:06
[    1.002912] device: 'PNP0C0F:07': device_add
[    1.002925] bus: 'acpi': add device PNP0C0F:07
[    1.002973] PM: Adding info for acpi:PNP0C0F:07
[    1.003515] device: 'PNP0C0C:00': device_add
[    1.003528] bus: 'acpi': add device PNP0C0C:00
[    1.003577] PM: Adding info for acpi:PNP0C0C:00
[    1.004679] device: 'INT33D2:00': device_add
[    1.004693] bus: 'acpi': add device INT33D2:00
[    1.004741] PM: Adding info for acpi:INT33D2:00
[    1.005810] device: 'INT33D3:00': device_add
[    1.005823] bus: 'acpi': add device INT33D3:00
[    1.005872] PM: Adding info for acpi:INT33D3:00
[    1.006935] device: 'INT33D4:00': device_add
[    1.006948] bus: 'acpi': add device INT33D4:00
[    1.006996] PM: Adding info for acpi:INT33D4:00
[    1.008185] device: 'INT33A1:00': device_add
[    1.008199] bus: 'acpi': add device INT33A1:00
[    1.008249] PM: Adding info for acpi:INT33A1:00
[    1.009399] device: 'INT3420:00': device_add
[    1.009413] bus: 'acpi': add device INT3420:00
[    1.009460] PM: Adding info for acpi:INT3420:00
[    1.010174] device: 'PNP0C0D:00': device_add
[    1.010187] bus: 'acpi': add device PNP0C0D:00
[    1.010237] PM: Adding info for acpi:PNP0C0D:00
[    1.011174] device: 'PNP0C01:01': device_add
[    1.011187] bus: 'acpi': add device PNP0C01:01
[    1.011235] PM: Adding info for acpi:PNP0C01:01
[    1.011737] device: 'LNXSYBUS:01': device_add
[    1.011750] bus: 'acpi': add device LNXSYBUS:01
[    1.011799] PM: Adding info for acpi:LNXSYBUS:01
[    1.012125] ACPI: Power Resource [FN00] (off)
[    1.012161] device: 'LNXPOWER:00': device_add
[    1.012174] bus: 'acpi': add device LNXPOWER:00
[    1.012222] PM: Adding info for acpi:LNXPOWER:00
[    1.013025] device: 'PNP0C0B:00': device_add
[    1.013039] bus: 'acpi': add device PNP0C0B:00
[    1.013089] PM: Adding info for acpi:PNP0C0B:00
[    1.013426] ACPI: Power Resource [FN01] (off)
[    1.013463] device: 'LNXPOWER:01': device_add
[    1.013477] bus: 'acpi': add device LNXPOWER:01
[    1.013525] PM: Adding info for acpi:LNXPOWER:01
[    1.014271] device: 'PNP0C0B:01': device_add
[    1.014284] bus: 'acpi': add device PNP0C0B:01
[    1.014334] PM: Adding info for acpi:PNP0C0B:01
[    1.014666] ACPI: Power Resource [FN02] (off)
[    1.014701] device: 'LNXPOWER:02': device_add
[    1.014715] bus: 'acpi': add device LNXPOWER:02
[    1.014765] PM: Adding info for acpi:LNXPOWER:02
[    1.015507] device: 'PNP0C0B:02': device_add
[    1.015522] bus: 'acpi': add device PNP0C0B:02
[    1.015570] PM: Adding info for acpi:PNP0C0B:02
[    1.015901] ACPI: Power Resource [FN03] (off)
[    1.015936] device: 'LNXPOWER:03': device_add
[    1.015949] bus: 'acpi': add device LNXPOWER:03
[    1.015997] PM: Adding info for acpi:LNXPOWER:03
[    1.016762] device: 'PNP0C0B:03': device_add
[    1.016776] bus: 'acpi': add device PNP0C0B:03
[    1.016824] PM: Adding info for acpi:PNP0C0B:03
[    1.017155] ACPI: Power Resource [FN04] (off)
[    1.017191] device: 'LNXPOWER:04': device_add
[    1.017204] bus: 'acpi': add device LNXPOWER:04
[    1.017254] PM: Adding info for acpi:LNXPOWER:04
[    1.018000] device: 'PNP0C0B:04': device_add
[    1.018013] bus: 'acpi': add device PNP0C0B:04
[    1.018061] PM: Adding info for acpi:PNP0C0B:04
[    1.018294] device: 'LNXTHERM:00': device_add
[    1.018306] bus: 'acpi': add device LNXTHERM:00
[    1.018356] PM: Adding info for acpi:LNXTHERM:00
[    1.018594] device: 'LNXTHERM:01': device_add
[    1.018607] bus: 'acpi': add device LNXTHERM:01
[    1.018654] PM: Adding info for acpi:LNXTHERM:01
[    1.020090] device: 'PNP0A0A:00': device_add
[    1.020103] bus: 'acpi': add device PNP0A0A:00
[    1.020153] PM: Adding info for acpi:PNP0A0A:00
[    1.021337] device: 'SKTD000:00': device_add
[    1.021351] bus: 'acpi': add device SKTD000:00
[    1.021399] PM: Adding info for acpi:SKTD000:00
[    1.022220] device: 'NXP5442:00': device_add
[    1.022234] bus: 'acpi': add device NXP5442:00
[    1.022283] PM: Adding info for acpi:NXP5442:00
[    1.023103] device: 'ICV0A12:00': device_add
[    1.023116] bus: 'acpi': add device ICV0A12:00
[    1.023164] PM: Adding info for acpi:ICV0A12:00
[    1.023747] device: 'device:63': device_add
[    1.023760] bus: 'acpi': add device device:63
[    1.023809] PM: Adding info for acpi:device:63
[    1.024318] device: 'PNP0C14:00': device_add
[    1.024330] bus: 'acpi': add device PNP0C14:00
[    1.024377] PM: Adding info for acpi:PNP0C14:00
[    1.030089] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.030132] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cl=
ockPM Segments MSI]
[    1.034540] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotp=
lug PME]
[    1.037705] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability=
]
[    1.037731] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using=
 BIOS configuration
[    1.042786] device: 'pci0000:00': device_add
[    1.042859] PM: Adding info for No Bus:pci0000:00
[    1.042872] device: '0000:00': device_add
[    1.042967] PM: Adding info for No Bus:0000:00
[    1.044598] PCI host bridge to bus 0000:00
[    1.044624] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 wind=
ow]
[    1.044653] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff wind=
ow]
[    1.044682] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff window]
[    1.044717] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7=
fff window]
[    1.044752] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000db=
fff window]
[    1.044786] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000df=
fff window]
[    1.044821] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3=
fff window]
[    1.044855] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7=
fff window]
[    1.044890] pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeaff=
fff window]
[    1.044925] pci_bus 0000:00: root bus resource [bus 00-3e]
[    1.044986] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    1.045107] device: '0000:00:00.0': device_add
[    1.045872] bus: 'pci': add device 0000:00:00.0
[    1.045998] PM: Adding info for pci:0000:00:00.0
[    1.046052] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    1.046168] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.046200] device: '0000:00:01.0': device_add
[    1.048325] pci 0000:00:01.0: System wakeup disabled by ACPI
[    1.048361] bus: 'pci': add device 0000:00:01.0
[    1.048526] PM: Adding info for pci:0000:00:01.0
[    1.048592] pci 0000:00:02.0: [8086:0412] type 00 class 0x030000
[    1.048612] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64b=
it]
[    1.048624] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64b=
it pref]
[    1.048633] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    1.048719] device: '0000:00:02.0': device_add
[    1.049582] bus: 'pci': add device 0000:00:02.0
[    1.049705] PM: Adding info for pci:0000:00:02.0
[    1.049747] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    1.049764] pci 0000:00:03.0: reg 0x10: [mem 0xf7f14000-0xf7f17fff 64b=
it]
[    1.049875] device: '0000:00:03.0': device_add
[    1.050728] bus: 'pci': add device 0000:00:03.0
[    1.050851] PM: Adding info for pci:0000:00:03.0
[    1.050920] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    1.050945] pci 0000:00:14.0: reg 0x10: [mem 0xf7f00000-0xf7f0ffff 64b=
it]
[    1.051068] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    1.051084] device: '0000:00:14.0': device_add
[    1.052007] pci 0000:00:14.0: System wakeup disabled by ACPI
[    1.052042] bus: 'pci': add device 0000:00:14.0
[    1.052202] PM: Adding info for pci:0000:00:14.0
[    1.052245] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    1.052272] pci 0000:00:16.0: reg 0x10: [mem 0xf7f1e000-0xf7f1e00f 64b=
it]
[    1.052395] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    1.052411] device: '0000:00:16.0': device_add
[    1.053188] bus: 'pci': add device 0000:00:16.0
[    1.053348] PM: Adding info for pci:0000:00:16.0
[    1.053407] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    1.053432] pci 0000:00:1a.0: reg 0x10: [mem 0xf7f1c000-0xf7f1c3ff]
[    1.053578] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.053597] device: '0000:00:1a.0': device_add
[    1.054702] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    1.054737] bus: 'pci': add device 0000:00:1a.0
[    1.054897] PM: Adding info for pci:0000:00:1a.0
[    1.054945] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    1.054969] pci 0000:00:1b.0: reg 0x10: [mem 0xf7f10000-0xf7f13fff 64b=
it]
[    1.055112] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.055133] device: '0000:00:1b.0': device_add
[    1.056052] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    1.056088] bus: 'pci': add device 0000:00:1b.0
[    1.056248] PM: Adding info for pci:0000:00:1b.0
[    1.056292] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    1.056425] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.056476] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    1.056497] pci 0000:00:1c.0: Intel PCH root port ACS workaround enabl=
ed
[    1.056528] device: '0000:00:1c.0': device_add
[    1.058371] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.058407] bus: 'pci': add device 0000:00:1c.0
[    1.058569] PM: Adding info for pci:0000:00:1c.0
[    1.058616] pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
[    1.058753] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.058797] pci 0000:00:1c.2: Enabling MPC IRBNCE
[    1.058819] pci 0000:00:1c.2: Intel PCH root port ACS workaround enabl=
ed
[    1.058849] device: '0000:00:1c.2': device_add
[    1.060693] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    1.060729] bus: 'pci': add device 0000:00:1c.2
[    1.060892] PM: Adding info for pci:0000:00:1c.2
[    1.060937] pci 0000:00:1c.3: [8086:244e] type 01 class 0x060401
[    1.061072] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    1.061094] device: '0000:00:1c.3': device_add
[    1.062922] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    1.062957] bus: 'pci': add device 0000:00:1c.3
[    1.063119] PM: Adding info for pci:0000:00:1c.3
[    1.063172] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    1.063197] pci 0000:00:1d.0: reg 0x10: [mem 0xf7f1b000-0xf7f1b3ff]
[    1.063344] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.063363] device: '0000:00:1d.0': device_add
[    1.064471] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.064506] bus: 'pci': add device 0000:00:1d.0
[    1.064683] PM: Adding info for pci:0000:00:1d.0
[    1.064729] pci 0000:00:1f.0: [8086:8c4a] type 00 class 0x060100
[    1.064905] device: '0000:00:1f.0': device_add
[    1.065760] bus: 'pci': add device 0000:00:1f.0
[    1.065884] PM: Adding info for pci:0000:00:1f.0
[    1.065927] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    1.065948] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    1.065960] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    1.065971] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    1.065982] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    1.065994] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    1.066005] pci 0000:00:1f.2: reg 0x24: [mem 0xf7f1a000-0xf7f1a7ff]
[    1.066092] pci 0000:00:1f.2: PME# supported from D3hot
[    1.066108] device: '0000:00:1f.2': device_add
[    1.066962] bus: 'pci': add device 0000:00:1f.2
[    1.067123] PM: Adding info for pci:0000:00:1f.2
[    1.067162] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    1.067184] pci 0000:00:1f.3: reg 0x10: [mem 0xf7f19000-0xf7f190ff 64b=
it]
[    1.067213] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    1.067287] device: '0000:00:1f.3': device_add
[    1.068146] bus: 'pci': add device 0000:00:1f.3
[    1.068270] PM: Adding info for pci:0000:00:1f.3
[    1.068336] device: '0000:01': device_add
[    1.068426] PM: Adding info for No Bus:0000:01
[    1.068511] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.068590] device: '0000:02': device_add
[    1.068686] PM: Adding info for No Bus:0000:02
[    1.068805] pci 0000:02:00.0: [8086:08b1] type 00 class 0x028000
[    1.068852] pci 0000:02:00.0: reg 0x10: [mem 0xf7e00000-0xf7e01fff 64b=
it]
[    1.069149] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    1.069219] device: '0000:02:00.0': device_add
[    1.069443] pci 0000:02:00.0: System wakeup disabled by ACPI
[    1.069478] bus: 'pci': add device 0000:02:00.0
[    1.069644] PM: Adding info for pci:0000:02:00.0
[    1.080657] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    1.080684] pci 0000:00:1c.0:   bridge window [mem 0xf7e00000-0xf7efff=
ff]
[    1.080739] device: '0000:03': device_add
[    1.080829] PM: Adding info for No Bus:0000:03
[    1.080943] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    1.080970] pci 0000:03:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    1.081008] pci 0000:03:00.0: reg 0x18: [mem 0xf7d00000-0xf7d00fff 64b=
it]
[    1.081032] pci 0000:03:00.0: reg 0x20: [mem 0xf0000000-0xf0003fff 64b=
it pref]
[    1.081231] pci 0000:03:00.0: supports D1 D2
[    1.081234] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    1.081294] device: '0000:03:00.0': device_add
[    1.081514] pci 0000:03:00.0: System wakeup disabled by ACPI
[    1.081549] bus: 'pci': add device 0000:03:00.0
[    1.081716] PM: Adding info for pci:0000:03:00.0
[    1.092652] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    1.092676] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[    1.092681] pci 0000:00:1c.2:   bridge window [mem 0xf7d00000-0xf7dfff=
ff]
[    1.092689] pci 0000:00:1c.2:   bridge window [mem 0xf0000000-0xf00fff=
ff 64bit pref]
[    1.092738] device: '0000:04': device_add
[    1.092829] PM: Adding info for No Bus:0000:04
[    1.092934] pci 0000:04:00.0: [1b21:1080] type 01 class 0x060401
[    1.093124] device: '0000:04:00.0': device_add
[    1.093342] pci 0000:04:00.0: System wakeup disabled by ACPI
[    1.093377] bus: 'pci': add device 0000:04:00.0
[    1.093544] PM: Adding info for pci:0000:04:00.0
[    1.093577] pci 0000:00:1c.3: PCI bridge to [bus 04-05] (subtractive d=
ecode)
[    1.093606] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    1.093611] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfff=
ff]
[    1.093624] pci 0000:00:1c.3:   bridge window [io  0x0000-0x0cf7 windo=
w] (subtractive decode)
[    1.093631] pci 0000:00:1c.3:   bridge window [io  0x0d00-0xffff windo=
w] (subtractive decode)
[    1.093639] pci 0000:00:1c.3:   bridge window [mem 0x000a0000-0x000bff=
ff window] (subtractive decode)
[    1.093646] pci 0000:00:1c.3:   bridge window [mem 0x000d4000-0x000d7f=
ff window] (subtractive decode)
[    1.093653] pci 0000:00:1c.3:   bridge window [mem 0x000d8000-0x000dbf=
ff window] (subtractive decode)
[    1.093660] pci 0000:00:1c.3:   bridge window [mem 0x000dc000-0x000dff=
ff window] (subtractive decode)
[    1.093667] pci 0000:00:1c.3:   bridge window [mem 0x000e0000-0x000e3f=
ff window] (subtractive decode)
[    1.093674] pci 0000:00:1c.3:   bridge window [mem 0x000e4000-0x000e7f=
ff window] (subtractive decode)
[    1.093681] pci 0000:00:1c.3:   bridge window [mem 0xdf200000-0xfeafff=
ff window] (subtractive decode)
[    1.093724] device: '0000:05': device_add
[    1.093814] PM: Adding info for No Bus:0000:05
[    1.093858] pci 0000:05:00.0: [104b:8130] type 00 class 0x010000
[    1.093886] pci 0000:05:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    1.093905] pci 0000:05:00.0: reg 0x14: [mem 0xf7c08000-0xf7c08fff]
[    1.093992] pci 0000:05:00.0: reg 0x30: [mem 0xf7c00000-0xf7c07fff pre=
f]
[    1.094133] device: '0000:05:00.0': device_add
[    1.094155] bus: 'pci': add device 0000:05:00.0
[    1.094286] PM: Adding info for pci:0000:05:00.0
[    1.094393] pci 0000:04:00.0: PCI bridge to [bus 05] (subtractive deco=
de)
[    1.094427] pci 0000:04:00.0:   bridge window [io  0xd000-0xdfff]
[    1.094434] pci 0000:04:00.0:   bridge window [mem 0xf7c00000-0xf7cfff=
ff]
[    1.094450] pci 0000:04:00.0:   bridge window [io  0xd000-0xdfff] (sub=
tractive decode)
[    1.094457] pci 0000:04:00.0:   bridge window [mem 0xf7c00000-0xf7cfff=
ff] (subtractive decode)
[    1.094465] pci 0000:04:00.0:   bridge window [io  0x0000-0x0cf7 windo=
w] (subtractive decode)
[    1.094472] pci 0000:04:00.0:   bridge window [io  0x0d00-0xffff windo=
w] (subtractive decode)
[    1.094480] pci 0000:04:00.0:   bridge window [mem 0x000a0000-0x000bff=
ff window] (subtractive decode)
[    1.094487] pci 0000:04:00.0:   bridge window [mem 0x000d4000-0x000d7f=
ff window] (subtractive decode)
[    1.094494] pci 0000:04:00.0:   bridge window [mem 0x000d8000-0x000dbf=
ff window] (subtractive decode)
[    1.094501] pci 0000:04:00.0:   bridge window [mem 0x000dc000-0x000dff=
ff window] (subtractive decode)
[    1.094509] pci 0000:04:00.0:   bridge window [mem 0x000e0000-0x000e3f=
ff window] (subtractive decode)
[    1.094516] pci 0000:04:00.0:   bridge window [mem 0x000e4000-0x000e7f=
ff window] (subtractive decode)
[    1.094523] pci 0000:04:00.0:   bridge window [mem 0xdf200000-0xfeafff=
ff window] (subtractive decode)
[    1.095005] Registering platform device 'INT0800:00'. Parent at 0000:0=
0:1f.0
[    1.095012] device: 'INT0800:00': device_add
[    1.095044] bus: 'platform': add device INT0800:00
[    1.095106] PM: Adding info for platform:INT0800:00
[    1.096496] Registering platform device 'PNP0103:00'. Parent at 0000:0=
0:1f.0
[    1.096503] device: 'PNP0103:00': device_add
[    1.096533] bus: 'platform': add device PNP0103:00
[    1.096592] PM: Adding info for platform:PNP0103:00
[    1.097074] Registering platform device 'PNP0C04:00'. Parent at 0000:0=
0:1f.0
[    1.097081] device: 'PNP0C04:00': device_add
[    1.097111] bus: 'platform': add device PNP0C04:00
[    1.097171] PM: Adding info for platform:PNP0C04:00
[    1.105663] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 =
14 15)
[    1.106629] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 1=
4 15) *0, disabled.
[    1.107591] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 10 11 12 =
14 15)
[    1.108538] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 1=
4 *15)
[    1.109507] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 =
14 15)
[    1.110456] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 =
14 15)
[    1.111401] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 =
14 15)
[    1.112344] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *=
14 15)
[    1.112615] Registering platform device 'PNP0C0C:00'. Parent at platfo=
rm
[    1.112622] device: 'PNP0C0C:00': device_add
[    1.112667] bus: 'platform': add device PNP0C0C:00
[    1.112730] PM: Adding info for platform:PNP0C0C:00
[    1.114694] Registering platform device 'PNP0C0B:00'. Parent at platfo=
rm
[    1.114701] device: 'PNP0C0B:00': device_add
[    1.114730] bus: 'platform': add device PNP0C0B:00
[    1.114789] PM: Adding info for platform:PNP0C0B:00
[    1.114981] Registering platform device 'PNP0C0B:01'. Parent at platfo=
rm
[    1.114987] device: 'PNP0C0B:01': device_add
[    1.115016] bus: 'platform': add device PNP0C0B:01
[    1.115071] PM: Adding info for platform:PNP0C0B:01
[    1.115258] Registering platform device 'PNP0C0B:02'. Parent at platfo=
rm
[    1.115265] device: 'PNP0C0B:02': device_add
[    1.115293] bus: 'platform': add device PNP0C0B:02
[    1.115351] PM: Adding info for platform:PNP0C0B:02
[    1.115544] Registering platform device 'PNP0C0B:03'. Parent at platfo=
rm
[    1.115550] device: 'PNP0C0B:03': device_add
[    1.115578] bus: 'platform': add device PNP0C0B:03
[    1.115634] PM: Adding info for platform:PNP0C0B:03
[    1.115822] Registering platform device 'PNP0C0B:04'. Parent at platfo=
rm
[    1.115829] device: 'PNP0C0B:04': device_add
[    1.115857] bus: 'platform': add device PNP0C0B:04
[    1.115915] PM: Adding info for platform:PNP0C0B:04
[    1.116033] Registering platform device 'PNP0A0A:00'. Parent at platfo=
rm
[    1.116039] device: 'PNP0A0A:00': device_add
[    1.116067] bus: 'platform': add device PNP0A0A:00
[    1.116122] PM: Adding info for platform:PNP0A0A:00
[    1.116774] Registering platform device 'PNP0C14:00'. Parent at platfo=
rm
[    1.116781] device: 'PNP0C14:00': device_add
[    1.116810] bus: 'platform': add device PNP0C14:00
[    1.116868] PM: Adding info for platform:PNP0C14:00
[    1.116923] device: 'LNXPWRBN:00': device_add
[    1.116936] bus: 'acpi': add device LNXPWRBN:00
[    1.116981] PM: Adding info for acpi:LNXPWRBN:00
[    1.117073] ACPI: Enabled 5 GPEs in block 00 to 3F
[    1.117157] bus: 'acpi': add driver ec
[    1.117328] bus: 'pnp': registered
[    1.117332] bus: 'platform': add driver 88pm860x-regulator
[    1.117376] device class 'misc': registering
[    1.117413] device class 'tpm': registering
[    1.117461] device: 'vga_arbiter': device_add
[    1.117536] PM: Adding info for No Bus:vga_arbiter
[    1.117718] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    1.117745] pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Dio+m=
em,owns=3Dio+mem,locks=3Dnone
[    1.117787] pci 0000:00:02.0: vgaarb: bridge control possible
[    1.117808] vgaarb: loaded
[    1.117873] bus: 'i2c': add driver 88PM860x
[    1.117908] bus: 'i2c': add driver WM8400
[    1.117941] bus: 'i2c': add driver wm831x
[    1.117975] bus: 'spi': add driver wm831x
[    1.118007] bus: 'i2c': add driver wm8350
[    1.118038] bus: 'i2c': add driver tps65910
[    1.118070] bus: 'spi': add driver ezx-pcap
[    1.118102] bus: 'i2c': add driver da903x
[    1.118133] bus: 'spi': add driver da9052
[    1.118163] bus: 'i2c': add driver da9052
[    1.118195] bus: 'i2c': add driver max8925
[    1.118228] bus: 'i2c': add driver max8997
[    1.118255] bus: 'i2c': add driver max8998
[    1.118280] bus: 'i2c': add driver ab3100
[    1.118305] bus: 'i2c': add driver tps6586x
[    1.118336] bus: 'i2c': add driver tps65090
[    1.118367] bus: 'i2c': add driver aat2870
[    1.118399] bus: 'i2c': add driver palmas
[    1.118431] bus: 'i2c': add driver rc5t583
[    1.119069] device class 'scsi_host': registering
[    1.119153] bus: 'scsi': registered
[    1.119155] device class 'scsi_device': registering
[    1.119197] SCSI subsystem initialized
[    1.119338] device class 'ata_link': registering
[    1.119364] device class 'ata_port': registering
[    1.119387] device class 'ata_device': registering
[    1.119420] libata version 3.00 loaded.
[    1.119423] device class 'mdio_bus': registering
[    1.119489] bus: 'mdio_bus': registered
[    1.119492] bus: 'mdio_bus': add driver Generic PHY
[    1.119525] bus: 'mdio_bus': add driver Generic 10G PHY
[    1.119574] ACPI: bus type USB registered
[    1.119636] bus: 'usb': registered
[    1.119651] bus: 'usb': add driver usbfs
[    1.119725] usbcore: registered new interface driver usbfs
[    1.119754] bus: 'usb': add driver hub
[    1.119806] usbcore: registered new interface driver hub
[    1.119888] bus: 'usb': add driver usb
[    1.119927] usbcore: registered new device driver usb
[    1.119991] bus: 'serio': registered
[    1.119993] device class 'input': registering
[    1.120036] device class 'rtc': registering
[    1.120065] device class 'power_supply': registering
[    1.120093] device class 'hwmon': registering
[    1.120328] bus: 'mmc': registered
[    1.120330] device class 'mmc_host': registering
[    1.120395] bus: 'sdio': registered
[    1.120401] device class 'leds': registering
[    1.120445] device class 'devfreq': registering
[    1.120612] device class 'sound': registering
[    1.120760] Advanced Linux Sound Architecture Driver Initialized.
[    1.120783] PCI: Using ACPI for IRQ routing
[    1.122425] PCI: pci_cache_line_size set to 64 bytes
[    1.122506] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    1.122519] e820: reserve RAM buffer [mem 0xc3df5000-0xc3ffffff]
[    1.122527] e820: reserve RAM buffer [mem 0xc4247000-0xc7ffffff]
[    1.122535] e820: reserve RAM buffer [mem 0xd86c3000-0xdbffffff]
[    1.122542] e820: reserve RAM buffer [mem 0xda000000-0xdbffffff]
[    1.122550] e820: reserve RAM buffer [mem 0x41fe00000-0x41fffffff]
[    1.122598] device class 'net': registering
[    1.122681] device: 'lo': device_add
[    1.122966] PM: Adding info for No Bus:lo
[    1.123254] NetLabel: Initializing
[    1.123270] NetLabel:  domain hash size =3D 128
[    1.123287] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
[    1.123426] NetLabel:  unlabeled traffic allowed by default
[    1.123447] device class 'rfkill': registering
[    1.123484] device: 'rfkill': device_add
[    1.123537] PM: Adding info for No Bus:rfkill
[    1.123738] device class 'watchdog': registering
[    1.123839] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.123877] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.125984] clocksource: Switched to clocksource hpet
[    1.201720] VFS: Disk quotas dquot_6.6.0
[    1.201783] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 by=
tes)
[    1.202472] AppArmor: AppArmor Filesystem Enabled
[    1.202528] device: 'fbcon': device_add
[    1.202613] PM: Adding info for No Bus:fbcon
[    1.202698] bus: 'pnp': add driver system
[    1.202732] pnp: PnP ACPI init
[    1.202766] device: 'pnp0': device_add
[    1.202810] PM: Adding info for No Bus:pnp0
[    1.203170] device: '00:00': device_add
[    1.203205] bus: 'pnp': add device 00:00
[    1.203264] PM: Adding info for pnp:00:00
[    1.203286] bus: 'pnp': driver_probe_device: matched device 00:00 with=
 driver system
[    1.203291] bus: 'pnp': really_probe: probing driver system with devic=
e 00:00
[    1.203306] devices_kset: Moving 00:00 to end of list
[    1.203324] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserve=
d
[    1.203350] driver: 'system': driver_bound: bound to device '00:00'
[    1.203355] bus: 'pnp': really_probe: bound device 00:00 to driver sys=
tem
[    1.203372] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    1.205423] device: '00:01': device_add
[    1.205453] bus: 'pnp': add device 00:01
[    1.205510] PM: Adding info for pnp:00:01
[    1.205529] bus: 'pnp': driver_probe_device: matched device 00:01 with=
 driver system
[    1.205533] bus: 'pnp': really_probe: probing driver system with devic=
e 00:01
[    1.205547] devices_kset: Moving 00:01 to end of list
[    1.205564] system 00:01: [io  0x0680-0x069f] has been reserved
[    1.205599] system 00:01: [io  0xffff] has been reserved
[    1.205630] system 00:01: [io  0xffff] has been reserved
[    1.205661] system 00:01: [io  0xffff] has been reserved
[    1.205692] system 00:01: [io  0x1c00-0x1cfe] has been reserved
[    1.205724] system 00:01: [io  0x1d00-0x1dfe] has been reserved
[    1.205757] system 00:01: [io  0x1e00-0x1efe] has been reserved
[    1.205789] system 00:01: [io  0x1f00-0x1ffe] has been reserved
[    1.205822] system 00:01: [io  0x1800-0x18fe] has been reserved
[    1.205854] system 00:01: [io  0x164e-0x164f] has been reserved
[    1.205877] driver: 'system': driver_bound: bound to device '00:01'
[    1.205881] bus: 'pnp': really_probe: bound device 00:01 to driver sys=
tem
[    1.205888] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    1.205997] device: '00:02': device_add
[    1.206026] bus: 'pnp': add device 00:02
[    1.206084] PM: Adding info for pnp:00:02
[    1.206107] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    1.206464] device: '00:03': device_add
[    1.206492] bus: 'pnp': add device 00:03
[    1.206547] PM: Adding info for pnp:00:03
[    1.206565] bus: 'pnp': driver_probe_device: matched device 00:03 with=
 driver system
[    1.206569] bus: 'pnp': really_probe: probing driver system with devic=
e 00:03
[    1.206583] devices_kset: Moving 00:03 to end of list
[    1.206597] system 00:03: [io  0x1854-0x1857] has been reserved
[    1.206621] driver: 'system': driver_bound: bound to device '00:03'
[    1.206624] bus: 'pnp': really_probe: bound device 00:03 to driver sys=
tem
[    1.206631] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c=
02 (active)
[    1.207477] device: '00:04': device_add
[    1.207506] bus: 'pnp': add device 00:04
[    1.207563] PM: Adding info for pnp:00:04
[    1.207582] bus: 'pnp': driver_probe_device: matched device 00:04 with=
 driver system
[    1.207586] bus: 'pnp': really_probe: probing driver system with devic=
e 00:04
[    1.207599] devices_kset: Moving 00:04 to end of list
[    1.207613] system 00:04: [io  0x0290-0x029f] has been reserved
[    1.207637] driver: 'system': driver_bound: bound to device '00:04'
[    1.207640] bus: 'pnp': really_probe: bound device 00:04 to driver sys=
tem
[    1.207647] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    1.207982] device: '00:05': device_add
[    1.208010] bus: 'pnp': add device 00:05
[    1.208066] PM: Adding info for pnp:00:05
[    1.208084] bus: 'pnp': driver_probe_device: matched device 00:05 with=
 driver system
[    1.208088] bus: 'pnp': really_probe: probing driver system with devic=
e 00:05
[    1.208101] devices_kset: Moving 00:05 to end of list
[    1.208115] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    1.208138] driver: 'system': driver_bound: bound to device '00:05'
[    1.208142] bus: 'pnp': really_probe: bound device 00:05 to driver sys=
tem
[    1.208148] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    1.210600] pnp 00:06: [dma 0 disabled]
[    1.210723] device: '00:06': device_add
[    1.210755] bus: 'pnp': add device 00:06
[    1.210846] PM: Adding info for pnp:00:06
[    1.210868] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    1.216844] device: '00:07': device_add
[    1.216873] bus: 'pnp': add device 00:07
[    1.216931] PM: Adding info for pnp:00:07
[    1.216950] bus: 'pnp': driver_probe_device: matched device 00:07 with=
 driver system
[    1.216954] bus: 'pnp': really_probe: probing driver system with devic=
e 00:07
[    1.216967] devices_kset: Moving 00:07 to end of list
[    1.216983] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserve=
d
[    1.217019] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserve=
d
[    1.217054] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserve=
d
[    1.217088] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserve=
d
[    1.217123] system 00:07: [mem 0xf8000000-0xfbffffff] has been reserve=
d
[    1.217157] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserve=
d
[    1.217198] system 00:07: [mem 0xfed90000-0xfed93fff] could not be res=
erved
[    1.217234] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserve=
d
[    1.217268] system 00:07: [mem 0xff000000-0xffffffff] has been reserve=
d
[    1.217307] system 00:07: [mem 0xfee00000-0xfeefffff] could not be res=
erved
[    1.217343] system 00:07: [mem 0xf7fef000-0xf7feffff] has been reserve=
d
[    1.217378] system 00:07: [mem 0xf7ff0000-0xf7ff0fff] has been reserve=
d
[    1.217402] driver: 'system': driver_bound: bound to device '00:07'
[    1.217406] bus: 'pnp': really_probe: bound device 00:07 to driver sys=
tem
[    1.217413] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    1.221437] pnp: PnP ACPI: found 8 devices
[    1.221472] device class 'mem': registering
[    1.221506] device: 'mem': device_add
[    1.221564] PM: Adding info for No Bus:mem
[    1.221671] device: 'null': device_add
[    1.221721] PM: Adding info for No Bus:null
[    1.221789] device: 'port': device_add
[    1.221836] PM: Adding info for No Bus:port
[    1.221900] device: 'zero': device_add
[    1.221946] PM: Adding info for No Bus:zero
[    1.222030] device: 'full': device_add
[    1.222077] PM: Adding info for No Bus:full
[    1.222140] device: 'random': device_add
[    1.222187] PM: Adding info for No Bus:random
[    1.222252] device: 'urandom': device_add
[    1.222301] PM: Adding info for No Bus:urandom
[    1.222364] device: 'kmsg': device_add
[    1.222410] PM: Adding info for No Bus:kmsg
[    1.222483] device: 'tty': device_add
[    1.222543] PM: Adding info for No Bus:tty
[    1.222627] device: 'console': device_add
[    1.222679] PM: Adding info for No Bus:console
[    1.222754] device: 'tty0': device_add
[    1.222809] PM: Adding info for No Bus:tty0
[    1.222883] device class 'vc': registering
[    1.222916] device: 'vcs': device_add
[    1.222974] PM: Adding info for No Bus:vcs
[    1.223050] device: 'vcsa': device_add
[    1.223102] PM: Adding info for No Bus:vcsa
[    1.223174] device: 'vcs1': device_add
[    1.223229] PM: Adding info for No Bus:vcs1
[    1.223301] device: 'vcsa1': device_add
[    1.223357] PM: Adding info for No Bus:vcsa1
[    1.223464] device: 'tty1': device_add
[    1.223520] PM: Adding info for No Bus:tty1
[    1.223597] device: 'tty2': device_add
[    1.223650] PM: Adding info for No Bus:tty2
[    1.223724] device: 'tty3': device_add
[    1.223779] PM: Adding info for No Bus:tty3
[    1.223853] device: 'tty4': device_add
[    1.223907] PM: Adding info for No Bus:tty4
[    1.223983] device: 'tty5': device_add
[    1.224037] PM: Adding info for No Bus:tty5
[    1.224113] device: 'tty6': device_add
[    1.224165] PM: Adding info for No Bus:tty6
[    1.224241] device: 'tty7': device_add
[    1.224293] PM: Adding info for No Bus:tty7
[    1.224371] device: 'tty8': device_add
[    1.224430] PM: Adding info for No Bus:tty8
[    1.224504] device: 'tty9': device_add
[    1.224557] PM: Adding info for No Bus:tty9
[    1.224645] device: 'tty10': device_add
[    1.224702] PM: Adding info for No Bus:tty10
[    1.224777] device: 'tty11': device_add
[    1.224829] PM: Adding info for No Bus:tty11
[    1.224903] device: 'tty12': device_add
[    1.224958] PM: Adding info for No Bus:tty12
[    1.225034] device: 'tty13': device_add
[    1.225087] PM: Adding info for No Bus:tty13
[    1.225162] device: 'tty14': device_add
[    1.225215] PM: Adding info for No Bus:tty14
[    1.225288] device: 'tty15': device_add
[    1.225343] PM: Adding info for No Bus:tty15
[    1.225417] device: 'tty16': device_add
[    1.225469] PM: Adding info for No Bus:tty16
[    1.225543] device: 'tty17': device_add
[    1.225597] PM: Adding info for No Bus:tty17
[    1.225671] device: 'tty18': device_add
[    1.225723] PM: Adding info for No Bus:tty18
[    1.225797] device: 'tty19': device_add
[    1.225851] PM: Adding info for No Bus:tty19
[    1.225928] device: 'tty20': device_add
[    1.225996] PM: Adding info for No Bus:tty20
[    1.226073] device: 'tty21': device_add
[    1.226127] PM: Adding info for No Bus:tty21
[    1.226203] device: 'tty22': device_add
[    1.226255] PM: Adding info for No Bus:tty22
[    1.226329] device: 'tty23': device_add
[    1.226382] PM: Adding info for No Bus:tty23
[    1.226455] device: 'tty24': device_add
[    1.226510] PM: Adding info for No Bus:tty24
[    1.226583] device: 'tty25': device_add
[    1.226636] PM: Adding info for No Bus:tty25
[    1.226709] device: 'tty26': device_add
[    1.226764] PM: Adding info for No Bus:tty26
[    1.226839] device: 'tty27': device_add
[    1.226892] PM: Adding info for No Bus:tty27
[    1.226967] device: 'tty28': device_add
[    1.227020] PM: Adding info for No Bus:tty28
[    1.227095] device: 'tty29': device_add
[    1.227148] PM: Adding info for No Bus:tty29
[    1.227221] device: 'tty30': device_add
[    1.227274] PM: Adding info for No Bus:tty30
[    1.227349] device: 'tty31': device_add
[    1.227404] PM: Adding info for No Bus:tty31
[    1.227478] device: 'tty32': device_add
[    1.227531] PM: Adding info for No Bus:tty32
[    1.227606] device: 'tty33': device_add
[    1.227661] PM: Adding info for No Bus:tty33
[    1.227736] device: 'tty34': device_add
[    1.227789] PM: Adding info for No Bus:tty34
[    1.227880] device: 'tty35': device_add
[    1.227935] PM: Adding info for No Bus:tty35
[    1.228009] device: 'tty36': device_add
[    1.228062] PM: Adding info for No Bus:tty36
[    1.228137] device: 'tty37': device_add
[    1.228190] PM: Adding info for No Bus:tty37
[    1.228263] device: 'tty38': device_add
[    1.228318] PM: Adding info for No Bus:tty38
[    1.228391] device: 'tty39': device_add
[    1.228444] PM: Adding info for No Bus:tty39
[    1.228517] device: 'tty40': device_add
[    1.228572] PM: Adding info for No Bus:tty40
[    1.228648] device: 'tty41': device_add
[    1.228701] PM: Adding info for No Bus:tty41
[    1.228776] device: 'tty42': device_add
[    1.228831] PM: Adding info for No Bus:tty42
[    1.228905] device: 'tty43': device_add
[    1.228958] PM: Adding info for No Bus:tty43
[    1.229031] device: 'tty44': device_add
[    1.229084] PM: Adding info for No Bus:tty44
[    1.229157] device: 'tty45': device_add
[    1.229212] PM: Adding info for No Bus:tty45
[    1.229286] device: 'tty46': device_add
[    1.229339] PM: Adding info for No Bus:tty46
[    1.229412] device: 'tty47': device_add
[    1.229467] PM: Adding info for No Bus:tty47
[    1.229542] device: 'tty48': device_add
[    1.229595] PM: Adding info for No Bus:tty48
[    1.229671] device: 'tty49': device_add
[    1.229726] PM: Adding info for No Bus:tty49
[    1.229800] device: 'tty50': device_add
[    1.229854] PM: Adding info for No Bus:tty50
[    1.229927] device: 'tty51': device_add
[    1.229994] PM: Adding info for No Bus:tty51
[    1.230069] device: 'tty52': device_add
[    1.230125] PM: Adding info for No Bus:tty52
[    1.230201] device: 'tty53': device_add
[    1.230255] PM: Adding info for No Bus:tty53
[    1.230330] device: 'tty54': device_add
[    1.230385] PM: Adding info for No Bus:tty54
[    1.230462] device: 'tty55': device_add
[    1.230515] PM: Adding info for No Bus:tty55
[    1.230590] device: 'tty56': device_add
[    1.230645] PM: Adding info for No Bus:tty56
[    1.230718] device: 'tty57': device_add
[    1.230771] PM: Adding info for No Bus:tty57
[    1.230847] device: 'tty58': device_add
[    1.230900] PM: Adding info for No Bus:tty58
[    1.230975] device: 'tty59': device_add
[    1.231028] PM: Adding info for No Bus:tty59
[    1.231117] device: 'tty60': device_add
[    1.231170] PM: Adding info for No Bus:tty60
[    1.231243] device: 'tty61': device_add
[    1.231298] PM: Adding info for No Bus:tty61
[    1.231373] device: 'tty62': device_add
[    1.231427] PM: Adding info for No Bus:tty62
[    1.231502] device: 'tty63': device_add
[    1.231557] PM: Adding info for No Bus:tty63
[    1.231781] device class 'firmware': registering
[    1.231824] device class 'thermal': registering
[    1.236379] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff,=
 max_idle_ns: 2085701024 ns
[    1.236461] bus: 'ssb': registered
[    1.236472] bus: 'pci': add driver b43-pci-bridge
[    1.236588] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.236616] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    1.236640] pci 0000:00:1c.0:   bridge window [mem 0xf7e00000-0xf7efff=
ff]
[    1.236671] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    1.236692] pci 0000:00:1c.2:   bridge window [io  0xe000-0xefff]
[    1.236717] pci 0000:00:1c.2:   bridge window [mem 0xf7d00000-0xf7dfff=
ff]
[    1.236743] pci 0000:00:1c.2:   bridge window [mem 0xf0000000-0xf00fff=
ff 64bit pref]
[    1.236778] pci 0000:04:00.0: PCI bridge to [bus 05]
[    1.236799] pci 0000:04:00.0:   bridge window [io  0xd000-0xdfff]
[    1.236827] pci 0000:04:00.0:   bridge window [mem 0xf7c00000-0xf7cfff=
ff]
[    1.236863] pci 0000:00:1c.3: PCI bridge to [bus 04-05]
[    1.236884] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    1.236909] pci 0000:00:1c.3:   bridge window [mem 0xf7c00000-0xf7cfff=
ff]
[    1.236941] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    1.236944] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    1.236947] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff win=
dow]
[    1.236950] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff win=
dow]
[    1.236952] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff win=
dow]
[    1.236955] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff win=
dow]
[    1.236958] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff wi=
ndow]
[    1.236961] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff wi=
ndow]
[    1.236963] pci_bus 0000:00: resource 12 [mem 0xdf200000-0xfeafffff wi=
ndow]
[    1.236966] pci_bus 0000:02: resource 1 [mem 0xf7e00000-0xf7efffff]
[    1.236969] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    1.236972] pci_bus 0000:03: resource 1 [mem 0xf7d00000-0xf7dfffff]
[    1.236975] pci_bus 0000:03: resource 2 [mem 0xf0000000-0xf00fffff 64b=
it pref]
[    1.236977] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    1.236980] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    1.236983] pci_bus 0000:04: resource 4 [io  0x0000-0x0cf7 window]
[    1.236985] pci_bus 0000:04: resource 5 [io  0x0d00-0xffff window]
[    1.236988] pci_bus 0000:04: resource 6 [mem 0x000a0000-0x000bffff win=
dow]
[    1.236991] pci_bus 0000:04: resource 7 [mem 0x000d4000-0x000d7fff win=
dow]
[    1.236993] pci_bus 0000:04: resource 8 [mem 0x000d8000-0x000dbfff win=
dow]
[    1.236996] pci_bus 0000:04: resource 9 [mem 0x000dc000-0x000dffff win=
dow]
[    1.236999] pci_bus 0000:04: resource 10 [mem 0x000e0000-0x000e3fff wi=
ndow]
[    1.237001] pci_bus 0000:04: resource 11 [mem 0x000e4000-0x000e7fff wi=
ndow]
[    1.237004] pci_bus 0000:04: resource 12 [mem 0xdf200000-0xfeafffff wi=
ndow]
[    1.237007] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    1.237010] pci_bus 0000:05: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    1.237012] pci_bus 0000:05: resource 4 [io  0xd000-0xdfff]
[    1.237015] pci_bus 0000:05: resource 5 [mem 0xf7c00000-0xf7cfffff]
[    1.237017] pci_bus 0000:05: resource 6 [io  0x0000-0x0cf7 window]
[    1.237020] pci_bus 0000:05: resource 7 [io  0x0d00-0xffff window]
[    1.237023] pci_bus 0000:05: resource 8 [mem 0x000a0000-0x000bffff win=
dow]
[    1.237025] pci_bus 0000:05: resource 9 [mem 0x000d4000-0x000d7fff win=
dow]
[    1.237028] pci_bus 0000:05: resource 10 [mem 0x000d8000-0x000dbfff wi=
ndow]
[    1.237031] pci_bus 0000:05: resource 11 [mem 0x000dc000-0x000dffff wi=
ndow]
[    1.237033] pci_bus 0000:05: resource 12 [mem 0x000e0000-0x000e3fff wi=
ndow]
[    1.237036] pci_bus 0000:05: resource 13 [mem 0x000e4000-0x000e7fff wi=
ndow]
[    1.237039] pci_bus 0000:05: resource 14 [mem 0xdf200000-0xfeafffff wi=
ndow]
[    1.238083] NET: Registered protocol family 2
[    1.238924] TCP established hash table entries: 131072 (order: 8, 1048=
576 bytes)
[    1.239521] TCP bind hash table entries: 65536 (order: 10, 4194304 byt=
es)
[    1.243473] TCP: Hash tables configured (established 131072 bind 65536=
)
[    1.243774] UDP hash table entries: 8192 (order: 8, 1310720 bytes)
[    1.244933] UDP-Lite hash table entries: 8192 (order: 8, 1310720 bytes=
)
[    1.246305] NET: Registered protocol family 1
[    1.246364] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0=
x000c0000-0x000dffff]
[    1.299008] PCI: CLS 64 bytes, default 64
[    1.299330] Trying to unpack rootfs image as initramfs...
[    6.862981] Freeing initrd memory: 314060K
[    6.863219] DMAR: No ATSR found
[    6.864218] DMAR: dmar0: Using Queued invalidation
[    6.864276] DMAR: dmar1: Using Queued invalidation
[    6.864348] DMAR: Setting RMRR:
[    6.864778] DMAR: Setting identity map for device 0000:00:02.0 [0xdb00=
0000 - 0xdf1fffff]
[    6.865506] DMAR: Setting identity map for device 0000:00:14.0 [0xd885=
2000 - 0xd885efff]
[    6.866063] DMAR: Setting identity map for device 0000:00:1a.0 [0xd885=
2000 - 0xd885efff]
[    6.866543] DMAR: Setting identity map for device 0000:00:1d.0 [0xd885=
2000 - 0xd885efff]
[    6.866594] DMAR: Prepare 0-16MiB unity mapping for LPC
[    6.866996] DMAR: Setting identity map for device 0000:00:1f.0 [0x0 - =
0xffffff]
[    6.867135] DMAR: Intel(R) Virtualization Technology for Directed I/O
[    6.867171] device: 'dmar0': device_add
[    6.867274] PM: Adding info for No Bus:dmar0
[    6.867318] device: 'dmar1': device_add
[    6.867395] PM: Adding info for No Bus:dmar1
[    6.867496] iommu: Adding device 0000:00:00.0 to group 0
[    6.867591] iommu: Adding device 0000:00:01.0 to group 1
[    6.867669] iommu: Adding device 0000:00:02.0 to group 2
[    6.867747] iommu: Adding device 0000:00:03.0 to group 3
[    6.867826] iommu: Adding device 0000:00:14.0 to group 4
[    6.867913] iommu: Adding device 0000:00:16.0 to group 5
[    6.867990] iommu: Adding device 0000:00:1a.0 to group 6
[    6.868067] iommu: Adding device 0000:00:1b.0 to group 7
[    6.868144] iommu: Adding device 0000:00:1c.0 to group 8
[    6.868223] iommu: Adding device 0000:00:1c.2 to group 9
[    6.868313] iommu: Adding device 0000:00:1c.3 to group 10
[    6.868396] iommu: Adding device 0000:00:1d.0 to group 11
[    6.868505] iommu: Adding device 0000:00:1f.0 to group 12
[    6.868567] iommu: Adding device 0000:00:1f.2 to group 12
[    6.868629] iommu: Adding device 0000:00:1f.3 to group 12
[    6.868708] iommu: Adding device 0000:02:00.0 to group 13
[    6.868786] iommu: Adding device 0000:03:00.0 to group 14
[    6.868833] iommu: Adding device 0000:04:00.0 to group 10
[    6.868877] iommu: Adding device 0000:05:00.0 to group 10
[    6.874479] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 6553=
60 ms ovfl timer
[    6.874511] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    6.874532] RAPL PMU: hw unit of domain package 2^-14 Joules
[    6.874552] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    6.874571] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    6.874642] bus: 'pci': add driver hsw_uncore
[    6.874658] bus: 'pci': driver_probe_device: matched device 0000:00:00=
=2E0 with driver hsw_uncore
[    6.874664] bus: 'pci': really_probe: probing driver hsw_uncore with d=
evice 0000:00:00.0
[    6.874690] devices_kset: Moving 0000:00:00.0 to end of list
[    6.874750] driver: 'hsw_uncore': driver_bound: bound to device '0000:=
00:00.0'
[    6.874755] bus: 'pci': really_probe: bound device 0000:00:00.0 to dri=
ver hsw_uncore
[    6.875403] Registering platform device 'pcspkr'. Parent at platform
[    6.875409] device: 'pcspkr': device_add
[    6.875422] bus: 'platform': add device pcspkr
[    6.875476] PM: Adding info for platform:pcspkr
[    6.875500] Scanning for low memory corruption every 60 seconds
[    6.875567] Registering platform device 'vesa-framebuffer.0'. Parent a=
t platform
[    6.875573] device: 'vesa-framebuffer.0': device_add
[    6.875585] bus: 'platform': add device vesa-framebuffer.0
[    6.875633] PM: Adding info for platform:vesa-framebuffer.0
[    6.875969] device: 'snapshot': device_add
[    6.876023] PM: Adding info for No Bus:snapshot
[    6.876156] bus: 'clocksource': registered
[    6.876166] device: 'clocksource': device_add
[    6.876209] PM: Adding info for No Bus:clocksource
[    6.876219] device: 'clocksource0': device_add
[    6.876230] bus: 'clocksource': add device clocksource0
[    6.876271] PM: Adding info for clocksource:clocksource0
[    6.876324] bus: 'platform': add driver alarmtimer
[    6.876372] Registering platform device 'alarmtimer'. Parent at platfo=
rm
[    6.876377] device: 'alarmtimer': device_add
[    6.876389] bus: 'platform': add device alarmtimer
[    6.876440] PM: Adding info for platform:alarmtimer
[    6.876460] bus: 'platform': driver_probe_device: matched device alarm=
timer with driver alarmtimer
[    6.876464] bus: 'platform': really_probe: probing driver alarmtimer w=
ith device alarmtimer
[    6.876477] devices_kset: Moving alarmtimer to end of list
[    6.876480] driver: 'alarmtimer': driver_bound: bound to device 'alarm=
timer'
[    6.876484] bus: 'platform': really_probe: bound device alarmtimer to =
driver alarmtimer
[    6.876552] bus: 'clockevents': registered
[    6.876562] device: 'clockevents': device_add
[    6.876603] PM: Adding info for No Bus:clockevents
[    6.876613] device: 'clockevent0': device_add
[    6.876624] bus: 'clockevents': add device clockevent0
[    6.876666] PM: Adding info for clockevents:clockevent0
[    6.876704] device: 'clockevent1': device_add
[    6.876714] bus: 'clockevents': add device clockevent1
[    6.876754] PM: Adding info for clockevents:clockevent1
[    6.876783] device: 'clockevent2': device_add
[    6.876794] bus: 'clockevents': add device clockevent2
[    6.876836] PM: Adding info for clockevents:clockevent2
[    6.876862] device: 'clockevent3': device_add
[    6.876873] bus: 'clockevents': add device clockevent3
[    6.876913] PM: Adding info for clockevents:clockevent3
[    6.876939] device: 'clockevent4': device_add
[    6.876950] bus: 'clockevents': add device clockevent4
[    6.876990] PM: Adding info for clockevents:clockevent4
[    6.877016] device: 'clockevent5': device_add
[    6.877028] bus: 'clockevents': add device clockevent5
[    6.877068] PM: Adding info for clockevents:clockevent5
[    6.877095] device: 'clockevent6': device_add
[    6.877106] bus: 'clockevents': add device clockevent6
[    6.877146] PM: Adding info for clockevents:clockevent6
[    6.877172] device: 'clockevent7': device_add
[    6.877183] bus: 'clockevents': add device clockevent7
[    6.877224] PM: Adding info for clockevents:clockevent7
[    6.877249] device: 'broadcast': device_add
[    6.877258] bus: 'clockevents': add device broadcast
[    6.877297] PM: Adding info for clockevents:broadcast
[    6.877352] audit: initializing netlink subsys (disabled)
[    6.877548] audit: type=3D2000 audit(1494865686.868:1): state=3Dinitia=
lized audit_enabled=3D0 res=3D1
[    6.878199] bus: 'event_source': registered
[    6.878214] device: 'cstate_pkg': device_add
[    6.878275] bus: 'event_source': add device cstate_pkg
[    6.878328] PM: Adding info for event_source:cstate_pkg
[    6.878369] device: 'cstate_core': device_add
[    6.878401] bus: 'event_source': add device cstate_core
[    6.878450] PM: Adding info for event_source:cstate_core
[    6.878476] device: 'uncore_arb': device_add
[    6.878509] bus: 'event_source': add device uncore_arb
[    6.878558] PM: Adding info for event_source:uncore_arb
[    6.878583] device: 'uncore_cbox_3': device_add
[    6.878624] bus: 'event_source': add device uncore_cbox_3
[    6.878673] PM: Adding info for event_source:uncore_cbox_3
[    6.878699] device: 'uncore_cbox_2': device_add
[    6.878738] bus: 'event_source': add device uncore_cbox_2
[    6.878789] PM: Adding info for event_source:uncore_cbox_2
[    6.878813] device: 'uncore_cbox_1': device_add
[    6.878852] bus: 'event_source': add device uncore_cbox_1
[    6.878901] PM: Adding info for event_source:uncore_cbox_1
[    6.878926] device: 'uncore_cbox_0': device_add
[    6.878966] bus: 'event_source': add device uncore_cbox_0
[    6.879015] PM: Adding info for event_source:uncore_cbox_0
[    6.879041] device: 'uncore_imc': device_add
[    6.879083] bus: 'event_source': add device uncore_imc
[    6.879134] PM: Adding info for event_source:uncore_imc
[    6.879157] device: 'power': device_add
[    6.879217] bus: 'event_source': add device power
[    6.879264] PM: Adding info for event_source:power
[    6.879287] device: 'msr': device_add
[    6.879320] bus: 'event_source': add device msr
[    6.879367] PM: Adding info for event_source:msr
[    6.879390] device: 'intel_bts': device_add
[    6.879400] bus: 'event_source': add device intel_bts
[    6.879449] PM: Adding info for event_source:intel_bts
[    6.879474] device: 'cpu': device_add
[    6.879621] bus: 'event_source': add device cpu
[    6.879668] PM: Adding info for event_source:cpu
[    6.879691] device: 'breakpoint': device_add
[    6.879701] bus: 'event_source': add device breakpoint
[    6.879749] PM: Adding info for event_source:breakpoint
[    6.879772] device: 'tracepoint': device_add
[    6.879781] bus: 'event_source': add device tracepoint
[    6.879828] PM: Adding info for event_source:tracepoint
[    6.879851] device: 'software': device_add
[    6.879861] bus: 'event_source': add device software
[    6.879907] PM: Adding info for event_source:software
[    6.880030] workingset: timestamp_bits=3D56 max_order=3D22 bucket_orde=
r=3D0
[    6.898856] fuse init (API version 7.26)
[    6.899152] device: 'fuse': device_add
[    6.899205] PM: Adding info for No Bus:fuse
[    6.901341] device class 'bsg': registering
[    6.901376] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 250)
[    6.901541] io scheduler noop registered
[    6.901559] io scheduler deadline registered (default)
[    6.901877] io scheduler cfq registered
[    6.901895] io scheduler mq-deadline registered
[    6.902910] device class 'phy': registering
[    6.903105] bus: 'pci_express': registered
[    6.903108] bus: 'pci': add driver pcieport
[    6.903121] bus: 'pci': driver_probe_device: matched device 0000:00:01=
=2E0 with driver pcieport
[    6.903125] bus: 'pci': really_probe: probing driver pcieport with dev=
ice 0000:00:01.0
[    6.903140] devices_kset: Moving 0000:00:01.0 to end of list
[    6.904637] device: '0000:00:01.0:pcie008': device_add
[    6.904652] bus: 'pci_express': add device 0000:00:01.0:pcie008
[    6.904706] PM: Adding info for pci_express:0000:00:01.0:pcie008
[    6.904835] driver: 'pcieport': driver_bound: bound to device '0000:00=
:01.0'
[    6.904841] bus: 'pci': really_probe: bound device 0000:00:01.0 to dri=
ver pcieport
[    6.904850] bus: 'pci': driver_probe_device: matched device 0000:00:1c=
=2E0 with driver pcieport
[    6.904854] bus: 'pci': really_probe: probing driver pcieport with dev=
ice 0000:00:1c.0
[    6.904868] devices_kset: Moving 0000:00:1c.0 to end of list
[    6.906036] driver: 'pcieport': driver_bound: bound to device '0000:00=
:1c.0'
[    6.906041] bus: 'pci': really_probe: bound device 0000:00:1c.0 to dri=
ver pcieport
[    6.906047] bus: 'pci': driver_probe_device: matched device 0000:00:1c=
=2E2 with driver pcieport
[    6.906051] bus: 'pci': really_probe: probing driver pcieport with dev=
ice 0000:00:1c.2
[    6.906065] devices_kset: Moving 0000:00:1c.2 to end of list
[    6.907355] driver: 'pcieport': driver_bound: bound to device '0000:00=
:1c.2'
[    6.907360] bus: 'pci': really_probe: bound device 0000:00:1c.2 to dri=
ver pcieport
[    6.907406] bus: 'pci_express': add driver aer
[    6.907439] bus: 'pci_express': add driver pcie_pme
[    6.907474] bus: 'rapidio': add driver tsi57x
[    6.907506] bus: 'rapidio': add driver idtcps
[    6.907537] bus: 'rapidio': add driver tsi568
[    6.907567] bus: 'rapidio': add driver idt_gen2
[    6.907598] bus: 'pci': add driver tsi721
[    6.907667] bus: 'pci': add driver imsttfb
[    6.907716] bus: 'pci': add driver asiliantfb
[    6.907764] bus: 'platform': add driver efi-framebuffer
[    6.907802] intel_idle: MWAIT substates: 0x42120
[    6.907804] intel_idle: v0.4.1 model 0x3C
[    6.909824] intel_idle: lapic_timer_reliable_states 0xffffffff
[    6.909828] bus: 'acpi': add driver ac
[    6.909932] bus: 'acpi': add driver button
[    6.909987] bus: 'acpi': driver_probe_device: matched device PNP0C0C:0=
0 with driver button
[    6.909992] bus: 'acpi': really_probe: probing driver button with devi=
ce PNP0C0C:00
[    6.910006] devices_kset: Moving PNP0C0C:00 to end of list
[    6.910034] device: 'input0': device_add
[    6.910189] PM: Adding info for No Bus:input0
[    6.910235] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0C:00/input/input0
[    6.910328] ACPI: Power Button [PWRB]
[    6.910354] driver: 'button': driver_bound: bound to device 'PNP0C0C:0=
0'
[    6.910359] bus: 'acpi': really_probe: bound device PNP0C0C:00 to driv=
er button
[    6.910372] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:=
00 with driver button
[    6.910377] bus: 'acpi': really_probe: probing driver button with devi=
ce LNXPWRBN:00
[    6.910390] devices_kset: Moving LNXPWRBN:00 to end of list
[    6.910415] device: 'input1': device_add
[    6.910567] PM: Adding info for No Bus:input1
[    6.910597] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    6.910637] ACPI: Power Button [PWRF]
[    6.910661] driver: 'button': driver_bound: bound to device 'LNXPWRBN:=
00'
[    6.910666] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to dri=
ver button
[    6.910693] bus: 'platform': add driver acpi-fan
[    6.910710] bus: 'platform': driver_probe_device: matched device PNP0C=
0B:00 with driver acpi-fan
[    6.910715] bus: 'platform': really_probe: probing driver acpi-fan wit=
h device PNP0C0B:00
[    6.910728] devices_kset: Moving PNP0C0B:00 to end of list
[    6.911187] device: 'cooling_device0': device_add
[    6.911277] PM: Adding info for No Bus:cooling_device0
[    6.911321] driver: 'acpi-fan': driver_bound: bound to device 'PNP0C0B=
:00'
[    6.911325] bus: 'platform': really_probe: bound device PNP0C0B:00 to =
driver acpi-fan
[    6.911331] bus: 'platform': driver_probe_device: matched device PNP0C=
0B:01 with driver acpi-fan
[    6.911335] bus: 'platform': really_probe: probing driver acpi-fan wit=
h device PNP0C0B:01
[    6.911348] devices_kset: Moving PNP0C0B:01 to end of list
[    6.911768] device: 'cooling_device1': device_add
[    6.911847] PM: Adding info for No Bus:cooling_device1
[    6.911877] driver: 'acpi-fan': driver_bound: bound to device 'PNP0C0B=
:01'
[    6.911881] bus: 'platform': really_probe: bound device PNP0C0B:01 to =
driver acpi-fan
[    6.911887] bus: 'platform': driver_probe_device: matched device PNP0C=
0B:02 with driver acpi-fan
[    6.911891] bus: 'platform': really_probe: probing driver acpi-fan wit=
h device PNP0C0B:02
[    6.911904] devices_kset: Moving PNP0C0B:02 to end of list
[    6.912327] device: 'cooling_device2': device_add
[    6.912403] PM: Adding info for No Bus:cooling_device2
[    6.912432] driver: 'acpi-fan': driver_bound: bound to device 'PNP0C0B=
:02'
[    6.912436] bus: 'platform': really_probe: bound device PNP0C0B:02 to =
driver acpi-fan
[    6.912441] bus: 'platform': driver_probe_device: matched device PNP0C=
0B:03 with driver acpi-fan
[    6.912445] bus: 'platform': really_probe: probing driver acpi-fan wit=
h device PNP0C0B:03
[    6.912458] devices_kset: Moving PNP0C0B:03 to end of list
[    6.912875] device: 'cooling_device3': device_add
[    6.912953] PM: Adding info for No Bus:cooling_device3
[    6.912982] driver: 'acpi-fan': driver_bound: bound to device 'PNP0C0B=
:03'
[    6.912986] bus: 'platform': really_probe: bound device PNP0C0B:03 to =
driver acpi-fan
[    6.912991] bus: 'platform': driver_probe_device: matched device PNP0C=
0B:04 with driver acpi-fan
[    6.912995] bus: 'platform': really_probe: probing driver acpi-fan wit=
h device PNP0C0B:04
[    6.913008] devices_kset: Moving PNP0C0B:04 to end of list
[    6.913425] device: 'cooling_device4': device_add
[    6.913501] PM: Adding info for No Bus:cooling_device4
[    6.913531] driver: 'acpi-fan': driver_bound: bound to device 'PNP0C0B=
:04'
[    6.913535] bus: 'platform': really_probe: bound device PNP0C0B:04 to =
driver acpi-fan
[    6.913566] bus: 'cpu': add driver processor
[    6.913578] bus: 'cpu': driver_probe_device: matched device cpu0 with =
driver processor
[    6.913582] bus: 'cpu': really_probe: probing driver processor with de=
vice cpu0
[    6.913594] devices_kset: Moving cpu0 to end of list
[    6.913642] device: 'cooling_device5': device_add
[    6.913715] PM: Adding info for No Bus:cooling_device5
[    6.913747] driver: 'processor': driver_bound: bound to device 'cpu0'
[    6.913751] bus: 'cpu': really_probe: bound device cpu0 to driver proc=
essor
[    6.913756] bus: 'cpu': driver_probe_device: matched device cpu1 with =
driver processor
[    6.913759] bus: 'cpu': really_probe: probing driver processor with de=
vice cpu1
[    6.913771] devices_kset: Moving cpu1 to end of list
[    6.913814] device: 'cooling_device6': device_add
[    6.913887] PM: Adding info for No Bus:cooling_device6
[    6.913917] driver: 'processor': driver_bound: bound to device 'cpu1'
[    6.913921] bus: 'cpu': really_probe: bound device cpu1 to driver proc=
essor
[    6.913925] bus: 'cpu': driver_probe_device: matched device cpu2 with =
driver processor
[    6.913928] bus: 'cpu': really_probe: probing driver processor with de=
vice cpu2
[    6.913940] devices_kset: Moving cpu2 to end of list
[    6.913983] device: 'cooling_device7': device_add
[    6.914053] PM: Adding info for No Bus:cooling_device7
[    6.914084] driver: 'processor': driver_bound: bound to device 'cpu2'
[    6.914088] bus: 'cpu': really_probe: bound device cpu2 to driver proc=
essor
[    6.914092] bus: 'cpu': driver_probe_device: matched device cpu3 with =
driver processor
[    6.914095] bus: 'cpu': really_probe: probing driver processor with de=
vice cpu3
[    6.914107] devices_kset: Moving cpu3 to end of list
[    6.914151] device: 'cooling_device8': device_add
[    6.914223] PM: Adding info for No Bus:cooling_device8
[    6.914277] driver: 'processor': driver_bound: bound to device 'cpu3'
[    6.914281] bus: 'cpu': really_probe: bound device cpu3 to driver proc=
essor
[    6.914285] bus: 'cpu': driver_probe_device: matched device cpu4 with =
driver processor
[    6.914289] bus: 'cpu': really_probe: probing driver processor with de=
vice cpu4
[    6.914301] devices_kset: Moving cpu4 to end of list
[    6.914345] device: 'cooling_device9': device_add
[    6.914416] PM: Adding info for No Bus:cooling_device9
[    6.914446] driver: 'processor': driver_bound: bound to device 'cpu4'
[    6.914449] bus: 'cpu': really_probe: bound device cpu4 to driver proc=
essor
[    6.914454] bus: 'cpu': driver_probe_device: matched device cpu5 with =
driver processor
[    6.914457] bus: 'cpu': really_probe: probing driver processor with de=
vice cpu5
[    6.914472] devices_kset: Moving cpu5 to end of list
[    6.914514] device: 'cooling_device10': device_add
[    6.914585] PM: Adding info for No Bus:cooling_device10
[    6.914615] driver: 'processor': driver_bound: bound to device 'cpu5'
[    6.914618] bus: 'cpu': really_probe: bound device cpu5 to driver proc=
essor
[    6.914623] bus: 'cpu': driver_probe_device: matched device cpu6 with =
driver processor
[    6.914626] bus: 'cpu': really_probe: probing driver processor with de=
vice cpu6
[    6.914638] devices_kset: Moving cpu6 to end of list
[    6.914681] device: 'cooling_device11': device_add
[    6.914754] PM: Adding info for No Bus:cooling_device11
[    6.914783] driver: 'processor': driver_bound: bound to device 'cpu6'
[    6.914786] bus: 'cpu': really_probe: bound device cpu6 to driver proc=
essor
[    6.914791] bus: 'cpu': driver_probe_device: matched device cpu7 with =
driver processor
[    6.914794] bus: 'cpu': really_probe: probing driver processor with de=
vice cpu7
[    6.914806] devices_kset: Moving cpu7 to end of list
[    6.914848] device: 'cooling_device12': device_add
[    6.914919] PM: Adding info for No Bus:cooling_device12
[    6.914949] driver: 'processor': driver_bound: bound to device 'cpu7'
[    6.914952] bus: 'cpu': really_probe: bound device cpu7 to driver proc=
essor
[    6.915124] bus: 'acpi': add driver thermal
[    6.915183] bus: 'acpi': driver_probe_device: matched device LNXTHERM:=
00 with driver thermal
[    6.915188] bus: 'acpi': really_probe: probing driver thermal with dev=
ice LNXTHERM:00
[    6.915205] devices_kset: Moving LNXTHERM:00 to end of list
[    6.919239] device: 'thermal_zone0': device_add
[    6.919437] PM: Adding info for No Bus:thermal_zone0
[    6.919477] (NULL device *): hwmon_device_register() is deprecated. Pl=
ease convert the driver to use hwmon_device_register_with_info().
[    6.919537] device: 'hwmon0': device_add
[    6.919622] PM: Adding info for No Bus:hwmon0
[    6.922022] thermal LNXTHERM:00: registered as thermal_zone0
[    6.922046] ACPI: Thermal Zone [TZ00] (28 C)
[    6.922074] driver: 'thermal': driver_bound: bound to device 'LNXTHERM=
:00'
[    6.922079] bus: 'acpi': really_probe: bound device LNXTHERM:00 to dri=
ver thermal
[    6.922084] bus: 'acpi': driver_probe_device: matched device LNXTHERM:=
01 with driver thermal
[    6.922089] bus: 'acpi': really_probe: probing driver thermal with dev=
ice LNXTHERM:01
[    6.922102] devices_kset: Moving LNXTHERM:01 to end of list
[    6.925651] device: 'thermal_zone1': device_add
[    6.925794] PM: Adding info for No Bus:thermal_zone1
[    6.926637] thermal LNXTHERM:01: registered as thermal_zone1
[    6.926661] ACPI: Thermal Zone [TZ01] (30 C)
[    6.926687] driver: 'thermal': driver_bound: bound to device 'LNXTHERM=
:01'
[    6.926691] bus: 'acpi': really_probe: bound device LNXTHERM:01 to dri=
ver thermal
[    6.926739] bus: 'acpi': add driver hardware_error_device
[    6.926910] bus: 'acpi': add driver battery
[    6.926932] GHES: HEST is not enabled!
[    6.926967] bus: 'platform': add driver gpio-clk
[    6.927044] bus: 'platform': add driver clk-pmc-atom
[    6.927115] bus: 'pci': add driver virtio-pci
[    6.927266] device: 'ptmx': device_add
[    6.927316] PM: Adding info for No Bus:ptmx
[    6.927404] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    6.927492] bus: 'pnp': add driver serial
[    6.927531] bus: 'pnp': driver_probe_device: matched device 00:06 with=
 driver serial
[    6.927536] bus: 'pnp': really_probe: probing driver serial with devic=
e 00:06
[    6.927550] devices_kset: Moving 00:06 to end of list
[    6.947999] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200=
) is a 16550A
[    6.948079] device: 'ttyS0': device_add
[    6.948259] PM: Adding info for No Bus:ttyS0
[    6.948423] driver: 'serial': driver_bound: bound to device '00:06'
[    6.948428] bus: 'pnp': really_probe: bound device 00:06 to driver ser=
ial
[    6.948467] Registering platform device 'serial8250'. Parent at platfo=
rm
[    6.948473] device: 'serial8250': device_add
[    6.948485] bus: 'platform': add device serial8250
[    6.948533] PM: Adding info for platform:serial8250
[    6.948604] device: 'ttyS1': device_add
[    6.948734] PM: Adding info for No Bus:ttyS1
[    6.948903] device: 'ttyS2': device_add
[    6.949011] PM: Adding info for No Bus:ttyS2
[    6.949157] device: 'ttyS3': device_add
[    6.949264] PM: Adding info for No Bus:ttyS3
[    6.949393] device: 'ttyS4': device_add
[    6.949500] PM: Adding info for No Bus:ttyS4
[    6.949626] device: 'ttyS5': device_add
[    6.949733] PM: Adding info for No Bus:ttyS5
[    6.949859] device: 'ttyS6': device_add
[    6.949965] PM: Adding info for No Bus:ttyS6
[    6.950093] device: 'ttyS7': device_add
[    6.950198] PM: Adding info for No Bus:ttyS7
[    6.950346] device: 'ttyS8': device_add
[    6.950452] PM: Adding info for No Bus:ttyS8
[    6.950584] device: 'ttyS9': device_add
[    6.950689] PM: Adding info for No Bus:ttyS9
[    6.950820] device: 'ttyS10': device_add
[    6.950927] PM: Adding info for No Bus:ttyS10
[    6.951056] device: 'ttyS11': device_add
[    6.951163] PM: Adding info for No Bus:ttyS11
[    6.951292] device: 'ttyS12': device_add
[    6.951398] PM: Adding info for No Bus:ttyS12
[    6.951524] device: 'ttyS13': device_add
[    6.951632] PM: Adding info for No Bus:ttyS13
[    6.951761] device: 'ttyS14': device_add
[    6.951867] PM: Adding info for No Bus:ttyS14
[    6.951994] device: 'ttyS15': device_add
[    6.952101] PM: Adding info for No Bus:ttyS15
[    6.952229] device: 'ttyS16': device_add
[    6.952337] PM: Adding info for No Bus:ttyS16
[    6.952463] device: 'ttyS17': device_add
[    6.952570] PM: Adding info for No Bus:ttyS17
[    6.952714] device: 'ttyS18': device_add
[    6.952825] PM: Adding info for No Bus:ttyS18
[    6.952953] device: 'ttyS19': device_add
[    6.953059] PM: Adding info for No Bus:ttyS19
[    6.953186] device: 'ttyS20': device_add
[    6.953290] PM: Adding info for No Bus:ttyS20
[    6.953418] device: 'ttyS21': device_add
[    6.953527] PM: Adding info for No Bus:ttyS21
[    6.953655] device: 'ttyS22': device_add
[    6.953761] PM: Adding info for No Bus:ttyS22
[    6.953888] device: 'ttyS23': device_add
[    6.953995] PM: Adding info for No Bus:ttyS23
[    6.954120] device: 'ttyS24': device_add
[    6.954226] PM: Adding info for No Bus:ttyS24
[    6.954377] device: 'ttyS25': device_add
[    6.954484] PM: Adding info for No Bus:ttyS25
[    6.954610] device: 'ttyS26': device_add
[    6.954717] PM: Adding info for No Bus:ttyS26
[    6.954845] device: 'ttyS27': device_add
[    6.954951] PM: Adding info for No Bus:ttyS27
[    6.955077] device: 'ttyS28': device_add
[    6.955183] PM: Adding info for No Bus:ttyS28
[    6.955309] device: 'ttyS29': device_add
[    6.955415] PM: Adding info for No Bus:ttyS29
[    6.955543] device: 'ttyS30': device_add
[    6.955649] PM: Adding info for No Bus:ttyS30
[    6.955775] device: 'ttyS31': device_add
[    6.955882] PM: Adding info for No Bus:ttyS31
[    6.955990] bus: 'platform': add driver serial8250
[    6.956006] bus: 'platform': driver_probe_device: matched device seria=
l8250 with driver serial8250
[    6.956010] bus: 'platform': really_probe: probing driver serial8250 w=
ith device serial8250
[    6.956023] devices_kset: Moving serial8250 to end of list
[    6.956026] driver: 'serial8250': driver_bound: bound to device 'seria=
l8250'
[    6.956030] bus: 'platform': really_probe: bound device serial8250 to =
driver serial8250
[    6.956058] bus: 'pci': add driver serial
[    6.956119] bus: 'pci': add driver exar_serial
[    6.956168] bus: 'pci': add driver 8250_lpss
[    6.956264] device: 'ttyprintk': device_add
[    6.956320] PM: Adding info for No Bus:ttyprintk
[    6.956403] device: 'hpet': device_add
[    6.956457] PM: Adding info for No Bus:hpet
[    6.956546] bus: 'acpi': add driver hpet
[    6.956567] bus: 'acpi': driver_probe_device: matched device PNP0103:0=
0 with driver hpet
[    6.956571] bus: 'acpi': really_probe: probing driver hpet with device=
 PNP0103:00
[    6.956585] devices_kset: Moving PNP0103:00 to end of list
[    6.957172] hpet: probe of PNP0103:00 rejects match -19
[    6.957259] device: 'hw_random': device_add
[    6.957320] PM: Adding info for No Bus:hw_random
[    6.957440] Linux agpgart interface v0.103
[    6.957460] bus: 'pci': add driver agpgart-amd64
[    6.957637] bus: 'pci': remove driver agpgart-amd64
[    6.957658] driver: 'agpgart-amd64': driver_release
[    6.957664] bus: 'pci': add driver agpgart-intel
[    6.957715] bus: 'pci': add driver agpgart-via
[    6.958014] device: 'cache': device_add
[    6.958060] PM: Adding info for No Bus:cache
[    6.958077] device: 'index0': device_add
[    6.958154] PM: Adding info for No Bus:index0
[    6.958167] device: 'index1': device_add
[    6.958239] PM: Adding info for No Bus:index1
[    6.958273] device: 'index2': device_add
[    6.958345] PM: Adding info for No Bus:index2
[    6.958357] device: 'index3': device_add
[    6.958429] PM: Adding info for No Bus:index3
[    6.958476] device: 'cache': device_add
[    6.958524] PM: Adding info for No Bus:cache
[    6.958540] device: 'index0': device_add
[    6.958613] PM: Adding info for No Bus:index0
[    6.958625] device: 'index1': device_add
[    6.958698] PM: Adding info for No Bus:index1
[    6.958709] device: 'index2': device_add
[    6.958780] PM: Adding info for No Bus:index2
[    6.958791] device: 'index3': device_add
[    6.958866] PM: Adding info for No Bus:index3
[    6.958901] device: 'cache': device_add
[    6.958943] PM: Adding info for No Bus:cache
[    6.958959] device: 'index0': device_add
[    6.959033] PM: Adding info for No Bus:index0
[    6.959045] device: 'index1': device_add
[    6.959117] PM: Adding info for No Bus:index1
[    6.959128] device: 'index2': device_add
[    6.959198] PM: Adding info for No Bus:index2
[    6.959210] device: 'index3': device_add
[    6.959281] PM: Adding info for No Bus:index3
[    6.959355] device: 'cache': device_add
[    6.959400] PM: Adding info for No Bus:cache
[    6.959416] device: 'index0': device_add
[    6.959491] PM: Adding info for No Bus:index0
[    6.959503] device: 'index1': device_add
[    6.959575] PM: Adding info for No Bus:index1
[    6.959587] device: 'index2': device_add
[    6.959658] PM: Adding info for No Bus:index2
[    6.959669] device: 'index3': device_add
[    6.959741] PM: Adding info for No Bus:index3
[    6.959823] device: 'cache': device_add
[    6.959867] PM: Adding info for No Bus:cache
[    6.959883] device: 'index0': device_add
[    6.959957] PM: Adding info for No Bus:index0
[    6.959969] device: 'index1': device_add
[    6.960045] PM: Adding info for No Bus:index1
[    6.960057] device: 'index2': device_add
[    6.960127] PM: Adding info for No Bus:index2
[    6.960138] device: 'index3': device_add
[    6.960210] PM: Adding info for No Bus:index3
[    6.960288] device: 'cache': device_add
[    6.960332] PM: Adding info for No Bus:cache
[    6.960348] device: 'index0': device_add
[    6.960423] PM: Adding info for No Bus:index0
[    6.960435] device: 'index1': device_add
[    6.960505] PM: Adding info for No Bus:index1
[    6.960518] device: 'index2': device_add
[    6.960590] PM: Adding info for No Bus:index2
[    6.960601] device: 'index3': device_add
[    6.960673] PM: Adding info for No Bus:index3
[    6.960712] device: 'cache': device_add
[    6.960753] PM: Adding info for No Bus:cache
[    6.960769] device: 'index0': device_add
[    6.960842] PM: Adding info for No Bus:index0
[    6.960854] device: 'index1': device_add
[    6.960923] PM: Adding info for No Bus:index1
[    6.960935] device: 'index2': device_add
[    6.961006] PM: Adding info for No Bus:index2
[    6.961017] device: 'index3': device_add
[    6.961087] PM: Adding info for No Bus:index3
[    6.961155] device: 'cache': device_add
[    6.961199] PM: Adding info for No Bus:cache
[    6.961216] device: 'index0': device_add
[    6.961290] PM: Adding info for No Bus:index0
[    6.961302] device: 'index1': device_add
[    6.961374] PM: Adding info for No Bus:index1
[    6.961386] device: 'index2': device_add
[    6.961456] PM: Adding info for No Bus:index2
[    6.961468] device: 'index3': device_add
[    6.961539] PM: Adding info for No Bus:index3
[    6.961560] device class 'devcoredump': registering
[    6.965600] device: '1:0': device_add
[    6.965686] PM: Adding info for No Bus:1:0
[    6.965775] device: 'ram0': device_add
[    6.965871] PM: Adding info for No Bus:ram0
[    6.966452] device: '1:1': device_add
[    6.966522] PM: Adding info for No Bus:1:1
[    6.966567] device: 'ram1': device_add
[    6.966651] PM: Adding info for No Bus:ram1
[    6.967041] device: '1:2': device_add
[    6.967107] PM: Adding info for No Bus:1:2
[    6.967149] device: 'ram2': device_add
[    6.967232] PM: Adding info for No Bus:ram2
[    6.967616] device: '1:3': device_add
[    6.967682] PM: Adding info for No Bus:1:3
[    6.967724] device: 'ram3': device_add
[    6.967808] PM: Adding info for No Bus:ram3
[    6.968183] device: '1:4': device_add
[    6.968251] PM: Adding info for No Bus:1:4
[    6.968292] device: 'ram4': device_add
[    6.968373] PM: Adding info for No Bus:ram4
[    6.968748] device: '1:5': device_add
[    6.968815] PM: Adding info for No Bus:1:5
[    6.968856] device: 'ram5': device_add
[    6.968939] PM: Adding info for No Bus:ram5
[    6.969311] device: '1:6': device_add
[    6.969378] PM: Adding info for No Bus:1:6
[    6.969422] device: 'ram6': device_add
[    6.969504] PM: Adding info for No Bus:ram6
[    6.969871] device: '1:7': device_add
[    6.969941] PM: Adding info for No Bus:1:7
[    6.969984] device: 'ram7': device_add
[    6.970067] PM: Adding info for No Bus:ram7
[    6.970492] device: '1:8': device_add
[    6.970558] PM: Adding info for No Bus:1:8
[    6.970601] device: 'ram8': device_add
[    6.970683] PM: Adding info for No Bus:ram8
[    6.971070] device: '1:9': device_add
[    6.971138] PM: Adding info for No Bus:1:9
[    6.971179] device: 'ram9': device_add
[    6.971260] PM: Adding info for No Bus:ram9
[    6.971644] device: '1:10': device_add
[    6.971709] PM: Adding info for No Bus:1:10
[    6.971751] device: 'ram10': device_add
[    6.971834] PM: Adding info for No Bus:ram10
[    6.972217] device: '1:11': device_add
[    6.972284] PM: Adding info for No Bus:1:11
[    6.972328] device: 'ram11': device_add
[    6.972410] PM: Adding info for No Bus:ram11
[    6.972781] device: '1:12': device_add
[    6.972847] PM: Adding info for No Bus:1:12
[    6.972888] device: 'ram12': device_add
[    6.972971] PM: Adding info for No Bus:ram12
[    6.973343] device: '1:13': device_add
[    6.973409] PM: Adding info for No Bus:1:13
[    6.973451] device: 'ram13': device_add
[    6.973533] PM: Adding info for No Bus:ram13
[    6.973903] device: '1:14': device_add
[    6.973970] PM: Adding info for No Bus:1:14
[    6.974014] device: 'ram14': device_add
[    6.974095] PM: Adding info for No Bus:ram14
[    6.974505] device: '1:15': device_add
[    6.974571] PM: Adding info for No Bus:1:15
[    6.974613] device: 'ram15': device_add
[    6.974697] PM: Adding info for No Bus:ram15
[    6.975077] brd: module loaded
[    6.975104] device: 'loop-control': device_add
[    6.975159] PM: Adding info for No Bus:loop-control
[    6.975783] device: '7:0': device_add
[    6.975869] PM: Adding info for No Bus:7:0
[    6.975956] device: 'loop0': device_add
[    6.976049] PM: Adding info for No Bus:loop0
[    6.977376] device: '7:1': device_add
[    6.977448] PM: Adding info for No Bus:7:1
[    6.977499] device: 'loop1': device_add
[    6.977593] PM: Adding info for No Bus:loop1
[    6.978938] device: '7:2': device_add
[    6.979014] PM: Adding info for No Bus:7:2
[    6.979064] device: 'loop2': device_add
[    6.979155] PM: Adding info for No Bus:loop2
[    6.980470] device: '7:3': device_add
[    6.980544] PM: Adding info for No Bus:7:3
[    6.980591] device: 'loop3': device_add
[    6.980681] PM: Adding info for No Bus:loop3
[    6.982046] device: '7:4': device_add
[    6.982122] PM: Adding info for No Bus:7:4
[    6.982168] device: 'loop4': device_add
[    6.982293] PM: Adding info for No Bus:loop4
[    6.983639] device: '7:5': device_add
[    6.983715] PM: Adding info for No Bus:7:5
[    6.983762] device: 'loop5': device_add
[    6.983851] PM: Adding info for No Bus:loop5
[    6.985156] device: '7:6': device_add
[    6.985231] PM: Adding info for No Bus:7:6
[    6.985279] device: 'loop6': device_add
[    6.985367] PM: Adding info for No Bus:loop6
[    6.986680] device: '7:7': device_add
[    6.986755] PM: Adding info for No Bus:7:7
[    6.986801] device: 'loop7': device_add
[    6.986891] PM: Adding info for No Bus:loop7
[    6.987806] loop: module loaded
[    6.987872] bus: 'virtio': add driver virtio_blk
[    6.987914] device class 'mei': registering
[    6.987984] bus: 'mei': registered
[    6.987987] bus: 'pci': add driver mei_me
[    6.988002] bus: 'pci': driver_probe_device: matched device 0000:00:16=
=2E0 with driver mei_me
[    6.988007] bus: 'pci': really_probe: probing driver mei_me with devic=
e 0000:00:16.0
[    6.988023] devices_kset: Moving 0000:00:16.0 to end of list
[    6.991286] device: 'mei0': device_add
[    6.991383] PM: Adding info for No Bus:mei0
[    6.991546] driver: 'mei_me': driver_bound: bound to device '0000:00:1=
6.0'
[    6.991551] bus: 'pci': really_probe: bound device 0000:00:16.0 to dri=
ver mei_me
[    6.991608] bus: 'i2c': add driver htcpld-chip
[    6.991643] bus: 'platform': add driver i2c-htcpld
[    6.991681] bus: 'platform': remove driver i2c-htcpld
[    6.991701] driver: 'i2c-htcpld': driver_release
[    6.991708] bus: 'i2c': add driver wm8994
[    6.991740] bus: 'i2c': add driver tps65912
[    6.991774] bus: 'spi': add driver tps65912
[    6.991805] bus: 'i2c': add driver twl6040
[    6.991836] bus: 'i2c': add driver max77693
[    6.991869] bus: 'i2c': add driver adp5520
[    6.991911] device class 'spi_transport': registering
[    6.991934] device class 'spi_host': registering
[    6.992058] device class 'scsi_disk': registering
[    6.992235] bus: 'scsi': add driver sd
[    6.992270] bus: 'scsi': add driver sr
[    6.992309] device class 'scsi_generic': registering
[    6.992388] bus: 'pci': add driver ahci
[    6.992417] bus: 'pci': driver_probe_device: matched device 0000:00:1f=
=2E2 with driver ahci
[    6.992421] bus: 'pci': really_probe: probing driver ahci with device =
0000:00:1f.2
[    6.992436] devices_kset: Moving 0000:00:1f.2 to end of list
[    6.992441] ahci 0000:00:1f.2: version 3.0
[    6.993913] device: 'mei::b638ab7e-94e2-4ea2-a552-d1c54b627f04:01': de=
vice_add
[    6.993940] bus: 'mei': add device mei::b638ab7e-94e2-4ea2-a552-d1c54b=
627f04:01
[    6.994011] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps =
0x3 impl SATA mode
[    6.994012] PM: Adding info for mei:mei::b638ab7e-94e2-4ea2-a552-d1c54=
b627f04:01
[    6.994048] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part =
ems apst=20
[    6.994076] device: 'mei::3c4852d6-d47b-4f46-b05e-b5edc1aa440e:01': de=
vice_add
[    6.994089] bus: 'mei': add device mei::3c4852d6-d47b-4f46-b05e-b5edc1=
aa440e:01
[    6.994154] PM: Adding info for mei:mei::3c4852d6-d47b-4f46-b05e-b5edc=
1aa440e:01
[    6.994183] device: 'mei::3c4852d6-d47b-4f46-b05e-b5edc1aa430a:01': de=
vice_add
[    6.994196] bus: 'mei': add device mei::3c4852d6-d47b-4f46-b05e-b5edc1=
aa430a:01
[    6.994289] PM: Adding info for mei:mei::3c4852d6-d47b-4f46-b05e-b5edc=
1aa430a:01
[    6.994320] device: 'mei::f908627d-13bf-4a04-b91f-a64e9245323d:01': de=
vice_add
[    6.994334] bus: 'mei': add device mei::f908627d-13bf-4a04-b91f-a64e92=
45323d:01
[    6.994396] PM: Adding info for mei:mei::f908627d-13bf-4a04-b91f-a64e9=
245323d:01
[    6.994424] device: 'mei::8c2f4425-77d6-4755-aca3-891fdbc66a58:01': de=
vice_add
[    6.994437] bus: 'mei': add device mei::8c2f4425-77d6-4755-aca3-891fdb=
c66a58:01
[    6.994497] PM: Adding info for mei:mei::8c2f4425-77d6-4755-aca3-891fd=
bc66a58:01
[    6.994532] device: 'mei::309dcde8-ccb1-4062-8f78-600115a34327:01': de=
vice_add
[    6.994544] bus: 'mei': add device mei::309dcde8-ccb1-4062-8f78-600115=
a34327:01
[    6.994606] PM: Adding info for mei:mei::309dcde8-ccb1-4062-8f78-60011=
5a34327:01
[    6.994634] device: 'mei::55213584-9a29-4916-badf-0fb7ed682aeb:01': de=
vice_add
[    6.994651] bus: 'mei': add device mei::55213584-9a29-4916-badf-0fb7ed=
682aeb:01
[    6.994711] PM: Adding info for mei:mei::55213584-9a29-4916-badf-0fb7e=
d682aeb:01
[    6.994738] device: 'mei::fa8f55e8-ab22-42dd-b916-7dce39002574:01': de=
vice_add
[    6.994751] bus: 'mei': add device mei::fa8f55e8-ab22-42dd-b916-7dce39=
002574:01
[    6.994812] PM: Adding info for mei:mei::fa8f55e8-ab22-42dd-b916-7dce3=
9002574:01
[    7.006412] device: 'ata1': device_add
[    7.006470] PM: Adding info for No Bus:ata1
[    7.006488] device: 'ata1': device_add
[    7.006598] PM: Adding info for No Bus:ata1
[    7.006679] device: 'link1': device_add
[    7.006733] PM: Adding info for No Bus:link1
[    7.006743] device: 'link1': device_add
[    7.006834] PM: Adding info for No Bus:link1
[    7.007484] device: 'dev1.0': device_add
[    7.007560] PM: Adding info for No Bus:dev1.0
[    7.007570] device: 'dev1.0': device_add
[    7.007660] PM: Adding info for No Bus:dev1.0
[    7.007744] device: 'ata2': device_add
[    7.007798] PM: Adding info for No Bus:ata2
[    7.007809] device: 'ata2': device_add
[    7.007896] PM: Adding info for No Bus:ata2
[    7.007952] device: 'link2': device_add
[    7.008008] PM: Adding info for No Bus:link2
[    7.008017] device: 'link2': device_add
[    7.008105] PM: Adding info for No Bus:link2
[    7.008731] device: 'dev2.0': device_add
[    7.008803] PM: Adding info for No Bus:dev2.0
[    7.008812] device: 'dev2.0': device_add
[    7.008900] PM: Adding info for No Bus:dev2.0
[    7.008981] device: 'ata3': device_add
[    7.009035] PM: Adding info for No Bus:ata3
[    7.009046] device: 'ata3': device_add
[    7.009132] PM: Adding info for No Bus:ata3
[    7.009188] device: 'link3': device_add
[    7.009241] PM: Adding info for No Bus:link3
[    7.009251] device: 'link3': device_add
[    7.009336] PM: Adding info for No Bus:link3
[    7.009894] device: 'dev3.0': device_add
[    7.009968] PM: Adding info for No Bus:dev3.0
[    7.009978] device: 'dev3.0': device_add
[    7.010063] PM: Adding info for No Bus:dev3.0
[    7.010146] device: 'ata4': device_add
[    7.010199] PM: Adding info for No Bus:ata4
[    7.010211] device: 'ata4': device_add
[    7.010309] PM: Adding info for No Bus:ata4
[    7.010368] device: 'link4': device_add
[    7.010423] PM: Adding info for No Bus:link4
[    7.010434] device: 'link4': device_add
[    7.010519] PM: Adding info for No Bus:link4
[    7.011145] device: 'dev4.0': device_add
[    7.011219] PM: Adding info for No Bus:dev4.0
[    7.011229] device: 'dev4.0': device_add
[    7.011315] PM: Adding info for No Bus:dev4.0
[    7.011396] device: 'ata5': device_add
[    7.011451] PM: Adding info for No Bus:ata5
[    7.011463] device: 'ata5': device_add
[    7.011547] PM: Adding info for No Bus:ata5
[    7.011603] device: 'link5': device_add
[    7.011656] PM: Adding info for No Bus:link5
[    7.011667] device: 'link5': device_add
[    7.011754] PM: Adding info for No Bus:link5
[    7.012312] device: 'dev5.0': device_add
[    7.012383] PM: Adding info for No Bus:dev5.0
[    7.012394] device: 'dev5.0': device_add
[    7.012481] PM: Adding info for No Bus:dev5.0
[    7.012564] device: 'ata6': device_add
[    7.012618] PM: Adding info for No Bus:ata6
[    7.012630] device: 'ata6': device_add
[    7.012716] PM: Adding info for No Bus:ata6
[    7.012772] device: 'link6': device_add
[    7.012826] PM: Adding info for No Bus:link6
[    7.012836] device: 'link6': device_add
[    7.012924] PM: Adding info for No Bus:link6
[    7.013484] device: 'dev6.0': device_add
[    7.013556] PM: Adding info for No Bus:dev6.0
[    7.013568] device: 'dev6.0': device_add
[    7.013654] PM: Adding info for No Bus:dev6.0
[    7.013993] scsi host0: ahci
[    7.014265] device: 'host0': device_add
[    7.014281] bus: 'scsi': add device host0
[    7.014337] PM: Adding info for scsi:host0
[    7.014379] device: 'host0': device_add
[    7.014532] PM: Adding info for No Bus:host0
[    7.014878] scsi host1: ahci
[    7.014926] device: 'host1': device_add
[    7.014942] bus: 'scsi': add device host1
[    7.015000] PM: Adding info for scsi:host1
[    7.015029] device: 'host1': device_add
[    7.015177] PM: Adding info for No Bus:host1
[    7.015511] scsi host2: ahci
[    7.015548] device: 'host2': device_add
[    7.015562] bus: 'scsi': add device host2
[    7.015617] PM: Adding info for scsi:host2
[    7.015645] device: 'host2': device_add
[    7.015793] PM: Adding info for No Bus:host2
[    7.016156] scsi host3: ahci
[    7.016196] device: 'host3': device_add
[    7.016214] bus: 'scsi': add device host3
[    7.016270] PM: Adding info for scsi:host3
[    7.016301] device: 'host3': device_add
[    7.016456] PM: Adding info for No Bus:host3
[    7.016804] scsi host4: ahci
[    7.016852] device: 'host4': device_add
[    7.016869] bus: 'scsi': add device host4
[    7.016928] PM: Adding info for scsi:host4
[    7.016958] device: 'host4': device_add
[    7.017108] PM: Adding info for No Bus:host4
[    7.017456] scsi host5: ahci
[    7.017495] device: 'host5': device_add
[    7.017512] bus: 'scsi': add device host5
[    7.017568] PM: Adding info for scsi:host5
[    7.017601] device: 'host5': device_add
[    7.017751] PM: Adding info for No Bus:host5
[    7.017815] ata1: SATA max UDMA/133 abar m2048@0xf7f1a000 port 0xf7f1a=
100 irq 28
[    7.017848] ata2: SATA max UDMA/133 abar m2048@0xf7f1a000 port 0xf7f1a=
180 irq 28
[    7.017879] ata3: DUMMY
[    7.017892] ata4: DUMMY
[    7.017906] ata5: DUMMY
[    7.017919] ata6: DUMMY
[    7.017989] driver: 'ahci': driver_bound: bound to device '0000:00:1f.=
2'
[    7.017995] bus: 'pci': really_probe: bound device 0000:00:1f.2 to dri=
ver ahci
[    7.018067] bus: 'pci': add driver ata_piix
[    7.018148] bus: 'pci': add driver pata_sis
[    7.018217] bus: 'pci': add driver pata_acpi
[    7.018307] bus: 'pci': add driver ata_generic
[    7.018382] bus: 'mdio_bus': add driver AM79C874
[    7.018416] bus: 'mdio_bus': add driver Broadcom BCM5411
[    7.018448] bus: 'mdio_bus': add driver Broadcom BCM5421
[    7.018479] bus: 'mdio_bus': add driver Broadcom BCM54210E
[    7.018509] bus: 'mdio_bus': add driver Broadcom BCM5461
[    7.018539] bus: 'mdio_bus': add driver Broadcom BCM54612E
[    7.018568] bus: 'mdio_bus': add driver Broadcom BCM54616S
[    7.018601] bus: 'mdio_bus': add driver Broadcom BCM5464
[    7.018632] bus: 'mdio_bus': add driver Broadcom BCM5481
[    7.018663] bus: 'mdio_bus': add driver Broadcom BCM54810
[    7.018693] bus: 'mdio_bus': add driver Broadcom BCM5482
[    7.018724] bus: 'mdio_bus': add driver Broadcom BCM50610
[    7.018754] bus: 'mdio_bus': add driver Broadcom BCM50610M
[    7.018784] bus: 'mdio_bus': add driver Broadcom BCM57780
[    7.018814] bus: 'mdio_bus': add driver Broadcom BCMAC131
[    7.018845] bus: 'mdio_bus': add driver Broadcom BCM5241
[    7.018875] bus: 'mdio_bus': add driver Cicada Cis8201
[    7.018906] bus: 'mdio_bus': add driver Cicada Cis8204
[    7.018938] bus: 'mdio_bus': add driver Davicom DM9161E
[    7.018970] bus: 'mdio_bus': add driver Davicom DM9161B/C
[    7.019005] bus: 'mdio_bus': add driver Davicom DM9161A
[    7.019035] bus: 'mdio_bus': add driver Davicom DM9131
[    7.019074] Registering platform device 'Fixed MDIO bus.0'. Parent at =
platform
[    7.019079] device: 'Fixed MDIO bus.0': device_add
[    7.019092] bus: 'platform': add device Fixed MDIO bus.0
[    7.019141] PM: Adding info for platform:Fixed MDIO bus.0
[    7.019177] device: 'fixed-0': device_add
[    7.019242] PM: Adding info for No Bus:fixed-0
[    7.019306] libphy: Fixed MDIO Bus: probed
[    7.019325] bus: 'mdio_bus': add driver ICPlus IP175C
[    7.019357] bus: 'mdio_bus': add driver ICPlus IP1001
[    7.019388] bus: 'mdio_bus': add driver ICPlus IP101A/G
[    7.019422] bus: 'mdio_bus': add driver ET1011C
[    7.019453] bus: 'mdio_bus': add driver LXT970
[    7.019487] bus: 'mdio_bus': add driver LXT971
[    7.019517] bus: 'mdio_bus': add driver LXT973-A2
[    7.019548] bus: 'mdio_bus': add driver LXT973
[    7.019580] bus: 'mdio_bus': add driver Marvell 88E1101
[    7.019612] bus: 'mdio_bus': add driver Marvell 88E1112
[    7.019642] bus: 'mdio_bus': add driver Marvell 88E1111
[    7.019672] bus: 'mdio_bus': add driver Marvell 88E1118
[    7.019703] bus: 'mdio_bus': add driver Marvell 88E1121R
[    7.019733] bus: 'mdio_bus': add driver Marvell 88E1318S
[    7.019763] bus: 'mdio_bus': add driver Marvell 88E1145
[    7.019793] bus: 'mdio_bus': add driver Marvell 88E1149R
[    7.019824] bus: 'mdio_bus': add driver Marvell 88E1240
[    7.019854] bus: 'mdio_bus': add driver Marvell 88E1116R
[    7.019884] bus: 'mdio_bus': add driver Marvell 88E1510
[    7.019915] bus: 'mdio_bus': add driver Marvell 88E1540
[    7.019945] bus: 'mdio_bus': add driver Marvell 88E1545
[    7.019975] bus: 'mdio_bus': add driver Marvell 88E3016
[    7.020005] bus: 'mdio_bus': add driver Marvell 88E6390
[    7.020035] bus: 'mdio_bus': add driver Micrel KS8737
[    7.020066] bus: 'mdio_bus': add driver Micrel KSZ8021 or KSZ8031
[    7.020098] bus: 'mdio_bus': add driver Micrel KSZ8031
[    7.020129] bus: 'mdio_bus': add driver Micrel KSZ8041
[    7.020160] bus: 'mdio_bus': add driver Micrel KSZ8041RNLI
[    7.020190] bus: 'mdio_bus': add driver Micrel KSZ8051
[    7.020220] bus: 'mdio_bus': add driver Micrel KSZ8001 or KS8721
[    7.020250] bus: 'mdio_bus': add driver Micrel KSZ8081 or KSZ8091
[    7.020280] bus: 'mdio_bus': add driver Micrel KSZ8061
[    7.020310] bus: 'mdio_bus': add driver Micrel KSZ9021 Gigabit PHY
[    7.020343] bus: 'mdio_bus': add driver Micrel KSZ9031 Gigabit PHY
[    7.020377] bus: 'mdio_bus': add driver Micrel KSZ8873MLL Switch
[    7.020407] bus: 'mdio_bus': add driver Micrel KSZ886X Switch
[    7.020437] bus: 'mdio_bus': add driver Micrel KSZ8795
[    7.020467] bus: 'mdio_bus': add driver NatSemi DP83865
[    7.020499] bus: 'mdio_bus': add driver QS6612
[    7.020530] bus: 'mdio_bus': add driver RTL8201CP Ethernet
[    7.020563] bus: 'mdio_bus': add driver RTL8211B Gigabit Ethernet
[    7.020593] bus: 'mdio_bus': add driver RTL8211DN Gigabit Ethernet
[    7.020624] bus: 'mdio_bus': add driver RTL8211E Gigabit Ethernet
[    7.020654] bus: 'mdio_bus': add driver RTL8211F Gigabit Ethernet
[    7.020686] bus: 'mdio_bus': add driver SMSC LAN83C185
[    7.020717] bus: 'mdio_bus': add driver SMSC LAN8187
[    7.020748] bus: 'mdio_bus': add driver SMSC LAN8700
[    7.020779] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[    7.020809] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[    7.020844] bus: 'mdio_bus': add driver SMSC LAN8740
[    7.020874] bus: 'mdio_bus': add driver STe101p
[    7.020906] bus: 'mdio_bus': add driver STe100p
[    7.020936] bus: 'mdio_bus': add driver Vitesse VSC8234
[    7.020969] bus: 'mdio_bus': add driver Vitesse VSC8244
[    7.021001] bus: 'mdio_bus': add driver Vitesse VSC8514
[    7.021032] bus: 'mdio_bus': add driver Vitesse VSC8572
[    7.021062] bus: 'mdio_bus': add driver Vitesse VSC8574
[    7.021092] bus: 'mdio_bus': add driver Vitesse VSC8601
[    7.021124] bus: 'mdio_bus': add driver Vitesse VSC8662
[    7.021154] bus: 'mdio_bus': add driver Vitesse VSC8221
[    7.021184] bus: 'mdio_bus': add driver Vitesse VSC8211
[    7.021215] tun: Universal TUN/TAP device driver, 1.6
[    7.021246] device: 'tun': device_add
[    7.021301] PM: Adding info for No Bus:tun
[    7.021488] bus: 'virtio': add driver virtio_net
[    7.021522] PPP generic driver version 2.4.2
[    7.021562] device class 'ppp': registering
[    7.021598] device: 'ppp': device_add
[    7.021655] PM: Adding info for No Bus:ppp
[    7.021750] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    7.021801] ehci-pci: EHCI PCI platform driver
[    7.021821] bus: 'pci': add driver ehci-pci
[    7.021836] bus: 'pci': driver_probe_device: matched device 0000:00:1a=
=2E0 with driver ehci-pci
[    7.021841] bus: 'pci': really_probe: probing driver ehci-pci with dev=
ice 0000:00:1a.0
[    7.021858] devices_kset: Moving 0000:00:1a.0 to end of list
[    7.023234] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    7.023349] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bu=
s number 1
[    7.023421] ehci-pci 0000:00:1a.0: debug port 2
[    7.027447] ehci-pci 0000:00:1a.0: cache line size of 64 is not suppor=
ted
[    7.027526] ehci-pci 0000:00:1a.0: irq 20, io mem 0xf7f1c000
[    7.042279] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    7.042821] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    7.042855] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    7.042889] usb usb1: Product: EHCI Host Controller
[    7.042912] usb usb1: Manufacturer: Linux 4.11.1-rc1+ ehci_hcd
[    7.042937] usb usb1: SerialNumber: 0000:00:1a.0
[    7.042969] device: 'usb1': device_add
[    7.043183] bus: 'usb': add device usb1
[    7.043289] PM: Adding info for usb:usb1
[    7.043507] bus: 'usb': driver_probe_device: matched device usb1 with =
driver usb
[    7.043516] bus: 'usb': really_probe: probing driver usb with device u=
sb1
[    7.043539] devices_kset: Moving usb1 to end of list
[    7.043684] device: '1-0:1.0': device_add
[    7.043747] bus: 'usb': add device 1-0:1.0
[    7.043794] PM: Adding info for usb:1-0:1.0
[    7.043848] bus: 'usb': driver_probe_device: matched device 1-0:1.0 wi=
th driver hub
[    7.043855] bus: 'usb': really_probe: probing driver hub with device 1=
-0:1.0
[    7.043878] devices_kset: Moving 1-0:1.0 to end of list
[    7.043889] hub 1-0:1.0: USB hub found
[    7.044004] hub 1-0:1.0: 2 ports detected
[    7.044238] device: 'usb1-port1': device_add
[    7.045219] PM: Adding info for No Bus:usb1-port1
[    7.045296] device: 'usb1-port2': device_add
[    7.045423] PM: Adding info for No Bus:usb1-port2
[    7.045613] driver: 'hub': driver_bound: bound to device '1-0:1.0'
[    7.045622] bus: 'usb': really_probe: bound device 1-0:1.0 to driver h=
ub
[    7.045673] device: 'ep_81': device_add
[    7.045783] PM: Adding info for No Bus:ep_81
[    7.045791] driver: 'usb': driver_bound: bound to device 'usb1'
[    7.045797] bus: 'usb': really_probe: bound device usb1 to driver usb
[    7.045820] device: 'ep_00': device_add
[    7.045916] PM: Adding info for No Bus:ep_00
[    7.045955] driver: 'ehci-pci': driver_bound: bound to device '0000:00=
:1a.0'
[    7.045960] bus: 'pci': really_probe: bound device 0000:00:1a.0 to dri=
ver ehci-pci
[    7.045968] bus: 'pci': driver_probe_device: matched device 0000:00:1d=
=2E0 with driver ehci-pci
[    7.045972] bus: 'pci': really_probe: probing driver ehci-pci with dev=
ice 0000:00:1d.0
[    7.045986] devices_kset: Moving 0000:00:1d.0 to end of list
[    7.047308] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    7.047362] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bu=
s number 2
[    7.047417] ehci-pci 0000:00:1d.0: debug port 2
[    7.051405] ehci-pci 0000:00:1d.0: cache line size of 64 is not suppor=
ted
[    7.051472] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7f1b000
[    7.066277] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    7.066714] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    7.066744] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    7.066778] usb usb2: Product: EHCI Host Controller
[    7.066801] usb usb2: Manufacturer: Linux 4.11.1-rc1+ ehci_hcd
[    7.066826] usb usb2: SerialNumber: 0000:00:1d.0
[    7.066856] device: 'usb2': device_add
[    7.067050] bus: 'usb': add device usb2
[    7.067153] PM: Adding info for usb:usb2
[    7.067318] bus: 'usb': driver_probe_device: matched device usb2 with =
driver usb
[    7.067323] bus: 'usb': really_probe: probing driver usb with device u=
sb2
[    7.067340] devices_kset: Moving usb2 to end of list
[    7.067419] device: '2-0:1.0': device_add
[    7.067482] bus: 'usb': add device 2-0:1.0
[    7.067531] PM: Adding info for usb:2-0:1.0
[    7.067563] bus: 'usb': driver_probe_device: matched device 2-0:1.0 wi=
th driver hub
[    7.067568] bus: 'usb': really_probe: probing driver hub with device 2=
-0:1.0
[    7.067587] devices_kset: Moving 2-0:1.0 to end of list
[    7.067595] hub 2-0:1.0: USB hub found
[    7.067693] hub 2-0:1.0: 2 ports detected
[    7.067863] device: 'usb2-port1': device_add
[    7.068824] PM: Adding info for No Bus:usb2-port1
[    7.068879] device: 'usb2-port2': device_add
[    7.069005] PM: Adding info for No Bus:usb2-port2
[    7.069150] driver: 'hub': driver_bound: bound to device '2-0:1.0'
[    7.069156] bus: 'usb': really_probe: bound device 2-0:1.0 to driver h=
ub
[    7.069182] device: 'ep_81': device_add
[    7.069293] PM: Adding info for No Bus:ep_81
[    7.069299] driver: 'usb': driver_bound: bound to device 'usb2'
[    7.069304] bus: 'usb': really_probe: bound device usb2 to driver usb
[    7.069324] device: 'ep_00': device_add
[    7.069417] PM: Adding info for No Bus:ep_00
[    7.069456] driver: 'ehci-pci': driver_bound: bound to device '0000:00=
:1d.0'
[    7.069461] bus: 'pci': really_probe: bound device 0000:00:1d.0 to dri=
ver ehci-pci
[    7.069502] ehci-platform: EHCI generic platform driver
[    7.069524] bus: 'platform': add driver ehci-platform
[    7.069569] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.069601] ohci-pci: OHCI PCI platform driver
[    7.069620] bus: 'pci': add driver ohci-pci
[    7.069672] ohci-platform: OHCI generic platform driver
[    7.069692] bus: 'platform': add driver ohci-platform
[    7.069728] uhci_hcd: USB Universal Host Controller Interface driver
[    7.069902] bus: 'pci': add driver uhci_hcd
[    7.069974] bus: 'pci': add driver xhci_hcd
[    7.069987] bus: 'pci': driver_probe_device: matched device 0000:00:14=
=2E0 with driver xhci_hcd
[    7.069991] bus: 'pci': really_probe: probing driver xhci_hcd with dev=
ice 0000:00:14.0
[    7.070006] devices_kset: Moving 0000:00:14.0 to end of list
[    7.071319] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    7.071374] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bu=
s number 3
[    7.072733] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0=
x100 quirks 0x00009810
[    7.072777] xhci_hcd 0000:00:14.0: cache line size of 64 is not suppor=
ted
[    7.073431] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    7.073461] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    7.073495] usb usb3: Product: xHCI Host Controller
[    7.073518] usb usb3: Manufacturer: Linux 4.11.1-rc1+ xhci-hcd
[    7.073543] usb usb3: SerialNumber: 0000:00:14.0
[    7.073573] device: 'usb3': device_add
[    7.073768] bus: 'usb': add device usb3
[    7.073870] PM: Adding info for usb:usb3
[    7.074034] bus: 'usb': driver_probe_device: matched device usb3 with =
driver usb
[    7.074039] bus: 'usb': really_probe: probing driver usb with device u=
sb3
[    7.074056] devices_kset: Moving usb3 to end of list
[    7.074136] device: '3-0:1.0': device_add
[    7.074201] bus: 'usb': add device 3-0:1.0
[    7.074266] PM: Adding info for usb:3-0:1.0
[    7.074298] bus: 'usb': driver_probe_device: matched device 3-0:1.0 wi=
th driver hub
[    7.074303] bus: 'usb': really_probe: probing driver hub with device 3=
-0:1.0
[    7.074324] devices_kset: Moving 3-0:1.0 to end of list
[    7.074332] hub 3-0:1.0: USB hub found
[    7.074457] hub 3-0:1.0: 14 ports detected
[    7.074629] device: 'usb3-port1': device_add
[    7.081474] PM: Adding info for No Bus:usb3-port1
[    7.081530] device: 'usb3-port2': device_add
[    7.088658] PM: Adding info for No Bus:usb3-port2
[    7.088713] device: 'usb3-port3': device_add
[    7.096333] PM: Adding info for No Bus:usb3-port3
[    7.096388] device: 'usb3-port4': device_add
[    7.104081] PM: Adding info for No Bus:usb3-port4
[    7.104137] device: 'usb3-port5': device_add
[    7.112115] PM: Adding info for No Bus:usb3-port5
[    7.112172] device: 'usb3-port6': device_add
[    7.120446] PM: Adding info for No Bus:usb3-port6
[    7.120505] device: 'usb3-port7': device_add
[    7.129086] PM: Adding info for No Bus:usb3-port7
[    7.129142] device: 'usb3-port8': device_add
[    7.137994] PM: Adding info for No Bus:usb3-port8
[    7.138048] device: 'usb3-port9': device_add
[    7.147698] PM: Adding info for No Bus:usb3-port9
[    7.147753] device: 'usb3-port10': device_add
[    7.157233] PM: Adding info for No Bus:usb3-port10
[    7.157288] device: 'usb3-port11': device_add
[    7.167043] PM: Adding info for No Bus:usb3-port11
[    7.167097] device: 'usb3-port12': device_add
[    7.177276] PM: Adding info for No Bus:usb3-port12
[    7.177331] device: 'usb3-port13': device_add
[    7.187684] PM: Adding info for No Bus:usb3-port13
[    7.187738] device: 'usb3-port14': device_add
[    7.198379] PM: Adding info for No Bus:usb3-port14
[    7.199156] driver: 'hub': driver_bound: bound to device '3-0:1.0'
[    7.199163] bus: 'usb': really_probe: bound device 3-0:1.0 to driver h=
ub
[    7.199189] device: 'ep_81': device_add
[    7.199298] PM: Adding info for No Bus:ep_81
[    7.199303] driver: 'usb': driver_bound: bound to device 'usb3'
[    7.199308] bus: 'usb': really_probe: bound device usb3 to driver usb
[    7.199329] device: 'ep_00': device_add
[    7.199424] PM: Adding info for No Bus:ep_00
[    7.199467] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    7.199516] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bu=
s number 4
[    7.200014] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    7.200044] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    7.200077] usb usb4: Product: xHCI Host Controller
[    7.200099] usb usb4: Manufacturer: Linux 4.11.1-rc1+ xhci-hcd
[    7.200123] usb usb4: SerialNumber: 0000:00:14.0
[    7.200152] device: 'usb4': device_add
[    7.200346] bus: 'usb': add device usb4
[    7.200443] PM: Adding info for usb:usb4
[    7.200640] bus: 'usb': driver_probe_device: matched device usb4 with =
driver usb
[    7.200647] bus: 'usb': really_probe: probing driver usb with device u=
sb4
[    7.200667] devices_kset: Moving usb4 to end of list
[    7.200816] device: '4-0:1.0': device_add
[    7.200878] bus: 'usb': add device 4-0:1.0
[    7.200922] PM: Adding info for usb:4-0:1.0
[    7.200957] bus: 'usb': driver_probe_device: matched device 4-0:1.0 wi=
th driver hub
[    7.200963] bus: 'usb': really_probe: probing driver hub with device 4=
-0:1.0
[    7.200984] devices_kset: Moving 4-0:1.0 to end of list
[    7.200995] hub 4-0:1.0: USB hub found
[    7.201112] hub 4-0:1.0: 6 ports detected
[    7.201296] device: 'usb4-port1': device_add
[    7.206511] PM: Adding info for No Bus:usb4-port1
[    7.206631] device: 'usb4-port2': device_add
[    7.211828] PM: Adding info for No Bus:usb4-port2
[    7.211914] device: 'usb4-port3': device_add
[    7.217092] PM: Adding info for No Bus:usb4-port3
[    7.217176] device: 'usb4-port4': device_add
[    7.222364] PM: Adding info for No Bus:usb4-port4
[    7.222446] device: 'usb4-port5': device_add
[    7.227627] PM: Adding info for No Bus:usb4-port5
[    7.227712] device: 'usb4-port6': device_add
[    7.232883] PM: Adding info for No Bus:usb4-port6
[    7.233247] driver: 'hub': driver_bound: bound to device '4-0:1.0'
[    7.233254] bus: 'usb': really_probe: bound device 4-0:1.0 to driver h=
ub
[    7.233281] device: 'ep_81': device_add
[    7.233388] PM: Adding info for No Bus:ep_81
[    7.233394] driver: 'usb': driver_bound: bound to device 'usb4'
[    7.233400] bus: 'usb': really_probe: bound device usb4 to driver usb
[    7.233422] device: 'ep_00': device_add
[    7.233511] PM: Adding info for No Bus:ep_00
[    7.233525] driver: 'xhci_hcd': driver_bound: bound to device '0000:00=
:14.0'
[    7.233530] bus: 'pci': really_probe: bound device 0000:00:14.0 to dri=
ver xhci_hcd
[    7.233575] bus: 'ssb': add driver ssb_hcd
[    7.233610] usbip_core: USB/IP Core v1.0.0
[    7.233759] bus: 'platform': add driver vhci_hcd
[    7.233809] Registering platform device 'vhci_hcd'. Parent at platform=

[    7.233815] device: 'vhci_hcd': device_add
[    7.233827] bus: 'platform': add device vhci_hcd
[    7.233877] PM: Adding info for platform:vhci_hcd
[    7.233902] bus: 'platform': driver_probe_device: matched device vhci_=
hcd with driver vhci_hcd
[    7.233906] bus: 'platform': really_probe: probing driver vhci_hcd wit=
h device vhci_hcd
[    7.233919] devices_kset: Moving vhci_hcd to end of list
[    7.233941] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    7.233966] vhci_hcd vhci_hcd: new USB bus registered, assigned bus nu=
mber 5
[    7.234036] vhci_hcd: created sysfs vhci_hcd
[    7.234438] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    7.234467] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    7.234498] usb usb5: Product: USB/IP Virtual Host Controller
[    7.234521] usb usb5: Manufacturer: Linux 4.11.1-rc1+ vhci_hcd
[    7.234544] usb usb5: SerialNumber: vhci_hcd
[    7.234572] device: 'usb5': device_add
[    7.234706] bus: 'usb': add device usb5
[    7.234806] PM: Adding info for usb:usb5
[    7.235011] bus: 'usb': driver_probe_device: matched device usb5 with =
driver usb
[    7.235017] bus: 'usb': really_probe: probing driver usb with device u=
sb5
[    7.235037] devices_kset: Moving usb5 to end of list
[    7.235134] device: '5-0:1.0': device_add
[    7.235193] bus: 'usb': add device 5-0:1.0
[    7.235236] PM: Adding info for usb:5-0:1.0
[    7.235270] bus: 'usb': driver_probe_device: matched device 5-0:1.0 wi=
th driver hub
[    7.235276] bus: 'usb': really_probe: probing driver hub with device 5=
-0:1.0
[    7.235297] devices_kset: Moving 5-0:1.0 to end of list
[    7.235307] hub 5-0:1.0: USB hub found
[    7.235432] hub 5-0:1.0: 8 ports detected
[    7.235614] device: 'usb5-port1': device_add
[    7.235702] PM: Adding info for No Bus:usb5-port1
[    7.235794] device: 'usb5-port2': device_add
[    7.235872] PM: Adding info for No Bus:usb5-port2
[    7.235946] device: 'usb5-port3': device_add
[    7.236025] PM: Adding info for No Bus:usb5-port3
[    7.236099] device: 'usb5-port4': device_add
[    7.236176] PM: Adding info for No Bus:usb5-port4
[    7.236248] device: 'usb5-port5': device_add
[    7.236325] PM: Adding info for No Bus:usb5-port5
[    7.236398] device: 'usb5-port6': device_add
[    7.236477] PM: Adding info for No Bus:usb5-port6
[    7.236548] device: 'usb5-port7': device_add
[    7.236625] PM: Adding info for No Bus:usb5-port7
[    7.236696] device: 'usb5-port8': device_add
[    7.236775] PM: Adding info for No Bus:usb5-port8
[    7.237229] driver: 'hub': driver_bound: bound to device '5-0:1.0'
[    7.237235] bus: 'usb': really_probe: bound device 5-0:1.0 to driver h=
ub
[    7.237261] device: 'ep_81': device_add
[    7.237363] PM: Adding info for No Bus:ep_81
[    7.237368] driver: 'usb': driver_bound: bound to device 'usb5'
[    7.237373] bus: 'usb': really_probe: bound device usb5 to driver usb
[    7.237395] device: 'ep_00': device_add
[    7.237484] PM: Adding info for No Bus:ep_00
[    7.237497] driver: 'vhci_hcd': driver_bound: bound to device 'vhci_hc=
d'
[    7.237501] bus: 'platform': really_probe: bound device vhci_hcd to dr=
iver vhci_hcd
[    7.237506] vhci_hcd: USB/IP 'Virtual' Host Controller (VHCI) Driver v=
1.0.0
[    7.237669] bus: 'usb': add driver usbip-host
[    7.237710] usbcore: registered new device driver usbip-host
[    7.237737] usbip_host: USB/IP Host Driver v1.0.0
[    7.237757] bus: 'pnp': add driver i8042 kbd
[    7.237793] bus: 'pnp': add driver i8042 aux
[    7.237830] bus: 'pnp': remove driver i8042 kbd
[    7.237851] driver: 'i8042 kbd': driver_release
[    7.237860] bus: 'pnp': remove driver i8042 aux
[    7.237879] driver: 'i8042 aux': driver_release
[    7.237883] i8042: PNP: No PS/2 controller found.
[    7.237925] device: 'mice': device_add
[    7.237987] PM: Adding info for No Bus:mice
[    7.238128] device: 'psaux': device_add
[    7.238184] PM: Adding info for No Bus:psaux
[    7.238272] mousedev: PS/2 mouse device common for all mice
[    7.238319] device: 'event0': device_add
[    7.238390] PM: Adding info for No Bus:event0
[    7.238524] device: 'event1': device_add
[    7.238585] PM: Adding info for No Bus:event1
[    7.238681] bus: 'serio': add driver atkbd
[    7.238808] device: 'uinput': device_add
[    7.238861] PM: Adding info for No Bus:uinput
[    7.238948] bus: 'pnp': add driver rtc_cmos
[    7.238961] bus: 'pnp': driver_probe_device: matched device 00:02 with=
 driver rtc_cmos
[    7.238965] bus: 'pnp': really_probe: probing driver rtc_cmos with dev=
ice 00:02
[    7.238979] devices_kset: Moving 00:02 to end of list
[    7.238994] rtc_cmos 00:02: RTC can wake from S4
[    7.239153] rtc rtc0: alarm rollover: day
[    7.239183] device: 'rtc0': device_add
[    7.239291] PM: Adding info for No Bus:rtc0
[    7.239401] rtc rtc0: rtc_cmos: dev (252:0)
[    7.239412] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    7.239483] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvr=
am, hpet irqs
[    7.239516] driver: 'rtc_cmos': driver_bound: bound to device '00:02'
[    7.239520] bus: 'pnp': really_probe: bound device 00:02 to driver rtc=
_cmos
[    7.240089] device-mapper: uevent: version 1.0.3
[    7.240442] device: 'device-mapper': device_add
[    7.240495] PM: Adding info for No Bus:device-mapper
[    7.240623] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialise=
d: dm-devel@redhat.com
[    7.240660] intel_pstate: Intel P-state driver initializing
[    7.241890] device: 'ashmem': device_add
[    7.241938] PM: Adding info for No Bus:ashmem
[    7.242020] ashmem: initialized
[    7.242050] device class 'extcon': registering
[    7.242145] device: 'binder': device_add
[    7.242194] PM: Adding info for No Bus:binder
[    7.243320] NET: Registered protocol family 10
[    7.244757] Segment Routing with IPv6
[    7.244816] NET: Registered protocol family 17
[    7.244888] Key type dns_resolver registered
[    7.244952] bus: 'machinecheck': registered
[    7.244961] device: 'machinecheck': device_add
[    7.244998] PM: Adding info for No Bus:machinecheck
[    7.245039] device: 'machinecheck0': device_add
[    7.245052] bus: 'machinecheck': add device machinecheck0
[    7.245090] PM: Adding info for machinecheck:machinecheck0
[    7.245249] device: 'machinecheck1': device_add
[    7.245263] bus: 'machinecheck': add device machinecheck1
[    7.245302] PM: Adding info for machinecheck:machinecheck1
[    7.245403] device: 'machinecheck2': device_add
[    7.245413] bus: 'machinecheck': add device machinecheck2
[    7.245461] PM: Adding info for machinecheck:machinecheck2
[    7.245586] device: 'machinecheck3': device_add
[    7.245601] bus: 'machinecheck': add device machinecheck3
[    7.245645] PM: Adding info for machinecheck:machinecheck3
[    7.245812] device: 'machinecheck4': device_add
[    7.245827] bus: 'machinecheck': add device machinecheck4
[    7.245870] PM: Adding info for machinecheck:machinecheck4
[    7.246018] device: 'machinecheck5': device_add
[    7.246033] bus: 'machinecheck': add device machinecheck5
[    7.246076] PM: Adding info for machinecheck:machinecheck5
[    7.246208] device: 'machinecheck6': device_add
[    7.246223] bus: 'machinecheck': add device machinecheck6
[    7.246282] PM: Adding info for machinecheck:machinecheck6
[    7.246444] device: 'machinecheck7': device_add
[    7.246458] bus: 'machinecheck': add device machinecheck7
[    7.246502] PM: Adding info for machinecheck:machinecheck7
[    7.246631] device: 'mcelog': device_add
[    7.246685] PM: Adding info for No Bus:mcelog
[    7.246875] Registering platform device 'microcode'. Parent at platfor=
m
[    7.246881] device: 'microcode': device_add
[    7.246893] bus: 'platform': add device microcode
[    7.246946] PM: Adding info for platform:microcode
[    7.247020] microcode: sig=3D0x306c3, pf=3D0x2, revision=3D0x9
[    7.247231] device: 'microcode': device_add
[    7.247283] PM: Adding info for No Bus:microcode
[    7.247441] microcode: Microcode Update Driver: v2.2.
[    7.247525] device: 'cpu_dma_latency': device_add
[    7.247597] PM: Adding info for No Bus:cpu_dma_latency
[    7.247730] device: 'network_latency': device_add
[    7.247783] PM: Adding info for No Bus:network_latency
[    7.247936] device: 'network_throughput': device_add
[    7.247986] PM: Adding info for No Bus:network_throughput
[    7.248116] device: 'memory_bandwidth': device_add
[    7.248168] PM: Adding info for No Bus:memory_bandwidth
[    7.248321] registered taskstats version 1
[    7.252543] Key type trusted registered
[    7.259854] Key type encrypted registered
[    7.259879] AppArmor: AppArmor sha1 policy hashing enabled
[    7.259900] evm: HMAC attrs: 0x1
[    7.264077]   Magic number: 1:743:489
[    7.264238] rtc_cmos 00:02: setting system clock to 2017-05-15 16:28:0=
7 UTC (1494865687)
[    7.264475] bus: 'platform': add driver charger-manager
[    7.264536] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    7.264556] EDD information not available.
[    7.264912] PM: Hibernation image not present or could not be loaded.
[    7.264925] ALSA device list:
[    7.264939]   No soundcards found.
[    7.333246] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.333308] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.335132] ata2.00: ATA-9: ST1000DM003-1CH162, CC49, max UDMA/133
[    7.335157] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31=
/32), AA
[    7.348435] ata1.00: ATA-9: INTEL SSDSC2BW120A4, DC32, max UDMA/133
[    7.348462] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    7.374244] ata1.00: configured for UDMA/133
[    7.374311] usb 1-1: new high-speed USB device number 2 using ehci-pci=

[    7.375226] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2BW12 =
DC32 PQ: 0 ANSI: 5
[    7.375675] device: 'target0:0:0': device_add
[    7.375700] bus: 'scsi': add device target0:0:0
[    7.375760] PM: Adding info for scsi:target0:0:0
[    7.375807] device: '0:0:0:0': device_add
[    7.375932] bus: 'scsi': add device 0:0:0:0
[    7.375983] PM: Adding info for scsi:0:0:0:0
[    7.376009] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 w=
ith driver sd
[    7.376018] bus: 'scsi': really_probe: probing driver sd with device 0=
:0:0:0
[    7.376036] devices_kset: Moving 0:0:0:0 to end of list
[    7.376103] device: '0:0:0:0': device_add
[    7.376248] PM: Adding info for No Bus:0:0:0:0
[    7.376324] driver: 'sd': driver_bound: bound to device '0:0:0:0'
[    7.376356] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver =
sd
[    7.376371] device: '0:0:0:0': device_add
[    7.376476] PM: Adding info for No Bus:0:0:0:0
[    7.376597] device: 'sg0': device_add
[    7.376696] PM: Adding info for No Bus:sg0
[    7.376888] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.376944] device: '0:0:0:0': device_add
[    7.377046] PM: Adding info for No Bus:0:0:0:0
[    7.377054] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 =
GB/112 GiB)
[    7.377160] sd 0:0:0:0: [sda] Write Protect is off
[    7.377182] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.377353] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    7.377617] device: '8:0': device_add
[    7.377714] PM: Adding info for No Bus:8:0
[    7.377786] device: 'sda': device_add
[    7.377904] PM: Adding info for No Bus:sda
[    7.379922]  sda: sda1 sda2
[    7.379984] device: 'sda1': device_add
[    7.380114] PM: Adding info for No Bus:sda1
[    7.380291] device: 'sda2': device_add
[    7.380409] PM: Adding info for No Bus:sda2
[    7.381684] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.398326] usb 2-1: new high-speed USB device number 2 using ehci-pci=

[    7.522959] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
8008
[    7.522991] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    7.523024] device: '1-1': device_add
[    7.523218] bus: 'usb': add device 1-1
[    7.523321] PM: Adding info for usb:1-1
[    7.523565] bus: 'usb': driver_probe_device: matched device 1-1 with d=
river usb
[    7.523580] bus: 'usb': really_probe: probing driver usb with device 1=
-1
[    7.523613] devices_kset: Moving 1-1 to end of list
[    7.524003] device: '1-1:1.0': device_add
[    7.524107] bus: 'usb': add device 1-1:1.0
[    7.524186] PM: Adding info for usb:1-1:1.0
[    7.524249] bus: 'usb': driver_probe_device: matched device 1-1:1.0 wi=
th driver hub
[    7.524262] bus: 'usb': really_probe: probing driver hub with device 1=
-1:1.0
[    7.524305] devices_kset: Moving 1-1:1.0 to end of list
[    7.524325] hub 1-1:1.0: USB hub found
[    7.524517] hub 1-1:1.0: 6 ports detected
[    7.525027] ata2.00: configured for UDMA/133
[    7.525090] device: '1-1-port1': device_add
[    7.525691] scsi 1:0:0:0: Direct-Access     ATA      ST1000DM003-1CH1 =
CC49 PQ: 0 ANSI: 5
[    7.526150] device: 'target1:0:0': device_add
[    7.526167] bus: 'scsi': add device target1:0:0
[    7.526186] PM: Adding info for No Bus:1-1-port1
[    7.526224] PM: Adding info for scsi:target1:0:0
[    7.526257] device: '1:0:0:0': device_add
[    7.526306] device: '1-1-port2': device_add
[    7.526409] bus: 'scsi': add device 1:0:0:0
[    7.526454] PM: Adding info for scsi:1:0:0:0
[    7.526473] bus: 'scsi': driver_probe_device: matched device 1:0:0:0 w=
ith driver sd
[    7.526477] bus: 'scsi': really_probe: probing driver sd with device 1=
:0:0:0
[    7.526491] devices_kset: Moving 1:0:0:0 to end of list
[    7.526527] device: '1:0:0:0': device_add
[    7.526649] PM: Adding info for No Bus:1:0:0:0
[    7.526683] driver: 'sd': driver_bound: bound to device '1:0:0:0'
[    7.526702] bus: 'scsi': really_probe: bound device 1:0:0:0 to driver =
sd
[    7.526711] device: '1:0:0:0': device_add
[    7.526779] PM: Adding info for No Bus:1:0:0:0
[    7.526856] device: 'sg1': device_add
[    7.526918] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.0=
0 TB/932 GiB)
[    7.526934] PM: Adding info for No Bus:sg1
[    7.526951] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    7.527061] sd 1:0:0:0: [sdb] Write Protect is off
[    7.527064] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    7.527083] device: '1:0:0:0': device_add
[    7.527098] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    7.527158] PM: Adding info for No Bus:1:0:0:0
[    7.527167] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    7.527253] PM: Adding info for No Bus:1-1-port2
[    7.527334] device: '1-1-port3': device_add
[    7.527413] device: '8:16': device_add
[    7.527493] PM: Adding info for No Bus:8:16
[    7.527536] device: 'sdb': device_add
[    7.527631] PM: Adding info for No Bus:sdb
[    7.528261] PM: Adding info for No Bus:1-1-port3
[    7.528324] device: '1-1-port4': device_add
[    7.529172] PM: Adding info for No Bus:1-1-port4
[    7.529233] device: '1-1-port5': device_add
[    7.530079] PM: Adding info for No Bus:1-1-port5
[    7.530141] device: '1-1-port6': device_add
[    7.530999] PM: Adding info for No Bus:1-1-port6
[    7.531091] usb 3-3: new high-speed USB device number 2 using xhci_hcd=

[    7.531751] driver: 'hub': driver_bound: bound to device '1-1:1.0'
[    7.531764] bus: 'usb': really_probe: bound device 1-1:1.0 to driver h=
ub
[    7.531789] device: 'ep_81': device_add
[    7.531876] PM: Adding info for No Bus:ep_81
[    7.531882] driver: 'usb': driver_bound: bound to device '1-1'
[    7.531887] bus: 'usb': really_probe: bound device 1-1 to driver usb
[    7.531913] device: 'ep_00': device_add
[    7.531981] PM: Adding info for No Bus:ep_00
[    7.550957] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
8000
[    7.550987] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    7.551019] device: '2-1': device_add
[    7.551128] bus: 'usb': add device 2-1
[    7.551176] PM: Adding info for usb:2-1
[    7.551325] bus: 'usb': driver_probe_device: matched device 2-1 with d=
river usb
[    7.551331] bus: 'usb': really_probe: probing driver usb with device 2=
-1
[    7.551349] devices_kset: Moving 2-1 to end of list
[    7.551623] device: '2-1:1.0': device_add
[    7.551677] bus: 'usb': add device 2-1:1.0
[    7.551717] PM: Adding info for usb:2-1:1.0
[    7.551750] bus: 'usb': driver_probe_device: matched device 2-1:1.0 wi=
th driver hub
[    7.551755] bus: 'usb': really_probe: probing driver hub with device 2=
-1:1.0
[    7.551772] devices_kset: Moving 2-1:1.0 to end of list
[    7.551780] hub 2-1:1.0: USB hub found
[    7.552075] hub 2-1:1.0: 8 ports detected
[    7.552540] device: '2-1-port1': device_add
[    7.553611] PM: Adding info for No Bus:2-1-port1
[    7.553685] device: '2-1-port2': device_add
[    7.554640] PM: Adding info for No Bus:2-1-port2
[    7.554703] device: '2-1-port3': device_add
[    7.555988] PM: Adding info for No Bus:2-1-port3
[    7.556052] device: '2-1-port4': device_add
[    7.556957] PM: Adding info for No Bus:2-1-port4
[    7.557019] device: '2-1-port5': device_add
[    7.557926] PM: Adding info for No Bus:2-1-port5
[    7.557987] device: '2-1-port6': device_add
[    7.558915] PM: Adding info for No Bus:2-1-port6
[    7.558977] device: '2-1-port7': device_add
[    7.559883] PM: Adding info for No Bus:2-1-port7
[    7.559945] device: '2-1-port8': device_add
[    7.560851] PM: Adding info for No Bus:2-1-port8
[    7.562697] driver: 'hub': driver_bound: bound to device '2-1:1.0'
[    7.562705] bus: 'usb': really_probe: bound device 2-1:1.0 to driver h=
ub
[    7.562731] device: 'ep_81': device_add
[    7.562828] PM: Adding info for No Bus:ep_81
[    7.562833] driver: 'usb': driver_bound: bound to device '2-1'
[    7.562839] bus: 'usb': really_probe: bound device 2-1 to driver usb
[    7.562865] device: 'ep_00': device_add
[    7.562942] PM: Adding info for No Bus:ep_00
[    7.568966]  sdb: sdb1
[    7.569009] device: 'sdb1': device_add
[    7.569128] PM: Adding info for No Bus:sdb1
[    7.570024] sd 1:0:0:0: [sdb] Attached SCSI disk
[    7.571663] Freeing unused kernel memory: 1920K
[    7.571681] Write protecting the kernel read-only data: 34816k
[    7.572123] Freeing unused kernel memory: 4K
[    7.575892] Freeing unused kernel memory: 1976K
[    7.596886] random: systemd-udevd: uninitialized urandom read (16 byte=
s read)
[    7.597154] random: systemd-udevd: uninitialized urandom read (16 byte=
s read)
[    7.597192] random: systemd-udevd: uninitialized urandom read (16 byte=
s read)
[    7.597228] random: systemd-udevd: uninitialized urandom read (16 byte=
s read)
[    7.597924] random: udevadm: uninitialized urandom read (16 bytes read=
)
[    7.598061] random: udevadm: uninitialized urandom read (16 bytes read=
)
[    7.606205] random: udevadm: uninitialized urandom read (16 bytes read=
)
[    7.606600] random: udevadm: uninitialized urandom read (16 bytes read=
)
[    7.606832] random: udevadm: uninitialized urandom read (16 bytes read=
)
[    7.607049] random: udevadm: uninitialized urandom read (16 bytes read=
)
[    7.671567] usb 3-3: New USB device found, idVendor=3D0cf2, idProduct=3D=
6230
[    7.671622] usb 3-3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D4
[    7.671673] usb 3-3: Product: UB623X      =20
[    7.671708] usb 3-3: Manufacturer: ENE Flash =20
[    7.671743] usb 3-3: SerialNumber: 606569746801
[    7.671796] device: '3-3': device_add
[    7.672027] bus: 'usb': add device 3-3
[    7.672114] PM: Adding info for usb:3-3
[    7.672516] bus: 'usb': driver_probe_device: matched device 3-3 with d=
river usb
[    7.672525] bus: 'usb': really_probe: probing driver usb with device 3=
-3
[    7.672552] devices_kset: Moving 3-3 to end of list
[    7.673103] device: '3-3:1.0': device_add
[    7.673200] bus: 'usb': add device 3-3:1.0
[    7.673278] PM: Adding info for usb:3-3:1.0
[    7.673444] device: 'ep_01': device_add
[    7.673659] PM: Adding info for No Bus:ep_01
[    7.673692] device: 'ep_82': device_add
[    7.673869] PM: Adding info for No Bus:ep_82
[    7.673878] driver: 'usb': driver_bound: bound to device '3-3'
[    7.673893] bus: 'usb': really_probe: bound device 3-3 to driver usb
[    7.673940] device: 'ep_00': device_add
[    7.674087] PM: Adding info for No Bus:ep_00
[    7.678650] bus: 'usb': add driver usb-storage
[    7.678694] bus: 'usb': driver_probe_device: matched device 3-3:1.0 wi=
th driver usb-storage
[    7.678700] bus: 'usb': really_probe: probing driver usb-storage with =
device 3-3:1.0
[    7.678726] devices_kset: Moving 3-3:1.0 to end of list
[    7.678736] usb-storage 3-3:1.0: USB Mass Storage device detected
[    7.679132] scsi host6: usb-storage 3-3:1.0
[    7.679199] device: 'host6': device_add
[    7.679225] bus: 'scsi': add device host6
[    7.679342] PM: Adding info for scsi:host6
[    7.679505] device: 'host6': device_add
[    7.679680] PM: Adding info for No Bus:host6
[    7.679730] driver: 'usb-storage': driver_bound: bound to device '3-3:=
1.0'
[    7.679778] bus: 'usb': really_probe: bound device 3-3:1.0 to driver u=
sb-storage
[    7.679842] usbcore: registered new interface driver usb-storage
[    7.752455] device class 'wmi': registering
[    7.752514] bus: 'acpi': add driver wmi
[    7.752655] bus: 'acpi': driver_probe_device: matched device PNP0C14:0=
0 with driver wmi
[    7.752665] bus: 'acpi': really_probe: probing driver wmi with device =
PNP0C14:00
[    7.752688] devices_kset: Moving PNP0C14:00 to end of list
[    7.752847] device: '97845ED0-4E6D-11DE-8A39-0800200C9A66': device_add=

[    7.752923] PM: Adding info for No Bus:97845ED0-4E6D-11DE-8A39-0800200=
C9A66
[    7.753039] device: '466747A0-70EC-11DE-8A39-0800200C9A66': device_add=

[    7.753154] PM: Adding info for No Bus:466747A0-70EC-11DE-8A39-0800200=
C9A66
[    7.753222] device: 'ABBC0F72-8EA1-11D1-00A0-C90629100000': device_add=

[    7.753333] PM: Adding info for No Bus:ABBC0F72-8EA1-11D1-00A0-C906291=
00000
[    7.753409] device: '05901221-D566-11D1-B2F0-00A0C9062910': device_add=

[    7.753504] PM: Adding info for No Bus:05901221-D566-11D1-B2F0-00A0C90=
62910
[    7.753538] driver: 'wmi': driver_bound: bound to device 'PNP0C14:00'
[    7.753553] bus: 'acpi': really_probe: bound device PNP0C14:00 to driv=
er wmi
[    7.753625] wmi: Mapper loaded
[    7.762244] bus: 'pci': add driver r8169
[    7.762313] bus: 'pci': driver_probe_device: matched device 0000:03:00=
=2E0 with driver r8169
[    7.762323] bus: 'pci': really_probe: probing driver r8169 with device=
 0000:03:00.0
[    7.762346] devices_kset: Moving 0000:03:00.0 to end of list
[    7.762353] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    7.762439] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have AS=
PM control
[    7.764014] device class 'drm': registering
[    7.776195] device: 'eth0': device_add
[    7.776760] PM: Adding info for No Bus:eth0
[    7.777584] r8169 0000:03:00.0 eth0: RTL8168g/8111g at 0xffffc900018ff=
000, e0:3f:49:44:d4:33, XID 0c000800 IRQ 30
[    7.777662] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 byte=
s, tx checksumming: ko]
[    7.777762] driver: 'r8169': driver_bound: bound to device '0000:03:00=
=2E0'
[    7.777846] bus: 'pci': really_probe: bound device 0000:03:00.0 to dri=
ver r8169
[    7.802324] usb 3-4: new full-speed USB device number 3 using xhci_hcd=

[    7.813513] bus: 'pci': add driver i915
[    7.813551] bus: 'pci': driver_probe_device: matched device 0000:00:02=
=2E0 with driver i915
[    7.813561] bus: 'pci': really_probe: probing driver i915 with device =
0000:00:02.0
[    7.813589] devices_kset: Moving 0000:00:02.0 to end of list
[    7.817228] [drm] Memory usable by graphics device =3D 2048M
[    7.817265] [drm] VT-d active for gfx access
[    7.817331] [drm] Replacing VGA console driver
[    7.817436] [drm] DMAR active, disabling use of stolen memory
[    7.824033] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013)=
=2E
[    7.824091] [drm] Driver supports precise vblank timestamp query.
[    7.828428] device: 'i2c-0': device_add
[    7.828457] bus: 'i2c': add device i2c-0
[    7.828506] PM: Adding info for i2c:i2c-0
[    7.829152] device: 'i2c-1': device_add
[    7.829175] bus: 'i2c': add device i2c-1
[    7.829221] PM: Adding info for i2c:i2c-1
[    7.829320] device: 'i2c-2': device_add
[    7.829354] bus: 'i2c': add device i2c-2
[    7.829399] PM: Adding info for i2c:i2c-2
[    7.829493] device: 'i2c-3': device_add
[    7.829515] bus: 'i2c': add device i2c-3
[    7.829570] PM: Adding info for i2c:i2c-3
[    7.829662] device: 'i2c-4': device_add
[    7.829687] bus: 'i2c': add device i2c-4
[    7.829741] PM: Adding info for i2c:i2c-4
[    7.829833] device: 'i2c-5': device_add
[    7.829856] bus: 'i2c': add device i2c-5
[    7.829910] PM: Adding info for i2c:i2c-5
[    7.831144] i915 0000:00:02.0: vgaarb: changed VGA decodes: olddecodes=
=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    7.844599] device: 'renderD128': device_add
[    7.844720] PM: Adding info for No Bus:renderD128
[    7.845098] device: 'card0': device_add
[    7.845170] PM: Adding info for No Bus:card0
[    7.845501] device: 'card0-VGA-1': device_add
[    7.845646] PM: Adding info for No Bus:card0-VGA-1
[    7.845865] device: 'card0-HDMI-A-1': device_add
[    7.845978] PM: Adding info for No Bus:card0-HDMI-A-1
[    7.846096] device: 'card0-HDMI-A-2': device_add
[    7.846205] PM: Adding info for No Bus:card0-HDMI-A-2
[    7.846422] [drm] Initialized i915 1.6.0 20170123 for 0000:00:02.0 on =
minor 0
[    7.847549] bus: 'acpi': add driver video
[    7.847628] bus: 'acpi': driver_probe_device: matched device LNXVIDEO:=
00 with driver video
[    7.847640] bus: 'acpi': really_probe: probing driver video with devic=
e LNXVIDEO:00
[    7.847658] devices_kset: Moving LNXVIDEO:00 to end of list
[    7.860883] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post:=
 no)
[    7.869247] device: 'acpi_video0': device_add
[    7.869388] PM: Adding info for No Bus:acpi_video0
[    7.869716] device: 'cooling_device13': device_add
[    7.869803] PM: Adding info for No Bus:cooling_device13
[    7.869901] acpi device:62: registered as cooling_device13
[    7.870473] device: 'input2': device_add
[    7.870657] PM: Adding info for No Bus:input2
[    7.870790] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A=
08:00/LNXVIDEO:00/input/input2
[    7.870868] device: 'event2': device_add
[    7.870970] PM: Adding info for No Bus:event2
[    7.871328] driver: 'video': driver_bound: bound to device 'LNXVIDEO:0=
0'
[    7.871379] bus: 'acpi': really_probe: bound device LNXVIDEO:00 to dri=
ver video
[    7.871594] i915 0000:00:02.0: adding component (ops i915_audio_compon=
ent_bind_ops [i915])
[    7.871623] [drm] Initialized i915 1.6.0 20170123 for 0000:00:02.0 on =
minor 0
[    7.871668] driver: 'i915': driver_bound: bound to device '0000:00:02.=
0'
[    7.871713] bus: 'pci': really_probe: bound device 0000:00:02.0 to dri=
ver i915
[    7.906449] tsc: Refined TSC clocksource calibration: 3392.145 MHz
[    7.906509] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x3=
0e55212bb0, max_idle_ns: 440795241820 ns
[    7.943516] usb 3-4: New USB device found, idVendor=3D058f, idProduct=3D=
9254
[    7.943546] usb 3-4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    7.943574] usb 3-4: Product: Generic USB Hub
[    7.943595] usb 3-4: Manufacturer: ALCOR
[    7.943620] device: '3-4': device_add
[    7.943738] bus: 'usb': add device 3-4
[    7.943787] PM: Adding info for usb:3-4
[    7.943937] bus: 'usb': driver_probe_device: matched device 3-4 with d=
river usb
[    7.943942] bus: 'usb': really_probe: probing driver usb with device 3=
-4
[    7.943959] devices_kset: Moving 3-4 to end of list
[    7.944378] device: '3-4:1.0': device_add
[    7.944432] bus: 'usb': add device 3-4:1.0
[    7.944473] PM: Adding info for usb:3-4:1.0
[    7.944574] bus: 'usb': driver_probe_device: matched device 3-4:1.0 wi=
th driver hub
[    7.944580] bus: 'usb': really_probe: probing driver hub with device 3=
-4:1.0
[    7.944598] devices_kset: Moving 3-4:1.0 to end of list
[    7.944606] hub 3-4:1.0: USB hub found
[    7.944791] hub 3-4:1.0: 4 ports detected
[    7.945042] device: '3-4-port1': device_add
[    7.945119] PM: Adding info for No Bus:3-4-port1
[    7.945202] device: '3-4-port2': device_add
[    7.945271] PM: Adding info for No Bus:3-4-port2
[    7.945333] device: '3-4-port3': device_add
[    7.945401] PM: Adding info for No Bus:3-4-port3
[    7.945462] device: '3-4-port4': device_add
[    7.945533] PM: Adding info for No Bus:3-4-port4
[    7.946077] driver: 'hub': driver_bound: bound to device '3-4:1.0'
[    7.946086] bus: 'usb': really_probe: bound device 3-4:1.0 to driver h=
ub
[    7.946108] device: 'ep_81': device_add
[    7.946199] PM: Adding info for No Bus:ep_81
[    7.946204] driver: 'usb': driver_bound: bound to device '3-4'
[    7.946209] bus: 'usb': really_probe: bound device 3-4 to driver usb
[    7.946235] device: 'ep_00': device_add
[    7.946331] PM: Adding info for No Bus:ep_00
[    7.971308] device: 'fb0': device_add
[    7.971413] PM: Adding info for No Bus:fb0
[    7.971748] fbcon: inteldrmfb (fb0) is primary device
[    7.971856] device: 'vtcon1': device_add
[    7.971955] PM: Adding info for No Bus:vtcon1
[    8.003041] Console: switching to colour frame buffer device 200x56
[    8.024060] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    8.170335] raid6: sse2x1   gen()  9686 MB/s
[    8.238339] raid6: sse2x1   xor()  7845 MB/s
[    8.242356] usb 3-4.1: new low-speed USB device number 4 using xhci_hc=
d
[    8.306333] raid6: sse2x2   gen() 12881 MB/s
[    8.356960] usb 3-4.1: New USB device found, idVendor=3D0461, idProduc=
t=3D4e04
[    8.357022] usb 3-4.1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[    8.357076] usb 3-4.1: Product: USB NETVISTA FULL WIDTH KEYBOARD
[    8.357123] usb 3-4.1: Manufacturer: NOVATEK
[    8.357165] device: '3-4.1': device_add
[    8.357271] bus: 'usb': add device 3-4.1
[    8.357317] PM: Adding info for usb:3-4.1
[    8.357483] bus: 'usb': driver_probe_device: matched device 3-4.1 with=
 driver usb
[    8.357488] bus: 'usb': really_probe: probing driver usb with device 3=
-4.1
[    8.357503] devices_kset: Moving 3-4.1 to end of list
[    8.358194] device: '3-4.1:1.0': device_add
[    8.358245] bus: 'usb': add device 3-4.1:1.0
[    8.358283] PM: Adding info for usb:3-4.1:1.0
[    8.358392] device: 'ep_81': device_add
[    8.358509] PM: Adding info for No Bus:ep_81
[    8.358518] device: '3-4.1:1.1': device_add
[    8.358574] bus: 'usb': add device 3-4.1:1.1
[    8.358610] PM: Adding info for usb:3-4.1:1.1
[    8.358680] device: 'ep_82': device_add
[    8.358770] PM: Adding info for No Bus:ep_82
[    8.358775] driver: 'usb': driver_bound: bound to device '3-4.1'
[    8.358782] bus: 'usb': really_probe: bound device 3-4.1 to driver usb=

[    8.358807] device: 'ep_00': device_add
[    8.358888] PM: Adding info for No Bus:ep_00
[    8.361872] bus: 'hid': registered
[    8.361882] device class 'hidraw': registering
[    8.361917] hidraw: raw HID events driver (C) Jiri Kosina
[    8.363350] bus: 'usb': add driver usbhid
[    8.363379] bus: 'usb': driver_probe_device: matched device 3-4.1:1.0 =
with driver usbhid
[    8.363385] bus: 'usb': really_probe: probing driver usbhid with devic=
e 3-4.1:1.0
[    8.363398] devices_kset: Moving 3-4.1:1.0 to end of list
[    8.365944] device: '0003:0461:4E04.0001': device_add
[    8.365960] bus: 'hid': add device 0003:0461:4E04.0001
[    8.366020] PM: Adding info for hid:0003:0461:4E04.0001
[    8.366090] driver: 'usbhid': driver_bound: bound to device '3-4.1:1.0=
'
[    8.366111] bus: 'usb': really_probe: bound device 3-4.1:1.0 to driver=
 usbhid
[    8.366116] bus: 'usb': driver_probe_device: matched device 3-4.1:1.1 =
with driver usbhid
[    8.366120] bus: 'usb': really_probe: probing driver usbhid with devic=
e 3-4.1:1.1
[    8.366132] devices_kset: Moving 3-4.1:1.1 to end of list
[    8.370133] device: '0003:0461:4E04.0002': device_add
[    8.370146] bus: 'hid': add device 0003:0461:4E04.0002
[    8.370201] PM: Adding info for hid:0003:0461:4E04.0002
[    8.370248] driver: 'usbhid': driver_bound: bound to device '3-4.1:1.1=
'
[    8.370264] bus: 'usb': really_probe: bound device 3-4.1:1.1 to driver=
 usbhid
[    8.370353] usbcore: registered new interface driver usbhid
[    8.370404] usbhid: USB HID core driver
[    8.371626] bus: 'hid': add driver hid-generic
[    8.371679] bus: 'hid': driver_probe_device: matched device 0003:0461:=
4E04.0001 with driver hid-generic
[    8.371688] bus: 'hid': really_probe: probing driver hid-generic with =
device 0003:0461:4E04.0001
[    8.371711] devices_kset: Moving 0003:0461:4E04.0001 to end of list
[    8.372015] device: 'input3': device_add
[    8.372159] PM: Adding info for No Bus:input3
[    8.372224] input: NOVATEK USB NETVISTA FULL WIDTH KEYBOARD as /device=
s/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1:1.0/0003:0461:4E04.0001/in=
put/input3
[    8.374331] raid6: sse2x2   xor()  8812 MB/s
[    8.434418] device: 'input3::numlock': device_add
[    8.434501] PM: Adding info for No Bus:input3::numlock
[    8.434922] device: 'input3::capslock': device_add
[    8.435041] PM: Adding info for No Bus:input3::capslock
[    8.435176] device: 'input3::scrolllock': device_add
[    8.435317] PM: Adding info for No Bus:input3::scrolllock
[    8.435478] device: 'event3': device_add
[    8.435595] PM: Adding info for No Bus:event3
[    8.435846] device: 'hidraw0': device_add
[    8.435991] PM: Adding info for No Bus:hidraw0
[    8.436295] hid-generic 0003:0461:4E04.0001: input,hidraw0: USB HID v1=
=2E10 Keyboard [NOVATEK USB NETVISTA FULL WIDTH KEYBOARD] on usb-0000:00:=
14.0-4.1/input0
[    8.436429] driver: 'hid-generic': driver_bound: bound to device '0003=
:0461:4E04.0001'
[    8.436438] bus: 'hid': really_probe: bound device 0003:0461:4E04.0001=
 to driver hid-generic
[    8.436453] bus: 'hid': driver_probe_device: matched device 0003:0461:=
4E04.0002 with driver hid-generic
[    8.436457] bus: 'hid': really_probe: probing driver hid-generic with =
device 0003:0461:4E04.0002
[    8.436469] devices_kset: Moving 0003:0461:4E04.0002 to end of list
[    8.437494] device: 'input4': device_add
[    8.437629] PM: Adding info for No Bus:input4
[    8.437686] input: NOVATEK USB NETVISTA FULL WIDTH KEYBOARD as /device=
s/pci0000:00/0000:00:14.0/usb3/3-4/3-4.1/3-4.1:1.1/0003:0461:4E04.0002/in=
put/input4
[    8.442341] raid6: sse2x4   gen() 15102 MB/s
[    8.442373] usb 3-4.4: new low-speed USB device number 5 using xhci_hc=
d
[    8.498402] device: 'event4': device_add
[    8.498468] PM: Adding info for No Bus:event4
[    8.498630] device: 'hidraw1': device_add
[    8.498760] PM: Adding info for No Bus:hidraw1
[    8.498892] hid-generic 0003:0461:4E04.0002: input,hidraw1: USB HID v1=
=2E10 Device [NOVATEK USB NETVISTA FULL WIDTH KEYBOARD] on usb-0000:00:14=
=2E0-4.1/input1
[    8.499050] driver: 'hid-generic': driver_bound: bound to device '0003=
:0461:4E04.0002'
[    8.499058] bus: 'hid': really_probe: bound device 0003:0461:4E04.0002=
 to driver hid-generic
[    8.510343] raid6: sse2x4   xor() 11433 MB/s
[    8.526795] random: fast init done
[    8.553712] usb 3-4.4: New USB device found, idVendor=3D04b3, idProduc=
t=3D310c
[    8.553768] usb 3-4.4: New USB device strings: Mfr=3D0, Product=3D2, S=
erialNumber=3D0
[    8.553823] usb 3-4.4: Product: USB Optical Mouse
[    8.553866] device: '3-4.4': device_add
[    8.553967] bus: 'usb': add device 3-4.4
[    8.554010] PM: Adding info for usb:3-4.4
[    8.554191] bus: 'usb': driver_probe_device: matched device 3-4.4 with=
 driver usb
[    8.554196] bus: 'usb': really_probe: probing driver usb with device 3=
-4.4
[    8.554211] devices_kset: Moving 3-4.4 to end of list
[    8.554845] device: '3-4.4:1.0': device_add
[    8.554896] bus: 'usb': add device 3-4.4:1.0
[    8.554934] PM: Adding info for usb:3-4.4:1.0
[    8.554996] bus: 'usb': driver_probe_device: matched device 3-4.4:1.0 =
with driver usbhid
[    8.555001] bus: 'usb': really_probe: probing driver usbhid with devic=
e 3-4.4:1.0
[    8.555022] devices_kset: Moving 3-4.4:1.0 to end of list
[    8.556512] device: '0003:04B3:310C.0003': device_add
[    8.556533] bus: 'hid': add device 0003:04B3:310C.0003
[    8.556609] PM: Adding info for hid:0003:04B3:310C.0003
[    8.556755] bus: 'hid': driver_probe_device: matched device 0003:04B3:=
310C.0003 with driver hid-generic
[    8.556763] bus: 'hid': really_probe: probing driver hid-generic with =
device 0003:04B3:310C.0003
[    8.556783] devices_kset: Moving 0003:04B3:310C.0003 to end of list
[    8.556974] device: 'input5': device_add
[    8.557200] PM: Adding info for No Bus:input5
[    8.557351] input: USB Optical Mouse as /devices/pci0000:00/0000:00:14=
=2E0/usb3/3-4/3-4.4/3-4.4:1.0/0003:04B3:310C.0003/input/input5
[    8.557502] device: 'mouse0': device_add
[    8.557602] PM: Adding info for No Bus:mouse0
[    8.557904] device: 'event5': device_add
[    8.558011] PM: Adding info for No Bus:event5
[    8.558185] device: 'hidraw2': device_add
[    8.558352] PM: Adding info for No Bus:hidraw2
[    8.558641] hid-generic 0003:04B3:310C.0003: input,hidraw2: USB HID v1=
=2E11 Mouse [USB Optical Mouse] on usb-0000:00:14.0-4.4/input0
[    8.558743] driver: 'hid-generic': driver_bound: bound to device '0003=
:04B3:310C.0003'
[    8.558751] bus: 'hid': really_probe: bound device 0003:04B3:310C.0003=
 to driver hid-generic
[    8.558769] driver: 'usbhid': driver_bound: bound to device '3-4.4:1.0=
'
[    8.558774] bus: 'usb': really_probe: bound device 3-4.4:1.0 to driver=
 usbhid
[    8.558794] device: 'ep_81': device_add
[    8.558882] PM: Adding info for No Bus:ep_81
[    8.558886] driver: 'usb': driver_bound: bound to device '3-4.4'
[    8.558891] bus: 'usb': really_probe: bound device 3-4.4 to driver usb=

[    8.558931] device: 'ep_00': device_add
[    8.559010] PM: Adding info for No Bus:ep_00
[    8.578346] raid6: avx2x1   gen() 19305 MB/s
[    8.646349] raid6: avx2x1   xor() 15002 MB/s
[    8.707795] scsi 6:0:0:0: Direct-Access     USB2.0   CardReader CF    =
0100 PQ: 0 ANSI: 0
[    8.710154] scsi 6:0:0:1: Direct-Access     USB2.0   CardReader SM XD =
0100 PQ: 0 ANSI: 0
[    8.712466] scsi 6:0:0:2: Direct-Access     USB2.0   CardReader MS    =
0100 PQ: 0 ANSI: 0
[    8.714336] raid6: avx2x2   gen() 23352 MB/s
[    8.716054] scsi 6:0:0:3: Direct-Access     USB2.0   CardReader SD    =
0100 PQ: 0 ANSI: 0
[    8.718603] device: 'target6:0:0': device_add
[    8.718618] bus: 'scsi': add device target6:0:0
[    8.718663] PM: Adding info for scsi:target6:0:0
[    8.718806] device: '6:0:0:0': device_add
[    8.718937] bus: 'scsi': add device 6:0:0:0
[    8.718982] PM: Adding info for scsi:6:0:0:0
[    8.719027] bus: 'scsi': driver_probe_device: matched device 6:0:0:0 w=
ith driver sd
[    8.719032] bus: 'scsi': really_probe: probing driver sd with device 6=
:0:0:0
[    8.719047] devices_kset: Moving 6:0:0:0 to end of list
[    8.719084] device: '6:0:0:0': device_add
[    8.719244] PM: Adding info for No Bus:6:0:0:0
[    8.719379] driver: 'sd': driver_bound: bound to device '6:0:0:0'
[    8.719389] bus: 'scsi': really_probe: bound device 6:0:0:0 to driver =
sd
[    8.719407] device: '6:0:0:0': device_add
[    8.719487] PM: Adding info for No Bus:6:0:0:0
[    8.719575] device: 'sg2': device_add
[    8.719663] PM: Adding info for No Bus:sg2
[    8.719818] device: '8:32': device_add
[    8.719854] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    8.719896] PM: Adding info for No Bus:8:32
[    8.720160] device: 'sdc': device_add
[    8.720373] PM: Adding info for No Bus:sdc
[    8.721434] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[    8.723510] device: '6:0:0:0': device_add
[    8.723588] PM: Adding info for No Bus:6:0:0:0
[    8.723801] device: '6:0:0:1': device_add
[    8.723917] bus: 'scsi': add device 6:0:0:1
[    8.723993] PM: Adding info for scsi:6:0:0:1
[    8.724025] bus: 'scsi': driver_probe_device: matched device 6:0:0:1 w=
ith driver sd
[    8.724029] bus: 'scsi': really_probe: probing driver sd with device 6=
:0:0:1
[    8.724044] devices_kset: Moving 6:0:0:1 to end of list
[    8.724079] device: '6:0:0:1': device_add
[    8.724216] PM: Adding info for No Bus:6:0:0:1
[    8.724257] driver: 'sd': driver_bound: bound to device '6:0:0:1'
[    8.724266] bus: 'scsi': really_probe: bound device 6:0:0:1 to driver =
sd
[    8.724283] device: '6:0:0:1': device_add
[    8.724381] PM: Adding info for No Bus:6:0:0:1
[    8.724453] device: 'sg3': device_add
[    8.724572] PM: Adding info for No Bus:sg3
[    8.724671] device: '8:48': device_add
[    8.724739] sd 6:0:0:1: Attached scsi generic sg3 type 0
[    8.724761] PM: Adding info for No Bus:8:48
[    8.724818] device: 'sdd': device_add
[    8.724928] PM: Adding info for No Bus:sdd
[    8.725537] sd 6:0:0:1: [sdd] Attached SCSI removable disk
[    8.730771] device: '6:0:0:1': device_add
[    8.730913] PM: Adding info for No Bus:6:0:0:1
[    8.731115] device: '6:0:0:2': device_add
[    8.731341] bus: 'scsi': add device 6:0:0:2
[    8.731434] PM: Adding info for scsi:6:0:0:2
[    8.731491] bus: 'scsi': driver_probe_device: matched device 6:0:0:2 w=
ith driver sd
[    8.731499] bus: 'scsi': really_probe: probing driver sd with device 6=
:0:0:2
[    8.731526] devices_kset: Moving 6:0:0:2 to end of list
[    8.731595] device: '6:0:0:2': device_add
[    8.731836] PM: Adding info for No Bus:6:0:0:2
[    8.731934] driver: 'sd': driver_bound: bound to device '6:0:0:2'
[    8.731951] bus: 'scsi': really_probe: bound device 6:0:0:2 to driver =
sd
[    8.731982] device: '6:0:0:2': device_add
[    8.732139] PM: Adding info for No Bus:6:0:0:2
[    8.732286] device: 'sg4': device_add
[    8.732315] device: '8:64': device_add
[    8.732401] PM: Adding info for No Bus:8:64
[    8.732437] PM: Adding info for No Bus:sg4
[    8.732494] device: 'sde': device_add
[    8.732622] sd 6:0:0:2: Attached scsi generic sg4 type 0
[    8.732747] PM: Adding info for No Bus:sde
[    8.734617] device: '6:0:0:2': device_add
[    8.734701] PM: Adding info for No Bus:6:0:0:2
[    8.734924] device: '6:0:0:3': device_add
[    8.735090] bus: 'scsi': add device 6:0:0:3
[    8.735139] PM: Adding info for scsi:6:0:0:3
[    8.735179] bus: 'scsi': driver_probe_device: matched device 6:0:0:3 w=
ith driver sd
[    8.735187] bus: 'scsi': really_probe: probing driver sd with device 6=
:0:0:3
[    8.735229] devices_kset: Moving 6:0:0:3 to end of list
[    8.735297] device: '6:0:0:3': device_add
[    8.735526] PM: Adding info for No Bus:6:0:0:3
[    8.735589] driver: 'sd': driver_bound: bound to device '6:0:0:3'
[    8.735605] bus: 'scsi': really_probe: bound device 6:0:0:3 to driver =
sd
[    8.735637] device: '6:0:0:3': device_add
[    8.735744] PM: Adding info for No Bus:6:0:0:3
[    8.735863] device: 'sg5': device_add
[    8.736037] PM: Adding info for No Bus:sg5
[    8.736064] device: '8:80': device_add
[    8.736173] sd 6:0:0:3: Attached scsi generic sg5 type 0
[    8.736179] PM: Adding info for No Bus:8:80
[    8.736291] device: 'sdf': device_add
[    8.736466] PM: Adding info for No Bus:sdf
[    8.737506] sd 6:0:0:2: [sde] Attached SCSI removable disk
[    8.739133] sd 6:0:0:3: [sdf] Attached SCSI removable disk
[    8.744438] device: '6:0:0:3': device_add
[    8.744556] PM: Adding info for No Bus:6:0:0:3
[    8.782356] raid6: avx2x2   xor() 14032 MB/s
[    8.850360] raid6: avx2x4   gen() 27609 MB/s
[    8.918362] raid6: avx2x4   xor() 20921 MB/s
[    8.919826] raid6: using algorithm avx2x4 gen() 27609 MB/s
[    8.921276] raid6: .... xor() 20921 MB/s, rmw enabled
[    8.922777] raid6: using avx2x2 recovery algorithm
[    8.924981] xor: automatically using best checksumming function   avx =
     =20
[    8.931220] clocksource: Switched to clocksource tsc
[    8.947831] device: 'btrfs-control': device_add
[    8.947895] PM: Adding info for No Bus:btrfs-control
[    8.948132] Btrfs loaded, crc32c=3Dcrc32c-intel
[    9.076417] EXT4-fs (sda1): mounted filesystem with ordered data mode.=
 Opts: (null)
[    9.475118] device: 'autofs': device_add
[    9.475172] PM: Adding info for No Bus:autofs
[    9.483635] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.494586] systemd[1]: systemd 232 running in system mode. (+PAM +AUD=
IT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT =
+GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    9.498225] systemd[1]: Detected architecture x86-64.
[    9.516903] systemd[1]: Set hostname to <mazurka>.
[    9.643646] systemd[1]: Listening on Journal Socket.
[    9.650547] systemd[1]: Created slice System Slice.
[    9.657976] systemd[1]: Mounting POSIX Message Queue File System...
[    9.665648] systemd[1]: Started Read required files in advance.
[    9.673161] systemd[1]: Reached target Remote File Systems.
[    9.687468] systemd[1]: Listening on udev Control Socket.
[    9.694089] systemd[1]: Listening on Journal Audit Socket.
[    9.726892] bus: 'parport': registered
[    9.730333] device class 'printer': registering
[    9.733298] lp: driver loaded but no devices found
[    9.738108] device class 'ppdev': registering
[    9.739682] bus: 'parport': add driver ppdev
[    9.739796] ppdev: user-space parallel port driver
[    9.743700] bus: 'platform': add driver parport_pc
[    9.743845] bus: 'pnp': add driver parport_pc
[    9.743937] Registering platform device 'parport_pc.956'. Parent at pl=
atform
[    9.743945] device: 'parport_pc.956': device_add
[    9.743965] bus: 'platform': add device parport_pc.956
[    9.744050] PM: Adding info for platform:parport_pc.956
[    9.744111] bus: 'platform': driver_probe_device: matched device parpo=
rt_pc.956 with driver parport_pc
[    9.744117] bus: 'platform': really_probe: probing driver parport_pc w=
ith device parport_pc.956
[    9.744138] devices_kset: Moving parport_pc.956 to end of list
[    9.744142] driver: 'parport_pc': driver_bound: bound to device 'parpo=
rt_pc.956'
[    9.744301] bus: 'platform': really_probe: bound device parport_pc.956=
 to driver parport_pc
[    9.744417] device: 'parport0': device_add
[    9.744436] bus: 'parport': add device parport0
[    9.744510] PM: Adding info for parport:parport0
[    9.744550] bus: 'parport': driver_probe_device: matched device parpor=
t0 with driver ppdev
[    9.744555] bus: 'parport': really_probe: probing driver ppdev with de=
vice parport0
[    9.744579] devices_kset: Moving parport0 to end of list
[    9.744642] ppdev: probe of parport0 rejects match -19
[    9.744720] device: 'parport0': device_unregister
[    9.744957] bus: 'parport': remove device parport0
[    9.744960] PM: Removing info for parport:parport0
[    9.745196] bus: 'platform': remove device parport_pc.956
[    9.745255] PM: Removing info for platform:parport_pc.956
[    9.745327] Registering platform device 'parport_pc.888'. Parent at pl=
atform
[    9.745335] device: 'parport_pc.888': device_add
[    9.745354] bus: 'platform': add device parport_pc.888
[    9.745439] PM: Adding info for platform:parport_pc.888
[    9.745488] bus: 'platform': driver_probe_device: matched device parpo=
rt_pc.888 with driver parport_pc
[    9.745493] bus: 'platform': really_probe: probing driver parport_pc w=
ith device parport_pc.888
[    9.745513] devices_kset: Moving parport_pc.888 to end of list
[    9.745516] driver: 'parport_pc': driver_bound: bound to device 'parpo=
rt_pc.888'
[    9.745528] bus: 'platform': really_probe: bound device parport_pc.888=
 to driver parport_pc
[    9.745583] device: 'parport0': device_add
[    9.745602] bus: 'parport': add device parport0
[    9.745674] PM: Adding info for parport:parport0
[    9.745713] bus: 'parport': driver_probe_device: matched device parpor=
t0 with driver ppdev
[    9.745717] bus: 'parport': really_probe: probing driver ppdev with de=
vice parport0
[    9.745737] devices_kset: Moving parport0 to end of list
[    9.745760] ppdev: probe of parport0 rejects match -19
[    9.745826] device: 'parport0': device_unregister
[    9.745924] bus: 'parport': remove device parport0
[    9.745927] PM: Removing info for parport:parport0
[    9.746108] bus: 'platform': remove device parport_pc.888
[    9.746134] PM: Removing info for platform:parport_pc.888
[    9.746206] Registering platform device 'parport_pc.632'. Parent at pl=
atform
[    9.746213] device: 'parport_pc.632': device_add
[    9.746230] bus: 'platform': add device parport_pc.632
[    9.746311] PM: Adding info for platform:parport_pc.632
[    9.746357] bus: 'platform': driver_probe_device: matched device parpo=
rt_pc.632 with driver parport_pc
[    9.746362] bus: 'platform': really_probe: probing driver parport_pc w=
ith device parport_pc.632
[    9.746398] devices_kset: Moving parport_pc.632 to end of list
[    9.746401] driver: 'parport_pc': driver_bound: bound to device 'parpo=
rt_pc.632'
[    9.746411] bus: 'platform': really_probe: bound device parport_pc.632=
 to driver parport_pc
[    9.746466] device: 'parport0': device_add
[    9.746484] bus: 'parport': add device parport0
[    9.746557] PM: Adding info for parport:parport0
[    9.746598] bus: 'parport': driver_probe_device: matched device parpor=
t0 with driver ppdev
[    9.746602] bus: 'parport': really_probe: probing driver ppdev with de=
vice parport0
[    9.746621] devices_kset: Moving parport0 to end of list
[    9.746643] ppdev: probe of parport0 rejects match -19
[    9.746711] device: 'parport0': device_unregister
[    9.746809] bus: 'parport': remove device parport0
[    9.746811] PM: Removing info for parport:parport0
[    9.746983] bus: 'platform': remove device parport_pc.632
[    9.747008] PM: Removing info for platform:parport_pc.632
[    9.747067] bus: 'pci': add driver parport_pc
[    9.903899] device: 'vcs2': device_add
[    9.903976] PM: Adding info for No Bus:vcs2
[    9.904220] device: 'vcsa2': device_add
[    9.904272] PM: Adding info for No Bus:vcsa2
[    9.905516] device: 'vcs3': device_add
[    9.905568] PM: Adding info for No Bus:vcs3
[    9.905717] device: 'vcsa3': device_add
[    9.905767] PM: Adding info for No Bus:vcsa3
[    9.907050] device: 'vcs4': device_add
[    9.907102] PM: Adding info for No Bus:vcs4
[    9.907248] device: 'vcsa4': device_add
[    9.907297] PM: Adding info for No Bus:vcsa4
[    9.908575] device: 'vcs5': device_add
[    9.908627] PM: Adding info for No Bus:vcs5
[    9.908772] device: 'vcsa5': device_add
[    9.908820] PM: Adding info for No Bus:vcsa5
[    9.910144] device: 'vcs6': device_add
[    9.910202] PM: Adding info for No Bus:vcs6
[    9.910309] device: 'vcsa6': device_add
[    9.910361] PM: Adding info for No Bus:vcsa6
[    9.977979] EXT4-fs (sda1): re-mounted. Opts: errors=3Dremount-ro
[   10.024039] systemd-journald[333]: Received request to flush runtime j=
ournal from PID 1
[   10.472584] bus: 'platform': add driver tpm_tis
[   10.472712] bus: 'acpi': add driver tpm_tis
[   10.472898] bus: 'pnp': add driver tpm_tis
[   10.572432] bus: 'pci': add driver lpc_ich
[   10.572493] bus: 'pci': driver_probe_device: matched device 0000:00:1f=
=2E0 with driver lpc_ich
[   10.572503] bus: 'pci': really_probe: probing driver lpc_ich with devi=
ce 0000:00:1f.0
[   10.572529] devices_kset: Moving 0000:00:1f.0 to end of list
[   10.572606] Registering platform device 'iTCO_wdt.0.auto'. Parent at 0=
000:00:1f.0
[   10.572619] device: 'iTCO_wdt.0.auto': device_add
[   10.572678] bus: 'platform': add device iTCO_wdt.0.auto
[   10.572779] PM: Adding info for platform:iTCO_wdt.0.auto
[   10.572869] ACPI Warning: SystemIO range 0x0000000000001828-0x00000000=
0000182F conflicts with OpRegion 0x0000000000001800-0x000000000000187F (\=
PMIO) (20170119/utaddress-247)
[   10.572889] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   10.572904] ACPI Warning: SystemIO range 0x0000000000001C40-0x00000000=
00001C4F conflicts with OpRegion 0x0000000000001C00-0x0000000000001FFF (\=
GPR) (20170119/utaddress-247)
[   10.572922] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   10.572933] ACPI Warning: SystemIO range 0x0000000000001C30-0x00000000=
00001C3F conflicts with OpRegion 0x0000000000001C00-0x0000000000001C3F (\=
GPRL) (20170119/utaddress-247)
[   10.572958] ACPI Warning: SystemIO range 0x0000000000001C30-0x00000000=
00001C3F conflicts with OpRegion 0x0000000000001C00-0x0000000000001FFF (\=
GPR) (20170119/utaddress-247)
[   10.572975] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   10.572987] ACPI Warning: SystemIO range 0x0000000000001C00-0x00000000=
00001C2F conflicts with OpRegion 0x0000000000001C00-0x0000000000001C3F (\=
GPRL) (20170119/utaddress-247)
[   10.573007] ACPI Warning: SystemIO range 0x0000000000001C00-0x00000000=
00001C2F conflicts with OpRegion 0x0000000000001C00-0x0000000000001FFF (\=
GPR) (20170119/utaddress-247)
[   10.573022] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[   10.573026] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   10.573253] Registering platform device 'intel-spi'. Parent at 0000:00=
:1f.0
[   10.573264] device: 'intel-spi': device_add
[   10.573318] bus: 'platform': add device intel-spi
[   10.573427] PM: Adding info for platform:intel-spi
[   10.573499] driver: 'lpc_ich': driver_bound: bound to device '0000:00:=
1f.0'
[   10.579994] device: 'timer': device_add
[   10.580168] PM: Adding info for No Bus:timer
[   10.581226] bus: 'pci': really_probe: bound device 0000:00:1f.0 to dri=
ver lpc_ich
[   10.615684] bus: 'hdaudio': registered
[   10.645687] bus: 'pci': add driver snd_hda_intel
[   10.645729] bus: 'pci': driver_probe_device: matched device 0000:00:03=
=2E0 with driver snd_hda_intel
[   10.645739] bus: 'pci': really_probe: probing driver snd_hda_intel wit=
h device 0000:00:03.0
[   10.645766] devices_kset: Moving 0000:00:03.0 to end of list
[   10.648247] driver: 'snd_hda_intel': driver_bound: bound to device '00=
00:00:03.0'
[   10.648340] snd_hda_intel 0000:00:03.0: trying to bring up master
[   10.648349] snd_hda_intel 0000:00:03.0: Looking for component 0
[   10.648353] snd_hda_intel 0000:00:03.0: found component 0000:00:02.0, =
duplicate 0
[   10.648407] snd_hda_intel 0000:00:03.0: binding 0000:00:02.0 (ops i915=
_audio_component_bind_ops [i915])
[   10.648495] snd_hda_intel 0000:00:03.0: bound 0000:00:02.0 (ops i915_a=
udio_component_bind_ops [i915])
[   10.650631] bus: 'pci': really_probe: bound device 0000:00:03.0 to dri=
ver snd_hda_intel
[   10.650649] bus: 'pci': driver_probe_device: matched device 0000:00:1b=
=2E0 with driver snd_hda_intel
[   10.650657] bus: 'pci': really_probe: probing driver snd_hda_intel wit=
h device 0000:00:1b.0
[   10.650688] devices_kset: Moving 0000:00:1b.0 to end of list
[   10.652844] driver: 'snd_hda_intel': driver_bound: bound to device '00=
00:00:1b.0'
[   10.658097] bus: 'pci': really_probe: bound device 0000:00:1b.0 to dri=
ver snd_hda_intel
[   10.663138] device: 'hdaudioC1D0': device_add
[   10.663305] bus: 'hdaudio': add device hdaudioC1D0
[   10.663424] PM: Adding info for hdaudio:hdaudioC1D0
[   10.682534] bus: 'hdaudio': add driver snd_hda_codec_generic
[   10.683584] device: 'hdaudioC0D0': device_add
[   10.683747] bus: 'hdaudio': add device hdaudioC0D0
[   10.683844] PM: Adding info for hdaudio:hdaudioC0D0
[   10.687138] bus: 'hdaudio': add driver snd_hda_codec_realtek
[   10.687171] bus: 'hdaudio': driver_probe_device: matched device hdaudi=
oC1D0 with driver snd_hda_codec_realtek
[   10.687181] bus: 'hdaudio': really_probe: probing driver snd_hda_codec=
_realtek with device hdaudioC1D0
[   10.687205] devices_kset: Moving hdaudioC1D0 to end of list
[   10.688432] snd_hda_codec_realtek hdaudioC1D0: autoconfig for ALC887-V=
D: line_outs=3D1 (0x14/0x0/0x0/0x0/0x0) type:line
[   10.688439] snd_hda_codec_realtek hdaudioC1D0:    speaker_outs=3D0 (0x=
0/0x0/0x0/0x0/0x0)
[   10.688445] snd_hda_codec_realtek hdaudioC1D0:    hp_outs=3D1 (0x1b/0x=
0/0x0/0x0/0x0)
[   10.688450] snd_hda_codec_realtek hdaudioC1D0:    mono: mono_out=3D0x0=

[   10.688455] snd_hda_codec_realtek hdaudioC1D0:    dig-out=3D0x11/0x0
[   10.688460] snd_hda_codec_realtek hdaudioC1D0:    inputs:
[   10.688468] snd_hda_codec_realtek hdaudioC1D0:      Front Mic=3D0x19
[   10.688476] snd_hda_codec_realtek hdaudioC1D0:      Rear Mic=3D0x18
[   10.688481] snd_hda_codec_realtek hdaudioC1D0:      Line=3D0x1a
[   10.691449] bus: 'hdaudio': add driver snd_hda_codec_hdmi
[   10.691480] bus: 'hdaudio': driver_probe_device: matched device hdaudi=
oC0D0 with driver snd_hda_codec_hdmi
[   10.691489] bus: 'hdaudio': really_probe: probing driver snd_hda_codec=
_hdmi with device hdaudioC0D0
[   10.691511] devices_kset: Moving hdaudioC0D0 to end of list
[   10.696715] driver: 'snd_hda_codec_hdmi': driver_bound: bound to devic=
e 'hdaudioC0D0'
[   10.696734] bus: 'hdaudio': really_probe: bound device hdaudioC0D0 to =
driver snd_hda_codec_hdmi
[   10.697424] device: 'card0': device_add
[   10.697634] PM: Adding info for No Bus:card0
[   10.697728] device: 'controlC0': device_add
[   10.697874] PM: Adding info for No Bus:controlC0
[   10.699049] device: 'pcmC0D3p': device_add
[   10.699235] PM: Adding info for No Bus:pcmC0D3p
[   10.699740] device: 'pcmC0D7p': device_add
[   10.700178] PM: Adding info for No Bus:pcmC0D7p
[   10.700393] device: 'pcmC0D8p': device_add
[   10.700546] PM: Adding info for No Bus:pcmC0D8p
[   10.700817] device: 'hwC0D0': device_add
[   10.701272] PM: Adding info for No Bus:hwC0D0
[   10.701687] device: 'input6': device_add
[   10.701999] PM: Adding info for No Bus:input6
[   10.702098] input: HDA Intel HDMI HDMI/DP,pcm=3D3 as /devices/pci0000:=
00/0000:00:03.0/sound/card0/input6
[   10.702182] device: 'event6': device_add
[   10.702347] PM: Adding info for No Bus:event6
[   10.702770] device: 'input7': device_add
[   10.703035] PM: Adding info for No Bus:input7
[   10.703108] input: HDA Intel HDMI HDMI/DP,pcm=3D7 as /devices/pci0000:=
00/0000:00:03.0/sound/card0/input7
[   10.703156] device: 'event7': device_add
[   10.703291] PM: Adding info for No Bus:event7
[   10.703481] device: 'input8': device_add
[   10.703776] PM: Adding info for No Bus:input8
[   10.703850] input: HDA Intel HDMI HDMI/DP,pcm=3D8 as /devices/pci0000:=
00/0000:00:03.0/sound/card0/input8
[   10.703897] device: 'event8': device_add
[   10.704034] PM: Adding info for No Bus:event8
[   10.709831] driver: 'snd_hda_codec_realtek': driver_bound: bound to de=
vice 'hdaudioC1D0'
[   10.709855] bus: 'hdaudio': really_probe: bound device hdaudioC1D0 to =
driver snd_hda_codec_realtek
[   10.710587] device: 'card1': device_add
[   10.710751] PM: Adding info for No Bus:card1
[   10.710794] device: 'controlC1': device_add
[   10.710866] PM: Adding info for No Bus:controlC1
[   10.711003] device: 'pcmC1D0p': device_add
[   10.711088] PM: Adding info for No Bus:pcmC1D0p
[   10.711794] device: 'pcmC1D0c': device_add
[   10.711878] PM: Adding info for No Bus:pcmC1D0c
[   10.712015] device: 'pcmC1D1p': device_add
[   10.712095] PM: Adding info for No Bus:pcmC1D1p
[   10.712260] device: 'pcmC1D2c': device_add
[   10.712372] PM: Adding info for No Bus:pcmC1D2c
[   10.713893] device: 'hwC1D0': device_add
[   10.714253] PM: Adding info for No Bus:hwC1D0
[   10.714443] device: 'input9': device_add
[   10.714718] PM: Adding info for No Bus:input9
[   10.714792] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000=
:00:1b.0/sound/card1/input9
[   10.714842] device: 'event9': device_add
[   10.714983] PM: Adding info for No Bus:event9
[   10.715170] device: 'input10': device_add
[   10.715435] PM: Adding info for No Bus:input10
[   10.715509] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:=
00:1b.0/sound/card1/input10
[   10.715558] device: 'event10': device_add
[   10.715726] PM: Adding info for No Bus:event10
[   10.715857] device: 'input11': device_add
[   10.716050] PM: Adding info for No Bus:input11
[   10.716090] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1=
b.0/sound/card1/input11
[   10.716116] device: 'event11': device_add
[   10.716185] PM: Adding info for No Bus:event11
[   10.716387] device: 'input12': device_add
[   10.716661] PM: Adding info for No Bus:input12
[   10.716735] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:=
00:1b.0/sound/card1/input12
[   10.716782] device: 'event12': device_add
[   10.716922] PM: Adding info for No Bus:event12
[   10.717111] device: 'input13': device_add
[   10.717299] PM: Adding info for No Bus:input13
[   10.717339] input: HDA Intel PCH Front Headphone as /devices/pci0000:0=
0/0000:00:1b.0/sound/card1/input13
[   10.717364] device: 'event13': device_add
[   10.717441] PM: Adding info for No Bus:event13
[   10.746810] AVX2 version of gcm_enc/dec engaged.
[   10.746816] AES CTR mode by8 optimization enabled
[   10.860297] device: 'kvm': device_add
[   10.860420] PM: Adding info for No Bus:kvm
[   10.870662] bus: 'platform': add driver coretemp
[   10.870834] Registering platform device 'coretemp.0'. Parent at platfo=
rm
[   10.870846] device: 'coretemp.0': device_add
[   10.870873] bus: 'platform': add device coretemp.0
[   10.870974] PM: Adding info for platform:coretemp.0
[   10.871042] bus: 'platform': driver_probe_device: matched device coret=
emp.0 with driver coretemp
[   10.871050] bus: 'platform': really_probe: probing driver coretemp wit=
h device coretemp.0
[   10.871074] devices_kset: Moving coretemp.0 to end of list
[   10.871115] device: 'hwmon1': device_add
[   10.871344] PM: Adding info for No Bus:hwmon1
[   10.871509] driver: 'coretemp': driver_bound: bound to device 'coretem=
p.0'
[   10.871526] bus: 'platform': really_probe: bound device coretemp.0 to =
driver coretemp
[   10.892541] device: 'thermal_zone2': device_add
[   10.892760] PM: Adding info for No Bus:thermal_zone2
[   11.019497] Adding 4194300k swap on /dev/sda2.  Priority:-1 extents:1 =
across:4194300k SSFS
[   11.420662] EXT4-fs (sdb1): mounted filesystem with ordered data mode.=
 Opts: errors=3Dremount-ro
[   11.612558] audit: type=3D1400 audit(1494865691.842:2): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"content-hub-clipboard" pid=3D909=
 comm=3D"apparmor_parser"
[   11.612678] audit: type=3D1400 audit(1494865691.842:3): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"content-hub-peer-picker" pid=3D9=
10 comm=3D"apparmor_parser"
[   11.612857] audit: type=3D1400 audit(1494865691.842:4): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"url-dispatcher-bad-url-helper" p=
id=3D915 comm=3D"apparmor_parser"
[   11.617871] audit: type=3D1400 audit(1494865691.846:5): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"ubuntu-printing-app" pid=3D919 c=
omm=3D"apparmor_parser"
[   11.618798] audit: type=3D1400 audit(1494865691.850:6): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/sbin/dhclient" pid=3D914 comm=3D=
"apparmor_parser"
[   11.618811] audit: type=3D1400 audit(1494865691.850:7): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/lib/NetworkManager/nm-dhcp-=
client.action" pid=3D914 comm=3D"apparmor_parser"
[   11.618823] audit: type=3D1400 audit(1494865691.850:8): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/lib/NetworkManager/nm-dhcp-=
helper" pid=3D914 comm=3D"apparmor_parser"
[   11.618833] audit: type=3D1400 audit(1494865691.850:9): apparmor=3D"ST=
ATUS" operation=3D"profile_load" name=3D"/usr/lib/connman/scripts/dhclien=
t-script" pid=3D914 comm=3D"apparmor_parser"
[   11.618987] audit: type=3D1400 audit(1494865691.850:10): apparmor=3D"S=
TATUS" operation=3D"profile_load" name=3D"/usr/lib/x86_64-linux-gnu/light=
dm-remote-session-freerdp/freerdp-session-wrapper" pid=3D912 comm=3D"appa=
rmor_parser"
[   11.705151] __allocate_fw_buf: fw-rtl_nic/rtl8168g-2.fw buf=3Dffff8803=
47042400
[   11.706944] r8169 0000:03:00.0: loading /lib/firmware/updates/4.11.1-r=
c1+/rtl_nic/rtl8168g-2.fw failed with error -2
[   11.706964] r8169 0000:03:00.0: loading /lib/firmware/updates/rtl_nic/=
rtl8168g-2.fw failed with error -2
[   11.707251] r8169 0000:03:00.0: loading /lib/firmware/4.11.1-rc1+/rtl_=
nic/rtl8168g-2.fw failed with error -2
[   11.709087] r8169 0000:03:00.0: direct-loading rtl_nic/rtl8168g-2.fw
[   11.709132] fw_set_page_data: fw-rtl_nic/rtl8168g-2.fw buf=3Dffff88034=
7042400 data=3Dffffc90002a94000 size=3D4896
[   11.753065] r8169 0000:03:00.0 eth0: link down
[   11.753132] r8169 0000:03:00.0 eth0: link down
[   11.753160] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   12.472724] device: 'lo': device_add
[   12.472926] PM: Adding info for No Bus:lo
[   12.565486] random: crng init done
[   14.571022] r8169 0000:03:00.0 eth0: link up
[   14.571053] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   22.522949] device: 'vcs7': device_add
[   22.523052] PM: Adding info for No Bus:vcs7
[   22.523558] device: 'vcsa7': device_add
[   22.523655] PM: Adding info for No Bus:vcsa7
[   24.058237] device: '0:41': device_add
[   24.058402] PM: Adding info for No Bus:0:41
[   24.587650] device: 'lo': device_add
[   24.587850] PM: Adding info for No Bus:lo
[   29.766466] TCP: request_sock_TCP: Possible SYN flooding on port 53255=
=2E Sending cookies.  Check SNMP counters.
[   42.694075] PM: Removing info for No Bus:lo

--------------B03647AB76172C3E8BD88FB9
Content-Type: text/plain; charset=UTF-8;
 name="dmidecode.out"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmidecode.out"

# dmidecode 2.12
SMBIOS 2.7 present.
79 structures occupying 3055 bytes.
Table at 0x000EB920.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 0705
	Release Date: 12/05/2013
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 8192 kB
	Characteristics:
		PCI is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
		UEFI is supported
	BIOS Revision: 4.6

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: System76, Inc.
	Product Name: Wild Dog Performance
	Version: wilp10
	Serial Number: System Serial Number
	UUID: 21FD6EE0-D7DA-11DD-8AA1-E03F4944D433
	Wake-up Type: Power Switch
	SKU Number: All
	Family: ASUS MB

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASUSTeK COMPUTER INC.
	Product Name: H87-PLUS
	Version: Rev X.0x
	Serial Number: 131219712501681
	Asset Tag: To be filled by O.E.M.
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: To be filled by O.E.M.
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 22 bytes
Chassis Information
	Manufacturer: System76, Inc.
	Type: Desktop
	Lock: Not Present
	Version: Desktop
	Serial Number: wilp10
	Asset Tag: Asset-1234567890
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0
	SKU Number: To be filled by O.E.M.

Handle 0x0004, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2 Keyboard
	Internal Connector Type: None
	External Reference Designator: PS/2 Keyboard
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0005, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB3_4
	Internal Connector Type: None
	External Reference Designator: USB3_4
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0006, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB3_56
	Internal Connector Type: None
	External Reference Designator: USB3_56
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0007, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: GbE LAN
	Internal Connector Type: None
	External Reference Designator: GbE LAN
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: AUDIO
	Internal Connector Type: None
	External Reference Designator: AUDIO
	External Connector Type: Other
	Port Type: Audio Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: DVI
	Internal Connector Type: None
	External Reference Designator: DVI port
	External Connector Type: Other
	Port Type: Other

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SPDIFO_HDMI
	Internal Connector Type: None
	External Reference Designator: HDMI port
	External Connector Type: Other
	Port Type: Other

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_1
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_2
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_3
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_4
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_5
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6G_6
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB3_12
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB7_8
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB9_10
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB11_12
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB13_14
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: AAFP
	Internal Connector Type: Mini Jack (headphones)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CPU_FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CHA_FAN1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CHA_FAN2
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: DB-9 male
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Serial Port 16550A Compatible

Handle 0x001B, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIEX16_1
	Type: x16 PCI Express
	Current Usage: Available
	Length: Long
	ID: 1
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:01:00.0

Handle 0x001C, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIEX1_1
	Type: x1 PCI Express
	Current Usage: In Use
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:02:00.0

Handle 0x001D, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIEX1_2
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 3
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:ff:00.0

Handle 0x001E, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIEX16_2
	Type: x16 PCI Express
	Current Usage: Available
	Length: Long
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:ff:00.0

Handle 0x001F, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 5
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:05:1c.7

Handle 0x0020, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 6
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:05:1d.0

Handle 0x0021, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI3
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 7
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported
	Bus Address: 0000:05:1d.1

Handle 0x0022, DMI type 10, 8 bytes
On Board Device 1 Information
	Type: Ethernet
	Status: Enabled
	Description: Onboard Ethernet
On Board Device 2 Information
	Type: Sound
	Status: Enabled
	Description: Onboard Audio

Handle 0x0023, DMI type 11, 5 bytes
OEM Strings
	String 1: To Be Filled By O.E.M.
	String 2: To Be Filled By O.E.M.
	String 3: Amber
	String 4: To Be Filled By O.E.M.

Handle 0x0024, DMI type 12, 5 bytes
System Configuration Options
	Option 1: To Be Filled By O.E.M.

Handle 0x0025, DMI type 24, 5 bytes
Hardware Security
	Power-On Password Status: Disabled
	Keyboard Password Status: Disabled
	Administrator Password Status: Disabled
	Front Panel Reset Status: Disabled

Handle 0x0026, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0027, DMI type 34, 11 bytes
Management Device
	Description: Nuvoton NCT6791D
	Type: Other
	Address: 0x00000295
	Address Type: I/O Port

Handle 0x0028, DMI type 26, 22 bytes
Voltage Probe
	Description: LM78A
	Location: <OUT OF SPEC>
	Status: <OUT OF SPEC>
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x0029, DMI type 36, 16 bytes
Management Device Threshold Data
	Lower Non-critical Threshold: 1
	Upper Non-critical Threshold: 2
	Lower Critical Threshold: 3
	Upper Critical Threshold: 4
	Lower Non-recoverable Threshold: 5
	Upper Non-recoverable Threshold: 6

Handle 0x002A, DMI type 35, 11 bytes
Management Device Component
	Description: To Be Filled By O.E.M.
	Management Device Handle: 0x0027
	Component Handle: 0x0027
	Threshold Handle: 0x0028

Handle 0x002B, DMI type 28, 22 bytes
Temperature Probe
	Description: LM78A
	Location: <OUT OF SPEC>
	Status: <OUT OF SPEC>
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x002C, DMI type 36, 16 bytes
Management Device Threshold Data
	Lower Non-critical Threshold: 1
	Upper Non-critical Threshold: 2
	Lower Critical Threshold: 3
	Upper Critical Threshold: 4
	Lower Non-recoverable Threshold: 5
	Upper Non-recoverable Threshold: 6

Handle 0x002D, DMI type 35, 11 bytes
Management Device Component
	Description: To Be Filled By O.E.M.
	Management Device Handle: 0x0027
	Component Handle: 0x002A
	Threshold Handle: 0x002B

Handle 0x002E, DMI type 27, 15 bytes
Cooling Device
	Temperature Probe Handle: 0x002B
	Type: <OUT OF SPEC>
	Status: <OUT OF SPEC>
	Cooling Unit Group: 1
	OEM-specific Information: 0x00000000
	Nominal Speed: Unknown Or Non-rotating
	Description: Cooling Dev 1

Handle 0x002F, DMI type 36, 16 bytes
Management Device Threshold Data
	Lower Non-critical Threshold: 1
	Upper Non-critical Threshold: 2
	Lower Critical Threshold: 3
	Upper Critical Threshold: 4
	Lower Non-recoverable Threshold: 5
	Upper Non-recoverable Threshold: 6

Handle 0x0030, DMI type 35, 11 bytes
Management Device Component
	Description: To Be Filled By O.E.M.
	Management Device Handle: 0x0027
	Component Handle: 0x002D
	Threshold Handle: 0x002E

Handle 0x0031, DMI type 27, 15 bytes
Cooling Device
	Temperature Probe Handle: 0x002B
	Type: <OUT OF SPEC>
	Status: <OUT OF SPEC>
	Cooling Unit Group: 1
	OEM-specific Information: 0x00000000
	Nominal Speed: Unknown Or Non-rotating
	Description: Not Specified

Handle 0x0032, DMI type 36, 16 bytes
Management Device Threshold Data
	Lower Non-critical Threshold: 1
	Upper Non-critical Threshold: 2
	Lower Critical Threshold: 3
	Upper Critical Threshold: 4
	Lower Non-recoverable Threshold: 5
	Upper Non-recoverable Threshold: 6

Handle 0x0033, DMI type 35, 11 bytes
Management Device Component
	Description: To Be Filled By O.E.M.
	Management Device Handle: 0x0027
	Component Handle: 0x0030
	Threshold Handle: 0x0031

Handle 0x0034, DMI type 29, 22 bytes
Electrical Current Probe
	Description: ABC
	Location: <OUT OF SPEC>
	Status: <OUT OF SPEC>
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x0035, DMI type 36, 16 bytes
Management Device Threshold Data

Handle 0x0036, DMI type 35, 11 bytes
Management Device Component
	Description: To Be Filled By O.E.M.
	Management Device Handle: 0x0027
	Component Handle: 0x0033
	Threshold Handle: 0x0031

Handle 0x0037, DMI type 26, 22 bytes
Voltage Probe
	Description: LM78A
	Location: Power Unit
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x0038, DMI type 28, 22 bytes
Temperature Probe
	Description: LM78A
	Location: Power Unit
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x0039, DMI type 27, 15 bytes
Cooling Device
	Temperature Probe Handle: 0x0038
	Type: Power Supply Fan
	Status: OK
	Cooling Unit Group: 1
	OEM-specific Information: 0x00000000
	Nominal Speed: Unknown Or Non-rotating
	Description: Cooling Dev 1

Handle 0x003A, DMI type 29, 22 bytes
Electrical Current Probe
	Description: ABC
	Location: Power Unit
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x003B, DMI type 39, 22 bytes
System Power Supply
	Power Unit Group: 1
	Location: To Be Filled By O.E.M.
	Name: To Be Filled By O.E.M.
	Manufacturer: To Be Filled By O.E.M.
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Model Part Number: To Be Filled By O.E.M.
	Revision: To Be Filled By O.E.M.
	Max Power Capacity: Unknown
	Status: Present, OK
	Type: Switching
	Input Voltage Range Switching: Auto-switch
	Plugged: Yes
	Hot Replaceable: No
	Input Voltage Probe Handle: 0x0037
	Cooling Device Handle: 0x0039
	Input Current Probe Handle: 0x003A

Handle 0x003C, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard LAN
	Type: Ethernet
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:00:19.0

Handle 0x003D, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard 1394
	Type: Other
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:03:1c.7

Handle 0x003E, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard IGD
	Type: Video
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:00:02.0

Handle 0x003F, DMI type 139, 54 bytes
OEM-specific Type
	Header and Data:
		8B 36 3F 00 FE DC BA 98 76 54 32 10 04 04 32 55
		F8 00 A2 02 A1 00 40 63 06 11 44 30 03 DF 40 B2
		00 20 00 73 3C 10 08 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 01
	Strings:
		V1394GUID

Handle 0x0040, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x0041
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 8192 MB
	Form Factor: DIMM
	Set: None
	Locator: ChannelA-DIMM0
	Bank Locator: BANK 0
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MHz
	Manufacturer: 1315
	Serial Number: 16134525
	Asset Tag: 9876543210
	Part Number: BLS8G3D1609DS1S00.
	Rank: 2
	Configured Clock Speed: 1600 MHz

Handle 0x0041, DMI type 16, 23 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 32 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x0042, DMI type 20, 35 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 8 GB
	Physical Device Handle: 0x0040
	Memory Array Mapped Address Handle: 0x0047
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x0043, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x0041
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: ChannelA-DIMM1
	Bank Locator: BANK 1
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: [Empty]
	Serial Number: [Empty]
	Asset Tag: 9876543210
	Part Number: [Empty]
	Rank: Unknown
	Configured Clock Speed: Unknown

Handle 0x0044, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x0041
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 8192 MB
	Form Factor: DIMM
	Set: None
	Locator: ChannelB-DIMM0
	Bank Locator: BANK 2
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MHz
	Manufacturer: 1315
	Serial Number: 16134522
	Asset Tag: 9876543210
	Part Number: BLS8G3D1609DS1S00.
	Rank: 2
	Configured Clock Speed: 1600 MHz

Handle 0x0045, DMI type 20, 35 bytes
Memory Device Mapped Address
	Starting Address: 0x00200000000
	Ending Address: 0x003FFFFFFFF
	Range Size: 8 GB
	Physical Device Handle: 0x0044
	Memory Array Mapped Address Handle: 0x0047
	Partition Row Position: Unknown
	Interleave Position: Unknown
	Interleaved Data Depth: Unknown

Handle 0x0046, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x0041
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: ChannelB-DIMM1
	Bank Locator: BANK 3
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: [Empty]
	Serial Number: [Empty]
	Asset Tag: 9876543210
	Part Number: [Empty]
	Rank: Unknown
	Configured Clock Speed: Unknown

Handle 0x0047, DMI type 19, 31 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x003FFFFFFFF
	Range Size: 16 GB
	Physical Array Handle: 0x0041
	Partition Width: 4

Handle 0x0048, DMI type 7, 19 bytes
Cache Information
	Socket Designation: CPU Internal L1
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Other
	Associativity: 8-way Set-associative

Handle 0x0049, DMI type 7, 19 bytes
Cache Information
	Socket Designation: CPU Internal L2
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 1024 kB
	Maximum Size: 1024 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x004A, DMI type 7, 19 bytes
Cache Information
	Socket Designation: CPU Internal L3
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 8192 kB
	Maximum Size: 8192 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x004E, DMI type 4, 42 bytes
Processor Information
	Socket Designation: SOCKET 1150
	Type: Central Processor
	Family: Other
	Manufacturer: Intel
	ID: C3 06 03 00 FF FB EB BF
	Version: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
	Voltage: 1.2 V
	External Clock: 100 MHz
	Max Speed: 3900 MHz
	Current Speed: 3400 MHz
	Status: Populated, Enabled
	Upgrade: Socket BGA1155
	L1 Cache Handle: 0x0048
	L2 Cache Handle: 0x0049
	L3 Cache Handle: 0x004A
	Serial Number: Not Specified
	Asset Tag: Fill By OEM
	Part Number: Fill By OEM
	Core Count: 4
	Core Enabled: 4
	Thread Count: 8
	Characteristics:
		64-bit capable

Handle 0x0053, DMI type 131, 64 bytes
OEM-specific Type
	Header and Data:
		83 40 53 00 35 00 00 00 00 00 00 00 00 00 00 00
		F8 00 4A 8C 00 00 00 00 01 20 00 00 00 00 09 00
		41 05 02 00 00 00 00 00 C8 00 FF FF 00 00 00 00
		00 00 00 00 66 00 00 00 76 50 72 6F 00 00 00 00

Handle 0x0054, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Long
	Installable Languages: 8
		en|US|iso8859-1
		fr|FR|iso8859-1
		es|ES|iso8859-1
		de|DE|iso8859-1
		ru|RU|iso8859-5
		ko|KR|unicode
		ja|JP|unicode
		zh|CN|unicode
	Currently Installed Language: en|US|iso8859-1

Handle 0x0056, DMI type 127, 4 bytes
End Of Table


--------------B03647AB76172C3E8BD88FB9--
