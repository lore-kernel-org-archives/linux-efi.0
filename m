From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [PATCH 0/2] ESRT fixes for relocatable kexec'd kernel
Date: Fri, 2 Mar 2018 14:53:27 +0900
Message-ID: <20180302055325.GQ6019@linaro.org>
References: <1519414953-5478-1-git-send-email-tbaicar@codeaurora.org>
 <20180228061901.GJ6019@linaro.org>
 <1f03865f-2d22-8ba1-a276-a6b49d7c14de@codeaurora.org>
 <20180301025026.GK6019@linaro.org>
 <7cd3f462-c619-9d82-73a0-2f3bc9de095e@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7cd3f462-c619-9d82-73a0-2f3bc9de095e@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, sgoel@codeaurora.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

Tyler, Jeffrey,

[Note: This issue takes place in kexec, not kdump. So to be precise,
it is not the same phenomenon as what I addressed in [1],[2]:
  [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-February/557254.html
  [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-January/553098.html
]

On Thu, Mar 01, 2018 at 12:56:38PM -0500, Tyler Baicar wrote:
> Hello,
> 
> On 2/28/2018 9:50 PM, AKASHI Takahiro wrote:
> >Hi,
> >
> >On Wed, Feb 28, 2018 at 08:39:42AM -0700, Jeffrey Hugo wrote:
> >>On 2/27/2018 11:19 PM, AKASHI Takahiro wrote:
> >>>Tyler,
> >>>
> >>># I missed catching your patch as its subject doesn't contain arm64.
> >>>
> >>>On Fri, Feb 23, 2018 at 12:42:31PM -0700, Tyler Baicar wrote:
> >>>>Currently on arm64 ESRT memory does not appear to be properly blocked off.
> >>>>Upon successful initialization, ESRT prints out the memory region that it
> >>>>exists in like:
> >>>>
> >>>>esrt: Reserving ESRT space from 0x000000000a4c1c18 to 0x000000000a4c1cf0.
> >>>>
> >>>>But then by dumping /proc/iomem this region appears as part of System RAM
> >>>>rather than being reserved:
> >>>>
> >>>>08f10000-0deeffff : System RAM
> >>>>
> >>>>This causes issues when trying to kexec if the kernel is relocatable. When
> >>>>kexec tries to execute, this memory can be selected to relocate the kernel to
> >>>>which then overwrites all the ESRT information. Then when the kexec'd kernel
> >>>>tries to initialize ESRT, it doesn't recognize the ESRT version number and
> >>>>just returns from efi_esrt_init().
> >>>I'm not sure what is the root cause of your problem.
> >>>Do you have good confidence that the kernel (2nd kernel image in this case?)
> >>>really overwrite ESRT region?
> >>According to my debug, yes.
> >>Using JTAG, I was able to determine that the ESRT memory region was getting
> >>overwritten by the secondary kernel in
> >>kernel/arch/arm64/kernel/relocate_kernel.S - specifically the "copy_page"
> >>line of arm64_relocate_new_kernel()
> >>
> >>>To my best knowledge, kexec is carefully designed not to do such a thing
> >>>as it allocates a temporary buffer for kernel image and copies it to the
> >>>final destination at the very end of the 1st kernel.
> >>>
> >>>My guess is that kexec, or rather kexec-tools, tries to load the kernel image
> >>>at 0x8f80000 (or 0x9080000?, not sure) in your case. It may or may not be
> >>>overlapped with ESRT.
> >>>(Try "-d" option when executing kexec command for confirmation.)
> >>With -d, I see
> >>
> >>get_memory_ranges_iomem_cb: 0000000009611000 - 000000000e5fffff : System RAM
> >>
> >>That overlaps the ESRT reservation -
> >>[ 0.000000] esrt: Reserving ESRT space from 0x000000000b708718 to
> >>0x000000000b7087f0
> >>
> >>>Are you using initrd with kexec?
> >>Yes
> >To make the things clear, can you show me, if possible, the followings:
> I have attached all of these:

Many thanks.
According to the data, ESRT was overwritten by initrd, not the kernel image.
It doesn't matter to you though :)

The solution would be, as Ard suggested, that more information be
added to /proc/iomem.
I'm going to fix the issue as quickly as possible.

Thanks,
-Takahiro AKASHI


> >* dmesg
> dmesg.txt: Main kernel dmesg logs which shows ESRT enabling properly
> kexec_dmesg.txt: Kexec'd kernel dmesg logs showing ESRT invalid version and
> the memory leak warning
> >* /proc/iomem
> iomem.txt
> >* the output from "kexec -d", particularly the last part like
> >     kexec_load: entry = 0x411d7660 flags = 0xb70000
> >     nr_segments = 3
> >     segment[0].buf   = 0xffff86613010
> >     segment[0].bufsz = 0x10e9b48
> >     segment[0].mem   = 0x40080000
> >     segment[0].memsz = 0x1156000
> >     segment[1].buf   = 0xffff86211010
> >     segment[1].bufsz = 0x20e
> >     segment[1].mem   = 0x411d6000
> >     segment[1].memsz = 0x1000
> >     segment[2].buf   = 0x5045420
> >     segment[2].bufsz = 0x31b8
> >     segment[2].mem   = 0x411d7000
> >     segment[2].memsz = 0x4000
> kexec_output.txt
> 
> Thanks,
> Tyler
> 
> -- 
> Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
> Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project.
> 

> root@ubuntu:/home/ubuntu# dmesg
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 4.14.14 (lnxbuild@bait-qsvbuild-13-bldr-lnx) (gcc version 6.3.1 20170109 (Linaro GCC 6.3-2017.02)) #2 SMP Thu Feb 15 20:32:17 MST 2018
> [    0.000000] Boot CPU: AArch64 Processor [510f8000]
> [    0.000000] earlycon: pl11 at MMIO32 0x000000ff78ed1000 (options '')
> [    0.000000] bootconsole [pl11] enabled
> [    0.000000] efi: Getting EFI parameters from FDT:
> [    0.000000] efi: EFI v2.60 by Qualcomm
> [    0.000000] efi:  ACPI 2.0=0x8bd0000  PROP=0xdf695c8  SMBIOS 3.0=0x4c20000  ESRT=0xa4c1c18  MEMATTR=0xa401018  RNG=0xdf16a98
> [    0.000000] random: fast init done
> [    0.000000] efi: seeding entropy pool
> [    0.000000] esrt: Reserving ESRT space from 0x000000000a4c1c18 to 0x000000000a4c1cf0.
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x0000000008BD0000 000024 (v02 QCOM  )
> [    0.000000] ACPI: XSDT 0x0000000008BC0000 000094 (v01 QCOM   QDF2400  00000000 QCOM 00000001)
> [    0.000000] ACPI: FACP 0x0000000008880000 000114 (v06 QCOM   QDF2400  00000000 INTL 20150515)
> [    0.000000] ACPI: DSDT 0x00000000088A0000 0332B6 (v02 QCOM   QDF2400  00000004 INTL 20150515)
> [    0.000000] ACPI: DBG2 0x0000000008930000 000072 (v00 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: IORT 0x0000000008910000 000D40 (v00 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: TPM2 0x0000000008900000 000040 (v04 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: BERT 0x00000000088E0000 000030 (v01 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: EINJ 0x0000000008890000 000150 (v01 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: GTDT 0x0000000008870000 00007C (v02 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: PCCT 0x0000000008850000 0000AC (v01 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: SPMI 0x0000000008840000 000041 (v04 QCOM   QDF2400  00000000 INTL 20150515)
> [    0.000000] ACPI: PPTT 0x00000000083B0000 000736 (v01 QCOM   QDF2400  00000002 INTL 20150515)
> [    0.000000] ACPI: APIC 0x00000000088F0000 000ED0 (v04 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: HEST 0x0000000008920000 000288 (v01 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: MCFG 0x0000000008860000 00005C (v01 QCOM   QDF2400  00000001 QCOM 00000001)
> [    0.000000] ACPI: SPCR 0x0000000004C00000 000050 (v04 QCOM   QDF2400  00000001 QCOM 00000001)
> [    0.000000] ACPI: SPCR: console: pl011,mmio32,0xff78ed1000,115200
> [    0.000000] ACPI: NUMA: Failed to initialise from firmware
> [    0.000000] NUMA: Faking a node at [mem 0x0000000000000000-0x00000017ffffffff]
> [    0.000000] NUMA: NODE_DATA [mem 0x17fb65be80-0x17fb65efff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000200000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x00000017ffffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000200000-0x000000000021ffff]
> [    0.000000]   node   0: [mem 0x0000000000820000-0x000000000307ffff]
> [    0.000000]   node   0: [mem 0x0000000003080000-0x000000000308ffff]
> [    0.000000]   node   0: [mem 0x0000000003090000-0x00000000031fffff]
> [    0.000000]   node   0: [mem 0x0000000003200000-0x00000000033fffff]
> [    0.000000]   node   0: [mem 0x0000000003410000-0x0000000004c0ffff]
> [    0.000000]   node   0: [mem 0x0000000004c10000-0x0000000004c2ffff]
> [    0.000000]   node   0: [mem 0x0000000004c30000-0x0000000004c3dfff]
> [    0.000000]   node   0: [mem 0x0000000004c3e000-0x0000000004c41fff]
> [    0.000000]   node   0: [mem 0x0000000004c42000-0x0000000004c4cfff]
> [    0.000000]   node   0: [mem 0x0000000004c4d000-0x0000000007c61fff]
> [    0.000000]   node   0: [mem 0x0000000007c62000-0x0000000007d6ffff]
> [    0.000000]   node   0: [mem 0x0000000007d70000-0x0000000007eeffff]
> [    0.000000]   node   0: [mem 0x0000000007ef0000-0x0000000007f0ffff]
> [    0.000000]   node   0: [mem 0x0000000007f10000-0x0000000007faffff]
> [    0.000000]   node   0: [mem 0x0000000007fb0000-0x0000000008310fff]
> [    0.000000]   node   0: [mem 0x0000000008311000-0x0000000008316fff]
> [    0.000000]   node   0: [mem 0x0000000008317000-0x00000000083c0fff]
> [    0.000000]   node   0: [mem 0x00000000083c1000-0x00000000083c6fff]
> [    0.000000]   node   0: [mem 0x00000000083c7000-0x00000000083effff]
> [    0.000000]   node   0: [mem 0x00000000083f0000-0x00000000085dffff]
> [    0.000000]   node   0: [mem 0x00000000085e0000-0x00000000085e0fff]
> [    0.000000]   node   0: [mem 0x00000000085e1000-0x00000000085e3fff]
> [    0.000000]   node   0: [mem 0x00000000085e4000-0x00000000085fffff]
> [    0.000000]   node   0: [mem 0x0000000008600000-0x000000000860ffff]
> [    0.000000]   node   0: [mem 0x0000000008610000-0x000000000863ffff]
> [    0.000000]   node   0: [mem 0x0000000008640000-0x00000000087affff]
> [    0.000000]   node   0: [mem 0x00000000087b0000-0x0000000008940fff]
> [    0.000000]   node   0: [mem 0x0000000008941000-0x0000000008943fff]
> [    0.000000]   node   0: [mem 0x0000000008944000-0x000000000896ffff]
> [    0.000000]   node   0: [mem 0x0000000008970000-0x0000000008a0ffff]
> [    0.000000]   node   0: [mem 0x0000000008a10000-0x0000000008a7ffff]
> [    0.000000]   node   0: [mem 0x0000000008a80000-0x0000000008bbffff]
> [    0.000000]   node   0: [mem 0x0000000008bc0000-0x0000000008bdffff]
> [    0.000000]   node   0: [mem 0x0000000008be0000-0x0000000008f02fff]
> [    0.000000]   node   0: [mem 0x0000000008f03000-0x000000000deeffff]
> [    0.000000]   node   0: [mem 0x000000000def0000-0x000000000df1ffff]
> [    0.000000]   node   0: [mem 0x000000000df20000-0x000000000fffffff]
> [    0.000000]   node   0: [mem 0x0000000010800000-0x0000000017feffff]
> [    0.000000]   node   0: [mem 0x000000001c000000-0x000000001c00ffff]
> [    0.000000]   node   0: [mem 0x000000001c010000-0x000000001c7fffff]
> [    0.000000]   node   0: [mem 0x000000001c810000-0x000000007efbffff]
> [    0.000000]   node   0: [mem 0x000000007efc0000-0x000000007efdffff]
> [    0.000000]   node   0: [mem 0x000000007efe0000-0x000000007efeffff]
> [    0.000000]   node   0: [mem 0x000000007eff0000-0x000000007effffff]
> [    0.000000]   node   0: [mem 0x000000007f000000-0x000000007fffffff]
> [    0.000000]   node   0: [mem 0x0000000080000000-0x00000000bfffffff]
> [    0.000000]   node   0: [mem 0x00000000c0000000-0x00000017ffffffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000000200000-0x00000017ffffffff]
> [    0.000000] On node 0 totalpages: 25145296
> [    0.000000]   DMA zone: 16376 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 1028048 pages, LIFO batch:31
> [    0.000000]   Normal zone: 376832 pages used for memmap
> [    0.000000]   Normal zone: 24117248 pages, LIFO batch:31
> [    0.000000] psci: probing for conduit method from ACPI.
> [    0.000000] psci: PSCIv1.0 detected in firmware.
> [    0.000000] psci: Using standard PSCI v0.2 function IDs
> [    0.000000] psci: MIGRATE_INFO_TYPE not supported.
> [    0.000000] percpu: Embedded 28 pages/cpu @ffffb2759acf8000 s77592 r8192 d28904 u114688
> [    0.000000] pcpu-alloc: s77592 r8192 d28904 u114688 alloc=28*4096
> [    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07
> [    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15
> [    0.000000] pcpu-alloc: [0] 16 [0] 17 [0] 18 [0] 19 [0] 20 [0] 21 [0] 22 [0] 23
> [    0.000000] pcpu-alloc: [0] 24 [0] 25 [0] 26 [0] 27 [0] 28 [0] 29 [0] 30 [0] 31
> [    0.000000] pcpu-alloc: [0] 32 [0] 33 [0] 34 [0] 35 [0] 36 [0] 37 [0] 38 [0] 39
> [    0.000000] pcpu-alloc: [0] 40 [0] 41 [0] 42 [0] 43 [0] 44 [0] 45
> [    0.000000] Detected PIPT I-cache on CPU0
> [    0.000000] CPU features: enabling workaround for Qualcomm Technologies Falkor erratum 1003
> [    0.000000] CPU features: enabling workaround for Qualcomm Technologies Falkor erratum 1009
> [    0.000000] CPU features: enabling workaround for Qualcomm Technologies Falkor erratum 1029
> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 24752088
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: \EFI\BOOT\Image user_debug=31 loglevel=9 uefi_debug e1000e.IntMode=1 pci=pcie_bus_safe pcie_aspm.policy=default cpuidle.off=0 rootwait rw root=PARTUUID=76ec3f97-3414-4896-a317-340ffa63adc6 rootfstype=ext4 initrd=initramfs.img earlycon=pl011,mmio32,0xff78ed1000 "" "" "" "" "" "" "" ""
> [    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
> [    0.000000] log_buf_len total cpu_extra contributions: 184320 bytes
> [    0.000000] log_buf_len min size: 16384 bytes
> [    0.000000] log_buf_len: 262144 bytes
> [    0.000000] early log buf free: 7596(46%)
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] software IO TLB [mem 0xfbffe000-0xffffe000] (64MB) mapped at [ffffb25efbffe000-ffffb25effffdfff]
> [    0.000000] Memory: 97723812K/100581184K available (10556K kernel code, 1596K rwdata, 4236K rodata, 5312K init, 970K bss, 2857372K reserved, 0K cma-reserved)
> [    0.000000] Virtual kernel memory layout:
> [    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000   (   128 MB)
> [    0.000000]     vmalloc : 0xffff000008000000 - 0xffff7dffbfff0000   (129022 GB)
> [    0.000000]       .text : 0xffff38c5d1e80000 - 0xffff38c5d28d0000   ( 10560 KB)
> [    0.000000]     .rodata : 0xffff38c5d28d0000 - 0xffff38c5d2d00000   (  4288 KB)
> [    0.000000]       .init : 0xffff38c5d2d00000 - 0xffff38c5d3230000   (  5312 KB)
> [    0.000000]       .data : 0xffff38c5d3230000 - 0xffff38c5d33bf200   (  1597 KB)
> [    0.000000]        .bss : 0xffff38c5d33bf200 - 0xffff38c5d34b1c80   (   971 KB)
> [    0.000000]     fixed   : 0xffff7dfffe7f9000 - 0xffff7dfffec00000   (  4124 KB)
> [    0.000000]     PCI I/O : 0xffff7dfffee00000 - 0xffff7dffffe00000   (    16 MB)
> [    0.000000]     vmemmap : 0xffff7e0000000000 - 0xffff800000000000   (  2048 GB maximum)
> [    0.000000]               0xffff7ec978008000 - 0xffff7ec9d8000000   (  1535 MB actual)
> [    0.000000]     memory  : 0xffffb25e00200000 - 0xffffb27600000000   ( 98302 MB)
> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=46, Nodes=1
> [    0.000000] ftrace: allocating 37871 entries in 148 pages
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=46.
> [    0.000000]  Tasks RCU enabled.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=46
> [    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
> [    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
> [    0.000000] GICv3: Distributor has no Range Selector support
> [    0.000000] GICv3: VLPI support, no direct LPI support
> [    0.000000] ACPI: SRAT not present
> [    0.000000] ITS [mem 0xff7efe0000-0xff7effffff]
> [    0.000000] ITS@0x000000ff7efe0000: Using ITS number 0
> [    0.000000] GIC: enabling workaround for ITS: QDF2400 erratum 0065
> [    0.000000] ITS@0x000000ff7efe0000: allocated 524288 Devices @179a000000 (indirect, esz 8, psz 64K, shr 1)
> [    0.000000] ITS@0x000000ff7efe0000: allocated 8192 Interrupt Collections @179a950000 (flat, esz 8, psz 64K, shr 1)
> [    0.000000] ITS@0x000000ff7efe0000: allocated 65536 Virtual CPUs @179a980000 (flat, esz 8, psz 64K, shr 1)
> [    0.000000] GIC: using LPI property table @0x000000179a960000
> [    0.000000] ITS: Allocated 1792 chunks for LPIs
> [    0.000000] ITS: Allocated DevID ffffffff as GICv4 proxy device (64 slots)
> [    0.000000] ITS: Enabling GICv4 support
> [    0.000000] GICv3: CPU0: found redistributor 0 region 0:0x000000ff7f000000
> [    0.000000] CPU0: using LPI pending table @0x000000179aa00000
> [    0.000000] arch_timer: cp15 timer(s) running at 20.00MHz (phys).
> [    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x49cd42e20, max_idle_ns: 440795202120 ns
> [    0.000001] sched_clock: 56 bits at 20MHz, resolution 50ns, wraps every 4398046511100ns
> [    0.008610] Console: colour dummy device 80x25
> [    0.013377] Remapping and enabling EFI services.
> [    0.018308]   EFI remap 0x0000000000200000 => 000059efedb70000
> [    0.024530]   EFI remap 0x0000000003080000 => 000059efedb90000
> [    0.030752]   EFI remap 0x0000000004c10000 => 000059efedba0000
> [    0.036980]   EFI remap 0x0000000007d70000 => 000059efedbc0000
> [    0.043201]   EFI remap 0x0000000007e00000 => 000059efedc50000
> [    0.049429]   EFI remap 0x0000000007e10000 => 000059efedc60000
> [    0.055651]   EFI remap 0x0000000007ea0000 => 000059efedcf0000
> [    0.061874]   EFI remap 0x0000000007ec0000 => 000059efedd10000
> [    0.068100]   EFI remap 0x0000000007f10000 => 000059efedd40000
> [    0.074321]   EFI remap 0x0000000007f70000 => 000059efedda0000
> [    0.080544]   EFI remap 0x0000000007f80000 => 000059efeddb0000
> [    0.086770]   EFI remap 0x00000000083f0000 => 000059efedde0000
> [    0.092991]   EFI remap 0x0000000008450000 => 000059efede40000
> [    0.099218]   EFI remap 0x0000000008460000 => 000059efede50000
> [    0.105439]   EFI remap 0x00000000084f0000 => 000059efedee0000
> [    0.111667]   EFI remap 0x0000000008500000 => 000059efedef0000
> [    0.117889]   EFI remap 0x0000000008590000 => 000059efedf80000
> [    0.124112]   EFI remap 0x00000000085b0000 => 000059efedfa0000
> [    0.130338]   EFI remap 0x0000000008640000 => 000059efedfd0000
> [    0.136560]   EFI remap 0x00000000086a0000 => 000059efee030000
> [    0.142789]   EFI remap 0x00000000086b0000 => 000059efee040000
> [    0.149010]   EFI remap 0x0000000008760000 => 000059efee0f0000
> [    0.155234]   EFI remap 0x0000000008770000 => 000059efee100000
> [    0.161459]   EFI remap 0x0000000008970000 => 000059efee140000
> [    0.167680]   EFI remap 0x00000000089d0000 => 000059efee1a0000
> [    0.173903]   EFI remap 0x00000000089e0000 => 000059efee1b0000
> [    0.180128]   EFI remap 0x0000000008a80000 => 000059efee1e0000
> [    0.186350]   EFI remap 0x0000000008ae0000 => 000059efee240000
> [    0.192577]   EFI remap 0x0000000008af0000 => 000059efee250000
> [    0.198799]   EFI remap 0x0000000008b80000 => 000059efee2e0000
> [    0.205021]   EFI remap 0x0000000008b90000 => 000059efee2f0000
> [    0.211247]   EFI remap 0x0000000008be0000 => 000059efee320000
> [    0.217468]   EFI remap 0x0000000008c40000 => 000059efee380000
> [    0.223696]   EFI remap 0x0000000008c50000 => 000059efee390000
> [    0.229917]   EFI remap 0x0000000008ce0000 => 000059efee420000
> [    0.236144]   EFI remap 0x0000000008cf0000 => 000059efee430000
> [    0.242366]   EFI remap 0x0000000008d80000 => 000059efee4c0000
> [    0.248593]   EFI remap 0x0000000008d90000 => 000059efee4d0000
> [    0.254814]   EFI remap 0x0000000008e20000 => 000059efee560000
> [    0.261041]   EFI remap 0x0000000008e30000 => 000059efee570000
> [    0.267263]   EFI remap 0x0000000008ec0000 => 000059efee600000
> [    0.273486]   EFI remap 0x0000000008ed0000 => 000059efee610000
> [    0.279709]   EFI remap 0x000000000def0000 => 000059efee640000
> [    0.285931]   EFI remap 0x000000001c000000 => 000059efee670000
> [    0.292153]   EFI remap 0x000000ff70030000 => 000059efee680000
> [    0.298374]   EFI remap 0x000000ff70400000 => 000059efee690000
> [    0.304595]   EFI remap 0x000000ff79000000 => 000059efee800000
> [    0.310817]   EFI remap 0x000000ff79420000 => 000059efeec00000
> [    0.317038]   EFI remap 0x000000ff7ac00000 => 000059efeee00000
> [    0.323343] Calibrating delay loop (skipped), value calculated using timer frequency.. 40.00 BogoMIPS (lpj=80000)
> [    0.334296] pid_max: default: 47104 minimum: 368
> [    0.339229] ACPI: Core revision 20170728
> [    0.379878] ACPI: 1 ACPI AML tables successfully acquired and loaded
> [    0.386698] Security Framework initialized
> [    0.391064] Yama: becoming mindful.
> [    0.394782] SELinux:  Disabled at boot.
> [    0.398869] AppArmor: AppArmor disabled by boot time parameter
> [    0.408660] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
> [    0.418334] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
> [    0.426202] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.433782] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.442234] ASID allocator initialised with 32768 entries
> [    0.448017] Hierarchical SRCU implementation.
> [    0.453046] PCI/MSI: ITS@0xff7efe0000 domain created
> [    0.458349] Platform MSI: ITS@0xff7efe0000 domain created
> [    0.464440] smp: Bringing up secondary CPUs ...
> [    0.470149] Detected PIPT I-cache on CPU1
> [    0.470159] GICv3: CPU1: found redistributor 100 region 1:0x000000ff7f080000
> [    0.470167] CPU1: using LPI pending table @0x0000001793fa0000
> [    0.470189] CPU1: Booted secondary processor [510f8000]
> [    0.471143] Detected PIPT I-cache on CPU2
> [    0.471152] GICv3: CPU2: found redistributor 200 region 2:0x000000ff7f100000
> [    0.471161] CPU2: using LPI pending table @0x0000001793ff0000
> [    0.471181] CPU2: Booted secondary processor [510f8000]
> [    0.472108] Detected PIPT I-cache on CPU3
> [    0.472117] GICv3: CPU3: found redistributor 300 region 3:0x000000ff7f180000
> [    0.472126] CPU3: using LPI pending table @0x0000001793840000
> [    0.472146] CPU3: Booted secondary processor [510f8000]
> [    0.473038] Detected PIPT I-cache on CPU4
> [    0.473048] GICv3: CPU4: found redistributor 400 region 4:0x000000ff7f200000
> [    0.473056] CPU4: using LPI pending table @0x0000001793890000
> [    0.473076] CPU4: Booted secondary processor [510f8000]
> [    0.474018] Detected PIPT I-cache on CPU5
> [    0.474029] GICv3: CPU5: found redistributor 500 region 5:0x000000ff7f280000
> [    0.474037] CPU5: using LPI pending table @0x00000017938d0000
> [    0.474058] CPU5: Booted secondary processor [510f8000]
> [    0.474947] Detected PIPT I-cache on CPU6
> [    0.474958] GICv3: CPU6: found redistributor 700 region 6:0x000000ff7f380000
> [    0.474966] CPU6: using LPI pending table @0x0000001793930000
> [    0.474987] CPU6: Booted secondary processor [510f8000]
> [    0.475863] Detected PIPT I-cache on CPU7
> [    0.475874] GICv3: CPU7: found redistributor 800 region 7:0x000000ff7f400000
> [    0.475882] CPU7: using LPI pending table @0x0000001793980000
> [    0.475903] CPU7: Booted secondary processor [510f8000]
> [    0.476829] Detected PIPT I-cache on CPU8
> [    0.476842] GICv3: CPU8: found redistributor 900 region 8:0x000000ff7f480000
> [    0.476851] CPU8: using LPI pending table @0x00000017939c0000
> [    0.476873] CPU8: Booted secondary processor [510f8000]
> [    0.477804] Detected PIPT I-cache on CPU9
> [    0.477817] GICv3: CPU9: found redistributor a00 region 9:0x000000ff7f500000
> [    0.477826] CPU9: using LPI pending table @0x0000001793a30000
> [    0.477848] CPU9: Booted secondary processor [510f8000]
> [    0.478718] Detected PIPT I-cache on CPU10
> [    0.478732] GICv3: CPU10: found redistributor b00 region 10:0x000000ff7f580000
> [    0.478740] CPU10: using LPI pending table @0x0000001793a70000
> [    0.478763] CPU10: Booted secondary processor [510f8000]
> [    0.479615] Detected PIPT I-cache on CPU11
> [    0.479629] GICv3: CPU11: found redistributor c00 region 11:0x000000ff7f600000
> [    0.479637] CPU11: using LPI pending table @0x0000001793ab0000
> [    0.479660] CPU11: Booted secondary processor [510f8000]
> [    0.480590] Detected PIPT I-cache on CPU12
> [    0.480605] GICv3: CPU12: found redistributor d00 region 12:0x000000ff7f680000
> [    0.480613] CPU12: using LPI pending table @0x0000001793b20000
> [    0.480637] CPU12: Booted secondary processor [510f8000]
> [    0.481551] Detected PIPT I-cache on CPU13
> [    0.481566] GICv3: CPU13: found redistributor e00 region 13:0x000000ff7f700000
> [    0.481575] CPU13: using LPI pending table @0x0000001793b60000
> [    0.481598] CPU13: Booted secondary processor [510f8000]
> [    0.482448] Detected PIPT I-cache on CPU14
> [    0.482463] GICv3: CPU14: found redistributor f00 region 14:0x000000ff7f780000
> [    0.482472] CPU14: using LPI pending table @0x0000001793ba0000
> [    0.482496] CPU14: Booted secondary processor [510f8000]
> [    0.483376] Detected PIPT I-cache on CPU15
> [    0.483392] GICv3: CPU15: found redistributor 1000 region 15:0x000000ff7f800000
> [    0.483401] CPU15: using LPI pending table @0x0000001793400000
> [    0.483423] CPU15: Booted secondary processor [510f8000]
> [    0.484351] Detected PIPT I-cache on CPU16
> [    0.484367] GICv3: CPU16: found redistributor 1100 region 16:0x000000ff7f880000
> [    0.484376] CPU16: using LPI pending table @0x0000001793450000
> [    0.484400] CPU16: Booted secondary processor [510f8000]
> [    0.485338] Detected PIPT I-cache on CPU17
> [    0.485355] GICv3: CPU17: found redistributor 1200 region 17:0x000000ff7f900000
> [    0.485363] CPU17: using LPI pending table @0x0000001793490000
> [    0.485387] CPU17: Booted secondary processor [510f8000]
> [    0.486274] Detected PIPT I-cache on CPU18
> [    0.486290] GICv3: CPU18: found redistributor 1300 region 18:0x000000ff7f980000
> [    0.486299] CPU18: using LPI pending table @0x0000001793500000
> [    0.486323] CPU18: Booted secondary processor [510f8000]
> [    0.487220] Detected PIPT I-cache on CPU19
> [    0.487237] GICv3: CPU19: found redistributor 1400 region 19:0x000000ff7fa00000
> [    0.487246] CPU19: using LPI pending table @0x0000001793540000
> [    0.487268] CPU19: Booted secondary processor [510f8000]
> [    0.488198] Detected PIPT I-cache on CPU20
> [    0.488216] GICv3: CPU20: found redistributor 1500 region 20:0x000000ff7fa80000
> [    0.488224] CPU20: using LPI pending table @0x0000001793580000
> [    0.488249] CPU20: Booted secondary processor [510f8000]
> [    0.489170] Detected PIPT I-cache on CPU21
> [    0.489188] GICv3: CPU21: found redistributor 1600 region 21:0x000000ff7fb00000
> [    0.489197] CPU21: using LPI pending table @0x00000017935f0000
> [    0.489221] CPU21: Booted secondary processor [510f8000]
> [    0.490138] Detected PIPT I-cache on CPU22
> [    0.490157] GICv3: CPU22: found redistributor 1700 region 22:0x000000ff7fb80000
> [    0.490165] CPU22: using LPI pending table @0x0000001793630000
> [    0.490189] CPU22: Booted secondary processor [510f8000]
> [    0.491086] Detected PIPT I-cache on CPU23
> [    0.491105] GICv3: CPU23: found redistributor 1 region 23:0x000000ff7f040000
> [    0.491112] CPU23: using LPI pending table @0x0000001793670000
> [    0.491134] CPU23: Booted secondary processor [510f8000]
> [    0.492031] Detected PIPT I-cache on CPU24
> [    0.492048] GICv3: CPU24: found redistributor 101 region 24:0x000000ff7f0c0000
> [    0.492056] CPU24: using LPI pending table @0x00000017936c0000
> [    0.492076] CPU24: Booted secondary processor [510f8000]
> [    0.492986] Detected PIPT I-cache on CPU25
> [    0.493004] GICv3: CPU25: found redistributor 201 region 25:0x000000ff7f140000
> [    0.493012] CPU25: using LPI pending table @0x0000001793720000
> [    0.493032] CPU25: Booted secondary processor [510f8000]
> [    0.493922] Detected PIPT I-cache on CPU26
> [    0.493942] GICv3: CPU26: found redistributor 301 region 26:0x000000ff7f1c0000
> [    0.493949] CPU26: using LPI pending table @0x0000001793760000
> [    0.493969] CPU26: Booted secondary processor [510f8000]
> [    0.494874] Detected PIPT I-cache on CPU27
> [    0.494894] GICv3: CPU27: found redistributor 401 region 27:0x000000ff7f240000
> [    0.494901] CPU27: using LPI pending table @0x00000017937a0000
> [    0.494922] CPU27: Booted secondary processor [510f8000]
> [    0.495849] Detected PIPT I-cache on CPU28
> [    0.495872] GICv3: CPU28: found redistributor 601 region 28:0x000000ff7f340000
> [    0.495881] CPU28: using LPI pending table @0x0000001793010000
> [    0.495907] CPU28: Booted secondary processor [510f8000]
> [    0.496818] Detected PIPT I-cache on CPU29
> [    0.496839] GICv3: CPU29: found redistributor 701 region 29:0x000000ff7f3c0000
> [    0.496846] CPU29: using LPI pending table @0x0000001793060000
> [    0.496867] CPU29: Booted secondary processor [510f8000]
> [    0.497727] Detected PIPT I-cache on CPU30
> [    0.497749] GICv3: CPU30: found redistributor 801 region 30:0x000000ff7f440000
> [    0.497757] CPU30: using LPI pending table @0x00000017930a0000
> [    0.497778] CPU30: Booted secondary processor [510f8000]
> [    0.498671] Detected PIPT I-cache on CPU31
> [    0.498693] GICv3: CPU31: found redistributor 901 region 31:0x000000ff7f4c0000
> [    0.498701] CPU31: using LPI pending table @0x0000001793100000
> [    0.498722] CPU31: Booted secondary processor [510f8000]
> [    0.499624] Detected PIPT I-cache on CPU32
> [    0.499646] GICv3: CPU32: found redistributor a01 region 32:0x000000ff7f540000
> [    0.499654] CPU32: using LPI pending table @0x0000001793140000
> [    0.499676] CPU32: Booted secondary processor [510f8000]
> [    0.500544] Detected PIPT I-cache on CPU33
> [    0.500567] GICv3: CPU33: found redistributor b01 region 33:0x000000ff7f5c0000
> [    0.500575] CPU33: using LPI pending table @0x0000001793180000
> [    0.500597] CPU33: Booted secondary processor [510f8000]
> [    0.501433] Detected PIPT I-cache on CPU34
> [    0.501456] GICv3: CPU34: found redistributor c01 region 34:0x000000ff7f640000
> [    0.501463] CPU34: using LPI pending table @0x00000017931f0000
> [    0.501486] CPU34: Booted secondary processor [510f8000]
> [    0.502384] Detected PIPT I-cache on CPU35
> [    0.502408] GICv3: CPU35: found redistributor d01 region 35:0x000000ff7f6c0000
> [    0.502416] CPU35: using LPI pending table @0x0000001793230000
> [    0.502438] CPU35: Booted secondary processor [510f8000]
> [    0.503352] Detected PIPT I-cache on CPU36
> [    0.503377] GICv3: CPU36: found redistributor e01 region 36:0x000000ff7f740000
> [    0.503385] CPU36: using LPI pending table @0x0000001793280000
> [    0.503407] CPU36: Booted secondary processor [510f8000]
> [    0.504253] Detected PIPT I-cache on CPU37
> [    0.504277] GICv3: CPU37: found redistributor f01 region 37:0x000000ff7f7c0000
> [    0.504285] CPU37: using LPI pending table @0x00000017932e0000
> [    0.504308] CPU37: Booted secondary processor [510f8000]
> [    0.505126] Detected PIPT I-cache on CPU38
> [    0.505151] GICv3: CPU38: found redistributor 1001 region 38:0x000000ff7f840000
> [    0.505159] CPU38: using LPI pending table @0x0000001793320000
> [    0.505182] CPU38: Booted secondary processor [510f8000]
> [    0.506113] Detected PIPT I-cache on CPU39
> [    0.506139] GICv3: CPU39: found redistributor 1101 region 39:0x000000ff7f8c0000
> [    0.506147] CPU39: using LPI pending table @0x0000001793370000
> [    0.506170] CPU39: Booted secondary processor [510f8000]
> [    0.507097] Detected PIPT I-cache on CPU40
> [    0.507123] GICv3: CPU40: found redistributor 1201 region 40:0x000000ff7f940000
> [    0.507131] CPU40: using LPI pending table @0x00000017933d0000
> [    0.507154] CPU40: Booted secondary processor [510f8000]
> [    0.507982] Detected PIPT I-cache on CPU41
> [    0.508008] GICv3: CPU41: found redistributor 1301 region 41:0x000000ff7f9c0000
> [    0.508016] CPU41: using LPI pending table @0x0000001792c10000
> [    0.508039] CPU41: Booted secondary processor [510f8000]
> [    0.508896] Detected PIPT I-cache on CPU42
> [    0.508922] GICv3: CPU42: found redistributor 1401 region 42:0x000000ff7fa40000
> [    0.508930] CPU42: using LPI pending table @0x0000001792c50000
> [    0.508952] CPU42: Booted secondary processor [510f8000]
> [    0.509871] Detected PIPT I-cache on CPU43
> [    0.509899] GICv3: CPU43: found redistributor 1501 region 43:0x000000ff7fac0000
> [    0.509906] CPU43: using LPI pending table @0x0000001792cb0000
> [    0.509930] CPU43: Booted secondary processor [510f8000]
> [    0.510838] Detected PIPT I-cache on CPU44
> [    0.510866] GICv3: CPU44: found redistributor 1601 region 44:0x000000ff7fb40000
> [    0.510873] CPU44: using LPI pending table @0x0000001792d10000
> [    0.510897] CPU44: Booted secondary processor [510f8000]
> [    0.511753] Detected PIPT I-cache on CPU45
> [    0.511780] GICv3: CPU45: found redistributor 1701 region 45:0x000000ff7fbc0000
> [    0.511787] CPU45: using LPI pending table @0x0000001792d50000
> [    0.511811] CPU45: Booted secondary processor [510f8000]
> [    0.511873] smp: Brought up 1 node, 46 CPUs
> [    1.591228] SMP: Total of 46 processors activated.
> [    1.596336] CPU features: detected feature: GIC system register CPU interface
> [    1.603948] CPU features: detected feature: Privileged Access Never
> [    1.610633] CPU features: detected feature: Kernel page table isolation (KPTI)
> [    1.740357] CPU: All CPU(s) started at EL2
> [    1.744889] alternatives: patching kernel code
> [    1.759402] devtmpfs: initialized
> [    1.763089] evm: security.selinux
> [    1.766617] evm: security.SMACK64
> [    1.770148] evm: security.SMACK64EXEC
> [    1.774046] evm: security.SMACK64TRANSMUTE
> [    1.778411] evm: security.SMACK64MMAP
> [    1.782309] evm: security.ima
> [    1.785468] evm: security.capability
> [    1.789553] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    1.800032] futex hash table entries: 16384 (order: 9, 2097152 bytes)
> [    1.807189] pinctrl core: initialized pinctrl subsystem
> [    1.812963] SMBIOS 3.1.1 present.
> [    1.816497] DMI: Qualcomm Qualcomm Centriq(TM) 2400 Development Platform/ABW|SYS|CVR,1DPC|V3           , BIOS STB_XBL.DF.2.0_-64-1-G1CA82A3-DIRT
> [    1.830392] NET: Registered protocol family 16
> [    1.835818] cpuidle: using governor ladder
> [    1.840250] cpuidle: using governor menu
> [    1.844457] Detected 2 PCC Subspaces
> [    1.848291] Registering PCC driver as Mailbox controller
> [    1.854027] vdso: 2 pages (1 code @ ffff38c5d28d7000, 1 data @ ffff38c5d3235000)
> [    1.861923] hw-breakpoint: found 8 breakpoint and 4 watchpoint registers.
> [    1.869631] DMA: preallocated 256 KiB pool for atomic allocations
> [    1.876153] ACPI: bus type PCI registered
> [    1.880426] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    1.887329] Serial: AMBA PL011 UART driver
> [    1.894133] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> [    1.901841] ipmi:dmi: Invalid IPMI type: 0
> [    1.902038] ACPI: Added _OSI(Module Device)
> [    1.910866] ACPI: Added _OSI(Processor Device)
> [    1.915603] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    1.920618] ACPI: Added _OSI(Processor Aggregator Device)
> [    2.368541] ACPI: Interpreter enabled
> [    2.372451] ACPI: Using GIC for interrupt routing
> [    2.377479] ACPI: MCFG table detected, 3 entries
> [    2.382747] HEST: Table parsing has been initialized.
> [    2.436492] sbsa-uart ARMH0011:01: working around QDF2400 SoC erratum 44
> [    2.443657] ARMH0011:01: ttyAMA0 at MMIO 0xff78ed1000 (irq = 27, base_baud = 0) is a SBSA
> [    2.452387] console [ttyAMA0] enabled
> [    2.459935] bootconsole [pl11] disabled
> [    2.477253] ACPI: PCI Interrupt Link [LN0A] (IRQs *88)
> [    2.481461] ACPI: PCI Interrupt Link [LN0B] (IRQs *89)
> [    2.486577] ACPI: PCI Interrupt Link [LN0C] (IRQs *90)
> [    2.491698] ACPI: PCI Interrupt Link [LN0D] (IRQs *91)
> [    2.496907] ACPI: PCI Root Bridge [PCI1] (domain 0001 [bus 00-ff])
> [    2.502977] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    2.511216] acpi PNP0A08:01: PCIe AER handled by firmware
> [    2.516672] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
> [    2.530754] acpi PNP0A08:01: ECAM area [mem 0x90000000000-0x9000fffffff] reserved by PNP0C02:01
> [    2.538507] acpi PNP0A08:01: ECAM at [mem 0x90000000000-0x9000fffffff] for [bus 00-ff]
> [    2.546428] Remapped I/O 0x000009ffffff0000 to [io  0x0000-0xffff window]
> [    2.553228] PCI host bridge to bus 0001:00
> [    2.557243] pci_bus 0001:00: root bus resource [mem 0x90100100000-0x9011fffffff window] (bus address [0x00100000-0x1fffffff])
> [    2.568526] pci_bus 0001:00: root bus resource [mem 0x90200000000-0x9021fffffff window] (bus address [0x20000000-0x3fffffff])
> [    2.579811] pci_bus 0001:00: root bus resource [mem 0x90300000000-0x9033fffffff window] (bus address [0x40000000-0x7fffffff])
> [    2.591095] pci_bus 0001:00: root bus resource [mem 0x90400000000-0x9fffffeffff window]
> [    2.599081] pci_bus 0001:00: root bus resource [io  0x0000-0xffff window] (bus address [0x1000-0x10fff])
> [    2.608543] pci_bus 0001:00: root bus resource [bus 00-ff]
> [    2.614019] pci 0001:00:00.0: [17cb:0401] type 01 class 0x060400
> [    2.620033] pci 0001:00:00.0: PME# supported from D0 D3hot
> [    2.625559] pci 0001:00:00.0: BAR 14: assigned [mem 0x90100100000-0x901002fffff]
> [    2.632851] pci 0001:00:00.0: BAR 15: assigned [mem 0x90400000000-0x904001fffff 64bit pref]
> [    2.641182] pci 0001:00:00.0: BAR 13: assigned [io  0x1000-0x1fff]
> [    2.647346] pci 0001:00:00.0: PCI bridge to [bus 01]
> [    2.652293] pci 0001:00:00.0:   bridge window [io  0x1000-0x1fff]
> [    2.658370] pci 0001:00:00.0:   bridge window [mem 0x90100100000-0x901002fffff]
> [    2.665662] pci 0001:00:00.0:   bridge window [mem 0x90400000000-0x904001fffff 64bit pref]
> [    2.673911] pci 0001:00:00.0: Max Payload Size set to  512/ 512 (was  512), Max Read Rq 4096
> [    2.682358] ACPI: PCI Interrupt Link [LN1A] (IRQs *92)
> [    2.687472] ACPI: PCI Interrupt Link [LN1B] (IRQs *93)
> [    2.692592] ACPI: PCI Interrupt Link [LN1C] (IRQs *94)
> [    2.697713] ACPI: PCI Interrupt Link [LN1D] (IRQs *95)
> [    2.702920] ACPI: PCI Root Bridge [PCI2] (domain 0002 [bus 00-ff])
> [    2.708992] acpi PNP0A08:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    2.717232] acpi PNP0A08:02: PCIe AER handled by firmware
> [    2.722690] acpi PNP0A08:02: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
> [    2.736860] acpi PNP0A08:02: ECAM area [mem 0xa0000000000-0xa000fffffff] reserved by PNP0C02:02
> [    2.744611] acpi PNP0A08:02: ECAM at [mem 0xa0000000000-0xa000fffffff] for [bus 00-ff]
> [    2.752530] Remapped I/O 0x00000affffff0000 to [io  0x10000-0x1ffff window]
> [    2.759506] PCI host bridge to bus 0002:00
> [    2.763525] pci_bus 0002:00: root bus resource [mem 0xa0100100000-0xa011fffffff window] (bus address [0x00100000-0x1fffffff])
> [    2.774805] pci_bus 0002:00: root bus resource [mem 0xa0200000000-0xa021fffffff window] (bus address [0x20000000-0x3fffffff])
> [    2.786090] pci_bus 0002:00: root bus resource [mem 0xa0300000000-0xa033fffffff window] (bus address [0x40000000-0x7fffffff])
> [    2.797374] pci_bus 0002:00: root bus resource [mem 0xa0400000000-0xafffffeffff window]
> [    2.805360] pci_bus 0002:00: root bus resource [io  0x10000-0x1ffff window] (bus address [0x1000-0x10fff])
> [    2.814996] pci_bus 0002:00: root bus resource [bus 00-ff]
> [    2.820470] pci 0002:00:00.0: [17cb:0401] type 01 class 0x060400
> [    2.826483] pci 0002:00:00.0: PME# supported from D0 D3hot
> [    2.832014] pci 0002:01:00.0: [8086:105e] type 00 class 0x020000
> [    2.837934] pci 0002:01:00.0: reg 0x10: [mem 0xa011ff60000-0xa011ff7ffff]
> [    2.844690] pci 0002:01:00.0: reg 0x14: [mem 0xa011ff40000-0xa011ff5ffff]
> [    2.851461] pci 0002:01:00.0: reg 0x18: [io  0x1f020-0x1f03f]
> [    2.857214] pci 0002:01:00.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
> [    2.863923] pci 0002:01:00.0: PME# supported from D0 D3hot D3cold
> [    2.870017] pci 0002:01:00.1: [8086:105e] type 00 class 0x020000
> [    2.875954] pci 0002:01:00.1: reg 0x10: [mem 0xa011ff20000-0xa011ff3ffff]
> [    2.882711] pci 0002:01:00.1: reg 0x14: [mem 0xa011ff00000-0xa011ff1ffff]
> [    2.889482] pci 0002:01:00.1: reg 0x18: [io  0x1f000-0x1f01f]
> [    2.895234] pci 0002:01:00.1: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
> [    2.901942] pci 0002:01:00.1: PME# supported from D0 D3hot D3cold
> [    2.908031] pci 0002:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    2.917962] pci 0002:00:00.0: BAR 14: assigned [mem 0xa0100100000-0xa01002fffff]
> [    2.925327] pci 0002:00:00.0: BAR 15: assigned [mem 0xa0400000000-0xa04001fffff 64bit pref]
> [    2.933659] pci 0002:00:00.0: BAR 13: assigned [io  0x10000-0x10fff]
> [    2.939997] pci 0002:01:00.0: BAR 0: assigned [mem 0xa0100100000-0xa010011ffff]
> [    2.947290] pci 0002:01:00.0: BAR 1: assigned [mem 0xa0100120000-0xa010013ffff]
> [    2.954582] pci 0002:01:00.0: BAR 6: assigned [mem 0xa0100140000-0xa010015ffff pref]
> [    2.962305] pci 0002:01:00.1: BAR 0: assigned [mem 0xa0100160000-0xa010017ffff]
> [    2.969599] pci 0002:01:00.1: BAR 1: assigned [mem 0xa0100180000-0xa010019ffff]
> [    2.976890] pci 0002:01:00.1: BAR 6: assigned [mem 0xa01001a0000-0xa01001bffff pref]
> [    2.984614] pci 0002:01:00.0: BAR 2: assigned [io  0x10000-0x1001f]
> [    2.990866] pci 0002:01:00.1: BAR 2: assigned [io  0x10020-0x1003f]
> [    2.997118] pci 0002:00:00.0: PCI bridge to [bus 01]
> [    3.002062] pci 0002:00:00.0:   bridge window [io  0x10000-0x10fff]
> [    3.008313] pci 0002:00:00.0:   bridge window [mem 0xa0100100000-0xa01002fffff]
> [    3.015604] pci 0002:00:00.0:   bridge window [mem 0xa0400000000-0xa04001fffff 64bit pref]
> [    3.023853] pci 0002:00:00.0: Max Payload Size set to  256/ 512 (was  256), Max Read Rq 4096
> [    3.032276] pci 0002:01:00.0: Max Payload Size set to  256/ 256 (was  256), Max Read Rq 4096
> [    3.040696] pci 0002:01:00.1: Max Payload Size set to  256/ 256 (was  256), Max Read Rq 4096
> [    3.049142] ACPI: PCI Interrupt Link [LN2A] (IRQs *96)
> [    3.054255] ACPI: PCI Interrupt Link [LN2B] (IRQs *97)
> [    3.059375] ACPI: PCI Interrupt Link [LN2C] (IRQs *98)
> [    3.064496] ACPI: PCI Interrupt Link [LN2D] (IRQs *99)
> [    3.069707] ACPI: PCI Root Bridge [PCI3] (domain 0003 [bus 00-ff])
> [    3.075775] acpi PNP0A08:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    3.084014] acpi PNP0A08:03: PCIe AER handled by firmware
> [    3.089469] acpi PNP0A08:03: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
> [    3.103740] acpi PNP0A08:03: ECAM area [mem 0xc0000000000-0xc000fffffff] reserved by PNP0C02:03
> [    3.111492] acpi PNP0A08:03: ECAM at [mem 0xc0000000000-0xc000fffffff] for [bus 00-ff]
> [    3.119411] Remapped I/O 0x00000cffffff0000 to [io  0x20000-0x2ffff window]
> [    3.126386] PCI host bridge to bus 0003:00
> [    3.130402] pci_bus 0003:00: root bus resource [mem 0xc0100100000-0xc011fffffff window] (bus address [0x00100000-0x1fffffff])
> [    3.141685] pci_bus 0003:00: root bus resource [mem 0xc0200000000-0xc021fffffff window] (bus address [0x20000000-0x3fffffff])
> [    3.152970] pci_bus 0003:00: root bus resource [mem 0xc0300000000-0xc033fffffff window] (bus address [0x40000000-0x7fffffff])
> [    3.164254] pci_bus 0003:00: root bus resource [mem 0xc0400000000-0xcfffffeffff window]
> [    3.172241] pci_bus 0003:00: root bus resource [io  0x20000-0x2ffff window] (bus address [0x1000-0x10fff])
> [    3.181876] pci_bus 0003:00: root bus resource [bus 00-ff]
> [    3.187350] pci 0003:00:00.0: [17cb:0401] type 01 class 0x060400
> [    3.193359] pci 0003:00:00.0: PME# supported from D0 D3hot
> [    3.198927] pci 0003:01:00.0: [15b3:1015] type 00 class 0x020000
> [    3.204913] pci 0003:01:00.0: reg 0x10: [mem 0xcfffc000000-0xcfffdffffff 64bit pref]
> [    3.212650] pci 0003:01:00.0: reg 0x30: [mem 0xfff00000-0xffffffff pref]
> [    3.219624] pci 0003:01:00.0: PME# supported from D3cold
> [    3.224662] pci 0003:01:00.0: reg 0x1a4: [mem 0xcfffe000000-0xcfffe0fffff 64bit pref]
> [    3.232310] pci 0003:01:00.0: VF(n) BAR0 space: [mem 0xcfffe000000-0xcfffe7fffff 64bit pref] (contains BAR0 for 8 VFs)
> [    3.243569] pci 0003:00:00.0: BAR 15: assigned [mem 0xc0400000000-0xc0403ffffff 64bit pref]
> [    3.251322] pci 0003:00:00.0: BAR 14: assigned [mem 0xc0100100000-0xc01002fffff]
> [    3.258699] pci 0003:00:00.0: BAR 13: assigned [io  0x20000-0x20fff]
> [    3.265036] pci 0003:01:00.0: BAR 0: assigned [mem 0xc0400000000-0xc0401ffffff 64bit pref]
> [    3.273317] pci 0003:01:00.0: BAR 6: assigned [mem 0xc0100100000-0xc01001fffff pref]
> [    3.281008] pci 0003:01:00.0: BAR 7: assigned [mem 0xc0402000000-0xc04027fffff 64bit pref]
> [    3.289270] pci 0003:00:00.0: PCI bridge to [bus 01-02]
> [    3.294463] pci 0003:00:00.0:   bridge window [io  0x20000-0x20fff]
> [    3.300713] pci 0003:00:00.0:   bridge window [mem 0xc0100100000-0xc01002fffff]
> [    3.308004] pci 0003:00:00.0:   bridge window [mem 0xc0400000000-0xc0403ffffff 64bit pref]
> [    3.316253] pci 0003:00:00.0: Max Payload Size set to  512/ 512 (was  512), Max Read Rq 4096
> [    3.324713] pci 0003:01:00.0: Max Payload Size set to  512/ 512 (was  512), Max Read Rq 4096
> [    3.333121] ACPI: PCI Interrupt Link [LN3A] (IRQs *100)
> [    3.338323] ACPI: PCI Interrupt Link [LN3B] (IRQs *101)
> [    3.343532] ACPI: PCI Interrupt Link [LN3C] (IRQs *102)
> [    3.348739] ACPI: PCI Interrupt Link [LN3D] (IRQs *103)
> [    3.354026] ACPI: PCI Interrupt Link [LN4A] (IRQs *104)
> [    3.359156] ACPI: PCI Interrupt Link [LN4B] (IRQs *105)
> [    3.364362] ACPI: PCI Interrupt Link [LN4C] (IRQs *106)
> [    3.369570] ACPI: PCI Interrupt Link [LN4D] (IRQs *107)
> [    3.374850] ACPI: PCI Interrupt Link [LN5A] (IRQs *108)
> [    3.379988] ACPI: PCI Interrupt Link [LN5B] (IRQs *109)
> [    3.385195] ACPI: PCI Interrupt Link [LN5C] (IRQs *110)
> [    3.390404] ACPI: PCI Interrupt Link [LN5D] (IRQs *111)
> [    3.410426] vgaarb: loaded
> [    3.412414] SCSI subsystem initialized
> [    3.416008] libata version 3.00 loaded.
> [    3.419747] ACPI: bus type USB registered
> [    3.423738] usbcore: registered new interface driver usbfs
> [    3.429194] usbcore: registered new interface driver hub
> [    3.434596] usbcore: registered new device driver usb
> [    3.439872] EDAC MC: Ver: 3.0.0
> [    3.442741] Registered efivars operations
> [    3.448049] NetLabel: Initializing
> [    3.450486] NetLabel:  domain hash size = 128
> [    3.454835] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
> [    3.460487] NetLabel:  unlabeled traffic allowed by default
> [    3.466504] clocksource: Switched to clocksource arch_sys_counter
> [    3.486371] VFS: Disk quotas dquot_6.6.0
> [    3.489358] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    3.496324] pnp: PnP ACPI init
> [    3.502949] system 00:00: [mem 0x80000000000-0x8000fffffff] has been reserved
> [    3.509130] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.515979] system 00:01: [mem 0x90000000000-0x9000fffffff] could not be reserved
> [    3.523364] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.530214] system 00:02: [mem 0xa0000000000-0xa000fffffff] could not be reserved
> [    3.537600] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.544452] system 00:03: [mem 0xc0000000000-0xc000fffffff] could not be reserved
> [    3.551836] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.558687] system 00:04: [mem 0xd0000000000-0xd000fffffff] has been reserved
> [    3.565728] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.572576] system 00:05: [mem 0xe0000000000-0xe000fffffff] has been reserved
> [    3.579614] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.591330] pnp: PnP ACPI: found 6 devices
> [    3.596498] NET: Registered protocol family 2
> [    3.600212] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
> [    3.608046] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    3.614155] TCP: Hash tables configured (established 524288 bind 65536)
> [    3.620789] UDP hash table entries: 65536 (order: 9, 2097152 bytes)
> [    3.627211] UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
> [    3.633966] NET: Registered protocol family 1
> [    3.637952] pci 0003:01:00.0: enabling device (0000 -> 0002)
> [    3.643588] PCI: CLS 64 bytes, default 128
> [    3.647680] Unpacking initramfs...
> [    4.765579] Freeing initrd memory: 75272K
> [    4.769650] qcom-pmu-extensions QCOM8150:00: PCC support detected
> [    4.775519] hw perfevents: enabled with qcom_pmuv3_0 PMU driver, 9 counters available
> [    4.782778] Enabled QCOM QOS feature, number of ids 240
> [    4.788044] qcom-qos QCOM8102:00: Property 'ccm_scale' not defined, set def scale 2560
> [    4.795705] qcom-qos QCOM8102:00: Registered QOS CCM PMU, type: 7
> [    4.801913] kvm [1]: 16-bit VMID
> [    4.804992] kvm [1]: IDMAP page: 114c3000
> [    4.808983] kvm [1]: HYP VA range: 800000000000:ffffffffffff
> [    4.815160] kvm [1]: GICv3: no GICV resource entry
> [    4.819405] kvm [1]: disabling GICv2 emulation
> [    4.823885] kvm [1]: GIC system register CPU interface enabled
> [    4.830232] kvm [1]: vgic interrupt IRQ1
> [    4.833554] kvm [1]: virtual timer IRQ3
> [    4.837908] kvm [1]: Hyp mode initialized successfully
> [    4.843625] audit: initializing netlink subsys (disabled)
> [    4.848138] audit: type=2000 audit(3.812:1): state=initialized audit_enabled=0 res=1
> [    4.848283] Initialise system trusted keyrings
> [    4.848295] Key type blacklist registered
> [    4.848333] workingset: timestamp_bits=40 max_order=25 bucket_order=0
> [    4.849567] zbud: loaded
> [    4.850169] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [    4.850347] fuse init (API version 7.26)
> [    4.852355] Key type asymmetric registered
> [    4.852356] Asymmetric key parser 'x509' registered
> [    4.852405] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
> [    4.852504] io scheduler noop registered
> [    4.852505] io scheduler deadline registered
> [    4.852562] io scheduler cfq registered (default)
> [    4.912669] qcom-irq-combiner QCOM80B1:00: Initialized with [p=111,n=29,r=ffff0000085bd018]
> [    4.920439] qcom-irq-combiner QCOM80B1:01: Initialized with [p=112,n=12,r=ffff00000860d024]
> [    4.928761] qcom-irq-combiner QCOM80B1:02: Initialized with [p=113,n=16,r=ffff00000863d038]
> [    4.937089] qcom-irq-combiner QCOM80B1:03: Initialized with [p=114,n=18,r=ffff00000868d03c]
> [    4.954274] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
> [    4.965535] thermal LNXTHERM:00: registered as thermal_zone0
> [    4.971128] ACPI: Thermal Zone [TZ0] (31 C)
> [    4.975412] thermal LNXTHERM:01: registered as thermal_zone1
> [    4.980937] ACPI: Thermal Zone [TZ1] (26 C)
> [    4.985217] thermal LNXTHERM:02: registered as thermal_zone2
> [    4.990746] ACPI: Thermal Zone [TZ2] (25 C)
> [    4.995026] thermal LNXTHERM:03: registered as thermal_zone3
> [    5.000555] ACPI: Thermal Zone [TZ3] (25 C)
> [    5.004834] thermal LNXTHERM:04: registered as thermal_zone4
> [    5.010364] ACPI: Thermal Zone [TZ4] (25 C)
> [    5.014639] thermal LNXTHERM:05: registered as thermal_zone5
> [    5.020173] ACPI: Thermal Zone [TZ5] (25 C)
> [    5.024452] thermal LNXTHERM:06: registered as thermal_zone6
> [    5.029982] ACPI: Thermal Zone [TZ6] (23 C)
> [    5.034257] thermal LNXTHERM:07: registered as thermal_zone7
> [    5.039794] ACPI: Thermal Zone [TZ7] (24 C)
> [    5.044068] thermal LNXTHERM:08: registered as thermal_zone8
> [    5.049600] ACPI: Thermal Zone [TZ8] (24 C)
> [    5.053875] thermal LNXTHERM:09: registered as thermal_zone9
> [    5.059409] ACPI: Thermal Zone [TZ9] (23 C)
> [    5.063688] thermal LNXTHERM:0a: registered as thermal_zone10
> [    5.069305] ACPI: Thermal Zone [TZ10] (23 C)
> [    5.073671] thermal LNXTHERM:0d: registered as thermal_zone11
> [    5.079288] ACPI: Thermal Zone [TZ13] (25 C)
> [    5.083650] thermal LNXTHERM:0e: registered as thermal_zone12
> [    5.089270] ACPI: Thermal Zone [TZ14] (24 C)
> [    5.093632] thermal LNXTHERM:0f: registered as thermal_zone13
> [    5.099253] ACPI: Thermal Zone [TZ15] (25 C)
> [    5.103617] thermal LNXTHERM:10: registered as thermal_zone14
> [    5.109235] ACPI: Thermal Zone [TZ16] (24 C)
> [    5.113598] thermal LNXTHERM:11: registered as thermal_zone15
> [    5.119218] ACPI: Thermal Zone [TZ17] (23 C)
> [    5.123580] thermal LNXTHERM:12: registered as thermal_zone16
> [    5.129200] ACPI: Thermal Zone [TZ18] (25 C)
> [    5.133564] thermal LNXTHERM:13: registered as thermal_zone17
> [    5.139183] ACPI: Thermal Zone [TZ19] (25 C)
> [    5.143548] thermal LNXTHERM:14: registered as thermal_zone18
> [    5.149166] ACPI: Thermal Zone [TZ20] (25 C)
> [    5.153527] thermal LNXTHERM:15: registered as thermal_zone19
> [    5.159149] ACPI: Thermal Zone [TZ21] (25 C)
> [    5.163510] thermal LNXTHERM:16: registered as thermal_zone20
> [    5.169134] ACPI: Thermal Zone [TZ22] (25 C)
> [    5.173497] thermal LNXTHERM:17: registered as thermal_zone21
> [    5.179114] ACPI: Thermal Zone [TZ23] (25 C)
> [    5.183480] thermal LNXTHERM:18: registered as thermal_zone22
> [    5.189097] ACPI: Thermal Zone [TZ24] (24 C)
> [    5.193457] thermal LNXTHERM:19: registered as thermal_zone23
> [    5.199079] ACPI: Thermal Zone [TZ25] (24 C)
> [    5.203440] thermal LNXTHERM:1a: registered as thermal_zone24
> [    5.209061] ACPI: Thermal Zone [TZ26] (25 C)
> [    5.213427] thermal LNXTHERM:1b: registered as thermal_zone25
> [    5.219044] ACPI: Thermal Zone [TZ27] (25 C)
> [    5.223407] thermal LNXTHERM:1c: registered as thermal_zone26
> [    5.229027] ACPI: Thermal Zone [TZ28] (25 C)
> [    5.233390] thermal LNXTHERM:1d: registered as thermal_zone27
> [    5.239010] ACPI: Thermal Zone [TZ29] (24 C)
> [    5.243371] thermal LNXTHERM:1e: registered as thermal_zone28
> [    5.248992] ACPI: Thermal Zone [TZ30] (25 C)
> [    5.253355] thermal LNXTHERM:1f: registered as thermal_zone29
> [    5.258975] ACPI: Thermal Zone [TZ31] (25 C)
> [    5.263338] thermal LNXTHERM:20: registered as thermal_zone30
> [    5.268958] ACPI: Thermal Zone [TZ32] (24 C)
> [    5.273323] thermal LNXTHERM:21: registered as thermal_zone31
> [    5.278940] ACPI: Thermal Zone [TZ33] (24 C)
> [    5.283302] thermal LNXTHERM:22: registered as thermal_zone32
> [    5.288923] ACPI: Thermal Zone [TZ34] (24 C)
> [    5.293283] thermal LNXTHERM:23: registered as thermal_zone33
> [    5.298908] ACPI: Thermal Zone [TZ35] (24 C)
> [    5.303273] thermal LNXTHERM:24: registered as thermal_zone34
> [    5.308888] ACPI: Thermal Zone [TZ36] (25 C)
> [    5.313250] thermal LNXTHERM:25: registered as thermal_zone35
> [    5.318871] ACPI: Thermal Zone [TZ37] (25 C)
> [    5.323233] thermal LNXTHERM:26: registered as thermal_zone36
> [    5.328853] ACPI: Thermal Zone [TZ38] (25 C)
> [    5.333215] thermal LNXTHERM:27: registered as thermal_zone37
> [    5.338836] ACPI: Thermal Zone [TZ39] (25 C)
> [    5.343200] thermal LNXTHERM:28: registered as thermal_zone38
> [    5.348819] ACPI: Thermal Zone [TZ40] (24 C)
> [    5.353180] thermal LNXTHERM:29: registered as thermal_zone39
> [    5.358802] ACPI: Thermal Zone [TZ41] (24 C)
> [    5.363170] thermal LNXTHERM:2a: registered as thermal_zone40
> [    5.368784] ACPI: Thermal Zone [TZ42] (25 C)
> [    5.373149] thermal LNXTHERM:2b: registered as thermal_zone41
> [    5.378771] ACPI: Thermal Zone [TZ43] (25 C)
> [    5.383142] thermal LNXTHERM:2c: registered as thermal_zone42
> [    5.388753] ACPI: Thermal Zone [TZ44] (25 C)
> [    5.393117] thermal LNXTHERM:2d: registered as thermal_zone43
> [    5.398733] ACPI: Thermal Zone [TZ45] (25 C)
> [    5.403096] thermal LNXTHERM:2e: registered as thermal_zone44
> [    5.408715] ACPI: Thermal Zone [TZ46] (25 C)
> [    5.413077] thermal LNXTHERM:2f: registered as thermal_zone45
> [    5.418697] ACPI: Thermal Zone [TZ47] (25 C)
> [    5.423061] thermal LNXTHERM:30: registered as thermal_zone46
> [    5.428683] ACPI: Thermal Zone [TZ48] (26 C)
> [    5.433043] thermal LNXTHERM:31: registered as thermal_zone47
> [    5.438663] ACPI: Thermal Zone [TZ49] (31 C)
> [    5.443020] thermal LNXTHERM:32: registered as thermal_zone48
> [    5.448645] ACPI: Thermal Zone [TZ50] (19 C)
> [    5.453002] thermal LNXTHERM:33: registered as thermal_zone49
> [    5.458627] ACPI: Thermal Zone [TZ51] (25 C)
> [    5.462987] thermal LNXTHERM:34: registered as thermal_zone50
> [    5.468610] ACPI: Thermal Zone [TZ52] (26 C)
> [    5.472969] thermal LNXTHERM:35: registered as thermal_zone51
> [    5.478593] ACPI: Thermal Zone [TZ53] (24 C)
> [    5.482953] thermal LNXTHERM:36: registered as thermal_zone52
> [    5.488575] ACPI: Thermal Zone [TZ54] (24 C)
> [    5.492935] thermal LNXTHERM:37: registered as thermal_zone53
> [    5.498558] ACPI: Thermal Zone [TZ55] (24 C)
> [    5.502919] thermal LNXTHERM:38: registered as thermal_zone54
> [    5.508541] ACPI: Thermal Zone [TZ56] (23 C)
> [    5.512900] thermal LNXTHERM:39: registered as thermal_zone55
> [    5.518524] ACPI: Thermal Zone [TZ57] (24 C)
> [    5.522882] thermal LNXTHERM:3a: registered as thermal_zone56
> [    5.528506] ACPI: Thermal Zone [TZ58] (24 C)
> [    5.533020] ghes_edac: This EDAC driver relies on BIOS to enumerate memory and get error reports.
> [    5.541617] ghes_edac: Unfortunately, not all BIOSes reflect the memory layout correctly.
> [    5.549771] ghes_edac: So, the end result of using this driver varies from vendor to vendor.
> [    5.558195] ghes_edac: If you find incorrect reports, please contact your hardware vendor
> [    5.566351] ghes_edac: to correct its BIOS.
> [    5.570518] ghes_edac: This system has 6 DIMM sockets.
> [    5.575768] EDAC MC0: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    5.585157] EDAC MC1: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    5.594613] EDAC MC2: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    5.604071] EDAC MC3: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    5.613530] EDAC MC4: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    5.623086] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
> [    5.630411] ACPI GTDT: found 1 SBSA generic Watchdog(s).
> [    5.637075] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [    5.644326] msm_serial: driver initialized
> [    5.647933] arm-smmu-v3 arm-smmu-v3.0.auto: option mask 0x0
> [    5.653050] arm-smmu-v3 arm-smmu-v3.0.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    5.661097] arm-smmu-v3 arm-smmu-v3.0.auto: SMMU currently enabled! Resetting...
> [    5.668476] arm-smmu-v3 arm-smmu-v3.0.auto: msi_domain absent - falling back to wired irqs
> [    5.676931] arm-smmu-v3 arm-smmu-v3.1.auto: option mask 0x0
> [    5.682287] arm-smmu-v3 arm-smmu-v3.1.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    5.690350] arm-smmu-v3 arm-smmu-v3.1.auto: SMMU currently enabled! Resetting...
> [    5.697728] arm-smmu-v3 arm-smmu-v3.1.auto: msi_domain absent - falling back to wired irqs
> [    5.706121] arm-smmu-v3 arm-smmu-v3.2.auto: option mask 0x0
> [    5.711536] arm-smmu-v3 arm-smmu-v3.2.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    5.719601] arm-smmu-v3 arm-smmu-v3.2.auto: SMMU currently enabled! Resetting...
> [    5.726981] arm-smmu-v3 arm-smmu-v3.2.auto: msi_domain absent - falling back to wired irqs
> [    5.735369] arm-smmu-v3 arm-smmu-v3.3.auto: option mask 0x0
> [    5.740791] arm-smmu-v3 arm-smmu-v3.3.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    5.748856] arm-smmu-v3 arm-smmu-v3.3.auto: SMMU currently enabled! Resetting...
> [    5.756235] arm-smmu-v3 arm-smmu-v3.3.auto: msi_domain absent - falling back to wired irqs
> [    5.764625] arm-smmu-v3 arm-smmu-v3.4.auto: option mask 0x0
> [    5.770048] arm-smmu-v3 arm-smmu-v3.4.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    5.778108] arm-smmu-v3 arm-smmu-v3.4.auto: SMMU currently enabled! Resetting...
> [    5.785489] arm-smmu-v3 arm-smmu-v3.4.auto: msi_domain absent - falling back to wired irqs
> [    5.793877] arm-smmu-v3 arm-smmu-v3.5.auto: option mask 0x0
> [    5.799302] arm-smmu-v3 arm-smmu-v3.5.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    5.807363] arm-smmu-v3 arm-smmu-v3.5.auto: SMMU currently enabled! Resetting...
> [    5.814744] arm-smmu-v3 arm-smmu-v3.5.auto: msi_domain absent - falling back to wired irqs
> [    5.823589] cacheinfo: Unable to detect cache hierarchy for CPU 0
> [    5.833424] loop: module loaded
> [    5.836086] mdio_bus fixed-0: GPIO lookup for consumer reset
> [    5.841253] mdio_bus fixed-0: using lookup tables for GPIO lookup
> [    5.847325] mdio_bus fixed-0: lookup for GPIO reset failed
> [    5.852799] libphy: Fixed MDIO Bus: probed
> [    5.856872] tun: Universal TUN/TAP device driver, 1.6
> [    5.862344] PPP generic driver version 2.4.2
> [    5.866299] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    5.872680] ehci-pci: EHCI PCI platform driver
> [    5.877113] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    5.883263] ohci-pci: OHCI PCI platform driver
> [    5.887696] uhci_hcd: USB Universal Host Controller Interface driver
> [    5.894180] mousedev: PS/2 mouse device common for all mice
> [    5.899885] rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc0
> [    5.905820] i2c /dev entries driver
> [    5.909631] device-mapper: uevent: version 1.0.3
> [    5.913855] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised: dm-devel@redhat.com
> [    5.923929] ledtrig-cpu: registered to indicate activity on CPUs
> [    5.929043] EFI Variables Facility v0.08 2004-May-17
> [    5.935411] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 0
> [    5.941426] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 1
> [    5.948368] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 2
> [    5.955307] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 3
> [    5.962250] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 4
> [    5.969195] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 5
> [    5.976140] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 6
> [    5.983084] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 7
> [    5.990028] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 8
> [    5.996973] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 9
> [    6.003917] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 10
> [    6.010948] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 11
> [    6.017980] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 12
> [    6.025011] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 13
> [    6.032042] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 14
> [    6.039074] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 15
> [    6.046104] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 16
> [    6.053135] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 17
> [    6.060168] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 18
> [    6.067200] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 19
> [    6.074229] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 20
> [    6.081262] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 21
> [    6.088293] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 22
> [    6.095323] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 23
> [    6.102399] qcom-l2cache-pmu QCOM8130:00: CPU0 associated with cluster 0
> [    6.109103] qcom-l2cache-pmu QCOM8130:00: CPU1 associated with cluster 1
> [    6.115786] qcom-l2cache-pmu QCOM8130:00: CPU2 associated with cluster 2
> [    6.122434] qcom-l2cache-pmu QCOM8130:00: CPU3 associated with cluster 3
> [    6.129162] qcom-l2cache-pmu QCOM8130:00: CPU4 associated with cluster 4
> [    6.135852] qcom-l2cache-pmu QCOM8130:00: CPU5 associated with cluster 5
> [    6.142535] qcom-l2cache-pmu QCOM8130:00: CPU6 associated with cluster 7
> [    6.149219] qcom-l2cache-pmu QCOM8130:00: CPU7 associated with cluster 8
> [    6.155906] qcom-l2cache-pmu QCOM8130:00: CPU8 associated with cluster 9
> [    6.162591] qcom-l2cache-pmu QCOM8130:00: CPU9 associated with cluster 10
> [    6.169360] qcom-l2cache-pmu QCOM8130:00: CPU10 associated with cluster 11
> [    6.176218] qcom-l2cache-pmu QCOM8130:00: CPU11 associated with cluster 12
> [    6.183076] qcom-l2cache-pmu QCOM8130:00: CPU12 associated with cluster 13
> [    6.189892] qcom-l2cache-pmu QCOM8130:00: CPU13 associated with cluster 14
> [    6.196743] qcom-l2cache-pmu QCOM8130:00: CPU14 associated with cluster 15
> [    6.203628] qcom-l2cache-pmu QCOM8130:00: CPU15 associated with cluster 16
> [    6.210495] qcom-l2cache-pmu QCOM8130:00: CPU16 associated with cluster 17
> [    6.217354] qcom-l2cache-pmu QCOM8130:00: CPU17 associated with cluster 18
> [    6.224212] qcom-l2cache-pmu QCOM8130:00: CPU18 associated with cluster 19
> [    6.231058] qcom-l2cache-pmu QCOM8130:00: CPU19 associated with cluster 20
> [    6.237914] qcom-l2cache-pmu QCOM8130:00: CPU20 associated with cluster 21
> [    6.244771] qcom-l2cache-pmu QCOM8130:00: CPU21 associated with cluster 22
> [    6.251629] qcom-l2cache-pmu QCOM8130:00: CPU22 associated with cluster 23
> [    6.258523] qcom-l2cache-pmu QCOM8130:00: CPU23 associated with cluster 0
> [    6.265304] qcom-l2cache-pmu QCOM8130:00: CPU24 associated with cluster 1
> [    6.272071] qcom-l2cache-pmu QCOM8130:00: CPU25 associated with cluster 2
> [    6.278842] qcom-l2cache-pmu QCOM8130:00: CPU26 associated with cluster 3
> [    6.285611] qcom-l2cache-pmu QCOM8130:00: CPU27 associated with cluster 4
> [    6.292384] qcom-l2cache-pmu QCOM8130:00: CPU28 associated with cluster 6
> [    6.299156] qcom-l2cache-pmu QCOM8130:00: CPU29 associated with cluster 7
> [    6.305923] qcom-l2cache-pmu QCOM8130:00: CPU30 associated with cluster 8
> [    6.312697] qcom-l2cache-pmu QCOM8130:00: CPU31 associated with cluster 9
> [    6.319469] qcom-l2cache-pmu QCOM8130:00: CPU32 associated with cluster 10
> [    6.326325] qcom-l2cache-pmu QCOM8130:00: CPU33 associated with cluster 11
> [    6.333181] qcom-l2cache-pmu QCOM8130:00: CPU34 associated with cluster 12
> [    6.340040] qcom-l2cache-pmu QCOM8130:00: CPU35 associated with cluster 13
> [    6.346859] qcom-l2cache-pmu QCOM8130:00: CPU36 associated with cluster 14
> [    6.353714] qcom-l2cache-pmu QCOM8130:00: CPU37 associated with cluster 15
> [    6.360612] qcom-l2cache-pmu QCOM8130:00: CPU38 associated with cluster 16
> [    6.367428] qcom-l2cache-pmu QCOM8130:00: CPU39 associated with cluster 17
> [    6.374281] qcom-l2cache-pmu QCOM8130:00: CPU40 associated with cluster 18
> [    6.381138] qcom-l2cache-pmu QCOM8130:00: CPU41 associated with cluster 19
> [    6.388035] qcom-l2cache-pmu QCOM8130:00: CPU42 associated with cluster 20
> [    6.394902] qcom-l2cache-pmu QCOM8130:00: CPU43 associated with cluster 21
> [    6.401759] qcom-l2cache-pmu QCOM8130:00: CPU44 associated with cluster 22
> [    6.408616] qcom-l2cache-pmu QCOM8130:00: CPU45 associated with cluster 23
> [    6.415475] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU using 24 HW PMUs
> [    6.425728] qcom-l3cache-pmu QCOM8081:00: Registered l3cache_0_0, type: 9
> [    6.433918] qcom-l3cache-pmu QCOM8081:01: Registered l3cache_0_1, type: 10
> [    6.442174] qcom-l3cache-pmu QCOM8081:02: Registered l3cache_0_2, type: 11
> [    6.450415] qcom-l3cache-pmu QCOM8081:03: Registered l3cache_0_3, type: 12
> [    6.458658] qcom-l3cache-pmu QCOM8081:04: Registered l3cache_0_4, type: 13
> [    6.466899] qcom-l3cache-pmu QCOM8081:05: Registered l3cache_0_5, type: 14
> [    6.475141] qcom-l3cache-pmu QCOM8081:06: Registered l3cache_0_6, type: 15
> [    6.483385] qcom-l3cache-pmu QCOM8081:07: Registered l3cache_0_7, type: 16
> [    6.491624] qcom-l3cache-pmu QCOM8081:08: Registered l3cache_0_8, type: 17
> [    6.499865] qcom-l3cache-pmu QCOM8081:09: Registered l3cache_0_9, type: 18
> [    6.508107] qcom-l3cache-pmu QCOM8081:0a: Registered l3cache_0_10, type: 19
> [    6.516450] qcom-l3cache-pmu QCOM8081:0b: Registered l3cache_0_11, type: 20
> [    6.522858] NET: Registered protocol family 10
> [    6.535973] Segment Routing with IPv6
> [    6.538702] NET: Registered protocol family 17
> [    6.543275] Key type dns_resolver registered
> [    6.547984] registered taskstats version 1
> [    6.551454] Loading compiled-in X.509 certificates
> [    6.560947] Loaded X.509 cert 'Build time autogenerated kernel key: ea7718ec66a9224983a1a9a6eb5015ebf4889903'
> [    6.569975] zswap: loaded using pool lzo/zbud
> [    6.579809] aes_arm64: module verification failed: signature and/or required key missing - tainting kernel
> [    6.595799] Key type big_key registered
> [    6.598689] Key type trusted registered
> [    6.606925] Key type encrypted registered
> [    6.609976] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
> [    6.616267] evm: HMAC attrs: 0x1
> [    6.619659] iommu: Adding device 0001:00:00.0 to group 0
> [    6.624918] PCI Interrupt Link [LN1A] enabled at IRQ 92
> [    6.630054] pcieport 0001:00:00.0: Signaling PME with IRQ 134
> [    6.635703] pciehp 0001:00:00.0:pcie004: Slot #1 AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surprise- Interlock+ NoCompl- LLActRep+
> [    6.648160] iommu: Adding device 0002:00:00.0 to group 1
> [    6.653460] PCI Interrupt Link [LN2A] enabled at IRQ 96
> [    6.658601] pcieport 0002:00:00.0: Signaling PME with IRQ 136
> [    6.664256] pciehp 0002:00:00.0:pcie004: Slot #2 AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surprise- Interlock+ NoCompl- LLActRep+
> [    6.676715] iommu: Adding device 0003:00:00.0 to group 2
> [    6.682024] PCI Interrupt Link [LN3A] enabled at IRQ 100
> [    6.687241] pcieport 0003:00:00.0: Signaling PME with IRQ 138
> [    6.692900] pciehp 0003:00:00.0:pcie004: Slot #4 AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surprise- Interlock+ NoCompl- LLActRep+
> [    6.705460] rtc-efi rtc-efi: setting system clock to 2018-03-01 17:46:15 UTC (1519926375)
> [    6.715747] Freeing unused kernel memory: 5312K
> [    6.719866] Checked W+X mappings: passed, no W+X pages found
> [    6.857506] gpio gpiochip0: (QCOM8002:00): added GPIO chardev (254:0)
> [    6.858440] sdhci: Secure Digital Host Controller Interface driver
> [    6.858441] sdhci: Copyright(c) Pierre Ossman
> [    6.873534] gpiochip_setup_dev: registered GPIOs 0 to 149 on device: gpiochip0 (QCOM8002:00)
> [    6.881916] gpio gpiochip0: (QCOM8002:00): created GPIO range 0->149 ==> QCOM8002:00 PIN 0->149
> [    6.881974] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [    6.897428] i2c_qup QCOM8010:00:
>                 tx channel not available
> [    6.897485] pps_core: LinuxPPS API ver. 1 registered
> [    6.897486] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    6.898159] PTP clock support registered
> [    6.901682] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
> [    6.901683] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [    6.901721] pcieport 0002:00:00.0: Using QCOM ACS Quirk (1)
> [    6.901742] iommu: Adding device 0002:01:00.0 to group 3
> [    6.902008] e1000e 0002:01:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    6.902012] e1000e 0002:01:00.0: Interrupt Mode set to 1
> [    6.969072] i2c_qup QCOM8010:01:
>                 tx channel not available
> [    6.986824] pcieport 0003:00:00.0: Using QCOM ACS Quirk (1)
> [    6.991469] iommu: Adding device 0003:01:00.0 to group 4
> [    6.996997] mlx5_core 0003:01:00.0: firmware version: 14.14.1100
> [    7.003302] xhci-hcd QCOM8041:00: xHCI Host Controller
> [    7.005032] ipmi message handler version 39.2
> [    7.005570] ipmi device interface
> [    7.006887] IPMI System Interface driver.
> [    7.006902] ipmi_si: probing via SPMI
> [    7.006920] ipmi_si: Unable to find any System Interface(s)
> [    7.027144] IPMI SSIF Interface driver
> [    7.027269] acpi IPI0001:00: GPIO: looking up 0 in _CRS
> [    7.027319] ipmi_ssif: Trying ACPI-specified SSIF interface at i2c address 0x42, adapter QUP I2C adapter, slave address 0x0
> [    7.048735] xhci-hcd QCOM8041:00: new USB bus registered, assigned bus number 1
> [    7.056171] xhci-hcd QCOM8041:00: hcc params 0x0220f665 hci version 0x100 quirks 0x00010010
> [    7.064366] xhci-hcd QCOM8041:00: irq 115, io mem 0xff79800000
> [    7.070219] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    7.074908] e1000e 0002:01:00.0 eth0: (PCI Express:2.5GT/s:Width x4) 00:1b:21:bd:07:f0
> [    7.074909] e1000e 0002:01:00.0 eth0: Intel(R) PRO/1000 Network Connection
> [    7.074991] e1000e 0002:01:00.0 eth0: MAC: 0, PHY: 4, PBA No: D50868-006
> [    7.075028] pcieport 0002:00:00.0: Using QCOM ACS Quirk (1)
> [    7.075046] iommu: Adding device 0002:01:00.1 to group 5
> [    7.075216] PCI Interrupt Link [LN2B] enabled at IRQ 97
> [    7.075300] e1000e 0002:01:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [    7.123728] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    7.130932] usb usb1: Product: xHCI Host Controller
> [    7.135793] usb usb1: Manufacturer: Linux 4.14.14 xhci-hcd
> [    7.141262] usb usb1: SerialNumber: QCOM8041:00
> [    7.146014] hub 1-0:1.0: USB hub found
> [    7.149522] hub 1-0:1.0: 1 port detected
> [    7.153512] xhci-hcd QCOM8041:00: xHCI Host Controller
> [    7.158542] xhci-hcd QCOM8041:00: new USB bus registered, assigned bus number 2
> [    7.165846] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
> [    7.173925] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
> [    7.180673] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    7.187877] usb usb2: Product: xHCI Host Controller
> [    7.192740] usb usb2: Manufacturer: Linux 4.14.14 xhci-hcd
> [    7.198206] usb usb2: SerialNumber: QCOM8041:00
> [    7.202948] hub 2-0:1.0: USB hub found
> [    7.206472] hub 2-0:1.0: config failed, hub doesn't have any ports! (err -19)
> [    7.213303] ipmi_ssif i2c-IPI0001:00: Found new BMC (man_id: 0x0005a9, prod_id: 0x0001, dev_id: 0x20)
> [    7.223012] xhci-hcd QCOM8041:01: xHCI Host Controller
> [    7.227908] xhci-hcd QCOM8041:01: new USB bus registered, assigned bus number 3
> [    7.235327] xhci-hcd QCOM8041:01: hcc params 0x0220f665 hci version 0x100 quirks 0x00010010
> [    7.243537] xhci-hcd QCOM8041:01: irq 116, io mem 0xff79a00000
> [    7.249379] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    7.250885] e1000e 0002:01:00.1 eth1: (PCI Express:2.5GT/s:Width x4) 00:1b:21:bd:07:f1
> [    7.250887] e1000e 0002:01:00.1 eth1: Intel(R) PRO/1000 Network Connection
> [    7.250968] e1000e 0002:01:00.1 eth1: MAC: 0, PHY: 4, PBA No: D50868-006
> [    7.277547] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    7.284752] usb usb3: Product: xHCI Host Controller
> [    7.289613] usb usb3: Manufacturer: Linux 4.14.14 xhci-hcd
> [    7.295081] usb usb3: SerialNumber: QCOM8041:01
> [    7.299818] hub 3-0:1.0: USB hub found
> [    7.303343] hub 3-0:1.0: 1 port detected
> [    7.307323] xhci-hcd QCOM8041:01: xHCI Host Controller
> [    7.312361] xhci-hcd QCOM8041:01: new USB bus registered, assigned bus number 4
> [    7.319665] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
> [    7.327746] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    7.334492] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    7.341696] usb usb4: Product: xHCI Host Controller
> [    7.346558] usb usb4: Manufacturer: Linux 4.14.14 xhci-hcd
> [    7.352026] usb usb4: SerialNumber: QCOM8041:01
> [    7.356768] hub 4-0:1.0: USB hub found
> [    7.360288] hub 4-0:1.0: config failed, hub doesn't have any ports! (err -19)
> [    7.367666] hidma-mgmt QCOM8060:00: HW rev: 1.1 @ 0x000000ff98000000 with 6 physical channels
> [    7.375994] hidma-mgmt QCOM8060:01: HW rev: 1.1 @ 0x000000ff9a000000 with 6 physical channels
> [    7.384849] hidma QCOM8062:00: HI-DMA engine driver registration complete
> [    7.391469] hidma QCOM8062:01: HI-DMA engine driver registration complete
> [    7.398443] mmc0: SDHCI controller on ACPI [QCOM8051:00] using PIO
> [    7.404890] mdio_bus QCOM8070:00: GPIO lookup for consumer reset
> [    7.410115] mdio_bus QCOM8070:00: using lookup tables for GPIO lookup
> [    7.416533] mdio_bus QCOM8070:00: lookup for GPIO reset failed
> [    7.425768] libphy: emac-mdio: probed
> [    7.428774] qcom-emac QCOM8070:00 eth2: hardware id 64.1, hardware version 1.3.0
> [    7.435992] ahci QCOM8090:00: SSS flag set, parallel bus scan disabled
> [    7.442382] ahci QCOM8090:00: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [    7.450695] ahci QCOM8090:00: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [    7.460955] scsi host0: ahci
> [    7.463536] ata1: SATA max UDMA/133 mmio [mem 0xff88000000-0xff880001ff] port 0x100 irq 28
> [    7.471786] ahci QCOM8090:01: SSS flag set, parallel bus scan disabled
> [    7.478221] ahci QCOM8090:01: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [    7.486545] ahci QCOM8090:01: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [    7.496823] scsi host1: ahci
> [    7.499379] ata2: SATA max UDMA/133 mmio [mem 0xff89000000-0xff890001ff] port 0x100 irq 29
> [    7.500670] mmc0: new high speed SDHC card at address aaaa
> [    7.500930] mmcblk0: mmc0:aaaa SE32G 29.7 GiB
> [    7.502010]  mmcblk0: p1
> [    7.520091] xhci-hcd QCOM8041:02: xHCI Host Controller
> [    7.525098] xhci-hcd QCOM8041:02: new USB bus registered, assigned bus number 5
> [    7.532517] xhci-hcd QCOM8041:02: hcc params 0x0220f665 hci version 0x100 quirks 0x00010010
> [    7.540723] xhci-hcd QCOM8041:02: irq 117, io mem 0xff79c00000
> [    7.546573] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
> [    7.553301] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    7.560502] usb usb5: Product: xHCI Host Controller
> [    7.565363] usb usb5: Manufacturer: Linux 4.14.14 xhci-hcd
> [    7.570831] usb usb5: SerialNumber: QCOM8041:02
> [    7.575571] hub 5-0:1.0: USB hub found
> [    7.579094] hub 5-0:1.0: 1 port detected
> [    7.583071] xhci-hcd QCOM8041:02: xHCI Host Controller
> [    7.588110] xhci-hcd QCOM8041:02: new USB bus registered, assigned bus number 6
> [    7.595416] usb usb6: We don't know the algorithms for LPM for this host, disabling LPM.
> [    7.603498] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
> [    7.610244] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    7.616679] (0003:01:00.0): E-Switch: Total vports 9, per vport: max uc(1024) max mc(16384)
> [    7.625780] usb usb6: Product: xHCI Host Controller
> [    7.630640] usb usb6: Manufacturer: Linux 4.14.14 xhci-hcd
> [    7.636111] usb usb6: SerialNumber: QCOM8041:02
> [    7.638529] mlx5_core 0003:01:00.0: Port module event: module 0, Cable plugged
> [    7.648050] hub 6-0:1.0: USB hub found
> [    7.651578] hub 6-0:1.0: config failed, hub doesn't have any ports! (err -19)
> [    7.653172] mlx5_core 0003:01:00.0: MLX5E: StrdRq(1) RqSz(8) StrdSz(128) RxCqeCmprss(0)
> [    7.666907] xhci-hcd QCOM8041:03: xHCI Host Controller
> [    7.671798] xhci-hcd QCOM8041:03: new USB bus registered, assigned bus number 7
> [    7.679221] xhci-hcd QCOM8041:03: hcc params 0x0220f665 hci version 0x100 quirks 0x00010010
> [    7.687427] xhci-hcd QCOM8041:03: irq 118, io mem 0xff79e00000
> [    7.693271] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
> [    7.700002] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    7.707204] usb usb7: Product: xHCI Host Controller
> [    7.712064] usb usb7: Manufacturer: Linux 4.14.14 xhci-hcd
> [    7.717533] usb usb7: SerialNumber: QCOM8041:03
> [    7.722272] hub 7-0:1.0: USB hub found
> [    7.725795] hub 7-0:1.0: 1 port detected
> [    7.729769] xhci-hcd QCOM8041:03: xHCI Host Controller
> [    7.734814] xhci-hcd QCOM8041:03: new USB bus registered, assigned bus number 8
> [    7.742116] usb usb8: We don't know the algorithms for LPM for this host, disabling LPM.
> [    7.750196] usb usb8: New USB device found, idVendor=1d6b, idProduct=0003
> [    7.756943] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    7.764147] usb usb8: Product: xHCI Host Controller
> [    7.769008] usb usb8: Manufacturer: Linux 4.14.14 xhci-hcd
> [    7.771563] mlx5_ib: Mellanox Connect-IB Infiniband driver v5.0-0
> [    7.780554] usb usb8: SerialNumber: QCOM8041:03
> [    7.785297] hub 8-0:1.0: USB hub found
> [    7.788815] hub 8-0:1.0: config failed, hub doesn't have any ports! (err -19)
> [    7.796080] hidma-mgmt QCOM8060:02: HW rev: 1.1 @ 0x000000ff9c000000 with 6 physical channels
> [    7.804505] hidma-mgmt QCOM8060:03: HW rev: 1.1 @ 0x000000ff9e000000 with 6 physical channels
> [    7.813357] hidma QCOM8062:02: HI-DMA engine driver registration complete
> [    7.820008] hidma QCOM8062:03: HI-DMA engine driver registration complete
> [    7.826575] ahci QCOM8090:02: SSS flag set, parallel bus scan disabled
> [    7.832997] ahci QCOM8090:02: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [    7.841319] ahci QCOM8090:02: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [    7.851515] scsi host2: ahci
> [    7.854127] ata3: SATA max UDMA/133 mmio [mem 0xff8a000000-0xff8a0001ff] port 0x100 irq 30
> [    7.862416] ahci QCOM8090:03: SSS flag set, parallel bus scan disabled
> [    7.868843] ahci QCOM8090:03: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [    7.877169] ahci QCOM8090:03: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [    7.887360] scsi host3: ahci
> [    7.889979] ata4: SATA max UDMA/133 mmio [mem 0xff8b000000-0xff8b0001ff] port 0x100 irq 31
> [    7.898513] hidma QCOM8062:04: HI-DMA engine driver registration complete
> [    7.905238] hidma QCOM8062:05: HI-DMA engine driver registration complete
> [    7.911816] ahci QCOM8090:04: SSS flag set, parallel bus scan disabled
> [    7.918238] ahci QCOM8090:04: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [    7.918394] usb 5-1: new high-speed USB device number 2 using xhci-hcd
> [    7.933072] ahci QCOM8090:04: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [    7.943262] scsi host4: ahci
> [    7.945884] ata5: SATA max UDMA/133 mmio [mem 0xff8c000000-0xff8c0001ff] port 0x100 irq 32
> [    7.946396] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    7.946553] ata1.00: ATA-9: Samsung SSD 845DC EVO 240GB, EXT03X3Q, max UDMA/133
> [    7.946554] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    7.946713] ata1.00: configured for UDMA/133
> [    7.946883] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 845D 3X3Q PQ: 0 ANSI: 5
> [    7.947044] ata1.00: Enabling discard_zeroes_data
> [    7.947084] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    7.947086] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/224 GiB)
> [    7.947096] sd 0:0:0:0: [sda] Write Protect is off
> [    7.947097] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    7.947110] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    7.947246] ata1.00: Enabling discard_zeroes_data
> [    7.948697]  sda: sda1 sda2
> [    7.948938] ata1.00: Enabling discard_zeroes_data
> [    7.949011] sd 0:0:0:0: [sda] Attached SCSI disk
> [    7.994438] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [    7.994727] ata2.00: ATA-9: MICRON_M510DC_MTFDDAK240MBP, 0013, max UDMA/133
> [    7.994729] ata2.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    8.006599] ata2.00: configured for UDMA/133
> [    8.006812] scsi 1:0:0:0: Direct-Access     ATA      MICRON_M510DC_MT 0013 PQ: 0 ANSI: 5
> [    8.007057] sd 1:0:0:0: [sdb] 468862128 512-byte logical blocks: (240 GB/224 GiB)
> [    8.007059] sd 1:0:0:0: [sdb] 4096-byte physical blocks
> [    8.007067] sd 1:0:0:0: [sdb] Write Protect is off
> [    8.007068] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    8.007080] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    8.007096] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    8.008465]  sdb: sdb1 sdb2
> [    8.008840] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    8.062436] usb 7-1: new high-speed USB device number 2 using xhci-hcd
> [    8.066528] usb 5-1: New USB device found, idVendor=0424, idProduct=2514
> [    8.066530] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    8.075495] hub 5-1:1.0: USB hub found
> [    8.075588] hub 5-1:1.0: 4 ports detected
> [    8.144204] ahci QCOM8090:05: SSS flag set, parallel bus scan disabled
> [    8.150621] ahci QCOM8090:05: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [    8.158942] ahci QCOM8090:05: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [    8.169118] scsi host5: ahci
> [    8.171761] ata6: SATA max UDMA/133 mmio [mem 0xff8d000000-0xff8d0001ff] port 0x100 irq 33
> [    8.177537] ata3: SATA link down (SStatus 0 SControl 300)
> [    8.185657] hidma QCOM8062:06: HI-DMA engine driver registration complete
> [    8.192400] hidma QCOM8062:07: HI-DMA engine driver registration complete
> [    8.198968] ahci QCOM8090:06: SSS flag set, parallel bus scan disabled
> [    8.205391] ahci QCOM8090:06: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [    8.211069] usb 7-1: New USB device found, idVendor=0624, idProduct=0249
> [    8.211071] usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    8.211072] usb 7-1: Product: USB Composite Device-1
> [    8.211073] usb 7-1: Manufacturer: Avocent
> [    8.211074] usb 7-1: SerialNumber: 20120430-1
> [    8.213502] ata4: SATA link down (SStatus 0 SControl 300)
> [    8.230972] usb-storage 7-1:1.0: USB Mass Storage device detected
> [    8.231295] scsi host6: usb-storage 7-1:1.0
> [    8.231383] usbcore: registered new interface driver usb-storage
> [    8.232101] usbcore: registered new interface driver uas
> [    8.267795] ahci QCOM8090:06: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [    8.278070] scsi host7: ahci
> [    8.280632] ata7: SATA max UDMA/133 mmio [mem 0xff8e000000-0xff8e0001ff] port 0x100 irq 34
> [    8.288996] ahci QCOM8090:07: SSS flag set, parallel bus scan disabled
> [    8.295327] ahci QCOM8090:07: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [    8.303646] ahci QCOM8090:07: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [    8.313887] scsi host8: ahci
> [    8.316478] ata8: SATA max UDMA/133 mmio [mem 0xff8f000000-0xff8f0001ff] port 0x100 irq 35
> [    8.324979] hidma QCOM8062:08: HI-DMA engine driver registration complete
> [    8.331720] hidma QCOM8062:09: HI-DMA engine driver registration complete
> [    8.338490] hidma QCOM8062:0a: HI-DMA engine driver registration complete
> [    8.345254] hidma QCOM8062:0b: HI-DMA engine driver registration complete
> [    8.352021] hidma QCOM8062:0c: HI-DMA engine driver registration complete
> [    8.358797] hidma QCOM8062:0d: HI-DMA engine driver registration complete
> [    8.365571] hidma QCOM8062:0e: HI-DMA engine driver registration complete
> [    8.372345] hidma QCOM8062:0f: HI-DMA engine driver registration complete
> [    8.379114] hidma QCOM8062:10: HI-DMA engine driver registration complete
> [    8.385884] hidma QCOM8062:11: HI-DMA engine driver registration complete
> [    8.392768] hidma QCOM8062:12: HI-DMA engine driver registration complete
> [    8.394434] usb 5-1.1: new full-speed USB device number 3 using xhci-hcd
> [    8.406217] hidma QCOM8062:13: HI-DMA engine driver registration complete
> [    8.412986] hidma QCOM8062:14: HI-DMA engine driver registration complete
> [    8.419766] hidma QCOM8062:15: HI-DMA engine driver registration complete
> [    8.426550] hidma QCOM8062:16: HI-DMA engine driver registration complete
> [    8.433306] hidma QCOM8062:17: HI-DMA engine driver registration complete
> [    8.458283] ata5: SATA link down (SStatus 0 SControl 300)
> [    8.495527] usb 5-1.1: New USB device found, idVendor=0624, idProduct=0248
> [    8.501353] ata6: SATA link down (SStatus 0 SControl 300)
> [    8.506824] usb 5-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    8.514116] usb 5-1.1: Product: USB Composite Device-0
> [    8.519236] usb 5-1.1: Manufacturer: Avocent
> [    8.523490] usb 5-1.1: SerialNumber: 20120430
> [    8.577488] hidraw: raw HID events driver (C) Jiri Kosina
> [    8.585201] usbcore: registered new interface driver usbhid
> [    8.589823] usbhid: USB HID core driver
> [    8.594555] input: Avocent USB Composite Device-0 as /devices/platform/QCOM8041:02/usb5/5-1/5-1.1/5-1.1:1.0/0003:0624:0248.0001/input/input0
> [    8.601357] ata7: SATA link down (SStatus 0 SControl 300)
> [    8.637117] ata8: SATA link down (SStatus 0 SControl 300)
> [    8.670526] hid-generic 0003:0624:0248.0001: input,hidraw0: USB HID v1.00 Keyboard [Avocent USB Composite Device-0] on usb-QCOM8041:02-1.1/input0
> [    8.682701] input: Avocent USB Composite Device-0 as /devices/platform/QCOM8041:02/usb5/5-1/5-1.1/5-1.1:1.1/0003:0624:0248.0002/input/input1
> [    8.695310] hid-generic 0003:0624:0248.0002: input,hidraw1: USB HID v1.00 Mouse [Avocent USB Composite Device-0] on usb-QCOM8041:02-1.1/input1
> [    8.708034] input: Avocent USB Composite Device-0 as /devices/platform/QCOM8041:02/usb5/5-1/5-1.1/5-1.1:1.2/0003:0624:0248.0003/input/input2
> [    8.720673] hid-generic 0003:0624:0248.0003: input,hidraw2: USB HID v1.00 Mouse [Avocent USB Composite Device-0] on usb-QCOM8041:02-1.1/input2
> [    8.848478] usb 5-1.2: new full-speed USB device number 4 using xhci-hcd
> [    8.960857] usb 5-1.2: New USB device found, idVendor=05c6, idProduct=9302
> [    8.966774] usb 5-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=128
> [    8.974236] usb 5-1.2: Product: Embedded Power Measurement (EPM) device
> [    8.980833] usb 5-1.2: Manufacturer: QUALCOMM Inc.
> [    8.985607] usb 5-1.2: SerialNumber: 070E0AF902165400
> [    9.006935] cdc_acm 5-1.2:1.1: ttyACM0: USB ACM device
> [    9.011447] usbcore: registered new interface driver cdc_acm
> [    9.016764] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
> [    9.255031] scsi 6:0:0:0: CD-ROM            MP EMS   Virtual Media    0399 PQ: 0 ANSI: 0
> [    9.262574] scsi 6:0:0:1: Direct-Access     MP EMS   Virtual Media    0399 PQ: 0 ANSI: 0 CCS
> [    9.270977] scsi 6:0:0:2: Direct-Access     MP EMS   Virtual Media    0399 PQ: 0 ANSI: 0 CCS
> [    9.280158] sr 6:0:0:0: [sr0] scsi3-mmc drive: 0x/0x cd/rw caddy
> [    9.285209] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    9.290635] sr 6:0:0:0: Attached scsi CD-ROM sr0
> [    9.295190] sr 6:0:0:0: Attached scsi generic sg2 type 5
> [    9.300612] sd 6:0:0:1: Attached scsi generic sg3 type 0
> [    9.301385] sd 6:0:0:1: [sdc] Attached SCSI removable disk
> [    9.311385] sd 6:0:0:2: Attached scsi generic sg4 type 0
> [    9.312173] sd 6:0:0:2: [sdd] Attached SCSI removable disk
> [    9.994434] raid6: int64x1  gen()  2373 MB/s
> [   10.062439] raid6: int64x1  xor()  1780 MB/s
> [   10.130445] raid6: int64x2  gen()  2948 MB/s
> [   10.198437] raid6: int64x2  xor()  2336 MB/s
> [   10.266443] raid6: int64x4  gen()  3502 MB/s
> [   10.334431] raid6: int64x4  xor()  2538 MB/s
> [   10.402436] raid6: int64x8  gen()  4172 MB/s
> [   10.470439] raid6: int64x8  xor()  2596 MB/s
> [   10.538444] raid6: neonx1   gen()  2833 MB/s
> [   10.606426] raid6: neonx1   xor()  3892 MB/s
> [   10.674442] raid6: neonx2   gen()  4034 MB/s
> [   10.742434] raid6: neonx2   xor()  4232 MB/s
> [   10.810432] raid6: neonx4   gen()  4847 MB/s
> [   10.878430] raid6: neonx4   xor()  4538 MB/s
> [   10.946432] raid6: neonx8   gen()  5038 MB/s
> [   11.014433] raid6: neonx8   xor()  4434 MB/s
> [   11.017737] raid6: using algorithm neonx8 gen() 5038 MB/s
> [   11.023123] raid6: .... xor() 4434 MB/s, rmw enabled
> [   11.028070] raid6: using neon recovery algorithm
> [   11.033204] async_tx: api initialized (async)
> [   11.037353] xor: measuring software checksum speed
> [   11.078434]    8regs     : 10620.000 MB/sec
> [   11.118432]    8regs_prefetch: 10027.000 MB/sec
> [   11.158433]    32regs    : 14488.000 MB/sec
> [   11.198432]    32regs_prefetch: 13416.000 MB/sec
> [   11.202084] xor: using function: 32regs (14488.000 MB/sec)
> [   11.260065] Btrfs loaded, crc32c=crc32c-arm64-ce
> [   11.359632] random: crng init done
> [   11.662365] mlx5_core 0003:01:00.0 eth3: Link down
> [   11.667695] IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
> [   11.950708] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   12.050489] Atheros 8031 ethernet QCOM8070:00:04: attached PHY driver [Atheros 8031 ethernet] (mii_bus:phy_addr=QCOM8070:00:04, irq=POLL)
> [   12.061915] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
> [   12.338678] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   13.063496] qcom-emac QCOM8070:00 eth2: Link is Down
> [   14.367343] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> [   14.374111] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   16.134555] qcom-emac QCOM8070:00 eth2: Link is Up - 1Gbps/Full - flow control rx/tx
> [   16.141345] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> [   16.660152] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> [   16.847418] e1000e: eth0 NIC Link is Down
> [   17.023480] e1000e: eth1 NIC Link is Down
> [   17.427619] systemd[1]: systemd 229 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN)
> [   17.445036] systemd[1]: Detected architecture arm64.
> [   17.462635] systemd[1]: Set hostname to <ubuntu>.
> [   17.541621] systemd[1]: Listening on Journal Socket (/dev/log).
> [   17.558539] systemd[1]: Listening on Journal Socket.
> [   17.576784] systemd[1]: Created slice System Slice.
> [   17.590473] systemd[1]: Listening on udev Kernel Socket.
> [   17.606511] systemd[1]: Listening on LVM2 metadata daemon socket.
> [   17.622505] systemd[1]: Listening on fsck to fsckd communication Socket.
> [   17.642492] systemd[1]: Started Trigger resolvconf update for networkd DNS.
> [   17.760996] RPC: Registered named UNIX socket transport module.
> [   17.765964] RPC: Registered udp transport module.
> [   17.770643] RPC: Registered tcp transport module.
> [   17.774296] Loading iSCSI transport class v2.0-870.
> [   17.780190] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   17.793573] iscsi: registered transport (tcp)
> [   17.842957] iscsi: registered transport (iser)
> [   18.997903] systemd-journald[955]: Received request to flush runtime journal from PID 1
> [   19.203467] IPMI System Interface driver.
> [   19.203557] ipmi_si: probing via SPMI
> [   19.203646] ipmi_si: Unable to find any System Interface(s)
> [   19.398397] IPMI System Interface driver.
> [   19.398908] ipmi_si: probing via SPMI
> [   19.399685] ipmi_si: Unable to find any System Interface(s)
> [   19.784510] new mount options do not match the existing superblock, will be ignored
> [   19.907228] new mount options do not match the existing superblock, will be ignored
> [   22.534445] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   22.948007] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   23.369380] Ebtables v2.0 registered
> [   24.380409] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
> [   24.458521] virbr0: port 1(virbr0-nic) entered blocking state
> [   24.458524] virbr0: port 1(virbr0-nic) entered disabled state
> [   24.458600] device virbr0-nic entered promiscuous mode
> [   27.940673] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
> [   30.344989] virbr0: port 1(virbr0-nic) entered blocking state
> [   30.344993] virbr0: port 1(virbr0-nic) entered listening state
> [   31.841560] virbr0: port 1(virbr0-nic) entered disabled state

> root@ubuntu:/home/ubuntu# cat /proc/iomem
> 00200000-0021ffff : reserved
> 00820000-0307ffff : System RAM
> 03080000-0308ffff : reserved
> 03090000-031fffff : System RAM
> 03200000-033fffff : reserved
> 03410000-04c0ffff : System RAM
> 04c10000-04c2ffff : reserved
> 04c30000-04c3dfff : System RAM
> 04c3e000-04c41fff : reserved
> 04c42000-04c4cfff : System RAM
> 04c4d000-07c61fff : reserved
> 07c62000-07d6ffff : System RAM
> 07d70000-07eeffff : reserved
> 07ef0000-07f0ffff : System RAM
> 07f10000-07faffff : reserved
> 07fb0000-08310fff : System RAM
> 08311000-08316fff : reserved
> 08317000-083c0fff : System RAM
> 083c1000-083c6fff : reserved
> 083c7000-083effff : System RAM
> 083f0000-085dffff : reserved
> 085e0000-085e0fff : System RAM
> 085e1000-085e3fff : reserved
> 085e4000-085fffff : System RAM
> 08600000-0860ffff : reserved
> 08610000-0863ffff : System RAM
> 08640000-087affff : reserved
> 087b0000-08940fff : System RAM
> 08941000-08943fff : reserved
> 08944000-0896ffff : System RAM
> 08970000-08a0ffff : reserved
> 08a10000-08a7ffff : System RAM
> 08a80000-08bbffff : reserved
> 08bc0000-08bdffff : System RAM
> 08be0000-08f02fff : reserved
> 08f03000-0deeffff : System RAM
> 0def0000-0df1ffff : reserved
> 0df20000-0fffffff : System RAM
> 10800000-17feffff : System RAM
>   10a80000-118fffff : Kernel code
>   11e30000-120b9fff : Kernel data
> 1c000000-1c00ffff : reserved
> 1c010000-1c7fffff : System RAM
> 1c800000-1c800fff : QCOM8110:00
>   1c800000-1c800fff : QCOM8110:00
> 1c810000-7efbffff : System RAM
> 7efc0000-7efdffff : reserved
> 7efe0000-7efeffff : System RAM
> 7eff0000-7effffff : reserved
> 7f000000-7fffffff : System RAM
> 80000000-bfffffff : reserved
> c0000000-17ffffffff : System RAM
> ff02010000-ff0296ffff : QCOM8002:00
>   ff02010000-ff0296ffff : QCOM8002:00
> ff02e10000-ff02e10fff : QCOM80B0:00
> ff11490000-ff11490fff : QCOM80C1:01
> ff114c0000-ff114c0fff : QCOM80C1:01
> ff114d0000-ff114d0fff : QCOM80C1:01
> ff114e0000-ff114e0fff : QCOM80C1:01
> ff11510000-ff11510fff : QCOM80C1:00
> ff11540000-ff11540fff : QCOM80C1:00
> ff11550000-ff11550fff : QCOM80C1:00
> ff11560000-ff11560fff : QCOM80C1:00
> ff11590000-ff11590fff : QCOM80C1:05
> ff115c0000-ff115c0fff : QCOM80C1:05
> ff115d0000-ff115d0fff : QCOM80C1:05
> ff115e0000-ff115e0fff : QCOM80C1:05
> ff13a10000-ff13a10fff : QCOM80C1:02
> ff13a40000-ff13a40fff : QCOM80C1:02
> ff13a50000-ff13a50fff : QCOM80C1:02
> ff13a60000-ff13a60fff : QCOM80C1:02
> ff13a90000-ff13a90fff : QCOM80C1:03
> ff13ac0000-ff13ac0fff : QCOM80C1:03
> ff13ad0000-ff13ad0fff : QCOM80C1:03
> ff13ae0000-ff13ae0fff : QCOM80C1:03
> ff13b10000-ff13b10fff : QCOM80C1:04
> ff13b40000-ff13b40fff : QCOM80C1:04
> ff13b50000-ff13b50fff : QCOM80C1:04
> ff13b60000-ff13b60fff : QCOM80C1:04
> ff18d00000-ff18d00fff : QCOM8070:00
> ff18d10000-ff18d10fff : QCOM8070:00
>   ff18d10000-ff18d103ff : QCOM8071:00
>   ff18d10400-ff18d10fff : QCOM8071:00
> ff61000000-ff6100ffff : QCOM8070:00
>   ff61000000-ff6100ffff : QCOM8070:00
> ff61016000-ff61016fff : QCOM8070:00
>   ff61016000-ff61016fff : QCOM8070:00
> ff6101c000-ff6101ffff : QCOM8070:00
> ff61400000-ff6145ffff : QCOM80A2:00
> ff78750000-ff78750fff : QCOM8010:01
>   ff78750000-ff78750fff : QCOM8010:01
> ff78b30000-ff78b30fff : QCOM8010:00
>   ff78b30000-ff78b30fff : QCOM8010:00
> ff78ed1000-ff78ed11ff : ARMH0011:01
>   ff78ed1000-ff78ed11ff : ARMH0011:01
> ff79524900-ff79524aff : QCOM8051:00
>   ff79524900-ff79524aff : QCOM8051:00
> ff79800000-ff7980ccff : QCOM8041:00
>   ff79800000-ff7980ccff : QCOM8041:00
> ff79a00000-ff79a0ccff : QCOM8041:01
>   ff79a00000-ff79a0ccff : QCOM8041:01
> ff79c00000-ff79c0ccff : QCOM8041:02
>   ff79c00000-ff79c0ccff : QCOM8041:02
> ff79e00000-ff79e0ccff : QCOM8041:03
>   ff79e00000-ff79e0ccff : QCOM8041:03
> ff7a900000-ff7a95ffff : QCOM80A2:0c
> ff7ea00000-ff7ea00fff : sbsa-gwdt.0
> ff7ea10000-ff7ea10fff : sbsa-gwdt.0
> ff80030000-ff8003ffff : QCOM80D0:00
> ff80130000-ff8013ffff : QCOM80D0:01
> ff80230000-ff8023ffff : QCOM80D0:02
> ff80330000-ff8033ffff : QCOM80D0:03
> ff80430000-ff8043ffff : QCOM80D0:04
> ff80530000-ff8053ffff : QCOM80D0:0b
> ff80590000-ff8059ffff : QCOM8101:00
> ff805a8000-ff805a8fff : QCOM8081:00
>   ff805a8000-ff805a8fff : QCOM8081:00
> ff805b0000-ff805bffff : QCOM8101:00
> ff80630000-ff8063ffff : QCOM80D0:0c
> ff80690000-ff8069ffff : QCOM8101:01
> ff806a8000-ff806a8fff : QCOM8081:01
>   ff806a8000-ff806a8fff : QCOM8081:01
> ff806b0000-ff806bffff : QCOM8101:01
> ff80730000-ff8073ffff : QCOM80D0:0d
> ff80790000-ff8079ffff : QCOM8101:02
> ff807a8000-ff807a8fff : QCOM8081:02
>   ff807a8000-ff807a8fff : QCOM8081:02
> ff807b0000-ff807bffff : QCOM8101:02
> ff80830000-ff8083ffff : QCOM80D0:0e
> ff80890000-ff8089ffff : QCOM8101:03
> ff808a8000-ff808a8fff : QCOM8081:03
>   ff808a8000-ff808a8fff : QCOM8081:03
> ff808b0000-ff808bffff : QCOM8101:03
> ff80930000-ff8093ffff : QCOM80D0:0f
> ff80990000-ff8099ffff : QCOM8101:04
> ff809a8000-ff809a8fff : QCOM8081:04
>   ff809a8000-ff809a8fff : QCOM8081:04
> ff809b0000-ff809bffff : QCOM8101:04
> ff80a30000-ff80a3ffff : QCOM80D0:10
> ff80a90000-ff80a9ffff : QCOM8101:05
> ff80aa8000-ff80aa8fff : QCOM8081:05
>   ff80aa8000-ff80aa8fff : QCOM8081:05
> ff80ab0000-ff80abffff : QCOM8101:05
> ff80b30000-ff80b3ffff : QCOM80D0:11
> ff80b90000-ff80b9ffff : QCOM8101:06
> ff80ba8000-ff80ba8fff : QCOM8081:06
>   ff80ba8000-ff80ba8fff : QCOM8081:06
> ff80bb0000-ff80bbffff : QCOM8101:06
> ff80c30000-ff80c3ffff : QCOM80D0:12
> ff80c90000-ff80c9ffff : QCOM8101:07
> ff80ca8000-ff80ca8fff : QCOM8081:07
>   ff80ca8000-ff80ca8fff : QCOM8081:07
> ff80cb0000-ff80cbffff : QCOM8101:07
> ff80d30000-ff80d3ffff : QCOM80D0:13
> ff80d90000-ff80d9ffff : QCOM8101:08
> ff80da8000-ff80da8fff : QCOM8081:08
>   ff80da8000-ff80da8fff : QCOM8081:08
> ff80db0000-ff80dbffff : QCOM8101:08
> ff80e30000-ff80e3ffff : QCOM80D0:14
> ff80e90000-ff80e9ffff : QCOM8101:09
> ff80ea8000-ff80ea8fff : QCOM8081:09
>   ff80ea8000-ff80ea8fff : QCOM8081:09
> ff80eb0000-ff80ebffff : QCOM8101:09
> ff80f30000-ff80f3ffff : QCOM80D0:15
> ff80f90000-ff80f9ffff : QCOM8101:0a
> ff80fa8000-ff80fa8fff : QCOM8081:0a
>   ff80fa8000-ff80fa8fff : QCOM8081:0a
> ff80fb0000-ff80fbffff : QCOM8101:0a
> ff81030000-ff8103ffff : QCOM80D0:16
> ff81090000-ff8109ffff : QCOM8101:0b
> ff810a8000-ff810a8fff : QCOM8081:0b
>   ff810a8000-ff810a8fff : QCOM8081:0b
> ff810b0000-ff810bffff : QCOM8101:0b
> ff81130000-ff8113ffff : QCOM80D0:05
> ff81230000-ff8123ffff : QCOM80D0:06
> ff81330000-ff8133ffff : QCOM80D0:07
> ff81430000-ff8143ffff : QCOM80D0:08
> ff81530000-ff8153ffff : QCOM80D0:09
> ff81630000-ff8163ffff : QCOM80D0:0a
> ff81730000-ff8173ffff : QCOM80D0:17
> ff81830000-ff8183ffff : QCOM80D0:18
> ff81930000-ff8193ffff : QCOM80D0:19
> ff81a30000-ff81a3ffff : QCOM80D0:1a
> ff81b30000-ff81b3ffff : QCOM80D0:1b
> ff81c30000-ff81c3ffff : QCOM80D0:1c
> ff88000000-ff880001ff : QCOM8090:00
>   ff88000000-ff880001ff : QCOM8090:00
> ff88800000-ff8885ffff : QCOM80A2:0d
> ff89000000-ff890001ff : QCOM8090:01
>   ff89000000-ff890001ff : QCOM8090:01
> ff89800000-ff8985ffff : QCOM80A2:0e
> ff8a000000-ff8a0001ff : QCOM8090:02
>   ff8a000000-ff8a0001ff : QCOM8090:02
> ff8a800000-ff8a85ffff : QCOM80A2:0f
> ff8b000000-ff8b0001ff : QCOM8090:03
>   ff8b000000-ff8b0001ff : QCOM8090:03
> ff8b800000-ff8b85ffff : QCOM80A2:10
> ff8c000000-ff8c0001ff : QCOM8090:04
>   ff8c000000-ff8c0001ff : QCOM8090:04
> ff8c800000-ff8c85ffff : QCOM80A2:11
> ff8d000000-ff8d0001ff : QCOM8090:05
>   ff8d000000-ff8d0001ff : QCOM8090:05
> ff8d800000-ff8d85ffff : QCOM80A2:12
> ff8e000000-ff8e0001ff : QCOM8090:06
>   ff8e000000-ff8e0001ff : QCOM8090:06
> ff8e800000-ff8e85ffff : QCOM80A2:13
> ff8f000000-ff8f0001ff : QCOM8090:07
>   ff8f000000-ff8f0001ff : QCOM8090:07
> ff8f800000-ff8f85ffff : QCOM80A2:14
> ff98000000-ff980013ff : QCOM8060:00
>   ff98000000-ff980013ff : QCOM8060:00
> ff98010000-ff98010fff : QCOM8062:00
>   ff98010000-ff98010fff : QCOM8060:00
>     ff98010000-ff98010fff : QCOM8062:00
> ff98020000-ff98020fff : QCOM8062:01
>   ff98020000-ff98020fff : QCOM8060:00
>     ff98020000-ff98020fff : QCOM8062:01
> ff98030000-ff98030fff : QCOM8062:02
>   ff98030000-ff98030fff : QCOM8060:00
>     ff98030000-ff98030fff : QCOM8062:02
> ff98040000-ff98040fff : QCOM8062:03
>   ff98040000-ff98040fff : QCOM8060:00
>     ff98040000-ff98040fff : QCOM8062:03
> ff98050000-ff98050fff : QCOM8062:04
>   ff98050000-ff98050fff : QCOM8060:00
>     ff98050000-ff98050fff : QCOM8062:04
> ff98060000-ff98060fff : QCOM8062:05
>   ff98060000-ff98060fff : QCOM8060:00
>     ff98060000-ff98060fff : QCOM8062:05
> ff98070000-ff98070fff : QCOM8062:00
>   ff98070000-ff98070fff : QCOM8062:00
> ff98080000-ff98080fff : QCOM8062:01
>   ff98080000-ff98080fff : QCOM8062:01
> ff98090000-ff98090fff : QCOM8062:02
>   ff98090000-ff98090fff : QCOM8062:02
> ff980a0000-ff980a0fff : QCOM8062:03
>   ff980a0000-ff980a0fff : QCOM8062:03
> ff980b0000-ff980b0fff : QCOM8062:04
>   ff980b0000-ff980b0fff : QCOM8062:04
> ff980c0000-ff980c0fff : QCOM8062:05
>   ff980c0000-ff980c0fff : QCOM8062:05
> ff99000000-ff9905ffff : QCOM80A2:02
> ff9a000000-ff9a0013ff : QCOM8060:01
>   ff9a000000-ff9a0013ff : QCOM8060:01
> ff9a010000-ff9a010fff : QCOM8062:06
>   ff9a010000-ff9a010fff : QCOM8060:01
>     ff9a010000-ff9a010fff : QCOM8062:06
> ff9a020000-ff9a020fff : QCOM8062:07
>   ff9a020000-ff9a020fff : QCOM8060:01
>     ff9a020000-ff9a020fff : QCOM8062:07
> ff9a030000-ff9a030fff : QCOM8062:08
>   ff9a030000-ff9a030fff : QCOM8060:01
>     ff9a030000-ff9a030fff : QCOM8062:08
> ff9a040000-ff9a040fff : QCOM8062:09
>   ff9a040000-ff9a040fff : QCOM8060:01
>     ff9a040000-ff9a040fff : QCOM8062:09
> ff9a050000-ff9a050fff : QCOM8062:0a
>   ff9a050000-ff9a050fff : QCOM8060:01
>     ff9a050000-ff9a050fff : QCOM8062:0a
> ff9a060000-ff9a060fff : QCOM8062:0b
>   ff9a060000-ff9a060fff : QCOM8060:01
>     ff9a060000-ff9a060fff : QCOM8062:0b
> ff9a070000-ff9a070fff : QCOM8062:06
>   ff9a070000-ff9a070fff : QCOM8062:06
> ff9a080000-ff9a080fff : QCOM8062:07
>   ff9a080000-ff9a080fff : QCOM8062:07
> ff9a090000-ff9a090fff : QCOM8062:08
>   ff9a090000-ff9a090fff : QCOM8062:08
> ff9a0a0000-ff9a0a0fff : QCOM8062:09
>   ff9a0a0000-ff9a0a0fff : QCOM8062:09
> ff9a0b0000-ff9a0b0fff : QCOM8062:0a
>   ff9a0b0000-ff9a0b0fff : QCOM8062:0a
> ff9a0c0000-ff9a0c0fff : QCOM8062:0b
>   ff9a0c0000-ff9a0c0fff : QCOM8062:0b
> ff9b000000-ff9b05ffff : QCOM80A2:03
> ff9c000000-ff9c0013ff : QCOM8060:02
>   ff9c000000-ff9c0013ff : QCOM8060:02
> ff9c010000-ff9c010fff : QCOM8062:0c
>   ff9c010000-ff9c010fff : QCOM8060:02
>     ff9c010000-ff9c010fff : QCOM8062:0c
> ff9c020000-ff9c020fff : QCOM8062:0d
>   ff9c020000-ff9c020fff : QCOM8060:02
>     ff9c020000-ff9c020fff : QCOM8062:0d
> ff9c030000-ff9c030fff : QCOM8062:0e
>   ff9c030000-ff9c030fff : QCOM8060:02
>     ff9c030000-ff9c030fff : QCOM8062:0e
> ff9c040000-ff9c040fff : QCOM8062:0f
>   ff9c040000-ff9c040fff : QCOM8060:02
>     ff9c040000-ff9c040fff : QCOM8062:0f
> ff9c050000-ff9c050fff : QCOM8062:10
>   ff9c050000-ff9c050fff : QCOM8060:02
>     ff9c050000-ff9c050fff : QCOM8062:10
> ff9c060000-ff9c060fff : QCOM8062:11
>   ff9c060000-ff9c060fff : QCOM8060:02
>     ff9c060000-ff9c060fff : QCOM8062:11
> ff9c070000-ff9c070fff : QCOM8062:0c
>   ff9c070000-ff9c070fff : QCOM8062:0c
> ff9c080000-ff9c080fff : QCOM8062:0d
>   ff9c080000-ff9c080fff : QCOM8062:0d
> ff9c090000-ff9c090fff : QCOM8062:0e
>   ff9c090000-ff9c090fff : QCOM8062:0e
> ff9c0a0000-ff9c0a0fff : QCOM8062:0f
>   ff9c0a0000-ff9c0a0fff : QCOM8062:0f
> ff9c0b0000-ff9c0b0fff : QCOM8062:10
>   ff9c0b0000-ff9c0b0fff : QCOM8062:10
> ff9c0c0000-ff9c0c0fff : QCOM8062:11
>   ff9c0c0000-ff9c0c0fff : QCOM8062:11
> ff9d000000-ff9d05ffff : QCOM80A2:04
> ff9e000000-ff9e0013ff : QCOM8060:03
>   ff9e000000-ff9e0013ff : QCOM8060:03
> ff9e010000-ff9e010fff : QCOM8062:12
>   ff9e010000-ff9e010fff : QCOM8060:03
>     ff9e010000-ff9e010fff : QCOM8062:12
> ff9e020000-ff9e020fff : QCOM8062:13
>   ff9e020000-ff9e020fff : QCOM8060:03
>     ff9e020000-ff9e020fff : QCOM8062:13
> ff9e030000-ff9e030fff : QCOM8062:14
>   ff9e030000-ff9e030fff : QCOM8060:03
>     ff9e030000-ff9e030fff : QCOM8062:14
> ff9e040000-ff9e040fff : QCOM8062:15
>   ff9e040000-ff9e040fff : QCOM8060:03
>     ff9e040000-ff9e040fff : QCOM8062:15
> ff9e050000-ff9e050fff : QCOM8062:16
>   ff9e050000-ff9e050fff : QCOM8060:03
>     ff9e050000-ff9e050fff : QCOM8062:16
> ff9e060000-ff9e060fff : QCOM8062:17
>   ff9e060000-ff9e060fff : QCOM8060:03
>     ff9e060000-ff9e060fff : QCOM8062:17
> ff9e070000-ff9e070fff : QCOM8062:12
>   ff9e070000-ff9e070fff : QCOM8062:12
> ff9e080000-ff9e080fff : QCOM8062:13
>   ff9e080000-ff9e080fff : QCOM8062:13
> ff9e090000-ff9e090fff : QCOM8062:14
>   ff9e090000-ff9e090fff : QCOM8062:14
> ff9e0a0000-ff9e0a0fff : QCOM8062:15
>   ff9e0a0000-ff9e0a0fff : QCOM8062:15
> ff9e0b0000-ff9e0b0fff : QCOM8062:16
>   ff9e0b0000-ff9e0b0fff : QCOM8062:16
> ff9e0c0000-ff9e0c0fff : QCOM8062:17
>   ff9e0c0000-ff9e0c0fff : QCOM8062:17
> ff9f000000-ff9f05ffff : QCOM80A2:05
> 80000000000-8000fffffff : pnp 00:00
> 90000000000-9000fffffff : PCI ECAM
> 90100100000-9011fffffff : PCI Bus 0001:00
>   90100100000-901002fffff : PCI Bus 0001:01
> 90200000000-9021fffffff : PCI Bus 0001:00
> 90300000000-9033fffffff : PCI Bus 0001:00
> 90400000000-9fffffeffff : PCI Bus 0001:00
>   90400000000-904001fffff : PCI Bus 0001:01
> a0000000000-a000fffffff : PCI ECAM
> a0100100000-a011fffffff : PCI Bus 0002:00
>   a0100100000-a01002fffff : PCI Bus 0002:01
>     a0100100000-a010011ffff : 0002:01:00.0
>       a0100100000-a010011ffff : e1000e
>     a0100120000-a010013ffff : 0002:01:00.0
>       a0100120000-a010013ffff : e1000e
>     a0100140000-a010015ffff : 0002:01:00.0
>     a0100160000-a010017ffff : 0002:01:00.1
>       a0100160000-a010017ffff : e1000e
>     a0100180000-a010019ffff : 0002:01:00.1
>       a0100180000-a010019ffff : e1000e
>     a01001a0000-a01001bffff : 0002:01:00.1
> a0200000000-a021fffffff : PCI Bus 0002:00
> a0300000000-a033fffffff : PCI Bus 0002:00
> a0400000000-afffffeffff : PCI Bus 0002:00
>   a0400000000-a04001fffff : PCI Bus 0002:01
> bffffd00000-bffffd5ffff : QCOM80A2:06
>   bffffd00000-bffffd1ffff : arm-smmu-v3.0.auto
>     bffffd00000-bffffd1ffff : arm-smmu-v3.0.auto
> bffffe00000-bffffe5ffff : QCOM80A2:07
>   bffffe00000-bffffe1ffff : arm-smmu-v3.1.auto
>     bffffe00000-bffffe1ffff : arm-smmu-v3.1.auto
> bfffff00000-bfffff5ffff : QCOM80A2:08
>   bfffff00000-bfffff1ffff : arm-smmu-v3.2.auto
>     bfffff00000-bfffff1ffff : arm-smmu-v3.2.auto
> c0000000000-c000fffffff : PCI ECAM
> c0100100000-c011fffffff : PCI Bus 0003:00
>   c0100100000-c01002fffff : PCI Bus 0003:01
>     c0100100000-c01001fffff : 0003:01:00.0
> c0200000000-c021fffffff : PCI Bus 0003:00
> c0300000000-c033fffffff : PCI Bus 0003:00
> c0400000000-cfffffeffff : PCI Bus 0003:00
>   c0400000000-c0403ffffff : PCI Bus 0003:01
>     c0400000000-c0401ffffff : 0003:01:00.0
>       c0400000000-c0401ffffff : mlx5_core
>     c0402000000-c04027fffff : 0003:01:00.0
> d0000000000-d000fffffff : pnp 00:04
> e0000000000-e000fffffff : pnp 00:05
> fffffd00000-fffffd5ffff : QCOM80A2:09
>   fffffd00000-fffffd1ffff : arm-smmu-v3.3.auto
>     fffffd00000-fffffd1ffff : arm-smmu-v3.3.auto
> fffffe00000-fffffe5ffff : QCOM80A2:0a
>   fffffe00000-fffffe1ffff : arm-smmu-v3.4.auto
>     fffffe00000-fffffe1ffff : arm-smmu-v3.4.auto
> ffffff00000-ffffff5ffff : QCOM80A2:0b
>   ffffff00000-ffffff1ffff : arm-smmu-v3.5.auto
>     ffffff00000-ffffff1ffff : arm-smmu-v3.5.auto

> ubuntu@ubuntu:~$ dmesg
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 4.14.14 (lnxbuild@bait-qsvbuild-13-bldr-lnx) (gcc version 6.3.1 20170109 (Linaro GCC 6.3-2017.02)) #1 SMP Thu Feb 15 19:52:35 MST 2018
> [    0.000000] Boot CPU: AArch64 Processor [510f8000]
> [    0.000000] earlycon: pl11 at MMIO32 0x000000ff78ed1000 (options '')
> [    0.000000] bootconsole [pl11] enabled
> [    0.000000] efi: Getting EFI parameters from FDT:
> [    0.000000] efi: EFI v2.60 by Qualcomm
> [    0.000000] efi:  ACPI 2.0=0x8bd0000  PROP=0xdf695c8  SMBIOS 3.0=0x4c20000  ESRT=0xa4c1c18  MEMATTR=0xa401018  RNG=0xdf16a98
> [    0.000000] random: fast init done
> [    0.000000] efi: seeding entropy pool
> [    0.000000] efi: memattr: Unexpected EFI Memory Attributes table version -520764131
> [    0.000000] esrt: Unsupported ESRT version 4637552977029017975.
> [    0.000000] ITS: reserved prop table memory [0x0000179a960000-0x0000179a96ffff]
> [    0.000000] ITS: reserved pend table memory [0x0000179aa00000-0x0000179aa0ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793fa0000-0x00001793faffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793ff0000-0x00001793ffffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793840000-0x0000179384ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793890000-0x0000179389ffff]
> [    0.000000] ITS: reserved pend table memory [0x000017938d0000-0x000017938dffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793930000-0x0000179393ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793980000-0x0000179398ffff]
> [    0.000000] ITS: reserved pend table memory [0x000017939c0000-0x000017939cffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793a30000-0x00001793a3ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793a70000-0x00001793a7ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793ab0000-0x00001793abffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793b20000-0x00001793b2ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793b60000-0x00001793b6ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793ba0000-0x00001793baffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793400000-0x0000179340ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793450000-0x0000179345ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793490000-0x0000179349ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793500000-0x0000179350ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793540000-0x0000179354ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793580000-0x0000179358ffff]
> [    0.000000] ITS: reserved pend table memory [0x000017935f0000-0x000017935fffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793630000-0x0000179363ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793670000-0x0000179367ffff]
> [    0.000000] ITS: reserved pend table memory [0x000017936c0000-0x000017936cffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793720000-0x0000179372ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793760000-0x0000179376ffff]
> [    0.000000] ITS: reserved pend table memory [0x000017937a0000-0x000017937affff]
> [    0.000000] ITS: reserved pend table memory [0x00001793010000-0x0000179301ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793060000-0x0000179306ffff]
> [    0.000000] ITS: reserved pend table memory [0x000017930a0000-0x000017930affff]
> [    0.000000] ITS: reserved pend table memory [0x00001793100000-0x0000179310ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793140000-0x0000179314ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793180000-0x0000179318ffff]
> [    0.000000] ITS: reserved pend table memory [0x000017931f0000-0x000017931fffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793230000-0x0000179323ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793280000-0x0000179328ffff]
> [    0.000000] ITS: reserved pend table memory [0x000017932e0000-0x000017932effff]
> [    0.000000] ITS: reserved pend table memory [0x00001793320000-0x0000179332ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001793370000-0x0000179337ffff]
> [    0.000000] ITS: reserved pend table memory [0x000017933d0000-0x000017933dffff]
> [    0.000000] ITS: reserved pend table memory [0x00001792c10000-0x00001792c1ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001792c50000-0x00001792c5ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001792cb0000-0x00001792cbffff]
> [    0.000000] ITS: reserved pend table memory [0x00001792d10000-0x00001792d1ffff]
> [    0.000000] ITS: reserved pend table memory [0x00001792d50000-0x00001792d5ffff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x0000000008BD0000 000024 (v02 QCOM  )
> [    0.000000] ACPI: XSDT 0x0000000008BC0000 000094 (v01 QCOM   QDF2400  00000000 QCOM 00000001)
> [    0.000000] ACPI: FACP 0x0000000008880000 000114 (v06 QCOM   QDF2400  00000000 INTL 20150515)
> [    0.000000] ACPI: DSDT 0x00000000088A0000 0332B6 (v02 QCOM   QDF2400  00000004 INTL 20150515)
> [    0.000000] ACPI: DBG2 0x0000000008930000 000072 (v00 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: IORT 0x0000000008910000 000D40 (v00 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: TPM2 0x0000000008900000 000040 (v04 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: BERT 0x00000000088E0000 000030 (v01 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: EINJ 0x0000000008890000 000150 (v01 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: GTDT 0x0000000008870000 00007C (v02 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: PCCT 0x0000000008850000 0000AC (v01 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: SPMI 0x0000000008840000 000041 (v04 QCOM   QDF2400  00000000 INTL 20150515)
> [    0.000000] ACPI: PPTT 0x00000000083B0000 000736 (v01 QCOM   QDF2400  00000002 INTL 20150515)
> [    0.000000] ACPI: APIC 0x00000000088F0000 000ED0 (v04 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: HEST 0x0000000008920000 000288 (v01 QCOM   QDF2400  00000001 INTL 20150515)
> [    0.000000] ACPI: MCFG 0x0000000008860000 00005C (v01 QCOM   QDF2400  00000001 QCOM 00000001)
> [    0.000000] ACPI: SPCR 0x0000000004C00000 000050 (v04 QCOM   QDF2400  00000001 QCOM 00000001)
> [    0.000000] ACPI: SPCR: console: pl011,mmio32,0xff78ed1000,115200
> [    0.000000] ACPI: NUMA: Failed to initialise from firmware
> [    0.000000] NUMA: Faking a node at [mem 0x0000000000000000-0x00000017ffffffff]
> [    0.000000] NUMA: NODE_DATA [mem 0x17fffdee80-0x17fffe1fff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x0000000000200000-0x00000000ffffffff]
> [    0.000000]   Normal   [mem 0x0000000100000000-0x00000017ffffffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x0000000000200000-0x000000000021ffff]
> [    0.000000]   node   0: [mem 0x0000000000820000-0x000000000307ffff]
> [    0.000000]   node   0: [mem 0x0000000003080000-0x000000000308ffff]
> [    0.000000]   node   0: [mem 0x0000000003090000-0x00000000031fffff]
> [    0.000000]   node   0: [mem 0x0000000003200000-0x00000000033fffff]
> [    0.000000]   node   0: [mem 0x0000000003410000-0x0000000004c0ffff]
> [    0.000000]   node   0: [mem 0x0000000004c10000-0x0000000004c2ffff]
> [    0.000000]   node   0: [mem 0x0000000004c30000-0x0000000004c3dfff]
> [    0.000000]   node   0: [mem 0x0000000004c3e000-0x0000000004c41fff]
> [    0.000000]   node   0: [mem 0x0000000004c42000-0x0000000004c4cfff]
> [    0.000000]   node   0: [mem 0x0000000004c4d000-0x0000000007c61fff]
> [    0.000000]   node   0: [mem 0x0000000007c62000-0x0000000007d6ffff]
> [    0.000000]   node   0: [mem 0x0000000007d70000-0x0000000007eeffff]
> [    0.000000]   node   0: [mem 0x0000000007ef0000-0x0000000007f0ffff]
> [    0.000000]   node   0: [mem 0x0000000007f10000-0x0000000007faffff]
> [    0.000000]   node   0: [mem 0x0000000007fb0000-0x0000000008310fff]
> [    0.000000]   node   0: [mem 0x0000000008311000-0x0000000008316fff]
> [    0.000000]   node   0: [mem 0x0000000008317000-0x00000000083c0fff]
> [    0.000000]   node   0: [mem 0x00000000083c1000-0x00000000083c6fff]
> [    0.000000]   node   0: [mem 0x00000000083c7000-0x00000000083effff]
> [    0.000000]   node   0: [mem 0x00000000083f0000-0x00000000085dffff]
> [    0.000000]   node   0: [mem 0x00000000085e0000-0x00000000085e0fff]
> [    0.000000]   node   0: [mem 0x00000000085e1000-0x00000000085e3fff]
> [    0.000000]   node   0: [mem 0x00000000085e4000-0x00000000085fffff]
> [    0.000000]   node   0: [mem 0x0000000008600000-0x000000000860ffff]
> [    0.000000]   node   0: [mem 0x0000000008610000-0x000000000863ffff]
> [    0.000000]   node   0: [mem 0x0000000008640000-0x00000000087affff]
> [    0.000000]   node   0: [mem 0x00000000087b0000-0x0000000008940fff]
> [    0.000000]   node   0: [mem 0x0000000008941000-0x0000000008943fff]
> [    0.000000]   node   0: [mem 0x0000000008944000-0x000000000896ffff]
> [    0.000000]   node   0: [mem 0x0000000008970000-0x0000000008a0ffff]
> [    0.000000]   node   0: [mem 0x0000000008a10000-0x0000000008a7ffff]
> [    0.000000]   node   0: [mem 0x0000000008a80000-0x0000000008bbffff]
> [    0.000000]   node   0: [mem 0x0000000008bc0000-0x0000000008bdffff]
> [    0.000000]   node   0: [mem 0x0000000008be0000-0x0000000008f02fff]
> [    0.000000]   node   0: [mem 0x0000000008f03000-0x000000000deeffff]
> [    0.000000]   node   0: [mem 0x000000000def0000-0x000000000df1ffff]
> [    0.000000]   node   0: [mem 0x000000000df20000-0x000000000fffffff]
> [    0.000000]   node   0: [mem 0x0000000010800000-0x0000000017feffff]
> [    0.000000]   node   0: [mem 0x000000001c000000-0x000000001c00ffff]
> [    0.000000]   node   0: [mem 0x000000001c010000-0x000000001c7fffff]
> [    0.000000]   node   0: [mem 0x000000001c810000-0x000000007efbffff]
> [    0.000000]   node   0: [mem 0x000000007efc0000-0x000000007efdffff]
> [    0.000000]   node   0: [mem 0x000000007efe0000-0x000000007efeffff]
> [    0.000000]   node   0: [mem 0x000000007eff0000-0x000000007effffff]
> [    0.000000]   node   0: [mem 0x000000007f000000-0x000000007fffffff]
> [    0.000000]   node   0: [mem 0x0000000080000000-0x00000000bfffffff]
> [    0.000000]   node   0: [mem 0x00000000c0000000-0x00000017ffffffff]
> [    0.000000] Initmem setup node 0 [mem 0x0000000000200000-0x00000017ffffffff]
> [    0.000000] On node 0 totalpages: 25145296
> [    0.000000]   DMA zone: 16376 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 1028048 pages, LIFO batch:31
> [    0.000000]   Normal zone: 376832 pages used for memmap
> [    0.000000]   Normal zone: 24117248 pages, LIFO batch:31
> [    0.000000] psci: probing for conduit method from ACPI.
> [    0.000000] psci: PSCIv1.0 detected in firmware.
> [    0.000000] psci: Using standard PSCI v0.2 function IDs
> [    0.000000] psci: MIGRATE_INFO_TYPE not supported.
> [    0.000000] percpu: Embedded 28 pages/cpu @ffff80179f6f8000 s77592 r8192 d28904 u114688
> [    0.000000] pcpu-alloc: s77592 r8192 d28904 u114688 alloc=28*4096
> [    0.000000] pcpu-alloc: [0] 00 [0] 01 [0] 02 [0] 03 [0] 04 [0] 05 [0] 06 [0] 07
> [    0.000000] pcpu-alloc: [0] 08 [0] 09 [0] 10 [0] 11 [0] 12 [0] 13 [0] 14 [0] 15
> [    0.000000] pcpu-alloc: [0] 16 [0] 17 [0] 18 [0] 19 [0] 20 [0] 21 [0] 22 [0] 23
> [    0.000000] pcpu-alloc: [0] 24 [0] 25 [0] 26 [0] 27 [0] 28 [0] 29 [0] 30 [0] 31
> [    0.000000] pcpu-alloc: [0] 32 [0] 33 [0] 34 [0] 35 [0] 36 [0] 37 [0] 38 [0] 39
> [    0.000000] pcpu-alloc: [0] 40 [0] 41 [0] 42 [0] 43 [0] 44 [0] 45
> [    0.000000] Detected PIPT I-cache on CPU0
> [    0.000000] CPU features: enabling workaround for Qualcomm Technologies Falkor erratum 1003
> [    0.000000] CPU features: enabling workaround for Qualcomm Technologies Falkor erratum 1009
> [    0.000000] CPU features: enabling workaround for Qualcomm Technologies Falkor erratum 1029
> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 24752088
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: \EFI\BOOT\Image user_debug=31 loglevel=9 uefi_debug e1000e.IntMode=1 pci=pcie_bus_safe pcie_aspm.policy=default cpuidle.off=0 rootwait rw root=PARTUUID=76ec3f97-3414-4896-a317-340ffa63adc6 rootfstype=ext4 initrd=initramfs.img earlycon=pl011,mmio32,0xff78ed1000 "" "" "" "" "" "" "" ""
> [    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
> [    0.000000] log_buf_len total cpu_extra contributions: 184320 bytes
> [    0.000000] log_buf_len min size: 16384 bytes
> [    0.000000] log_buf_len: 262144 bytes
> [    0.000000] early log buf free: 3584(21%)
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] software IO TLB [mem 0xfbffe000-0xffffe000] (64MB) mapped at [ffff8000fbffe000-ffff8000ffffdfff]
> [    0.000000] Memory: 97722852K/100581184K available (10556K kernel code, 1596K rwdata, 4236K rodata, 5312K init, 970K bss, 2858332K reserved, 0K cma-reserved)
> [    0.000000] Virtual kernel memory layout:
> [    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000   (   128 MB)
> [    0.000000]     vmalloc : 0xffff000008000000 - 0xffff7dffbfff0000   (129022 GB)
> [    0.000000]       .text : 0xffff000008080000 - 0xffff000008ad0000   ( 10560 KB)
> [    0.000000]     .rodata : 0xffff000008ad0000 - 0xffff000008f00000   (  4288 KB)
> [    0.000000]       .init : 0xffff000008f00000 - 0xffff000009430000   (  5312 KB)
> [    0.000000]       .data : 0xffff000009430000 - 0xffff0000095bf200   (  1597 KB)
> [    0.000000]        .bss : 0xffff0000095bf200 - 0xffff0000096b1c80   (   971 KB)
> [    0.000000]     fixed   : 0xffff7dfffe7f9000 - 0xffff7dfffec00000   (  4124 KB)
> [    0.000000]     PCI I/O : 0xffff7dfffee00000 - 0xffff7dffffe00000   (    16 MB)
> [    0.000000]     vmemmap : 0xffff7e0000000000 - 0xffff800000000000   (  2048 GB maximum)
> [    0.000000]               0xffff7e0000008000 - 0xffff7e0060000000   (  1535 MB actual)
> [    0.000000]     memory  : 0xffff800000200000 - 0xffff801800000000   ( 98302 MB)
> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=46, Nodes=1
> [    0.000000] ftrace: allocating 37871 entries in 148 pages
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=46.
> [    0.000000]  Tasks RCU enabled.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=46
> [    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
> [    0.000000] GICv3: GIC: Using split EOI/Deactivate mode
> [    0.000000] GICv3: Distributor has no Range Selector support
> [    0.000000] GICv3: VLPI support, no direct LPI support
> [    0.000000] ACPI: SRAT not present
> [    0.000000] ITS [mem 0xff7efe0000-0xff7effffff]
> [    0.000000] ITS@0x000000ff7efe0000: Using ITS number 0
> [    0.000000] GIC: enabling workaround for ITS: QDF2400 erratum 0065
> [    0.000000] ITS@0x000000ff7efe0000: allocated 524288 Devices @179e800000 (indirect, esz 8, psz 64K, shr 1)
> [    0.000000] ITS@0x000000ff7efe0000: allocated 8192 Interrupt Collections @179f150000 (flat, esz 8, psz 64K, shr 1)
> [    0.000000] ITS@0x000000ff7efe0000: allocated 65536 Virtual CPUs @179f180000 (flat, esz 8, psz 64K, shr 1)
> [    0.000000] GIC: using LPI property table @0x000000179a960000
> [    0.000000] ITS: Allocated 1792 chunks for LPIs
> [    0.000000] ITS: Allocated DevID ffffffff as GICv4 proxy device (64 slots)
> [    0.000000] ITS: Enabling GICv4 support
> [    0.000000] GICv3: CPU0: found redistributor 0 region 0:0x000000ff7f000000
> [    0.000000] CPU0: using LPI pending table @0x000000179aa00000
> [    0.000000] arch_timer: cp15 timer(s) running at 20.00MHz (phys).
> [    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x49cd42e20, max_idle_ns: 440795202120 ns
> [    0.000002] sched_clock: 56 bits at 20MHz, resolution 50ns, wraps every 4398046511100ns
> [    0.008696] Console: colour dummy device 80x25
> [    0.013504] Remapping and enabling EFI services.
> [    0.018453]   EFI remap 0x0000000000200000 => 000059efedb70000
> [    0.024689]   EFI remap 0x0000000003080000 => 000059efedb90000
> [    0.030927]   EFI remap 0x0000000004c10000 => 000059efedba0000
> [    0.037177]   EFI remap 0x0000000007d70000 => 000059efedbc0000
> [    0.043415]   EFI remap 0x0000000007e00000 => 000059efedc50000
> [    0.049662]   EFI remap 0x0000000007e10000 => 000059efedc60000
> [    0.055900]   EFI remap 0x0000000007ea0000 => 000059efedcf0000
> [    0.062138]   EFI remap 0x0000000007ec0000 => 000059efedd10000
> [    0.068381]   EFI remap 0x0000000007f10000 => 000059efedd40000
> [    0.074617]   EFI remap 0x0000000007f70000 => 000059efedda0000
> [    0.080857]   EFI remap 0x0000000007f80000 => 000059efeddb0000
> [    0.087104]   EFI remap 0x00000000083f0000 => 000059efedde0000
> [    0.093343]   EFI remap 0x0000000008450000 => 000059efede40000
> [    0.099593]   EFI remap 0x0000000008460000 => 000059efede50000
> [    0.105827]   EFI remap 0x00000000084f0000 => 000059efedee0000
> [    0.112076]   EFI remap 0x0000000008500000 => 000059efedef0000
> [    0.118313]   EFI remap 0x0000000008590000 => 000059efedf80000
> [    0.124552]   EFI remap 0x00000000085b0000 => 000059efedfa0000
> [    0.130798]   EFI remap 0x0000000008640000 => 000059efedfd0000
> [    0.137038]   EFI remap 0x00000000086a0000 => 000059efee030000
> [    0.143287]   EFI remap 0x00000000086b0000 => 000059efee040000
> [    0.149526]   EFI remap 0x0000000008760000 => 000059efee0f0000
> [    0.155764]   EFI remap 0x0000000008770000 => 000059efee100000
> [    0.162005]   EFI remap 0x0000000008970000 => 000059efee140000
> [    0.168240]   EFI remap 0x00000000089d0000 => 000059efee1a0000
> [    0.174476]   EFI remap 0x00000000089e0000 => 000059efee1b0000
> [    0.180719]   EFI remap 0x0000000008a80000 => 000059efee1e0000
> [    0.186954]   EFI remap 0x0000000008ae0000 => 000059efee240000
> [    0.193198]   EFI remap 0x0000000008af0000 => 000059efee250000
> [    0.199436]   EFI remap 0x0000000008b80000 => 000059efee2e0000
> [    0.205675]   EFI remap 0x0000000008b90000 => 000059efee2f0000
> [    0.211918]   EFI remap 0x0000000008be0000 => 000059efee320000
> [    0.218155]   EFI remap 0x0000000008c40000 => 000059efee380000
> [    0.224403]   EFI remap 0x0000000008c50000 => 000059efee390000
> [    0.230638]   EFI remap 0x0000000008ce0000 => 000059efee420000
> [    0.236885]   EFI remap 0x0000000008cf0000 => 000059efee430000
> [    0.243124]   EFI remap 0x0000000008d80000 => 000059efee4c0000
> [    0.249371]   EFI remap 0x0000000008d90000 => 000059efee4d0000
> [    0.255608]   EFI remap 0x0000000008e20000 => 000059efee560000
> [    0.261851]   EFI remap 0x0000000008e30000 => 000059efee570000
> [    0.268089]   EFI remap 0x0000000008ec0000 => 000059efee600000
> [    0.274328]   EFI remap 0x0000000008ed0000 => 000059efee610000
> [    0.280565]   EFI remap 0x000000000def0000 => 000059efee640000
> [    0.286801]   EFI remap 0x000000001c000000 => 000059efee670000
> [    0.293036]   EFI remap 0x000000ff70030000 => 000059efee680000
> [    0.299272]   EFI remap 0x000000ff70400000 => 000059efee690000
> [    0.305504]   EFI remap 0x000000ff79000000 => 000059efee800000
> [    0.311739]   EFI remap 0x000000ff79420000 => 000059efeec00000
> [    0.317973]   EFI remap 0x000000ff7ac00000 => 000059efeee00000
> [    0.324205] Calibrating delay loop (skipped), value calculated using timer frequency.. 40.00 BogoMIPS (lpj=80000)
> [    0.335182] pid_max: default: 47104 minimum: 368
> [    0.340137] ACPI: Core revision 20170728
> [    0.427196] ACPI: 1 ACPI AML tables successfully acquired and loaded
> [    0.434077] Security Framework initialized
> [    0.438458] Yama: becoming mindful.
> [    0.442188] SELinux:  Disabled at boot.
> [    0.446285] AppArmor: AppArmor disabled by boot time parameter
> [    0.460600] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
> [    0.472525] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
> [    0.480491] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.488159] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.497126] ASID allocator initialised with 32768 entries
> [    0.502948] Hierarchical SRCU implementation.
> [    0.508355] PCI/MSI: ITS@0xff7efe0000 domain created
> [    0.513677] Platform MSI: ITS@0xff7efe0000 domain created
> [    0.520148] smp: Bringing up secondary CPUs ...
> [    0.526698] Detected PIPT I-cache on CPU1
> [    0.526723] GICv3: CPU1: found redistributor 100 region 1:0x000000ff7f080000
> [    0.526739] CPU1: using LPI pending table @0x0000001793fa0000
> [    0.526784] CPU1: Booted secondary processor [510f8000]
> [    0.528693] Detected PIPT I-cache on CPU2
> [    0.528717] GICv3: CPU2: found redistributor 200 region 2:0x000000ff7f100000
> [    0.528733] CPU2: using LPI pending table @0x0000001793ff0000
> [    0.528780] CPU2: Booted secondary processor [510f8000]
> [    0.530669] Detected PIPT I-cache on CPU3
> [    0.530694] GICv3: CPU3: found redistributor 300 region 3:0x000000ff7f180000
> [    0.530710] CPU3: using LPI pending table @0x0000001793840000
> [    0.530757] CPU3: Booted secondary processor [510f8000]
> [    0.532547] Detected PIPT I-cache on CPU4
> [    0.532572] GICv3: CPU4: found redistributor 400 region 4:0x000000ff7f200000
> [    0.532588] CPU4: using LPI pending table @0x0000001793890000
> [    0.532634] CPU4: Booted secondary processor [510f8000]
> [    0.534526] Detected PIPT I-cache on CPU5
> [    0.534553] GICv3: CPU5: found redistributor 500 region 5:0x000000ff7f280000
> [    0.534568] CPU5: using LPI pending table @0x00000017938d0000
> [    0.534619] CPU5: Booted secondary processor [510f8000]
> [    0.536410] Detected PIPT I-cache on CPU6
> [    0.536437] GICv3: CPU6: found redistributor 700 region 6:0x000000ff7f380000
> [    0.536452] CPU6: using LPI pending table @0x0000001793930000
> [    0.536501] CPU6: Booted secondary processor [510f8000]
> [    0.538279] Detected PIPT I-cache on CPU7
> [    0.538307] GICv3: CPU7: found redistributor 800 region 7:0x000000ff7f400000
> [    0.538322] CPU7: using LPI pending table @0x0000001793980000
> [    0.538370] CPU7: Booted secondary processor [510f8000]
> [    0.540235] Detected PIPT I-cache on CPU8
> [    0.540264] GICv3: CPU8: found redistributor 900 region 8:0x000000ff7f480000
> [    0.540281] CPU8: using LPI pending table @0x00000017939c0000
> [    0.540332] CPU8: Booted secondary processor [510f8000]
> [    0.542201] Detected PIPT I-cache on CPU9
> [    0.542231] GICv3: CPU9: found redistributor a00 region 9:0x000000ff7f500000
> [    0.542247] CPU9: using LPI pending table @0x0000001793a30000
> [    0.542298] CPU9: Booted secondary processor [510f8000]
> [    0.544062] Detected PIPT I-cache on CPU10
> [    0.544092] GICv3: CPU10: found redistributor b00 region 10:0x000000ff7f580000
> [    0.544108] CPU10: using LPI pending table @0x0000001793a70000
> [    0.544161] CPU10: Booted secondary processor [510f8000]
> [    0.545872] Detected PIPT I-cache on CPU11
> [    0.545903] GICv3: CPU11: found redistributor c00 region 11:0x000000ff7f600000
> [    0.545918] CPU11: using LPI pending table @0x0000001793ab0000
> [    0.545972] CPU11: Booted secondary processor [510f8000]
> [    0.547846] Detected PIPT I-cache on CPU12
> [    0.547878] GICv3: CPU12: found redistributor d00 region 12:0x000000ff7f680000
> [    0.547894] CPU12: using LPI pending table @0x0000001793b20000
> [    0.547948] CPU12: Booted secondary processor [510f8000]
> [    0.549789] Detected PIPT I-cache on CPU13
> [    0.549821] GICv3: CPU13: found redistributor e00 region 13:0x000000ff7f700000
> [    0.549837] CPU13: using LPI pending table @0x0000001793b60000
> [    0.549891] CPU13: Booted secondary processor [510f8000]
> [    0.551610] Detected PIPT I-cache on CPU14
> [    0.551644] GICv3: CPU14: found redistributor f00 region 14:0x000000ff7f780000
> [    0.551659] CPU14: using LPI pending table @0x0000001793ba0000
> [    0.551713] CPU14: Booted secondary processor [510f8000]
> [    0.553494] Detected PIPT I-cache on CPU15
> [    0.553527] GICv3: CPU15: found redistributor 1000 region 15:0x000000ff7f800000
> [    0.553542] CPU15: using LPI pending table @0x0000001793400000
> [    0.553596] CPU15: Booted secondary processor [510f8000]
> [    0.555469] Detected PIPT I-cache on CPU16
> [    0.555502] GICv3: CPU16: found redistributor 1100 region 16:0x000000ff7f880000
> [    0.555518] CPU16: using LPI pending table @0x0000001793450000
> [    0.555573] CPU16: Booted secondary processor [510f8000]
> [    0.557465] Detected PIPT I-cache on CPU17
> [    0.557499] GICv3: CPU17: found redistributor 1200 region 17:0x000000ff7f900000
> [    0.557514] CPU17: using LPI pending table @0x0000001793490000
> [    0.557570] CPU17: Booted secondary processor [510f8000]
> [    0.559365] Detected PIPT I-cache on CPU18
> [    0.559399] GICv3: CPU18: found redistributor 1300 region 18:0x000000ff7f980000
> [    0.559415] CPU18: using LPI pending table @0x0000001793500000
> [    0.559472] CPU18: Booted secondary processor [510f8000]
> [    0.561285] Detected PIPT I-cache on CPU19
> [    0.561319] GICv3: CPU19: found redistributor 1400 region 19:0x000000ff7fa00000
> [    0.561334] CPU19: using LPI pending table @0x0000001793540000
> [    0.561388] CPU19: Booted secondary processor [510f8000]
> [    0.563269] Detected PIPT I-cache on CPU20
> [    0.563305] GICv3: CPU20: found redistributor 1500 region 20:0x000000ff7fa80000
> [    0.563320] CPU20: using LPI pending table @0x0000001793580000
> [    0.563378] CPU20: Booted secondary processor [510f8000]
> [    0.565244] Detected PIPT I-cache on CPU21
> [    0.565281] GICv3: CPU21: found redistributor 1600 region 21:0x000000ff7fb00000
> [    0.565297] CPU21: using LPI pending table @0x00000017935f0000
> [    0.565354] CPU21: Booted secondary processor [510f8000]
> [    0.567193] Detected PIPT I-cache on CPU22
> [    0.567230] GICv3: CPU22: found redistributor 1700 region 22:0x000000ff7fb80000
> [    0.567245] CPU22: using LPI pending table @0x0000001793630000
> [    0.567302] CPU22: Booted secondary processor [510f8000]
> [    0.568890] Detected PIPT I-cache on CPU23
> [    0.568917] GICv3: CPU23: found redistributor 1 region 23:0x000000ff7f040000
> [    0.568927] CPU23: using LPI pending table @0x0000001793670000
> [    0.568966] CPU23: Booted secondary processor [510f8000]
> [    0.570748] Detected PIPT I-cache on CPU24
> [    0.570782] GICv3: CPU24: found redistributor 101 region 24:0x000000ff7f0c0000
> [    0.570797] CPU24: using LPI pending table @0x00000017936c0000
> [    0.570844] CPU24: Booted secondary processor [510f8000]
> [    0.572692] Detected PIPT I-cache on CPU25
> [    0.572727] GICv3: CPU25: found redistributor 201 region 25:0x000000ff7f140000
> [    0.572741] CPU25: using LPI pending table @0x0000001793720000
> [    0.572791] CPU25: Booted secondary processor [510f8000]
> [    0.574610] Detected PIPT I-cache on CPU26
> [    0.574646] GICv3: CPU26: found redistributor 301 region 26:0x000000ff7f1c0000
> [    0.574661] CPU26: using LPI pending table @0x0000001793760000
> [    0.574710] CPU26: Booted secondary processor [510f8000]
> [    0.576543] Detected PIPT I-cache on CPU27
> [    0.576579] GICv3: CPU27: found redistributor 401 region 27:0x000000ff7f240000
> [    0.576594] CPU27: using LPI pending table @0x00000017937a0000
> [    0.576643] CPU27: Booted secondary processor [510f8000]
> [    0.578514] Detected PIPT I-cache on CPU28
> [    0.578557] GICv3: CPU28: found redistributor 601 region 28:0x000000ff7f340000
> [    0.578572] CPU28: using LPI pending table @0x0000001793010000
> [    0.578634] CPU28: Booted secondary processor [510f8000]
> [    0.580487] Detected PIPT I-cache on CPU29
> [    0.580527] GICv3: CPU29: found redistributor 701 region 29:0x000000ff7f3c0000
> [    0.580542] CPU29: using LPI pending table @0x0000001793060000
> [    0.580593] CPU29: Booted secondary processor [510f8000]
> [    0.582349] Detected PIPT I-cache on CPU30
> [    0.582389] GICv3: CPU30: found redistributor 801 region 30:0x000000ff7f440000
> [    0.582404] CPU30: using LPI pending table @0x00000017930a0000
> [    0.582453] CPU30: Booted secondary processor [510f8000]
> [    0.584272] Detected PIPT I-cache on CPU31
> [    0.584312] GICv3: CPU31: found redistributor 901 region 31:0x000000ff7f4c0000
> [    0.584327] CPU31: using LPI pending table @0x0000001793100000
> [    0.584380] CPU31: Booted secondary processor [510f8000]
> [    0.586217] Detected PIPT I-cache on CPU32
> [    0.586258] GICv3: CPU32: found redistributor a01 region 32:0x000000ff7f540000
> [    0.586273] CPU32: using LPI pending table @0x0000001793140000
> [    0.586326] CPU32: Booted secondary processor [510f8000]
> [    0.588098] Detected PIPT I-cache on CPU33
> [    0.588140] GICv3: CPU33: found redistributor b01 region 33:0x000000ff7f5c0000
> [    0.588155] CPU33: using LPI pending table @0x0000001793180000
> [    0.588210] CPU33: Booted secondary processor [510f8000]
> [    0.589917] Detected PIPT I-cache on CPU34
> [    0.589960] GICv3: CPU34: found redistributor c01 region 34:0x000000ff7f640000
> [    0.589974] CPU34: using LPI pending table @0x00000017931f0000
> [    0.590028] CPU34: Booted secondary processor [510f8000]
> [    0.591863] Detected PIPT I-cache on CPU35
> [    0.591907] GICv3: CPU35: found redistributor d01 region 35:0x000000ff7f6c0000
> [    0.591922] CPU35: using LPI pending table @0x0000001793230000
> [    0.591980] CPU35: Booted secondary processor [510f8000]
> [    0.593843] Detected PIPT I-cache on CPU36
> [    0.593888] GICv3: CPU36: found redistributor e01 region 36:0x000000ff7f740000
> [    0.593903] CPU36: using LPI pending table @0x0000001793280000
> [    0.593959] CPU36: Booted secondary processor [510f8000]
> [    0.595681] Detected PIPT I-cache on CPU37
> [    0.595725] GICv3: CPU37: found redistributor f01 region 37:0x000000ff7f7c0000
> [    0.595739] CPU37: using LPI pending table @0x00000017932e0000
> [    0.595796] CPU37: Booted secondary processor [510f8000]
> [    0.597472] Detected PIPT I-cache on CPU38
> [    0.597517] GICv3: CPU38: found redistributor 1001 region 38:0x000000ff7f840000
> [    0.597531] CPU38: using LPI pending table @0x0000001793320000
> [    0.597585] CPU38: Booted secondary processor [510f8000]
> [    0.599468] Detected PIPT I-cache on CPU39
> [    0.599513] GICv3: CPU39: found redistributor 1101 region 39:0x000000ff7f8c0000
> [    0.599528] CPU39: using LPI pending table @0x0000001793370000
> [    0.599586] CPU39: Booted secondary processor [510f8000]
> [    0.601462] Detected PIPT I-cache on CPU40
> [    0.601507] GICv3: CPU40: found redistributor 1201 region 40:0x000000ff7f940000
> [    0.601522] CPU40: using LPI pending table @0x00000017933d0000
> [    0.601579] CPU40: Booted secondary processor [510f8000]
> [    0.603276] Detected PIPT I-cache on CPU41
> [    0.603322] GICv3: CPU41: found redistributor 1301 region 41:0x000000ff7f9c0000
> [    0.603337] CPU41: using LPI pending table @0x0000001792c10000
> [    0.603395] CPU41: Booted secondary processor [510f8000]
> [    0.605152] Detected PIPT I-cache on CPU42
> [    0.605198] GICv3: CPU42: found redistributor 1401 region 42:0x000000ff7fa40000
> [    0.605213] CPU42: using LPI pending table @0x0000001792c50000
> [    0.605268] CPU42: Booted secondary processor [510f8000]
> [    0.607144] Detected PIPT I-cache on CPU43
> [    0.607191] GICv3: CPU43: found redistributor 1501 region 43:0x000000ff7fac0000
> [    0.607206] CPU43: using LPI pending table @0x0000001792cb0000
> [    0.607267] CPU43: Booted secondary processor [510f8000]
> [    0.609108] Detected PIPT I-cache on CPU44
> [    0.609156] GICv3: CPU44: found redistributor 1601 region 44:0x000000ff7fb40000
> [    0.609171] CPU44: using LPI pending table @0x0000001792d10000
> [    0.609231] CPU44: Booted secondary processor [510f8000]
> [    0.610984] Detected PIPT I-cache on CPU45
> [    0.611031] GICv3: CPU45: found redistributor 1701 region 45:0x000000ff7fbc0000
> [    0.611046] CPU45: using LPI pending table @0x0000001792d50000
> [    0.611105] CPU45: Booted secondary processor [510f8000]
> [    0.611285] smp: Brought up 1 node, 46 CPUs
> [    1.692859] SMP: Total of 46 processors activated.
> [    1.697980] CPU features: detected feature: GIC system register CPU interface
> [    1.705605] CPU features: detected feature: Privileged Access Never
> [    1.712306] CPU features: detected feature: Kernel page table isolation (KPTI)
> [    1.923161] CPU: All CPU(s) started at EL2
> [    1.927918] alternatives: patching kernel code
> [    1.949231] devtmpfs: initialized
> [    1.953104] evm: security.selinux
> [    1.956637] evm: security.SMACK64
> [    1.960181] evm: security.SMACK64EXEC
> [    1.964083] evm: security.SMACK64TRANSMUTE
> [    1.968458] evm: security.SMACK64MMAP
> [    1.972365] evm: security.ima
> [    1.975533] evm: security.capability
> [    1.980366] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
> [    1.990969] futex hash table entries: 16384 (order: 9, 2097152 bytes)
> [    1.998390] pinctrl core: initialized pinctrl subsystem
> [    2.004399] SMBIOS 3.1.1 present.
> [    2.007948] DMI: Qualcomm Qualcomm Centriq(TM) 2400 Development Platform/ABW|SYS|CVR,1DPC|V3           , BIOS STB_XBL.DF.2.0_-64-1-G1CA82A3-DIRT
> [    2.021938] NET: Registered protocol family 16
> [    2.028242] cpuidle: using governor ladder
> [    2.032767] cpuidle: using governor menu
> [    2.037016] Detected 2 PCC Subspaces
> [    2.040890] Registering PCC driver as Mailbox controller
> [    2.046727] vdso: 2 pages (1 code @ ffff000008ad7000, 1 data @ ffff000009435000)
> [    2.054642] hw-breakpoint: found 8 breakpoint and 4 watchpoint registers.
> [    2.063004] DMA: preallocated 256 KiB pool for atomic allocations
> [    2.069562] ACPI: bus type PCI registered
> [    2.073845] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [    2.080801] Serial: AMBA PL011 UART driver
> [    2.090733] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
> [    2.099333] ipmi:dmi: Invalid IPMI type: 0
> [    2.099623] ACPI: Added _OSI(Module Device)
> [    2.108477] ACPI: Added _OSI(Processor Device)
> [    2.113221] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    2.118248] ACPI: Added _OSI(Processor Aggregator Device)
> [    2.624538] ACPI: Interpreter enabled
> [    2.628465] ACPI: Using GIC for interrupt routing
> [    2.633524] ACPI: MCFG table detected, 3 entries
> [    2.639208] HEST: Table parsing has been initialized.
> [    2.754704] sbsa-uart ARMH0011:01: working around QDF2400 SoC erratum 44
> [    2.761904] ARMH0011:01: ttyAMA0 at MMIO 0xff78ed1000 (irq = 27, base_baud = 0) is a SBSA
> [    2.770657] console [ttyAMA0] enabled
> [    2.778217] bootconsole [pl11] disabled
> [    2.807250] ACPI: PCI Interrupt Link [LN0A] (IRQs *88)
> [    2.811494] ACPI: PCI Interrupt Link [LN0B] (IRQs *89)
> [    2.816609] ACPI: PCI Interrupt Link [LN0C] (IRQs *90)
> [    2.821730] ACPI: PCI Interrupt Link [LN0D] (IRQs *91)
> [    2.827045] ACPI: PCI Root Bridge [PCI1] (domain 0001 [bus 00-ff])
> [    2.833001] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    2.841343] acpi PNP0A08:01: PCIe AER handled by firmware
> [    2.846902] acpi PNP0A08:01: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
> [    2.869335] acpi PNP0A08:01: ECAM area [mem 0x90000000000-0x9000fffffff] reserved by PNP0C02:01
> [    2.877110] acpi PNP0A08:01: ECAM at [mem 0x90000000000-0x9000fffffff] for [bus 00-ff]
> [    2.885060] Remapped I/O 0x000009ffffff0000 to [io  0x0000-0xffff window]
> [    2.891887] PCI host bridge to bus 0001:00
> [    2.895833] pci_bus 0001:00: root bus resource [mem 0x90100100000-0x9011fffffff window] (bus address [0x00100000-0x1fffffff])
> [    2.907114] pci_bus 0001:00: root bus resource [mem 0x90200000000-0x9021fffffff window] (bus address [0x20000000-0x3fffffff])
> [    2.918398] pci_bus 0001:00: root bus resource [mem 0x90300000000-0x9033fffffff window] (bus address [0x40000000-0x7fffffff])
> [    2.929682] pci_bus 0001:00: root bus resource [mem 0x90400000000-0x9fffffeffff window]
> [    2.937669] pci_bus 0001:00: root bus resource [io  0x0000-0xffff window] (bus address [0x1000-0x10fff])
> [    2.947131] pci_bus 0001:00: root bus resource [bus 00-ff]
> [    2.952611] pci 0001:00:00.0: [17cb:0401] type 01 class 0x060400
> [    2.958645] pci 0001:00:00.0: PME# supported from D0 D3hot
> [    2.964242] pci 0001:00:00.0: BAR 14: assigned [mem 0x90100100000-0x901002fffff]
> [    2.971442] pci 0001:00:00.0: BAR 15: assigned [mem 0x90400000000-0x904001fffff 64bit pref]
> [    2.979770] pci 0001:00:00.0: BAR 13: assigned [io  0x1000-0x1fff]
> [    2.985933] pci 0001:00:00.0: PCI bridge to [bus 01]
> [    2.990881] pci 0001:00:00.0:   bridge window [io  0x1000-0x1fff]
> [    2.996957] pci 0001:00:00.0:   bridge window [mem 0x90100100000-0x901002fffff]
> [    3.004253] pci 0001:00:00.0:   bridge window [mem 0x90400000000-0x904001fffff 64bit pref]
> [    3.012500] pci 0001:00:00.0: Max Payload Size set to  512/ 512 (was  512), Max Read Rq 4096
> [    3.020979] ACPI: PCI Interrupt Link [LN1A] (IRQs *92)
> [    3.026086] ACPI: PCI Interrupt Link [LN1B] (IRQs *93)
> [    3.031205] ACPI: PCI Interrupt Link [LN1C] (IRQs *94)
> [    3.036327] ACPI: PCI Interrupt Link [LN1D] (IRQs *95)
> [    3.041636] ACPI: PCI Root Bridge [PCI2] (domain 0002 [bus 00-ff])
> [    3.047595] acpi PNP0A08:02: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    3.055939] acpi PNP0A08:02: PCIe AER handled by firmware
> [    3.061495] acpi PNP0A08:02: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
> [    3.084135] acpi PNP0A08:02: ECAM area [mem 0xa0000000000-0xa000fffffff] reserved by PNP0C02:02
> [    3.091905] acpi PNP0A08:02: ECAM at [mem 0xa0000000000-0xa000fffffff] for [bus 00-ff]
> [    3.099850] Remapped I/O 0x00000affffff0000 to [io  0x10000-0x1ffff window]
> [    3.106856] PCI host bridge to bus 0002:00
> [    3.110804] pci_bus 0002:00: root bus resource [mem 0xa0100100000-0xa011fffffff window] (bus address [0x00100000-0x1fffffff])
> [    3.122086] pci_bus 0002:00: root bus resource [mem 0xa0200000000-0xa021fffffff window] (bus address [0x20000000-0x3fffffff])
> [    3.133376] pci_bus 0002:00: root bus resource [mem 0xa0300000000-0xa033fffffff window] (bus address [0x40000000-0x7fffffff])
> [    3.144655] pci_bus 0002:00: root bus resource [mem 0xa0400000000-0xafffffeffff window]
> [    3.152641] pci_bus 0002:00: root bus resource [io  0x10000-0x1ffff window] (bus address [0x1000-0x10fff])
> [    3.162277] pci_bus 0002:00: root bus resource [bus 00-ff]
> [    3.167755] pci 0002:00:00.0: [17cb:0401] type 01 class 0x060400
> [    3.173787] pci 0002:00:00.0: PME# supported from D0 D3hot
> [    3.179383] pci 0002:01:00.0: [8086:105e] type 00 class 0x020000
> [    3.185219] pci 0002:01:00.0: reg 0x10: [mem 0xa0100100000-0xa010011ffff]
> [    3.191971] pci 0002:01:00.0: reg 0x14: [mem 0xa0100120000-0xa010013ffff]
> [    3.198742] pci 0002:01:00.0: reg 0x18: [io  0x10000-0x1001f]
> [    3.204497] pci 0002:01:00.0: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
> [    3.211217] pci 0002:01:00.0: PME# supported from D0 D3hot D3cold
> [    3.217345] pci 0002:01:00.1: [8086:105e] type 00 class 0x020000
> [    3.223238] pci 0002:01:00.1: reg 0x10: [mem 0xa0100160000-0xa010017ffff]
> [    3.229992] pci 0002:01:00.1: reg 0x14: [mem 0xa0100180000-0xa010019ffff]
> [    3.236763] pci 0002:01:00.1: reg 0x18: [io  0x10020-0x1003f]
> [    3.242517] pci 0002:01:00.1: reg 0x30: [mem 0xfffe0000-0xffffffff pref]
> [    3.249236] pci 0002:01:00.1: PME# supported from D0 D3hot D3cold
> [    3.255357] pci 0002:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
> [    3.265256] pci 0002:00:00.0: BAR 14: assigned [mem 0xa0100100000-0xa01002fffff]
> [    3.272609] pci 0002:00:00.0: BAR 15: assigned [mem 0xa0400000000-0xa04001fffff 64bit pref]
> [    3.280940] pci 0002:00:00.0: BAR 13: assigned [io  0x10000-0x10fff]
> [    3.287279] pci 0002:01:00.0: BAR 0: assigned [mem 0xa0100100000-0xa010011ffff]
> [    3.294571] pci 0002:01:00.0: BAR 1: assigned [mem 0xa0100120000-0xa010013ffff]
> [    3.301863] pci 0002:01:00.0: BAR 6: assigned [mem 0xa0100140000-0xa010015ffff pref]
> [    3.309585] pci 0002:01:00.1: BAR 0: assigned [mem 0xa0100160000-0xa010017ffff]
> [    3.316879] pci 0002:01:00.1: BAR 1: assigned [mem 0xa0100180000-0xa010019ffff]
> [    3.324171] pci 0002:01:00.1: BAR 6: assigned [mem 0xa01001a0000-0xa01001bffff pref]
> [    3.331894] pci 0002:01:00.0: BAR 2: assigned [io  0x10000-0x1001f]
> [    3.338147] pci 0002:01:00.1: BAR 2: assigned [io  0x10020-0x1003f]
> [    3.344398] pci 0002:00:00.0: PCI bridge to [bus 01]
> [    3.349342] pci 0002:00:00.0:   bridge window [io  0x10000-0x10fff]
> [    3.355592] pci 0002:00:00.0:   bridge window [mem 0xa0100100000-0xa01002fffff]
> [    3.362884] pci 0002:00:00.0:   bridge window [mem 0xa0400000000-0xa04001fffff 64bit pref]
> [    3.371135] pci 0002:00:00.0: Max Payload Size set to  256/ 512 (was  256), Max Read Rq 4096
> [    3.379557] pci 0002:01:00.0: Max Payload Size set to  256/ 256 (was  256), Max Read Rq 4096
> [    3.387978] pci 0002:01:00.1: Max Payload Size set to  256/ 256 (was  256), Max Read Rq 4096
> [    3.396460] ACPI: PCI Interrupt Link [LN2A] (IRQs *96)
> [    3.401565] ACPI: PCI Interrupt Link [LN2B] (IRQs *97)
> [    3.406682] ACPI: PCI Interrupt Link [LN2C] (IRQs *98)
> [    3.411803] ACPI: PCI Interrupt Link [LN2D] (IRQs *99)
> [    3.417117] ACPI: PCI Root Bridge [PCI3] (domain 0003 [bus 00-ff])
> [    3.423071] acpi PNP0A08:03: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
> [    3.431412] acpi PNP0A08:03: PCIe AER handled by firmware
> [    3.436971] acpi PNP0A08:03: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
> [    3.460072] acpi PNP0A08:03: ECAM area [mem 0xc0000000000-0xc000fffffff] reserved by PNP0C02:03
> [    3.467842] acpi PNP0A08:03: ECAM at [mem 0xc0000000000-0xc000fffffff] for [bus 00-ff]
> [    3.475788] Remapped I/O 0x00000cffffff0000 to [io  0x20000-0x2ffff window]
> [    3.482806] PCI host bridge to bus 0003:00
> [    3.486742] pci_bus 0003:00: root bus resource [mem 0xc0100100000-0xc011fffffff window] (bus address [0x00100000-0x1fffffff])
> [    3.498024] pci_bus 0003:00: root bus resource [mem 0xc0200000000-0xc021fffffff window] (bus address [0x20000000-0x3fffffff])
> [    3.509309] pci_bus 0003:00: root bus resource [mem 0xc0300000000-0xc033fffffff window] (bus address [0x40000000-0x7fffffff])
> [    3.520592] pci_bus 0003:00: root bus resource [mem 0xc0400000000-0xcfffffeffff window]
> [    3.528584] pci_bus 0003:00: root bus resource [io  0x20000-0x2ffff window] (bus address [0x1000-0x10fff])
> [    3.538217] pci_bus 0003:00: root bus resource [bus 00-ff]
> [    3.543693] pci 0003:00:00.0: [17cb:0401] type 01 class 0x060400
> [    3.549723] pci 0003:00:00.0: PME# supported from D0 D3hot
> [    3.555354] pci 0003:01:00.0: [15b3:1015] type 00 class 0x020000
> [    3.561269] pci 0003:01:00.0: reg 0x10: [mem 0xc0400000000-0xc0401ffffff 64bit pref]
> [    3.569069] pci 0003:01:00.0: reg 0x30: [mem 0xfff00000-0xffffffff pref]
> [    3.575973] pci 0003:01:00.0: PME# supported from D3cold
> [    3.581017] pci 0003:01:00.0: reg 0x1a4: [mem 0xc0402000000-0xc04020fffff 64bit pref]
> [    3.588649] pci 0003:01:00.0: VF(n) BAR0 space: [mem 0xc0402000000-0xc04027fffff 64bit pref] (contains BAR0 for 8 VFs)
> [    3.600033] pci 0003:00:00.0: BAR 15: assigned [mem 0xc0400000000-0xc0403ffffff 64bit pref]
> [    3.607661] pci 0003:00:00.0: BAR 14: assigned [mem 0xc0100100000-0xc01002fffff]
> [    3.615037] pci 0003:00:00.0: BAR 13: assigned [io  0x20000-0x20fff]
> [    3.621376] pci 0003:01:00.0: BAR 0: assigned [mem 0xc0400000000-0xc0401ffffff 64bit pref]
> [    3.629657] pci 0003:01:00.0: BAR 6: assigned [mem 0xc0100100000-0xc01001fffff pref]
> [    3.637346] pci 0003:01:00.0: BAR 7: assigned [mem 0xc0402000000-0xc04027fffff 64bit pref]
> [    3.645607] pci 0003:00:00.0: PCI bridge to [bus 01-02]
> [    3.650800] pci 0003:00:00.0:   bridge window [io  0x20000-0x20fff]
> [    3.657055] pci 0003:00:00.0:   bridge window [mem 0xc0100100000-0xc01002fffff]
> [    3.664343] pci 0003:00:00.0:   bridge window [mem 0xc0400000000-0xc0403ffffff 64bit pref]
> [    3.672593] pci 0003:00:00.0: Max Payload Size set to  512/ 512 (was  512), Max Read Rq 4096
> [    3.681052] pci 0003:01:00.0: Max Payload Size set to  512/ 512 (was  512), Max Read Rq 4096
> [    3.689495] ACPI: PCI Interrupt Link [LN3A] (IRQs *100)
> [    3.694688] ACPI: PCI Interrupt Link [LN3B] (IRQs *101)
> [    3.699893] ACPI: PCI Interrupt Link [LN3C] (IRQs *102)
> [    3.705101] ACPI: PCI Interrupt Link [LN3D] (IRQs *103)
> [    3.710485] ACPI: PCI Interrupt Link [LN4A] (IRQs *104)
> [    3.715521] ACPI: PCI Interrupt Link [LN4B] (IRQs *105)
> [    3.720726] ACPI: PCI Interrupt Link [LN4C] (IRQs *106)
> [    3.725940] ACPI: PCI Interrupt Link [LN4D] (IRQs *107)
> [    3.731302] ACPI: PCI Interrupt Link [LN5A] (IRQs *108)
> [    3.736354] ACPI: PCI Interrupt Link [LN5B] (IRQs *109)
> [    3.741559] ACPI: PCI Interrupt Link [LN5C] (IRQs *110)
> [    3.746766] ACPI: PCI Interrupt Link [LN5D] (IRQs *111)
> [    3.785239] vgaarb: loaded
> [    3.787508] SCSI subsystem initialized
> [    3.790969] libata version 3.00 loaded.
> [    3.794579] ACPI: bus type USB registered
> [    3.798580] usbcore: registered new interface driver usbfs
> [    3.804024] usbcore: registered new interface driver hub
> [    3.809561] usbcore: registered new device driver usb
> [    3.815003] EDAC MC: Ver: 3.0.0
> [    3.817679] Registered efivars operations
> [    3.824334] NetLabel: Initializing
> [    3.826790] NetLabel:  domain hash size = 128
> [    3.831120] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
> [    3.836789] NetLabel:  unlabeled traffic allowed by default
> [    3.843410] clocksource: Switched to clocksource arch_sys_counter
> [    3.902601] VFS: Disk quotas dquot_6.6.0
> [    3.905676] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    3.912904] pnp: PnP ACPI init
> [    3.931385] system 00:00: [mem 0x80000000000-0x8000fffffff] has been reserved
> [    3.937596] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.944670] system 00:01: [mem 0x90000000000-0x9000fffffff] could not be reserved
> [    3.951830] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.958924] system 00:02: [mem 0xa0000000000-0xa000fffffff] could not be reserved
> [    3.966064] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.973152] system 00:03: [mem 0xc0000000000-0xc000fffffff] could not be reserved
> [    3.980300] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    3.987411] system 00:04: [mem 0xd0000000000-0xd000fffffff] has been reserved
> [    3.994188] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    4.001249] system 00:05: [mem 0xe0000000000-0xe000fffffff] has been reserved
> [    4.008079] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    4.035226] pnp: PnP ACPI: found 6 devices
> [    4.045479] NET: Registered protocol family 2
> [    4.050081] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
> [    4.059463] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    4.065663] TCP: Hash tables configured (established 524288 bind 65536)
> [    4.072363] UDP hash table entries: 65536 (order: 9, 2097152 bytes)
> [    4.079391] UDP-Lite hash table entries: 65536 (order: 9, 2097152 bytes)
> [    4.086643] NET: Registered protocol family 1
> [    4.090169] PCI: CLS 64 bytes, default 128
> [    4.094270] Unpacking initramfs...
> [    8.708699] Freeing initrd memory: 75272K
> [    8.714754] qcom-pmu-extensions QCOM8150:00: PCC support detected
> [    8.721846] hw perfevents: enabled with qcom_pmuv3_0 PMU driver, 9 counters available
> [    8.729268] Enabled QCOM QOS feature, number of ids 240
> [    8.734433] qcom-qos QCOM8102:00: Property 'ccm_scale' not defined, set def scale 2560
> [    8.741845] qcom-qos QCOM8102:00: Registered QOS CCM PMU, type: 7
> [    8.748229] kvm [1]: 16-bit VMID
> [    8.751114] kvm [1]: IDMAP page: 14c3000
> [    8.755033] kvm [1]: HYP VA range: 800000000000:ffffffffffff
> [    8.762242] kvm [1]: GICv3: no GICV resource entry
> [    8.766096] kvm [1]: disabling GICv2 emulation
> [    8.770638] kvm [1]: GIC system register CPU interface enabled
> [    8.777883] kvm [1]: vgic interrupt IRQ1
> [    8.780871] kvm [1]: virtual timer IRQ3
> [    8.786037] kvm [1]: Hyp mode initialized successfully
> [    8.794036] audit: initializing netlink subsys (disabled)
> [    8.798682] audit: type=2000 audit(8.188:1): state=initialized audit_enabled=0 res=1
> [    8.799250] Initialise system trusted keyrings
> [    8.799274] Key type blacklist registered
> [    8.799387] workingset: timestamp_bits=40 max_order=25 bucket_order=0
> [    8.804455] zbud: loaded
> [    8.806592] squashfs: version 4.0 (2009/01/31) Phillip Lougher
> [    8.807276] fuse init (API version 7.26)
> [    8.814552] Key type asymmetric registered
> [    8.814557] Asymmetric key parser 'x509' registered
> [    8.814709] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
> [    8.814997] io scheduler noop registered
> [    8.815000] io scheduler deadline registered
> [    8.815238] io scheduler cfq registered (default)
> [    8.864660] qcom-irq-combiner QCOM80B1:00: Initialized with [p=111,n=29,r=ffff000009c1d018]
> [    8.872283] qcom-irq-combiner QCOM80B1:01: Initialized with [p=112,n=12,r=ffff000009c3d024]
> [    8.880597] qcom-irq-combiner QCOM80B1:02: Initialized with [p=113,n=16,r=ffff000009c8d038]
> [    8.888922] qcom-irq-combiner QCOM80B1:03: Initialized with [p=114,n=18,r=ffff000009cbd03c]
> [    8.928346] (NULL device *): hwmon_device_register() is deprecated. Please convert the driver to use hwmon_device_register_with_info().
> [    8.939739] thermal LNXTHERM:00: registered as thermal_zone0
> [    8.945215] ACPI: Thermal Zone [TZ0] (24 C)
> [    8.949863] thermal LNXTHERM:01: registered as thermal_zone1
> [    8.955026] ACPI: Thermal Zone [TZ1] (23 C)
> [    8.959641] thermal LNXTHERM:02: registered as thermal_zone2
> [    8.964835] ACPI: Thermal Zone [TZ2] (23 C)
> [    8.969446] thermal LNXTHERM:03: registered as thermal_zone3
> [    8.974643] ACPI: Thermal Zone [TZ3] (23 C)
> [    8.979263] thermal LNXTHERM:04: registered as thermal_zone4
> [    8.984451] ACPI: Thermal Zone [TZ4] (23 C)
> [    8.989060] thermal LNXTHERM:05: registered as thermal_zone5
> [    8.994267] ACPI: Thermal Zone [TZ5] (23 C)
> [    8.998860] thermal LNXTHERM:06: registered as thermal_zone6
> [    9.004070] ACPI: Thermal Zone [TZ6] (22 C)
> [    9.008697] thermal LNXTHERM:07: registered as thermal_zone7
> [    9.013881] ACPI: Thermal Zone [TZ7] (22 C)
> [    9.018481] thermal LNXTHERM:08: registered as thermal_zone8
> [    9.023688] ACPI: Thermal Zone [TZ8] (22 C)
> [    9.028284] thermal LNXTHERM:09: registered as thermal_zone9
> [    9.033496] ACPI: Thermal Zone [TZ9] (22 C)
> [    9.038105] thermal LNXTHERM:0a: registered as thermal_zone10
> [    9.043392] ACPI: Thermal Zone [TZ10] (22 C)
> [    9.048081] thermal LNXTHERM:0d: registered as thermal_zone11
> [    9.053376] ACPI: Thermal Zone [TZ13] (23 C)
> [    9.058084] thermal LNXTHERM:0e: registered as thermal_zone12
> [    9.063363] ACPI: Thermal Zone [TZ14] (23 C)
> [    9.068045] thermal LNXTHERM:0f: registered as thermal_zone13
> [    9.073344] ACPI: Thermal Zone [TZ15] (24 C)
> [    9.078033] thermal LNXTHERM:10: registered as thermal_zone14
> [    9.083326] ACPI: Thermal Zone [TZ16] (22 C)
> [    9.088009] thermal LNXTHERM:11: registered as thermal_zone15
> [    9.093308] ACPI: Thermal Zone [TZ17] (22 C)
> [    9.097992] thermal LNXTHERM:12: registered as thermal_zone16
> [    9.103291] ACPI: Thermal Zone [TZ18] (23 C)
> [    9.107984] thermal LNXTHERM:13: registered as thermal_zone17
> [    9.113273] ACPI: Thermal Zone [TZ19] (24 C)
> [    9.117962] thermal LNXTHERM:14: registered as thermal_zone18
> [    9.123263] ACPI: Thermal Zone [TZ20] (24 C)
> [    9.127951] thermal LNXTHERM:15: registered as thermal_zone19
> [    9.133239] ACPI: Thermal Zone [TZ21] (23 C)
> [    9.137940] thermal LNXTHERM:16: registered as thermal_zone20
> [    9.143222] ACPI: Thermal Zone [TZ22] (23 C)
> [    9.147907] thermal LNXTHERM:17: registered as thermal_zone21
> [    9.153204] ACPI: Thermal Zone [TZ23] (24 C)
> [    9.157899] thermal LNXTHERM:18: registered as thermal_zone22
> [    9.163187] ACPI: Thermal Zone [TZ24] (23 C)
> [    9.167873] thermal LNXTHERM:19: registered as thermal_zone23
> [    9.173170] ACPI: Thermal Zone [TZ25] (23 C)
> [    9.177860] thermal LNXTHERM:1a: registered as thermal_zone24
> [    9.183153] ACPI: Thermal Zone [TZ26] (23 C)
> [    9.187849] thermal LNXTHERM:1b: registered as thermal_zone25
> [    9.193136] ACPI: Thermal Zone [TZ27] (23 C)
> [    9.197826] thermal LNXTHERM:1c: registered as thermal_zone26
> [    9.203118] ACPI: Thermal Zone [TZ28] (24 C)
> [    9.207805] thermal LNXTHERM:1d: registered as thermal_zone27
> [    9.213100] ACPI: Thermal Zone [TZ29] (23 C)
> [    9.217838] thermal LNXTHERM:1e: registered as thermal_zone28
> [    9.223086] ACPI: Thermal Zone [TZ30] (23 C)
> [    9.227767] thermal LNXTHERM:1f: registered as thermal_zone29
> [    9.233066] ACPI: Thermal Zone [TZ31] (23 C)
> [    9.237751] thermal LNXTHERM:20: registered as thermal_zone30
> [    9.243048] ACPI: Thermal Zone [TZ32] (23 C)
> [    9.247733] thermal LNXTHERM:21: registered as thermal_zone31
> [    9.253037] ACPI: Thermal Zone [TZ33] (23 C)
> [    9.257713] thermal LNXTHERM:22: registered as thermal_zone32
> [    9.263013] ACPI: Thermal Zone [TZ34] (23 C)
> [    9.267707] thermal LNXTHERM:23: registered as thermal_zone33
> [    9.272996] ACPI: Thermal Zone [TZ35] (23 C)
> [    9.277683] thermal LNXTHERM:24: registered as thermal_zone34
> [    9.282978] ACPI: Thermal Zone [TZ36] (24 C)
> [    9.287672] thermal LNXTHERM:25: registered as thermal_zone35
> [    9.292961] ACPI: Thermal Zone [TZ37] (24 C)
> [    9.297652] thermal LNXTHERM:26: registered as thermal_zone36
> [    9.302944] ACPI: Thermal Zone [TZ38] (23 C)
> [    9.307630] thermal LNXTHERM:27: registered as thermal_zone37
> [    9.312926] ACPI: Thermal Zone [TZ39] (24 C)
> [    9.317610] thermal LNXTHERM:28: registered as thermal_zone38
> [    9.322909] ACPI: Thermal Zone [TZ40] (23 C)
> [    9.327600] thermal LNXTHERM:29: registered as thermal_zone39
> [    9.332892] ACPI: Thermal Zone [TZ41] (23 C)
> [    9.337587] thermal LNXTHERM:2a: registered as thermal_zone40
> [    9.342874] ACPI: Thermal Zone [TZ42] (24 C)
> [    9.347564] thermal LNXTHERM:2b: registered as thermal_zone41
> [    9.352857] ACPI: Thermal Zone [TZ43] (24 C)
> [    9.357541] thermal LNXTHERM:2c: registered as thermal_zone42
> [    9.362840] ACPI: Thermal Zone [TZ44] (24 C)
> [    9.367529] thermal LNXTHERM:2d: registered as thermal_zone43
> [    9.372821] ACPI: Thermal Zone [TZ45] (24 C)
> [    9.377522] thermal LNXTHERM:2e: registered as thermal_zone44
> [    9.382812] ACPI: Thermal Zone [TZ46] (24 C)
> [    9.387504] thermal LNXTHERM:2f: registered as thermal_zone45
> [    9.392787] ACPI: Thermal Zone [TZ47] (24 C)
> [    9.397470] thermal LNXTHERM:30: registered as thermal_zone46
> [    9.402770] ACPI: Thermal Zone [TZ48] (25 C)
> [    9.407458] thermal LNXTHERM:31: registered as thermal_zone47
> [    9.412752] ACPI: Thermal Zone [TZ49] (30 C)
> [    9.417426] thermal LNXTHERM:32: registered as thermal_zone48
> [    9.422735] ACPI: Thermal Zone [TZ50] (19 C)
> [    9.427433] thermal LNXTHERM:33: registered as thermal_zone49
> [    9.432717] ACPI: Thermal Zone [TZ51] (26 C)
> [    9.437389] thermal LNXTHERM:34: registered as thermal_zone50
> [    9.442700] ACPI: Thermal Zone [TZ52] (26 C)
> [    9.447394] thermal LNXTHERM:35: registered as thermal_zone51
> [    9.452682] ACPI: Thermal Zone [TZ53] (24 C)
> [    9.457369] thermal LNXTHERM:36: registered as thermal_zone52
> [    9.462666] ACPI: Thermal Zone [TZ54] (24 C)
> [    9.467358] thermal LNXTHERM:37: registered as thermal_zone53
> [    9.472648] ACPI: Thermal Zone [TZ55] (24 C)
> [    9.477320] thermal LNXTHERM:38: registered as thermal_zone54
> [    9.482631] ACPI: Thermal Zone [TZ56] (23 C)
> [    9.487320] thermal LNXTHERM:39: registered as thermal_zone55
> [    9.492612] ACPI: Thermal Zone [TZ57] (24 C)
> [    9.497289] thermal LNXTHERM:3a: registered as thermal_zone56
> [    9.502596] ACPI: Thermal Zone [TZ58] (24 C)
> [    9.507637] ghes_edac: This EDAC driver relies on BIOS to enumerate memory and get error reports.
> [    9.515708] ghes_edac: Unfortunately, not all BIOSes reflect the memory layout correctly.
> [    9.523857] ghes_edac: So, the end result of using this driver varies from vendor to vendor.
> [    9.532277] ghes_edac: If you find incorrect reports, please contact your hardware vendor
> [    9.540437] ghes_edac: to correct its BIOS.
> [    9.544604] ghes_edac: This system has 6 DIMM sockets.
> [    9.550223] EDAC MC0: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    9.559377] EDAC MC1: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    9.568835] EDAC MC2: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    9.578299] EDAC MC3: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    9.587746] EDAC MC4: Giving out device to module ghes_edac.c controller ghes_edac: DEV ghes (INTERRUPT)
> [    9.597423] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
> [    9.604632] ACPI GTDT: found 1 SBSA generic Watchdog(s).
> [    9.614805] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [    9.629835] msm_serial: driver initialized
> [    9.634836] arm-smmu-v3 arm-smmu-v3.0.auto: option mask 0x0
> [    9.639547] arm-smmu-v3 arm-smmu-v3.0.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    9.647561] arm-smmu-v3 arm-smmu-v3.0.auto: msi_domain absent - falling back to wired irqs
> [    9.656370] arm-smmu-v3 arm-smmu-v3.1.auto: option mask 0x0
> [    9.661399] arm-smmu-v3 arm-smmu-v3.1.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    9.669435] arm-smmu-v3 arm-smmu-v3.1.auto: msi_domain absent - falling back to wired irqs
> [    9.678000] arm-smmu-v3 arm-smmu-v3.2.auto: option mask 0x0
> [    9.683259] arm-smmu-v3 arm-smmu-v3.2.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    9.691305] arm-smmu-v3 arm-smmu-v3.2.auto: msi_domain absent - falling back to wired irqs
> [    9.699835] arm-smmu-v3 arm-smmu-v3.3.auto: option mask 0x0
> [    9.705131] arm-smmu-v3 arm-smmu-v3.3.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    9.713181] arm-smmu-v3 arm-smmu-v3.3.auto: msi_domain absent - falling back to wired irqs
> [    9.721724] arm-smmu-v3 arm-smmu-v3.4.auto: option mask 0x0
> [    9.727004] arm-smmu-v3 arm-smmu-v3.4.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    9.735064] arm-smmu-v3 arm-smmu-v3.4.auto: msi_domain absent - falling back to wired irqs
> [    9.743713] arm-smmu-v3 arm-smmu-v3.5.auto: option mask 0x0
> [    9.748901] arm-smmu-v3 arm-smmu-v3.5.auto: ias 44-bit, oas 44-bit (features 0x00001fef)
> [    9.756932] arm-smmu-v3 arm-smmu-v3.5.auto: msi_domain absent - falling back to wired irqs
> [    9.767177] cacheinfo: Unable to detect cache hierarchy for CPU 0
> [    9.788676] loop: module loaded
> [    9.792431] mdio_bus fixed-0: GPIO lookup for consumer reset
> [    9.797156] mdio_bus fixed-0: using lookup tables for GPIO lookup
> [    9.803220] mdio_bus fixed-0: lookup for GPIO reset failed
> [    9.808710] libphy: Fixed MDIO Bus: probed
> [    9.812766] tun: Universal TUN/TAP device driver, 1.6
> [    9.819194] PPP generic driver version 2.4.2
> [    9.822914] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    9.829045] ehci-pci: EHCI PCI platform driver
> [    9.833495] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    9.839620] ohci-pci: OHCI PCI platform driver
> [    9.844076] uhci_hcd: USB Universal Host Controller Interface driver
> [    9.850813] mousedev: PS/2 mouse device common for all mice
> [    9.856995] rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc0
> [    9.862767] i2c /dev entries driver
> [    9.867405] device-mapper: uevent: version 1.0.3
> [    9.871504] device-mapper: ioctl: 4.37.0-ioctl (2017-09-20) initialised: dm-devel@redhat.com
> [    9.884553] ledtrig-cpu: registered to indicate activity on CPUs
> [    9.889901] EFI Variables Facility v0.08 2004-May-17
> [    9.899431] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 0
> [    9.905475] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 1
> [    9.912422] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 2
> [    9.919362] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 3
> [    9.926301] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 4
> [    9.933249] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 5
> [    9.940190] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 6
> [    9.947148] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 7
> [    9.954077] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 8
> [    9.961022] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 9
> [    9.967971] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 10
> [    9.974999] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 11
> [    9.982029] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 12
> [    9.989064] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 13
> [    9.996092] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 14
> [   10.003123] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 15
> [   10.010160] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 16
> [   10.017185] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 17
> [   10.024216] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 18
> [   10.031253] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 19
> [   10.038280] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 20
> [   10.045319] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 21
> [   10.052342] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 22
> [   10.059377] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU cluster 23
> [   10.066456] qcom-l2cache-pmu QCOM8130:00: CPU0 associated with cluster 0
> [   10.073202] qcom-l2cache-pmu QCOM8130:00: CPU1 associated with cluster 1
> [   10.079866] qcom-l2cache-pmu QCOM8130:00: CPU2 associated with cluster 2
> [   10.086570] qcom-l2cache-pmu QCOM8130:00: CPU3 associated with cluster 3
> [   10.093299] qcom-l2cache-pmu QCOM8130:00: CPU4 associated with cluster 4
> [   10.100003] qcom-l2cache-pmu QCOM8130:00: CPU5 associated with cluster 5
> [   10.106694] qcom-l2cache-pmu QCOM8130:00: CPU6 associated with cluster 7
> [   10.113345] qcom-l2cache-pmu QCOM8130:00: CPU7 associated with cluster 8
> [   10.120056] qcom-l2cache-pmu QCOM8130:00: CPU8 associated with cluster 9
> [   10.126756] qcom-l2cache-pmu QCOM8130:00: CPU9 associated with cluster 10
> [   10.133489] qcom-l2cache-pmu QCOM8130:00: CPU10 associated with cluster 11
> [   10.140331] qcom-l2cache-pmu QCOM8130:00: CPU11 associated with cluster 12
> [   10.147191] qcom-l2cache-pmu QCOM8130:00: CPU12 associated with cluster 13
> [   10.154046] qcom-l2cache-pmu QCOM8130:00: CPU13 associated with cluster 14
> [   10.160906] qcom-l2cache-pmu QCOM8130:00: CPU14 associated with cluster 15
> [   10.167793] qcom-l2cache-pmu QCOM8130:00: CPU15 associated with cluster 16
> [   10.174666] qcom-l2cache-pmu QCOM8130:00: CPU16 associated with cluster 17
> [   10.181526] qcom-l2cache-pmu QCOM8130:00: CPU17 associated with cluster 18
> [   10.188378] qcom-l2cache-pmu QCOM8130:00: CPU18 associated with cluster 19
> [   10.195199] qcom-l2cache-pmu QCOM8130:00: CPU19 associated with cluster 20
> [   10.201997] qcom-l2cache-pmu QCOM8130:00: CPU20 associated with cluster 21
> [   10.208960] qcom-l2cache-pmu QCOM8130:00: CPU21 associated with cluster 22
> [   10.215813] qcom-l2cache-pmu QCOM8130:00: CPU22 associated with cluster 23
> [   10.222649] qcom-l2cache-pmu QCOM8130:00: CPU23 associated with cluster 0
> [   10.229421] qcom-l2cache-pmu QCOM8130:00: CPU24 associated with cluster 1
> [   10.236133] qcom-l2cache-pmu QCOM8130:00: CPU25 associated with cluster 2
> [   10.242954] qcom-l2cache-pmu QCOM8130:00: CPU26 associated with cluster 3
> [   10.249675] qcom-l2cache-pmu QCOM8130:00: CPU27 associated with cluster 4
> [   10.256501] qcom-l2cache-pmu QCOM8130:00: CPU28 associated with cluster 6
> [   10.263296] qcom-l2cache-pmu QCOM8130:00: CPU29 associated with cluster 7
> [   10.269987] qcom-l2cache-pmu QCOM8130:00: CPU30 associated with cluster 8
> [   10.276814] qcom-l2cache-pmu QCOM8130:00: CPU31 associated with cluster 9
> [   10.283609] qcom-l2cache-pmu QCOM8130:00: CPU32 associated with cluster 10
> [   10.290391] qcom-l2cache-pmu QCOM8130:00: CPU33 associated with cluster 11
> [   10.297225] qcom-l2cache-pmu QCOM8130:00: CPU34 associated with cluster 12
> [   10.304083] qcom-l2cache-pmu QCOM8130:00: CPU35 associated with cluster 13
> [   10.310941] qcom-l2cache-pmu QCOM8130:00: CPU36 associated with cluster 14
> [   10.317800] qcom-l2cache-pmu QCOM8130:00: CPU37 associated with cluster 15
> [   10.324724] qcom-l2cache-pmu QCOM8130:00: CPU38 associated with cluster 16
> [   10.331611] qcom-l2cache-pmu QCOM8130:00: CPU39 associated with cluster 17
> [   10.338461] qcom-l2cache-pmu QCOM8130:00: CPU40 associated with cluster 18
> [   10.345314] qcom-l2cache-pmu QCOM8130:00: CPU41 associated with cluster 19
> [   10.352134] qcom-l2cache-pmu QCOM8130:00: CPU42 associated with cluster 20
> [   10.358998] qcom-l2cache-pmu QCOM8130:00: CPU43 associated with cluster 21
> [   10.365889] qcom-l2cache-pmu QCOM8130:00: CPU44 associated with cluster 22
> [   10.372743] qcom-l2cache-pmu QCOM8130:00: CPU45 associated with cluster 23
> [   10.379672] qcom-l2cache-pmu QCOM8130:00: Registered L2 cache PMU using 24 HW PMUs
> [   10.392535] qcom-l3cache-pmu QCOM8081:00: Registered l3cache_0_0, type: 9
> [   10.403095] qcom-l3cache-pmu QCOM8081:01: Registered l3cache_0_1, type: 10
> [   10.413648] qcom-l3cache-pmu QCOM8081:02: Registered l3cache_0_2, type: 11
> [   10.424228] qcom-l3cache-pmu QCOM8081:03: Registered l3cache_0_3, type: 12
> [   10.434802] qcom-l3cache-pmu QCOM8081:04: Registered l3cache_0_4, type: 13
> [   10.445331] qcom-l3cache-pmu QCOM8081:05: Registered l3cache_0_5, type: 14
> [   10.455867] qcom-l3cache-pmu QCOM8081:06: Registered l3cache_0_6, type: 15
> [   10.466408] qcom-l3cache-pmu QCOM8081:07: Registered l3cache_0_7, type: 16
> [   10.476960] qcom-l3cache-pmu QCOM8081:08: Registered l3cache_0_8, type: 17
> [   10.487826] qcom-l3cache-pmu QCOM8081:09: Registered l3cache_0_9, type: 18
> [   10.498449] qcom-l3cache-pmu QCOM8081:0a: Registered l3cache_0_10, type: 19
> [   10.509101] qcom-l3cache-pmu QCOM8081:0b: Registered l3cache_0_11, type: 20
> [   10.516378] NET: Registered protocol family 10
> [   10.546622] Segment Routing with IPv6
> [   10.549418] NET: Registered protocol family 17
> [   10.554083] Key type dns_resolver registered
> [   10.559421] registered taskstats version 1
> [   10.562588] Loading compiled-in X.509 certificates
> [   10.581112] Loaded X.509 cert 'Build time autogenerated kernel key: ea7718ec66a9224983a1a9a6eb5015ebf4889903'
> [   10.590300] zswap: loaded using pool lzo/zbud
> [   10.595082] Debug warning: early ioremap leak of 1 areas detected.
>                please boot with early_ioremap_debug and report the dmesg.
> [   10.607104] ------------[ cut here ]------------
> [   10.611695] WARNING: CPU: 19 PID: 1 at mm/early_ioremap.c:99 check_early_ioremap_leak+0x4c/0x60
> [   10.620364] Modules linked in:
> [   10.623407] CPU: 19 PID: 1 Comm: swapper/0 Not tainted 4.14.14 #1
> [   10.629480] Hardware name: Qualcomm Qualcomm Centriq(TM) 2400 Development Platform/ABW|SYS|CVR,1DPC|V3           , BIOS STB_XBL.DF.2.0_-64-1-G1CA82A3-DIRT
> [   10.643282] task: ffff80179811c000 task.stack: ffff801798118000
> [   10.649186] PC is at check_early_ioremap_leak+0x4c/0x60
> [   10.654394] LR is at check_early_ioremap_leak+0x4c/0x60
> [   10.659602] pc : [<ffff000008f29388>] lr : [<ffff000008f29388>] pstate: 60400005
> [   10.666979] sp : ffff80179811bda0
> [   10.670278] x29: ffff80179811bda0 x28: 0000000000000000
> [   10.675572] x27: ffff00000903fb90 x26: ffff0000095c4000
> [   10.680867] x25: ffff000008f00400 x24: ffff000008fc3070
> [   10.686163] x23: ffff000008ef0028 x22: 0000000000000000
> [   10.691458] x21: 0000000000000007 x20: ffff000008f2933c
> [   10.696753] x19: ffff000009439000 x18: ffffffffffffffff
> [   10.702048] x17: 0000000000000000 x16: 0000000000000000
> [   10.707343] x15: ffff000009439c08 x14: ffff0000895e50fd
> [   10.712638] x13: ffff0000095e510b x12: 2e64657463657465
> [   10.717934] x11: 0000000000000000 x10: 0000000005f5e0ff
> [   10.723229] x9 : 0000000000000090 x8 : ffff00000943a658
> [   10.728524] x7 : 6f70657220646e61 x6 : 00000000000003c1
> [   10.733819] x5 : ffff801798118000 x4 : 0000000000000000
> [   10.739114] x3 : 0000000000000000 x2 : 0d96b4630bc96f00
> [   10.744409] x1 : 0000000000000000 x0 : 0000000000000071
> [   10.749705] Call trace:
> [   10.752138] Exception stack(0xffff80179811bc60 to 0xffff80179811bda0)
> [   10.758563] bc60: 0000000000000071 0000000000000000 0d96b4630bc96f00 0000000000000000
> [   10.766374] bc80: 0000000000000000 ffff801798118000 00000000000003c1 6f70657220646e61
> [   10.774186] bca0: ffff00000943a658 0000000000000090 0000000005f5e0ff 0000000000000000
> [   10.781999] bcc0: 2e64657463657465 ffff0000095e510b ffff0000895e50fd ffff000009439c08
> [   10.789811] bce0: 0000000000000000 0000000000000000 ffffffffffffffff ffff000009439000
> [   10.797624] bd00: ffff000008f2933c 0000000000000007 0000000000000000 ffff000008ef0028
> [   10.805436] bd20: ffff000008fc3070 ffff000008f00400 ffff0000095c4000 ffff00000903fb90
> [   10.813249] bd40: 0000000000000000 ffff80179811bda0 ffff000008f29388 ffff80179811bda0
> [   10.821061] bd60: ffff000008f29388 0000000060400005 0000000000000038 0000000000000000
> [   10.828874] bd80: ffffffffffffffff 0000000000000000 ffff80179811bda0 ffff000008f29388
> [   10.836686] [<ffff000008f29388>] check_early_ioremap_leak+0x4c/0x60
> [   10.842940] [<ffff000008083ee4>] do_one_initcall+0x64/0x188
> [   10.848497] [<ffff000008f01020>] kernel_init_freeable+0x1a8/0x248
> [   10.854574] [<ffff000008ab8e88>] kernel_init+0x18/0x110
> [   10.859777] [<ffff000008085544>] ret_from_fork+0x10/0x1c
> [   10.865070] ---[ end trace 8c88f78bc5207e74 ]---
> [   10.884011] aes_arm64: module verification failed: signature and/or required key missing - tainting kernel
> [   10.912683] Key type big_key registered
> [   10.915609] Key type trusted registered
> [   10.933672] Key type encrypted registered
> [   10.936763] ima: No TPM chip found, activating TPM-bypass! (rc=-19)
> [   10.943074] evm: HMAC attrs: 0x1
> [   10.946760] iommu: Adding device 0001:00:00.0 to group 0
> [   10.952114] PCI Interrupt Link [LN1A] enabled at IRQ 92
> [   10.957033] pcieport 0001:00:00.0: Signaling PME with IRQ 134
> [   10.962544] pciehp 0001:00:00.0:pcie004: Slot #1 AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surprise- Interlock+ NoCompl- LLActRep+
> [   10.975280] iommu: Adding device 0002:00:00.0 to group 1
> [   10.980628] PCI Interrupt Link [LN2A] enabled at IRQ 96
> [   10.985555] pcieport 0002:00:00.0: Signaling PME with IRQ 136
> [   10.991100] pciehp 0002:00:00.0:pcie004: Slot #2 AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surprise- Interlock+ NoCompl- LLActRep+
> [   11.003806] iommu: Adding device 0003:00:00.0 to group 2
> [   11.009203] PCI Interrupt Link [LN3A] enabled at IRQ 100
> [   11.014188] pcieport 0003:00:00.0: Signaling PME with IRQ 138
> [   11.019740] pciehp 0003:00:00.0:pcie004: Slot #4 AttnBtn+ PwrCtrl+ MRL+ AttnInd+ PwrInd+ HotPlug+ Surprise- Interlock+ NoCompl- LLActRep+
> [   11.032650] rtc-efi rtc-efi: setting system clock to 2018-03-01 17:51:25 UTC (1519926685)
> [   11.043771] Freeing unused kernel memory: 5312K
> [   11.049342] Checked W+X mappings: passed, no W+X pages found
> [   11.514530] gpio gpiochip0: (QCOM8002:00): added GPIO chardev (254:0)
> [   11.515377] sdhci: Secure Digital Host Controller Interface driver
> [   11.515378] sdhci: Copyright(c) Pierre Ossman
> [   11.530539] gpiochip_setup_dev: registered GPIOs 0 to 149 on device: gpiochip0 (QCOM8002:00)
> [   11.536470] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> [   11.545621] gpio gpiochip0: (QCOM8002:00): created GPIO range 0->149 ==> QCOM8002:00 PIN 0->149
> [   11.554448] i2c_qup QCOM8010:00:
>                 tx channel not available
> [   11.554462] pps_core: LinuxPPS API ver. 1 registered
> [   11.554463] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [   11.555201] PTP clock support registered
> [   11.558782] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
> [   11.558782] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [   11.558821] pcieport 0002:00:00.0: Using QCOM ACS Quirk (1)
> [   11.558856] iommu: Adding device 0002:01:00.0 to group 3
> [   11.559156] e1000e 0002:01:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [   11.559158] e1000e 0002:01:00.0: Interrupt Mode set to 1
> [   11.565806] pcieport 0003:00:00.0: Using QCOM ACS Quirk (1)
> [   11.565825] iommu: Adding device 0003:01:00.0 to group 4
> [   11.566120] mlx5_core 0003:01:00.0: firmware version: 14.14.1100
> [   11.642925] i2c_qup QCOM8010:01:
>                 tx channel not available
> [   11.659031] hidma-mgmt QCOM8060:00: HW rev: 1.1 @ 0x000000ff98000000 with 6 physical channels
> [   11.666681] hidma-mgmt QCOM8060:01: HW rev: 1.1 @ 0x000000ff9a000000 with 6 physical channels
> [   11.675898] mdio_bus QCOM8070:00: GPIO lookup for consumer reset
> [   11.677104] ipmi message handler version 39.2
> [   11.677687] ipmi device interface
> [   11.679109] IPMI System Interface driver.
> [   11.679126] ipmi_si: probing via SPMI
> [   11.679157] ipmi_si: Unable to find any System Interface(s)
> [   11.701924] mdio_bus QCOM8070:00: using lookup tables for GPIO lookup
> [   11.708348] mdio_bus QCOM8070:00: lookup for GPIO reset failed
> [   11.716599] IPMI SSIF Interface driver
> [   11.717364] libphy: emac-mdio: probed
> [   11.717682] qcom-emac QCOM8070:00 eth0: hardware id 64.1, hardware version 1.3.0
> [   11.717809] ahci QCOM8090:00: SSS flag set, parallel bus scan disabled
> [   11.717820] ahci QCOM8090:00: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [   11.717822] ahci QCOM8090:00: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [   11.718112] scsi host0: ahci
> [   11.718173] ata1: SATA max UDMA/133 mmio [mem 0xff88000000-0xff880001ff] port 0x100 irq 28
> [   11.718252] ahci QCOM8090:01: SSS flag set, parallel bus scan disabled
> [   11.718260] ahci QCOM8090:01: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [   11.718262] ahci QCOM8090:01: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [   11.718530] scsi host1: ahci
> [   11.718593] ata2: SATA max UDMA/133 mmio [mem 0xff89000000-0xff890001ff] port 0x100 irq 29
> [   11.718686] xhci-hcd QCOM8041:00: xHCI Host Controller
> [   11.718693] xhci-hcd QCOM8041:00: new USB bus registered, assigned bus number 1
> [   11.718839] xhci-hcd QCOM8041:00: hcc params 0x0220f665 hci version 0x100 quirks 0x00010010
> [   11.718853] xhci-hcd QCOM8041:00: irq 115, io mem 0xff79800000
> [   11.718904] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [   11.718905] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   11.718907] usb usb1: Product: xHCI Host Controller
> [   11.718908] usb usb1: Manufacturer: Linux 4.14.14 xhci-hcd
> [   11.718909] usb usb1: SerialNumber: QCOM8041:00
> [   11.719053] hub 1-0:1.0: USB hub found
> [   11.719061] hub 1-0:1.0: 1 port detected
> [   11.719160] xhci-hcd QCOM8041:00: xHCI Host Controller
> [   11.719163] xhci-hcd QCOM8041:00: new USB bus registered, assigned bus number 2
> [   11.719182] usb usb2: We don't know the algorithms for LPM for this host, disabling LPM.
> [   11.719205] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
> [   11.719206] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   11.719207] usb usb2: Product: xHCI Host Controller
> [   11.719208] usb usb2: Manufacturer: Linux 4.14.14 xhci-hcd
> [   11.719209] usb usb2: SerialNumber: QCOM8041:00
> [   11.719343] hub 2-0:1.0: USB hub found
> [   11.719352] hub 2-0:1.0: config failed, hub doesn't have any ports! (err -19)
> [   11.719462] xhci-hcd QCOM8041:01: xHCI Host Controller
> [   11.719466] xhci-hcd QCOM8041:01: new USB bus registered, assigned bus number 3
> [   11.719606] xhci-hcd QCOM8041:01: hcc params 0x0220f665 hci version 0x100 quirks 0x00010010
> [   11.719618] xhci-hcd QCOM8041:01: irq 116, io mem 0xff79a00000
> [   11.719659] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [   11.719661] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   11.719662] usb usb3: Product: xHCI Host Controller
> [   11.719663] usb usb3: Manufacturer: Linux 4.14.14 xhci-hcd
> [   11.719664] usb usb3: SerialNumber: QCOM8041:01
> [   11.719801] hub 3-0:1.0: USB hub found
> [   11.719808] hub 3-0:1.0: 1 port detected
> [   11.719887] xhci-hcd QCOM8041:01: xHCI Host Controller
> [   11.719890] xhci-hcd QCOM8041:01: new USB bus registered, assigned bus number 4
> [   11.719907] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
> [   11.719929] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [   11.719931] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   11.719932] usb usb4: Product: xHCI Host Controller
> [   11.719933] usb usb4: Manufacturer: Linux 4.14.14 xhci-hcd
> [   11.719934] usb usb4: SerialNumber: QCOM8041:01
> [   11.720046] hub 4-0:1.0: USB hub found
> [   11.720052] hub 4-0:1.0: config failed, hub doesn't have any ports! (err -19)
> [   11.720606] mmc0: SDHCI controller on ACPI [QCOM8051:00] using PIO
> [   11.720985] hidma QCOM8062:00: HI-DMA engine driver registration complete
> [   11.721292] hidma QCOM8062:01: HI-DMA engine driver registration complete
> [   11.721393] hidma-mgmt QCOM8060:02: HW rev: 1.1 @ 0x000000ff9c000000 with 6 physical channels
> [   11.721473] hidma-mgmt QCOM8060:03: HW rev: 1.1 @ 0x000000ff9e000000 with 6 physical channels
> [   11.721665] ahci QCOM8090:02: SSS flag set, parallel bus scan disabled
> [   11.721674] ahci QCOM8090:02: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [   11.721676] ahci QCOM8090:02: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [   11.721947] scsi host2: ahci
> [   11.722003] ata3: SATA max UDMA/133 mmio [mem 0xff8a000000-0xff8a0001ff] port 0x100 irq 30
> [   11.722103] ahci QCOM8090:03: SSS flag set, parallel bus scan disabled
> [   11.722111] ahci QCOM8090:03: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [   11.722113] ahci QCOM8090:03: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [   11.722358] scsi host3: ahci
> [   11.722423] ata4: SATA max UDMA/133 mmio [mem 0xff8b000000-0xff8b0001ff] port 0x100 irq 31
> [   11.722513] xhci-hcd QCOM8041:02: xHCI Host Controller
> [   11.722518] xhci-hcd QCOM8041:02: new USB bus registered, assigned bus number 5
> [   11.722660] xhci-hcd QCOM8041:02: hcc params 0x0220f665 hci version 0x100 quirks 0x00010010
> [   11.722672] xhci-hcd QCOM8041:02: irq 117, io mem 0xff79c00000
> [   11.722714] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
> [   11.722716] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   11.722717] usb usb5: Product: xHCI Host Controller
> [   11.722718] usb usb5: Manufacturer: Linux 4.14.14 xhci-hcd
> [   11.722719] usb usb5: SerialNumber: QCOM8041:02
> [   11.722865] hub 5-0:1.0: USB hub found
> [   11.722873] hub 5-0:1.0: 1 port detected
> [   11.722957] xhci-hcd QCOM8041:02: xHCI Host Controller
> [   11.722960] xhci-hcd QCOM8041:02: new USB bus registered, assigned bus number 6
> [   11.722976] usb usb6: We don't know the algorithms for LPM for this host, disabling LPM.
> [   11.722998] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
> [   11.723000] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   11.723001] usb usb6: Product: xHCI Host Controller
> [   11.723002] usb usb6: Manufacturer: Linux 4.14.14 xhci-hcd
> [   11.723003] usb usb6: SerialNumber: QCOM8041:02
> [   11.723117] hub 6-0:1.0: USB hub found
> [   11.723123] hub 6-0:1.0: config failed, hub doesn't have any ports! (err -19)
> [   11.723241] xhci-hcd QCOM8041:03: xHCI Host Controller
> [   11.723245] xhci-hcd QCOM8041:03: new USB bus registered, assigned bus number 7
> [   11.723386] xhci-hcd QCOM8041:03: hcc params 0x0220f665 hci version 0x100 quirks 0x00010010
> [   11.723398] xhci-hcd QCOM8041:03: irq 118, io mem 0xff79e00000
> [   11.723437] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
> [   11.723438] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   11.723439] usb usb7: Product: xHCI Host Controller
> [   11.723440] usb usb7: Manufacturer: Linux 4.14.14 xhci-hcd
> [   11.723441] usb usb7: SerialNumber: QCOM8041:03
> [   11.723576] hub 7-0:1.0: USB hub found
> [   11.723584] hub 7-0:1.0: 1 port detected
> [   11.723665] xhci-hcd QCOM8041:03: xHCI Host Controller
> [   11.723668] xhci-hcd QCOM8041:03: new USB bus registered, assigned bus number 8
> [   11.723684] usb usb8: We don't know the algorithms for LPM for this host, disabling LPM.
> [   11.723706] usb usb8: New USB device found, idVendor=1d6b, idProduct=0003
> [   11.723707] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   11.723708] usb usb8: Product: xHCI Host Controller
> [   11.723709] usb usb8: Manufacturer: Linux 4.14.14 xhci-hcd
> [   11.723710] usb usb8: SerialNumber: QCOM8041:03
> [   11.723842] hub 8-0:1.0: USB hub found
> [   11.723849] hub 8-0:1.0: config failed, hub doesn't have any ports! (err -19)
> [   11.724320] hidma QCOM8062:02: HI-DMA engine driver registration complete
> [   11.725194] hidma QCOM8062:03: HI-DMA engine driver registration complete
> [   11.725302] ahci QCOM8090:04: SSS flag set, parallel bus scan disabled
> [   11.725311] ahci QCOM8090:04: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [   11.725313] ahci QCOM8090:04: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [   11.725837] scsi host4: ahci
> [   11.725984] ata5: SATA max UDMA/133 mmio [mem 0xff8c000000-0xff8c0001ff] port 0x100 irq 32
> [   11.726068] ahci QCOM8090:05: SSS flag set, parallel bus scan disabled
> [   11.726076] ahci QCOM8090:05: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [   11.726078] ahci QCOM8090:05: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [   11.726364] scsi host5: ahci
> [   11.726431] ata6: SATA max UDMA/133 mmio [mem 0xff8d000000-0xff8d0001ff] port 0x100 irq 33
> [   11.726755] hidma QCOM8062:04: HI-DMA engine driver registration complete
> [   11.727038] hidma QCOM8062:05: HI-DMA engine driver registration complete
> [   11.727170] ahci QCOM8090:06: SSS flag set, parallel bus scan disabled
> [   11.727179] ahci QCOM8090:06: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [   11.727181] ahci QCOM8090:06: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [   11.727458] scsi host6: ahci
> [   11.727520] ata7: SATA max UDMA/133 mmio [mem 0xff8e000000-0xff8e0001ff] port 0x100 irq 34
> [   11.727602] ahci QCOM8090:07: SSS flag set, parallel bus scan disabled
> [   11.727610] ahci QCOM8090:07: AHCI 0001.0301 32 slots 1 ports 6 Gbps 0x1 impl platform mode
> [   11.727612] ahci QCOM8090:07: flags: 64bit ncq sntf stag pm led clo only pmp pio slum part ccc sadm sds apst
> [   11.727838] scsi host7: ahci
> [   11.727892] ata8: SATA max UDMA/133 mmio [mem 0xff8f000000-0xff8f0001ff] port 0x100 irq 35
> [   11.728217] hidma QCOM8062:06: HI-DMA engine driver registration complete
> [   11.728520] hidma QCOM8062:07: HI-DMA engine driver registration complete
> [   11.728801] hidma QCOM8062:08: HI-DMA engine driver registration complete
> [   11.729077] hidma QCOM8062:09: HI-DMA engine driver registration complete
> [   11.729356] hidma QCOM8062:0a: HI-DMA engine driver registration complete
> [   11.729634] hidma QCOM8062:0b: HI-DMA engine driver registration complete
> [   11.729918] hidma QCOM8062:0c: HI-DMA engine driver registration complete
> [   11.730203] hidma QCOM8062:0d: HI-DMA engine driver registration complete
> [   11.730489] hidma QCOM8062:0e: HI-DMA engine driver registration complete
> [   11.730777] hidma QCOM8062:0f: HI-DMA engine driver registration complete
> [   11.731063] hidma QCOM8062:10: HI-DMA engine driver registration complete
> [   11.731371] hidma QCOM8062:11: HI-DMA engine driver registration complete
> [   11.731791] hidma QCOM8062:12: HI-DMA engine driver registration complete
> [   11.732197] hidma QCOM8062:13: HI-DMA engine driver registration complete
> [   11.732608] hidma QCOM8062:14: HI-DMA engine driver registration complete
> [   11.733025] hidma QCOM8062:15: HI-DMA engine driver registration complete
> [   11.733438] hidma QCOM8062:16: HI-DMA engine driver registration complete
> [   11.733851] hidma QCOM8062:17: HI-DMA engine driver registration complete
> [   11.739653] e1000e 0002:01:00.0 eth1: (PCI Express:2.5GT/s:Width x4) 00:1b:21:bd:07:f0
> [   11.739654] e1000e 0002:01:00.0 eth1: Intel(R) PRO/1000 Network Connection
> [   11.739736] e1000e 0002:01:00.0 eth1: MAC: 0, PHY: 4, PBA No: D50868-006
> [   11.739776] pcieport 0002:00:00.0: Using QCOM ACS Quirk (1)
> [   11.739798] iommu: Adding device 0002:01:00.1 to group 5
> [   11.739966] PCI Interrupt Link [LN2B] enabled at IRQ 97
> [   11.740050] e1000e 0002:01:00.1: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
> [   11.824862] mmc0: new high speed SDHC card at address aaaa
> [   11.825125] mmcblk0: mmc0:aaaa SE32G 29.7 GiB
> [   11.826156]  mmcblk0: p1
> [   11.915638] e1000e 0002:01:00.1 eth2: (PCI Express:2.5GT/s:Width x4) 00:1b:21:bd:07:f1
> [   11.915639] e1000e 0002:01:00.1 eth2: Intel(R) PRO/1000 Network Connection
> [   11.915721] e1000e 0002:01:00.1 eth2: MAC: 0, PHY: 4, PBA No: D50868-006
> [   12.032779] ata3: SATA link down (SStatus 0 SControl 300)
> [   12.041859] ata5: SATA link down (SStatus 0 SControl 300)
> [   12.041862] ata7: SATA link down (SStatus 0 SControl 300)
> [   12.041865] ata6: SATA link down (SStatus 0 SControl 300)
> [   12.041884] ata4: SATA link down (SStatus 0 SControl 300)
> [   12.042121] ata8: SATA link down (SStatus 0 SControl 300)
> [   12.071207] usb 7-1: new high-speed USB device number 2 using xhci-hcd
> [   12.071212] usb 5-1: new high-speed USB device number 2 using xhci-hcd
> [   12.155288] (0003:01:00.0): E-Switch: Total vports 9, per vport: max uc(1024) max mc(16384)
> [   12.171704] mlx5_core 0003:01:00.0: Port module event: module 0, Cable plugged
> [   12.184103] mlx5_core 0003:01:00.0: MLX5E: StrdRq(1) RqSz(8) StrdSz(128) RxCqeCmprss(0)
> [   12.195213] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   12.195216] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   12.195380] ata1.00: ATA-9: Samsung SSD 845DC EVO 240GB, EXT03X3Q, max UDMA/133
> [   12.195381] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [   12.195549] ata1.00: configured for UDMA/133
> [   12.195566] ata2.00: ATA-9: MICRON_M510DC_MTFDDAK240MBP, 0013, max UDMA/133
> [   12.195567] ata2.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [   12.195745] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 845D 3X3Q PQ: 0 ANSI: 5
> [   12.195953] ata1.00: Enabling discard_zeroes_data
> [   12.195995] sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/224 GiB)
> [   12.196003] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [   12.196005] sd 0:0:0:0: [sda] Write Protect is off
> [   12.196007] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   12.196019] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   12.196148] ata1.00: Enabling discard_zeroes_data
> [   12.197568]  sda: sda1 sda2
> [   12.197849] ata1.00: Enabling discard_zeroes_data
> [   12.197925] sd 0:0:0:0: [sda] Attached SCSI disk
> [   12.207518] ata2.00: configured for UDMA/133
> [   12.207683] scsi 1:0:0:0: Direct-Access     ATA      MICRON_M510DC_MT 0013 PQ: 0 ANSI: 5
> [   12.207916] sd 1:0:0:0: [sdb] 468862128 512-byte logical blocks: (240 GB/224 GiB)
> [   12.207918] sd 1:0:0:0: [sdb] 4096-byte physical blocks
> [   12.207925] sd 1:0:0:0: [sdb] Write Protect is off
> [   12.207927] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [   12.207933] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [   12.207939] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   12.209283]  sdb: sdb1 sdb2
> [   12.209600] sd 1:0:0:0: [sdb] Attached SCSI disk
> [   12.219353] usb 5-1: New USB device found, idVendor=0424, idProduct=2514
> [   12.219355] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [   12.219794] usb 7-1: New USB device found, idVendor=0624, idProduct=0249
> [   12.219796] usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   12.219798] usb 7-1: Product: USB Composite Device-1
> [   12.219799] usb 7-1: Manufacturer: Avocent
> [   12.219800] usb 7-1: SerialNumber: 20120430-1
> [   12.235079] hub 5-1:1.0: USB hub found
> [   12.235206] hub 5-1:1.0: 4 ports detected
> [   12.236952] usb-storage 7-1:1.0: USB Mass Storage device detected
> [   12.237228] scsi host8: usb-storage 7-1:1.0
> [   12.237310] usbcore: registered new interface driver usb-storage
> [   12.237870] usbcore: registered new interface driver uas
> [   12.295366] mlx5_ib: Mellanox Connect-IB Infiniband driver v5.0-0
> [   12.563149] usb 5-1.1: new full-speed USB device number 3 using xhci-hcd
> [   12.664078] usb 5-1.1: New USB device found, idVendor=0624, idProduct=0248
> [   12.664080] usb 5-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   12.664081] usb 5-1.1: Product: USB Composite Device-0
> [   12.664082] usb 5-1.1: Manufacturer: Avocent
> [   12.664083] usb 5-1.1: SerialNumber: 20120430
> [   12.752365] hidraw: raw HID events driver (C) Jiri Kosina
> [   12.846728] usbcore: registered new interface driver usbhid
> [   12.846729] usbhid: USB HID core driver
> [   12.847736] input: Avocent USB Composite Device-0 as /devices/platform/QCOM8041:02/usb5/5-1/5-1.1/5-1.1:1.0/0003:0624:0248.0001/input/input0
> [   12.911460] hid-generic 0003:0624:0248.0001: input,hidraw0: USB HID v1.00 Keyboard [Avocent USB Composite Device-0] on usb-QCOM8041:02-1.1/input0
> [   12.911558] input: Avocent USB Composite Device-0 as /devices/platform/QCOM8041:02/usb5/5-1/5-1.1/5-1.1:1.1/0003:0624:0248.0002/input/input1
> [   12.911788] hid-generic 0003:0624:0248.0002: input,hidraw1: USB HID v1.00 Mouse [Avocent USB Composite Device-0] on usb-QCOM8041:02-1.1/input1
> [   12.911883] input: Avocent USB Composite Device-0 as /devices/platform/QCOM8041:02/usb5/5-1/5-1.1/5-1.1:1.2/0003:0624:0248.0003/input/input2
> [   12.912026] hid-generic 0003:0624:0248.0003: input,hidraw2: USB HID v1.00 Mouse [Avocent USB Composite Device-0] on usb-QCOM8041:02-1.1/input2
> [   12.990663] usb 5-1.2: new full-speed USB device number 4 using xhci-hcd
> [   13.201717] usb 5-1.2: New USB device found, idVendor=05c6, idProduct=9302
> [   13.201719] usb 5-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=128
> [   13.201721] usb 5-1.2: Product: Embedded Power Measurement (EPM) device
> [   13.201722] usb 5-1.2: Manufacturer: QUALCOMM Inc.
> [   13.201723] usb 5-1.2: SerialNumber: 070E0AF902165400
> [   13.230009] cdc_acm 5-1.2:1.1: ttyACM0: USB ACM device
> [   13.230307] usbcore: registered new interface driver cdc_acm
> [   13.230308] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
> [   13.255745] scsi 8:0:0:0: CD-ROM            MP EMS   Virtual Media    0399 PQ: 0 ANSI: 0
> [   13.256032] scsi 8:0:0:1: Direct-Access     MP EMS   Virtual Media    0399 PQ: 0 ANSI: 0 CCS
> [   13.256298] scsi 8:0:0:2: Direct-Access     MP EMS   Virtual Media    0399 PQ: 0 ANSI: 0 CCS
> [   13.257350] sr 8:0:0:0: [sr0] scsi3-mmc drive: 0x/0x cd/rw caddy
> [   13.257352] cdrom: Uniform CD-ROM driver Revision: 3.20
> [   13.257532] sr 8:0:0:0: Attached scsi CD-ROM sr0
> [   13.257622] sr 8:0:0:0: Attached scsi generic sg2 type 5
> [   13.257883] sd 8:0:0:1: Attached scsi generic sg3 type 0
> [   13.258102] sd 8:0:0:2: Attached scsi generic sg4 type 0
> [   13.321941] acpi IPI0001:00: GPIO: looking up 0 in _CRS
> [   13.327009] ipmi_ssif: Trying ACPI-specified SSIF interface at i2c address 0x42, adapter QUP I2C adapter, slave address 0x0
> [   13.361582] sd 8:0:0:1: [sdc] Attached SCSI removable disk
> [   13.362473] sd 8:0:0:2: [sdd] Attached SCSI removable disk
> [   13.506021] ipmi_ssif i2c-IPI0001:00: Found new BMC (man_id: 0x0005a9, prod_id: 0x0001, dev_id: 0x20)
> [   14.691160] raid6: int64x1  gen()  2372 MB/s
> [   14.759138] raid6: int64x1  xor()  1780 MB/s
> [   14.827144] raid6: int64x2  gen()  2947 MB/s
> [   14.895143] raid6: int64x2  xor()  2335 MB/s
> [   14.963141] raid6: int64x4  gen()  3501 MB/s
> [   15.031146] raid6: int64x4  xor()  2538 MB/s
> [   15.099139] raid6: int64x8  gen()  4171 MB/s
> [   15.167137] raid6: int64x8  xor()  2595 MB/s
> [   15.235141] raid6: neonx1   gen()  2833 MB/s
> [   15.303138] raid6: neonx1   xor()  3895 MB/s
> [   15.371143] raid6: neonx2   gen()  4033 MB/s
> [   15.439141] raid6: neonx2   xor()  4237 MB/s
> [   15.507143] raid6: neonx4   gen()  4847 MB/s
> [   15.575135] raid6: neonx4   xor()  4504 MB/s
> [   15.643145] raid6: neonx8   gen()  5038 MB/s
> [   15.711140] raid6: neonx8   xor()  4435 MB/s
> [   15.714444] raid6: using algorithm neonx8 gen() 5038 MB/s
> [   15.719830] raid6: .... xor() 4435 MB/s, rmw enabled
> [   15.724778] raid6: using neon recovery algorithm
> [   15.729888] async_tx: api initialized (async)
> [   15.734063] xor: measuring software checksum speed
> [   15.775135]    8regs     : 10595.000 MB/sec
> [   15.815135]    8regs_prefetch: 10011.000 MB/sec
> [   15.855135]    32regs    : 14522.000 MB/sec
> [   15.895134]    32regs_prefetch: 13447.000 MB/sec
> [   15.898786] xor: using function: 32regs (14522.000 MB/sec)
> [   15.956416] Btrfs loaded, crc32c=crc32c-arm64-ce
> [   16.066745] random: crng init done
> [   16.227476] IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
> [   16.323252] Atheros 8031 ethernet QCOM8070:00:04: attached PHY driver [Atheros 8031 ethernet] (mii_bus:phy_addr=QCOM8070:00:04, irq=POLL)
> [   16.334691] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   16.621062] mlx5_core 0003:01:00.0 eth3: Link down
> [   16.625465] IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
> [   16.907450] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
> [   17.344292] qcom-emac QCOM8070:00 eth0: Link is Down
> [   18.984051] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
> [   18.990818] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> [   19.391292] qcom-emac QCOM8070:00 eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> [   19.398084] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   21.361731] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
> [   21.552169] e1000e: eth1 NIC Link is Down
> [   21.728248] e1000e: eth2 NIC Link is Down
> [   22.124737] systemd[1]: systemd 229 running in system mode. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN)
> [   22.142131] systemd[1]: Detected architecture arm64.
> [   22.159422] systemd[1]: Set hostname to <ubuntu>.
> [   22.240694] systemd[1]: Listening on Journal Socket (/dev/log).
> [   22.255277] systemd[1]: Listening on LVM2 metadata daemon socket.
> [   22.271317] systemd[1]: Listening on Journal Socket.
> [   22.291285] systemd[1]: Listening on udev Kernel Socket.
> [   22.307233] systemd[1]: Reached target Swap.
> [   22.319325] systemd[1]: Listening on Journal Audit Socket.
> [   22.335242] systemd[1]: Reached target User and Group Name Lookups.
> [   22.425554] Loading iSCSI transport class v2.0-870.
> [   22.458972] iscsi: registered transport (tcp)
> [   22.509189] iscsi: registered transport (iser)
> [   22.591259] RPC: Registered named UNIX socket transport module.
> [   22.596686] RPC: Registered udp transport module.
> [   22.601369] RPC: Registered tcp transport module.
> [   22.606056] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   23.742603] systemd-journald[953]: Received request to flush runtime journal from PID 1
> [   23.865516] IPMI System Interface driver.
> [   23.865573] ipmi_si: probing via SPMI
> [   23.865640] ipmi_si: Unable to find any System Interface(s)
> [   24.006070] IPMI System Interface driver.
> [   24.006209] ipmi_si: probing via SPMI
> [   24.006417] ipmi_si: Unable to find any System Interface(s)
> [   24.668518] new mount options do not match the existing superblock, will be ignored
> [   24.710470] new mount options do not match the existing superblock, will be ignored
> [   27.302611] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   27.717007] ip6_tables: (C) 2000-2006 Netfilter Core Team
> [   28.143437] Ebtables v2.0 registered
> [   29.173231] bridge: filtering via arp/ip/ip6tables is no longer available by default. Update your scripts to load br_netfilter if you need this.
> [   29.251271] virbr0: port 1(virbr0-nic) entered blocking state
> [   29.251273] virbr0: port 1(virbr0-nic) entered disabled state
> [   29.251351] device virbr0-nic entered promiscuous mode
> [   32.738476] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
> [   35.105821] virbr0: port 1(virbr0-nic) entered blocking state
> [   35.105824] virbr0: port 1(virbr0-nic) entered listening state
> [   36.618432] virbr0: port 1(virbr0-nic) entered disabled state

> ubuntu:/home/ubuntu# kexec -l -d --reuse-cmd --initrd=/boot/initrd.img /boot/vmlinux
> arch_process_options:148: command_line: \EFI\BOOT\Image user_debug=31 loglevel=9 uefi_debug e1000e.IntMode=1 pci=pcie_bus_safe pcie_aspm.policy=default cpuidle.off=0 rootwait rw root=PARTUUID=76ec3f97-3414-4896-a317-340ffa63adc6 rootfstype=ext4 initrd=initramfs.img earlycon=pl011,mmio32,0xff78ed1000 "" "" "" "" "" "" "" ""
> arch_process_options:150: initrd: /boot/initrd.img
> arch_process_options:151: dtb: (null)
> Try gzip decompression.
> kernel: 0xffffab2c9010 kernel_size: 0xda078d8
> get_memory_ranges_iomem_cb: 0000000000200000 - 000000000021ffff : reserved
> get_memory_ranges_iomem_cb: 0000000000820000 - 000000000307ffff : System RAM
> get_memory_ranges_iomem_cb: 0000000003080000 - 000000000308ffff : reserved
> get_memory_ranges_iomem_cb: 0000000003090000 - 00000000031fffff : System RAM
> get_memory_ranges_iomem_cb: 0000000003200000 - 00000000033fffff : reserved
> get_memory_ranges_iomem_cb: 0000000003410000 - 0000000004c0ffff : System RAM
> get_memory_ranges_iomem_cb: 0000000004c10000 - 0000000004c2ffff : reserved
> get_memory_ranges_iomem_cb: 0000000004c30000 - 0000000004c3dfff : System RAM
> get_memory_ranges_iomem_cb: 0000000004c3e000 - 0000000004c41fff : reserved
> get_memory_ranges_iomem_cb: 0000000004c42000 - 0000000004c4cfff : System RAM
> get_memory_ranges_iomem_cb: 0000000004c4d000 - 0000000007c61fff : reserved
> get_memory_ranges_iomem_cb: 0000000007c62000 - 0000000007d6ffff : System RAM
> get_memory_ranges_iomem_cb: 0000000007d70000 - 0000000007eeffff : reserved
> get_memory_ranges_iomem_cb: 0000000007ef0000 - 0000000007f0ffff : System RAM
> get_memory_ranges_iomem_cb: 0000000007f10000 - 0000000007faffff : reserved
> get_memory_ranges_iomem_cb: 0000000007fb0000 - 0000000008310fff : System RAM
> get_memory_ranges_iomem_cb: 0000000008311000 - 0000000008316fff : reserved
> get_memory_ranges_iomem_cb: 0000000008317000 - 00000000083c0fff : System RAM
> get_memory_ranges_iomem_cb: 00000000083c1000 - 00000000083c6fff : reserved
> get_memory_ranges_iomem_cb: 00000000083c7000 - 00000000083effff : System RAM
> get_memory_ranges_iomem_cb: 00000000083f0000 - 00000000085dffff : reserved
> get_memory_ranges_iomem_cb: 00000000085e0000 - 00000000085e0fff : System RAM
> get_memory_ranges_iomem_cb: 00000000085e1000 - 00000000085e3fff : reserved
> get_memory_ranges_iomem_cb: 00000000085e4000 - 00000000085fffff : System RAM
> get_memory_ranges_iomem_cb: 0000000008600000 - 000000000860ffff : reserved
> get_memory_ranges_iomem_cb: 0000000008610000 - 000000000863ffff : System RAM
> get_memory_ranges_iomem_cb: 0000000008640000 - 00000000087affff : reserved
> get_memory_ranges_iomem_cb: 00000000087b0000 - 0000000008940fff : System RAM
> get_memory_ranges_iomem_cb: 0000000008941000 - 0000000008943fff : reserved
> get_memory_ranges_iomem_cb: 0000000008944000 - 000000000896ffff : System RAM
> get_memory_ranges_iomem_cb: 0000000008970000 - 0000000008a0ffff : reserved
> get_memory_ranges_iomem_cb: 0000000008a10000 - 0000000008a7ffff : System RAM
> get_memory_ranges_iomem_cb: 0000000008a80000 - 0000000008bbffff : reserved
> get_memory_ranges_iomem_cb: 0000000008bc0000 - 0000000008bdffff : System RAM
> get_memory_ranges_iomem_cb: 0000000008be0000 - 0000000008f02fff : reserved
> get_memory_ranges_iomem_cb: 0000000008f03000 - 000000000deeffff : System RAM
> get_memory_ranges_iomem_cb: 000000000def0000 - 000000000df1ffff : reserved
> get_memory_ranges_iomem_cb: 000000000df20000 - 000000000fffffff : System RAM
> get_memory_ranges_iomem_cb: 0000000010800000 - 0000000017feffff : System RAM
> get_memory_ranges_iomem_cb: 000000001c000000 - 000000001c00ffff : reserved
> get_memory_ranges_iomem_cb: 000000001c010000 - 000000001c7fffff : System RAM
> get_memory_ranges_iomem_cb: 000000001c810000 - 000000007efbffff : System RAM
> get_memory_ranges_iomem_cb: 000000007efc0000 - 000000007efdffff : reserved
> get_memory_ranges_iomem_cb: 000000007efe0000 - 000000007efeffff : System RAM
> get_memory_ranges_iomem_cb: 000000007eff0000 - 000000007effffff : reserved
> get_memory_ranges_iomem_cb: 000000007f000000 - 000000007fffffff : System RAM
> get_memory_ranges_iomem_cb: 0000000080000000 - 00000000bfffffff : reserved
> get_memory_ranges_iomem_cb: 00000000c0000000 - 00000017ffffffff : System RAM
> elf_arm64_load: e_entry:        ffff000008080000
> elf_arm64_load: p_vaddr:        ffff000008080000
> elf_arm64_load: header_offset:  0000000000000000
> elf_arm64_load: kernel_segment: 0000000000a00000
> elf_arm64_load: text_offset:    0000000000080000
> elf_arm64_load: image_size:     000000000163a000
> elf_arm64_load: phys_offset:    0000000000200000
> elf_arm64_load: vp_offset:      ffff000007800000
> elf_arm64_load: PE format:      yes
> read_1st_dtb: found /sys/firmware/fdt
> initrd: base 8f03000, size 49820c4h (77078724)
> dtb_set_initrd: start 149958656, end 227037380, size 77078724 (75272 KiB)
> dtb:    base 20ba000, size 301h (769)
> sym: sha256_starts info: 12 other: 00 shndx: 1 value: e70 size: 58
> sym: sha256_starts value: 20bbe70 addr: 20bb014
> machine_apply_elf_rel: CALL26 5800065394000000->5800065394000397
> sym: sha256_update info: 12 other: 00 shndx: 1 value: 2dd8 size: c
> sym: sha256_update value: 20bddd8 addr: 20bb030
> machine_apply_elf_rel: CALL26 eb15027f94000000->eb15027f94000b6a
> sym: sha256_finish info: 12 other: 00 shndx: 1 value: 2de8 size: 1c4
> sym: sha256_finish value: 20bdde8 addr: 20bb048
> machine_apply_elf_rel: CALL26 aa1303e194000000->aa1303e194000b68
> sym:     memcmp info: 12 other: 00 shndx: 1 value: 5f8 size: 34
> sym: memcmp value: 20bb5f8 addr: 20bb058
> machine_apply_elf_rel: CALL26 340003a094000000->340003a094000168
> sym:     printf info: 12 other: 00 shndx: 1 value: 514 size: 80
> sym: printf value: 20bb514 addr: 20bb068
> machine_apply_elf_rel: CALL26 5800042094000000->580004209400012b
> sym:     printf info: 12 other: 00 shndx: 1 value: 514 size: 80
> sym: printf value: 20bb514 addr: 20bb070
> machine_apply_elf_rel: CALL26 5800043694000000->5800043694000129
> sym:     printf info: 12 other: 00 shndx: 1 value: 514 size: 80
> sym: printf value: 20bb514 addr: 20bb084
> machine_apply_elf_rel: CALL26 f100827f94000000->f100827f94000124
> sym:     printf info: 12 other: 00 shndx: 1 value: 514 size: 80
> sym: printf value: 20bb514 addr: 20bb0a0
> machine_apply_elf_rel: CALL26 5800032094000000->580003209400011d
> sym:     printf info: 12 other: 00 shndx: 1 value: 514 size: 80
> sym: printf value: 20bb514 addr: 20bb0a8
> machine_apply_elf_rel: CALL26 38736a8194000000->38736a819400011b
> sym:     printf info: 12 other: 00 shndx: 1 value: 514 size: 80
> sym: printf value: 20bb514 addr: 20bb0b8
> machine_apply_elf_rel: CALL26 f100827f94000000->f100827f94000117
> sym:     printf info: 12 other: 00 shndx: 1 value: 514 size: 80
> sym: printf value: 20bb514 addr: 20bb0c8
> machine_apply_elf_rel: CALL26 5280002094000000->5280002094000113
> sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
> sym: .data value: 20be028 addr: 20bb0e0
> machine_apply_elf_rel: ABS64 0000000000000000->00000000020be028
> sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
> sym: .rodata.str1.1 value: 20bdfb8 addr: 20bb0e8
> machine_apply_elf_rel: ABS64 0000000000000000->00000000020bdfb8
> sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
> sym: .rodata.str1.1 value: 20bdfd8 addr: 20bb0f0
> machine_apply_elf_rel: ABS64 0000000000000000->00000000020bdfd8
> sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
> sym: .rodata.str1.1 value: 20bdfe8 addr: 20bb0f8
> machine_apply_elf_rel: ABS64 0000000000000000->00000000020bdfe8
> sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
> sym: .rodata.str1.1 value: 20bdfee addr: 20bb100
> machine_apply_elf_rel: ABS64 0000000000000000->00000000020bdfee
> sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
> sym: .rodata.str1.1 value: 20bdff0 addr: 20bb108
> machine_apply_elf_rel: ABS64 0000000000000000->00000000020bdff0
> sym:     printf info: 12 other: 00 shndx: 1 value: 514 size: 80
> sym: printf value: 20bb514 addr: 20bb11c
> machine_apply_elf_rel: CALL26 9400000094000000->94000000940000fe
> sym: setup_arch info: 12 other: 00 shndx: 1 value: e68 size: 4
> sym: setup_arch value: 20bbe68 addr: 20bb120
> machine_apply_elf_rel: CALL26 9400000094000000->9400000094000352
> sym: verify_sha256_digest info: 12 other: 00 shndx: 1 value: 0 size: e0
> sym: verify_sha256_digest value: 20bb000 addr: 20bb124
> machine_apply_elf_rel: CALL26 3400004094000000->3400004097ffffb7
> sym: post_verification_setup_arch info: 12 other: 00 shndx: 1 value: e64 size: 4
> sym: post_verification_setup_arch value: 20bbe64 addr: 20bb134
> machine_apply_elf_rel: JUMP26 0000000014000000->000000001400034c
> sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
> sym: .rodata.str1.1 value: 20be000 addr: 20bb138
> machine_apply_elf_rel: ABS64 0000000000000000->00000000020be000
> sym:    putchar info: 12 other: 00 shndx: 1 value: e60 size: 4
> sym: putchar value: 20bbe60 addr: 20bb198
> machine_apply_elf_rel: CALL26 140000b394000000->140000b394000332
> sym:    putchar info: 12 other: 00 shndx: 1 value: e60 size: 4
> sym: putchar value: 20bbe60 addr: 20bb208
> machine_apply_elf_rel: CALL26 9100069494000000->9100069494000316
> sym:    putchar info: 12 other: 00 shndx: 1 value: e60 size: 4
> sym: putchar value: 20bbe60 addr: 20bb458
> machine_apply_elf_rel: CALL26 9100071894000000->9100071894000282
> sym: .rodata.str1.1 info: 03 other: 00 shndx: 3 value: 0 size: 0
> sym: .rodata.str1.1 value: 20be012 addr: 20bb498
> machine_apply_elf_rel: ABS64 0000000000000000->00000000020be012
> sym:   vsprintf info: 12 other: 00 shndx: 1 value: 140 size: 354
> sym: vsprintf value: 20bb140 addr: 20bb508
> machine_apply_elf_rel: CALL26 a8d07bfd94000000->a8d07bfd97ffff0e
> sym:   vsprintf info: 12 other: 00 shndx: 1 value: 140 size: 354
> sym: vsprintf value: 20bb140 addr: 20bb588
> machine_apply_elf_rel: CALL26 a8d17bfd94000000->a8d17bfd97fffeee
> sym:  purgatory info: 12 other: 00 shndx: 1 value: 110 size: 28
> sym: purgatory value: 20bb110 addr: 20bb638
> machine_apply_elf_rel: CALL26 5800001194000000->5800001197fffeb6
> sym: arm64_kernel_entry info: 10 other: 00 shndx: 4 value: 120 size: 8
> sym: arm64_kernel_entry value: 20be148 addr: 20bb63c
> machine_apply_elf_rel: LD_PREL_LO19 5800000058000011->5800000058015871
> sym: arm64_dtb_addr info: 10 other: 00 shndx: 4 value: 128 size: 8
> sym: arm64_dtb_addr value: 20be150 addr: 20bb640
> machine_apply_elf_rel: LD_PREL_LO19 aa1f03e158000000->aa1f03e158015880
> sym: sha256_process info: 12 other: 00 shndx: 1 value: ec8 size: 1e08
> sym: sha256_process value: 20bbec8 addr: 20bdd4c
> machine_apply_elf_rel: CALL26 eb14027f94000000->eb14027f97fff85f
> sym:     memcpy info: 12 other: 00 shndx: 1 value: 5d8 size: 20
> sym: memcpy value: 20bb5d8 addr: 20bdd98
> machine_apply_elf_rel: JUMP26 d503201f14000000->d503201f17fff610
> sym:     memcpy info: 12 other: 00 shndx: 1 value: 5d8 size: 20
> sym: memcpy value: 20bb5d8 addr: 20bddb8
> machine_apply_elf_rel: CALL26 aa1403e194000000->aa1403e197fff608
> sym: sha256_process info: 12 other: 00 shndx: 1 value: ec8 size: 1e08
> sym: sha256_process value: 20bbec8 addr: 20bddc4
> machine_apply_elf_rel: CALL26 17ffffd894000000->17ffffd897fff841
> sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
> sym: .data value: 20be158 addr: 20bdfb0
> machine_apply_elf_rel: ABS64 0000000000000000->00000000020be158
> kexec_load: entry = 0x20bb630 flags = 0xb70000
> nr_segments = 5
> segment[0].buf   = 0xffffab2d9010
> segment[0].bufsz = 0xa4d8b8
> segment[0].mem   = 0xa80000
> segment[0].memsz = 0xa4e000
> segment[1].buf   = 0xffffabd29010
> segment[1].bufsz = 0xaef200
> segment[1].mem   = 0x14d0000
> segment[1].memsz = 0xbe2000
> segment[2].buf   = 0x25359710
> segment[2].bufsz = 0x301
> segment[2].mem   = 0x20ba000
> segment[2].memsz = 0x1000
> segment[3].buf   = 0x25359e00
> segment[3].bufsz = 0x3198
> segment[3].mem   = 0x20bb000
> segment[3].memsz = 0x4000
> segment[4].buf   = 0xffffa6544010
> segment[4].bufsz = 0x49820c4
> segment[4].mem   = 0x8f03000
> segment[4].memsz = 0x4983000
