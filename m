From: Dave Young <dyoung@redhat.com>
Subject: Re: kexec crash on OVMF i386 + x86_64 kernel (Re: [PATCH v4]
 x86/boot: Use efi_setup_data for searching RSDP on kexec-ed kernel)
Date: Wed, 17 Apr 2019 13:14:18 +0800
Message-ID: <20190417051418.GC8411@dhcp-128-65.nay.redhat.com>
References: <20190412025416.GA11070@jeru.linux.bs1.fc.nec.co.jp>
 <20190412084956.GC19808@zn.tnic>
 <20190412133528.GD19808@zn.tnic>
 <cc2c1dbe-4fb3-fb7d-0540-c04734fc15cb@ce.jp.nec.com>
 <20190415090717.GA29317@zn.tnic>
 <20190415102525.GB29317@zn.tnic>
 <23309b73-d135-a207-564b-6003cee39184@ce.jp.nec.com>
 <4dbbbb4b-7af9-bd98-b567-890407a15cd1@ce.jp.nec.com>
 <20190416094554.GF27892@zn.tnic>
 <befd6560-f41a-b142-a839-aaab861dee5a@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <befd6560-f41a-b142-a839-aaab861dee5a@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Borislav Petkov <bp@alien8.de>, Chao Fan <fanc.fnst@cn.fujitsu.com>, Baoquan He <bhe@redhat.com>, Kairui Song <kasong@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

Added efi people.

I remember previously Sai did some efi32 tests for kexec, but I'm not
sure if he tested EFI32 + 64bit kernel.

Kexec status is not certain because I'm not sure anyone tesed and
reported issues for that.

On 04/16/19 at 11:09pm, Junichi Nomura wrote:
> On 4/16/19 6:45 PM, Borislav Petkov wrote:
> > On Mon, Apr 15, 2019 at 11:14:34PM +0000, Junichi Nomura wrote:
> >> I see kexec is only supported on 64bit kernel. But are we sure
> >> we don't need to support kexec on EFI32 + 64bit kernel?
> >>
> >> I don't have such an environment and as far as I tried with OVMF i386
> >> and KVM guest, that combination doesn't work reliably even with v5.0.
> > 
> > What does that mean exactly?
> > 
> > If it can be fixed, we can try to.
> 
> When I do kexec on OVMF i386 + x86_64 kernel, 1st kexec seems to work.
> But 2nd kexec (i.e. kexec from kexec-booted system) causes kernel
> crash during boot like this:
> 
> [   69.907176] kexec_core: Starting new kernel
> early console in extract_kernel
> input_data: 0x000000003e7a73b1
> input_len: 0x00000000004464c8
> output: 0x000000003d600000
> output_len: 0x00000000015c7248
> kernel_total_size: 0x000000000142c000
> trampoline_32bit: 0x000000000009d000
> booted via startup_64()
> Physical KASLR using RDRAND RDTSC...
> Virtual KASLR using RDRAND RDTSC...
> 
> Decompressing Linux... Parsing ELF... Performing relocations... done.
> Booting the kernel.
> [    0.000000] Linux version 5.0.0-dirty (root@vm76) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-28) (GCC)) #2 SMP Mon Apr 8 04:42:45 EDT 2019
> [    0.000000] Command line: root=UUID=6bea2b7b-e6cc-4dba-ac79-be6530d348f5 ro console=tty0 console=ttyS0,115200n8 no_timer_check net.ifnames=0 crashkernel=auto LANG=en_US.UTF-8 earlyprintk=serial,ttyS0,115200 kexec kexec
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009ffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003ed74fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000003ed75000-0x000000003ee86fff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000003ee87000-0x000000003ff06fff] usable
> [    0.000000] BIOS-e820: [mem 0x000000003ff07000-0x000000003ff5efff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000003ff5f000-0x000000003ff66fff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x000000003ff67000-0x000000003ff6afff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x000000003ff6b000-0x000000003ffcffff] usable
> [    0.000000] BIOS-e820: [mem 0x000000003ffd0000-0x000000003ffeffff] reserved
> [    0.000000] BIOS-e820: [mem 0x000000003fff0000-0x000000003fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
> [    0.000000] printk: bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] DMI not present or invalid.
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 2238e001, primary cpu clock
> [    0.000001] kvm-clock: using sched offset of 100318497884 cycles
> [    0.001055] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
> [    0.004086] tsc: Detected 2399.998 MHz processor
> [    0.005147] last_pfn = 0x40000 max_arch_pfn = 0x400000000
> [    0.006234] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
> Memory KASLR using RDRAND RDTSC...
> [    0.008079] x2apic: enabled by BIOS, switching to x2apic ops
> [    0.020284] RAMDISK: [mem 0x3b8da000-0x3d5fffff]
> [    0.021169] ACPI: Early table checksum verification disabled
> [    0.022280] ACPI BIOS Error (bug): A valid RSDP was not found (20181213/tbxfroot-210)
> [    0.023755] No NUMA configuration found
> [    0.024461] Faking a node at [mem 0x0000000000000000-0x000000003fffffff]
> [    0.025746] NODE_DATA(0) allocated [mem 0x3ffa6000-0x3ffcffff]
> [    0.027098] crashkernel: memory value expected
> [    0.027918] Zone ranges:
> [    0.028384]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.029553]   DMA32    [mem 0x0000000001000000-0x000000003fffffff]
> [    0.030688]   Normal   empty
> [    0.031217]   Device   empty
> [    0.031741] Movable zone start for each node
> [    0.032525] Early memory node ranges
> [    0.033212]   node   0: [mem 0x0000000000001000-0x000000000009ffff]
> [    0.034377]   node   0: [mem 0x0000000000100000-0x000000003ed74fff]
> [    0.035520]   node   0: [mem 0x000000003ee87000-0x000000003ff06fff]
> [    0.036663]   node   0: [mem 0x000000003ff6b000-0x000000003ffcffff]
> [    0.037840]   node   0: [mem 0x000000003fff0000-0x000000003fffffff]
> [    0.039012] Zeroed struct page in unavailable ranges: 503 pages
> [    0.039013] Initmem setup node 0 [mem 0x0000000000001000-0x000000003fffffff]
> [    0.044319] BUG: unable to handle kernel paging request at ffffffffff5fd020
> [    0.045637] #PF error: [normal kernel read fault]
> [    0.046501] PGD 2200e067 P4D 2200e067 PUD 22010067 PMD 22011067 PTE 0
> [    0.047682] Oops: 0000 [#1] SMP
> [    0.048258] CPU: 0 PID: 0 Comm: swapper Not tainted 5.0.0-dirty #2
> [    0.049419] RIP: 0010:native_apic_mem_read+0x3/0x10
> [    0.050328] Code: 00 00 e8 20 3a 2b 00 48 89 d8 5b 5d c3 90 90 90 90 90 90 90 90 90 90 55 89 ff 48 89 e5 89 b7 00 d0 5f ff 5d c3 66 90 55 89 ff <8b> 87 00 d0 5f ff 48 89 e5 5d c3 66 90 e8 7b 8a 5b 00 55 b8 01 00
> [    0.053749] RSP: 0000:ffffffff88003e38 EFLAGS: 00010002
> [    0.054703] RAX: ffffffff87248840 RBX: 000000003fe09000 RCX: 0000000000000000
> [    0.056009] RDX: ffffffff88003e30 RSI: 000000000000f800 RDI: 0000000000000020
> [    0.057346] RBP: ffffffff88003e48 R08: 0000000000000000 R09: 0000000000000000
> [    0.058667] R10: 00000000000000ff R11: 0000000000000000 R12: 0000000001d254d6
> [    0.059969] R13: 000000003d600000 R14: 0000000000000000 R15: 0000000000000000
> [    0.061313] FS:  0000000000000000(0000) GS:ffffffff88173000(0000) knlGS:0000000000000000
> [    0.062812] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.063865] CR2: ffffffffff5fd020 CR3: 000000002200d000 CR4: 00000000000406b0
> [    0.065222] Call Trace:
> [    0.065670]  ? read_apic_id+0x19/0x30
> [    0.066347]  init_apic_mappings+0x7a/0x129
> [    0.067096]  setup_arch+0xb67/0xc19
> [    0.067729]  start_kernel+0x6b/0x4e3
> [    0.068386]  x86_64_start_reservations+0x24/0x26
> [    0.069230]  x86_64_start_kernel+0x6f/0x72
> [    0.069974]  secondary_startup_64+0xa4/0xb0
> [    0.070739] Modules linked in:
> [    0.071297] CR2: ffffffffff5fd020
> [    0.071901] random: get_random_bytes called from print_oops_end_marker+0x3f/0x60 with crng_init=0
> [    0.073567] ---[ end trace 2cc66932e568af60 ]---
> [    0.074427] RIP: 0010:native_apic_mem_read+0x3/0x10
> [    0.075320] Code: 00 00 e8 20 3a 2b 00 48 89 d8 5b 5d c3 90 90 90 90 90 90 90 90 90 90 55 89 ff 48 89 e5 89 b7 00 d0 5f ff 5d c3 66 90 55 89 ff <8b> 87 00 d0 5f ff 48 89 e5 5d c3 66 90 e8 7b 8a 5b 00 55 b8 01 00
> [    0.078755] RSP: 0000:ffffffff88003e38 EFLAGS: 00010002
> [    0.079741] RAX: ffffffff87248840 RBX: 000000003fe09000 RCX: 0000000000000000
> [    0.081050] RDX: ffffffff88003e30 RSI: 000000000000f800 RDI: 0000000000000020
> [    0.082355] RBP: ffffffff88003e48 R08: 0000000000000000 R09: 0000000000000000
> [    0.083687] R10: 00000000000000ff R11: 0000000000000000 R12: 0000000001d254d6
> [    0.084996] R13: 000000003d600000 R14: 0000000000000000 R15: 0000000000000000
> [    0.086296] FS:  0000000000000000(0000) GS:ffffffff88173000(0000) knlGS:0000000000000000
> [    0.087805] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.088855] CR2: ffffffffff5fd020 CR3: 000000002200d000 CR4: 00000000000406b0
> [    0.090167] Kernel panic - not syncing: Fatal exception
> [    0.091160] BUG: unable to handle kernel paging request at ffffffffff5fd030
> [    0.092438] #PF error: [normal kernel read fault]
> [    0.093301] PGD 2200e067 P4D 2200e067 PUD 22010067 PMD 22011067 PTE 0
> [    0.094480] Oops: 0000 [#2] SMP
> [    0.095094] CPU: 0 PID: 0 Comm: swapper Tainted: G      D           5.0.0-dirty #2
> [    0.096478] RIP: 0010:native_apic_mem_read+0x3/0x10
> [    0.097367] Code: 00 00 e8 20 3a 2b 00 48 89 d8 5b 5d c3 90 90 90 90 90 90 90 90 90 90 55 89 ff 48 89 e5 89 b7 00 d0 5f ff 5d c3 66 90 55 89 ff <8b> 87 00 d0 5f ff 48 89 e5 5d c3 66 90 e8 7b 8a 5b 00 55 b8 01 00
> [    0.100833] RSP: 0000:ffffffff88003aa8 EFLAGS: 00010002
> [    0.101792] RAX: ffffffff87248840 RBX: 0000000000000046 RCX: 0000000000000000
> [    0.103130] RDX: 0000000000000080 RSI: 0000000000002000 RDI: 0000000000000030
> [    0.104433] RBP: ffffffff88003ac0 R08: 0000000000000001 R09: 0000000000000080
> [    0.105733] R10: ffffffff88160ca0 R11: ffffffff8818a428 R12: 0000000000000000
> [    0.107070] R13: 0000000000000046 R14: ffffffff88013740 R15: 000000000000000b
> [    0.108382] FS:  0000000000000000(0000) GS:ffffffff88173000(0000) knlGS:0000000000000000
> [    0.109872] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.110926] CR2: ffffffffff5fd030 CR3: 000000002200d000 CR4: 00000000000406b0
> [    0.112265] Call Trace:
> [    0.112712]  ? clear_local_APIC+0x37/0x2f0
> [    0.113463]  disable_local_APIC+0x22/0x60
> [    0.114200]  native_stop_other_cpus+0xc8/0x160
> [    0.115048]  panic+0x11a/0x2a8
> [    0.115606]  oops_end+0xc1/0xd0
> [    0.116188]  no_context+0x1eb/0x550
> [    0.116826]  __bad_area_nosemaphore.constprop.30+0x50/0x1d0
> [    0.117852]  bad_area_nosemaphore+0x13/0x20
> [    0.118618]  do_kern_addr_fault+0x5c/0x90
> [    0.119387]  __do_page_fault+0x382/0x440
> [    0.120109]  ? memmap_init_zone+0x8f/0x22d
> [    0.120851]  do_page_fault+0x32/0x120
> [    0.121521]  page_fault+0x1e/0x30
> [    0.122128] RIP: 0010:native_apic_mem_read+0x3/0x10
> [    0.123045] Code: 00 00 e8 20 3a 2b 00 48 89 d8 5b 5d c3 90 90 90 90 90 90 90 90 90 90 55 89 ff 48 89 e5 89 b7 00 d0 5f ff 5d c3 66 90 55 89 ff <8b> 87 00 d0 5f ff 48 89 e5 5d c3 66 90 e8 7b 8a 5b 00 55 b8 01 00
> [    0.126481] RSP: 0000:ffffffff88003e38 EFLAGS: 00010002
> [    0.127502] RAX: ffffffff87248840 RBX: 000000003fe09000 RCX: 0000000000000000
> [    0.128807] RDX: ffffffff88003e30 RSI: 000000000000f800 RDI: 0000000000000020
> [    0.130161] RBP: ffffffff88003e48 R08: 0000000000000000 R09: 0000000000000000
> [    0.131464] R10: 00000000000000ff R11: 0000000000000000 R12: 0000000001d254d6
> [    0.132771] R13: 000000003d600000 R14: 0000000000000000 R15: 0000000000000000
> [    0.134081]  ? native_apic_mem_write+0x10/0x10
> [    0.134892]  ? read_apic_id+0x19/0x30
> [    0.135564]  init_apic_mappings+0x7a/0x129
> [    0.136316]  setup_arch+0xb67/0xc19
> [    0.136954]  start_kernel+0x6b/0x4e3
> [    0.137656]  x86_64_start_reservations+0x24/0x26
> [    0.138576]  x86_64_start_kernel+0x6f/0x72
> [    0.139329]  secondary_startup_64+0xa4/0xb0
> [    0.140096] Modules linked in:
> [    0.140653] CR2: ffffffffff5fd030
> [    0.141259] ---[ end trace 2cc66932e568af61 ]---
> [    0.142102] RIP: 0010:native_apic_mem_read+0x3/0x10
> [    0.142992] Code: 00 00 e8 20 3a 2b 00 48 89 d8 5b 5d c3 90 90 90 90 90 90 90 90 90 90 55 89 ff 48 89 e5 89 b7 00 d0 5f ff 5d c3 66 90 55 89 ff <8b> 87 00 d0 5f ff 48 89 e5 5d c3 66 90 e8 7b 8a 5b 00 55 b8 01 00
> [    0.146520] RSP: 0000:ffffffff88003e38 EFLAGS: 00010002
> [    0.147533] RAX: ffffffff87248840 RBX: 000000003fe09000 RCX: 0000000000000000
> [    0.148845] RDX: ffffffff88003e30 RSI: 000000000000f800 RDI: 0000000000000020
> [    0.150191] RBP: ffffffff88003e48 R08: 0000000000000000 R09: 0000000000000000
> [    0.151492] R10: 00000000000000ff R11: 0000000000000000 R12: 0000000001d254d6
> [    0.152796] R13: 000000003d600000 R14: 0000000000000000 R15: 0000000000000000
> [    0.154103] FS:  0000000000000000(0000) GS:ffffffff88173000(0000) knlGS:0000000000000000
> [    0.155579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.156625] CR2: ffffffffff5fd030 CR3: 000000002200d000 CR4: 00000000000406b0
> [    0.157967] Kernel panic - not syncing: Fatal exception
> <repeating panic>
> 
> 
> Libvirt configuration of the VM looks like this:
> 
>   <os>
>     <type arch='x86_64' machine='pc'>hvm</type>
>     <loader readonly='yes' type='pflash'>/usr/share/edk2.git/ovmf-ia32/OVMF_CODE-pure-efi.fd</loader>
>     <nvram template='/usr/share/edk2.git/ovmf-ia32/OVMF_VARS-pure-efi.fd'>/var/lib/libvirt/qemu/nvram/vm76_VARS-32.fd</nvram>
>     <kernel>/var/lib/libvirt/boot/vmlinuz-5.0.0-dirty</kernel>
>     <initrd>/var/lib/libvirt/boot/initramfs-5.0.0-dirty.img</initrd>
>     <cmdline>root=UUID=6bea2b7b-e6cc-4dba-ac79-be6530d348f5 ro console=tty0 console=ttyS0,115200n8 no_timer_check net.ifnames=0 crashkernel=auto LANG=en_US.UTF-8 earlyprintk=serial,ttyS0,115200</cmdline>
>     <boot dev='hd'/>
>   </os>
> 
> -- 
> Jun'ichi Nomura, NEC Corporation / NEC Solution Innovators, Ltd.
