From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [tip regression]  efi: Allow drivers to reserve boot services
 forever == toxic
Date: Fri, 16 Sep 2016 12:00:59 +0200
Message-ID: <1474020059.3881.3.camel@gmail.com>
References: <1474005912.3930.10.camel@gmail.com>
         <20160916093149.GC16797@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160916093149.GC16797-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 2016-09-16 at 10:31 +0100, Matt Fleming wrote:
> On Fri, 16 Sep, at 08:05:12AM, Mike Galbraith wrote:
> > Hi Matt,
> > 
> > My workstation started instant rebooting with tip.  I bisected it to..
> > 
> >    efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()
> > 
> > ..but seems it's really $subject, as box works fine with the below.
> > 
> > ---
> >  drivers/firmware/efi/efi.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- a/drivers/firmware/efi/efi.c
> > +++ b/drivers/firmware/efi/efi.c
> > @@ -415,6 +415,7 @@ void __init efi_mem_reserve(phys_addr_t
> >  {
> >  > > 	> > if (!memblock_is_region_reserved(addr, size))
> >  > > 	> > 	> > memblock_reserve(addr, size);
> > +> > 	> > else
> >  
> >  > > 	> > /*
> >  > > 	> >  * Some architectures (x86) reserve all boot services ranges
> > 
> > 
> > No idea what's going boom down in efi_arch_mem_reserve().
> 
> Urgh, that's bad. Which machine is this? Can you paste the dmesg after
> booting with the efi=debug kernel parameter, either with your above
> patch or with the commit reverted?

Ok, here's the whole thing just in case.  Hope it's not too big.

[    0.000000] microcode: microcode updated early to revision 0x20, date = 2016-03-16
[    0.000000] Linux version 4.8.0-tip (git@homer) (gcc version 4.8.5 (SUSE Linux) ) #68 SMP Fri Sep 16 07:40:25 CEST 2016
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.8.0-tip root=UUID=63d8c9f4-c094-4dd8-96cd-23c5e91d0322 ro nortsched hpc_cpusets nr_cpus=8 skew_tick=1 ftrace_dump_on_oops audit=0 nowatchdog console=ttyUSB0,115200n8 resume=/dev/disk/by-uuid/0de200a9-5ce0-4471-b94d-0360934d3430 showopts panic=60 ignore_loglevel cgroup_disable=memory crashkernel=256M,high crashkernel=131M,low nomodeset call_trace=old efi=debug
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000d0443fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d0444000-0x00000000d044afff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d044b000-0x00000000d0889fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d088a000-0x00000000d0b4afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d0b4b000-0x00000000de787fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de788000-0x00000000de811fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000de812000-0x00000000de828fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000de829000-0x00000000de98dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000de98e000-0x00000000deffefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000defff000-0x00000000deffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041effffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0xd0142018-0xd0163a57] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000059000-0x000000000009dfff] usable
[    0.000000] reserve setup_data: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000d0142017] usable
[    0.000000] reserve setup_data: [mem 0x00000000d0142018-0x00000000d0163a57] usable
[    0.000000] reserve setup_data: [mem 0x00000000d0163a58-0x00000000d0443fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000d0444000-0x00000000d044afff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000d044b000-0x00000000d0889fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000d088a000-0x00000000d0b4afff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000d0b4b000-0x00000000de787fff] usable
[    0.000000] reserve setup_data: [mem 0x00000000de788000-0x00000000de811fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000de812000-0x00000000de828fff] ACPI data
[    0.000000] reserve setup_data: [mem 0x00000000de829000-0x00000000de98dfff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x00000000de98e000-0x00000000deffefff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000defff000-0x00000000deffffff] usable
[    0.000000] reserve setup_data: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000041effffff] usable
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ESRT=0xdef87998  ACPI=0xde816000  ACPI 2.0=0xde816000  SMBIOS=0xdef87598 
[    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000000fff] (0MB)
[    0.000000] efi: mem01: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000001fff] (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000002000-0x0000000000057fff] (0MB)
[    0.000000] efi: mem03: [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000058000-0x0000000000058fff] (0MB)
[    0.000000] efi: mem04: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000059000-0x000000000009dfff] (0MB)
[    0.000000] efi: mem05: [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000000009e000-0x000000000009ffff] (0MB)
[    0.000000] efi: mem06: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x0000000000ffffff] (15MB)
[    0.000000] efi: mem07: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000001000000-0x0000000002317fff] (19MB)
[    0.000000] efi: mem08: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000002318000-0x000000003f65cfff] (979MB)
[    0.000000] efi: mem09: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x000000003f65d000-0x000000003fffffff] (9MB)
[    0.000000] efi: mem10: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000040000000-0x00000000959f5fff] (1369MB)
[    0.000000] efi: mem11: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000959f6000-0x00000000ccc67fff] (882MB)
[    0.000000] efi: mem12: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000ccc68000-0x00000000d0141fff] (52MB)
[    0.000000] efi: mem13: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d0142000-0x00000000d0341fff] (2MB)
[    0.000000] efi: mem14: [Loader Code        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d0342000-0x00000000d0443fff] (1MB)
[    0.000000] efi: mem15: [ACPI Memory NVS    |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d0444000-0x00000000d044afff] (0MB)
[    0.000000] efi: mem16: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d044b000-0x00000000d059ffff] (1MB)
[    0.000000] efi: mem17: [Boot Code          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d05a0000-0x00000000d0849fff] (2MB)
[    0.000000] efi: mem18: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d084a000-0x00000000d0865fff] (0MB)
[    0.000000] efi: mem19: [Boot Code          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d0866000-0x00000000d087ffff] (0MB)
[    0.000000] efi: mem20: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d0880000-0x00000000d0889fff] (0MB)
[    0.000000] efi: mem21: [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d088a000-0x00000000d0b4afff] (2MB)
[    0.000000] efi: mem22: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d0b4b000-0x00000000d0b57fff] (0MB)
[    0.000000] efi: mem23: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d0b58000-0x00000000d0b64fff] (0MB)
[    0.000000] efi: mem24: [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d0b65000-0x00000000d0b66fff] (0MB)
[    0.000000] efi: mem25: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d0b67000-0x00000000dcd30fff] (193MB)
[    0.000000] efi: mem26: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000dcd31000-0x00000000dcf41fff] (2MB)
[    0.000000] efi: mem27: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000dcf42000-0x00000000dcf46fff] (0MB)
[    0.000000] efi: mem28: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000dcf47000-0x00000000de091fff] (17MB)
[    0.000000] efi: mem29: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000de092000-0x00000000de51cfff] (4MB)
[    0.000000] efi: mem30: [Boot Code          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000de51d000-0x00000000de787fff] (2MB)
[    0.000000] efi: mem31: [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000de788000-0x00000000de7b4fff] (0MB)
[    0.000000] efi: mem32: [Reserved           |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000de7b5000-0x00000000de811fff] (0MB)
[    0.000000] efi: mem33: [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000de812000-0x00000000de815fff] (0MB)
[    0.000000] efi: mem34: [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000de816000-0x00000000de828fff] (0MB)
[    0.000000] efi: mem35: [ACPI Memory NVS    |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000de829000-0x00000000de876fff] (0MB)
[    0.000000] efi: mem36: [ACPI Memory NVS    |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000de877000-0x00000000de98dfff] (1MB)
[    0.000000] efi: mem37: [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000de98e000-0x00000000ded80fff] (3MB)
[    0.000000] efi: mem38: [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000ded81000-0x00000000def88fff] (2MB)
[    0.000000] efi: mem39: [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000def89000-0x00000000def9ffff] (0MB)
[    0.000000] efi: mem40: [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000defa0000-0x00000000deffefff] (0MB)
[    0.000000] efi: mem41: [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x00000000defff000-0x00000000deffffff] (0MB)
[    0.000000] efi: mem42: [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x000000041effffff] (12784MB)
[    0.000000] efi: mem43: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC] range=[0x00000000f8000000-0x00000000fbffffff] (64MB)
[    0.000000] efi: mem44: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC] range=[0x00000000fec00000-0x00000000fec00fff] (0MB)
[    0.000000] efi: mem45: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC] range=[0x00000000fed00000-0x00000000fed03fff] (0MB)
[    0.000000] efi: mem46: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC] range=[0x00000000fed1c000-0x00000000fed1ffff] (0MB)
[    0.000000] efi: mem47: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC] range=[0x00000000fee00000-0x00000000fee00fff] (0MB)
[    0.000000] efi: mem48: [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC] range=[0x00000000ff000000-0x00000000ffffffff] (16MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: MEDION MS-7848/MS-7848, BIOS M7848W08.20C 09/23/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x41f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7C00000000 write-back
[    0.000000]   1 base 0400000000 mask 7FF0000000 write-back
[    0.000000]   2 base 0410000000 mask 7FF8000000 write-back
[    0.000000]   3 base 0418000000 mask 7FFC000000 write-back
[    0.000000]   4 base 041C000000 mask 7FFE000000 write-back
[    0.000000]   5 base 041E000000 mask 7FFF000000 write-back
[    0.000000]   6 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- WT  
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf000 max_arch_pfn = 0x400000000
[    0.000000] esrt: Reserving ESRT space from 0x00000000def87998 to 0x00000000def879d0.
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x020a2000, 0x020a2fff] PGTABLE
[    0.000000] BRK [0x020a3000, 0x020a3fff] PGTABLE
[    0.000000] BRK [0x020a4000, 0x020a4fff] PGTABLE
[    0.000000] BRK [0x020a5000, 0x020a5fff] PGTABLE
[    0.000000] BRK [0x020a6000, 0x020a6fff] PGTABLE
[    0.000000] BRK [0x020a7000, 0x020a7fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3f65d000-0x3fffafff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DE816000 000024 (v02 MEDION)
[    0.000000] ACPI: XSDT 0x00000000DE816088 00008C (v01 MEDION MEDIONAG 11112011 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DE822CC8 00010C (v05 MEDION MEDIONAG 11112011 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DE8161A0 00CB24 (v02 MEDION MEDIONAG 00000028 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000DE98C080 000040
[    0.000000] ACPI: APIC 0x00000000DE822DD8 000092 (v03 MEDION MEDIONAG 11112011 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DE822E70 000044 (v01 MEDION MEDIONAG 11112011 AMI  00010013)
[    0.000000] ACPI: MSDM 0x00000000DE822EB8 000055 (v03 MEDION MEDIONAG 11112011 AMI  00010013)
[    0.000000] ACPI: LPIT 0x00000000DE822F10 00005C (v01 MEDION MEDIONAG 00000000 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000DE822F70 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DE8234B0 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20120711)
[    0.000000] ACPI: MCFG 0x00000000DE823F88 00003C (v01 MEDION MEDIONAG 11112011 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000DE823FC8 000038 (v01 MEDION MEDIONAG 11112011 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000DE824000 000443 (v01 SataRe SataTabl 00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DE824448 0033CE (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
[    0.000000] ACPI: DMAR 0x00000000DE827818 000080 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.000000] ACPI: SSDT 0x00000000DE827898 000A26 (v01 Intel_ IsctTabl 00001000 INTL 20120711)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041effffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x41efd2000-0x41effbfff]
[    0.000000] Reserving 131MB of low memory at 3392MB for crashkernel (System low RAM: 3556MB)
[    0.000000] Reserving 256MB of memory at 16608MB for crashkernel (System RAM: 16340MB)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000041effffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.000000]   node   0: [mem 0x0000000000059000-0x000000000009dfff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000d0443fff]
[    0.000000]   node   0: [mem 0x00000000d044b000-0x00000000d0889fff]
[    0.000000]   node   0: [mem 0x00000000d0b4b000-0x00000000de787fff]
[    0.000000]   node   0: [mem 0x00000000defff000-0x00000000deffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000041effffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000041effffff]
[    0.000000] On node 0 totalpages: 4183133
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14164 pages used for memmap
[    0.000000]   DMA32 zone: 906433 pages, LIFO batch:31
[    0.000000]   Normal zone: 51136 pages used for memmap
[    0.000000]   Normal zone: 3272704 pages, LIFO batch:31
[    0.000000] tboot: non-0 tboot_addr but it is not of type E820_RESERVED
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0142000-0xd0142fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0163000-0xd0163fff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0444000-0xd044afff]
[    0.000000] PM: Registered nosave memory: [mem 0xd088a000-0xd0b4afff]
[    0.000000] PM: Registered nosave memory: [mem 0xde788000-0xde811fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde812000-0xde828fff]
[    0.000000] PM: Registered nosave memory: [mem 0xde829000-0xde98dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xde98e000-0xdeffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf000000-0xf7ffffff]
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
[    0.000000] e820: [mem 0xdf000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645519600211568 ns
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] percpu: Embedded 34 pages/cpu @ffff88041ec00000 s99480 r8192 d31592 u262144
[    0.000000] pcpu-alloc: s99480 r8192 d31592 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 4117748
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: processor.max_cstate=1 intel_idle.max_cstate=1 skew_tick=1 hpc_cpusets threadsirqs BOOT_IMAGE=/boot/vmlinuz-4.8.0-tip root=UUID=63d8c9f4-c094-4dd8-96cd-23c5e91d0322 ro nortsched hpc_cpusets nr_cpus=8 skew_tick=1 ftrace_dump_on_oops audit=0 nowatchdog console=ttyUSB0,115200n8 resume=/dev/disk/by-uuid/0de200a9-5ce0-4471-b94d-0360934d3430 showopts panic=60 ignore_loglevel cgroup_disable=memory crashkernel=256M,high crashkernel=131M,low nomodeset call_trace=old efi=debug
[    0.000000] audit: disabled (until reboot)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 5485324K/16732532K available (6411K kernel code, 1196K rwdata, 2904K rodata, 1716K init, 1792K bss, 779840K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:16640 nr_irqs:488 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133484882848 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3591.592 MHz processor
[    0.000015] Calibrating delay loop (skipped), value calculated using timer frequency.. 7183.18 BogoMIPS (lpj=14366368)
[    0.000016] pid_max: default: 32768 minimum: 301
[    0.000020] ACPI: Core revision 20160422
[    0.010101] ACPI: 6 ACPI AML tables successfully acquired and loaded

[    0.010462] Security Framework initialized
[    0.010465] AppArmor: AppArmor initialized
[    0.010953] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.012822] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.013630] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.013639] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.013874] Disabling memory control group subsystem
[    0.013893] CPU: Physical Processor ID: 0
[    0.013894] CPU: Processor Core ID: 0
[    0.013897] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.013898] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.013900] mce: CPU supports 9 MCE banks
[    0.013906] CPU0: Thermal monitoring enabled (TM1)
[    0.013916] process: using mwait in idle threads
[    0.013918] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.013919] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.014142] Freeing SMP alternatives memory: 24K (ffffffff81eda000 - ffffffff81ee0000)
[    0.015782] ftrace: allocating 25276 entries in 99 pages
[    0.022546] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.022548] smpboot: Max logical packages: 2
[    0.022551] DMAR: Host address width 39
[    0.022552] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
[    0.022557] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap d2008c20660462 ecap f010da
[    0.022558] DMAR: RMRR base: 0x000000deeac000 end: 0x000000deebafff
[    0.022559] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed90000 IOMMU 0
[    0.022560] DMAR-IR: HPET id 0 under DRHD base 0xfed90000
[    0.022560] DMAR-IR: Queued invalidation will be enabled to support x2apic and Intr-remapping.
[    0.022694] DMAR-IR: Enabled IRQ remapping in x2apic mode
[    0.022695] x2apic enabled
[    0.022699] Switched APIC routing to cluster x2apic.
[    0.023101] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.062787] TSC deadline timer enabled
[    0.062789] smpboot: CPU0: Intel(R) Core(TM) i7-4790 CPU @ 3.60GHz (family: 0x6, model: 0x3c, stepping: 0x3)
[    0.062792] Performance Events: PEBS fmt2+, Haswell events, 16-deep LBR, full-width counters, Intel PMU driver.
[    0.062814] ... version:                3
[    0.062814] ... bit width:              48
[    0.062815] ... generic registers:      4
[    0.062815] ... value mask:             0000ffffffffffff
[    0.062816] ... max period:             0000ffffffffffff
[    0.062816] ... fixed-purpose events:   3
[    0.062817] ... event mask:             000000070000000f
[    0.063147] x86: Booting SMP configuration:
[    0.063148] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.624931] x86: Booted up 1 node, 8 CPUs
[    0.624934] smpboot: Total of 8 processors activated (57473.16 BogoMIPS)
[    0.630962] span: 0-7 (max cpu_capacity = 589)
[    0.659022] node 0 initialised, 2616842 pages in 28ms
[    0.659304] devtmpfs: initialized
[    0.659342] x86/mm: Memory block size: 128MB
[    0.661250] evm: security.selinux
[    0.661251] evm: security.ima
[    0.661251] evm: security.capability
[    0.661315] PM: Registering ACPI NVS region [mem 0xd0444000-0xd044afff] (28672 bytes)
[    0.661316] PM: Registering ACPI NVS region [mem 0xde829000-0xde98dfff] (1462272 bytes)
[    0.661364] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.661391] pinctrl core: initialized pinctrl subsystem
[    0.661424] RTC time:  9:51:44, date: 09/16/16
[    0.661479] NET: Registered protocol family 16
[    0.679010] cpuidle: using governor ladder
[    0.703023] cpuidle: using governor menu
[    0.703084] ACPI: bus type PCI registered
[    0.703085] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.703121] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.703123] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.703126] pmd_set_huge: Cannot satisfy [mem 0xf8000000-0xf8200000] with a huge-page mapping due to MTRR override.
[    0.703170] PCI: Using configuration type 1 for base access
[    0.703243] core: PMU erratum BJ122, BV98, HSD29 worked around, HT is on
[    0.719098] HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    0.719099] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.719215] ACPI: Added _OSI(Module Device)
[    0.719217] ACPI: Added _OSI(Processor Device)
[    0.719217] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.719218] ACPI: Added _OSI(Processor Aggregator Device)
[    0.719346] ACPI: Executed 1 blocks of module-level executable AML code
[    0.722934] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.723535] ACPI: Dynamic OEM Table Load:
[    0.723538] ACPI: SSDT 0xFFFF88041ECFD000 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
[    0.724090] ACPI: Dynamic OEM Table Load:
[    0.724093] ACPI: SSDT 0xFFFF88041EBF8800 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
[    0.724676] ACPI: Dynamic OEM Table Load:
[    0.724678] ACPI: SSDT 0xFFFF88041ECF6A00 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
[    0.726216] ACPI: Interpreter enabled
[    0.726230] ACPI: (supports S0 S3 S4 S5)
[    0.726231] ACPI: Using IOAPIC for interrupt routing
[    0.726248] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.732567] ACPI: Power Resource [FN00] (off)
[    0.732623] ACPI: Power Resource [FN01] (off)
[    0.732677] ACPI: Power Resource [FN02] (off)
[    0.732730] ACPI: Power Resource [FN03] (off)
[    0.732782] ACPI: Power Resource [FN04] (off)
[    0.733320] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.733323] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.733839] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.734107] PCI host bridge to bus 0000:00
[    0.734108] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.734109] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.734110] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.734111] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff window]
[    0.734112] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff window]
[    0.734113] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff window]
[    0.734113] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff window]
[    0.734114] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff window]
[    0.734115] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff window]
[    0.734116] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff window]
[    0.734117] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff window]
[    0.734117] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff window]
[    0.734118] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff window]
[    0.734119] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff window]
[    0.734120] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff window]
[    0.734121] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeafffff window]
[    0.734122] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.734126] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    0.734189] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.734211] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.734283] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.734323] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.734338] pci 0000:00:14.0: reg 0x10: [mem 0xf7200000-0xf720ffff 64bit]
[    0.734386] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.734419] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.734443] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.734457] pci 0000:00:16.0: reg 0x10: [mem 0xf721a000-0xf721a00f 64bit]
[    0.734508] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.734565] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.734579] pci 0000:00:1a.0: reg 0x10: [mem 0xf7218000-0xf72183ff]
[    0.734648] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.734690] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.734716] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.734727] pci 0000:00:1b.0: reg 0x10: [mem 0xf7210000-0xf7213fff 64bit]
[    0.734774] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.734808] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.734831] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.734882] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.734946] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.734970] pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
[    0.735021] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.735090] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.735118] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.735132] pci 0000:00:1d.0: reg 0x10: [mem 0xf7217000-0xf72173ff]
[    0.735201] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.735245] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.735269] pci 0000:00:1f.0: [8086:8c5c] type 00 class 0x060100
[    0.735401] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.735411] pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
[    0.735417] pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
[    0.735423] pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
[    0.735429] pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
[    0.735435] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    0.735441] pci 0000:00:1f.2: reg 0x24: [mem 0xf7216000-0xf72167ff]
[    0.735469] pci 0000:00:1f.2: PME# supported from D3hot
[    0.735518] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.735530] pci 0000:00:1f.3: reg 0x10: [mem 0xf7215000-0xf72150ff 64bit]
[    0.735546] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    0.735634] pci 0000:01:00.0: [10de:13c0] type 00 class 0x030000
[    0.735644] pci 0000:01:00.0: reg 0x10: [mem 0xf6000000-0xf6ffffff]
[    0.735653] pci 0000:01:00.0: reg 0x14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.735661] pci 0000:01:00.0: reg 0x1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
[    0.735667] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.735674] pci 0000:01:00.0: reg 0x30: [mem 0xf7000000-0xf707ffff pref]
[    0.735729] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.735753] pci 0000:01:00.1: [10de:0fbb] type 00 class 0x040300
[    0.735761] pci 0000:01:00.1: reg 0x10: [mem 0xf7080000-0xf7083fff]
[    0.747056] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.747057] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.747059] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.747061] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.747109] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.747172] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.747190] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.747215] pci 0000:03:00.0: reg 0x18: [mem 0xf7100000-0xf7100fff 64bit]
[    0.747232] pci 0000:03:00.0: reg 0x20: [mem 0xf2100000-0xf2103fff 64bit pref]
[    0.747316] pci 0000:03:00.0: supports D1 D2
[    0.747317] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.747354] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.759067] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.759070] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.759073] pci 0000:00:1c.2:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.759077] pci 0000:00:1c.2:   bridge window [mem 0xf2100000-0xf21fffff 64bit pref]
[    0.759628] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.759674] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.759716] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.759760] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.759802] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.759845] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.759888] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.759930] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.760159] ACPI: Enabled 6 GPEs in block 00 to 3F
[    0.760208] vgaarb: setting as boot device: PCI:0000:01:00.0
[    0.760210] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.760210] vgaarb: loaded
[    0.760211] vgaarb: bridge control possible 0000:01:00.0
[    0.760233] Registered efivars operations
[    0.763488] PCI: Using ACPI for IRQ routing
[    0.764641] PCI: pci_cache_line_size set to 64 bytes
[    0.764673] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.764674] e820: reserve RAM buffer [mem 0x0009e000-0x0009ffff]
[    0.764675] e820: reserve RAM buffer [mem 0xd0142018-0xd3ffffff]
[    0.764675] e820: reserve RAM buffer [mem 0xd0444000-0xd3ffffff]
[    0.764676] e820: reserve RAM buffer [mem 0xd088a000-0xd3ffffff]
[    0.764677] e820: reserve RAM buffer [mem 0xde788000-0xdfffffff]
[    0.764678] e820: reserve RAM buffer [mem 0xdf000000-0xdfffffff]
[    0.764679] e820: reserve RAM buffer [mem 0x41f000000-0x41fffffff]
[    0.764733] NetLabel: Initializing
[    0.764733] NetLabel:  domain hash size = 128
[    0.764734] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.764742] NetLabel:  unlabeled traffic allowed by default
[    0.764808] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.764811] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.766830] clocksource: Switched to clocksource hpet
[    0.770149] VFS: Disk quotas dquot_6.6.0
[    0.770162] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.770198] AppArmor: AppArmor Filesystem Enabled
[    0.770217] pnp: PnP ACPI init
[    0.770269] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.770271] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.770398] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.770399] system 00:01: [io  0xffff] has been reserved
[    0.770400] system 00:01: [io  0xffff] has been reserved
[    0.770401] system 00:01: [io  0xffff] has been reserved
[    0.770402] system 00:01: [io  0x1c00-0x1cfe] has been reserved
[    0.770403] system 00:01: [io  0x1d00-0x1dfe] has been reserved
[    0.770404] system 00:01: [io  0x1e00-0x1efe] has been reserved
[    0.770404] system 00:01: [io  0x1f00-0x1ffe] has been reserved
[    0.770405] system 00:01: [io  0x1800-0x18fe] has been reserved
[    0.770406] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.770408] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.770422] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.770452] system 00:03: [io  0x1854-0x1857] has been reserved
[    0.770454] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.770547] system 00:04: [io  0x0a00-0x0a1f] has been reserved
[    0.770548] system 00:04: [io  0x0a30-0x0a3f] has been reserved
[    0.770549] system 00:04: [io  0x0a20-0x0a2f] has been reserved
[    0.770550] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.770597] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    0.770599] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.770918] system 00:06: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.770920] system 00:06: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.770920] system 00:06: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.770921] system 00:06: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.770922] system 00:06: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.770923] system 00:06: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.770924] system 00:06: [mem 0xfed90000-0xfed93fff] could not be reserved
[    0.770925] system 00:06: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.770926] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
[    0.770927] system 00:06: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.770928] system 00:06: [mem 0xf7fdf000-0xf7fdffff] has been reserved
[    0.770929] system 00:06: [mem 0xf7fe0000-0xf7feffff] has been reserved
[    0.770931] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.771109] pnp: PnP ACPI: found 7 devices
[    0.776641] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.776653] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
[    0.776655] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02] add_size 200000 add_align 100000
[    0.776656] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000 add_align 100000
[    0.776663] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x000fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.776664] pci 0000:00:1c.0: res[14]=[mem 0x00100000-0x002fffff] res_to_dev_res add_size 200000 min_align 100000
[    0.776665] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.776666] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x002fffff 64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    0.776667] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] res_to_dev_res add_size 1000 min_align 1000
[    0.776668] pci 0000:00:1c.0: res[13]=[io  0x1000-0x1fff] res_to_dev_res add_size 1000 min_align 1000
[    0.776672] pci 0000:00:1c.0: BAR 14: assigned [mem 0xf2200000-0xf23fffff]
[    0.776677] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf2400000-0xf25fffff 64bit pref]
[    0.776679] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.776680] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.776681] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.776683] pci 0000:00:01.0:   bridge window [mem 0xf6000000-0xf70fffff]
[    0.776685] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.776687] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.776689] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.776693] pci 0000:00:1c.0:   bridge window [mem 0xf2200000-0xf23fffff]
[    0.776696] pci 0000:00:1c.0:   bridge window [mem 0xf2400000-0xf25fffff 64bit pref]
[    0.776700] pci 0000:00:1c.2: PCI bridge to [bus 03]
[    0.776702] pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
[    0.776706] pci 0000:00:1c.2:   bridge window [mem 0xf7100000-0xf71fffff]
[    0.776709] pci 0000:00:1c.2:   bridge window [mem 0xf2100000-0xf21fffff 64bit pref]
[    0.776714] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.776715] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.776715] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.776716] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff window]
[    0.776717] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff window]
[    0.776718] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff window]
[    0.776719] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff window]
[    0.776720] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff window]
[    0.776720] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff window]
[    0.776721] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff window]
[    0.776722] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff window]
[    0.776723] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff window]
[    0.776724] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff window]
[    0.776725] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff window]
[    0.776725] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff window]
[    0.776726] pci_bus 0000:00: resource 19 [mem 0xe0000000-0xfeafffff window]
[    0.776727] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.776728] pci_bus 0000:01: resource 1 [mem 0xf6000000-0xf70fffff]
[    0.776729] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.776730] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.776731] pci_bus 0000:02: resource 1 [mem 0xf2200000-0xf23fffff]
[    0.776731] pci_bus 0000:02: resource 2 [mem 0xf2400000-0xf25fffff 64bit pref]
[    0.776732] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.776733] pci_bus 0000:03: resource 1 [mem 0xf7100000-0xf71fffff]
[    0.776734] pci_bus 0000:03: resource 2 [mem 0xf2100000-0xf21fffff 64bit pref]
[    0.776799] NET: Registered protocol family 2
[    0.776895] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.777014] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.777112] TCP: Hash tables configured (established 131072 bind 65536)
[    0.777128] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.777160] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.777207] NET: Registered protocol family 1
[    0.777510] pci 0000:01:00.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.777520] PCI: CLS 64 bytes, default 64
[    0.777544] Unpacking initramfs...
[    1.411886] Freeing initrd memory: 9848K (ffff88003f65d000 - ffff88003fffb000)
[    1.411904] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.411906] software IO TLB [mem 0xcc142000-0xd0142000] (64MB) mapped at [ffff8800cc142000-ffff8800d0141fff]
[    1.412020] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 655360 ms ovfl timer
[    1.412021] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    1.412022] RAPL PMU: hw unit of domain package 2^-14 Joules
[    1.412022] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    1.412023] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    1.412230] Scanning for low memory corruption every 60 seconds
[    1.412418] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.412687] Initialise system trusted keyrings
[    1.412743] workingset: timestamp_bits=36 max_order=22 bucket_order=0
[    1.413698] zbud: loaded
[    1.438109] Key type asymmetric registered
[    1.438111] Asymmetric key parser 'x509' registered
[    1.438129] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    1.438148] io scheduler noop registered
[    1.438148] io scheduler deadline registered
[    1.438165] io scheduler cfq registered (default)
[    1.438517] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    1.438519] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.438520] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    1.438521] pcie_pme 0000:00:01.0:pcie001: service driver pcie_pme loaded
[    1.438535] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    1.438538] pcie_pme 0000:00:1c.0:pcie001: service driver pcie_pme loaded
[    1.438551] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    1.438552] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    1.438555] pcie_pme 0000:00:1c.2:pcie001: service driver pcie_pme loaded
[    1.438558] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.438564] pciehp 0000:00:1c.0:pcie004: Slot #0 AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+ Interlock- NoCompl+ LLActRep+
[    1.438582] pciehp 0000:00:1c.0:pcie004: service driver pciehp loaded
[    1.438584] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.438595] efifb: probing for efifb
[    1.438606] efifb: framebuffer at 0xe0000000, using 8640k, total 8640k
[    1.438607] efifb: mode is 1920x1080x32, linelength=8192, pages=1
[    1.438607] efifb: scrolling: redraw
[    1.438608] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.441542] Console: switching to colour frame buffer device 240x67
[    1.444367] fb0: EFI VGA frame buffer device
[    1.444371] intel_idle: MWAIT substates: 0x42120
[    1.444372] intel_idle: v0.4.1 model 0x3C
[    1.444373] intel_idle: max_cstate 1 reached
[    1.444452] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.444558] GHES: HEST is not enabled!
[    1.444578] Serial: 8250/16550 driver, 32 ports, IRQ sharing disabled
[    1.445401] Non-volatile memory driver v1.3
[    1.445417] Linux agpgart interface v0.103
[    1.445782] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.448100] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.448102] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.448164] mousedev: PS/2 mouse device common for all mice
[    1.448215] rtc_cmos 00:02: RTC can wake from S4
[    1.448315] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.448341] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.448348] intel_pstate: Intel P-state driver initializing
[    1.448631] ledtrig-cpu: registered to indicate activity on CPUs
[    1.448636] EFI Variables Facility v0.08 2004-May-17
[    1.455473] hidraw: raw HID events driver (C) Jiri Kosina
[    1.455961] NET: Registered protocol family 10
[    1.457216] microcode: sig=0x306c3, pf=0x2, revision=0x20
[    1.457371] microcode: Microcode Update Driver: v2.01 <tigran-ppwZ4lME3+KI6QP4U9MhSdBc4/FLrbF6@public.gmane.org>, Peter Oruba
[    1.457626] registered taskstats version 1
[    1.457633] Loading compiled-in X.509 certificates
[    1.461299] alg: No test for pkcs1pad(rsa,sha256) (pkcs1pad(rsa-generic,sha256))
[    1.463275] Loaded X.509 cert 'Build time autogenerated kernel key: c59619f81b041065e02de2944a667ab3e4f737d3'
[    1.463316] zswap: loaded using pool lzo/zbud
[    1.466390] Key type trusted registered
[    1.471187] Key type encrypted registered
[    1.471190] AppArmor: AppArmor sha1 policy hashing enabled
[    1.471194] ima: No TPM chip found, activating TPM-bypass!
[    1.471214] evm: HMAC attrs: 0x1
[    1.471899]   Magic number: 0:513:879
[    1.472084] PM: Checking hibernation image partition /dev/disk/by-uuid/0de200a9-5ce0-4471-b94d-0360934d3430
[    1.861850] PM: Hibernation image not present or could not be loaded.
[    1.861866] Warning: unable to open an initial console.
[    1.863190] Freeing unused kernel memory: 1716K (ffffffff81d2d000 - ffffffff81eda000)
[    1.863192] Write protecting the kernel read-only data: 12288k
[    1.863580] Freeing unused kernel memory: 1764K (ffff880001647000 - ffff880001800000)
[    1.866380] Freeing unused kernel memory: 1192K (ffff880001ad6000 - ffff880001c00000)
[    1.868426] random: systemd: uninitialized urandom read (16 bytes read)
[    1.869213] systemd[1]: systemd 210 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX -IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ +SECCOMP +APPARMOR)
[    1.869429] systemd[1]: Detected architecture 'x86-64'.
[    1.869432] systemd[1]: Running in initial RAM disk.
[    1.869842] autofs4: module verification failed: signature and/or required key missing - tainting kernel
[    1.870956] systemd[1]: Inserted module 'autofs4'
[    1.871041] systemd[1]: Set hostname to <homer>.
[    1.890251] random: systemd: uninitialized urandom read (16 bytes read)
[    1.890274] random: systemd: uninitialized urandom read (16 bytes read)
[    1.890620] random: systemd: uninitialized urandom read (16 bytes read)
[    1.891744] random: systemd: uninitialized urandom read (16 bytes read)
[    1.891876] random: systemd: uninitialized urandom read (16 bytes read)
[    1.891939] random: systemd: uninitialized urandom read (16 bytes read)
[    1.892060] random: systemd: uninitialized urandom read (16 bytes read)
[    1.892065] random: systemd: uninitialized urandom read (16 bytes read)
[    1.892069] random: systemd: uninitialized urandom read (16 bytes read)
[    1.892392] systemd[1]: Expecting device dev-disk-by\x2duuid-0de200a9\x2d5ce0\x2d4471\x2db94d\x2d0360934d3430.device...
[    1.892416] systemd[1]: Expecting device dev-disk-by\x2duuid-99D0\x2d1794.device...
[    1.892423] systemd[1]: Expecting device dev-disk-by\x2duuid-63d8c9f4\x2dc094\x2d4dd8\x2d96cd\x2d23c5e91d0322.device...
[    1.892429] systemd[1]: Starting Timers.
[    1.892435] systemd[1]: Reached target Timers.
[    1.896899] SCSI subsystem initialized
[    1.977765] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[    1.977803] ACPI: Power Button [PWRB]
[    1.977869] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    1.977907] ACPI: Power Button [PWRF]
[    1.978174] FUJITSU Extended Socket Network Device Driver - version 1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    1.985430] ACPI: bus type USB registered
[    1.985451] [drm] Initialized drm 1.1.0 20060810
[    1.985460] usbcore: registered new interface driver usbfs
[    1.985472] usbcore: registered new interface driver hub
[    1.985494] usbcore: registered new device driver usb
[    1.985973] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.986329] ehci-pci: EHCI PCI platform driver
[    1.986472] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.986482] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.986498] ehci-pci 0000:00:1a.0: debug port 2
[    1.987802] wmi: Mapper loaded
[    1.989262] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.990397] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.990501] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7218000
[    1.990774] libata version 3.00 loaded.
[    2.001537] r8169 0000:03:00.0 eth0: RTL8168g/8111g at 0xffffc900018fe000, d4:3d:7e:fc:4f:09, XID 0c000800 IRQ 28
[    2.001539] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    2.003871] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.003919] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.003921] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.003922] usb usb1: Product: EHCI Host Controller
[    2.003923] usb usb1: Manufacturer: Linux 4.8.0-tip ehci_hcd
[    2.003923] usb usb1: SerialNumber: 0000:00:1a.0
[    2.004014] hub 1-0:1.0: USB hub found
[    2.004020] hub 1-0:1.0: 2 ports detected
[    2.004206] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.004209] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.004219] ehci-pci 0000:00:1d.0: debug port 2
[    2.008126] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    2.008137] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7217000
[    2.023614] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.023650] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.023651] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.023652] usb usb2: Product: EHCI Host Controller
[    2.023653] usb usb2: Manufacturer: Linux 4.8.0-tip ehci_hcd
[    2.023654] usb usb2: SerialNumber: 0000:00:1d.0
[    2.023729] hub 2-0:1.0: USB hub found
[    2.023734] hub 2-0:1.0: 2 ports detected
[    2.023913] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.023918] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    2.025006] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 0x100 quirks 0x00009810
[    2.025010] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    2.025094] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.025095] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.025096] usb usb3: Product: xHCI Host Controller
[    2.025097] usb usb3: Manufacturer: Linux 4.8.0-tip xhci-hcd
[    2.025098] usb usb3: SerialNumber: 0000:00:14.0
[    2.025176] hub 3-0:1.0: USB hub found
[    2.025191] hub 3-0:1.0: 10 ports detected
[    2.027395] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    2.027397] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    2.027433] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    2.027434] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.027435] usb usb4: Product: xHCI Host Controller
[    2.027436] usb usb4: Manufacturer: Linux 4.8.0-tip xhci-hcd
[    2.027437] usb usb4: SerialNumber: 0000:00:14.0
[    2.027505] hub 4-0:1.0: USB hub found
[    2.027511] hub 4-0:1.0: 2 ports detected
[    2.027887] ahci 0000:00:1f.2: version 3.0
[    2.028002] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    2.028040] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x33 impl SATA mode
[    2.028043] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems sxs 
[    2.065047] scsi host0: ahci
[    2.065106] scsi host1: ahci
[    2.065158] scsi host2: ahci
[    2.065204] scsi host3: ahci
[    2.065248] scsi host4: ahci
[    2.065293] scsi host5: ahci
[    2.065320] ata1: SATA max UDMA/133 abar m2048@0xf7216000 port 0xf7216100 irq 30
[    2.065322] ata2: SATA max UDMA/133 abar m2048@0xf7216000 port 0xf7216180 irq 30
[    2.065323] ata3: DUMMY
[    2.065323] ata4: DUMMY
[    2.065324] ata5: SATA max UDMA/133 abar m2048@0xf7216000 port 0xf7216300 irq 30
[    2.065326] ata6: SATA max UDMA/133 abar m2048@0xf7216000 port 0xf7216380 irq 30
[    2.350879] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    2.355371] usb 3-1: new low-speed USB device number 2 using xhci_hcd
[    2.377774] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.389552] ata1.00: ATA-8: ADATA SP900, 5.6.0, max UDMA/133
[    2.389554] ata1.00: 250069680 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    2.399521] ata1.00: configured for UDMA/133
[    2.399625] scsi 0:0:0:0: Direct-Access     ATA      ADATA SP900      0    PQ: 0 ANSI: 5
[    2.399626] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.434876] tsc: Refined TSC clocksource calibration: 3591.683 MHz
[    2.434881] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x33c5a2aaf01, max_idle_ns: 440795238424 ns
[    2.438951] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    2.499676] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
[    2.499677] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.499832] hub 2-1:1.0: USB hub found
[    2.499926] hub 2-1:1.0: 6 ports detected
[    2.500625] usb 3-1: New USB device found, idVendor=0e8f, idProduct=0020
[    2.500627] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.500628] usb 3-1: Product: PS2toUSB Adapter
[    2.500628] usb 3-1: Manufacturer: GASIA
[    2.508689] usbcore: registered new interface driver usbhid
[    2.508690] usbhid: USB HID core driver
[    2.508969] input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0000:00:14.0/usb3/3-1/3-1:1.0/0003:0E8F:0020.0001/input/input5
[    2.547179] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
[    2.547181] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.547324] hub 1-1:1.0: USB hub found
[    2.547426] hub 1-1:1.0: 4 ports detected
[    2.566966] hid-generic 0003:0E8F:0020.0001: input,hidraw0: USB HID v1.10 Keyboard [GASIA PS2toUSB Adapter] on usb-0000:00:14.0-1/input0
[    2.567082] input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0000:00:14.0/usb3/3-1/3-1:1.1/0003:0E8F:0020.0002/input/input6
[    2.609980] random: crng init done
[    2.618882] usb 3-2: new high-speed USB device number 3 using xhci_hcd
[    2.626986] hid-generic 0003:0E8F:0020.0002: input,hidraw1: USB HID v1.10 Mouse [GASIA PS2toUSB Adapter] on usb-0000:00:14.0-1/input1
[    2.753580] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.754151] ata2.00: ATA-9: WDC WD10EZEX-00BN5A0, 01.01A01, max UDMA/133
[    2.754153] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.754716] ata2.00: configured for UDMA/133
[    2.754808] scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EZEX-00B 1A01 PQ: 0 ANSI: 5
[    2.760309] usb 3-2: New USB device found, idVendor=04e8, idProduct=342e
[    2.760310] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.760311] usb 3-2: Product: SCX-4300 Series
[    2.760312] usb 3-2: Manufacturer: Samsung
[    2.760313] usb 3-2: SerialNumber: 1457BFFS803023R.
[    2.782950] scsi 1:0:0:0: Attached scsi generic sg1 type 0
[    2.878910] usb 3-3: new high-speed USB device number 4 using xhci_hcd
[    3.025150] usb 3-3: New USB device found, idVendor=0e8d, idProduct=1836
[    3.025156] usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.025160] usb 3-3: Product: SES084D
[    3.025163] usb 3-3: Manufacturer: TSST Inc    
[    3.025166] usb 3-3: SerialNumber: R96XA84 
[    3.032734] usb-storage 3-3:1.0: USB Mass Storage device detected
[    3.032893] scsi host6: usb-storage 3-3:1.0
[    3.032936] scsi host6: runtime PM trying to activate child device host6 but parent (3-3:1.0) is not active
[    3.033023] usbcore: registered new interface driver usb-storage
[    3.033685] usbcore: registered new interface driver uas
[    3.097278] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.097704] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160422/psargs-359)
[    3.097714] ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.SPT4._GTF] (Node ffff88017fcdb0a0), AE_NOT_FOUND (20160422/psparse-542)
[    3.097868] ata5.00: ATA-9: WDC WD10EZEX-00BN5A0, 01.01A01, max UDMA/133
[    3.097872] ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.098316] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160422/psargs-359)
[    3.098321] ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.SPT4._GTF] (Node ffff88017fcdb0a0), AE_NOT_FOUND (20160422/psparse-542)
[    3.098468] ata5.00: configured for UDMA/133
[    3.098658] scsi 4:0:0:0: Direct-Access     ATA      WDC WD10EZEX-00B 1A01 PQ: 0 ANSI: 5
[    3.127298] scsi 4:0:0:0: Attached scsi generic sg2 type 0
[    3.147395] usb 3-4: new full-speed USB device number 5 using xhci_hcd
[    3.287404] usb 3-4: New USB device found, idVendor=067b, idProduct=2303
[    3.287406] usb 3-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.287407] usb 3-4: Product: USB-Serial Controller
[    3.287408] usb 3-4: Manufacturer: Prolific Technology Inc.
[    3.406902] usb 3-10: new full-speed USB device number 6 using xhci_hcd
[    3.441116] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.441516] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160422/psargs-359)
[    3.441520] ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.SPT5._GTF] (Node ffff88017fcdb118), AE_NOT_FOUND (20160422/psparse-542)
[    3.441654] ata6.00: ATA-9: WDC WD10EZEX-00BN5A0, 01.01A01, max UDMA/133
[    3.441655] ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.442066] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20160422/psargs-359)
[    3.442070] ACPI Error: Method parse/execution failed [\_SB.PCI0.SAT0.SPT5._GTF] (Node ffff88017fcdb118), AE_NOT_FOUND (20160422/psparse-542)
[    3.442200] ata6.00: configured for UDMA/133
[    3.442309] scsi 5:0:0:0: Direct-Access     ATA      WDC WD10EZEX-00B 1A01 PQ: 0 ANSI: 5
[    3.458964] clocksource: Switched to clocksource tsc
[    3.471210] scsi 5:0:0:0: Attached scsi generic sg3 type 0
[    3.474924] sd 0:0:0:0: [sda] 250069680 512-byte logical blocks: (128 GB/119 GiB)
[    3.474952] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)
[    3.474956] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    3.475004] sd 4:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)
[    3.475011] sd 4:0:0:0: [sdc] 4096-byte physical blocks
[    3.475029] sd 5:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)
[    3.475032] sd 5:0:0:0: [sdd] 4096-byte physical blocks
[    3.475044] sd 0:0:0:0: [sda] Write Protect is off
[    3.475048] sd 1:0:0:0: [sdb] Write Protect is off
[    3.475052] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.475053] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.475085] sd 4:0:0:0: [sdc] Write Protect is off
[    3.475090] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.475091] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.475092] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.475094] sd 5:0:0:0: [sdd] Write Protect is off
[    3.475098] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.475122] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.475125] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.480722]  sda: sda1 sda2 sda3 sda4 sda5 sda6
[    3.481138] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.537378]  sdd: sdd1
[    3.537553] sd 5:0:0:0: [sdd] Attached SCSI removable disk
[    3.542249]  sdb: sdb1 sdb2 sdb3
[    3.542396] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.544032]  sdc: sdc1 sdc2 sdc3
[    3.544175] sd 4:0:0:0: [sdc] Attached SCSI removable disk
[    3.549668] usb 3-10: New USB device found, idVendor=046d, idProduct=c52b
[    3.549670] usb 3-10: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.549671] usb 3-10: Product: USB Receiver
[    3.549672] usb 3-10: Manufacturer: Logitech
[    3.555061] logitech-djreceiver 0003:046D:C52B.0005: hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:14.0-10/input2
[    3.691388] input: Logitech M310 as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10:1.2/0003:046D:C52B.0005/0003:046D:1024.0006/input/input7
[    3.691444] logitech-hidpp-device 0003:046D:1024.0006: input,hidraw3: USB HID v1.11 Mouse [Logitech M310] on usb-0000:00:14.0-10:1
[    3.693429] input: Logitech K520 as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10:1.2/0003:046D:C52B.0005/0003:046D:2011.0007/input/input8
[    3.693523] logitech-hidpp-device 0003:046D:2011.0007: input,hidraw4: USB HID v1.11 Keyboard [Logitech K520] on usb-0000:00:14.0-10:2
[    3.774190] PM: Starting manual resume from disk
[    3.774192] PM: Hibernation image partition 8:34 present
[    3.774193] PM: Looking for hibernation image.
[    3.774314] PM: Image not found (code -22)
[    3.774324] PM: Hibernation image not present or could not be loaded.
[    3.908883] EXT4-fs (sdc3): mounted filesystem with ordered data mode. Opts: (null)
[    4.042787] scsi 6:0:0:0: CD-ROM            TSSTcorp CDDVDW SE-S084F  TS00 PQ: 0 ANSI: 0
[    4.042865] scsi 6:0:0:0: Attached scsi generic sg4 type 5
[    4.075339] systemd-journald[145]: Received SIGTERM from PID 1 (systemd).
[    4.357156] systemd: 35 output lines suppressed due to ratelimiting
[    6.974136] systemd-readahead[486]: Bumped block_nr parameter of 8:32 to 20480. This is a temporary hack and should be removed one day.
[    8.238839] RPC: Registered named UNIX socket transport module.
[    8.238841] RPC: Registered udp transport module.
[    8.238842] RPC: Registered tcp transport module.
[    8.238842] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    8.532841] EXT4-fs (sdc3): re-mounted. Opts: acl,user_xattr
[    9.313668] Installing knfsd (copyright (C) 1996 okir-pn4DOG8n3UYbFoVRYvo4fw@public.gmane.org).
[    9.439966] input: PC Speaker as /devices/platform/pcspkr/input/input9
[    9.527950] thermal LNXTHERM:00: registered as thermal_zone0
[    9.527952] ACPI: Thermal Zone [TZ00] (28 C)
[    9.528365] thermal LNXTHERM:01: registered as thermal_zone1
[    9.528367] ACPI: Thermal Zone [TZ01] (30 C)
[    9.760613] WARNING! power/level is deprecated; use power/control instead
[    9.824822] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
[   10.427815] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.842988] iTCO_vendor_support: vendor-support=0
[   11.632606] usblp 3-2:1.1: usblp0: USB Bidirectional printer dev 3 if 1 alt 0 proto 2 vid 0x04E8 pid 0x342E
[   11.632625] usbcore: registered new interface driver usblp
[   11.698648] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   11.698677] iTCO_wdt: Found a Lynx Point TCO device (Version=2, TCOBASE=0x1860)
[   11.698738] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   11.890998] sr 6:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   11.891000] cdrom: Uniform CD-ROM driver Revision: 3.20
[   11.891083] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   12.336746] device-mapper: uevent: version 1.0.3
[   12.336802] device-mapper: ioctl: 4.35.0-ioctl (2016-06-23) initialised: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
[   12.393601] AVX2 version of gcm_enc/dec engaged.
[   12.393603] AES CTR mode by8 optimization enabled
[   12.584979] EXT4-fs (sdd1): mounted filesystem with ordered data mode. Opts: data=ordered,acl,user_xattr
[   13.766327] usbcore: registered new interface driver usbserial
[   13.766341] usbcore: registered new interface driver usbserial_generic
[   13.766351] usbserial: USB Serial support registered for generic
[   13.774402] usbcore: registered new interface driver pl2303
[   13.774412] usbserial: USB Serial support registered for pl2303
[   13.774427] pl2303 3-4:1.0: pl2303 converter detected
[   13.774985] usb 3-4: pl2303 converter now attached to ttyUSB0
[   15.480151] Adding 2104316k swap on /dev/sdc2.  Priority:1 extents:1 across:2104316k FS
[   15.698609] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[   15.698880] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[   15.699141] snd_hda_intel 0000:01:00.1: Disabling MSI
[   15.902330] FAT-fs (sdc1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   16.235907] systemd-journald[491]: Received request to flush runtime journal from PID 1
[   16.357214] snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC887-VD: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:line
[   16.357216] snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   16.357217] snd_hda_codec_realtek hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   16.357218] snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=0x0
[   16.357219] snd_hda_codec_realtek hdaudioC0D0:    inputs:
[   16.357220] snd_hda_codec_realtek hdaudioC0D0:      Front Mic=0x19
[   16.357221] snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=0x18
[   16.357222] snd_hda_codec_realtek hdaudioC0D0:      Line=0x1a
[   16.368259] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   16.368295] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   16.368326] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   16.368357] input: HDA Intel PCH Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[   16.368387] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input14
[   16.723597] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
[   16.723657] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
[   16.723713] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input17
[   16.723821] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input18
[   17.791996] intel_rapl: Found RAPL domain package
[   17.791998] intel_rapl: Found RAPL domain core
[   17.792001] intel_rapl: Found RAPL domain dram
[   17.792003] intel_rapl: RAPL package 0 domain package locked by BIOS
[   17.792009] intel_rapl: RAPL package 0 domain dram locked by BIOS
[   17.939637] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   19.030753] nf_conntrack version 0.5.0 (65536 buckets, 262144 max)
[   19.820828] ip_tables: (C) 2000-2006 Netfilter Core Team
[   23.725827] No iBFT detected.
[   24.558497] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[   24.678230] r8169 0000:03:00.0 eth0: link down
[   24.678232] r8169 0000:03:00.0 eth0: link down
[   24.678429] br0: port 1(eth0) entered blocking state
[   24.678432] br0: port 1(eth0) entered disabled state
[   24.678503] device eth0 entered promiscuous mode
[   24.681130] IPv6: ADDRCONF(NETDEV_UP): br0: link is not ready
[   26.433739] r8169 0000:03:00.0 eth0: link up
[   26.433921] br0: port 1(eth0) entered blocking state
[   26.433923] br0: port 1(eth0) entered forwarding state
[   26.434005] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[   27.125388] NET: Registered protocol family 17
[   43.003013] NFSD: starting 90-second grace period (net ffffffff81cdfb80)
[   44.314914] Bridge firewalling registered
[   45.000275] loop: module loaded
[   52.328171] IPv6: ADDRCONF(NETDEV_UP): docker0: link is not ready
[   70.117621] fuse init (API version 7.25)
[   85.480872] Ebtables v2.0 registered
