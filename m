From: Robert Richter <robert.richter@cavium.com>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Tue, 18 Oct 2016 17:02:40 +0200
Message-ID: <20161018150240.GU22012@rric.localdomain>
References: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
 <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ@mail.gmail.com>
 <20161006161114.GH22012@rric.localdomain>
 <20161018101715.GA15639@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20161018101715.GA15639@leverpostej>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hanjun Guo <hanjun.guo@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Mark,

thanks for your answer. See below. I also attached the full crash
dump.

On 18.10.16 11:18:36, Mark Rutland wrote:
> Hi Robert, Ard,
> 
> Sorry for the delay in getting to this; I've been travelling a lot
> lately and in the meantime this managed to get buried in my inbox.
> 
> On Thu, Oct 06, 2016 at 06:11:14PM +0200, Robert Richter wrote:
> > On 06.10.16 11:00:33, Ard Biesheuvel wrote:
> > > On 6 October 2016 at 10:52, Robert Richter <rrichter@cavium.com> wrote:
> > > > There is a memory setup problem on ThunderX systems with certain
> > > > memory configurations. The symptom is
> > > >
> > > >  kernel BUG at mm/page_alloc.c:1848!
> > > >
> > > > This happens for some configs with 64k page size enabled. The bug
> > > > triggers for page zones with some pages in the zone not assigned to
> > > > this particular zone. In my case some pages that are marked as nomap
> > > > were not reassigned to the new zone of node 1, so those are still
> > > > assigned to node 0.
> > > >
> > > > The reason for the mis-configuration is a change in pfn_valid() which
> > > > reports pages marked nomap as invalid:
> > > >
> > > >  68709f45385a arm64: only consider memblocks with NOMAP cleared for linear mapping
> > > 
> > > These pages are owned by the firmware, which may map it with
> > > attributes that conflict with the attributes we use for the linear
> > > mapping. This means they should not be covered by the linear mapping.
> > > 
> > > > This causes pages marked as nomap being no long reassigned to the new
> > > > zone in memmap_init_zone() by calling __init_single_pfn().
> 
> Why do we have pages for a nomap region? Given the region shouldn't be
> in the linear mapping, and isn't suitable for general allocation, I
> don't believe it makes sense to have a struct page for any part of it.
> 
> Am I missing some reason that we require a struct page?
> 
> e.g. is it just easier to allocate an unused struct page than to carve
> it out?

Pages are handled in blocks with size MAX_ORDER_NR_PAGES. The start
and end pfn of a memory region is aligned then to fit the mem block
size (see memmap_init_zone()). Therefore a memblock may contain pages
without underlying physical memory.

mm code requires the whole memmap to be initialized, this means that
for each page in the whole mem block there is a valid struct page. See
e.g. move_freepages_block() and move_freepages(), stuct page is
accessed even before pfn_valid() is used. I assume there are other
occurrences of that too.

My interpretation is that pfn_valid() checks for the existence of a
valid struct page, there must not necessarily phys memory mapped to
it. This is the reason why I changed pfn_valid() to use
memblock_is_memory() which is sufficient for generic mm code. Only in
arm64 mm code I additinally added the memblock_is_map_memory() check
where pfn_valid() was used.

> 
> > > This sounds like the root cause of your issue. Could we not fix that instead?
> > 
> > Yes, this is proposal b) from my last mail that would work too: I
> > implemented an arm64 private early_pfn_valid() function that uses
> > memblock_is_memory() to setup all pages of a zone. Though, I think
> > this is the wrong way and thus I prefer this patch instead. I see
> > serveral reasons for this:
> > 
> > Inconsistent use of struct *page, it is initialized but never used
> > again.
> 
> As above, I don't believe we should have a struct page to initialise in
> the first place.
> 
> > Other archs only do a basic range check in pfn_valid(), the default
> > implementation just returns if the whole section is valid. As I
> > understand the code, if the mem range is not aligned to the section,
> > then there will be pfn's in the section that don't have physical mem
> > attached. The page is then just initialized, it's not marked reserved
> > nor the refcount is non-zero. It is then simply not used. This is how
> > no-map pages should be handled too.
> > 
> > I think pfn_valid() is just a quick check if the pfn's struct *page
> > can be used. There is a good description for this in include/linux/
> > mmzone.h. So there can be memory holes that have a valid pfn.
> 
> I take it you mean the comment in the CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
> ifdef (line 1266 in v4.9-rc1)?

Yes.

> 
> I'm not sufficiently acquainted with the memmap code to follow; I'll
> need to dig into that a bit further.
> 
> > If the no-map memory needs special handling, then additional checks
> > need to be added to the particular code (as in ioremap.c). It's imo
> > wrong to (mis-)use pfn_valid for that.
> > 
> > Variant b) involves generic mm code to fix it for arm64, this patch is
> > an arm64 change only. This makes it harder to get a fix for it.
> > (Though maybe only a problem of patch logistics.)
> > 
> > > > Fixing this by restoring the old behavior of pfn_valid() to use
> > > > memblock_is_memory().
> > > 
> > > This is incorrect imo. In general, pfn_valid() means ordinary memory
> > > covered by the linear mapping and the struct page array. Returning
> > > reserved ranges that the kernel should not even touch only to please
> > > the NUMA code seems like an inappropriate way to deal with this issue.
> > 
> > As said above, it is not marked as reserved, it is treated like
> > non-existing memory.
> 
> I think Ard was using "reserved" in the more general sense than the
> Linux-specific meaning. NOMAP is distinct from the Linux concept of
> "reserved" memory, but is "reserved" in some sense.
> 
> Memory with NOMAP is meant to be treated as non-existent for the purpose
> of the linear mapping (and thus for the purpose of struct page).

Yes, it's not marked reserved and can never be freed.

Thanks,

-Robert

> 
> > This has been observed for non-numa kernels too and can happen for
> > each zone that is only partly initialized.
> > 
> > I think the patch addresses your concerns. I can't see there the
> > kernel uses memory marked as nomap in a wrong way.
> 
> I'll have to dig into this locally; I'm still not familiar enough with
> this code to know what the right thing to do is.
> 
> Thanks,
> Mark.

EFI stub: Booting Linux Kernel...
EFI stub: Using DTB from configuration table
EFI stub: Exiting boot services and installing virtual address map...
Booting Linux on physical CPU 0x0
Linux version 4.8.0-rc4-00267-g664e88c (root@crb2spass2rric.localdomain) (gcc version 5.4.0 20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.1) ) #3 SMP Wed Sep 7 06:38:13 UTC 2016
Boot CPU: AArch64 Processor [431f0a10]
efi: Getting EFI parameters from FDT:
efi: EFI v2.40 by Cavium Thunder cn88xx EFI ThunderX-Firmware-Release-1.22.10-0-g4e85766 Aug 24 2016 15:59:03
efi:  ACPI=0xfffff000  ACPI 2.0=0xfffff014  SMBIOS 3.0=0x10ffafcf000 
cma: Reserved 512 MiB at 0x00000000c0000000
NUMA: Adding memblock [0x1400000 - 0xfffffffff] on node 0
NUMA: Adding memblock [0x10000400000 - 0x10fffffffff] on node 1
NUMA: parsing numa-distance-map-v1
NUMA: Initmem setup node 0 [mem 0x01400000-0xfffffffff]
NUMA: NODE_DATA [mem 0xfffff2580-0xfffffffff]
NUMA: Initmem setup node 1 [mem 0x10000400000-0x10fffffffff]
NUMA: NODE_DATA [mem 0x10ffffa2500-0x10ffffaff7f]
kmemleak: Kernel memory leak detector disabled
Zone ranges:
  DMA      [mem 0x0000000001400000-0x00000000ffffffff]
  Normal   [mem 0x0000000100000000-0x0000010fffffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000001400000-0x00000000fffdffff]
  node   0: [mem 0x00000000fffe0000-0x00000000ffffffff]
  node   0: [mem 0x0000000100000000-0x0000000fffffffff]
  node   1: [mem 0x0000010000400000-0x0000010ff9e8ffff]
  node   1: [mem 0x0000010ff9e90000-0x0000010ff9f2ffff]
  node   1: [mem 0x0000010ff9f30000-0x0000010ffaeaffff]
  node   1: [mem 0x0000010ffaeb0000-0x0000010ffaffffff]
  node   1: [mem 0x0000010ffb000000-0x0000010ffffaffff]
  node   1: [mem 0x0000010ffffb0000-0x0000010fffffffff]
Initmem setup node 0 [mem 0x0000000001400000-0x0000000fffffffff]
Initmem setup node 1 [mem 0x0000010000400000-0x0000010fffffffff]
psci: probing for conduit method from DT.
psci: PSCIv0.2 detected in firmware.
psci: Using standard PSCI v0.2 function IDs
psci: Trusted OS resident on physical CPU 0x0
Number of cores (96) exceeds configured maximum of 8 - clipping
percpu: Embedded 3 pages/cpu @ffffff0fffce0000 s117704 r8192 d70712 u196608
Detected VIPT I-cache on CPU0
CPU features: enabling workaround for Cavium erratum 27456
Built 2 zonelists in Node order, mobility grouping on.  Total pages: 2094720
Policy zone: Normal
Kernel command line: BOOT_IMAGE=/vmlinuz root=UUID=9a418ae5-231a-40c7-b7ba-ca70cfadfc5e ro LANG=en_US.UTF-8
PID hash table entries: 4096 (order: -1, 32768 bytes)
software IO TLB [mem 0xfbfd0000-0xfffd0000] (64MB) mapped at [fffffe00fbfd0000-fffffe00fffcffff]
Memory: 133196160K/134193152K available (9084K kernel code, 1545K rwdata, 3712K rodata, 1536K init, 15826K bss, 472704K reserved, 524288K cma-reserved)
Virtual kernel memory layout:
    modules : 0xfffffc0000000000 - 0xfffffc0008000000   (   128 MB)
    vmalloc : 0xfffffc0008000000 - 0xfffffdff5fff0000   (  2045 GB)
      .text : 0xfffffc0008080000 - 0xfffffc0008960000   (  9088 KB)
    .rodata : 0xfffffc0008960000 - 0xfffffc0008d10000   (  3776 KB)
      .init : 0xfffffc0008d10000 - 0xfffffc0008e90000   (  1536 KB)
      .data : 0xfffffc0008e90000 - 0xfffffc0009012600   (  1546 KB)
       .bss : 0xfffffc0009012600 - 0xfffffc0009f86fc8   ( 15827 KB)
    fixed   : 0xfffffdff7e7d0000 - 0xfffffdff7ec00000   (  4288 KB)
    PCI I/O : 0xfffffdff7ee00000 - 0xfffffdff7fe00000   (    16 MB)
    vmemmap : 0xfffffdff80000000 - 0xfffffe0000000000   (     2 GB maximum)
              0xfffffdff80005000 - 0xfffffdffc4000000   (  1087 MB actual)
    memory  : 0xfffffe0001400000 - 0xffffff1000000000   (1114092 MB)
SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=8, Nodes=2
Running RCU self tests
Hierarchical RCU implementation.
	RCU lockdep checking is enabled.
	Build-time adjustment of leaf fanout to 64.
NR_IRQS:64 nr_irqs:64 0
GICv3: GIC: Using split EOI/Deactivate mode
ITS: /interrupt-controller@801000000000/gic-its@801000020000
ITS@0x0000801000020000: allocated 2097152 Devices @ff5000000 (flat, esz 8, psz 64K, shr 1)
ITS: /interrupt-controller@801000000000/gic-its@901000020000
ITS@0x0000901000020000: allocated 2097152 Devices @ffa000000 (flat, esz 8, psz 64K, shr 1)
GIC: using LPI property table @0x0000000ff4140000
ITS: Allocated 32512 chunks for LPIs
GICv3: CPU0: found redistributor 0 region 0:0x0000801080000000
CPU0: using LPI pending table @0x0000000ff4150000
arm_arch_timer: Architected cp15 timer(s) running at 100.00MHz (phys).
clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x171024e7e0, max_idle_ns: 440795205315 ns
sched_clock: 56 bits at 100MHz, resolution 10ns, wraps every 4398046511100ns
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     32768
... MAX_LOCKDEP_CHAINS:      65536
... CHAINHASH_SIZE:          32768
 memory used by lock dependency info: 8159 kB
 per task-struct memory footprint: 1920 bytes
mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
Calibrating delay loop (skipped), value calculated using timer frequency.. 200.00 BogoMIPS (lpj=100000)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Yama: becoming mindful.
SELinux:  Initializing.
Dentry cache hash table entries: 16777216 (order: 11, 134217728 bytes)
Inode-cache hash table entries: 8388608 (order: 10, 67108864 bytes)
Mount-cache hash table entries: 262144 (order: 5, 2097152 bytes)
Mountpoint-cache hash table entries: 262144 (order: 5, 2097152 bytes)
ftrace: allocating 29244 entries in 8 pages
Unable to find CPU node for /cpus/cpu@8
/cpus/cpu-map/cluster0/core8: Can't get CPU for leaf core
ASID allocator initialised with 65536 entries
PCI/MSI: /interrupt-controller@801000000000/gic-its@801000020000 domain created
PCI/MSI: /interrupt-controller@801000000000/gic-its@901000020000 domain created
Platform MSI: /interrupt-controller@801000000000/gic-its@801000020000 domain created
Platform MSI: /interrupt-controller@801000000000/gic-its@901000020000 domain created
Remapping and enabling EFI services.
UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at arch/arm64/kernel/efi.c:34 efi_create_mapping+0x5c/0x11c
Modules linked in:

CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.8.0-rc4-00267-g664e88c #3
Hardware name: Cavium ThunderX CN88XX board (DT)
task: fffffe0fee55a200 task.stack: ffffff00004a4000
PC is at efi_create_mapping+0x5c/0x11c
LR is at efi_create_mapping+0x5c/0x11c
pc : [<fffffc0008d14f68>] lr : [<fffffc0008d14f68>] pstate: 60000045
sp : ffffff00004a7d00
x29: ffffff00004a7d00 x28: 0000000000000000 
x27: 0000000000000000 x26: 0000000000000000 
x25: 0000000000000000 x24: fffffc0008f9c730 
x23: fffffc0008f9c730 x22: fffffc0008c60ac0 
x21: fffffc0008f9c730 x20: 00c8000000000713 
x19: ffffff0ff76b0c08 x18: 0000000000000010 
x17: 00000000c9cbbfc7 x16: 0000000000000000 
x15: fffffc0089c956f7 x14: 3f657261776d7269 
x13: 6620796767756220 x12: 2d2d20424b203436 
x11: 206f742064656e67 x10: 0000000000000077 
x9 : 65726120736e6f69 x8 : 0000000000000001 
x7 : ffffff00004a4000 x6 : fffffc000814a288 
x5 : 0000000000000000 x4 : 0000000000000001 
x3 : 0000000000000001 x2 : ffffff00004a4000 
x1 : fffffe0fee55a200 x0 : 0000000000000040 

---[ end trace fcdd7f8cb96cdb3b ]---
Call trace:
Exception stack(0xffffff00004a7b20 to 0xffffff00004a7c50)
7b20: ffffff0ff76b0c08 0000040000000000 ffffff00004a7d00 fffffc0008d14f68
7b40: 0000000060000045 000000000000003d 0000000000000001 fffffc000814a9fc
7b60: ffffff00004a7c00 fffffc000814adcc ffffff00004a7c60 fffffc0008baf420
7b80: fffffc0008f9c730 fffffc0008c60ac0 fffffc0008f9c730 fffffc0008f9c730
7ba0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7bc0: fffffc00080d6d70 0000000000000000 0000000000000040 fffffe0fee55a200
7be0: ffffff00004a4000 0000000000000001 0000000000000001 0000000000000000
7c00: fffffc000814a288 ffffff00004a4000 0000000000000001 65726120736e6f69
7c20: 0000000000000077 206f742064656e67 2d2d20424b203436 6620796767756220
7c40: 3f657261776d7269 fffffc0089c956f7
[<fffffc0008d14f68>] efi_create_mapping+0x5c/0x11c
[<fffffc0008d5e1ec>] arm_enable_runtime_services+0x12c/0x210
[<fffffc0008082ff4>] do_one_initcall+0x44/0x138
[<fffffc0008d10d30>] kernel_init_freeable+0x17c/0x2e0
[<fffffc000893c888>] kernel_init+0x20/0xf8
[<fffffc0008082b80>] ret_from_fork+0x10/0x50
  EFI remap 0x0000010ff9e98000 => 0000000020008000
  EFI remap 0x0000010ffaeb6000 => 00000000200a6000
  EFI remap 0x0000010ffafc9000 => 00000000201b9000
  EFI remap 0x0000010ffafcd000 => 00000000201bd000
  EFI remap 0x0000010ffffb9000 => 00000000201f9000
  EFI remap 0x0000010ffffcd000 => 000000002020d000
  EFI remap 0x0000804000001000 => 0000000020241000
  EFI remap 0x000087e0d0001000 => 0000000020251000
Detected VIPT I-cache on CPU1
GICv3: CPU1: found redistributor 1 region 0:0x0000801080020000
CPU1: using LPI pending table @0x0000010014060000
CPU1: Booted secondary processor [431f0a10]
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at ./include/linux/cpumask.h:121 gic_raise_softirq+0x14c/0x1e0
Modules linked in:

CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W       4.8.0-rc4-00267-g664e88c #3
Hardware name: Cavium ThunderX CN88XX board (DT)
task: fffffe0fee57b600 task.stack: fffffe0fe4038000
PC is at gic_raise_softirq+0x14c/0x1e0
LR is at gic_raise_softirq+0xc0/0x1e0
pc : [<fffffc00084c07a4>] lr : [<fffffc00084c0718>] pstate: 600001c5
sp : fffffe0fe403bcd0
x29: fffffe0fe403bcd0 x28: 0000000000000001 
x27: fffffc0008fd7b1d x26: 0000000000000000 
x25: fffffc0008ec2000 x24: fffffc0008ecebc8 
x23: fffffc0008998688 x22: 0000000000000001 
x21: fffffc0008ec2e34 x20: 0000000000000000 
x19: 0000000000000008 x18: 0000000000000030 
x17: 0000000000000000 x16: 0000000000000000 
x15: fffffc0009c97f08 x14: 0000000000000002 
x13: 0000000000000332 x12: 0000000000000335 
x11: fffffc0009bf3de0 x10: 0000000000000332 
x9 : fffffe0fe4038000 x8 : 0000000000000000 
x7 : 00000000ffffffff x6 : 0000000000000000 
x5 : fffffffffffffffe x4 : 0000000000000040 
x3 : 0000000000000000 x2 : 0000000000000000 
x1 : 0000000000000008 x0 : 0000000000000001 

---[ end trace fcdd7f8cb96cdb3c ]---
Call trace:
Exception stack(0xfffffe0fe403baf0 to 0xfffffe0fe403bc20)
bae0:                                   0000000000000008 0000040000000000
bb00: fffffe0fe403bcd0 fffffc00084c07a4 00000000600001c5 000000000000003d
bb20: fffffe0fee57bec0 ffffffffffffffd8 0000000000000028 fffffe0fee57be70
bb40: fffffc000925fe88 0000000000000002 fffffc00080886c0 fffffe0fee57b600
bb60: fffffe0fe403bb90 fffffc0008088974 fffffc00099b4d60 fffffe0fee57b600
bb80: fffffc000925fe88 fffffe0fe403bd4c fffffe0fe403bbe0 fffffc00080889e8
bba0: 0000000000000001 0000000000000008 0000000000000000 0000000000000000
bbc0: 0000000000000040 fffffffffffffffe 0000000000000000 00000000ffffffff
bbe0: 0000000000000000 fffffe0fe4038000 0000000000000332 fffffc0009bf3de0
bc00: 0000000000000335 0000000000000332 0000000000000002 fffffc0009c97f08
[<fffffc00084c07a4>] gic_raise_softirq+0x14c/0x1e0
[<fffffc000808e028>] smp_cross_call+0x80/0x238
[<fffffc000808efa4>] smp_send_reschedule+0x3c/0x48
[<fffffc00081021a8>] resched_curr+0x58/0x90
[<fffffc0008103fd8>] check_preempt_curr+0x70/0xe8
[<fffffc0008104090>] ttwu_do_wakeup+0x40/0x2e8
[<fffffc00081043cc>] ttwu_do_activate+0x94/0xc0
[<fffffc00081058a8>] try_to_wake_up+0x200/0x580
[<fffffc0008105d3c>] default_wake_function+0x34/0x48
[<fffffc0008126afc>] __wake_up_common+0x64/0xa8
[<fffffc0008126bec>] __wake_up_locked+0x3c/0x50
[<fffffc0008127b58>] complete+0x48/0x68
[<fffffc000808e630>] secondary_start_kernel+0x180/0x208
[<0000000001482e08>] 0x1482e08
Detected VIPT I-cache on CPU2
GICv3: CPU2: found redistributor 2 region 0:0x0000801080040000
CPU2: using LPI pending table @0x0000010014070000
CPU2: Booted secondary processor [431f0a10]
Detected VIPT I-cache on CPU3
GICv3: CPU3: found redistributor 3 region 0:0x0000801080060000
CPU3: using LPI pending table @0x0000010014080000
CPU3: Booted secondary processor [431f0a10]
Detected VIPT I-cache on CPU4
GICv3: CPU4: found redistributor 4 region 0:0x0000801080080000
CPU4: using LPI pending table @0x0000010014090000
CPU4: Booted secondary processor [431f0a10]
Detected VIPT I-cache on CPU5
GICv3: CPU5: found redistributor 5 region 0:0x00008010800a0000
CPU5: using LPI pending table @0x00000100140a0000
CPU5: Booted secondary processor [431f0a10]
Detected VIPT I-cache on CPU6
GICv3: CPU6: found redistributor 6 region 0:0x00008010800c0000
CPU6: using LPI pending table @0x00000100140b0000
CPU6: Booted secondary processor [431f0a10]
Detected VIPT I-cache on CPU7
GICv3: CPU7: found redistributor 7 region 0:0x00008010800e0000
CPU7: using LPI pending table @0x00000100140c0000
CPU7: Booted secondary processor [431f0a10]
Brought up 8 CPUs
SMP: Total of 8 processors activated.
CPU features: detected feature: GIC system register CPU interface
CPU features: detected feature: LSE atomic instructions
CPU features: detected feature: Software prefetching using PRFM
CPU: All CPU(s) started at EL2
alternatives: patching kernel code
devtmpfs: initialized
SMBIOS 3.0.0 present.
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
atomic64_test: passed
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
cpuidle: using governor menu
vdso: 2 pages (1 code @ fffffc0008980000, 1 data @ fffffc0008eb0000)
hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
DMA: preallocated 256 KiB pool for atomic allocations
Serial: AMBA PL011 UART driver
87e024000000.serial: ttyAMA0 at MMIO 0x87e024000000 (irq = 7, base_baud = 0) is a PL011 rev3
console [ttyAMA0] enabled
87e025000000.serial: ttyAMA1 at MMIO 0x87e025000000 (irq = 8, base_baud = 0) is a PL011 rev3
OF: /soc@0/pci@848000000000: arguments longer than property
OF: /soc@0/pci@849000000000: arguments longer than property
OF: /soc@0/pci@84a000000000: arguments longer than property
OF: /soc@0/pci@84b000000000: arguments longer than property
OF: /soc@0/pci@87e0c0000000: arguments longer than property
OF: /soc@100000000000/pci@848000000000: arguments longer than property
OF: /soc@100000000000/pci@849000000000: arguments longer than property
OF: /soc@100000000000/pci@84a000000000: arguments longer than property
OF: /soc@100000000000/pci@84b000000000: arguments longer than property
HugeTLB registered 2 MB page size, pre-allocated 0 pages
HugeTLB registered 512 MB page size, pre-allocated 0 pages
ACPI: Interpreter disabled.
arm-smmu 830000000000.smmu0: probing hardware configuration...
arm-smmu 830000000000.smmu0: SMMUv2 with:
arm-smmu 830000000000.smmu0: 	stage 1 translation
arm-smmu 830000000000.smmu0: 	stage 2 translation
arm-smmu 830000000000.smmu0: 	nested translation
arm-smmu 830000000000.smmu0: 	non-coherent table walk
arm-smmu 830000000000.smmu0: 	(IDR0.CTTW overridden by dma-coherent property)
arm-smmu 830000000000.smmu0: 	stream matching with 128 register groups, mask 0x7fff
arm-smmu 830000000000.smmu0: 	128 context banks (0 stage-2 only)
arm-smmu 830000000000.smmu0: 	Supported page sizes: 0x62215000
arm-smmu 830000000000.smmu0: 	Stage-1: 48-bit VA -> 48-bit IPA
arm-smmu 830000000000.smmu0: 	Stage-2: 48-bit IPA -> 48-bit PA
arm-smmu 830000000000.smmu0: registered 1 master devices
arm-smmu 831000000000.smmu1: probing hardware configuration...
arm-smmu 831000000000.smmu1: SMMUv2 with:
arm-smmu 831000000000.smmu1: 	stage 1 translation
arm-smmu 831000000000.smmu1: 	stage 2 translation
arm-smmu 831000000000.smmu1: 	nested translation
arm-smmu 831000000000.smmu1: 	non-coherent table walk
arm-smmu 831000000000.smmu1: 	(IDR0.CTTW overridden by dma-coherent property)
arm-smmu 831000000000.smmu1: 	stream matching with 128 register groups, mask 0x7fff
arm-smmu 831000000000.smmu1: 	128 context banks (0 stage-2 only)
arm-smmu 831000000000.smmu1: 	Supported page sizes: 0x62215000
arm-smmu 831000000000.smmu1: 	Stage-1: 48-bit VA -> 48-bit IPA
arm-smmu 831000000000.smmu1: 	Stage-2: 48-bit IPA -> 48-bit PA
arm-smmu 831000000000.smmu1: registered 2 master devices
arm-smmu 832000000000.smmu2: probing hardware configuration...
arm-smmu 832000000000.smmu2: SMMUv2 with:
arm-smmu 832000000000.smmu2: 	stage 1 translation
arm-smmu 832000000000.smmu2: 	stage 2 translation
arm-smmu 832000000000.smmu2: 	nested translation
arm-smmu 832000000000.smmu2: 	non-coherent table walk
arm-smmu 832000000000.smmu2: 	(IDR0.CTTW overridden by dma-coherent property)
arm-smmu 832000000000.smmu2: 	stream matching with 128 register groups, mask 0x7fff
arm-smmu 832000000000.smmu2: 	128 context banks (0 stage-2 only)
arm-smmu 832000000000.smmu2: 	Supported page sizes: 0x62215000
arm-smmu 832000000000.smmu2: 	Stage-1: 48-bit VA -> 48-bit IPA
arm-smmu 832000000000.smmu2: 	Stage-2: 48-bit IPA -> 48-bit PA
arm-smmu 832000000000.smmu2: registered 1 master devices
arm-smmu 833000000000.smmu3: probing hardware configuration...
arm-smmu 833000000000.smmu3: SMMUv2 with:
arm-smmu 833000000000.smmu3: 	stage 1 translation
arm-smmu 833000000000.smmu3: 	stage 2 translation
arm-smmu 833000000000.smmu3: 	nested translation
arm-smmu 833000000000.smmu3: 	non-coherent table walk
arm-smmu 833000000000.smmu3: 	(IDR0.CTTW overridden by dma-coherent property)
arm-smmu 833000000000.smmu3: 	stream matching with 128 register groups, mask 0x7fff
arm-smmu 833000000000.smmu3: 	128 context banks (0 stage-2 only)
arm-smmu 833000000000.smmu3: 	Supported page sizes: 0x62215000
arm-smmu 833000000000.smmu3: 	Stage-1: 48-bit VA -> 48-bit IPA
arm-smmu 833000000000.smmu3: 	Stage-2: 48-bit IPA -> 48-bit PA
arm-smmu 833000000000.smmu3: registered 1 master devices
arm-smmu 930000000000.smmu4: probing hardware configuration...
arm-smmu 930000000000.smmu4: SMMUv2 with:
arm-smmu 930000000000.smmu4: 	stage 1 translation
arm-smmu 930000000000.smmu4: 	stage 2 translation
arm-smmu 930000000000.smmu4: 	nested translation
arm-smmu 930000000000.smmu4: 	non-coherent table walk
arm-smmu 930000000000.smmu4: 	(IDR0.CTTW overridden by dma-coherent property)
arm-smmu 930000000000.smmu4: 	stream matching with 128 register groups, mask 0x7fff
arm-smmu 930000000000.smmu4: 	128 context banks (0 stage-2 only)
arm-smmu 930000000000.smmu4: 	Supported page sizes: 0x62215000
arm-smmu 930000000000.smmu4: 	Stage-1: 48-bit VA -> 48-bit IPA
arm-smmu 930000000000.smmu4: 	Stage-2: 48-bit IPA -> 48-bit PA
arm-smmu 930000000000.smmu4: registered 1 master devices
arm-smmu 931000000000.smmu5: probing hardware configuration...
arm-smmu 931000000000.smmu5: SMMUv2 with:
arm-smmu 931000000000.smmu5: 	stage 1 translation
arm-smmu 931000000000.smmu5: 	stage 2 translation
arm-smmu 931000000000.smmu5: 	nested translation
arm-smmu 931000000000.smmu5: 	non-coherent table walk
arm-smmu 931000000000.smmu5: 	(IDR0.CTTW overridden by dma-coherent property)
arm-smmu 931000000000.smmu5: 	stream matching with 128 register groups, mask 0x7fff
arm-smmu 931000000000.smmu5: 	128 context banks (0 stage-2 only)
arm-smmu 931000000000.smmu5: 	Supported page sizes: 0x62215000
arm-smmu 931000000000.smmu5: 	Stage-1: 48-bit VA -> 48-bit IPA
arm-smmu 931000000000.smmu5: 	Stage-2: 48-bit IPA -> 48-bit PA
arm-smmu 931000000000.smmu5: registered 1 master devices
arm-smmu 932000000000.smmu6: probing hardware configuration...
arm-smmu 932000000000.smmu6: SMMUv2 with:
arm-smmu 932000000000.smmu6: 	stage 1 translation
arm-smmu 932000000000.smmu6: 	stage 2 translation
arm-smmu 932000000000.smmu6: 	nested translation
arm-smmu 932000000000.smmu6: 	non-coherent table walk
arm-smmu 932000000000.smmu6: 	(IDR0.CTTW overridden by dma-coherent property)
arm-smmu 932000000000.smmu6: 	stream matching with 128 register groups, mask 0x7fff
arm-smmu 932000000000.smmu6: 	128 context banks (0 stage-2 only)
arm-smmu 932000000000.smmu6: 	Supported page sizes: 0x62215000
arm-smmu 932000000000.smmu6: 	Stage-1: 48-bit VA -> 48-bit IPA
arm-smmu 932000000000.smmu6: 	Stage-2: 48-bit IPA -> 48-bit PA
arm-smmu 932000000000.smmu6: registered 1 master devices
arm-smmu 933000000000.smmu7: probing hardware configuration...
arm-smmu 933000000000.smmu7: SMMUv2 with:
arm-smmu 933000000000.smmu7: 	stage 1 translation
arm-smmu 933000000000.smmu7: 	stage 2 translation
arm-smmu 933000000000.smmu7: 	nested translation
arm-smmu 933000000000.smmu7: 	non-coherent table walk
arm-smmu 933000000000.smmu7: 	(IDR0.CTTW overridden by dma-coherent property)
arm-smmu 933000000000.smmu7: 	stream matching with 128 register groups, mask 0x7fff
arm-smmu 933000000000.smmu7: 	128 context banks (0 stage-2 only)
arm-smmu 933000000000.smmu7: 	Supported page sizes: 0x62215000
arm-smmu 933000000000.smmu7: 	Stage-1: 48-bit VA -> 48-bit IPA
arm-smmu 933000000000.smmu7: 	Stage-2: 48-bit IPA -> 48-bit PA
arm-smmu 933000000000.smmu7: registered 1 master devices
iommu: Adding device 848000000000.pci to group 0
iommu: Adding device 849000000000.pci to group 1
iommu: Adding device 84a000000000.pci to group 2
iommu: Adding device 84b000000000.pci to group 3
iommu: Adding device 88001f000000.pci to group 4
iommu: Adding device 948000000000.pci to group 5
iommu: Adding device 949000000000.pci to group 6
iommu: Adding device 94a000000000.pci to group 7
iommu: Adding device 94b000000000.pci to group 8
vgaarb: loaded
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMA-API: preallocated 4096 debug entries
DMA-API: debugging enabled by kernel config
clocksource: Switched to clocksource arch_sys_counter
VFS: Disk quotas dquot_6.6.0
VFS: Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
pnp: PnP ACPI: disabled
NET: Registered protocol family 2
TCP established hash table entries: 524288 (order: 6, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 6, 4194304 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
UDP hash table entries: 65536 (order: 7, 10485760 bytes)
UDP-Lite hash table entries: 65536 (order: 7, 10485760 bytes)
NET: Registered protocol family 1
Unpacking initramfs...
------------[ cut here ]------------
kernel BUG at mm/page_alloc.c:1844!
Internal error: Oops - BUG: 0 [#1] SMP
Modules linked in:
CPU: 4 PID: 1 Comm: swapper/0 Tainted: G        W       4.8.0-rc4-00267-g664e88c #3
Hardware name: www.cavium.com ThunderX CRB-2S/ThunderX CRB-2S, BIOS 0.3 Aug 24 2016
task: fffffe0fee55a200 task.stack: ffffff00004a4000
PC is at move_freepages+0x158/0x168
LR is at move_freepages_block+0xac/0xc0
pc : [<fffffc0008227618>] lr : [<fffffc00082276d4>] pstate: 800000c5
sp : ffffff00004a7480
x29: ffffff00004a7480 x28: fffffdffc3fc0020 
x27: fffffdffc3fc0000 x26: 000000000000000a 
x25: 000000000000000a x24: ffffff0ffffa3190 
x23: ffffff0fffdbf530 x22: 0000000000000000 
x21: fffffdffc3ffffc0 x20: ffffff0ffffa2c80 
x19: fffffdffc3f80000 x18: fffffe0fdc0c2548 
x17: 0000000000000000 x16: 0000000100000000 
x15: 00000000000000c1 x14: 04000000001b2000 
x13: 00aedf01c7040000 x12: 00001b00000033f5 
x11: 01c604000000001b x10: 0000ae7401c50430 
x9 : 0000000000000000 x8 : fffffc0008f53000 
x7 : fffffc00082295f0 x6 : 0000000000000001 
x5 : 0000000000000000 x4 : fffffe0fffff2580 
x3 : ffffff0ffffa2500 x2 : 0000000000000001 
x1 : fffffe0fffff2580 x0 : ffffff0ffffa2c80 

Process swapper/0 (pid: 1, stack limit = 0xffffff00004a4020)
Stack: (0xffffff00004a7480 to 0xffffff00004a8000)
7480: ffffff00004a74e0 fffffc00082276d4 0000000000000000 ffffff0ffffa2c80
74a0: fffffdffc3f80000 0000000000000000 ffffff0fffdbf530 ffffff0ffffa3190
74c0: 000000000000000a 000000000000000a fffffdffc3fc0000 fffffdffc3fc0020
74e0: ffffff00004a7510 fffffc0008227f00 ffffff0ffffa2c80 0000000000000000
7500: fffffdffc3fc0000 0000000000000028 ffffff00004a75b0 fffffc0008229654
7520: ffffff0fffdbf530 ffffff0ffffa2c80 fffffc0008e5f520 0000000000000000
7540: ffffff0fffdbf530 ffffff0fffdbf520 0000030ff6f60000 0000000000000001
7560: 0000000000000000 0000000000000000 ffffff0ffffa3200 fffffc00082295f0
7580: fffffc0008e5f520 fffffc0008ec1000 0000000000000000 0000000000000001
75a0: 0000000000000010 01ffff0ffffa2c80 ffffff00004a76a0 fffffc000822a5ec
75c0: 00000000024200c2 0000000000000000 0000000000000000 00000000024200c2
75e0: fffffc0008ec4000 0000000000000001 0000000000000000 fffffc0008ec2000
7600: 00000000024200c2 fffffc00082886c8 ffffffffffffffff 0000000000000040
7620: 00000012004a7640 fffffc0008e587e8 0000000100000000 0000000000000000
7640: ffffff00024200c2 fffffc00081007bc ffffff0ffffa2c80 0000000000000010
7660: fffffc0008e5f520 0000000000000040 0000000000000000 ffffff0ffffa3200
7680: 0000000000000001 ffffff0ffffa3b80 ffffff0ffffa3b80 ffffff00004a77b8
76a0: ffffff00004a77e0 fffffc00082886c8 0000000000000000 fffffc0008ec0c48
76c0: ffffff0ffffa3b80 0000000000000000 0000000000000000 0000000000000001
76e0: ffffff00004a4000 0000000000000000 fffffe0fee55a200 00000000000053d4
7700: fffffe0fee55a200 0000000000000000 0000000000000000 fffffc0008eec160
7720: 0000000000000000 0000000000000002 fffffe0fee55aa98 fffffc0008ec2000
7740: fffffe0fee55a200 fffffc0009c95000 0000000000000000 fffffc0008eec160
7760: 0000000000000000 fffffc0008e587e8 0000000000000000 0000000100400000
7780: 0000000000000000 0000000000000000 0000000000000000 0000000000000002
77a0: 0000000000000000 0000000000000000 fffffc000821d070 ffffff0ffffa3b80
77c0: 0000000000000000 ffffff0ffffa3b80 0000000100000000 0000000000000000
77e0: ffffff00004a7810 fffffc0008288d20 fffffc0008e587e8 fffffe0fec01a8f0
7800: 00000000024200c2 fffffc000821e62c ffffff00004a7870 fffffc000821e62c
7820: 0000000000000000 ffffff00004a4000 00000000024200c2 fffffe0fe0249410
7840: fffffc000821e788 00000000024200c2 fffffc0008f01d28 0000000002493ee0
7860: 0000000000002c2c 0000000000000040 ffffff00004a78d0 fffffc000821e788
7880: 0000000000000000 000000000000000e 00000000024200c2 fffffe0fe0249410
78a0: 0000000000000001 fffffc0008fd76ac fffffc0008f01d28 0000000002493ee0
78c0: 0000000000002c2c fffffc000821e850 ffffff00004a7930 fffffc000821e9b0
78e0: fffffe0fe0249410 0000000000000001 0000000000000001 0000000000002c2c
7900: ffffff00004a7a20 fffffe0fcc140400 00000000000053d4 fffffc00089b8900
7920: 0000000000002c2c fffffc000821e440 ffffff00004a7960 fffffc00082eb758
7940: fffffe0fe0249410 0000000000000001 0000000000010000 ffffff00004a7b18
7960: ffffff00004a79a0 fffffc000821e3bc 0000000000010000 ffffff00004a7b18
7980: fffffe0fe0249410 0000000000010000 0000000000000000 fffffc000821e434
79a0: ffffff00004a7a30 fffffc00082200e0 0000000000000000 fffffe0fcc140400
79c0: fffffe0fe0249210 ffffff00004a7af0 fffffe0fe0249410 ffffff00004a7b18
79e0: fffffc0008d40e70 0000000000008000 fffffc0009040078 ffffff0f83f26000
7a00: 0000000000000000 fffffc0008bd0300 00002c2c00000001 ffffff00004a4000
7a20: fffffdff83f20840 0000000027e02140 ffffff00004a7a80 fffffc00082201fc
7a40: 0000000000008000 ffffff00004a7af0 fffffe0fe02492e8 ffffff00004a7b18
7a60: ffffff00004a7bb8 0000000000000007 fffffc0008d40e70 0000000000008000
7a80: ffffff00004a7ab0 fffffc00082ba89c fffffe0fcc140400 0000000000008000
7aa0: ffffff00004a7bb8 fffffe0fdd350000 ffffff00004a7b40 fffffc00082bb588
7ac0: 0000000000000000 0000000000008000 fffffe0fcc140400 fffffe0fdd350000
7ae0: fffffe0fdd350000 0000000000008000 fffffe0fcc140400 000000000000ac2c
7b00: 0000000000000000 0000000000000000 0000000000000000 fffffc0000000003
7b20: 00000000000053d4 0000000000002c2c ffffff00004a7ae0 0000000000000001
7b40: ffffff00004a7b80 fffffc00082bc5b4 fffffe0fcc140400 fffffe0fcc140400
7b60: fffffe0fdd350000 0000000000008000 fffffc0008babe88 ffffff0f8ea0e439
7b80: ffffff00004a7bc0 fffffc0008d120f0 0000000000000000 0000000000008000
7ba0: fffffe0fdd350000 0000000000000000 fffffe0fdc3fa280 000000000000ac2c
7bc0: ffffff00004a7bf0 fffffc0008d121d4 fffffc0008d75000 fffffc0008d75b60
7be0: fffffc0008d75bb8 fffffe0fdd350000 ffffff00004a7c10 fffffc0008d11eac
7c00: fffffc0008d75b60 0000000000008000 ffffff00004a7c40 fffffc0008d11f10
7c20: 0000000000008000 0000000000008000 fffffc0008d75b60 fffffc00089e42c0
7c40: ffffff00004a7c80 fffffc0008d410f4 fffffe0fdc3fa280 ffffff0f83f26000
7c60: 0000000000000000 fffffe0fdd350000 fffffc0008d11d74 fffffc0008d11ec8
7c80: ffffff00004a7cf0 fffffc0008d411b4 fffffc0008d75000 ffffff0f83f26000
7ca0: 000000000e7f20bc 0000000000000000 fffffc0008d4119c fffffc0008ff1f38
7cc0: fffffc0008babf90 fffffc0009040000 fffffc0008e3d9a0 0000000000000000
7ce0: 0000000008d75000 0000000000008000 ffffff00004a7d00 fffffc0008d127c4
7d00: ffffff00004a7d60 fffffc0008d1294c fffffc0009040000 fffffc0008d128dc
7d20: fffffc0009040000 fffffc0009040000 fffffc0009040000 fffffc0008d1045c
7d40: fffffc0008cfc468 fffffc0008d74290 0000000000001b57 fffffc0008c04958
7d60: ffffff00004a7d90 fffffc0008082ff4 ffffff00004a4000 fffffc0008d128dc
7d80: 0000000000000000 0000000000000005 ffffff00004a7e00 fffffc0008d10df4
7da0: 0000000000000101 fffffc0009040000 fffffc0008d742a8 0000000000000005
7dc0: fffffc0008e3d700 0000000000000000 fffffc0008ee2370 fffffc0008bb79f8
7de0: 0000000000000000 0000000500000005 0000000000000000 fffffc0008d1045c
7e00: ffffff00004a7ea0 fffffc000893c888 fffffc0009040000 fffffc0009040000
7e20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7e40: 0000000000000000 0000000000000000 0000000000000000 ffffff00004a4000
7e60: 0000000000000003 0000000000000000 0000000000000000 0000000000000000
7e80: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7ea0: 0000000000000000 fffffc0008082b80 fffffc000893c868 0000000000000000
7ec0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7ee0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7f00: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7f20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7f40: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7f60: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7f80: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7fa0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
7fc0: 0000000000000000 0000000000000005 0000000000000000 0000000000000000
7fe0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call trace:
Exception stack(0xffffff00004a72a0 to 0xffffff00004a73d0)
72a0: fffffdffc3f80000 0000040000000000 ffffff00004a7480 fffffc0008227618
72c0: 00000000800000c5 000000000000003d fffffc0008ec4000 0000000000000030
72e0: ffffff00004a7300 fffffc00081593b0 fffffc0008f53000 0000000000000000
7300: ffffff00004a7320 fffffc000822abac fffffc0008fd76be ffffff00004a7438
7320: ffffff00004a7460 fffffc00082886c8 ffffff00004a7380 fffffc0008135d08
7340: 0000000000000001 0000000000000007 ffffff0ffffa2c80 fffffe0fffff2580
7360: 0000000000000001 ffffff0ffffa2500 fffffe0fffff2580 0000000000000000
7380: 0000000000000001 fffffc00082295f0 fffffc0008f53000 0000000000000000
73a0: 0000ae7401c50430 01c604000000001b 00001b00000033f5 00aedf01c7040000
73c0: 04000000001b2000 00000000000000c1
[<fffffc0008227618>] move_freepages+0x158/0x168
[<fffffc00082276d4>] move_freepages_block+0xac/0xc0
[<fffffc0008227f00>] __rmqueue+0x740/0x898
[<fffffc0008229654>] get_page_from_freelist+0x3e4/0xca0
[<fffffc000822a5ec>] __alloc_pages_nodemask+0x1ac/0xfd8
[<fffffc00082886c8>] alloc_page_interleave+0x60/0xb8
[<fffffc0008288d20>] alloc_pages_current+0x168/0x1c8
[<fffffc000821e62c>] __page_cache_alloc+0x17c/0x1c0
[<fffffc000821e788>] pagecache_get_page+0x118/0x2f8
[<fffffc000821e9b0>] grab_cache_page_write_begin+0x48/0x68
[<fffffc00082eb758>] simple_write_begin+0x40/0x168
[<fffffc000821e3bc>] generic_perform_write+0xc4/0x1b8
[<fffffc00082200e0>] __generic_file_write_iter+0x178/0x1c8
[<fffffc00082201fc>] generic_file_write_iter+0xcc/0x1c8
[<fffffc00082ba89c>] __vfs_write+0xcc/0x140
[<fffffc00082bb588>] vfs_write+0xa8/0x1c0
[<fffffc00082bc5b4>] SyS_write+0x54/0xb0
[<fffffc0008d120f0>] xwrite+0x34/0x7c
[<fffffc0008d121d4>] do_copy+0x9c/0xf4
[<fffffc0008d11eac>] write_buffer+0x34/0x50
[<fffffc0008d11f10>] flush_buffer+0x48/0xb8
[<fffffc0008d410f4>] __gunzip+0x27c/0x324
[<fffffc0008d411b4>] gunzip+0x18/0x20
[<fffffc0008d127c4>] unpack_to_rootfs+0x168/0x280
[<fffffc0008d1294c>] populate_rootfs+0x70/0x138
[<fffffc0008082ff4>] do_one_initcall+0x44/0x138
[<fffffc0008d10df4>] kernel_init_freeable+0x240/0x2e0
[<fffffc000893c888>] kernel_init+0x20/0xf8
[<fffffc0008082b80>] ret_from_fork+0x10/0x50
Code: 913dc021 9400d2db d4210000 d503201f (d4210000) 
---[ end trace fcdd7f8cb96cdb3d ]---
note: swapper/0[1] exited with preempt_count 1
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

SMP: stopping secondary CPUs
---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
