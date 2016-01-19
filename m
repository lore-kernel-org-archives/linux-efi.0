From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: v4.4-rc8 based tip tree kernel hangs on boot.
Date: Tue, 19 Jan 2016 16:17:15 +0530
Message-ID: <20160119104715.GA15850@linux.vnet.ibm.com>
References: <20160110192921.GD17012@linux.vnet.ibm.com>
 <20160111140140.GA2644@codeblueprint.co.uk>
 <20160112103043.GA5707@gmail.com>
 <20160115162011.GA2935@linux.vnet.ibm.com>
 <20160115222921.GA5378@codeblueprint.co.uk>
 <20160117173248.GA28841@linux.vnet.ibm.com>
 <20160118154001.GA2607@codeblueprint.co.uk>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160118154001.GA2607@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

* Matt Fleming <matt@codeblueprint.co.uk> [2016-01-18 15:40:01]:

> On Sun, 17 Jan, at 11:02:48PM, Srikar Dronamraju wrote:
> > 
> > Unfortunately even with your below patch on top of c9f2a9a ("x86/efi:
> > Hoist page table switching code into efi_call_virt()" also fails to boot
> > with and without CONFIG_DEBUG_WX=y. I have added CONFIG_EFI_PGT_DUMP.
> 
> What about if you comment out the call to efi_dump_pagetable()? What
> if you return early from efi_sync_low_kernel_mappings(), e.g.

This doesnt help but ....

> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 71121a9d06cf..e1f8ebb88f84 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -177,6 +177,8 @@ void efi_sync_low_kernel_mappings(void)
>  		init_mm.pgd + pgd_index(PAGE_OFFSET),
>  		sizeof(pgd_t) * num_pgds);
> 
> +	return;
> +

This alone makes it boot. dmesg below

i.e git checkout tip/x86/efi
+
git am <your patch> + <the above fixlet>



[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 4.4.0-rc2-tip-00051-gc63a5e4-dirty (srikar@x3850x5) (gcc version 4.9.2 (Ubuntu 4.9.2-10ubuntu13) ) #157 SMP Tue Jan 19 15:59:12 IST 2016
[    0.000000] Command line: BOOT_IMAGE=/boot/bak/vmlinuz-4.4.0-rc2-tip-00051-gc63a5e4-dirty root=/dev/mapper/x3850x5--vg-root ro console=tty0 console=tty1 console=ttyS0,115200n8 crashkernel=384M-:128M nmi_watchdog=0 nohpet ignore_loglevel log_buf_len=10M print_fatal_signals=1 loglevel=8 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: Legacy x87 FPU detected.
[    0.000000] x86/fpu: Using 'lazy' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000006bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000006c000-0x000000000006cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000000006d000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007edfbfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007edfc000-0x000000007f171fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f172000-0x000000007f79efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007f79f000-0x000000007f7fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007f7ff000-0x000000007f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000407fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00101000-0x0010106f] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000100-0x000000000006bfff] usable
[    0.000000] reserve setup_data: [mem 0x000000000006c000-0x000000000006cfff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000000006d000-0x000000000009efff] usable
[    0.000000] reserve setup_data: [mem 0x000000000009f000-0x000000000009ffff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x0000000000100fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000101000-0x000000000010106f] usable
[    0.000000] reserve setup_data: [mem 0x0000000000101070-0x000000007edfbfff] usable
[    0.000000] reserve setup_data: [mem 0x000000007edfc000-0x000000007f171fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007f172000-0x000000007f79efff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000007f79f000-0x000000007f7fefff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000007f7ff000-0x000000007f7fffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000407fffffff] usable
[    0.000000] efi: EFI v2.10 by EDK II
[    0.000000] efi:  ACPI=0x7f7fe000  ACPI 2.0=0x7f7fe014  SMBIOS=0x7f0a1000 
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: IBM System x3850 X5 -[71455RQ]-/Node 1, Processor Card, BIOS -[G0E177AUS-1.77]- 11/18/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x4080000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00080000000 mask FFF80000000 uncachable
[    0.000000]   1 base F8000000000 mask FE000000000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] x2apic: enabled by BIOS, switching to x2apic ops
[    0.000000] e820: last_pfn = 0x7f800 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] BRK [0x407f00b000, 0x407f00bfff] PGTABLE
[    0.000000] BRK [0x407f00c000, 0x407f00cfff] PGTABLE
[    0.000000] BRK [0x407f00d000, 0x407f00dfff] PGTABLE
[    0.000000] BRK [0x407f00e000, 0x407f00efff] PGTABLE
[    0.000000] BRK [0x407f00f000, 0x407f00ffff] PGTABLE
[    0.000000] BRK [0x407f010000, 0x407f010fff] PGTABLE
[    0.000000] log_buf_len: 16777216 bytes
[    0.000000] early log buf free: 256936(98%)
[    0.000000] RAMDISK: [mem 0x407cbf3000-0x407dffffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000000007F7FE014 000024 (v02 IBM   )
[    0.000000] ACPI: XSDT 0x000000007F7FE1C0 0000C4 (v01 IBM    SERGHDRA 00000000      01000013)
[    0.000000] ACPI: FACP 0x000000007F7FA000 0000F4 (v04 IBM    SERGHDRA 00000000 IBM  01000019)
[    0.000000] ACPI BIOS Warning (bug): 32/64X length mismatch in FADT/Gpe0Block: 128/64 (20150930/tbfadt-623)
[    0.000000] ACPI: DSDT 0x000000007F7DE000 013E3A (v01 IBM    SERGHDRA 00000003 IBM  01000015)
[    0.000000] ACPI: FACS 0x000000007F2B0000 000040
[    0.000000] ACPI: FACS 0x000000007F2B0000 000040
[    0.000000] ACPI: TCPA 0x000000007F7FD000 000064 (v00                 00000000      00000000)
[    0.000000] ACPI: ERST 0x000000007F7FB000 000230 (v01 IBM    SERGHDRA 00000001 IBM  0100001B)
[    0.000000] ACPI: HEST 0x000000007F7F9000 0000F4 (v01 IBM    SERGHDRA 00000001 IBM  0100001E)
[    0.000000] ACPI: HPET 0x000000007F7F8000 000038 (v01 IBM    SERGHDRA 00000001 IBM  01000017)
[    0.000000] ACPI: APIC 0x000000007F7F7000 00016A (v03 IBM    SERGHDRA 00000000 IBM  01000014)
[    0.000000] ACPI: MCFG 0x000000007F7F6000 00003C (v01 IBM    SERGHDRA 00000001 IBM  01000018)
[    0.000000] ACPI: OEM0 0x000000007F7F5000 000378 (v03 IBM    XSECSRAT 00000100 IBM  01000013)
[    0.000000] ACPI: SLIT 0x000000007F7F4000 000050 (v01 IBM    SERGHDRA 00000001 IBM  01000020)
[    0.000000] ACPI: SRAT 0x000000007F7F3000 0002F8 (v03 IBM    SERGHDRA 00000001 IBM  0100001A)
[    0.000000] ACPI: SLIC 0x000000007F7F2000 000176 (v01 IBM    SERGHDRA 00000000 IBM  0100001F)
[    0.000000] ACPI: SSDT 0x000000007F7DD000 000512 (v02 IBM    CPUSCOPE 00004000 IBM  01000016)
[    0.000000] ACPI: SSDT 0x000000007F7DC000 0008A1 (v02 IBM    CPUWYVRN 00004000 IBM  01000016)
[    0.000000] ACPI: SSDT 0x000000007F7D3000 008A24 (v02 IBM    PSTATEPM 00004000 IBM  01000016)
[    0.000000] ACPI: SSDT 0x000000007F7D2000 000F92 (v02 IBM    CPUCSTAT 00004000 IBM  01000016)
[    0.000000] ACPI: SSDT 0x000000007F7D1000 000214 (v02 IBM    WYVRNDEV 00004000 IBM  01000016)
[    0.000000] ACPI: SSDT 0x000000007F7D0000 00009E (v02 IBM    WYVRNGPE 00004000 IBM  01000016)
[    0.000000] ACPI: SSDT 0x000000007F7CF000 000F44 (v02 IBM    CPUNOTFY 00004000 IBM  01000016)
[    0.000000] ACPI: SSDT 0x000000007F7C7000 0078C4 (v02 IBM    CPUTSTAT 00004000 IBM  01000016)
[    0.000000] ACPI: DMAR 0x000000007F7C6000 0001E0 (v01 IBM    SERGHDRA 00000001 IBM  01000021)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] System requires x2apic physical mode
[    0.000000] Setting APIC routing to physical x2apic.
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x107fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x1080000000-0x207fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x2080000000-0x307fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0x3080000000-0x407fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=4
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x107fffffff] -> [mem 0x00000000-0x107fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x107fffc000-0x107fffffff]
[    0.000000] NODE_DATA(1) allocated [mem 0x207fffc000-0x207fffffff]
[    0.000000] NODE_DATA(2) allocated [mem 0x307fffc000-0x307fffffff]
[    0.000000] NODE_DATA(3) allocated [mem 0x407fefd000-0x407ff00fff]
[    0.000000] Reserving 128MB of memory at 768MB for crashkernel (System RAM: 262125MB)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000407fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000006bfff]
[    0.000000]   node   0: [mem 0x000000000006d000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000007edfbfff]
[    0.000000]   node   0: [mem 0x000000007f7ff000-0x000000007f7fffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000107fffffff]
[    0.000000]   node   1: [mem 0x0000001080000000-0x000000207fffffff]
[    0.000000]   node   2: [mem 0x0000002080000000-0x000000307fffffff]
[    0.000000]   node   3: [mem 0x0000003080000000-0x000000407fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000107fffffff]
[    0.000000] On node 0 totalpages: 16772506
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 25 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8056 pages used for memmap
[    0.000000]   DMA32 zone: 515581 pages, LIFO batch:31
[    0.000000]   Normal zone: 253952 pages used for memmap
[    0.000000]   Normal zone: 16252928 pages, LIFO batch:31
[    0.000000] Initmem setup node 1 [mem 0x0000001080000000-0x000000207fffffff]
[    0.000000] On node 1 totalpages: 16777216
[    0.000000]   Normal zone: 262144 pages used for memmap
[    0.000000]   Normal zone: 16777216 pages, LIFO batch:31
[    0.000000] Initmem setup node 2 [mem 0x0000002080000000-0x000000307fffffff]
[    0.000000] On node 2 totalpages: 16777216
[    0.000000]   Normal zone: 262144 pages used for memmap
[    0.000000]   Normal zone: 16777216 pages, LIFO batch:31
[    0.000000] Initmem setup node 3 [mem 0x0000003080000000-0x000000407fffffff]
[    0.000000] On node 3 totalpages: 16777216
[    0.000000]   Normal zone: 262144 pages used for memmap
[    0.000000]   Normal zone: 16777216 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x588
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] System requires x2apic physical mode
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
[    0.000000] IOAPIC[1]: apic_id 13, version 32, address 0xfec01000, GSI 24-47
[    0.000000] IOAPIC[2]: apic_id 12, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 32 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0006c000-0x0006cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x00101000-0x00101fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7edfc000-0x7f171fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f172000-0x7f79efff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f79f000-0x7f7fefff]
[    0.000000] PM: Registered nosave memory: [mem 0x7f800000-0x7fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x80000000-0x8fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xff7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff]
[    0.000000] e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:32 nr_node_ids:4
[    0.000000] PERCPU: Embedded 34 pages/cpu @ffff88103fc00000 s98520 r8192 d32552 u262144
[    0.000000] pcpu-alloc: s98520 r8192 d32552 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [1] 08 09 10 11 12 13 14 15 
[    0.000000] pcpu-alloc: [2] 16 17 18 19 20 21 22 23 [3] 24 25 26 27 28 29 30 31 
[    0.000000] Built 4 zonelists in Node order, mobility grouping on.  Total pages: 66055625
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/bak/vmlinuz-4.4.0-rc2-tip-00051-gc63a5e4-dirty root=/dev/mapper/x3850x5--vg-root ro console=tty0 console=tty1 console=ttyS0,115200n8 crashkernel=384M-:128M nmi_watchdog=0 nohpet ignore_loglevel log_buf_len=10M print_fatal_signals=1 loglevel=8 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 263965640K/268416616K available (7865K kernel code, 1329K rwdata, 3884K rodata, 1464K init, 1300K bss, 4450976K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=32, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	Build-time adjustment of leaf fanout to 64.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=32.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=32
[    0.000000] NR_IRQS:16640 nr_irqs:1496 16
[    0.000000] Spurious LAPIC timer interrupt on cpu 0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2260.964 MHz processor
[    0.000073] Calibrating delay loop (skipped), value calculated using timer frequency.. 4521.92 BogoMIPS (lpj=9043856)
[    0.010709] pid_max: default: 32768 minimum: 301
[    0.015352] ACPI: Core revision 20150930
[    0.086371] ACPI: 9 ACPI AML tables successfully acquired and loaded
[    0.100266] Security Framework initialized
[    0.104372] Yama: becoming mindful.
[    0.107885] AppArmor: AppArmor initialized
[    0.146769] Dentry cache hash table entries: 33554432 (order: 16, 268435456 bytes)
[    0.262268] Inode-cache hash table entries: 16777216 (order: 15, 134217728 bytes)
[    0.315500] Mount-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.323205] Mountpoint-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.333989] Initializing cgroup subsys io
[    0.338014] Initializing cgroup subsys memory
[    0.342409] Initializing cgroup subsys devices
[    0.346860] Initializing cgroup subsys freezer
[    0.351313] Initializing cgroup subsys net_cls
[    0.355766] Initializing cgroup subsys perf_event
[    0.360479] Initializing cgroup subsys net_prio
[    0.365018] Initializing cgroup subsys hugetlb
[    0.369530] CPU: Physical Processor ID: 0
[    0.373547] CPU: Processor Core ID: 0
[    0.377232] mce: CPU supports 22 MCE banks
[    0.381366] CPU0: Thermal monitoring enabled (TM1)
[    0.386172] process: using mwait in idle threads
[    0.390799] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.396288] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.403229] Freeing SMP alternatives memory: 28K (ffffffff81ebc000 - ffffffff81ec3000)
[    0.414786] ftrace: allocating 30985 entries in 122 pages
[    0.449555] DMAR: Host address width 48
[    0.453399] DMAR: DRHD base: 0x000000fd818000 flags: 0x0
[    0.458724] DMAR: dmar0: reg_base_addr fd818000 ver 1:0 cap c90780106f0462 ecap f020fe
[    0.466646] DMAR: DRHD base: 0x000000fed18000 flags: 0x1
[    0.471969] DMAR: dmar1: reg_base_addr fed18000 ver 1:0 cap c90780106f0462 ecap f020fe
[    0.479892] DMAR: RMRR base: 0x0000007f0d0000 end: 0x0000007f14ffff
[    0.486160] DMAR: ATSR flags: 0x0
[    0.489484] DMAR: RHSA base: 0x000000fed18000 proximity domain: 0x0
[    0.495755] DMAR: RHSA base: 0x000000fd818000 proximity domain: 0x2
[    0.502028] DMAR-IR: IOAPIC id 12 under DRHD base  0xfd818000 IOMMU 0
[    0.508469] DMAR-IR: IOAPIC id 14 under DRHD base  0xfed18000 IOMMU 1
[    0.514911] DMAR-IR: IOAPIC id 13 under DRHD base  0xfed18000 IOMMU 1
[    0.521356] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.530578] DMAR-IR: IRQ remapping was enabled on dmar0 but we are not in kdump mode
[    0.538329] DMAR-IR: Failed to copy IR table for dmar0 from previous kernel
[    0.545817] DMAR-IR: IRQ remapping was enabled on dmar1 but we are not in kdump mode
[    0.553567] DMAR-IR: Failed to copy IR table for dmar1 from previous kernel
[    0.560691] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.566097] System requires x2apic physical mode
[    0.571575] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.723729] smpboot: CPU0: Intel(R) Xeon(R) CPU           X7560  @ 2.27GHz (family: 0x6, model: 0x2e, stepping: 0x6)
[    0.734360] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    0.742749] perf_event_intel: CPU erratum AAJ80 worked around
[    0.748500] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.755379] ... version:                3
[    0.759395] ... bit width:              48
[    0.763497] ... generic registers:      4
[    0.767515] ... value mask:             0000ffffffffffff
[    0.772834] ... max period:             000000007fffffff
[    0.778153] ... fixed-purpose events:   3
[    0.782171] ... event mask:             000000070000000f
[    0.789456] x86: Booting SMP configuration:
[    0.793656] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7
[    0.908908] .... node  #1, CPUs:    #8  #9 #10 #11 #12 #13 #14 #15
[    1.137871] .... node  #2, CPUs:   #16 #17 #18 #19 #20 #21 #22 #23
[    1.365890] .... node  #3, CPUs:   #24 #25 #26 #27 #28 #29 #30 #31
[    1.593430] x86: Booted up 4 nodes, 32 CPUs
[    1.597828] smpboot: Total of 32 processors activated (144708.52 BogoMIPS)
[    1.840470] devtmpfs: initialized
[    1.843983] Using 2GB memory block size for large-memory system
[    1.858090] evm: security.selinux
[    1.861423] evm: security.SMACK64
[    1.864750] evm: security.SMACK64EXEC
[    1.868423] evm: security.SMACK64TRANSMUTE
[    1.872528] evm: security.SMACK64MMAP
[    1.876197] evm: security.ima
[    1.879175] evm: security.capability
[    1.883049] PM: Registering ACPI NVS region [mem 0x0006c000-0x0006cfff] (4096 bytes)
[    1.890809] PM: Registering ACPI NVS region [mem 0x0009f000-0x0009ffff] (4096 bytes)
[    1.898562] PM: Registering ACPI NVS region [mem 0x7f172000-0x7f79efff] (6475776 bytes)
[    1.907054] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    1.917127] pinctrl core: initialized pinctrl subsystem
[    1.922643] RTC time: 10:33:59, date: 01/19/16
[    1.927476] NET: Registered protocol family 16
[    1.944363] cpuidle: using governor ladder
[    1.960360] cpuidle: using governor menu
[    1.964298] PCCT header not found.
[    1.967997] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    1.975582] ACPI: bus type PCI registered
[    1.979603] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    1.986251] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
[    1.995573] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    2.002390] PCI: Using configuration type 1 for base access
[    2.007979] PCI: IBM System x3850 detected, can skip ISA alignment
[    2.029609] ACPI: Added _OSI(Module Device)
[    2.033812] ACPI: Added _OSI(Processor Device)
[    2.038268] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.042982] ACPI: Added _OSI(Processor Aggregator Device)
[    2.101294] ACPI: Interpreter enabled
[    2.104989] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20150930/hwxface-580)
[    2.114264] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20150930/hwxface-580)
[    2.123539] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20150930/hwxface-580)
[    2.132824] ACPI: (supports S0 S1 S5)
[    2.136497] ACPI: Using IOAPIC for interrupt routing
[    2.141595] HEST: Table parsing has been initialized.
[    2.146663] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.186306] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
[    2.192514] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    2.200978] acpi PNP0A08:00: _OSC: platform does not support [AER]
[    2.207429] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    2.215101] acpi PNP0A08:00: FADT indicates ASPM is unsupported, using BIOS configuration
[    2.224824] PCI host bridge to bus 0000:00
[    2.228941] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    2.235738] pci_bus 0000:00: root bus resource [io  0x0d00-0x7fff window]
[    2.242534] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    2.250030] pci_bus 0000:00: root bus resource [mem 0x90000000-0xbfffffff window]
[    2.257525] pci_bus 0000:00: root bus resource [mem 0xf8000000000-0xf807fffffff window]
[    2.265539] pci_bus 0000:00: root bus resource [mem 0xf8080000000-0xf80ffffffff window]
[    2.273554] pci_bus 0000:00: root bus resource [mem 0xf8100000000-0xf817fffffff window]
[    2.281568] pci_bus 0000:00: root bus resource [mem 0xf8180000000-0xf81ffffffff window]
[    2.289584] pci_bus 0000:00: root bus resource [mem 0xf8200000000-0xf827fffffff window]
[    2.297599] pci_bus 0000:00: root bus resource [mem 0xf8280000000-0xf82ffffffff window]
[    2.305613] pci_bus 0000:00: root bus resource [mem 0xf8300000000-0xf837fffffff window]
[    2.313628] pci_bus 0000:00: root bus resource [mem 0xf8380000000-0xf83ffffffff window]
[    2.321644] pci_bus 0000:00: root bus resource [mem 0xf8400000000-0xf847fffffff window]
[    2.329661] pci_bus 0000:00: root bus resource [mem 0xf8480000000-0xf84ffffffff window]
[    2.337675] pci_bus 0000:00: root bus resource [mem 0xf8500000000-0xf857fffffff window]
[    2.345689] pci_bus 0000:00: root bus resource [mem 0xf8580000000-0xf85ffffffff window]
[    2.353703] pci_bus 0000:00: root bus resource [mem 0xf8600000000-0xf867fffffff window]
[    2.361717] pci_bus 0000:00: root bus resource [mem 0xf8680000000-0xf86ffffffff window]
[    2.369732] pci_bus 0000:00: root bus resource [mem 0xf8700000000-0xf877fffffff window]
[    2.377745] pci_bus 0000:00: root bus resource [mem 0xf8780000000-0xf87ffffffff window]
[    2.385760] pci_bus 0000:00: root bus resource [mem 0xf8800000000-0xf887fffffff window]
[    2.393774] pci_bus 0000:00: root bus resource [mem 0xf8880000000-0xf88ffffffff window]
[    2.401788] pci_bus 0000:00: root bus resource [mem 0xf8900000000-0xf897fffffff window]
[    2.409805] pci_bus 0000:00: root bus resource [mem 0xf8980000000-0xf89ffffffff window]
[    2.417820] pci_bus 0000:00: root bus resource [mem 0xf8a00000000-0xf8a7fffffff window]
[    2.425833] pci_bus 0000:00: root bus resource [mem 0xf8a80000000-0xf8affffffff window]
[    2.433846] pci_bus 0000:00: root bus resource [mem 0xf8b00000000-0xf8b7fffffff window]
[    2.441860] pci_bus 0000:00: root bus resource [mem 0xf8b80000000-0xf8bffffffff window]
[    2.449878] pci_bus 0000:00: root bus resource [mem 0xf8c00000000-0xf8c7fffffff window]
[    2.457892] pci_bus 0000:00: root bus resource [mem 0xf8c80000000-0xf8cffffffff window]
[    2.465908] pci_bus 0000:00: root bus resource [mem 0xf8d00000000-0xf8d7fffffff window]
[    2.473923] pci_bus 0000:00: root bus resource [mem 0xf8d80000000-0xf8dffffffff window]
[    2.481939] pci_bus 0000:00: root bus resource [mem 0xf8e00000000-0xf8e7fffffff window]
[    2.489954] pci_bus 0000:00: root bus resource [mem 0xf8e80000000-0xf8effffffff window]
[    2.497970] pci_bus 0000:00: root bus resource [mem 0xf8f00000000-0xf8f7fffffff window]
[    2.505985] pci_bus 0000:00: root bus resource [mem 0xf8f80000000-0xf8fffffffff window]
[    2.514000] pci_bus 0000:00: root bus resource [bus 00-7f]
[    2.519509] pci 0000:00:00.0: [8086:3407] type 00 class 0x060000
[    2.525717] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    2.531819] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    2.538059] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    2.544162] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    2.550397] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    2.556491] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    2.562733] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    2.568827] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    2.575067] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    2.581169] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    2.587407] pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
[    2.593592] pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
[    2.599767] pci 0000:00:11.0: [8086:3427] type 00 class 0x080000
[    2.605951] pci 0000:00:11.1: [8086:3428] type 00 class 0x080000
[    2.612129] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    2.618331] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    2.624525] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    2.630734] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    2.636779] pci 0000:00:16.0: reg 0x10: [mem 0x90008000-0x9000bfff 64bit]
[    2.643749] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    2.649792] pci 0000:00:16.1: reg 0x10: [mem 0x9000c000-0x9000ffff 64bit]
[    2.656760] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    2.662804] pci 0000:00:16.2: reg 0x10: [mem 0x90010000-0x90013fff 64bit]
[    2.669772] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    2.675816] pci 0000:00:16.3: reg 0x10: [mem 0x90014000-0x90017fff 64bit]
[    2.682782] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    2.688829] pci 0000:00:16.4: reg 0x10: [mem 0x90018000-0x9001bfff 64bit]
[    2.695795] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    2.701838] pci 0000:00:16.5: reg 0x10: [mem 0x9001c000-0x9001ffff 64bit]
[    2.708807] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    2.714850] pci 0000:00:16.6: reg 0x10: [mem 0x90020000-0x90023fff 64bit]
[    2.721819] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    2.727863] pci 0000:00:16.7: reg 0x10: [mem 0x90024000-0x90027fff 64bit]
[    2.734834] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    2.740912] pci 0000:00:1a.0: reg 0x20: [io  0x0f20-0x0f3f]
[    2.746642] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    2.752719] pci 0000:00:1a.1: reg 0x20: [io  0x0f40-0x0f5f]
[    2.758448] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    2.764527] pci 0000:00:1a.2: reg 0x20: [io  0x0f60-0x0f7f]
[    2.770267] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    2.776318] pci 0000:00:1a.7: reg 0x10: [mem 0x902fe000-0x902fe3ff]
[    2.782689] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    2.788917] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    2.795027] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    2.801263] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    2.807375] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    2.813611] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    2.819690] pci 0000:00:1d.0: reg 0x20: [io  0x0f80-0x0f9f]
[    2.825422] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    2.831501] pci 0000:00:1d.1: reg 0x20: [io  0x0fa0-0x0fbf]
[    2.837230] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    2.843305] pci 0000:00:1d.2: reg 0x20: [io  0x0fc0-0x0fdf]
[    2.849042] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    2.855096] pci 0000:00:1d.7: reg 0x10: [mem 0x902ff000-0x902ff3ff]
[    2.861467] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    2.867686] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    2.873869] pci 0000:00:1f.0: [8086:3a18] type 00 class 0x060100
[    2.880125] pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
[    2.886172] pci 0000:00:1f.2: reg 0x10: [io  0x0ef0-0x0ef7]
[    2.891761] pci 0000:00:1f.2: reg 0x14: [io  0x0ee8-0x0eeb]
[    2.897351] pci 0000:00:1f.2: reg 0x18: [io  0x0ef8-0x0eff]
[    2.902940] pci 0000:00:1f.2: reg 0x1c: [io  0x0eec-0x0eef]
[    2.908531] pci 0000:00:1f.2: reg 0x20: [io  0x0f00-0x0f0f]
[    2.914122] pci 0000:00:1f.2: reg 0x24: [io  0x0f10-0x0f1f]
[    2.919844] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    2.925881] pci 0000:00:1f.3: reg 0x10: [mem 0x90007000-0x900070ff 64bit]
[    2.932700] pci 0000:00:1f.3: reg 0x20: [io  0x0fe0-0x0fff]
[    2.938500] pci 0000:04:00.0: [14e4:1639] type 00 class 0x020000
[    2.944561] pci 0000:04:00.0: reg 0x10: [mem 0x94000000-0x95ffffff 64bit]
[    2.951460] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    2.957685] pci 0000:04:00.1: [14e4:1639] type 00 class 0x020000
[    2.963740] pci 0000:04:00.1: reg 0x10: [mem 0x92000000-0x93ffffff 64bit]
[    2.970638] pci 0000:04:00.1: PME# supported from D0 D3hot D3cold
[    2.984395] pci 0000:00:01.0: PCI bridge to [bus 04-08]
[    2.989638] pci 0000:00:01.0:   bridge window [mem 0x92000000-0x95ffffff]
[    2.996522] pci 0000:09:00.0: [1000:0079] type 00 class 0x010400
[    3.002572] pci 0000:09:00.0: reg 0x10: [io  0x1f00-0x1fff]
[    3.008166] pci 0000:09:00.0: reg 0x14: [mem 0x903bc000-0x903bffff 64bit]
[    3.014975] pci 0000:09:00.0: reg 0x1c: [mem 0x903c0000-0x903fffff 64bit]
[    3.021788] pci 0000:09:00.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
[    3.028540] pci 0000:09:00.0: supports D1 D2
[    3.040390] pci 0000:00:03.0: PCI bridge to [bus 09-0d]
[    3.045634] pci 0000:00:03.0:   bridge window [io  0x1000-0x1fff]
[    3.051737] pci 0000:00:03.0:   bridge window [mem 0x90300000-0x903fffff]
[    3.058732] pci 0000:00:05.0: PCI bridge to [bus 0e-12]
[    3.064172] pci 0000:00:07.0: PCI bridge to [bus 13-17]
[    3.069634] pci 0000:18:00.0: [19a2:0700] type 00 class 0x020000
[    3.075703] pci 0000:18:00.0: reg 0x14: [mem 0x904e0000-0x904e3fff]
[    3.081997] pci 0000:18:00.0: reg 0x18: [mem 0x906e0000-0x906fffff 64bit]
[    3.088813] pci 0000:18:00.0: reg 0x20: [mem 0x906c0000-0x906dffff 64bit]
[    3.095623] pci 0000:18:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]
[    3.102392] pci 0000:18:00.0: PME# supported from D3hot D3cold
[    3.108405] pci 0000:18:00.1: [19a2:0700] type 00 class 0x020000
[    3.114472] pci 0000:18:00.1: reg 0x14: [mem 0x904e4000-0x904e7fff]
[    3.120768] pci 0000:18:00.1: reg 0x18: [mem 0x906a0000-0x906bffff 64bit]
[    3.127583] pci 0000:18:00.1: reg 0x20: [mem 0x90680000-0x9069ffff 64bit]
[    3.134392] pci 0000:18:00.1: reg 0x30: [mem 0xfff80000-0xffffffff pref]
[    3.141161] pci 0000:18:00.1: PME# supported from D3hot D3cold
[    3.152397] pci 0000:00:09.0: PCI bridge to [bus 18-1c]
[    3.157640] pci 0000:00:09.0:   bridge window [mem 0x90400000-0x906fffff]
[    3.164513] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    3.169590] pci 0000:02:00.0: [101b:0452] type 01 class 0x060400
[    3.175756] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    3.188394] pci 0000:00:1c.4: PCI bridge to [bus 02-03]
[    3.193638] pci 0000:00:1c.4:   bridge window [mem 0x90700000-0x90ffffff]
[    3.200440] pci 0000:00:1c.4:   bridge window [mem 0x91000000-0x91ffffff 64bit pref]
[    3.208291] pci 0000:03:00.0: [102b:0530] type 00 class 0x030000
[    3.214346] pci 0000:03:00.0: reg 0x10: [mem 0x91000000-0x91ffffff pref]
[    3.221068] pci 0000:03:00.0: reg 0x14: [mem 0x907fc000-0x907fffff]
[    3.227357] pci 0000:03:00.0: reg 0x18: [mem 0x90800000-0x90ffffff]
[    3.233869] pci 0000:02:00.0: PCI bridge to [bus 03]
[    3.238854] pci 0000:02:00.0:   bridge window [mem 0x90700000-0x90ffffff]
[    3.245652] pci 0000:02:00.0:   bridge window [mem 0x91000000-0x91ffffff pref]
[    3.253001] pci 0000:00:1e.0: PCI bridge to [bus 1d] (subtractive decode)
[    3.259810] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7 window] (subtractive decode)
[    3.268348] pci 0000:00:1e.0:   bridge window [io  0x0d00-0x7fff window] (subtractive decode)
[    3.276885] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff window] (subtractive decode)
[    3.286116] pci 0000:00:1e.0:   bridge window [mem 0x90000000-0xbfffffff window] (subtractive decode)
[    3.295345] pci 0000:00:1e.0:   bridge window [mem 0xf8000000000-0xf807fffffff window] (subtractive decode)
[    3.305096] pci 0000:00:1e.0:   bridge window [mem 0xf8080000000-0xf80ffffffff window] (subtractive decode)
[    3.314847] pci 0000:00:1e.0:   bridge window [mem 0xf8100000000-0xf817fffffff window] (subtractive decode)
[    3.324595] pci 0000:00:1e.0:   bridge window [mem 0xf8180000000-0xf81ffffffff window] (subtractive decode)
[    3.334343] pci 0000:00:1e.0:   bridge window [mem 0xf8200000000-0xf827fffffff window] (subtractive decode)
[    3.344094] pci 0000:00:1e.0:   bridge window [mem 0xf8280000000-0xf82ffffffff window] (subtractive decode)
[    3.353844] pci 0000:00:1e.0:   bridge window [mem 0xf8300000000-0xf837fffffff window] (subtractive decode)
[    3.363595] pci 0000:00:1e.0:   bridge window [mem 0xf8380000000-0xf83ffffffff window] (subtractive decode)
[    3.373343] pci 0000:00:1e.0:   bridge window [mem 0xf8400000000-0xf847fffffff window] (subtractive decode)
[    3.383091] pci 0000:00:1e.0:   bridge window [mem 0xf8480000000-0xf84ffffffff window] (subtractive decode)
[    3.392839] pci 0000:00:1e.0:   bridge window [mem 0xf8500000000-0xf857fffffff window] (subtractive decode)
[    3.402588] pci 0000:00:1e.0:   bridge window [mem 0xf8580000000-0xf85ffffffff window] (subtractive decode)
[    3.412337] pci 0000:00:1e.0:   bridge window [mem 0xf8600000000-0xf867fffffff window] (subtractive decode)
[    3.422087] pci 0000:00:1e.0:   bridge window [mem 0xf8680000000-0xf86ffffffff window] (subtractive decode)
[    3.431836] pci 0000:00:1e.0:   bridge window [mem 0xf8700000000-0xf877fffffff window] (subtractive decode)
[    3.441587] pci 0000:00:1e.0:   bridge window [mem 0xf8780000000-0xf87ffffffff window] (subtractive decode)
[    3.451336] pci 0000:00:1e.0:   bridge window [mem 0xf8800000000-0xf887fffffff window] (subtractive decode)
[    3.461085] pci 0000:00:1e.0:   bridge window [mem 0xf8880000000-0xf88ffffffff window] (subtractive decode)
[    3.470837] pci 0000:00:1e.0:   bridge window [mem 0xf8900000000-0xf897fffffff window] (subtractive decode)
[    3.480589] pci 0000:00:1e.0:   bridge window [mem 0xf8980000000-0xf89ffffffff window] (subtractive decode)
[    3.490338] pci 0000:00:1e.0:   bridge window [mem 0xf8a00000000-0xf8a7fffffff window] (subtractive decode)
[    3.500088] pci 0000:00:1e.0:   bridge window [mem 0xf8a80000000-0xf8affffffff window] (subtractive decode)
[    3.509836] pci 0000:00:1e.0:   bridge window [mem 0xf8b00000000-0xf8b7fffffff window] (subtractive decode)
[    3.519585] pci 0000:00:1e.0:   bridge window [mem 0xf8b80000000-0xf8bffffffff window] (subtractive decode)
[    3.529335] pci 0000:00:1e.0:   bridge window [mem 0xf8c00000000-0xf8c7fffffff window] (subtractive decode)
[    3.539084] pci 0000:00:1e.0:   bridge window [mem 0xf8c80000000-0xf8cffffffff window] (subtractive decode)
[    3.548835] pci 0000:00:1e.0:   bridge window [mem 0xf8d00000000-0xf8d7fffffff window] (subtractive decode)
[    3.558583] pci 0000:00:1e.0:   bridge window [mem 0xf8d80000000-0xf8dffffffff window] (subtractive decode)
[    3.568330] pci 0000:00:1e.0:   bridge window [mem 0xf8e00000000-0xf8e7fffffff window] (subtractive decode)
[    3.578077] pci 0000:00:1e.0:   bridge window [mem 0xf8e80000000-0xf8effffffff window] (subtractive decode)
[    3.587827] pci 0000:00:1e.0:   bridge window [mem 0xf8f00000000-0xf8f7fffffff window] (subtractive decode)
[    3.597578] pci 0000:00:1e.0:   bridge window [mem 0xf8f80000000-0xf8fffffffff window] (subtractive decode)
[    3.607380] pci_bus 0000:00: on NUMA node 0
[    3.613933] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ef])
[    3.620134] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    3.628599] acpi PNP0A08:01: _OSC: platform does not support [AER]
[    3.635048] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    3.642721] acpi PNP0A08:01: FADT indicates ASPM is unsupported, using BIOS configuration
[    3.652421] PCI host bridge to bus 0000:80
[    3.656533] pci_bus 0000:80: root bus resource [io  0x8000-0xffff window]
[    3.663329] pci_bus 0000:80: root bus resource [mem 0xc0000000-0xfbffffff window]
[    3.670825] pci_bus 0000:80: root bus resource [mem 0xf9000000000-0xf907fffffff window]
[    3.678839] pci_bus 0000:80: root bus resource [mem 0xf9080000000-0xf90ffffffff window]
[    3.686854] pci_bus 0000:80: root bus resource [mem 0xf9100000000-0xf917fffffff window]
[    3.694870] pci_bus 0000:80: root bus resource [mem 0xf9180000000-0xf91ffffffff window]
[    3.702890] pci_bus 0000:80: root bus resource [mem 0xf9200000000-0xf927fffffff window]
[    3.710904] pci_bus 0000:80: root bus resource [mem 0xf9280000000-0xf92ffffffff window]
[    3.718917] pci_bus 0000:80: root bus resource [mem 0xf9300000000-0xf937fffffff window]
[    3.726937] pci_bus 0000:80: root bus resource [mem 0xf9380000000-0xf93ffffffff window]
[    3.734951] pci_bus 0000:80: root bus resource [mem 0xf9400000000-0xf947fffffff window]
[    3.742965] pci_bus 0000:80: root bus resource [mem 0xf9480000000-0xf94ffffffff window]
[    3.750978] pci_bus 0000:80: root bus resource [mem 0xf9500000000-0xf957fffffff window]
[    3.758993] pci_bus 0000:80: root bus resource [mem 0xf9580000000-0xf95ffffffff window]
[    3.767008] pci_bus 0000:80: root bus resource [mem 0xf9600000000-0xf967fffffff window]
[    3.775021] pci_bus 0000:80: root bus resource [mem 0xf9680000000-0xf96ffffffff window]
[    3.783036] pci_bus 0000:80: root bus resource [mem 0xf9700000000-0xf977fffffff window]
[    3.791051] pci_bus 0000:80: root bus resource [mem 0xf9780000000-0xf97ffffffff window]
[    3.799064] pci_bus 0000:80: root bus resource [mem 0xf9800000000-0xf987fffffff window]
[    3.807080] pci_bus 0000:80: root bus resource [mem 0xf9880000000-0xf98ffffffff window]
[    3.815095] pci_bus 0000:80: root bus resource [mem 0xf9900000000-0xf997fffffff window]
[    3.823111] pci_bus 0000:80: root bus resource [mem 0xf9980000000-0xf99ffffffff window]
[    3.831124] pci_bus 0000:80: root bus resource [mem 0xf9a00000000-0xf9a7fffffff window]
[    3.839138] pci_bus 0000:80: root bus resource [mem 0xf9a80000000-0xf9affffffff window]
[    3.847152] pci_bus 0000:80: root bus resource [mem 0xf9b00000000-0xf9b7fffffff window]
[    3.855166] pci_bus 0000:80: root bus resource [mem 0xf9b80000000-0xf9bffffffff window]
[    3.863180] pci_bus 0000:80: root bus resource [mem 0xf9c00000000-0xf9c7fffffff window]
[    3.871194] pci_bus 0000:80: root bus resource [mem 0xf9c80000000-0xf9cffffffff window]
[    3.879210] pci_bus 0000:80: root bus resource [mem 0xf9d00000000-0xf9d7fffffff window]
[    3.887225] pci_bus 0000:80: root bus resource [mem 0xf9d80000000-0xf9dffffffff window]
[    3.895240] pci_bus 0000:80: root bus resource [mem 0xf9e00000000-0xf9e7fffffff window]
[    3.903257] pci_bus 0000:80: root bus resource [mem 0xf9e80000000-0xf9effffffff window]
[    3.911272] pci_bus 0000:80: root bus resource [mem 0xf9f00000000-0xf9f7fffffff window]
[    3.919286] pci_bus 0000:80: root bus resource [mem 0xf9f80000000-0xf9fffffffff window]
[    3.927304] pci_bus 0000:80: root bus resource [bus 80-ef]
[    3.932813] pci 0000:80:00.0: [8086:3420] type 01 class 0x060400
[    3.938912] pci 0000:80:00.0: PME# supported from D0 D3hot D3cold
[    3.945154] pci 0000:80:01.0: [8086:3408] type 01 class 0x060400
[    3.951260] pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
[    3.957508] pci 0000:80:03.0: [8086:340a] type 01 class 0x060400
[    3.963606] pci 0000:80:03.0: PME# supported from D0 D3hot D3cold
[    3.969850] pci 0000:80:07.0: [8086:340e] type 01 class 0x060400
[    3.975958] pci 0000:80:07.0: PME# supported from D0 D3hot D3cold
[    3.982198] pci 0000:80:09.0: [8086:3410] type 01 class 0x060400
[    3.988295] pci 0000:80:09.0: PME# supported from D0 D3hot D3cold
[    3.994537] pci 0000:80:10.0: [8086:3425] type 00 class 0x080000
[    4.000725] pci 0000:80:10.1: [8086:3426] type 00 class 0x080000
[    4.006902] pci 0000:80:11.0: [8086:3427] type 00 class 0x080000
[    4.013085] pci 0000:80:11.1: [8086:3428] type 00 class 0x080000
[    4.019269] pci 0000:80:14.0: [8086:342e] type 00 class 0x080000
[    4.025476] pci 0000:80:14.1: [8086:3422] type 00 class 0x080000
[    4.031672] pci 0000:80:14.2: [8086:3423] type 00 class 0x080000
[    4.037881] pci 0000:80:16.0: [8086:3430] type 00 class 0x088000
[    4.043926] pci 0000:80:16.0: reg 0x10: [mem 0xc0000000-0xc0003fff 64bit]
[    4.050899] pci 0000:80:16.1: [8086:3431] type 00 class 0x088000
[    4.056947] pci 0000:80:16.1: reg 0x10: [mem 0xc0004000-0xc0007fff 64bit]
[    4.063917] pci 0000:80:16.2: [8086:3432] type 00 class 0x088000
[    4.069965] pci 0000:80:16.2: reg 0x10: [mem 0xc0008000-0xc000bfff 64bit]
[    4.076938] pci 0000:80:16.3: [8086:3433] type 00 class 0x088000
[    4.082982] pci 0000:80:16.3: reg 0x10: [mem 0xc000c000-0xc000ffff 64bit]
[    4.089958] pci 0000:80:16.4: [8086:3429] type 00 class 0x088000
[    4.096006] pci 0000:80:16.4: reg 0x10: [mem 0xc0010000-0xc0013fff 64bit]
[    4.102983] pci 0000:80:16.5: [8086:342a] type 00 class 0x088000
[    4.109029] pci 0000:80:16.5: reg 0x10: [mem 0xc0014000-0xc0017fff 64bit]
[    4.116002] pci 0000:80:16.6: [8086:342b] type 00 class 0x088000
[    4.122049] pci 0000:80:16.6: reg 0x10: [mem 0xc0018000-0xc001bfff 64bit]
[    4.129021] pci 0000:80:16.7: [8086:342c] type 00 class 0x088000
[    4.135066] pci 0000:80:16.7: reg 0x10: [mem 0xc001c000-0xc001ffff 64bit]
[    4.142104] pci 0000:80:00.0: PCI bridge to [bus 81-85]
[    4.147569] pci 0000:86:00.0: [1077:2532] type 00 class 0x0c0400
[    4.153625] pci 0000:86:00.0: reg 0x10: [io  0x8c00-0x8cff]
[    4.159224] pci 0000:86:00.0: reg 0x14: [mem 0xc01fc000-0xc01fffff 64bit]
[    4.166055] pci 0000:86:00.0: reg 0x30: [mem 0xfffc0000-0xffffffff pref]
[    4.172954] pci 0000:86:00.1: [1077:2532] type 00 class 0x0c0400
[    4.179010] pci 0000:86:00.1: reg 0x10: [io  0x8e00-0x8eff]
[    4.184608] pci 0000:86:00.1: reg 0x14: [mem 0xc01f8000-0xc01fbfff 64bit]
[    4.191441] pci 0000:86:00.1: reg 0x30: [mem 0xfffc0000-0xffffffff pref]
[    4.204413] pci 0000:80:01.0: PCI bridge to [bus 86-8a]
[    4.209653] pci 0000:80:01.0:   bridge window [io  0x8000-0x8fff]
[    4.215759] pci 0000:80:01.0:   bridge window [mem 0xc0100000-0xc01fffff]
[    4.222758] pci 0000:80:03.0: PCI bridge to [bus 8b-8f]
[    4.228215] pci 0000:90:00.0: [1077:2532] type 00 class 0x0c0400
[    4.234270] pci 0000:90:00.0: reg 0x10: [io  0x9c00-0x9cff]
[    4.239867] pci 0000:90:00.0: reg 0x14: [mem 0xc02fc000-0xc02fffff 64bit]
[    4.246699] pci 0000:90:00.0: reg 0x30: [mem 0xfffc0000-0xffffffff pref]
[    4.253606] pci 0000:90:00.1: [1077:2532] type 00 class 0x0c0400
[    4.259663] pci 0000:90:00.1: reg 0x10: [io  0x9e00-0x9eff]
[    4.265260] pci 0000:90:00.1: reg 0x14: [mem 0xc02f8000-0xc02fbfff 64bit]
[    4.272090] pci 0000:90:00.1: reg 0x30: [mem 0xfffc0000-0xffffffff pref]
[    4.284412] pci 0000:80:07.0: PCI bridge to [bus 90-94]
[    4.289655] pci 0000:80:07.0:   bridge window [io  0x9000-0x9fff]
[    4.295760] pci 0000:80:07.0:   bridge window [mem 0xc0200000-0xc02fffff]
[    4.302762] pci 0000:80:09.0: PCI bridge to [bus 95-99]
[    4.308050] pci_bus 0000:80: on NUMA node 2
[    4.312836] ACPI: Enabled 1 GPEs in block 00 to 3F
[    4.317918] vgaarb: setting as boot device: PCI:0000:03:00.0
[    4.323585] vgaarb: device added: PCI:0000:03:00.0,decodes=io+mem,owns=io+mem,locks=none
[    4.331695] vgaarb: loaded
[    4.334417] vgaarb: bridge control possible 0000:03:00.0
[    4.340209] SCSI subsystem initialized
[    4.344101] libata version 3.00 loaded.
[    4.348003] ACPI: bus type USB registered
[    4.352065] usbcore: registered new interface driver usbfs
[    4.357577] usbcore: registered new interface driver hub
[    4.363015] usbcore: registered new device driver usb
[    4.368578] PCI: Using ACPI for IRQ routing
[    4.379303] PCI: Discovered peer bus fc
[    4.383149] PCI: root bus fc: using default resources
[    4.388210] PCI: Probing PCI hardware (bus fc)
[    4.392729] ACPI: \: failed to evaluate _DSM (0x1001)
[    4.397790] PCI host bridge to bus 0000:fc
[    4.401898] pci_bus 0000:fc: root bus resource [io  0x0000-0xffff]
[    4.408089] pci_bus 0000:fc: root bus resource [mem 0x00000000-0xfffffffffff]
[    4.415230] pci_bus 0000:fc: No busn resource found for root bus, will use [bus fc-ff]
[    4.423165] pci 0000:fc:00.0: [8086:2b00] type 00 class 0x060000
[    4.429302] pci 0000:fc:00.2: [8086:2b02] type 00 class 0x060000
[    4.435436] pci 0000:fc:00.4: [8086:2b22] type 00 class 0x060000
[    4.441566] pci 0000:fc:00.6: [8086:2b2a] type 00 class 0x060000
[    4.447693] pci 0000:fc:01.0: [8086:2b04] type 00 class 0x060000
[    4.453827] pci 0000:fc:02.0: [8086:2b08] type 00 class 0x060000
[    4.459957] pci 0000:fc:03.0: [8086:2b0c] type 00 class 0x060000
[    4.466093] pci 0000:fc:04.0: [8086:2b10] type 00 class 0x060000
[    4.472228] pci 0000:fc:05.0: [8086:2b14] type 00 class 0x060000
[    4.478357] pci 0000:fc:05.2: [8086:2b16] type 00 class 0x060000
[    4.484489] pci 0000:fc:05.4: [8086:2b13] type 00 class 0x060000
[    4.490617] pci 0000:fc:06.0: [8086:2b18] type 00 class 0x060000
[    4.496749] pci 0000:fc:07.0: [8086:2b1c] type 00 class 0x060000
[    4.502876] pci 0000:fc:07.2: [8086:2b1e] type 00 class 0x060000
[    4.509002] pci 0000:fc:07.4: [8086:2b1b] type 00 class 0x060000
[    4.515137] pci 0000:fc:08.0: [8086:2b20] type 00 class 0x060000
[    4.521273] pci 0000:fc:09.0: [8086:2b24] type 00 class 0x060000
[    4.527407] pci 0000:fc:0a.0: [8086:2b28] type 00 class 0x060000
[    4.533544] pci 0000:fc:0b.0: [8086:2b2c] type 00 class 0x060000
[    4.539680] pci 0000:fc:0c.0: [8086:2b30] type 00 class 0x060000
[    4.545817] pci 0000:fc:0d.0: [8086:2b34] type 00 class 0x060000
[    4.551954] pci 0000:fc:0e.0: [8086:2b38] type 00 class 0x060000
[    4.558093] pci 0000:fc:0f.0: [8086:2b3c] type 00 class 0x060000
[    4.564230] pci 0000:fc:10.0: [8086:2b40] type 00 class 0x060000
[    4.570363] pci 0000:fc:10.2: [8086:2b42] type 00 class 0x060000
[    4.576493] pci 0000:fc:10.4: [8086:2b32] type 00 class 0x060000
[    4.582623] pci 0000:fc:10.6: [8086:2b3a] type 00 class 0x060000
[    4.588751] pci 0000:fc:11.0: [8086:2b44] type 00 class 0x060000
[    4.594879] pci 0000:fc:11.2: [8086:2b46] type 00 class 0x060000
[    4.601008] pci 0000:fc:11.4: [8086:2b36] type 00 class 0x060000
[    4.607137] pci 0000:fc:11.6: [8086:2b3e] type 00 class 0x060000
[    4.613270] pci 0000:fc:12.0: [8086:2b48] type 00 class 0x060000
[    4.619407] pci 0000:fc:13.0: [8086:2b4c] type 00 class 0x060000
[    4.625544] pci 0000:fc:14.0: [8086:2b50] type 00 class 0x060000
[    4.631675] pci 0000:fc:14.2: [8086:2b52] type 00 class 0x060000
[    4.637811] pci 0000:fc:15.0: [8086:2b54] type 00 class 0x060000
[    4.643946] pci 0000:fc:15.2: [8086:2b56] type 00 class 0x060000
[    4.650081] pci 0000:fc:16.0: [8086:2b58] type 00 class 0x060000
[    4.656210] pci 0000:fc:16.2: [8086:2b5a] type 00 class 0x060000
[    4.662347] pci 0000:fc:17.0: [8086:2b5c] type 00 class 0x060000
[    4.668482] pci 0000:fc:17.2: [8086:2b5e] type 00 class 0x060000
[    4.674619] pci 0000:fc:18.0: [8086:2b60] type 00 class 0x060000
[    4.680753] pci 0000:fc:18.2: [8086:2b62] type 00 class 0x060000
[    4.686889] pci 0000:fc:19.0: [8086:2b64] type 00 class 0x060000
[    4.693021] pci 0000:fc:19.2: [8086:2b66] type 00 class 0x060000
[    4.699161] pci_bus 0000:fc: busn_res: [bus fc-ff] end is updated to fc
[    4.705808] PCI: Discovered peer bus fd
[    4.709656] PCI: root bus fd: using default resources
[    4.714714] PCI: Probing PCI hardware (bus fd)
[    4.719228] ACPI: \: failed to evaluate _DSM (0x1001)
[    4.724291] PCI host bridge to bus 0000:fd
[    4.728401] pci_bus 0000:fd: root bus resource [io  0x0000-0xffff]
[    4.734589] pci_bus 0000:fd: root bus resource [mem 0x00000000-0xfffffffffff]
[    4.741730] pci_bus 0000:fd: No busn resource found for root bus, will use [bus fd-ff]
[    4.749667] pci 0000:fd:00.0: [8086:2b00] type 00 class 0x060000
[    4.755798] pci 0000:fd:00.2: [8086:2b02] type 00 class 0x060000
[    4.761928] pci 0000:fd:00.4: [8086:2b22] type 00 class 0x060000
[    4.768057] pci 0000:fd:00.6: [8086:2b2a] type 00 class 0x060000
[    4.774186] pci 0000:fd:01.0: [8086:2b04] type 00 class 0x060000
[    4.780318] pci 0000:fd:02.0: [8086:2b08] type 00 class 0x060000
[    4.786452] pci 0000:fd:03.0: [8086:2b0c] type 00 class 0x060000
[    4.792590] pci 0000:fd:04.0: [8086:2b10] type 00 class 0x060000
[    4.798720] pci 0000:fd:05.0: [8086:2b14] type 00 class 0x060000
[    4.804846] pci 0000:fd:05.2: [8086:2b16] type 00 class 0x060000
[    4.810974] pci 0000:fd:05.4: [8086:2b13] type 00 class 0x060000
[    4.817104] pci 0000:fd:06.0: [8086:2b18] type 00 class 0x060000
[    4.823245] pci 0000:fd:07.0: [8086:2b1c] type 00 class 0x060000
[    4.829371] pci 0000:fd:07.2: [8086:2b1e] type 00 class 0x060000
[    4.835498] pci 0000:fd:07.4: [8086:2b1b] type 00 class 0x060000
[    4.841635] pci 0000:fd:08.0: [8086:2b20] type 00 class 0x060000
[    4.847771] pci 0000:fd:09.0: [8086:2b24] type 00 class 0x060000
[    4.853906] pci 0000:fd:0a.0: [8086:2b28] type 00 class 0x060000
[    4.860041] pci 0000:fd:0b.0: [8086:2b2c] type 00 class 0x060000
[    4.866176] pci 0000:fd:0c.0: [8086:2b30] type 00 class 0x060000
[    4.872314] pci 0000:fd:0d.0: [8086:2b34] type 00 class 0x060000
[    4.878448] pci 0000:fd:0e.0: [8086:2b38] type 00 class 0x060000
[    4.884585] pci 0000:fd:0f.0: [8086:2b3c] type 00 class 0x060000
[    4.890722] pci 0000:fd:10.0: [8086:2b40] type 00 class 0x060000
[    4.896852] pci 0000:fd:10.2: [8086:2b42] type 00 class 0x060000
[    4.902981] pci 0000:fd:10.4: [8086:2b32] type 00 class 0x060000
[    4.909114] pci 0000:fd:10.6: [8086:2b3a] type 00 class 0x060000
[    4.915245] pci 0000:fd:11.0: [8086:2b44] type 00 class 0x060000
[    4.921379] pci 0000:fd:11.2: [8086:2b46] type 00 class 0x060000
[    4.927510] pci 0000:fd:11.4: [8086:2b36] type 00 class 0x060000
[    4.933638] pci 0000:fd:11.6: [8086:2b3e] type 00 class 0x060000
[    4.939769] pci 0000:fd:12.0: [8086:2b48] type 00 class 0x060000
[    4.945907] pci 0000:fd:13.0: [8086:2b4c] type 00 class 0x060000
[    4.952044] pci 0000:fd:14.0: [8086:2b50] type 00 class 0x060000
[    4.958177] pci 0000:fd:14.2: [8086:2b52] type 00 class 0x060000
[    4.964312] pci 0000:fd:15.0: [8086:2b54] type 00 class 0x060000
[    4.970442] pci 0000:fd:15.2: [8086:2b56] type 00 class 0x060000
[    4.976574] pci 0000:fd:16.0: [8086:2b58] type 00 class 0x060000
[    4.982705] pci 0000:fd:16.2: [8086:2b5a] type 00 class 0x060000
[    4.988841] pci 0000:fd:17.0: [8086:2b5c] type 00 class 0x060000
[    4.994970] pci 0000:fd:17.2: [8086:2b5e] type 00 class 0x060000
[    5.001108] pci 0000:fd:18.0: [8086:2b60] type 00 class 0x060000
[    5.007245] pci 0000:fd:18.2: [8086:2b62] type 00 class 0x060000
[    5.013380] pci 0000:fd:19.0: [8086:2b64] type 00 class 0x060000
[    5.019509] pci 0000:fd:19.2: [8086:2b66] type 00 class 0x060000
[    5.025652] pci_bus 0000:fd: busn_res: [bus fd-ff] end is updated to fd
[    5.032300] PCI: Discovered peer bus fe
[    5.036146] PCI: root bus fe: using default resources
[    5.041208] PCI: Probing PCI hardware (bus fe)
[    5.045722] ACPI: \: failed to evaluate _DSM (0x1001)
[    5.050783] PCI host bridge to bus 0000:fe
[    5.054893] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    5.061081] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xfffffffffff]
[    5.068224] pci_bus 0000:fe: No busn resource found for root bus, will use [bus fe-ff]
[    5.076158] pci 0000:fe:00.0: [8086:2b00] type 00 class 0x060000
[    5.082288] pci 0000:fe:00.2: [8086:2b02] type 00 class 0x060000
[    5.088416] pci 0000:fe:00.4: [8086:2b22] type 00 class 0x060000
[    5.094539] pci 0000:fe:00.6: [8086:2b2a] type 00 class 0x060000
[    5.100663] pci 0000:fe:01.0: [8086:2b04] type 00 class 0x060000
[    5.106797] pci 0000:fe:02.0: [8086:2b08] type 00 class 0x060000
[    5.112930] pci 0000:fe:03.0: [8086:2b0c] type 00 class 0x060000
[    5.119059] pci 0000:fe:04.0: [8086:2b10] type 00 class 0x060000
[    5.125189] pci 0000:fe:05.0: [8086:2b14] type 00 class 0x060000
[    5.131317] pci 0000:fe:05.2: [8086:2b16] type 00 class 0x060000
[    5.137445] pci 0000:fe:05.4: [8086:2b13] type 00 class 0x060000
[    5.143574] pci 0000:fe:06.0: [8086:2b18] type 00 class 0x060000
[    5.149708] pci 0000:fe:07.0: [8086:2b1c] type 00 class 0x060000
[    5.155838] pci 0000:fe:07.2: [8086:2b1e] type 00 class 0x060000
[    5.161967] pci 0000:fe:07.4: [8086:2b1b] type 00 class 0x060000
[    5.168096] pci 0000:fe:08.0: [8086:2b20] type 00 class 0x060000
[    5.174225] pci 0000:fe:09.0: [8086:2b24] type 00 class 0x060000
[    5.180357] pci 0000:fe:0a.0: [8086:2b28] type 00 class 0x060000
[    5.186489] pci 0000:fe:0b.0: [8086:2b2c] type 00 class 0x060000
[    5.192620] pci 0000:fe:0c.0: [8086:2b30] type 00 class 0x060000
[    5.198751] pci 0000:fe:0d.0: [8086:2b34] type 00 class 0x060000
[    5.204887] pci 0000:fe:0e.0: [8086:2b38] type 00 class 0x060000
[    5.211018] pci 0000:fe:0f.0: [8086:2b3c] type 00 class 0x060000
[    5.217152] pci 0000:fe:10.0: [8086:2b40] type 00 class 0x060000
[    5.223275] pci 0000:fe:10.2: [8086:2b42] type 00 class 0x060000
[    5.229403] pci 0000:fe:10.4: [8086:2b32] type 00 class 0x060000
[    5.235529] pci 0000:fe:10.6: [8086:2b3a] type 00 class 0x060000
[    5.241653] pci 0000:fe:11.0: [8086:2b44] type 00 class 0x060000
[    5.247781] pci 0000:fe:11.2: [8086:2b46] type 00 class 0x060000
[    5.253911] pci 0000:fe:11.4: [8086:2b36] type 00 class 0x060000
[    5.260041] pci 0000:fe:11.6: [8086:2b3e] type 00 class 0x060000
[    5.266170] pci 0000:fe:12.0: [8086:2b48] type 00 class 0x060000
[    5.272304] pci 0000:fe:13.0: [8086:2b4c] type 00 class 0x060000
[    5.278436] pci 0000:fe:14.0: [8086:2b50] type 00 class 0x060000
[    5.284565] pci 0000:fe:14.2: [8086:2b52] type 00 class 0x060000
[    5.290699] pci 0000:fe:15.0: [8086:2b54] type 00 class 0x060000
[    5.296828] pci 0000:fe:15.2: [8086:2b56] type 00 class 0x060000
[    5.302966] pci 0000:fe:16.0: [8086:2b58] type 00 class 0x060000
[    5.309100] pci 0000:fe:16.2: [8086:2b5a] type 00 class 0x060000
[    5.315234] pci 0000:fe:17.0: [8086:2b5c] type 00 class 0x060000
[    5.321374] pci 0000:fe:17.2: [8086:2b5e] type 00 class 0x060000
[    5.327510] pci 0000:fe:18.0: [8086:2b60] type 00 class 0x060000
[    5.333640] pci 0000:fe:18.2: [8086:2b62] type 00 class 0x060000
[    5.339775] pci 0000:fe:19.0: [8086:2b64] type 00 class 0x060000
[    5.345902] pci 0000:fe:19.2: [8086:2b66] type 00 class 0x060000
[    5.352041] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to fe
[    5.358687] PCI: Discovered peer bus ff
[    5.362533] PCI: root bus ff: using default resources
[    5.367592] PCI: Probing PCI hardware (bus ff)
[    5.372106] ACPI: \: failed to evaluate _DSM (0x1001)
[    5.377168] PCI host bridge to bus 0000:ff
[    5.381274] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    5.387464] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xfffffffffff]
[    5.394609] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[    5.402544] pci 0000:ff:00.0: [8086:2b00] type 00 class 0x060000
[    5.408670] pci 0000:ff:00.2: [8086:2b02] type 00 class 0x060000
[    5.414798] pci 0000:ff:00.4: [8086:2b22] type 00 class 0x060000
[    5.420923] pci 0000:ff:00.6: [8086:2b2a] type 00 class 0x060000
[    5.427049] pci 0000:ff:01.0: [8086:2b04] type 00 class 0x060000
[    5.433181] pci 0000:ff:02.0: [8086:2b08] type 00 class 0x060000
[    5.439313] pci 0000:ff:03.0: [8086:2b0c] type 00 class 0x060000
[    5.445447] pci 0000:ff:04.0: [8086:2b10] type 00 class 0x060000
[    5.451584] pci 0000:ff:05.0: [8086:2b14] type 00 class 0x060000
[    5.457711] pci 0000:ff:05.2: [8086:2b16] type 00 class 0x060000
[    5.463839] pci 0000:ff:05.4: [8086:2b13] type 00 class 0x060000
[    5.469970] pci 0000:ff:06.0: [8086:2b18] type 00 class 0x060000
[    5.476103] pci 0000:ff:07.0: [8086:2b1c] type 00 class 0x060000
[    5.482230] pci 0000:ff:07.2: [8086:2b1e] type 00 class 0x060000
[    5.488360] pci 0000:ff:07.4: [8086:2b1b] type 00 class 0x060000
[    5.494493] pci 0000:ff:08.0: [8086:2b20] type 00 class 0x060000
[    5.500627] pci 0000:ff:09.0: [8086:2b24] type 00 class 0x060000
[    5.506765] pci 0000:ff:0a.0: [8086:2b28] type 00 class 0x060000
[    5.512902] pci 0000:ff:0b.0: [8086:2b2c] type 00 class 0x060000
[    5.519039] pci 0000:ff:0c.0: [8086:2b30] type 00 class 0x060000
[    5.525180] pci 0000:ff:0d.0: [8086:2b34] type 00 class 0x060000
[    5.531314] pci 0000:ff:0e.0: [8086:2b38] type 00 class 0x060000
[    5.537451] pci 0000:ff:0f.0: [8086:2b3c] type 00 class 0x060000
[    5.543590] pci 0000:ff:10.0: [8086:2b40] type 00 class 0x060000
[    5.549722] pci 0000:ff:10.2: [8086:2b42] type 00 class 0x060000
[    5.555849] pci 0000:ff:10.4: [8086:2b32] type 00 class 0x060000
[    5.561975] pci 0000:ff:10.6: [8086:2b3a] type 00 class 0x060000
[    5.568103] pci 0000:ff:11.0: [8086:2b44] type 00 class 0x060000
[    5.574233] pci 0000:ff:11.2: [8086:2b46] type 00 class 0x060000
[    5.580362] pci 0000:ff:11.4: [8086:2b36] type 00 class 0x060000
[    5.586492] pci 0000:ff:11.6: [8086:2b3e] type 00 class 0x060000
[    5.592619] pci 0000:ff:12.0: [8086:2b48] type 00 class 0x060000
[    5.598761] pci 0000:ff:13.0: [8086:2b4c] type 00 class 0x060000
[    5.604898] pci 0000:ff:14.0: [8086:2b50] type 00 class 0x060000
[    5.611024] pci 0000:ff:14.2: [8086:2b52] type 00 class 0x060000
[    5.617162] pci 0000:ff:15.0: [8086:2b54] type 00 class 0x060000
[    5.623295] pci 0000:ff:15.2: [8086:2b56] type 00 class 0x060000
[    5.629432] pci 0000:ff:16.0: [8086:2b58] type 00 class 0x060000
[    5.635563] pci 0000:ff:16.2: [8086:2b5a] type 00 class 0x060000
[    5.641697] pci 0000:ff:17.0: [8086:2b5c] type 00 class 0x060000
[    5.647831] pci 0000:ff:17.2: [8086:2b5e] type 00 class 0x060000
[    5.653968] pci 0000:ff:18.0: [8086:2b60] type 00 class 0x060000
[    5.660099] pci 0000:ff:18.2: [8086:2b62] type 00 class 0x060000
[    5.666237] pci 0000:ff:19.0: [8086:2b64] type 00 class 0x060000
[    5.672366] pci 0000:ff:19.2: [8086:2b66] type 00 class 0x060000
[    5.678508] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    5.684893] PCI: pci_cache_line_size set to 64 bytes
[    5.690347] e820: reserve RAM buffer [mem 0x0006c000-0x0006ffff]
[    5.696365] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    5.702379] e820: reserve RAM buffer [mem 0x00101000-0x001fffff]
[    5.708396] e820: reserve RAM buffer [mem 0x7edfc000-0x7fffffff]
[    5.714410] e820: reserve RAM buffer [mem 0x7f800000-0x7fffffff]
[    5.720700] NetLabel: Initializing
[    5.724115] NetLabel:  domain hash size = 128
[    5.728482] NetLabel:  protocols = UNLABELED CIPSOv4
[    5.733481] NetLabel:  unlabeled traffic allowed by default
[    5.739507] clocksource: Switched to clocksource refined-jiffies
[    5.761938] AppArmor: AppArmor Filesystem Enabled
[    5.766761] pnp: PnP ACPI init
[    5.770181] system 00:00: [mem 0xfed18000-0xfed19fff] could not be reserved
[    5.777162] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.784237] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    5.791153] system 00:02: [io  0x02f8-0x02ff] has been reserved
[    5.797091] system 00:02: Plug and Play ACPI device, IDs PNP0c01 (active)
[    5.803946] pnp 00:03: Plug and Play ACPI device, IDs PNP0c31 (active)
[    5.810542] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    5.817305] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    5.823941] system 00:05: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    5.831645] system 00:06: [io  0x0400-0x043f] has been reserved
[    5.837580] system 00:06: [io  0x0440-0x045f] has been reserved
[    5.843511] system 00:06: [io  0x0460-0x047f] has been reserved
[    5.849439] system 00:06: [io  0x0580-0x05ff] has been reserved
[    5.855368] system 00:06: [io  0x05e0-0x05ff] has been reserved
[    5.861297] system 00:06: [io  0x0cf9] could not be reserved
[    5.866968] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.874022] system 00:07: [io  0x0ca2] has been reserved
[    5.879350] system 00:07: [io  0x0ca3] has been reserved
[    5.884678] system 00:07: Plug and Play ACPI device, IDs IPI0001 PNP0c02 (active)
[    5.892528] system 00:08: [io  0x0ca0-0x0ca1] has been reserved
[    5.898461] system 00:08: [io  0x0ca4-0x0ca9] has been reserved
[    5.904390] system 00:08: [io  0x0caa-0x0cab] has been reserved
[    5.910320] system 00:08: [io  0x0cac-0x0caf] has been reserved
[    5.916249] system 00:08: [io  0x0cc0-0x0ccb] has been reserved
[    5.922180] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.929212] system 00:09: [io  0x0600-0x063f] has been reserved
[    5.935150] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.942186] system 00:0a: [io  0x0cb0-0x0cbf] has been reserved
[    5.948123] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.955253] system 00:0b: [mem 0xfd818000-0xfd819fff] could not be reserved
[    5.962233] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    5.969484] pnp: PnP ACPI: found 12 devices
[    5.981678] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    5.990702] clocksource: Switched to clocksource acpi_pm
[    5.996056] pci 0000:09:00.0: can't claim BAR 6 [mem 0xfffe0000-0xffffffff pref]: no compatible bridge window
[    6.005990] pci 0000:18:00.0: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
[    6.015920] pci 0000:18:00.1: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
[    6.025849] pci 0000:86:00.0: can't claim BAR 6 [mem 0xfffc0000-0xffffffff pref]: no compatible bridge window
[    6.035779] pci 0000:86:00.1: can't claim BAR 6 [mem 0xfffc0000-0xffffffff pref]: no compatible bridge window
[    6.045706] pci 0000:90:00.0: can't claim BAR 6 [mem 0xfffc0000-0xffffffff pref]: no compatible bridge window
[    6.055636] pci 0000:90:00.1: can't claim BAR 6 [mem 0xfffc0000-0xffffffff pref]: no compatible bridge window
[    6.065655] pci 0000:00:01.0: PCI bridge to [bus 04-08]
[    6.070901] pci 0000:00:01.0:   bridge window [mem 0x92000000-0x95ffffff]
[    6.077713] pci 0000:09:00.0: BAR 6: assigned [mem 0x90300000-0x9031ffff pref]
[    6.084956] pci 0000:00:03.0: PCI bridge to [bus 09-0d]
[    6.090197] pci 0000:00:03.0:   bridge window [io  0x1000-0x1fff]
[    6.096308] pci 0000:00:03.0:   bridge window [mem 0x90300000-0x903fffff]
[    6.103117] pci 0000:00:05.0: PCI bridge to [bus 0e-12]
[    6.108367] pci 0000:00:07.0: PCI bridge to [bus 13-17]
[    6.113618] pci 0000:18:00.0: BAR 6: assigned [mem 0x90400000-0x9047ffff pref]
[    6.120860] pci 0000:18:00.1: BAR 6: assigned [mem 0x90500000-0x9057ffff pref]
[    6.128101] pci 0000:00:09.0: PCI bridge to [bus 18-1c]
[    6.133344] pci 0000:00:09.0:   bridge window [mem 0x90400000-0x906fffff]
[    6.140155] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    6.145148] pci 0000:02:00.0: PCI bridge to [bus 03]
[    6.150133] pci 0000:02:00.0:   bridge window [mem 0x90700000-0x90ffffff]
[    6.156938] pci 0000:02:00.0:   bridge window [mem 0x91000000-0x91ffffff pref]
[    6.164185] pci 0000:00:1c.4: PCI bridge to [bus 02-03]
[    6.169428] pci 0000:00:1c.4:   bridge window [mem 0x90700000-0x90ffffff]
[    6.176232] pci 0000:00:1c.4:   bridge window [mem 0x91000000-0x91ffffff 64bit pref]
[    6.183999] pci 0000:00:1e.0: PCI bridge to [bus 1d]
[    6.188991] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    6.195186] pci_bus 0000:00: resource 5 [io  0x0d00-0x7fff window]
[    6.201379] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    6.208268] pci_bus 0000:00: resource 7 [mem 0x90000000-0xbfffffff window]
[    6.215157] pci_bus 0000:00: resource 8 [mem 0xf8000000000-0xf807fffffff window]
[    6.222572] pci_bus 0000:00: resource 9 [mem 0xf8080000000-0xf80ffffffff window]
[    6.229987] pci_bus 0000:00: resource 10 [mem 0xf8100000000-0xf817fffffff window]
[    6.237486] pci_bus 0000:00: resource 11 [mem 0xf8180000000-0xf81ffffffff window]
[    6.244989] pci_bus 0000:00: resource 12 [mem 0xf8200000000-0xf827fffffff window]
[    6.252491] pci_bus 0000:00: resource 13 [mem 0xf8280000000-0xf82ffffffff window]
[    6.259991] pci_bus 0000:00: resource 14 [mem 0xf8300000000-0xf837fffffff window]
[    6.267491] pci_bus 0000:00: resource 15 [mem 0xf8380000000-0xf83ffffffff window]
[    6.274991] pci_bus 0000:00: resource 16 [mem 0xf8400000000-0xf847fffffff window]
[    6.282491] pci_bus 0000:00: resource 17 [mem 0xf8480000000-0xf84ffffffff window]
[    6.289994] pci_bus 0000:00: resource 18 [mem 0xf8500000000-0xf857fffffff window]
[    6.297493] pci_bus 0000:00: resource 19 [mem 0xf8580000000-0xf85ffffffff window]
[    6.304995] pci_bus 0000:00: resource 20 [mem 0xf8600000000-0xf867fffffff window]
[    6.312495] pci_bus 0000:00: resource 21 [mem 0xf8680000000-0xf86ffffffff window]
[    6.319998] pci_bus 0000:00: resource 22 [mem 0xf8700000000-0xf877fffffff window]
[    6.327498] pci_bus 0000:00: resource 23 [mem 0xf8780000000-0xf87ffffffff window]
[    6.335001] pci_bus 0000:00: resource 24 [mem 0xf8800000000-0xf887fffffff window]
[    6.342504] pci_bus 0000:00: resource 25 [mem 0xf8880000000-0xf88ffffffff window]
[    6.350004] pci_bus 0000:00: resource 26 [mem 0xf8900000000-0xf897fffffff window]
[    6.357504] pci_bus 0000:00: resource 27 [mem 0xf8980000000-0xf89ffffffff window]
[    6.365002] pci_bus 0000:00: resource 28 [mem 0xf8a00000000-0xf8a7fffffff window]
[    6.372503] pci_bus 0000:00: resource 29 [mem 0xf8a80000000-0xf8affffffff window]
[    6.380003] pci_bus 0000:00: resource 30 [mem 0xf8b00000000-0xf8b7fffffff window]
[    6.387503] pci_bus 0000:00: resource 31 [mem 0xf8b80000000-0xf8bffffffff window]
[    6.395005] pci_bus 0000:00: resource 32 [mem 0xf8c00000000-0xf8c7fffffff window]
[    6.402504] pci_bus 0000:00: resource 33 [mem 0xf8c80000000-0xf8cffffffff window]
[    6.410007] pci_bus 0000:00: resource 34 [mem 0xf8d00000000-0xf8d7fffffff window]
[    6.417509] pci_bus 0000:00: resource 35 [mem 0xf8d80000000-0xf8dffffffff window]
[    6.425009] pci_bus 0000:00: resource 36 [mem 0xf8e00000000-0xf8e7fffffff window]
[    6.432509] pci_bus 0000:00: resource 37 [mem 0xf8e80000000-0xf8effffffff window]
[    6.440009] pci_bus 0000:00: resource 38 [mem 0xf8f00000000-0xf8f7fffffff window]
[    6.447510] pci_bus 0000:00: resource 39 [mem 0xf8f80000000-0xf8fffffffff window]
[    6.455012] pci_bus 0000:04: resource 1 [mem 0x92000000-0x95ffffff]
[    6.461291] pci_bus 0000:09: resource 0 [io  0x1000-0x1fff]
[    6.466880] pci_bus 0000:09: resource 1 [mem 0x90300000-0x903fffff]
[    6.473163] pci_bus 0000:18: resource 1 [mem 0x90400000-0x906fffff]
[    6.479445] pci_bus 0000:02: resource 1 [mem 0x90700000-0x90ffffff]
[    6.485727] pci_bus 0000:02: resource 2 [mem 0x91000000-0x91ffffff 64bit pref]
[    6.492966] pci_bus 0000:03: resource 1 [mem 0x90700000-0x90ffffff]
[    6.499250] pci_bus 0000:03: resource 2 [mem 0x91000000-0x91ffffff pref]
[    6.505963] pci_bus 0000:1d: resource 4 [io  0x0000-0x0cf7 window]
[    6.512159] pci_bus 0000:1d: resource 5 [io  0x0d00-0x7fff window]
[    6.518352] pci_bus 0000:1d: resource 6 [mem 0x000a0000-0x000bffff window]
[    6.525241] pci_bus 0000:1d: resource 7 [mem 0x90000000-0xbfffffff window]
[    6.532127] pci_bus 0000:1d: resource 8 [mem 0xf8000000000-0xf807fffffff window]
[    6.539541] pci_bus 0000:1d: resource 9 [mem 0xf8080000000-0xf80ffffffff window]
[    6.546955] pci_bus 0000:1d: resource 10 [mem 0xf8100000000-0xf817fffffff window]
[    6.554457] pci_bus 0000:1d: resource 11 [mem 0xf8180000000-0xf81ffffffff window]
[    6.561958] pci_bus 0000:1d: resource 12 [mem 0xf8200000000-0xf827fffffff window]
[    6.569456] pci_bus 0000:1d: resource 13 [mem 0xf8280000000-0xf82ffffffff window]
[    6.576955] pci_bus 0000:1d: resource 14 [mem 0xf8300000000-0xf837fffffff window]
[    6.584453] pci_bus 0000:1d: resource 15 [mem 0xf8380000000-0xf83ffffffff window]
[    6.591955] pci_bus 0000:1d: resource 16 [mem 0xf8400000000-0xf847fffffff window]
[    6.599455] pci_bus 0000:1d: resource 17 [mem 0xf8480000000-0xf84ffffffff window]
[    6.606956] pci_bus 0000:1d: resource 18 [mem 0xf8500000000-0xf857fffffff window]
[    6.614457] pci_bus 0000:1d: resource 19 [mem 0xf8580000000-0xf85ffffffff window]
[    6.621958] pci_bus 0000:1d: resource 20 [mem 0xf8600000000-0xf867fffffff window]
[    6.629459] pci_bus 0000:1d: resource 21 [mem 0xf8680000000-0xf86ffffffff window]
[    6.636960] pci_bus 0000:1d: resource 22 [mem 0xf8700000000-0xf877fffffff window]
[    6.644461] pci_bus 0000:1d: resource 23 [mem 0xf8780000000-0xf87ffffffff window]
[    6.651960] pci_bus 0000:1d: resource 24 [mem 0xf8800000000-0xf887fffffff window]
[    6.659461] pci_bus 0000:1d: resource 25 [mem 0xf8880000000-0xf88ffffffff window]
[    6.666960] pci_bus 0000:1d: resource 26 [mem 0xf8900000000-0xf897fffffff window]
[    6.674462] pci_bus 0000:1d: resource 27 [mem 0xf8980000000-0xf89ffffffff window]
[    6.681963] pci_bus 0000:1d: resource 28 [mem 0xf8a00000000-0xf8a7fffffff window]
[    6.689463] pci_bus 0000:1d: resource 29 [mem 0xf8a80000000-0xf8affffffff window]
[    6.696962] pci_bus 0000:1d: resource 30 [mem 0xf8b00000000-0xf8b7fffffff window]
[    6.704461] pci_bus 0000:1d: resource 31 [mem 0xf8b80000000-0xf8bffffffff window]
[    6.711963] pci_bus 0000:1d: resource 32 [mem 0xf8c00000000-0xf8c7fffffff window]
[    6.719463] pci_bus 0000:1d: resource 33 [mem 0xf8c80000000-0xf8cffffffff window]
[    6.726965] pci_bus 0000:1d: resource 34 [mem 0xf8d00000000-0xf8d7fffffff window]
[    6.734467] pci_bus 0000:1d: resource 35 [mem 0xf8d80000000-0xf8dffffffff window]
[    6.741966] pci_bus 0000:1d: resource 36 [mem 0xf8e00000000-0xf8e7fffffff window]
[    6.749466] pci_bus 0000:1d: resource 37 [mem 0xf8e80000000-0xf8effffffff window]
[    6.756967] pci_bus 0000:1d: resource 38 [mem 0xf8f00000000-0xf8f7fffffff window]
[    6.764467] pci_bus 0000:1d: resource 39 [mem 0xf8f80000000-0xf8fffffffff window]
[    6.772015] pci 0000:80:00.0: PCI bridge to [bus 81-85]
[    6.777271] pci 0000:86:00.0: BAR 6: assigned [mem 0xc0100000-0xc013ffff pref]
[    6.784515] pci 0000:86:00.1: BAR 6: assigned [mem 0xc0140000-0xc017ffff pref]
[    6.791756] pci 0000:80:01.0: PCI bridge to [bus 86-8a]
[    6.796999] pci 0000:80:01.0:   bridge window [io  0x8000-0x8fff]
[    6.803110] pci 0000:80:01.0:   bridge window [mem 0xc0100000-0xc01fffff]
[    6.809919] pci 0000:80:03.0: PCI bridge to [bus 8b-8f]
[    6.815170] pci 0000:90:00.0: BAR 6: assigned [mem 0xc0200000-0xc023ffff pref]
[    6.822414] pci 0000:90:00.1: BAR 6: assigned [mem 0xc0240000-0xc027ffff pref]
[    6.829655] pci 0000:80:07.0: PCI bridge to [bus 90-94]
[    6.834896] pci 0000:80:07.0:   bridge window [io  0x9000-0x9fff]
[    6.841005] pci 0000:80:07.0:   bridge window [mem 0xc0200000-0xc02fffff]
[    6.847815] pci 0000:80:09.0: PCI bridge to [bus 95-99]
[    6.853070] pci_bus 0000:80: resource 4 [io  0x8000-0xffff window]
[    6.859263] pci_bus 0000:80: resource 5 [mem 0xc0000000-0xfbffffff window]
[    6.866151] pci_bus 0000:80: resource 6 [mem 0xf9000000000-0xf907fffffff window]
[    6.873566] pci_bus 0000:80: resource 7 [mem 0xf9080000000-0xf90ffffffff window]
[    6.880982] pci_bus 0000:80: resource 8 [mem 0xf9100000000-0xf917fffffff window]
[    6.888396] pci_bus 0000:80: resource 9 [mem 0xf9180000000-0xf91ffffffff window]
[    6.895810] pci_bus 0000:80: resource 10 [mem 0xf9200000000-0xf927fffffff window]
[    6.903310] pci_bus 0000:80: resource 11 [mem 0xf9280000000-0xf92ffffffff window]
[    6.910812] pci_bus 0000:80: resource 12 [mem 0xf9300000000-0xf937fffffff window]
[    6.918311] pci_bus 0000:80: resource 13 [mem 0xf9380000000-0xf93ffffffff window]
[    6.925811] pci_bus 0000:80: resource 14 [mem 0xf9400000000-0xf947fffffff window]
[    6.933312] pci_bus 0000:80: resource 15 [mem 0xf9480000000-0xf94ffffffff window]
[    6.940813] pci_bus 0000:80: resource 16 [mem 0xf9500000000-0xf957fffffff window]
[    6.948313] pci_bus 0000:80: resource 17 [mem 0xf9580000000-0xf95ffffffff window]
[    6.955813] pci_bus 0000:80: resource 18 [mem 0xf9600000000-0xf967fffffff window]
[    6.963312] pci_bus 0000:80: resource 19 [mem 0xf9680000000-0xf96ffffffff window]
[    6.970813] pci_bus 0000:80: resource 20 [mem 0xf9700000000-0xf977fffffff window]
[    6.978313] pci_bus 0000:80: resource 21 [mem 0xf9780000000-0xf97ffffffff window]
[    6.985813] pci_bus 0000:80: resource 22 [mem 0xf9800000000-0xf987fffffff window]
[    6.993313] pci_bus 0000:80: resource 23 [mem 0xf9880000000-0xf98ffffffff window]
[    7.000815] pci_bus 0000:80: resource 24 [mem 0xf9900000000-0xf997fffffff window]
[    7.008315] pci_bus 0000:80: resource 25 [mem 0xf9980000000-0xf99ffffffff window]
[    7.015815] pci_bus 0000:80: resource 26 [mem 0xf9a00000000-0xf9a7fffffff window]
[    7.023314] pci_bus 0000:80: resource 27 [mem 0xf9a80000000-0xf9affffffff window]
[    7.030813] pci_bus 0000:80: resource 28 [mem 0xf9b00000000-0xf9b7fffffff window]
[    7.038312] pci_bus 0000:80: resource 29 [mem 0xf9b80000000-0xf9bffffffff window]
[    7.045813] pci_bus 0000:80: resource 30 [mem 0xf9c00000000-0xf9c7fffffff window]
[    7.053313] pci_bus 0000:80: resource 31 [mem 0xf9c80000000-0xf9cffffffff window]
[    7.060813] pci_bus 0000:80: resource 32 [mem 0xf9d00000000-0xf9d7fffffff window]
[    7.068314] pci_bus 0000:80: resource 33 [mem 0xf9d80000000-0xf9dffffffff window]
[    7.075815] pci_bus 0000:80: resource 34 [mem 0xf9e00000000-0xf9e7fffffff window]
[    7.083316] pci_bus 0000:80: resource 35 [mem 0xf9e80000000-0xf9effffffff window]
[    7.090817] pci_bus 0000:80: resource 36 [mem 0xf9f00000000-0xf9f7fffffff window]
[    7.098318] pci_bus 0000:80: resource 37 [mem 0xf9f80000000-0xf9fffffffff window]
[    7.105818] pci_bus 0000:86: resource 0 [io  0x8000-0x8fff]
[    7.111406] pci_bus 0000:86: resource 1 [mem 0xc0100000-0xc01fffff]
[    7.117686] pci_bus 0000:90: resource 0 [io  0x9000-0x9fff]
[    7.123273] pci_bus 0000:90: resource 1 [mem 0xc0200000-0xc02fffff]
[    7.129564] pci_bus 0000:fc: resource 4 [io  0x0000-0xffff]
[    7.135153] pci_bus 0000:fc: resource 5 [mem 0x00000000-0xfffffffffff]
[    7.141704] pci_bus 0000:fd: resource 4 [io  0x0000-0xffff]
[    7.147292] pci_bus 0000:fd: resource 5 [mem 0x00000000-0xfffffffffff]
[    7.153843] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    7.159428] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xfffffffffff]
[    7.165976] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    7.171565] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xfffffffffff]
[    7.178267] NET: Registered protocol family 2
[    7.183780] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    7.193493] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    7.200558] TCP: Hash tables configured (established 524288 bind 65536)
[    7.207563] UDP hash table entries: 65536 (order: 9, 2097152 bytes)
[    7.215015] UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
[    7.222867] NET: Registered protocol family 1
[    7.227580] pci 0000:03:00.0: Video device with shadowed ROM
[    7.233780] PCI: CLS 64 bytes, default 64
[    7.237920] Trying to unpack rootfs image as initramfs...
[    8.085618] Freeing initrd memory: 20532K (ffff88407cbf3000 - ffff88407e000000)
[    8.093356] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    8.099826] software IO TLB [mem 0x7adfc000-0x7edfc000] (64MB) mapped at [ffff88007adfc000-ffff88007edfbfff]
[    8.111079] Scanning for low memory corruption every 60 seconds
[    8.118664] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    8.125162] audit: initializing netlink subsys (disabled)
[    8.130646] audit: type=2000 audit(1453199643.155:1): initialized
[    8.138149] Initialise system trusted keyring
[    8.142884] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.153018] zbud: loaded
[    8.156045] VFS: Disk quotas dquot_6.6.0
[    8.160125] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    8.168470] fuse init (API version 7.23)
[    8.172812] Key type big_key registered
[    8.177583] Key type asymmetric registered
[    8.181703] Asymmetric key parser 'x509' registered
[    8.186715] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    8.194297] io scheduler noop registered
[    8.198245] io scheduler deadline registered (default)
[    8.203486] io scheduler cfq registered
[    8.264610] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    8.271598] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    8.278138] pci 0000:04:00.1: Signaling PME through PCIe PME interrupt
[    8.284681] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    8.291437] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    8.298415] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    8.304959] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    8.311715] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    8.318704] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[    8.325454] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[    8.332431] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[    8.339180] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    8.346154] pci 0000:18:00.0: Signaling PME through PCIe PME interrupt
[    8.352694] pci 0000:18:00.1: Signaling PME through PCIe PME interrupt
[    8.359236] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[    8.365986] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    8.372965] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    8.379717] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    8.386699] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    8.393243] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    8.399790] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    8.406544] pcieport 0000:80:00.0: Signaling PME through PCIe PME interrupt
[    8.413528] pcie_pme 0000:80:00.0:pcie01: service driver pcie_pme loaded
[    8.420280] pcieport 0000:80:01.0: Signaling PME through PCIe PME interrupt
[    8.427263] pci 0000:86:00.0: Signaling PME through PCIe PME interrupt
[    8.433809] pci 0000:86:00.1: Signaling PME through PCIe PME interrupt
[    8.440355] pcie_pme 0000:80:01.0:pcie01: service driver pcie_pme loaded
[    8.447102] pcieport 0000:80:03.0: Signaling PME through PCIe PME interrupt
[    8.454083] pcie_pme 0000:80:03.0:pcie01: service driver pcie_pme loaded
[    8.460836] pcieport 0000:80:07.0: Signaling PME through PCIe PME interrupt
[    8.467814] pci 0000:90:00.0: Signaling PME through PCIe PME interrupt
[    8.474356] pci 0000:90:00.1: Signaling PME through PCIe PME interrupt
[    8.480899] pcie_pme 0000:80:07.0:pcie01: service driver pcie_pme loaded
[    8.487647] pcieport 0000:80:09.0: Signaling PME through PCIe PME interrupt
[    8.494632] pcie_pme 0000:80:09.0:pcie01: service driver pcie_pme loaded
[    8.501360] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    8.506963] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    8.513733] efifb: probing for efifb
[    8.517384] efifb: framebuffer at 0x91000000, mapped to 0xffffc90019600000, using 1876k, total 1875k
[    8.526535] efifb: mode is 800x600x32, linelength=3200, pages=469
[    8.532639] efifb: scrolling: redraw
[    8.536232] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    8.585271] Console: switching to colour frame buffer device 100x37
[    8.633124] fb0: EFI VGA frame buffer device
[    8.637930] intel_idle: MWAIT substates: 0x120
[    8.642960] intel_idle: v0.4 model 0x2E
[    8.647261] intel_idle: lapic_timer_reliable_states 0x2
[    8.655661] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    8.663923] ACPI: Power Button [PWRF]
[    9.106796] tsc: Refined TSC clocksource calibration: 2260.963 MHz
[    9.113733] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x20972855270, max_idle_ns: 440795244217 ns
[   10.123416] clocksource: Switched to clocksource tsc
[   28.679565] ERST: Can not request [mem 0x7f2b5000-0x7f2b6bff] for ERST.
[   28.687384] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[   28.716817] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[   28.766114] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[   28.815549] serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[   28.849184] hpet_acpi_add: no address or irqs in _CRS
[   28.877601] Linux agpgart interface v0.103
[   28.926651] tpm_tis 00:03: 1.2 TPM (device-id 0xFE, rev-id 70)
[   29.068316] brd: module loaded
[   29.099560] loop: module loaded
[   29.122893] ata_piix 0000:00:1f.2: version 2.13
[   29.148494] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   29.178317] scsi host0: ata_piix
[   29.204369] scsi host1: ata_piix
[   29.227383] ata1: SATA max UDMA/133 cmd 0xef0 ctl 0xee8 bmdma 0xf00 irq 16
[   29.257214] ata2: SATA max UDMA/133 cmd 0xef8 ctl 0xeec bmdma 0xf08 irq 16
[   29.286672] libphy: Fixed MDIO Bus: probed
[   29.310730] tun: Universal TUN/TAP device driver, 1.6
[   29.335300] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   29.364372] PPP generic driver version 2.4.2
[   29.390731] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   29.417368] ehci-pci: EHCI PCI platform driver
[   29.441610] ehci-pci 0000:00:1a.7: EHCI Host Controller
[   29.468873] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   29.498298] ehci-pci 0000:00:1a.7: debug port 1
[   29.525438] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[   29.551321] ehci-pci 0000:00:1a.7: irq 19, io mem 0x902fe000
[   29.586779] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   29.612816] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   29.641601] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   29.671090] usb usb1: Product: EHCI Host Controller
[   29.695998] usb usb1: Manufacturer: Linux 4.4.0-rc2-tip-00051-gc63a5e4-dirty ehci_hcd
[   29.722781] usb usb1: SerialNumber: 0000:00:1a.7
[   29.748657] hub 1-0:1.0: USB hub found
[   29.773842] hub 1-0:1.0: 6 ports detected
[   29.796314] ehci-pci 0000:00:1d.7: EHCI Host Controller
[   29.820349] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   29.848244] ehci-pci 0000:00:1d.7: debug port 1
[   29.876705] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[   29.903514] ehci-pci 0000:00:1d.7: irq 17, io mem 0x902ff000
[   29.938708] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   29.962393] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   29.985516] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   30.009715] usb usb2: Product: EHCI Host Controller
[   30.033951] usb usb2: Manufacturer: Linux 4.4.0-rc2-tip-00051-gc63a5e4-dirty ehci_hcd
[   30.060714] usb usb2: SerialNumber: 0000:00:1d.7
[   30.082328] hub 2-0:1.0: USB hub found
[   30.105951] hub 2-0:1.0: 6 ports detected
[   30.128206] ehci-platform: EHCI generic platform driver
[   30.134770] usb 1-1: new high-speed USB device number 2 using ehci-pci
[   30.177657] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   30.204150] ohci-pci: OHCI PCI platform driver
[   30.226271] ohci-platform: OHCI generic platform driver
[   30.250428] uhci_hcd: USB Universal Host Controller Interface driver
[   30.271394] usb 1-1: New USB device found, idVendor=0624, idProduct=0201
[   30.271397] usb 1-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[   30.271400] usb 1-1: Product: Virtual Media KVM Module
[   30.271402] usb 1-1: Manufacturer: Avocent
[   30.271405] usb 1-1: SerialNumber: 130430041D2
[   30.334765] ata2.00: failed to resume link (SControl 0)
[   30.423797] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   30.449238] usb 2-1: new high-speed USB device number 2 using ehci-pci
[   30.475110] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   30.500678] uhci_hcd 0000:00:1a.0: detected 2 ports
[   30.524287] uhci_hcd 0000:00:1a.0: irq 17, io base 0x00000f20
[   30.550864] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   30.577777] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   30.603259] usb usb3: Product: UHCI Host Controller
[   30.627785] usb usb3: Manufacturer: Linux 4.4.0-rc2-tip-00051-gc63a5e4-dirty uhci_hcd
[   30.627788] usb usb3: SerialNumber: 0000:00:1a.0
[   30.628373] hub 3-0:1.0: USB hub found
[   30.628385] hub 3-0:1.0: 2 ports detected
[   30.629019] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   30.629031] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   30.629043] uhci_hcd 0000:00:1a.1: detected 2 ports
[   30.629096] uhci_hcd 0000:00:1a.1: irq 18, io base 0x00000f40
[   30.629185] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   30.629188] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   30.629190] usb usb4: Product: UHCI Host Controller
[   30.629192] usb usb4: Manufacturer: Linux 4.4.0-rc2-tip-00051-gc63a5e4-dirty uhci_hcd
[   30.629195] usb usb4: SerialNumber: 0000:00:1a.1
[   30.629447] hub 4-0:1.0: USB hub found
[   30.629457] hub 4-0:1.0: 2 ports detected
[   30.630031] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   30.630046] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[   30.630063] uhci_hcd 0000:00:1a.2: detected 2 ports
[   30.630100] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00000f60
[   30.630181] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   30.630184] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   30.630186] usb usb5: Product: UHCI Host Controller
[   30.630189] usb usb5: Manufacturer: Linux 4.4.0-rc2-tip-00051-gc63a5e4-dirty uhci_hcd
[   30.630191] usb usb5: SerialNumber: 0000:00:1a.2
[   30.630439] hub 5-0:1.0: USB hub found
[   30.630450] hub 5-0:1.0: 2 ports detected
[   30.631066] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   30.631083] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[   30.631095] uhci_hcd 0000:00:1d.0: detected 2 ports
[   30.631131] uhci_hcd 0000:00:1d.0: irq 17, io base 0x00000f80
[   30.631213] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   30.631215] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   30.631218] usb usb6: Product: UHCI Host Controller
[   30.631220] usb usb6: Manufacturer: Linux 4.4.0-rc2-tip-00051-gc63a5e4-dirty uhci_hcd
[   30.631223] usb usb6: SerialNumber: 0000:00:1d.0
[   30.631477] hub 6-0:1.0: USB hub found
[   30.631492] hub 6-0:1.0: 2 ports detected
[   30.632055] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   30.632067] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[   30.632079] uhci_hcd 0000:00:1d.1: detected 2 ports
[   30.632113] uhci_hcd 0000:00:1d.1: irq 18, io base 0x00000fa0
[   30.632200] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   30.632203] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   30.632206] usb usb7: Product: UHCI Host Controller
[   30.632208] usb usb7: Manufacturer: Linux 4.4.0-rc2-tip-00051-gc63a5e4-dirty uhci_hcd
[   30.632210] usb usb7: SerialNumber: 0000:00:1d.1
[   30.632462] hub 7-0:1.0: USB hub found
[   30.632476] hub 7-0:1.0: 2 ports detected
[   30.633048] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   30.633059] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   30.633072] uhci_hcd 0000:00:1d.2: detected 2 ports
[   30.633106] uhci_hcd 0000:00:1d.2: irq 19, io base 0x00000fc0
[   30.633195] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   30.633198] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   30.633201] usb usb8: Product: UHCI Host Controller
[   30.633203] usb usb8: Manufacturer: Linux 4.4.0-rc2-tip-00051-gc63a5e4-dirty uhci_hcd
[   30.633205] usb usb8: SerialNumber: 0000:00:1d.2
[   30.633464] hub 8-0:1.0: USB hub found
[   30.633474] hub 8-0:1.0: 2 ports detected
[   30.633919] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   30.678774] ata1.01: failed to resume link (SControl 0)
[   30.708568] usb 2-1: New USB device found, idVendor=04b3, idProduct=4012
[   30.708571] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   30.708574] usb 2-1: Product: IBM Composite Device-0
[   30.708576] usb 2-1: Manufacturer: IBM
[   30.708579] usb 2-1: SerialNumber: 20070221-7
[   30.835263] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   30.835371] ata1.01: SATA link down (SStatus 0 SControl 0)
[   30.835445] ata1.01: link offline, clearing class 3 to NONE
[   30.843774] ata1.00: ATAPI: MATSHITADVD-RAM UJ890, SAA4, max UDMA/100
[   30.859160] ata1.00: configured for UDMA/100
[   30.864391] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ890    SAA4 PQ: 0 ANSI: 5
[   30.881913] sr 0:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   30.881917] cdrom: Uniform CD-ROM driver Revision: 3.20
[   30.882175] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   30.882332] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   30.882955] serio: i8042 KBD port at 0x60,0x64 irq 1
[   30.883277] mousedev: PS/2 mouse device common for all mice
[   30.883637] rtc_cmos 00:04: RTC can wake from S4
[   30.883947] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[   30.883999] rtc_cmos 00:04: alarms up to one month, y3k, 242 bytes nvram
[   30.884019] i2c /dev entries driver
[   30.884131] device-mapper: uevent: version 1.0.3
[   30.884345] device-mapper: ioctl: 4.34.0-ioctl (2015-10-28) initialised: dm-devel@redhat.com
[   30.884410] ledtrig-cpu: registered to indicate activity on CPUs
[   30.884420] EFI Variables Facility v0.08 2004-May-17
[   31.074807] usb 6-2: new full-speed USB device number 2 using uhci_hcd
[   31.246965] usb 6-2: New USB device found, idVendor=04b3, idProduct=4010
[   31.246969] usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   31.246972] usb 6-2: Product: RNDIS/CDC ETHER
[   31.246974] usb 6-2: Manufacturer: IBM
[   31.366832] ata2.01: failed to resume link (SControl 0)
[   31.387317] ata2.00: SATA link down (SStatus 0 SControl 0)
[   31.387551] ata2.01: SATA link down (SStatus 0 SControl 0)
[   31.546816] NET: Registered protocol family 10
[   31.547529] NET: Registered protocol family 17
[   31.547551] Key type dns_resolver registered
[   31.550568] registered taskstats version 1
[   31.550606] Loading compiled-in X.509 certificates
[   31.553074] Loaded X.509 cert 'Build time autogenerated kernel key: 584145b4d4d767a4b0a1a690aff3998c4e385fd5'
[   31.553166] zswap: loaded using pool lzo/zbud
[   31.557780] Key type trusted registered
[   31.566457] Key type encrypted registered
[   31.566471] AppArmor: AppArmor sha1 policy hashing enabled
[   31.803616] evm: HMAC attrs: 0x1
[   31.806110]   Magic number: 0:485:578
[   31.806214] platform pcspkr: hash matches
[   31.826282] rtc_cmos 00:04: setting system clock to 2016-01-19 10:34:29 UTC (1453199669)
[   31.904201] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   31.904201] EDD information not available.
[   31.904294] PM: Hibernation image not present or could not be loaded.
[   33.370035] Freeing unused kernel memory: 1464K (ffffffff81d4e000 - ffffffff81ebc000)
[   33.398534] Write protecting the kernel read-only data: 12288k
[   33.431923] Freeing unused kernel memory: 316K (ffff88407e7b1000 - ffff88407e800000)
[   33.464288] Freeing unused kernel memory: 212K (ffff88407ebcb000 - ffff88407ec00000)
[   33.515868] random: systemd-udevd urandom read with 59 bits of entropy available
[   33.600256] megasas: 06.808.16.00-rc1
[   33.600430] bnx2: QLogic bnx2 Gigabit Ethernet Driver v2.2.6 (January 29, 2014)
[   33.601090] bnx2 0000:04:00.0 eth0: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem 94000000, IRQ 31, node addr e4:1f:13:c5:33:5c
[   33.601903] bnx2 0000:04:00.1 eth1: Broadcom NetXtreme II BCM5709 1000Base-T (C0) PCI Express found at mem 92000000, IRQ 37, node addr e4:1f:13:c5:33:5e
[   33.759777] megaraid_sas 0000:09:00.0: Waiting for FW to come to ready state
[   33.800239] hidraw: raw HID events driver (C) Jiri Kosina
[   33.808126] megaraid_sas 0000:09:00.0: FW now in Ready state
[   33.808343] megaraid_sas 0000:09:00.0: firmware supports msix	: (0)
[   33.808345] megaraid_sas 0000:09:00.0: current msix/online cpus	: (1/32)
[   33.914627] megaraid_sas 0000:09:00.0: controller type	: MR(512MB)
[   33.941664] megaraid_sas 0000:09:00.0: Online Controller Reset(OCR)	: Enabled
[   33.942013] usb-storage 1-1:1.2: USB Mass Storage device detected
[   33.942430] scsi host3: usb-storage 1-1:1.2
[   33.942570] usbcore: registered new interface driver usb-storage
[   34.002362] bnx2 0000:04:00.0 em1: renamed from eth0
[   34.084685] megaraid_sas 0000:09:00.0: Secure JBOD support	: No
[   34.116163] megaraid_sas 0000:09:00.0: megasas_init_mfi: fw_support_ieee=0
[   34.147976] megaraid_sas 0000:09:00.0: INIT adapter done
[   34.176829] megaraid_sas 0000:09:00.0: Jbod map is not supported megasas_setup_jbod_map 4612
[   34.214708] usbcore: registered new interface driver usbhid
[   34.241200] usbhid: USB HID core driver
[   34.259615] megaraid_sas 0000:09:00.0: pci id		: (0x1000)/(0x0079)/(0x1014)/(0x03b2)
[   34.259616] megaraid_sas 0000:09:00.0: unevenspan support	: no
[   34.259617] megaraid_sas 0000:09:00.0: firmware crash dump	: no
[   34.259619] megaraid_sas 0000:09:00.0: jbod sync map		: no
[   34.259621] scsi host2: Avago SAS based MegaRAID driver
[   34.388623] bnx2 0000:04:00.1 em2: renamed from eth1
[   34.447758] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.26-k.
[   34.480410] qla2xxx [0000:86:00.0]-001d: : Found an ISP2532 irq 38 iobase 0xffffc90018986000.
[   34.522602] input: Avocent Virtual Media KVM Module as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.0/0003:0624:0201.0001/input/input3
[   34.588898] usbcore: registered new interface driver uas
[   34.624994] be2net 0000:18:00.0: be2net version is 10.6.0.3
[   34.656559] hid-generic 0003:0624:0201.0001: input,hidraw0: USB HID v1.10 Keyboard [Avocent Virtual Media KVM Module] on usb-0000:00:1a.7-1/input0
[   34.656713] be2net 0000:18:00.0: PCIe error reporting enabled
[   34.747619] input: Avocent Virtual Media KVM Module as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/1-1:1.1/0003:0624:0201.0002/input/input4
[   34.799363] scsi host4: qla2xxx
[   34.800457] qla2xxx [0000:86:00.0]-00fb:4: QLogic QLE2562 - QLogic 8Gb FC Dual-port HBA for System x.
[   34.800463] qla2xxx [0000:86:00.0]-00fc:4: ISP2532: PCIe (5.0GT/s x8) @ 0000:86:00.0 hdma+ host#=4 fw=7.03.00 (90d5).
[   34.800699] qla2xxx [0000:86:00.1]-001d: : Found an ISP2532 irq 42 iobase 0xffffc90018a4e000.
[   34.911335] be2net 0000:18:00.0: FW config: function_mode=0x203, function_caps=0x7
[   34.942255] scsi 3:0:0:0: CD-ROM            KVM      vmDisk-CD        0.01 PQ: 0 ANSI: 0
[   35.011300] be2net 0000:18:00.0: Max: txqs 1, rxqs 5, rss 4, eqs 16, vfs 0
[   35.011301] be2net 0000:18:00.0: Max: uc-macs 30, mc-macs 64, vlans 64
[   35.011513] be2net 0000:18:00.0: enabled 4 MSI-x vector(s) for NIC
[   35.083453] scsi host5: qla2xxx
[   35.084494] qla2xxx [0000:86:00.1]-00fb:5: QLogic QLE2562 - QLogic 8Gb FC Dual-port HBA for System x.
[   35.084500] qla2xxx [0000:86:00.1]-00fc:5: ISP2532: PCIe (5.0GT/s x8) @ 0000:86:00.1 hdma+ host#=5 fw=7.03.00 (90d5).
[   35.084864] qla2xxx [0000:90:00.0]-001d: : Found an ISP2532 irq 38 iobase 0xffffc90018ac4000.
[   35.199351] be2net 0000:18:00.0: created 1 TX queue(s)
[   35.319283] be2net 0000:18:00.0: created 5 RX queue(s)
[   35.367310] be2net 0000:18:00.0: Upgrade to F/W ver 2.102.235.0 or newer to avoid conflicting priorities between NIC and FCoE traffic
[   35.395466] scsi host6: qla2xxx
[   35.396424] qla2xxx [0000:90:00.0]-00fb:6: QLogic QLE2562 - QLogic 8Gb FC Dual-port HBA for System x.
[   35.396429] qla2xxx [0000:90:00.0]-00fc:6: ISP2532: PCIe (5.0GT/s x8) @ 0000:90:00.0 hdma+ host#=6 fw=7.03.00 (90d5).
[   35.396742] qla2xxx [0000:90:00.1]-001d: : Found an ISP2532 irq 38 iobase 0xffffc90018ad2000.
[   35.420077] be2net 0000:18:00.0: FW version is 2.101.411.2
[   35.420079] be2net 0000:18:00.0: Firmware on card is old(2.101.411.2), IRQs may not work
[   35.420081] be2net 0000:18:00.0: Please upgrade firmware to version >= 4.0
[   35.428685] be2net 0000:18:00.0: HW Flow control - TX:1 RX:1
[   35.440727] be2net 0000:18:00.0: Emulex OneConnect: PF  port 0
[   35.441006] be2net 0000:18:00.1: be2net version is 10.6.0.3
[   35.441665] be2net 0000:18:00.1: PCIe error reporting enabled
[   35.683657] scsi host7: qla2xxx
[   35.684742] qla2xxx [0000:90:00.1]-00fb:7: QLogic QLE2562 - QLogic 8Gb FC Dual-port HBA for System x.
[   35.684747] qla2xxx [0000:90:00.1]-00fc:7: ISP2532: PCIe (5.0GT/s x8) @ 0000:90:00.1 hdma+ host#=7 fw=7.03.00 (90d5).
[   35.715451] be2net 0000:18:00.1: FW config: function_mode=0x203, function_caps=0x7
[   35.815395] be2net 0000:18:00.1: Max: txqs 1, rxqs 5, rss 4, eqs 16, vfs 0
[   35.815396] be2net 0000:18:00.1: Max: uc-macs 30, mc-macs 64, vlans 64
[   35.815589] be2net 0000:18:00.1: enabled 4 MSI-x vector(s) for NIC
[   35.975379] be2net 0000:18:00.1: created 1 TX queue(s)
[   36.103389] be2net 0000:18:00.1: created 5 RX queue(s)
[   36.159440] be2net 0000:18:00.1: Upgrade to F/W ver 2.102.235.0 or newer to avoid conflicting priorities between NIC and FCoE traffic
[   36.208169] be2net 0000:18:00.1: FW version is 2.101.411.2
[   36.208171] be2net 0000:18:00.1: Firmware on card is old(2.101.411.2), IRQs may not work
[   36.208172] be2net 0000:18:00.1: Please upgrade firmware to version >= 4.0
[   36.216756] be2net 0000:18:00.1: HW Flow control - TX:1 RX:1
[   36.228731] be2net 0000:18:00.1: Emulex OneConnect: PF  port 1
[   36.389348] be2net 0000:18:00.0 p7p1: renamed from eth0
[   36.538911] be2net 0000:18:00.1 p7p2: renamed from eth1
[   36.567035] hid-generic 0003:0624:0201.0002: input,hidraw1: USB HID v1.10 Mouse [Avocent Virtual Media KVM Module] on usb-0000:00:1a.7-1/input1
[   36.628546] input: IBM IBM Composite Device-0 as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:2.0/0003:04B3:4012.0003/input/input5
[   36.739285] hid-generic 0003:04B3:4012.0003: input,hidraw2: USB HID v1.00 Keyboard [IBM IBM Composite Device-0] on usb-0000:00:1d.7-1/input0
[   36.799785] input: IBM IBM Composite Device-0 as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:2.1/0003:04B3:4012.0004/input/input6
[   36.861424] hid-generic 0003:04B3:4012.0004: input,hidraw3: USB HID v1.00 Mouse [IBM IBM Composite Device-0] on usb-0000:00:1d.7-1/input1
[   36.926182] input: IBM IBM Composite Device-0 as /devices/pci0000:00/0000:00:1d.7/usb2/2-1/2-1:2.2/0003:04B3:4012.0005/input/input7
[   36.992081] hid-generic 0003:04B3:4012.0005: input,hidraw4: USB HID v1.00 Mouse [IBM IBM Composite Device-0] on usb-0000:00:1d.7-1/input2
[   37.062295] scsi 2:2:1:0: Direct-Access     IBM      ServeRAID M5015  2.12 PQ: 0 ANSI: 5
[   37.098480] scsi 2:2:2:0: Direct-Access     IBM      ServeRAID M5015  2.12 PQ: 0 ANSI: 5
[   37.224367] sd 2:2:1:0: [sda] 1167966208 512-byte logical blocks: (597 GB/556 GiB)
[   37.224383] sd 2:2:1:0: Attached scsi generic sg1 type 0
[   37.224669] sd 2:2:2:0: Attached scsi generic sg2 type 0
[   37.322438] sd 2:2:2:0: [sdb] 1751949312 512-byte logical blocks: (896 GB/835 GiB)
[   37.322510] sd 2:2:1:0: [sda] Write Protect is off
[   37.322512] sd 2:2:1:0: [sda] Mode Sense: 1f 00 00 08
[   37.322570] sd 2:2:1:0: [sda] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
[   37.349955]  sda: sda1 sda2 sda3
[   37.351623] sd 2:2:1:0: [sda] Attached SCSI disk
[   37.535608] sd 2:2:2:0: [sdb] Write Protect is off
[   37.568067] sd 2:2:2:0: [sdb] Mode Sense: 1f 00 00 08
[   37.600304] sd 2:2:2:0: [sdb] Write cache: enabled, read cache: disabled, doesn't support DPO or FUA
[   37.664243]  sdb: sdb1 sdb2 sdb3 sdb4 sdb5 sdb6 sdb7 sdb8
[   37.697124] sd 2:2:2:0: [sdb] Attached SCSI disk
[   37.728054] random: nonblocking pool is initialized
[   38.281438] EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
[   38.313792] EXT4-fs (dm-0): write access will be enabled during recovery
[   39.576660] EXT4-fs (dm-0): recovery complete
[   39.636016] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[   39.808163] sr 3:0:0:0: [sr1] scsi3-mmc drive: 0x/0x caddy
[   39.839288] sr 3:0:0:0: Attached scsi CD-ROM sr1
[   39.870304] sr 3:0:0:0: Attached scsi generic sg3 type 5
[   41.170658] autofs4: module verification failed: signature and/or required key missing - tainting kernel
[   41.239472] systemd[1]: Inserted module 'autofs4'
[   42.027837] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT -GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID -ELFUTILS +KMOD -IDN)
[   42.117363] systemd[1]: Detected architecture x86-64.
[   42.163115] systemd[1]: Set hostname to <x3850x5>.
[   42.828122] systemd[1]: Cannot add dependency job for unit gssproxy.service, ignoring: Unit gssproxy.service failed to load: No such file or directory.
[   42.885245] systemd[1]: Cannot add dependency job for unit nfs-blkmap.service, ignoring: Unit nfs-blkmap.service failed to load: No such file or directory.
[   42.945113] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
[   43.018825] systemd[1]: Reached target Encrypted Volumes.
[   43.049212] systemd[1]: Starting Encrypted Volumes.
[   43.086771] systemd[1]: Created slice Root Slice.
[   43.117212] systemd[1]: Starting Root Slice.
[   43.158775] systemd[1]: Listening on fsck to fsckd communication Socket.
[   43.189937] systemd[1]: Starting fsck to fsckd communication Socket.
[   43.230841] systemd[1]: Created slice User and Session Slice.
[   43.261269] systemd[1]: Starting User and Session Slice.
[   43.306823] systemd[1]: Listening on LVM2 metadata daemon socket.
[   43.335587] systemd[1]: Starting LVM2 metadata daemon socket.
[   43.378780] systemd[1]: Listening on Journal Audit Socket.
[   43.406176] systemd[1]: Starting Journal Audit Socket.
[   43.435994] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[   43.469062] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[   43.514805] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[   43.544345] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[   43.586849] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[   43.644284] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[   43.686810] systemd[1]: Listening on Delayed Shutdown Socket.
[   43.717589] systemd[1]: Starting Delayed Shutdown Socket.
[   43.758808] systemd[1]: Created slice System Slice.
[   43.789327] systemd[1]: Starting System Slice.
[   43.830810] systemd[1]: Created slice system-getty.slice.
[   43.860859] systemd[1]: Starting system-getty.slice.
[   43.898778] systemd[1]: Reached target Slices.
[   43.927102] systemd[1]: Starting Slices.
[   43.982782] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[   44.009184] systemd[1]: Starting Device-mapper event daemon FIFOs.
[   44.046841] systemd[1]: Listening on Journal Socket.
[   44.072569] systemd[1]: Starting Journal Socket.
[   44.122967] systemd[1]: Started Read required files in advance.
[   44.150737] systemd[1]: Starting Read required files in advance...
[   44.206862] systemd[1]: Starting Nameserver information manager...
[   44.243392] systemd[1]: Mounting POSIX Message Queue File System...
[   44.279823] systemd[1]: Mounting Debug File System...
[   44.315840] systemd[1]: Mounting RPC Pipe File System...
[   44.351694] systemd[1]: Mounting Huge Pages File System...
[   44.403066] systemd[1]: Starting Setup Virtual Console...
[   44.455842] RPC: Registered named UNIX socket transport module.
[   44.468262] systemd[1]: Starting Load Kernel Modules...
[   44.501944] RPC: Registered udp transport module.
[   44.501945] RPC: Registered tcp transport module.
[   44.501945] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   44.603054] systemd[1]: Starting Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling...
[   44.659693] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[   44.743109] systemd[1]: Starting Uncomplicated firewall...
[   44.791639] systemd[1]: Started Set Up Additional Binary Formats.
[   44.817908] systemd[1]: Started Kernel Module supporting RPCSEC_GSS.
[   44.858808] systemd[1]: Listening on Journal Socket (/dev/log).
[   44.883847] systemd[1]: Starting Journal Socket (/dev/log).
[   44.922816] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[   44.949774] systemd[1]: Starting system-systemd\x2dfsck.slice.
[   44.986794] systemd[1]: Listening on udev Control Socket.
[   45.011670] systemd[1]: Starting udev Control Socket.
[   45.046886] systemd[1]: Starting Increase datagram queue length...
[   45.094907] systemd[1]: Created slice system-serial\x2dgetty.slice.
[   45.118107] systemd[1]: Starting system-serial\x2dgetty.slice.
[   45.154959] systemd[1]: Listening on udev Kernel Socket.
[   45.178907] systemd[1]: Starting udev Kernel Socket.
[   45.218824] systemd[1]: Starting udev Coldplug all Devices...
[   45.274838] systemd[1]: Mounted RPC Pipe File System.
[   45.314833] systemd[1]: Mounted Huge Pages File System.
[   45.350971] systemd[1]: Mounted POSIX Message Queue File System.
[   45.386943] systemd[1]: Mounted Debug File System.
[   45.446874] systemd[1]: Started Setup Virtual Console.
[   45.478934] systemd[1]: Started Load Kernel Modules.
[   45.518908] systemd[1]: Started Create list of required static device nodes for the current kernel.
[   45.574865] systemd[1]: Started Uncomplicated firewall.
[   45.611021] systemd[1]: Started Increase datagram queue length.
[   45.650870] systemd[1]: Started Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling.
[   45.722996] systemd[1]: Started Nameserver information manager.
[   45.759186] systemd[1]: Started udev Coldplug all Devices.
[   45.855206] systemd[1]: Starting udev Wait for Complete Device Initialization...
[   45.898866] systemd[1]: Listening on Syslog Socket.
[   45.921319] systemd[1]: Starting Syslog Socket.
[   45.943399] systemd[1]: Starting Journal Service...
[   45.975704] systemd[1]: Starting Create Static Device Nodes in /dev...
[   46.011213] systemd[1]: Mounted Configuration File System.
[   46.032941] systemd[1]: Starting Apply Kernel Variables...
[   46.063740] systemd[1]: Mounting FUSE Control File System...
[   46.107419] systemd[1]: Mounted FUSE Control File System.
[   46.139363] systemd[1]: Started Apply Kernel Variables.
[   46.195196] systemd[1]: Started Create Static Device Nodes in /dev.
[   46.227014] systemd[1]: Started Journal Service.
[   46.876372] wmi: Mapper loaded
[   46.899380] ipmi message handler version 39.2
[   46.925002] dca service started, version 1.12.1
[   46.925240] EDAC MC: Ver: 3.0.0
[   46.968341] ACPI Warning: SystemIO range 0x00000000000005A8-0x00000000000005AF conflicts with OpRegion 0x00000000000005A8-0x00000000000005AF (\_SB_.PCI0.LPC0.GPE0) (20150930/utaddress-254)
[   46.971940] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   46.972032] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   47.135633] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   47.179610] IPMI System Interface driver.
[   47.203326] ipmi_si: probing via SMBIOS
[   47.228429] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
[   47.254300] ipmi_si: Adding SMBIOS-specified kcs state machine
[   47.278582] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o address 0xca2, slave address 0x20, irq 0
[   47.287601] cdc_ether 6-2:1.0 usb0: register 'cdc_ether' at usb-0000:00:1d.0-2, CDC Ethernet Device, e6:1f:13:c5:93:5f
[   47.287626] usbcore: registered new interface driver cdc_ether
[   47.435242] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   47.464553] ------------[ cut here ]------------
[   47.493773] WARNING: CPU: 0 PID: 4 at ../drivers/dma/ioat/dca.c:342 ioat_dca_init+0x17e/0x1a0 [ioatdma]()
[   47.546777] ioatdma 0000:00:16.0: APICID_TAG_MAP set incorrectly by BIOS, disabling DCA
[   47.577048] Modules linked in: cdc_ether(E) usbnet(E) kvm(E+) mii(E) i7core_edac(E) irqbypass(E) ioatdma(E+) serio_raw(E) joydev(E) ipmi_si(E+) lpc_ich(E) edac_core(E) shpchp(E) dca(E) mac_hid(E) 8250_fintek(E) ipmi_msghandler(E) wmi(E) sunrpc(E) autofs4(E) be2net hid_generic uas psmouse usbhid qla2xxx vxlan ip6_udp_tunnel hid scsi_transport_fc usb_storage pata_acpi megaraid_sas bnx2 udp_tunnel
[   47.577051] CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G            E   4.4.0-rc2-tip-00051-gc63a5e4-dirty #157
[   47.577052] Hardware name: IBM System x3850 X5 -[71455RQ]-/Node 1, Processor Card, BIOS -[G0E177AUS-1.77]- 11/18/2012
[   47.577059] Workqueue: events work_for_cpu_fn
[   47.577061]  ffffffffc0541841 ffff88103977bc38 ffffffff813a14a4 ffff88103977bc80
[   47.577063]  ffff88103977bc70 ffffffff810781e6 ffff8820391d2000 ffff88203918e290
[   47.577064]  ffff8810384bd480 ffffc90018a68100 0000000000000100 ffff88103977bcd0
[   47.577065] Call Trace:
[   47.577075]  [<ffffffff813a14a4>] dump_stack+0x44/0x60
[   47.577079]  [<ffffffff810781e6>] warn_slowpath_common+0x86/0xc0
[   47.577081]  [<ffffffff810782b4>] warn_slowpath_fmt_taint+0x44/0x50
[   47.577085]  [<ffffffffc054017e>] ioat_dca_init+0x17e/0x1a0 [ioatdma]
[   47.577089]  [<ffffffffc053c0cc>] ioat_pci_probe+0x9ac/0xf20 [ioatdma]
[   47.577094]  [<ffffffff813ee8b5>] local_pci_probe+0x45/0xa0
[   47.577095]  [<ffffffff8108cc94>] work_for_cpu_fn+0x14/0x20
[   47.577099]  [<ffffffff8108fea7>] process_one_work+0x157/0x3e0
[   47.577101]  [<ffffffff810909fd>] worker_thread+0x1bd/0x470
[   47.577103]  [<ffffffff81090840>] ? rescuer_thread+0x300/0x300
[   47.577106]  [<ffffffff81095b39>] kthread+0xc9/0xe0
[   47.577108]  [<ffffffff81095a70>] ? kthread_park+0x60/0x60
[   47.577114]  [<ffffffff817a9e8f>] ret_from_fork+0x3f/0x70
[   47.577118]  [<ffffffff81095a70>] ? kthread_park+0x60/0x60
[   47.577119] ---[ end trace e2fe1ab6f806c9b1 ]---
[   47.834382] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x000002, prod_id: 0x00fa, dev_id: 0x20)
[   47.834396] ipmi_si ipmi_si.0: IPMI kcs interface initialized
[   47.933185] gpio_ich: GPIO from 451 to 511 on gpio_ich
[   48.314983] IPMI SSIF Interface driver
[   48.468511] ipmi device interface
[   48.525601] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[   48.630013] Adding 8388604k swap on /dev/sdb5.  Priority:-1 extents:1 across:8388604k FS
[   48.657079] Adding 4194300k swap on /dev/sdb6.  Priority:-2 extents:1 across:4194300k FS
[   48.657091] Adding 268414972k swap on /dev/mapper/x3850x5--vg-swap_1.  Priority:-3 extents:1 across:268414972k FS
[   50.072946] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro
[   50.268223] ISO 9660 Extensions: Microsoft Joliet Level 3
[   50.328422] ISO 9660 Extensions: RRIP_1991A
[   50.340039] systemd-journald[1060]: Received request to flush runtime journal from PID 1
[   51.002871] EXT4-fs (sda2): mounting ext2 file system using the ext4 subsystem
[   51.033266] EXT4-fs (sda2): mounted filesystem without journal. Opts: (null)
[   51.224575] ifquery[1288]: segfault at 1 ip 00000000004031c8 sp 00007ffee8225ee0 error 4 in ifup[400000+d000]
[   51.233328] potentially unexpected fatal signal 11.
[   51.233331] CPU: 26 PID: 1288 Comm: ifquery Tainted: G          I E   4.4.0-rc2-tip-00051-gc63a5e4-dirty #157
[   51.233334] Hardware name: IBM System x3850 X5 -[71455RQ]-/Node 1, Processor Card, BIOS -[G0E177AUS-1.77]- 11/18/2012
[   51.233335] task: ffff88407db33200 ti: ffff884034a68000 task.ti: ffff884034a68000
[   51.233338] RIP: 0033:[<00000000004031c8>]  [<00000000004031c8>] 0x4031c8
[   51.233338] RSP: 002b:00007ffee8225ee0  EFLAGS: 00010202
[   51.233339] RAX: 000000006cfa0dc8 RBX: 0000000000000001 RCX: fffffffffffffffb
[   51.233340] RDX: 00007ffee8226458 RSI: 00007f206d354c58 RDI: 00007ffee8226f91
[   51.233341] RBP: 0000000000000003 R08: 00007ffee8226f8d R09: 0000000000000001
[   51.233342] R10: 00000000000008a5 R11: 0000000000000246 R12: 0000000000000000
[   51.233343] R13: 0000000000000000 R14: 00007ffee8226000 R15: 0000000000000001
[   51.233344] FS:  00007f206d56d700(0000) GS:ffff88407fc80000(0000) knlGS:0000000000000000
[   51.233345] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   51.233345] CR2: 0000000000000001 CR3: 000000403435d000 CR4: 00000000000006e0

[   51.830408] audit: type=1400 audit(1453199689.519:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=1322 comm="apparmor_parser"
[   51.893976] audit: type=1400 audit(1453199689.583:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1322 comm="apparmor_parser"
[   51.963166] audit: type=1400 audit(1453199689.655:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=1322 comm="apparmor_parser"
[   52.032155] audit: type=1400 audit(1453199689.723:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=1322 comm="apparmor_parser"
[   52.100711] audit: type=1400 audit(1453199689.791:6): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=1322 comm="apparmor_parser"
[   52.500452] bnx2 0000:04:00.1 em2: using MSIX
[   52.533851] IPv6: ADDRCONF(NETDEV_UP): em2: link is not ready
[   55.795028] bnx2 0000:04:00.1 em2: NIC Copper Link is Up, 1000 Mbps full duplex
[   55.803088] , receive & transmit flow control ON
[   55.808389] IPv6: ADDRCONF(NETDEV_CHANGE): em2: link becomes ready
[   56.035820] qla2xxx [0000:86:00.0]-8038:4: Cable is unplugged...
[   56.319821] qla2xxx [0000:86:00.1]-8038:5: Cable is unplugged...
[   56.631816] qla2xxx [0000:90:00.0]-8038:6: Cable is unplugged...
[   56.895824] qla2xxx [0000:90:00.1]-8038:7: Cable is unplugged...

>  	/*
>  	 * We can share all PGD entries apart from the one entry that
>  	 * covers the EFI runtime mapping space.
> 
> Do either of those modifications make your kernel boot when you apply
> the patch I sent on Friday? If so, which one? I'm struggling to find
> hardware that's similar enough to reproduce this.
> 

-- 
Thanks and Regards
Srikar Dronamraju
