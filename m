From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 08/10] efi/x86: Move EFI BGRT init code to early init code
Date: Mon, 15 May 2017 16:37:40 +0800
Message-ID: <20170515083740.GA30363@dhcp-128-65.nay.redhat.com>
References: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485868902-20401-9-git-send-email-ard.biesheuvel@linaro.org>
 <20170513231827.GA1068@bistromath.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170513231827.GA1068@bistromath.localdomain>
Sender: linux-acpi-owner@vger.kernel.org
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi,

Thanks for the report.
On 05/14/17 at 01:18am, Sabrina Dubroca wrote:
> 2017-01-31, 13:21:40 +0000, Ard Biesheuvel wrote:
> > From: Dave Young <dyoung@redhat.com>
> > 
> > Before invoking the arch specific handler, efi_mem_reserve() reserves
> > the given memory region through memblock.
> > 
> > efi_bgrt_init() will call efi_mem_reserve() after mm_init(), at which
> > time memblock is dead and should not be used anymore.
> > 
> > The EFI BGRT code depends on ACPI initialization to get the BGRT ACPI
> > table, so move parsing of the BGRT table to ACPI early boot code to
> > ensure that efi_mem_reserve() in EFI BGRT code still use memblock safely.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > Cc: Matt Fleming <matt@codeblueprint.co.uk>
> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: linux-acpi@vger.kernel.org
> > Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> I have a box that panics in early boot after this patch. The kernel
> config is based on a Fedora 25 kernel + localmodconfig.
> 
> BUG: unable to handle kernel paging request at ffffffffff240001
> IP: efi_bgrt_init+0xdc/0x134
> PGD 1ac0c067
> PUD 1ac0e067
> PMD 1aee9067
> PTE 9380701800000163
> 
> Oops: 0009 [#1] SMP
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper Not tainted 4.10.0-rc5-00116-g7b0a911 #19
> Hardware name: Hewlett-Packard HP Z220 CMT Workstation/1790, BIOS K51 v01.02 05/03/2012
> task: ffffffff9fc10500 task.stack: ffffffff9fc00000
> RIP: 0010:efi_bgrt_init+0xdc/0x134
> RSP: 0000:ffffffff9fc03d58 EFLAGS: 00010082
> RAX: ffffffffff240001 RBX: 0000000000000000 RCX: 1380701800000006
> RDX: 8000000000000163 RSI: 9380701800000163 RDI: 00000000000005be
> RBP: ffffffff9fc03d70 R08: 1380701800001000 R09: 0000000000000002
> R10: 000000000002d000 R11: ffff98a3dedd2fc6 R12: ffffffff9f9f22b6
> R13: ffffffff9ff49480 R14: 0000000000000010 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffffff9fd20000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffff240001 CR3: 000000001ac09000 CR4: 00000000000406b0
> Call Trace:
>  ? acpi_parse_ioapic+0x98/0x98
>  acpi_parse_bgrt+0x9/0xd
>  acpi_table_parse+0x7a/0xa9
>  acpi_boot_init+0x3c7/0x4f9
>  ? acpi_parse_x2apic+0x74/0x74
>  ? acpi_parse_x2apic_nmi+0x46/0x46
>  setup_arch+0xb4b/0xc6f
>  ? printk+0x52/0x6e
>  start_kernel+0xb2/0x47b
>  ? early_idt_handler_array+0x120/0x120
>  x86_64_start_reservations+0x24/0x26
>  x86_64_start_kernel+0xf7/0x11a
>  start_cpu+0x14/0x14
> Code: 48 c7 c7 10 16 a0 9f e8 4e 94 40 ff eb 62 be 06 00 00 00 e8 f9 ff 00 00 48 85 c0 75 0e 48 c7 c7 40 16 a0 9f e8 31 94 40 ff eb 45 <66> 44 8b 20 be 06 00 00 00 48 89 c7 8b 58 02 e8 87 00 01 00 66
> RIP: efi_bgrt_init+0xdc/0x134 RSP: ffffffff9fc03d58
> CR2: ffffffffff240001
> ---[ end trace f68728a0d3053b52 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> 
> 
> That code is:
> 
> 
> All code
> ========
>    0:	48 c7 c7 10 16 a0 9f 	mov    $0xffffffff9fa01610,%rdi
>    7:	e8 4e 94 40 ff       	callq  0xffffffffff40945a
>    c:	eb 62                	jmp    0x70
>    e:	be 06 00 00 00       	mov    $0x6,%esi
>   13:	e8 f9 ff 00 00       	callq  0x10011
>   18:	48 85 c0             	test   %rax,%rax
>   1b:	75 0e                	jne    0x2b
>   1d:	48 c7 c7 40 16 a0 9f 	mov    $0xffffffff9fa01640,%rdi
>   24:	e8 31 94 40 ff       	callq  0xffffffffff40945a
>   29:	eb 45                	jmp    0x70
>   2b:*	66 44 8b 20          	mov    (%rax),%r12w		<-- trapping instruction
>   2f:	be 06 00 00 00       	mov    $0x6,%esi
>   34:	48 89 c7             	mov    %rax,%rdi
>   37:	8b 58 02             	mov    0x2(%rax),%ebx
>   3a:	e8 87 00 01 00       	callq  0x100c6
>   3f:	66                   	data16
> 
> Code starting with the faulting instruction
> ===========================================
>    0:	66 44 8b 20          	mov    (%rax),%r12w
>    4:	be 06 00 00 00       	mov    $0x6,%esi
>    9:	48 89 c7             	mov    %rax,%rdi
>    c:	8b 58 02             	mov    0x2(%rax),%ebx
>    f:	e8 87 00 01 00       	callq  0x1009b
>   14:	66                   	data16
> 
> 
> which is just after the early_memremap() call.
> 
> I enabled early_ioremap_debug and the last warning had:
> 
> __early_ioremap(1380701800001000, 00001000) [1] => 00000001 + ffffffffff240000

The phys addr looks odd..

>From the kernel log, I do not see any efi messages so can you check if
you are booting with legacy mode or efi boot?

I suppose bgrt are efi only, if you are test with legacy boot it is odd
that there is BGRT table populated.

For debugging purpose maybe you can add some printk to dump the acpi
table header in efi_bgrt_init function, just print the version, status,
image_type, image_address.

If you can prove it is a non-efi boot, then maybe you can test below
patch:


diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index 04ca876..b986e26 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -36,6 +36,9 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 	if (acpi_disabled)
 		return;
 
+	if (!efi_enabled(EFI_CONFIG_TABLES))
+		return;
+
 	if (table->length < sizeof(bgrt_tab)) {
 		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
 		       table->length, sizeof(bgrt_tab));

> 
> 
> 
> Rest of the log, in case there's anything useful in there:
> 
> 
> Linux version 4.10.0-rc5-00116-g7b0a911 (root@netdev4) (gcc version 6.3.1 20161221 (Red Hat 6.3.1-1) (GCC) ) #19 SMP Sat May 13 23:16:09 CEST 2017
> Command line: BOOT_IMAGE=/vmlinuz-4.10.0-rc5-00116-g7b0a911 root=UUID=3b849e12-46bd-4406-a2ec-f44238a55d56 ro console=ttyS0,115200 earlyprintk=serial,0x000003F8,115200
> x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
> x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
> e820: BIOS-provided physical RAM map:
> BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
> BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
> BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
> BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
> BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
> BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
> BIOS-e820: [mem 0x0000000040005000-0x00000000d9362fff] usable
> BIOS-e820: [mem 0x00000000d9363000-0x00000000d9940fff] reserved
> BIOS-e820: [mem 0x00000000d9941000-0x00000000d9ba7fff] ACPI NVS
> BIOS-e820: [mem 0x00000000d9ba8000-0x00000000d9bb7fff] ACPI data
> BIOS-e820: [mem 0x00000000d9bb8000-0x00000000d9bc0fff] ACPI NVS
> BIOS-e820: [mem 0x00000000d9bc1000-0x00000000d9bc5fff] ACPI data
> BIOS-e820: [mem 0x00000000d9bc6000-0x00000000d9c08fff] ACPI NVS
> BIOS-e820: [mem 0x00000000d9c09000-0x00000000d9ffffff] usable
> BIOS-e820: [mem 0x00000000db000000-0x00000000df1fffff] reserved
> BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
> BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed44fff] reserved
> BIOS-e820: [mem 0x00000000fed90000-0x00000000fed93fff] reserved
> BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> BIOS-e820: [mem 0x0000000100000000-0x000000011edfffff] usable
> bootconsole [earlyser0] enabled
> NX (Execute Disable) protection: active
> SMBIOS 2.7 present.
> DMI: Hewlett-Packard HP Z220 CMT Workstation/1790, BIOS K51 v01.02 05/03/2012
> e820: last_pfn = 0x11ee00 max_arch_pfn = 0x400000000
> x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT
> ing RDTSC...
> e820: last_pfn = 0xda000 max_arch_pfn = 0x400000000
> found SMP MP-table at [mem 0x000f4ea0-0x000f4eaf] mapped at [ffff98a2c00f4ea0]
> RAMDISK: [mem 0x366ed000-0x3736efff]
> ACPI: Early table checksum verification disabled
> ACPI: RSDP 0x00000000000F9810 000024 (v02 HPQOEM)
> ACPI: XSDT 0x00000000D9BA8080 00007C (v01 HPQOEM SLIC-WKS 01072009 AMI  00010013)
> ACPI: FACP 0x00000000D9BB10F0 0000F4 (v04 HPQOEM SLIC-WKS 01072009 AMI  00010013)
> ACPI: DSDT 0x00000000D9BA8188 008F67 (v02 HPQOEM SLIC-WKS 00000051 INTL 20051117)
> ACPI: FACS 0x00000000D9BB8F80 000040
> ACPI: APIC 0x00000000D9BB11E8 000084 (v03 HPQOEM SLIC-WKS 01072009 AMI  00010013)
> ACPI: MCFG 0x00000000D9BB1270 00003C (v01 HPQOEM SLIC-WKS 01072009 MSFT 00000097)
> ACPI: HPET 0x00000000D9BB12B0 000038 (v01 HPQOEM SLIC-WKS 01072009 AMI. 00000005)
> ACPI: SSDT 0x00000000D9BB12E8 00036D (v01 SataRe SataTabl 00001000 INTL 20091112)
> ACPI: SSDT 0x00000000D9BB1658 005270 (v01 COMPAQ WMI      00000001 MSFT 03000001)
> ACPI: SLIC 0x00000000D9BB68C8 000176 (v01 HPQOEM SLIC-WKS 00000001      00000000)
> ACPI: SSDT 0x00000000D9BB6A40 0009AA (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
> ACPI: SSDT 0x00000000D9BB73F0 000A92 (v01 PmRef  CpuPm    00003000 INTL 20051117)
> ACPI: ASF! 0x00000000D9BB7E88 0000A5 (v32 INTEL   HCG     00000001 TFSM 000F4240)
> ACPI: BGRT 0x00000000D9BB7F30 00003C (v00 HPQOEM SLIC-WKS 01072009 AMI  00010013)
> No NUMA configuration found
> Faking a node at [mem 0x0000000000000000-0x000000011edfffff]
> NODE_DATA(0) allocated [mem 0x11edd5000-0x11edfffff]
> Zone ranges:
>   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
>   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
>   Normal   [mem 0x0000000100000000-0x000000011edfffff]
>   Device   empty
> Movable zone start for each node
> Early memory node ranges
>   node   0: [mem 0x0000000000001000-0x0000000000092fff]
>   node   0: [mem 0x0000000000100000-0x000000001fffffff]
>   node   0: [mem 0x0000000020200000-0x0000000040003fff]
>   node   0: [mem 0x0000000040005000-0x00000000d9362fff]
>   node   0: [mem 0x00000000d9c09000-0x00000000d9ffffff]
>   node   0: [mem 0x0000000100000000-0x000000011edfffff]
> Initmem setup node 0 [mem 0x0000000000001000-0x000000011edfffff]
> Reserving Intel graphics memory at 0x00000000db200000-0x00000000df1fffff
> ACPI: PM-Timer IO Port: 0x408
> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x8086a701 base: 0xfed00000
> BUG: unable to handle kernel paging request at ffffffffff240001
> IP: efi_bgrt_init+0xdc/0x134
> PGD 1ac0c067
> PUD 1ac0e067
> PMD 1aee9067
> PTE 9380701800000163
> 
> Oops: 0009 [#1] SMP
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper Not tainted 4.10.0-rc5-00116-g7b0a911 #19
> Hardware name: Hewlett-Packard HP Z220 CMT Workstation/1790, BIOS K51 v01.02 05/03/2012
> task: ffffffff9fc10500 task.stack: ffffffff9fc00000
> RIP: 0010:efi_bgrt_init+0xdc/0x134
> RSP: 0000:ffffffff9fc03d58 EFLAGS: 00010082
> RAX: ffffffffff240001 RBX: 0000000000000000 RCX: 1380701800000006
> RDX: 8000000000000163 RSI: 9380701800000163 RDI: 00000000000005be
> RBP: ffffffff9fc03d70 R08: 1380701800001000 R09: 0000000000000002
> R10: 000000000002d000 R11: ffff98a3dedd2fc6 R12: ffffffff9f9f22b6
> R13: ffffffff9ff49480 R14: 0000000000000010 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffffffff9fd20000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffff240001 CR3: 000000001ac09000 CR4: 00000000000406b0
> Call Trace:
>  ? acpi_parse_ioapic+0x98/0x98
>  acpi_parse_bgrt+0x9/0xd
>  acpi_table_parse+0x7a/0xa9
>  acpi_boot_init+0x3c7/0x4f9
>  ? acpi_parse_x2apic+0x74/0x74
>  ? acpi_parse_x2apic_nmi+0x46/0x46
>  setup_arch+0xb4b/0xc6f
>  ? printk+0x52/0x6e
>  start_kernel+0xb2/0x47b
>  ? early_idt_handler_array+0x120/0x120
>  x86_64_start_reservations+0x24/0x26
>  x86_64_start_kernel+0xf7/0x11a
>  start_cpu+0x14/0x14
> Code: 48 c7 c7 10 16 a0 9f e8 4e 94 40 ff eb 62 be 06 00 00 00 e8 f9 ff 00 00 48 85 c0 75 0e 48 c7 c7 40 16 a0 9f e8 31 94 40 ff eb 45 <66> 44 8b 20 be 06 00 00 00 48 89 c7 8b 58 02 e8 87 00 01 00 66
> RIP: efi_bgrt_init+0xdc/0x134 RSP: ffffffff9fc03d58
> CR2: ffffffffff240001
> ---[ end trace f68728a0d3053b52 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> 
> 
> -- 
> Sabrina

Thanks
Dave
