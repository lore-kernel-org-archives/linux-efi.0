From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm*: Pass latest memory map to the kernel
Date: Mon, 12 Dec 2016 09:35:12 +0000
Message-ID: <584E6F50.3020901@arm.com>
References: <1481307843-18521-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481307843-18521-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On 09/12/16 18:24, Ard Biesheuvel wrote:
> As reported by James, the current libstub code involving the annotated
> memory map only works somewhat correctly by accident, due to the fact
> that a pool allocation happens to be reused immediately, retaining its
> former contents.
> 
> Instead of juggling memory maps, which makes the code more complex than
> it needs to be, simply put a placholder value into the FDT, and only
> write the actual value after ExitBootServices() has been called.

> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index a6a93116a8f0..5d39dff77f17 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -101,7 +101,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>  	if (status)
>  		goto fdt_set_fail;
>  
> -	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)memory_map);
> +	fdt_val64 = U64_MAX; /* placeholder */
>  	status = fdt_setprop(fdt, node, "linux,uefi-mmap-start",
>  			     &fdt_val64,  sizeof(fdt_val64));
>  	if (status)
> @@ -148,6 +148,24 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>  	return EFI_LOAD_ERROR;
>  }
>  
> +static efi_status_t update_fdt_memmap(void *fdt, u64 memmap)
> +{
> +	int node = fdt_path_offset(fdt, "/chosen");
> +	efi_status_t status;
> +
> +	if (node < 0)
> +		return EFI_LOAD_ERROR;
> +
> +	memmap = cpu_to_fdt64(memmap);
> +	status = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-start",
> +				     &memmap, sizeof(memmap));
> +
> +	if (status)
> +		return EFI_LOAD_ERROR;
> +
> +	return EFI_SUCCESS;
> +}

v4.9.0 with this patch doesn't boot on my Seattle (with known buggy UEFI FW)
[0]. It looks like the memory map is truncated (and missing a runtime region,
compare with [1]). Should 'linux,uefi-mmap-size' be updated too? (Otherwise its
the size when we retrieved the runtime mapping, but before we allocated the FDT)


> +
>  #ifndef EFI_FDT_ALIGN
>  #define EFI_FDT_ALIGN EFI_PAGE_SIZE
>  #endif
> @@ -243,15 +261,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  			goto fail;
>  		}
>  
> -		/*
> -		 * Now that we have done our final memory allocation (and free)
> -		 * we can get the memory map key  needed for
> -		 * exit_boot_services().
> -		 */
> -		status = efi_get_memory_map(sys_table, &map);
> -		if (status != EFI_SUCCESS)
> -			goto fail_free_new_fdt;
> -
>  		status = update_fdt(sys_table,
>  				    (void *)fdt_addr, fdt_size,
>  				    (void *)*new_fdt_addr, new_fdt_size,
                                    cmdline_ptr, initrd_addr, initrd_size,
                                    memory_map, map_size, desc_size, desc_ver);

Removing the efi_get_memory_map() call means memory_map is an uninitialised
pointer passed here. It looks like the compiler spots that its also unused so
doesn't generate a warning.

Wouldn't it be better to remove the argument (as its unused), or pass the
placeholder value here? (readability is in the eye of the beholder...)



> @@ -266,20 +275,16 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  			/*
>  			 * We need to allocate more space for the new
>  			 * device tree, so free existing buffer that is
> -			 * too small.  Also free memory map, as we will need
> -			 * to get new one that reflects the free/alloc we do
> -			 * on the device tree buffer.
> +			 * too small.
>  			 */
>  			efi_free(sys_table, new_fdt_size, *new_fdt_addr);
> -			sys_table->boottime->free_pool(memory_map);
>  			new_fdt_size += EFI_PAGE_SIZE;
>  		} else {
>  			pr_efi_err(sys_table, "Unable to construct new device tree.\n");
> -			goto fail_free_mmap;
> +			goto fail_free_new_fdt;
>  		}
>  	}
>  
> -	sys_table->boottime->free_pool(memory_map);
>  	priv.runtime_map = runtime_map;
>  	priv.runtime_entry_count = &runtime_entry_count;
>  	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
> @@ -288,6 +293,17 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  	if (status == EFI_SUCCESS) {
>  		efi_set_virtual_address_map_t *svam;
>  
> +		status = update_fdt_memmap((void *)*new_fdt_addr,
> +					   (u64)memory_map);
> +		if (status != EFI_SUCCESS) {
> +			/*
> +			 * The kernel won't get far without the memory map, but
> +			 * may still be able to print something meaningful so
> +			 * return success here.
> +			 */
> +			return EFI_SUCCESS;
> +		}
> +
>  		/* Install the new virtual address map */
>  		svam = sys_table->runtime->set_virtual_address_map;
>  		status = svam(runtime_entry_count * desc_size, desc_size,
> @@ -319,9 +335,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  
>  	pr_efi_err(sys_table, "Exit boot services failed.\n");
>  
> -fail_free_mmap:
> -	sys_table->boottime->free_pool(memory_map);
> -
>  fail_free_new_fdt:
>  	efi_free(sys_table, new_fdt_size, *new_fdt_addr);
>  
> 

Looks better than my attempt!

Thanks,

James

[0] Seattle broken boot, v4.9.0:defconfig + this patch
Shell> efi\morse\Image console=ttyAMA0,115200
root=PARTUUID=b2edf709-3b28-4cb3-8809-203f262e2bcc rw earlycon=pl011,0xe1010000
crashkernel=1G stacktrace ignore_loglevel=1 acpi=on efi=debug resume=/dev/sda3
EFI stub: Booting Linux Kernel...
EFI stub: Using DTB from configuration table
EFI stub: Exiting boot services and installing virtual address map...
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.9.0-00001-gd0a79eca7083 (morse@melchizedek) (gcc
version 5.2.1 20150903 (Debian 5.2.1-16) ) #6482 SMP PREEMPT Mon Dec 12 08:41:16
GMT 2016
[    0.000000] Boot CPU: AArch64 Processor [411fd072]
[    0.000000] earlycon: pl11 at MMIO 0x00000000e1010000 (options '')
[    0.000000] bootconsole [pl11] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] efi: Getting EFI parameters from FDT:
[    0.000000] efi:   System Table: 0x00000083ff34bf18
[    0.000000] efi:   MemMap Address: 0x00000083fced4018
[    0.000000] efi:   MemMap Size: 0x000004e0
[    0.000000] efi:   MemMap Desc. Size: 0x00000030
[    0.000000] efi:   MemMap Desc. Version: 0x00000001
[    0.000000] efi: EFI v2.40 by American Megatrends
[    0.000000] efi:  ACPI 2.0=0x83ff1c3000  SMBIOS 3.0=0x83ff347798
[    0.000000] efi: Processing EFI memory map:
[    0.000000] efi:   0x0000e1050000-0x0000e105ffff [Memory Mapped I/O  |RUN|  |
 |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e1300000-0x0000e1300fff [Memory Mapped I/O  |RUN|  |
 |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e8200000-0x0000e827ffff [Memory Mapped I/O  |RUN|  |
 |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x008000000000-0x008001e7ffff [Runtime Data       |RUN|  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x008001e80000-0x008001ffffff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x008002000000-0x008002e6ffff [Loader Data        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x008002e70000-0x00801fdfffff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x00801fe00000-0x00801fe0ffff [Loader Data        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x00801fe10000-0x00801fffbfff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x00801fffc000-0x00801fffffff [Boot Data          |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x008020000000-0x0083f0ffffff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083f1000000-0x0083f101ffff [Boot Data          |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083f1020000-0x0083fb347fff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fb348000-0x0083fc133fff [Loader Code        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fc134000-0x0083fced3fff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fced4000-0x0083fced4fff [Loader Data        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fced5000-0x0083fcff0fff [Loader Code        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fcff1000-0x0083fea67fff [Boot Data          |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fea68000-0x0083febd3fff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083febd4000-0x0083ff186fff [Boot Code          |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff187000-0x0083ff1b6fff [Reserved           |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff1b7000-0x0083ff1c4fff [ACPI Reclaim Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff1c5000-0x0083ff20ffff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff210000-0x0083ff224fff [Loader Data        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff225000-0x0083ff226fff [ACPI Memory NVS    |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff227000-0x0083ff34bfff [Runtime Data       |RUN|  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] cma: Reserved 16 MiB at 0x00000080ff000000
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000083FF1C3000 000024 (v02 AMDINC)
[    0.000000] ACPI: XSDT 0x00000083FF1C3028 000084 (v01 AMDINC SEATTLE
00000000 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000083FF1C30B0 00010C (v05 AMDINC SEATTLE
00000000 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000083FF1C31C0 000967 (v02 AMDINC SEATTLE
00000003 INTL 20140926)
[    0.000000] ACPI: MCFG 0x00000083FF1C3B28 00003C (v01 AMDINC SEATTLE
00000000 MSFT 00000097)
[    0.000000] ACPI: DBG2 0x00000083FF1C3B68 00005A (v00 AMDINC SEATTLE
00000000 AMI  00000000)
[    0.000000] ACPI: GTDT 0x00000083FF1C3BC8 000060 (v02 AMDINC SEATTLE
00000000 AMI  00000000)
[    0.000000] ACPI: APIC 0x00000083FF1C3C28 0002BC (v03 AMDINC SEATTLE
00000000 AMI  00000000)
[    0.000000] ACPI: CSRT 0x00000083FF1C3EE8 000060 (v00 AMDINC
00000000 AMI  00000000)
[    0.000000] ACPI: SSDT 0x00000083FF1C3F48 00011B (v02 AMDINC CPUSSDT
00000000 AMI  00000000)
[    0.000000] ACPI: SSDT 0x00000083FF1C4068 00008A (v01 AMDINC SATASSDT
00000003 INTL 20140926)
[    0.000000] ACPI: SSDT 0x00000083FF1C40F8 0004B3 (v01 AMDINC ETHSSDT
00000003 INTL 20140926)
[    0.000000] ACPI: SPCR 0x00000083FF1C45B0 000050 (v02 A M I  APTIO V
00000000 AMI. 00000005)
[    0.000000] ACPI: HEST 0x00000083FF1C4600 0001A8 (v01 AMD    AMD HEST
00000000      00000000)
[    0.000000] ACPI: BERT 0x00000083FF1C47A8 000030 (v01 AMD    AMD BERT
00000000      00000000)
[    0.000000] ACPI: SPCR: console: pl011,mmio,0xe1010000,115200
[    0.000000] ACPI: NUMA: Failed to initialise from firmware
[    0.000000] NUMA: Faking a node at [mem 0x0000000000000000-0x00000083ff34bfff]
[    0.000000] NUMA: Adding memblock [0x8000000000 - 0x8001e7ffff] on node 0
[    0.000000] NUMA: Adding memblock [0x8001e80000 - 0x83ff186fff] on node 0
[    0.000000] NUMA: Adding memblock [0x83ff187000 - 0x83ff1c4fff] on node 0
[    0.000000] NUMA: Adding memblock [0x83ff1c5000 - 0x83ff224fff] on node 0
[    0.000000] NUMA: Adding memblock [0x83ff225000 - 0x83ff34bfff] on node 0
[    0.000000] NUMA: Initmem setup node 0 [mem 0x8000000000-0x83ff34bfff]
[    0.000000] NUMA: NODE_DATA [mem 0x83ff214500-0x83ff215fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000008000000000-0x00000080ffffffff]
[    0.000000]   Normal   [mem 0x0000008100000000-0x00000083ff34bfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000008000000000-0x0000008001e7ffff]
[    0.000000]   node   0: [mem 0x0000008001e80000-0x00000083ff186fff]
[    0.000000]   node   0: [mem 0x00000083ff187000-0x00000083ff1c4fff]
[    0.000000]   node   0: [mem 0x00000083ff1c5000-0x00000083ff224fff]
[    0.000000]   node   0: [mem 0x00000083ff225000-0x00000083ff34bfff]
[    0.000000] Initmem setup node 0 [mem 0x0000008000000000-0x00000083ff34bfff]
[    0.000000] On node 0 totalpages: 4191052
[    0.000000]   DMA zone: 16384 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 1048576 pages, LIFO batch:31
[    0.000000]   Normal zone: 49102 pages used for memmap
[    0.000000]   Normal zone: 3142476 pages, LIFO batch:31
[    0.000000] psci: probing for conduit method from ACPI.
[    0.000000] psci: PSCIv0.2 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] percpu: Embedded 21 pages/cpu @ffff8003ff0df000 s47896 r8192
d29928 u86016
[    0.000000] pcpu-alloc: s47896 r8192 d29928 u86016 alloc=21*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7
[    0.000000] Detected PIPT I-cache on CPU0
[    0.000000] CPU features: enabling workaround for ARM erratum 832075
[    0.000000] CPU features: enabling workaround for ARM erratum 834220
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total
pages: 4125566
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: efi\morse\Image console=ttyAMA0,115200
root=PARTUUID=b2edf709-3b28-4cb3-8809-203f262e2bcc rw earlycon=pl011,0xe1010000
crashkernel=1G stacktrace ignore_loglevel=1 acpi=on efi=debug resume=/dev/sda3
[    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
[    0.000000] log_buf_len total cpu_extra contributions: 28672 bytes
[    0.000000] log_buf_len min size: 16384 bytes
[    0.000000] log_buf_len: 65536 bytes
[    0.000000] early log buf free: 7932(48%)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] software IO TLB [mem 0x80fafff000-0x80fefff000] (64MB) mapped at
[ffff8000fafff000-ffff8000feffefff]
[    0.000000] Memory: 16371940K/16764208K available (8444K kernel code, 834K
rwdata, 3624K rodata, 1024K init, 277K bss, 375884K reserved, 16384K cma-reserved)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000   (   128 MB)
[    0.000000]     vmalloc : 0xffff000008000000 - 0xffff7dffbfff0000   (129022 GB)
[    0.000000]       .text : 0xffff000008080000 - 0xffff0000088c0000   (  8448 KB)
[    0.000000]     .rodata : 0xffff0000088c0000 - 0xffff000008c50000   (  3648 KB)
[    0.000000]       .init : 0xffff000008c50000 - 0xffff000008d50000   (  1024 KB)
[    0.000000]       .data : 0xffff000008d50000 - 0xffff000008e20a00   (   835 KB)
[    0.000000]        .bss : 0xffff000008e20a00 - 0xffff000008e65fbc   (   278 KB)
[    0.000000]     fixed   : 0xffff7dfffe7fd000 - 0xffff7dfffec00000   (  4108 KB)
[    0.000000]     PCI I/O : 0xffff7dfffee00000 - 0xffff7dffffe00000   (    16 MB)
[    0.000000]     vmemmap : 0xffff7e0000000000 - 0xffff800000000000   (  2048
GB maximum)
[    0.000000]               0xffff7e0000000000 - 0xffff7e000ffcd300   (   255
MB actual)
[    0.000000]     memory  : 0xffff800000000000 - 0xffff8003ff34c000   ( 16371 MB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  Build-time adjustment of leaf fanout to 64.
[    0.000000]  RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=8
[    0.000000] NR_IRQS:64 nr_irqs:64 0
[    0.000000] GIC: Using split EOI/Deactivate mode
[    0.000000] GICv2m: range[mem 0xe1180000-0xe1180fff], SPI[64:319]
[    0.000000] arm_arch_timer: Architected cp15 timer(s) running at 250.00MHz
(phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles:
0x7350b89c29, max_idle_ns: 881590431910 ns
[    0.000001] sched_clock: 56 bits at 250MHz, resolution 4ns, wraps every
4398046511102ns
[    0.008135] Console: colour dummy device 80x25
[    0.012700] Calibrating delay loop (skipped), value calculated using timer
frequency.. 500.00 BogoMIPS (lpj=1000000)
[    0.023333] pid_max: default: 32768 minimum: 301
[    0.027997] ACPI: Core revision 20160831
[    0.032378] ACPI: 4 ACPI AML tables successfully acquired and loaded
[    0.038819] Security Framework initialized
[    0.044630] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.056118] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.064713] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.071683] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.079547] ASID allocator initialised with 65536 entries
[    0.117078] Remapping and enabling EFI services.
[    0.121756]   EFI remap 0x00000000e1050000 => 0000000020000000
[    0.127645]   EFI remap 0x00000000e1300000 => 0000000020010000
[    0.133531]   EFI remap 0x00000000e8200000 => 0000000020020000
[    0.139459]   EFI remap 0x0000008000000000 => 0000000020200000
[    0.145348]   EFI remap 0x00000083ff227000 => 0000000022087000
[    0.209377] Detected PIPT I-cache on CPU1
[    0.209397] CPU1: Booted secondary processor [411fd072]
[    0.255389] Detected PIPT I-cache on CPU2
[    0.255406] CPU2: Booted secondary processor [411fd072]
[    0.297453] Detected PIPT I-cache on CPU3
[    0.297465] CPU3: Booted secondary processor [411fd072]
[    0.343475] Detected PIPT I-cache on CPU4
[    0.343489] CPU4: Booted secondary processor [411fd072]
[    0.385539] Detected PIPT I-cache on CPU5
[    0.385551] CPU5: Booted secondary processor [411fd072]
[    0.431557] Detected PIPT I-cache on CPU6
[    0.431572] CPU6: Booted secondary processor [411fd072]
[    0.473621] Detected PIPT I-cache on CPU7
[    0.473633] CPU7: Booted secondary processor [411fd072]
[    0.473661] Brought up 8 CPUs
[    0.541646] SMP: Total of 8 processors activated.
[    0.546379] CPU features: detected feature: 32-bit EL0 Support
[    0.552287] CPU: All CPU(s) started at EL2
[    0.556418] alternatives: patching kernel code
[    0.564405] devtmpfs: initialized
[    0.568066] SMBIOS 3.0.0 present.
[    0.571469] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff,
max_idle_ns: 7645041785100000 ns
[    0.581454] pinctrl core: initialized pinctrl subsystem
[    0.587047] NET: Registered protocol family 16
[    0.615078] cpuidle: using governor menu
[    0.619095] vdso: 2 pages (1 code @ ffff0000088c7000, 1 data @ ffff000008d54000)
[    0.626550] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    0.633729] DMA: preallocated 256 KiB pool for atomic allocations
[    0.639929] ACPI: bus type PCI registered
[    0.644002] Serial: AMBA PL011 UART driver
[    0.664262] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.670997] ACPI: Added _OSI(Module Device)
[    0.675210] ACPI: Added _OSI(Processor Device)
[    0.679681] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.684413] ACPI: Added _OSI(Processor Aggregator Device)
[    0.690715] ACPI: Interpreter enabled
[    0.694400] ACPI: Using GIC for interrupt routing
[    0.699149] ACPI: MCFG table detected, 1 entries
[    0.706008] AMDI0511:00: ttyAMA0 at MMIO 0xe1010000 (irq = 8, base_baud = 0)
is a SBSA
[    0.713985] console [ttyAMA0] enabled
[    0.713985] console [ttyAMA0] enabled
[    0.721314] bootconsole [pl11] disabled
[    0.721314] bootconsole [pl11] disabled
[    0.729170] acpi AMDI0400:01: amba_handler_attach(): amba_device_add() failed
(-19)
[    0.737230] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-0f])
[    0.743407] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM
Segments MSI]
[    0.751790] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER
PCIeCapability]
[    0.759793] acpi PNP0A08:00: ECAM at [mem 0xf0000000-0xf0ffffff] for [bus 00-0f]
[    0.767211] Remapped I/O 0x00000001dffe0000 to [io  0x0000-0xffff window]
[    0.774105] PCI host bridge to bus 0000:00
[    0.778194] pci_bus 0000:00: root bus resource [mem 0x40000000-0x5fffffff window]
[    0.785667] pci_bus 0000:00: root bus resource [mem 0x60000000-0x7fffffff window]
[    0.793141] pci_bus 0000:00: root bus resource [mem 0x80000000-0x9fffffff window]
[    0.800616] pci_bus 0000:00: root bus resource [mem 0xa0000000-0xbfffffff window]
[    0.808089] pci_bus 0000:00: root bus resource [mem 0x100000000-0x1ffffffff
window]
[    0.815735] pci_bus 0000:00: root bus resource [mem 0x200000000-0x3ffffffff
window]
[    0.823380] pci_bus 0000:00: root bus resource [mem 0x400000000-0x7ffffffff
window]
[    0.831026] pci_bus 0000:00: root bus resource [mem 0x800000000-0xfffffffff
window]
[    0.838672] pci_bus 0000:00: root bus resource [mem 0x1000000000-0x1fffffffff
window]
[    0.846492] pci_bus 0000:00: root bus resource [mem 0x2000000000-0x3fffffffff
window]
[    0.854311] pci_bus 0000:00: root bus resource [mem 0x4000000000-0x7fffffffff
window]
[    0.862130] pci_bus 0000:00: root bus resource [io  0x0000-0xffff window]
(bus address [0xefff0000-0xefffffff])
[    0.872206] pci_bus 0000:00: root bus resource [bus 00-0f]
[    0.877687] pci 0000:00:00.0: [1022:1a00] type 00 class 0x060000
[    0.883770] pci 0000:00:02.0: [1022:1a01] type 00 class 0x060000
[    0.889848] pci 0000:00:02.1: [1022:1a02] type 01 class 0x060400
[    0.895882] pci 0000:00:02.1: PME# supported from D0 D3hot D3cold
[    0.902102] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    0.908115] pci 0000:01:00.0: reg 0x10: initial BAR value 0x00000000 invalid
[    0.915153] pci 0000:01:00.0: reg 0x10: [io  size 0x0100]
[    0.920565] pci 0000:01:00.0: reg 0x18: [mem 0xbff00000-0xbff00fff 64bit]
[    0.927356] pci 0000:01:00.0: reg 0x20: [mem 0x7ffff00000-0x7ffff03fff 64bit
pref]
[    0.934988] pci 0000:01:00.0: supports D1 D2
[    0.939249] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.957880] pci 0000:00:02.1: BAR 14: assigned [mem 0x40000000-0x400fffff]
[    0.964751] pci 0000:00:02.1: BAR 15: assigned [mem 0x100000000-0x1000fffff
64bit pref]
[    0.972746] pci 0000:00:02.1: BAR 13: assigned [io  0x1000-0x1fff]
[    0.978918] pci 0000:01:00.0: BAR 4: assigned [mem 0x100000000-0x100003fff
64bit pref]
[    0.986834] pci 0000:01:00.0: BAR 2: assigned [mem 0x40000000-0x40000fff 64bit]
[    0.994141] pci 0000:01:00.0: BAR 0: assigned [io  0x1000-0x10ff]
[    1.000229] pci 0000:00:02.1: PCI bridge to [bus 01]
[    1.005184] pci 0000:00:02.1:   bridge window [io  0x1000-0x1fff]
[    1.011267] pci 0000:00:02.1:   bridge window [mem 0x40000000-0x400fffff]
[    1.018045] pci 0000:00:02.1:   bridge window [mem 0x100000000-0x1000fffff
64bit pref]
[    1.026555] vgaarb: loaded
[    1.029330] SCSI subsystem initialized
[    1.033135] libata version 3.00 loaded.
[    1.037015] ACPI: bus type USB registered
[    1.041052] usbcore: registered new interface driver usbfs
[    1.046545] usbcore: registered new interface driver hub
[    1.051878] usbcore: registered new device driver usb
[    1.057097] ------------[ cut here ]------------
[    1.061709] WARNING: CPU: 2 PID: 1 at
../drivers/i2c/busses/i2c-designware-core.c:293 i2c_dw_clk_rate+0x3c/0x48
[    1.071780] Modules linked in:
[    1.074823]
[    1.076303] CPU: 2 PID: 1 Comm: swapper/0 Not tainted
4.9.0-00001-gd0a79eca7083 #6482
[    1.084119] Hardware name: AMD Overdrive/Supercharger/Default string, BIOS
ROD1002C 04/08/2016
[    1.092717] task: ffff8003ecd08000 task.stack: ffff8003ecd10000
[    1.098623] PC is at i2c_dw_clk_rate+0x3c/0x48
[    1.103055] LR is at i2c_dw_init+0xfc/0x3c8
[    1.107225] pc : [<ffff000008704e74>] lr : [<ffff0000087056b4>] pstate: 60000045
[    1.114607] sp : ffff8003ecd13ba0
[    1.117908] x29: ffff8003ecd13ba0 x28: 0000000000000000
[    1.123211] x27: ffff000008d0d158 x26: ffff000008c50450
[    1.128514] x25: ffff000008ca2798 x24: ffff000008c46b38
[    1.133815] x23: 00000000431bde83 x22: 000000000000012c
[    1.139116] x21: 00000000000707ae x20: 000000000000012c
[    1.144417] x19: ffff8003eca7b018 x18: ffff00000806dfff
[    1.149718] x17: 0000000000000000 x16: 0000000000000001
[    1.155019] x15: ffff00000806dfff x14: efffffffefff0000
[    1.160320] x13: 00000000030c0100 x12: 0000000000000018
[    1.165621] x11: 0000000000000000 x10: 0101010101010101
[    1.170922] x9 : 0000000000000000 x8 : ffff8003ecbfc880
[    1.176223] x7 : 0000000000000000 x6 : 000000000000003f
[    1.181524] x5 : 0000000000000000 x4 : 0000000000000000
[    1.186825] x3 : ffff00000806d06c x2 : 0000000000000000
[    1.192126] x1 : 0000000000000001 x0 : ffff000008e10000
[    1.197426]

[    1.198906] ---[ end trace f3069799ac0efee6 ]---
[    1.203510] Call trace:
[    1.205945] Exception stack(0xffff8003ecd139d0 to 0xffff8003ecd13b00)
[    1.212372] 39c0:                                   ffff8003eca7b018
0001000000000000
[    1.220188] 39e0: ffff8003ecd13ba0 ffff000008704e74 ffff8003ecd13a90
ffff000008451794
[    1.228005] 3a00: ffff8003ecbfc818 0000000000000000 ffff8003ee8137a8
ffff8003ecbfc818
[    1.235821] 3a20: 0000000000000000 ffff8003ee8137a8 ffff000008ca2798
ffff000008c50450
[    1.243637] 3a40: ffff8003ecd13a90 ffff0000084517a0 0000000000000005
0000000000000000
[    1.251453] 3a60: ffff8003ee8137a8 ffff8003ecbfc818 ffff000008e10000
0000000000000001
[    1.259269] 3a80: 0000000000000000 ffff00000806d06c 0000000000000000
0000000000000000
[    1.267084] 3aa0: 000000000000003f 0000000000000000 ffff8003ecbfc880
0000000000000000
[    1.274900] 3ac0: 0101010101010101 0000000000000000 0000000000000018
00000000030c0100
[    1.282716] 3ae0: efffffffefff0000 ffff00000806dfff 0000000000000001
0000000000000000
[    1.290533] [<ffff000008704e74>] i2c_dw_clk_rate+0x3c/0x48
[    1.296006] [<ffff0000087059b8>] i2c_dw_probe+0x38/0x250
[    1.301305] [<ffff000008706410>] dw_i2c_plat_probe+0x1d0/0x430
[    1.307127] [<ffff000008521a40>] platform_drv_probe+0x50/0xb8
[    1.312861] [<ffff00000851ff2c>] driver_probe_device+0x1fc/0x2a8
[    1.318854] [<ffff000008520084>] __driver_attach+0xac/0xb0
[    1.324326] [<ffff00000851df48>] bus_for_each_dev+0x60/0xa0
[    1.329886] [<ffff00000851f718>] driver_attach+0x20/0x28
[    1.335185] [<ffff00000851f318>] bus_add_driver+0x1d0/0x238
[    1.340744] [<ffff000008520848>] driver_register+0x60/0xf8
[    1.346217] [<ffff000008521980>] __platform_driver_register+0x40/0x48
[    1.352646] [<ffff000008c8fccc>] dw_i2c_init_driver+0x18/0x20
[    1.358380] [<ffff0000080830b8>] do_one_initcall+0x38/0x128
[    1.363941] [<ffff000008c50cf8>] kernel_init_freeable+0x1ac/0x250
[    1.370023] [<ffff0000088ae008>] kernel_init+0x10/0x108
[    1.375234] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[    1.381032] pps_core: LinuxPPS API ver. 1 registered
[    1.385988] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo
Giometti <giometti-k2GhghHVRtY@public.gmane.org>
[    1.395116] PTP clock support registered
[    1.399087] Registered efivars operations
[    1.403091] Unable to handle kernel paging request at virtual address 22c4a238
[    1.410303] pgd = ffff000008e69000
[    1.413691] [22c4a238] *pgd=00000083ff223003[    1.417777] ,
*pud=00000083ff222003
, *pmd=0000000000000000[    1.423254]
[    1.424734] Internal error: Oops: 86000006 [#1] PREEMPT SMP
[    1.430292] Modules linked in:
[    1.433336] CPU: 2 PID: 1 Comm: swapper/0 Tainted: G        W
4.9.0-00001-gd0a79eca7083 #6482
[    1.442367] Hardware name: AMD Overdrive/Supercharger/Default string, BIOS
ROD1002C 04/08/2016
[    1.450963] task: ffff8003ecd08000 task.stack: ffff8003ecd10000
[    1.456869] PC is at 0x22c4a238
[    1.460001] LR is at virt_efi_get_next_variable+0x88/0xc8
[    1.465386] pc : [<0000000022c4a238>] lr : [<ffff00000875e7d0>] pstate: 20000045
[    1.472766] sp : ffff8003ecd13c70
[    1.476068] x29: ffff8003ecd13c70 x28: ffff000008e0bc68
[    1.481369] x27: ffff8003ecd13dc0 x26: ffff000008c50450
[    1.486670] x25: ffff000008e0b000 x24: 0000000000000001
[    1.491971] x23: 0000000000000040 x22: ffff8003ecd13d30
[    1.497271] x21: ffff8003eca32800 x20: ffff8003ecd13d28
[    1.502571] x19: ffff000008e0bf20 x18: 0000000000000006
[    1.507871] x17: 0000000000000000 x16: 0000000000000001
[    1.513172] x15: ffff000008e2cc35 x14: 0000000000000127
[    1.518472] x13: 0000000000000001 x12: 0000000005f5e0ff
[    1.523773] x11: 0000000000000006 x10: 0000000000000128
[    1.529073] x9 : 0000000000000000 x8 : ffff8003eca32c00
[    1.534373] x7 : 0000000000000000 x6 : 0000000000000000
[    1.539673] x5 : 0000000000000000 x4 : 0000000000000004
[    1.544974] x3 : 0000000022c4a238 x2 : ffff8003ecd13d30
[    1.550274] x1 : ffff8003eca32800 x0 : ffff8003ecd13d28
[    1.555574]
[    1.557053] Process swapper/0 (pid: 1, stack limit = 0xffff8003ecd10020)
[    1.563740] Stack: (0xffff8003ecd13c70 to 0xffff8003ecd14000)
[    1.569472] 3c60:                                   ffff8003ecd13cb0
ffff00000875c8ac
[    1.577288] 3c80: ffff8003eca32800 ffff000008e58000 ffff8003ecd13dc0
0000000000000400
[    1.585104] 3ca0: ffff000008e58568 ffff8003ecd13d20 ffff8003ecd13d60
ffff000008c930fc
[    1.592920] 3cc0: 0000000000000000 ffff000008e58000 ffff000008d5bf88
ffff8003ecd13dc0
[    1.600735] 3ce0: ffff000008e25000 ffff000008c46b38 ffff000008ca2798
ffff000008c50450
[    1.608551] 3d00: ffff000008d0d1b0 0000000000000000 ffff000008e0bc68
ffff000008c92d30
[    1.616367] 3d20: ffff8003ecd13d60 0000000000000400 ffff8003ecd10000
ffff000008e58000
[    1.624183] 3d40: ffff000008d5bf88 0000000000000004 ffff000008e25000
ffff000008e58000
[    1.631998] 3d60: ffff8003ecd13dd0 ffff0000080830b8 ffff8003ecd10000
ffff000008c93028
[    1.639813] 3d80: 0000000000000000 0000000000000004 ffff000008e25000
ffff000008c46b38
[    1.647628] 3da0: ffff000008ca2798 ffff000008c91bdc ffff8003ecd13dd0
ffff0000080830b8
[    1.655444] 3dc0: ffff8003ecd13dc0 ffff8003ecd13dc0 ffff8003ecd13e40
ffff000008c50cf8
[    1.663259] 3de0: 000000000000011e ffff000008e25000 ffff000008ca2840
0000000000000004
[    1.671074] 3e00: ffff000008d0cf00 0000000000000000 ffff000008e25000
ffff000008b2da98
[    1.678890] 3e20: 0000000400000004 0000000000000000 0000000000000000
ffff000008c46b38
[    1.686705] 3e40: ffff8003ecd13ea0 ffff0000088ae008 ffff0000088adff8
0000000000000000
[    1.694520] 3e60: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.702336] 3e80: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.710151] 3ea0: 0000000000000000 ffff000008082e80 ffff0000088adff8
0000000000000000
[    1.717966] 3ec0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.725781] 3ee0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.733597] 3f00: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.741412] 3f20: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.749227] 3f40: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.757042] 3f60: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.764858] 3f80: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.772673] 3fa0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.780488] 3fc0: 0000000000000000 0000000000000005 0000000000000000
0000000000000000
[    1.788304] 3fe0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
[    1.796118] Call trace:
[    1.798551] Exception stack(0xffff8003ecd13aa0 to 0xffff8003ecd13bd0)
[    1.804978] 3aa0: ffff000008e0bf20 0001000000000000 ffff8003ecd13c70
0000000022c4a238
[    1.812794] 3ac0: ffff000008e2c6b8 0000000000000000 0000000000000000
ffff8003ecd13b20
[    1.820609] 3ae0: ffff0000080ff730 ffff8003ecd13b20 ffff8003ecd13b20
ffff0000080ff7a4
[    1.828425] 3b00: ffff8003ecd13b20 ffff0000080ff7dc ffff000008e2c000
ffff000008e2c6b8
[    1.836240] 3b20: ffff8003ecd13ba0 ffff0000080ffcfc ffff000008e2c000
ffff000008d6e398
[    1.844055] 3b40: ffff8003ecd13d28 ffff8003eca32800 ffff8003ecd13d30
0000000022c4a238
[    1.851871] 3b60: 0000000000000004 0000000000000000 0000000000000000
0000000000000000
[    1.859686] 3b80: ffff8003eca32c00 0000000000000000 0000000000000128
0000000000000006
[    1.867502] 3ba0: 0000000005f5e0ff 0000000000000001 0000000000000127
ffff000008e2cc35
[    1.875316] 3bc0: 0000000000000001 0000000000000000
[    1.880181] [<0000000022c4a238>] 0x22c4a238
[    1.884352] [<ffff00000875c8ac>] efivar_init+0x8c/0x348
[    1.889565] [<ffff000008c930fc>] efisubsys_init+0xd4/0x270
[    1.895037] [<ffff0000080830b8>] do_one_initcall+0x38/0x128
[    1.900596] [<ffff000008c50cf8>] kernel_init_freeable+0x1ac/0x250
[    1.906676] [<ffff0000088ae008>] kernel_init+0x10/0x108
[    1.911887] [<ffff000008082e80>] ret_from_fork+0x10/0x50
[    1.917187] Code: bad PC value
[    1.920238] ---[ end trace f3069799ac0efee7 ]---
[    1.924847] note: swapper/0[1] exited with preempt_count 2
[    1.930329] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[    1.930329]
[    1.939447] SMP: stopping secondary CPUs
[    1.943361] ---[ end Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[    1.943361]



[1] efi=debug output for v4.9.0:defconfig
[    0.000000] efi:   0x0000e1050000-0x0000e105ffff [Memory Mapped I/O  |RUN|  |
 |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e1300000-0x0000e1300fff [Memory Mapped I/O  |RUN|  |
 |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x0000e8200000-0x0000e827ffff [Memory Mapped I/O  |RUN|  |
 |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x008000000000-0x008001e7ffff [Runtime Data       |RUN|  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x008001e80000-0x008001ffffff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x008002000000-0x008002e7ffff [Loader Data        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x008002e80000-0x00801fdfffff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x00801fe00000-0x00801fe0ffff [Loader Data        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x00801fe10000-0x00801fffbfff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x00801fffc000-0x00801fffffff [Boot Data          |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x008020000000-0x0083f0ffffff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083f1000000-0x0083f101ffff [Boot Data          |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083f1020000-0x0083fb33afff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fb33b000-0x0083fc12dfff [Loader Code        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fc12e000-0x0083fced3fff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fced4000-0x0083fced4fff [Loader Data        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fced5000-0x0083fcff0fff [Loader Code        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fcff1000-0x0083fea67fff [Boot Data          |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083fea68000-0x0083febd3fff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083febd4000-0x0083ff186fff [Boot Code          |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff187000-0x0083ff1b6fff [Reserved           |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff1b7000-0x0083ff1c4fff [ACPI Reclaim Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff1c5000-0x0083ff20ffff [Conventional Memory|   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff210000-0x0083ff224fff [Loader Data        |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff225000-0x0083ff226fff [ACPI Memory NVS    |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff227000-0x0083ff34bfff [Runtime Data       |RUN|  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ff34c000-0x0083ffe42fff [Runtime Code       |RUN|  |
 |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] efi:   0x0083ffe43000-0x0083ffffffff [Boot Data          |   |  |
 |  |  |  |  |   |WB|WT|WC|UC]
