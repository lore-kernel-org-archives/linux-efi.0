From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/7] arm: add [U]EFI support
Date: Fri, 18 Jul 2014 15:00:52 +0100
Message-ID: <1405692053-7514-7-git-send-email-leif.lindholm@linaro.org>
References: <1405692053-7514-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405692053-7514-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
operates similarly to the x86 stub: it is a shim between the EFI
firmware and the normal zImage entry point, and sets up the environment
that the zImage is expecting.  This includes optionally loading the
initrd and device tree from the system partition based on the kernel
command line. Much of this code is shared with arm64.

This patch also implements basic support for UEFI runtime services in
the ARM architecture - a requirement for (among other things) using
efibootmgr to read and update the system boot configuration.
It uses the generic configuration table scanning code.

[Initial stub support]
Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
[Runtime Services support]
Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
[Stub as static library]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/Kconfig                      |   21 ++
 arch/arm/boot/compressed/.gitignore   |    2 +
 arch/arm/boot/compressed/Makefile     |   21 +-
 arch/arm/boot/compressed/efi-header.S |  117 +++++++++
 arch/arm/boot/compressed/efi-stub.c   |   92 +++++++
 arch/arm/boot/compressed/head.S       |   78 +++++-
 arch/arm/include/asm/efi.h            |   47 ++++
 arch/arm/kernel/Makefile              |    2 +
 arch/arm/kernel/efi.c                 |  435 +++++++++++++++++++++++++++++++++
 arch/arm/kernel/efi_phys.S            |   66 +++++
 arch/arm/kernel/setup.c               |    7 +-
 11 files changed, 879 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/boot/compressed/efi-header.S
 create mode 100644 arch/arm/boot/compressed/efi-stub.c
 create mode 100644 arch/arm/include/asm/efi.h
 create mode 100644 arch/arm/kernel/efi.c
 create mode 100644 arch/arm/kernel/efi_phys.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0f33848..78d8140b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2100,6 +2100,25 @@ config AUTO_ZRELADDR
 	  0xf8000000. This assumes the zImage being placed in the first 128MB
 	  from start of memory.
 
+config EFI_STUB
+	bool
+
+config EFI
+	bool "UEFI runtime service support"
+	depends on OF && !CPU_BIG_ENDIAN
+	select UCS2_STRING
+	select EARLY_IOREMAP
+	select EFI_PARAMS_FROM_FDT
+	select EFI_STUB
+	select EFI_ARMSTUB
+	---help---
+	  This option provides support for runtime services provided
+	  by UEFI firmware (such as non-volatile variables, realtime
+	  clock, and platform reset). A UEFI stub is also provided to
+	  allow the kernel to be booted as an EFI application. This
+	  is only useful for kernels that may run on systems that have
+	  UEFI firmware.
+
 endmenu
 
 menu "CPU Power Management"
@@ -2224,6 +2243,8 @@ source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+source "drivers/firmware/Kconfig"
+
 source "fs/Kconfig"
 
 source "arch/arm/Kconfig.debug"
diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
index 0714e03..cc3487e 100644
--- a/arch/arm/boot/compressed/.gitignore
+++ b/arch/arm/boot/compressed/.gitignore
@@ -14,8 +14,10 @@ vmlinux.lds
 # borrowed libfdt files
 fdt.c
 fdt.h
+fdt_empty_tree.c
 fdt_ro.c
 fdt_rw.c
+fdt_sw.c
 fdt_wip.c
 libfdt.h
 libfdt_internal.h
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 27536b1..841d38f 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -91,7 +91,7 @@ suffix_$(CONFIG_KERNEL_LZ4)  = lz4
 
 # Borrowed libfdt files for the ATAG compatibility mode
 
-libfdt		:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c
+libfdt		:= fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c
 libfdt_hdrs	:= fdt.h libfdt.h libfdt_internal.h
 
 libfdt_objs	:= $(addsuffix .o, $(basename $(libfdt)))
@@ -99,11 +99,26 @@ libfdt_objs	:= $(addsuffix .o, $(basename $(libfdt)))
 $(addprefix $(obj)/,$(libfdt) $(libfdt_hdrs)): $(obj)/%: $(srctree)/scripts/dtc/libfdt/%
 	$(call cmd,shipped)
 
-$(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o): \
+$(addprefix $(obj)/,$(libfdt_objs) atags_to_fdt.o efi-stub.o): \
 	$(addprefix $(obj)/,$(libfdt_hdrs))
 
 ifeq ($(CONFIG_ARM_ATAG_DTB_COMPAT),y)
-OBJS	+= $(libfdt_objs) atags_to_fdt.o
+OBJS	+= atags_to_fdt.o
+USE_LIBFDT = y
+endif
+
+ifeq ($(CONFIG_EFI),y)
+CFLAGS_efi-stub.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
+OBJS	+= efi-stub.o banner.o ../../../../drivers/firmware/efi/libstub/lib.a
+USE_LIBFDT = y
+
+$(obj)/banner.o: OBJCOPYFLAGS=-j .rodata
+$(obj)/banner.o: $(objtree)/init/version.o FORCE
+	$(call if_changed,objcopy)
+endif
+
+ifeq ($(USE_LIBFDT),y)
+OBJS	+= $(libfdt_objs)
 endif
 
 targets       := vmlinux vmlinux.lds \
diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
new file mode 100644
index 0000000..dbb7101
--- /dev/null
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -0,0 +1,117 @@
+@ Copyright (C) 2013 Linaro Ltd;  <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+@
+@ This file contains the PE/COFF header that is part of the
+@ EFI stub.
+@
+
+	.org	0x3c
+	@
+	@ The PE header can be anywhere in the file, but for
+	@ simplicity we keep it together with the MSDOS header
+	@ The offset to the PE/COFF header needs to be at offset
+	@ 0x3C in the MSDOS header.
+	@ The only 2 fields of the MSDOS header that are used are this
+	@ PE/COFF offset, and the "MZ" bytes at offset 0x0.
+	@
+	.long	pe_header			@ Offset to the PE header.
+
+      .align 3
+pe_header:
+	.ascii	"PE"
+	.short 	0
+
+coff_header:
+	.short	0x01c2				@ ARM or Thumb
+	.short	2				@ nr_sections
+	.long	0 				@ TimeDateStamp
+	.long	0				@ PointerToSymbolTable
+	.long	1				@ NumberOfSymbols
+	.short	section_table - optional_header	@ SizeOfOptionalHeader
+	.short	0x306				@ Characteristics.
+						@ IMAGE_FILE_32BIT_MACHINE |
+						@ IMAGE_FILE_DEBUG_STRIPPED |
+						@ IMAGE_FILE_EXECUTABLE_IMAGE |
+						@ IMAGE_FILE_LINE_NUMS_STRIPPED
+
+optional_header:
+	.short	0x10b				@ PE32 format
+	.byte	0x02				@ MajorLinkerVersion
+	.byte	0x14				@ MinorLinkerVersion
+
+	.long	_edata - efi_stub_entry		@ SizeOfCode
+
+	.long	0				@ SizeOfInitializedData
+	.long	0				@ SizeOfUninitializedData
+
+	.long	efi_stub_entry			@ AddressOfEntryPoint
+	.long	efi_stub_entry			@ BaseOfCode
+	.long	0				@ data
+
+extra_header_fields:
+	.long	0				@ ImageBase
+	.long	0x20				@ SectionAlignment
+	.long	0x8				@ FileAlignment
+	.short	0				@ MajorOperatingSystemVersion
+	.short	0				@ MinorOperatingSystemVersion
+	.short	0				@ MajorImageVersion
+	.short	0				@ MinorImageVersion
+	.short	0				@ MajorSubsystemVersion
+	.short	0				@ MinorSubsystemVersion
+	.long	0				@ Win32VersionValue
+
+	.long	_edata				@ SizeOfImage
+
+	@ Everything before the entry point is considered part of the header
+	.long	efi_stub_entry			@ SizeOfHeaders
+	.long	0				@ CheckSum
+	.short	0xa				@ Subsystem (EFI application)
+	.short	0				@ DllCharacteristics
+	.long	0				@ SizeOfStackReserve
+	.long	0				@ SizeOfStackCommit
+	.long	0				@ SizeOfHeapReserve
+	.long	0				@ SizeOfHeapCommit
+	.long	0				@ LoaderFlags
+	.long	0x6				@ NumberOfRvaAndSizes
+
+	.quad   0                               @ ExportTable
+	.quad   0                               @ ImportTable
+	.quad   0                               @ ResourceTable
+	.quad   0                               @ ExceptionTable
+	.quad   0                               @ CertificationTable
+	.quad   0                               @ BaseRelocationTable
+	# Section table
+section_table:
+
+	#
+	# The EFI application loader requires a relocation section
+	# because EFI applications must be relocatable.  This is a
+	# dummy section as far as we are concerned.
+	#
+	.ascii	".reloc"
+	.byte	0
+	.byte	0			@ end of 0 padding of section name
+	.long	0
+	.long	0
+	.long	0			@ SizeOfRawData
+	.long	0			@ PointerToRawData
+	.long	0			@ PointerToRelocations
+	.long	0			@ PointerToLineNumbers
+	.short	0			@ NumberOfRelocations
+	.short	0			@ NumberOfLineNumbers
+	.long	0x42100040		@ Characteristics (section flags)
+
+
+	.ascii	".text"
+	.byte	0
+	.byte	0
+	.byte	0        		@ end of 0 padding of section name
+	.long	_edata - efi_stub_entry		@ VirtualSize
+	.long	efi_stub_entry			@ VirtualAddress
+	.long	_edata - efi_stub_entry		@ SizeOfRawData
+	.long	efi_stub_entry			@ PointerToRawData
+
+	.long	0		@ PointerToRelocations (0 for executables)
+	.long	0		@ PointerToLineNumbers (0 for executables)
+	.short	0		@ NumberOfRelocations  (0 for executables)
+	.short	0		@ NumberOfLineNumbers  (0 for executables)
+	.long	0xe0500020	@ Characteristics (section flags)
diff --git a/arch/arm/boot/compressed/efi-stub.c b/arch/arm/boot/compressed/efi-stub.c
new file mode 100644
index 0000000..1341229
--- /dev/null
+++ b/arch/arm/boot/compressed/efi-stub.c
@@ -0,0 +1,92 @@
+/*
+ * linux/arch/arm/boot/compressed/efi-stub.c
+ *
+ * Copyright (C) 2013 Linaro Ltd;  <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * This file implements the EFI boot stub for the ARM kernel
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
+				 unsigned long *image_addr,
+				 unsigned long *image_size,
+				 unsigned long *reserve_addr,
+				 unsigned long *reserve_size,
+				 unsigned long dram_base,
+				 efi_loaded_image_t *image)
+{
+	unsigned long nr_pages;
+	efi_status_t status;
+	/* Use alloc_addr to tranlsate between types */
+	efi_physical_addr_t alloc_addr;
+
+	/*
+	 * Verify that the DRAM base address is compatible the the ARM
+	 * boot protocol, which determines the base of DRAM by masking
+	 * off the low 24 bits of the address at which the zImage is
+	 * loaded at.  These assumptions are made by the decompressor,
+	 * before any memory map is available.
+	 */
+	if (dram_base & (ZIMAGE_OFFSET_LIMIT - 1)) {
+		pr_efi_err(sys_table, "Invalid DRAM base address alignment.\n");
+		return EFI_LOAD_ERROR;
+	}
+
+	/*
+	 * Reserve memory for the uncompressed kernel image. This is
+	 * all that prevents any future allocations from conflicting
+	 * with the kernel.  Since we can't tell from the compressed
+	 * image how much DRAM the kernel actually uses (due to BSS
+	 * size uncertainty) we allocate the maximum possible size.
+	 * Do this very early, as prints can cause memory allocations
+	 * that may conflict with this.
+	 */
+	alloc_addr = dram_base;
+	*reserve_size = MAX_UNCOMP_KERNEL_SIZE;
+	nr_pages = round_up(*reserve_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	status = sys_table->boottime->allocate_pages(EFI_ALLOCATE_ADDRESS,
+						     EFI_LOADER_DATA,
+						     nr_pages, &alloc_addr);
+	if (status != EFI_SUCCESS) {
+		*reserve_size = 0;
+		pr_efi_err(sys_table, "Unable to allocate memory for uncompressed kernel.\n");
+		return status;
+	}
+	*reserve_addr = alloc_addr;
+
+	/*
+	 * Relocate the zImage, if required.  ARM doesn't have a
+	 * preferred address, so we set it to 0, as we want to allocate
+	 * as low in memory as possible.
+	 */
+	*image_size = image->image_size;
+	status = efi_relocate_kernel(sys_table, image_addr, *image_size,
+				     *image_size, 0, 0);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to relocate kernel.\n");
+		efi_free(sys_table, *reserve_size, *reserve_addr);
+		*reserve_size = 0;
+		return status;
+	}
+
+	/*
+	 * Check to see if we were able to allocate memory low enough
+	 * in memory.  The kernel determines the base of DRAM from the
+	 * address at which the zImage is loaded.
+	 */
+	if (*image_addr + *image_size > dram_base + ZIMAGE_OFFSET_LIMIT) {
+		pr_efi_err(sys_table, "Failed to relocate kernel, no low memory available.\n");
+		efi_free(sys_table, *reserve_size, *reserve_addr);
+		*reserve_size = 0;
+		efi_free(sys_table, *image_size, *image_addr);
+		*image_size = 0;
+		return EFI_LOAD_ERROR;
+	}
+	return EFI_SUCCESS;
+}
diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 3a8b32d..8e808cf 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -117,19 +117,89 @@
 		.arm				@ Always enter in ARM state
 start:
 		.type	start,#function
+#ifdef CONFIG_EFI
+		@ Magic MSDOS signature for PE/COFF + ADD opcode
+		@ the EFI stub only supports little endian, as the EFI functions
+		@ it invokes are little endian.
+		.word	0x62805a4d
+#else
+		mov	r0, r0
+#endif
 		.rept	7
 		mov	r0, r0
 		.endr
-   ARM(		mov	r0, r0		)
-   ARM(		b	1f		)
- THUMB(		adr	r12, BSYM(1f)	)
- THUMB(		bx	r12		)
+
+ ARM(		b	zimage_continue	)
+ THUMB(		blx	zimage_continue	)	@ Unconditional state change
+		@ zimage_continue will be in ARM or thumb mode as configured
 
 		.word	0x016f2818		@ Magic numbers to help the loader
 		.word	start			@ absolute load/run zImage address
 		.word	_edata			@ zImage end address
+
+#ifdef CONFIG_EFI
+		@ Portions of the MSDOS file header must be at offset
+		@ 0x3c from the start of the file.  All PE/COFF headers
+		@ are kept contiguous for simplicity.
+#include "efi-header.S"
+
+efi_stub_entry:
+		@ The EFI stub entry point is not at a fixed address, however
+		@ this address must be set in the PE/COFF header.
+		@ EFI entry point is in A32 mode, switch to T32 if configured.
+ THUMB(		adr	r12, BSYM(1f)	)
+ THUMB(		bx	r12		)
  THUMB(		.thumb			)
 1:
+		@ Save lr on stack for possible return to EFI firmware.
+		@ Don't care about fp, but need 64 bit alignment....
+		stmfd	sp!, {fp, lr}
+
+		@ allocate space on stack for passing current zImage address
+		@ and for the EFI stub to return of new entry point of
+		@ zImage, as EFI stub may copy the kernel.  Pointer address
+		@ is passed in r2.  r0 and r1 are passed through from the
+		@ EFI firmware to efi_entry
+		adr	r3, start
+		str	r3, [sp, #-8]!
+		mov	r2, sp			@ pass pointer in r2
+		bl	efi_entry
+		ldr	r3, [sp], #8	@ get new zImage address from stack
+
+		@ Check for error return from EFI stub.  r0 has FDT address
+		@ or error code.
+		cmn	r0, #1
+		beq	efi_load_fail
+
+		@ Save return values of efi_entry
+		stmfd	sp!, {r0, r3}
+		bl	cache_clean_flush
+		bl	cache_off
+		ldmfd   sp!, {r0, r3}
+
+		@ Set parameters for booting zImage according to boot protocol
+		@ put FDT address in r2, it was returned by efi_entry()
+		@ r1 is FDT machine type, and r0 needs to be 0
+		mov	r2, r0
+		mov	r1, #0xFFFFFFFF
+		mov	r0, #0
+
+		@ Branch to (possibly) relocated zImage that is in r3
+		@ Make sure we are in A32 mode, as zImage requires
+ THUMB(		bx	r3		)
+ ARM(		mov	pc, r3		)
+
+efi_load_fail:
+		@ Return EFI_LOAD_ERROR to EFI firmware on error.
+		@ Switch back to ARM mode for EFI is done based on
+		@ return address on stack in case we are in THUMB mode
+		mov	r0, #0x80000000		@ 0x80000001, avoiding
+		orr	r0, #1			@ literal pool generation
+		ldmfd	sp!, {fp, pc}		@ put lr from stack into pc
+#endif
+
+ THUMB(		.thumb			)
+zimage_continue:
  ARM_BE8(	setend	be )			@ go BE8 if compiled for BE8
 		mrs	r9, cpsr
 #ifdef CONFIG_ARM_VIRT_EXT
diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
new file mode 100644
index 0000000..f4fc276
--- /dev/null
+++ b/arch/arm/include/asm/efi.h
@@ -0,0 +1,47 @@
+#ifndef _ASM_ARM_EFI_H
+#define _ASM_ARM_EFI_H
+
+#ifdef CONFIG_EFI
+#include <asm/mach/map.h>
+
+extern void efi_init(void);
+
+typedef efi_status_t uefi_phys_call_t(efi_set_virtual_address_map_t *f,
+				      u32 virt_phys_offset,
+				      u32 memory_map_size,
+				      u32 descriptor_size,
+				      u32 descriptor_version,
+				      efi_memory_desc_t *dsc);
+
+asmlinkage uefi_phys_call_t uefi_phys_call;
+
+#define uefi_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY_RWX)
+#define uefi_ioremap(cookie, size) __arm_ioremap((cookie), (size), MT_DEVICE)
+#define uefi_unmap(cookie) __arm_iounmap((cookie))
+#define uefi_iounmap(cookie) __arm_iounmap((cookie))
+
+#else
+#define efi_init()
+#endif /* CONFIG_EFI */
+
+#define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
+
+/*
+ * The maximum uncompressed kernel size is 32 MBytes, so we will reserve
+ * that for the decompressed kernel.  We have no easy way to tell what
+ * the actuall size of code + data the uncompressed kernel will use.
+ */
+#define MAX_UNCOMP_KERNEL_SIZE 0x02000000
+
+/*
+ * The kernel zImage should be located between 32 Mbytes
+ * and 128 MBytes from the base of DRAM.  The min
+ * address leaves space for a maximal size uncompressed image,
+ * and the max address is due to how the zImage decompressor
+ * picks a destination address.
+ */
+#define ZIMAGE_OFFSET_LIMIT    0x08000000
+#define MIN_ZIMAGE_OFFSET      MAX_UNCOMP_KERNEL_SIZE
+#define MAX_FDT_OFFSET         ZIMAGE_OFFSET_LIMIT
+
+#endif /* _ASM_ARM_EFI_H */
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 38ddd9f..d7d4263 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -101,4 +101,6 @@ obj-y				+= psci.o
 obj-$(CONFIG_SMP)		+= psci_smp.o
 endif
 
+obj-$(CONFIG_EFI)		+= efi.o efi_phys.o
+
 extra-y := $(head-y) vmlinux.lds
diff --git a/arch/arm/kernel/efi.c b/arch/arm/kernel/efi.c
new file mode 100644
index 0000000..4c4a1e8
--- /dev/null
+++ b/arch/arm/kernel/efi.c
@@ -0,0 +1,435 @@
+/*
+ * Based on Unified Extensible Firmware Interface Specification version 2.3.1
+ *
+ * Copyright (C) 2013-2014  Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/efi.h>
+#include <linux/export.h>
+#include <linux/memblock.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <asm/cacheflush.h>
+#include <asm/idmap.h>
+#include <asm/setup.h>
+#include <asm/tlbflush.h>
+#include <asm/efi.h>
+
+struct efi_memory_map memmap;
+
+static efi_runtime_services_t *runtime;
+
+static phys_addr_t uefi_system_table;
+static phys_addr_t uefi_boot_mmap;
+static u32 uefi_boot_mmap_size;
+static u32 uefi_mmap_desc_size;
+static u32 uefi_mmap_desc_ver;
+
+/*
+ * If you want to wire up a debugger and debug the UEFI side, set to 0.
+ */
+#define DISCARD_UNUSED_REGIONS 1
+
+/*
+ * If you need to (temporarily) support buggy firmware, set to 0.
+ */
+#define DISCARD_BOOT_SERVICES_REGIONS 1
+
+static int uefi_debug __initdata;
+static int __init uefi_debug_setup(char *str)
+{
+	uefi_debug = 1;
+
+	return 0;
+}
+early_param("uefi_debug", uefi_debug_setup);
+
+static int __init uefi_systab_init(void)
+{
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i, retval;
+
+	efi.systab = early_memremap(uefi_system_table,
+				    sizeof(efi_system_table_t));
+
+	/*
+	 * Verify the UEFI System Table
+	 */
+	if (efi.systab == NULL)
+		panic("Whoa! Can't find UEFI system table.\n");
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		panic("Whoa! UEFI system table signature incorrect\n");
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		pr_warn("Warning: UEFI system table version %d.%02d, expected 2.30 or greater\n",
+			efi.systab->hdr.revision >> 16,
+			efi.systab->hdr.revision & 0xffff);
+
+	/* Show what we know for posterity */
+	c16 = early_memremap(efi.systab->fw_vendor, sizeof(vendor));
+	if (c16) {
+		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
+			vendor[i] = c16[i];
+		vendor[i] = '\0';
+	}
+
+	pr_info("UEFI v%u.%.02u by %s\n",
+		efi.systab->hdr.revision >> 16,
+		efi.systab->hdr.revision & 0xffff, vendor);
+
+	retval = efi_config_init(NULL);
+	if (retval == 0)
+		set_bit(EFI_CONFIG_TABLES, &efi.flags);
+
+	early_memunmap(c16, sizeof(vendor));
+	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
+
+	return retval;
+}
+
+static __init int is_discardable_region(efi_memory_desc_t *md)
+{
+	if (md->attribute & EFI_MEMORY_RUNTIME)
+		return 0;
+
+	switch (md->type) {
+	case EFI_CONVENTIONAL_MEMORY:
+		return 1;
+	case EFI_BOOT_SERVICES_CODE:
+	case EFI_BOOT_SERVICES_DATA:
+		return DISCARD_BOOT_SERVICES_REGIONS;
+	/* Keep tables around for any future kexec operations */
+	case EFI_ACPI_MEMORY_NVS:
+	case EFI_ACPI_RECLAIM_MEMORY:
+		return 0;
+	/* Preserve */
+	case EFI_RESERVED_TYPE:
+		return 0;
+	}
+
+	return DISCARD_UNUSED_REGIONS;
+}
+
+static __initdata struct {
+	u32 type;
+	const char *name;
+}  memory_type_name_map[] = {
+	{EFI_RESERVED_TYPE, "reserved"},
+	{EFI_LOADER_CODE, "loader code"},
+	{EFI_LOADER_DATA, "loader data"},
+	{EFI_BOOT_SERVICES_CODE, "boot services code"},
+	{EFI_BOOT_SERVICES_DATA, "boot services data"},
+	{EFI_RUNTIME_SERVICES_CODE, "runtime services code"},
+	{EFI_RUNTIME_SERVICES_DATA, "runtime services data"},
+	{EFI_CONVENTIONAL_MEMORY, "conventional memory"},
+	{EFI_UNUSABLE_MEMORY, "unusable memory"},
+	{EFI_ACPI_RECLAIM_MEMORY, "ACPI reclaim memory"},
+	{EFI_ACPI_MEMORY_NVS, "ACPI memory nvs"},
+	{EFI_MEMORY_MAPPED_IO, "memory mapped I/O"},
+	{EFI_MEMORY_MAPPED_IO_PORT_SPACE, "memory mapped I/O port space"},
+	{EFI_PAL_CODE, "pal code"},
+	{EFI_MAX_MEMORY_TYPE, NULL},
+};
+
+static __init void remove_sections(phys_addr_t addr, unsigned long size)
+{
+	unsigned long section_offset;
+	unsigned long num_sections;
+
+	section_offset = addr - (addr & SECTION_MASK);
+	num_sections = size / SECTION_SIZE;
+	if (size % SECTION_SIZE)
+		num_sections++;
+
+	memblock_remove(addr - section_offset, num_sections * SECTION_SIZE);
+}
+
+static void memmap_init(void)
+{
+	efi_memory_desc_t *md;
+	int i = 0;
+
+	if (uefi_debug)
+		pr_info("Processing UEFI memory map:\n");
+
+	memmap.map = early_memremap(uefi_boot_mmap, uefi_boot_mmap_size);
+	if (!memmap.map)
+		return;
+
+	memmap.map_end = memmap.map + uefi_boot_mmap_size;
+	memmap.nr_map = 0;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		pr_info("  %8llu pages @ %016llx (%s)\n",
+			md->num_pages, md->phys_addr,
+			memory_type_name_map[md->type].name);
+		if (md->attribute & EFI_MEMORY_WB) {
+			if (is_discardable_region(md)) {
+				arm_add_memory(md->phys_addr,
+					       md->num_pages * EFI_PAGE_SIZE);
+				i++;
+			}
+		}
+		memmap.nr_map++;
+	}
+
+	if (uefi_debug)
+		pr_info("%d memory regions added.\n", i);
+
+	remove_sections(uefi_boot_mmap, uefi_boot_mmap_size);
+
+	early_memunmap(memmap.map, uefi_boot_mmap_size);
+
+	set_bit(EFI_MEMMAP, &efi.flags);
+}
+
+void __init efi_init(void)
+{
+	struct efi_fdt_params params;
+
+	uefi_debug = 1;
+
+	/* Grab UEFI information placed in FDT by stub */
+	if (!efi_get_fdt_params(&params, uefi_debug))
+		return;
+
+	uefi_system_table = params.system_table;
+
+	uefi_boot_mmap = params.mmap;
+	uefi_boot_mmap_size = params.mmap_size;
+	uefi_mmap_desc_size = params.desc_size;
+	uefi_mmap_desc_ver = params.desc_ver;
+	memmap.desc_size = uefi_mmap_desc_size;
+	memmap.map_end = memmap.map + params.mmap_size;
+	if (uefi_boot_mmap > UINT_MAX) {
+		pr_err("UEFI memory map located above 4GB - unusable!");
+		return;
+	}
+
+	if (uefi_systab_init() < 0)
+		return;
+
+	memmap_init();
+
+	set_bit(EFI_BOOT, &efi.flags);
+}
+
+/*
+ * Disable instrrupts, enable idmap and disable caches.
+ */
+static void __init phys_call_prologue(void)
+{
+	local_irq_disable();
+
+	outer_disable();
+
+	idmap_prepare();
+}
+
+/*
+ * Restore original memory map and re-enable interrupts.
+ */
+static void __init phys_call_epilogue(void)
+{
+	static struct mm_struct *mm = &init_mm;
+
+	/* Restore original memory mapping */
+	cpu_switch_mm(mm->pgd, mm);
+
+	local_flush_bp_all();
+	local_flush_tlb_all();
+
+	outer_resume();
+
+	local_irq_enable();
+}
+
+static int __init remap_region(efi_memory_desc_t *md, int entry)
+{
+	efi_memory_desc_t *region;
+	u32 va;
+	u64 paddr;
+	u64 size;
+
+	region = memmap.map + entry * memmap.desc_size;
+	*region = *md;
+	paddr = region->phys_addr;
+	size = region->num_pages << EFI_PAGE_SHIFT;
+
+	/*
+	 * Map everything writeback-capable as coherent memory,
+	 * anything else as device.
+	 */
+	if (md->attribute & EFI_MEMORY_WB)
+		va = (u32)uefi_remap(paddr, size);
+	else
+		va = (u32)uefi_ioremap(paddr, size);
+	if (!va)
+		return 0;
+	region->virt_addr = va;
+
+	if (uefi_debug)
+		pr_info("  %016llx-%016llx => 0x%08x : (%s)\n",
+			paddr, paddr + size - 1, va,
+			md->attribute &  EFI_MEMORY_WB ? "WB" : "I/O");
+
+	return 1;
+}
+
+static int __init remap_regions(void)
+{
+	void *p;
+	efi_memory_desc_t *md;
+	int mapped_regions;
+
+	memmap.phys_map = uefi_remap(uefi_boot_mmap, uefi_boot_mmap_size);
+	if (!memmap.phys_map)
+		return 0;
+
+	memmap.map_end = memmap.phys_map + uefi_boot_mmap_size;
+	memmap.desc_size = uefi_mmap_desc_size;
+	memmap.desc_version = uefi_mmap_desc_ver;
+
+	/* Allocate space for the physical region map */
+	memmap.map = kzalloc(memmap.nr_map * memmap.desc_size, GFP_ATOMIC);
+	if (!memmap.map)
+		return 0;
+
+	mapped_regions = 0;
+	for (p = memmap.phys_map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (is_discardable_region(md))
+			continue;
+
+		if (remap_region(p, mapped_regions))
+			mapped_regions++;
+		else
+			goto err_unmap;
+	}
+
+	memmap.map_end = memmap.map + mapped_regions * memmap.desc_size;
+	efi.memmap = &memmap;
+
+	uefi_unmap(memmap.phys_map);
+	memmap.phys_map = efi_lookup_mapped_addr(uefi_boot_mmap);
+	efi.systab = efi_lookup_mapped_addr(uefi_system_table);
+	if (!efi.systab) {
+		pr_err("Failed to locate UEFI System Table after remap -- buggy firmware?\n");
+		goto err_unmap;
+	}
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+
+	/*
+	 * efi.systab->runtime is a 32-bit pointer to something guaranteed by
+	 * the UEFI specification to be 1:1 mapped in a 4GB address space.
+	 */
+	runtime = efi_lookup_mapped_addr((u32)efi.systab->runtime);
+
+	return 1;
+
+err_unmap:
+	/*
+	 * Unmap the successfully mapped regions.
+	 */
+	for_each_efi_memory_desc(&memmap, md) {
+		if (is_discardable_region(md))
+			continue;
+		if (!mapped_regions--)
+			break;
+		iounmap((__force void *)(u32)(md->virt_addr));
+	}
+	kfree(memmap.map);
+	memmap.map = NULL;
+
+	return 0;
+}
+
+
+/*
+ * This function switches the UEFI runtime services to virtual mode.
+ * This operation must be performed only once in the system's lifetime,
+ * including any kexec calls.
+ *
+ * This must be done with a 1:1 mapping. The current implementation
+ * resolves this by disabling the MMU.
+ */
+efi_status_t  __init phys_set_virtual_address_map(u32 memory_map_size,
+						  u32 descriptor_size,
+						  u32 descriptor_version,
+						  efi_memory_desc_t *dsc)
+{
+	uefi_phys_call_t *phys_set_map;
+	efi_status_t status;
+
+	phys_call_prologue();
+
+	phys_set_map = (void *)(unsigned long)virt_to_phys(uefi_phys_call);
+
+	/* Called with caches disabled, returns with caches enabled */
+	status = phys_set_map(efi.set_virtual_address_map,
+			      PAGE_OFFSET - PHYS_OFFSET,
+			      memory_map_size, descriptor_size,
+			      descriptor_version, dsc);
+
+	phys_call_epilogue();
+
+	return status;
+}
+
+/*
+ * Called explicitly from init/mm.c
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	efi_status_t status;
+	u32 mmap_phys_addr;
+
+	if (!efi_enabled(EFI_BOOT)) {
+		pr_info("UEFI services will not be available.\n");
+		return;
+	}
+
+	pr_info("Remapping and enabling UEFI services.\n");
+
+	/* Map the regions we memblock_remove:d earlier into kernel
+	   address space */
+	if (!remap_regions()) {
+		pr_info("Failed to remap UEFI regions - runtime services will not be available.\n");
+		return;
+	}
+
+	/* Call SetVirtualAddressMap with the physical address of the map */
+	efi.set_virtual_address_map = runtime->set_virtual_address_map;
+
+	/*
+	 * __virt_to_phys() takes an unsigned long and returns a phys_addr_t
+	 * memmap.phys_map is a void *
+	 * The gymnastics below makes this compile validly with/without LPAE.
+	 */
+	mmap_phys_addr = __virt_to_phys((u32)memmap.map);
+	memmap.phys_map = (void *)mmap_phys_addr;
+
+	status = phys_set_virtual_address_map(memmap.nr_map * memmap.desc_size,
+					      memmap.desc_size,
+					      memmap.desc_version,
+					      memmap.phys_map);
+	if (status != EFI_SUCCESS) {
+		pr_info("Failed to set UEFI virtual address map!\n");
+		return;
+	}
+
+	/* Set up function pointers for efivars */
+	efi.get_variable = runtime->get_variable;
+	efi.get_next_variable = runtime->get_next_variable;
+	efi.set_variable = runtime->set_variable;
+	efi.set_virtual_address_map = NULL;
+
+	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+}
diff --git a/arch/arm/kernel/efi_phys.S b/arch/arm/kernel/efi_phys.S
new file mode 100644
index 0000000..e808b57
--- /dev/null
+++ b/arch/arm/kernel/efi_phys.S
@@ -0,0 +1,66 @@
+/*
+ * arch/arm/kernel/efi_phys.S
+ *
+ * Copyright (C) 2013  Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/assembler.h>
+#include <asm/cp15.h>
+#include <linux/linkage.h>
+
+@ uefi_phys_call(*f, virt_phys_offset, a, b, c, d, ...)
+	.section    .idmap.text, "ax"
+	.align  5
+ENTRY(uefi_phys_call)
+	@ Save physical context
+	mov	r12, sp
+	ldr	sp, =tmpstack
+	stmfd	sp, {r4-r5, r12, lr}	@ push is redefined by asm/assembler.h
+
+	mov	r4, r1
+
+	@ Extract function pointer (don't write lr again before call)
+	mov	lr, r0
+
+	@ Shift arguments down
+	mov	r0, r2
+	mov	r1, r3
+	ldr	r2, [r12], #4
+	ldr	r3, [r12], #4
+
+	@ Convert sp to physical
+	sub	r12, r12, r4
+	mov	sp, r12
+
+	@ Disable MMU
+	ldr	r5, =(CR_M)
+	update_sctlr	r12, , r5
+	isb
+
+	@ Make call
+	blx	lr
+
+	@ Enable MMU + Caches
+	ldr	r4, =(CR_I | CR_C | CR_M)
+	update_sctlr	r12, r4
+	isb
+
+	ldr	sp, =tmpstack_top
+	ldmfd	sp, {r4-r5, r12, lr}
+
+	@ Restore virtual sp and return
+	mov	sp, r12
+	bx	lr
+
+	.align	3
+tmpstack_top:
+	.long	0	@ r4
+	.long	0	@ r5
+	.long	0	@ r12
+	.long	0	@ lr
+tmpstack:
+ENDPROC(uefi_phys_call)
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index aa2621a..41b37aa 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -30,6 +30,7 @@
 #include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/sort.h>
+#include <linux/efi.h>
 
 #include <asm/unified.h>
 #include <asm/cp15.h>
@@ -57,6 +58,7 @@
 #include <asm/unwind.h>
 #include <asm/memblock.h>
 #include <asm/virt.h>
+#include <asm/efi.h>
 
 #include "atags.h"
 
@@ -884,6 +886,9 @@ void __init setup_arch(char **cmdline_p)
 	if (mdesc->reboot_mode != REBOOT_HARD)
 		reboot_mode = mdesc->reboot_mode;
 
+	early_ioremap_init();
+	efi_init();
+
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code   = (unsigned long) _etext;
 	init_mm.end_data   = (unsigned long) _edata;
@@ -895,8 +900,6 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
-	early_ioremap_init();
-
 	early_paging_init(mdesc, lookup_processor_type(read_cpuid_id()));
 	setup_dma_zone(mdesc);
 	sanity_check_meminfo();
-- 
1.7.10.4
