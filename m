From: Mark Salter <msalter@redhat.com>
Subject: [PATCH 4/6] arm64: add EFI stub
Date: Fri, 10 Jan 2014 17:29:08 -0500
Message-ID: <1389392950-22457-5-git-send-email-msalter@redhat.com>
References: <1389392950-22457-1-git-send-email-msalter@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1389392950-22457-1-git-send-email-msalter@redhat.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>, matt.fleming@intel.com, patches@linaro.org, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org, linux-efi@vger.kernel.org, Mark Salter <msalter@redhat.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

This patch adds PE/COFF header fields to the start of the Image
so that it appears as an EFI application to EFI firmware. An EFI
stub is included to allow direct booting of the kernel Image. Due
to EFI firmware limitations, only little endian kernels with 4K
page sizes are supported at this time. Support in the COFF header
for signed images was provided by Ard Biesheuvel.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig            |  10 +++
 arch/arm64/kernel/Makefile    |   3 +
 arch/arm64/kernel/efi-entry.S |  93 ++++++++++++++++++++++
 arch/arm64/kernel/efi-stub.c  | 181 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S      | 112 ++++++++++++++++++++++++++
 5 files changed, 399 insertions(+)
 create mode 100644 arch/arm64/kernel/efi-entry.S
 create mode 100644 arch/arm64/kernel/efi-stub.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e66a317..3f1c2b2 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -249,6 +249,16 @@ config CMDLINE_FORCE
 	  This is useful if you cannot or don't want to change the
 	  command-line options your boot loader passes to the kernel.
 
+config EFI_STUB
+	bool "EFI stub support"
+	depends on !ARM64_64K_PAGES && OF
+	select LIBFDT
+	default y
+	help
+	  This kernel feature allows an Image to be loaded directly
+	  by EFI firmware without the use of a bootloader.
+	  See Documentation/efi-stub.txt for more information.
+
 endmenu
 
 menu "Userspace binary formats"
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 5ba2fd4..1c52b84 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -4,6 +4,8 @@
 
 CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
+CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET) \
+			   -I$(src)/../../../scripts/dtc/libfdt
 
 # Object file lists.
 arm64-obj-y		:= cputable.o debug-monitors.o entry.o irq.o fpsimd.o	\
@@ -18,6 +20,7 @@ arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o
 arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+arm64-obj-$(CONFIG_EFI_STUB)		+= efi-stub.o efi-entry.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
new file mode 100644
index 0000000..83bfb72
--- /dev/null
+++ b/arch/arm64/kernel/efi-entry.S
@@ -0,0 +1,93 @@
+/*
+ * EFI entry point.
+ *
+ * Copyright (C) 2013 Red Hat, Inc.
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+#include <asm/assembler.h>
+
+#define EFI_LOAD_ERROR 0x8000000000000001
+
+	__INIT
+
+	/*
+	 * We arrive here from the EFI boot manager with:
+	 *
+	 *    * MMU on with identity-mapped RAM.
+	 *    * Icache and Dcache on
+	 *
+	 * We will most likely be running from some place other than where
+	 * we want to be. The kernel image wants to be placed at TEXT_OFFSET
+	 * from start of RAM.
+	 */
+ENTRY(efi_stub_entry)
+	stp	x29, x30, [sp, #-32]!
+
+	/*
+	 * Call efi_entry to do the real work.
+	 * x0 and x1 are already set up by firmware. Current runtime
+	 * address of image is calculated and passed via *image_addr.
+	 *
+	 * unsigned long efi_entry(void *handle,
+	 *                         efi_system_table_t *sys_table,
+	 *                         unsigned long *image_addr) ;
+	 */
+	adrp	x8, _text
+        add	x8, x8, #:lo12:_text
+	add	x2, sp, 16
+	str	x8, [x2]
+	bl	efi_entry
+	cmn	x0, #1
+	b.eq	efi_load_fail
+
+	/*
+	 * efi_entry() will have relocated the kernel image if necessary
+	 * and we return here with device tree address in x0 and the kernel
+	 * entry point stored at *image_addr. Save those values in registers
+	 * which are preserved by __flush_dcache_all.
+	 */
+	ldr	x1, [sp, #16]
+	mov	x20, x0
+	mov	x21, x1
+
+	/* Turn off Dcache and MMU */
+	mrs	x0, CurrentEL
+	cmp	x0, #PSR_MODE_EL2t
+	ccmp	x0, #PSR_MODE_EL2h, #0x4, ne
+	b.ne	1f
+	mrs	x0, sctlr_el2
+	bic	x0, x0, #1 << 0	// clear SCTLR.M
+	bic	x0, x0, #1 << 2	// clear SCTLR.C
+	msr	sctlr_el2, x0
+	isb
+	b	2f
+1:
+	mrs	x0, sctlr_el1
+	bic	x0, x0, #1 << 0	// clear SCTLR.M
+	bic	x0, x0, #1 << 2	// clear SCTLR.C
+	msr	sctlr_el1, x0
+	isb
+2:
+	bl	__flush_dcache_all
+
+	/* Jump to real entry point */
+	mov	x0, x20
+	mov	x1, xzr
+	mov	x2, xzr
+	mov	x3, xzr
+	br	x21
+
+efi_load_fail:
+	mov	x0, #EFI_LOAD_ERROR
+	ldp	x29, x30, [sp], #32
+	ret
+
+ENDPROC(efi_stub_entry)
diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
new file mode 100644
index 0000000..10d02bf
--- /dev/null
+++ b/arch/arm64/kernel/efi-stub.c
@@ -0,0 +1,181 @@
+/*
+ * linux/arch/arm/boot/compressed/efi-stub.c
+ *
+ * Copyright (C) 2013, 2014 Linaro Ltd;  <roy.franz@linaro.org>
+ *
+ * This file implements the EFI boot stub for the arm64 kernel.
+ * Adapted from ARM version by Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/efi.h>
+#include <linux/libfdt.h>
+#include <asm/sections.h>
+#include <generated/compile.h>
+#include <generated/utsrelease.h>
+
+/* error code which can't be mistaken for valid address */
+#define EFI_ERROR	(~0UL)
+
+/*
+ * EFI function call wrappers. These are not required for arm64, but wrappers
+ * are required for X86 to convert between ABIs. These wrappers are provided
+ * to allow code sharing between X86 and other architectures. Since these
+ * wrappers directly invoke the EFI function pointer, the function pointer
+ * type must be properly defined, which is not the case for X86. One advantage
+ * of this is it allows for type checking of arguments, which is not possible
+ * with the X86 wrappers.
+ */
+#define efi_call_phys0(f)			f()
+#define efi_call_phys1(f, a1)			f(a1)
+#define efi_call_phys2(f, a1, a2)		f(a1, a2)
+#define efi_call_phys3(f, a1, a2, a3)		f(a1, a2, a3)
+#define efi_call_phys4(f, a1, a2, a3, a4)	f(a1, a2, a3, a4)
+#define efi_call_phys5(f, a1, a2, a3, a4, a5)	f(a1, a2, a3, a4, a5)
+
+/*
+ * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
+ * start of kernel and may not cross a 2MiB boundary. We set alignment to
+ * 2MiB so we know it won't cross a 2MiB boundary.
+ */
+#define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
+#define MAX_FDT_OFFSET	SZ_512M
+
+/* Include shared EFI stub code */
+#include "../../../drivers/firmware/efi/efi-stub-helper.c"
+#include "../../../drivers/firmware/efi/fdt.c"
+
+static unsigned long __init get_dram_base(efi_system_table_t *sys_table)
+{
+	efi_status_t status;
+	unsigned long map_size;
+	unsigned long membase  = EFI_ERROR;
+	struct efi_memory_map map;
+	efi_memory_desc_t *md;
+
+	status = efi_get_memory_map(sys_table, (efi_memory_desc_t **)&map.map,
+				    &map_size, &map.desc_size, NULL, NULL);
+	if (status != EFI_SUCCESS)
+		return membase;
+
+	map.map_end = map.map + map_size;
+
+	for_each_efi_memory_desc(&map, md)
+		if (md->type == EFI_CONVENTIONAL_MEMORY)
+			if (membase > md->phys_addr)
+				membase = md->phys_addr;
+
+	efi_call_phys1(sys_table->boottime->free_pool, map.map);
+
+	return membase;
+}
+
+unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
+			       unsigned long *image_addr)
+{
+	efi_loaded_image_t *image;
+	efi_status_t status;
+	unsigned long image_size, image_memsize = 0;
+	unsigned long dram_base;
+	/* addr/point and size pairs for memory management*/
+	u64 initrd_addr;
+	u64 initrd_size = 0;
+	u64 fdt_addr;  /* Original DTB */
+	u64 fdt_size = 0;
+	char *cmdline_ptr = NULL;
+	int cmdline_size = 0;
+	unsigned long new_fdt_addr;
+
+	/* Check if we were booted by the EFI firmware */
+	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		goto fail;
+
+	pr_efi(sys_table, "Booting Linux Kernel...\n");
+
+	dram_base = get_dram_base(sys_table);
+	if (dram_base == EFI_ERROR) {
+		pr_efi_err(sys_table, "Failed to find DRAM base\n");
+		goto fail;
+	}
+
+	/* Relocate the image, if required. */
+	image_size = _edata - _text;
+	if (*image_addr != (dram_base + TEXT_OFFSET)) {
+		image_memsize = image_size + (_end - _edata);
+		status = efi_relocate_kernel(sys_table, image_addr,
+					     image_size, image_memsize,
+					     dram_base + TEXT_OFFSET,
+					     PAGE_SIZE);
+		if (status != EFI_SUCCESS) {
+			pr_efi_err(sys_table, "Failed to relocate kernel\n");
+			goto fail;
+		}
+		if (*image_addr != (dram_base + TEXT_OFFSET)) {
+			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
+			goto fail_free_image;
+		}
+	}
+
+	efi_get_cmdline(sys_table, &image, handle, &cmdline_ptr);
+	if (!cmdline_ptr) {
+		pr_efi_err(sys_table, "getting command line via LOADED_IMAGE_PROTOCOL\n");
+		goto fail_free_image;
+	}
+
+	status = handle_cmdline_files(sys_table, image, cmdline_ptr, "dtb=",
+				      ~0UL, (unsigned long *)&fdt_addr,
+				      (unsigned long *)&fdt_size);
+	if (status != EFI_SUCCESS || !fdt_addr) {
+		pr_efi_err(sys_table, "Failed to load device tree!\n");
+		goto fail_free_cmdline;
+	}
+
+	if (fdt_check_header((void *)fdt_addr)) {
+		pr_efi_err(sys_table, "Device Tree header not valid!\n");
+		goto fail_free_dtb;
+	}
+	if (fdt_totalsize((void *)fdt_addr) > fdt_size) {
+		pr_efi_err(sys_table, "Truncated device tree!\n");
+		goto fail_free_dtb;
+	}
+
+	status = handle_cmdline_files(sys_table, image, cmdline_ptr,
+				      "initrd=", dram_base + SZ_512M,
+				      (unsigned long *)&initrd_addr,
+				      (unsigned long *)&initrd_size);
+	if (status != EFI_SUCCESS)
+		pr_efi_err(sys_table, "Failed initrd from command line!\n");
+
+	new_fdt_addr = fdt_addr;
+	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
+				&new_fdt_addr, dram_base + MAX_FDT_OFFSET,
+				initrd_addr, initrd_size, cmdline_ptr,
+				fdt_addr, fdt_size);
+
+	/*
+	 * If all went well, we need to return the FDT address to the
+	 * calling function so it can be passed to kernel as part of
+	 * the kernel boot protocol.
+	 */
+	if (status == EFI_SUCCESS)
+		return new_fdt_addr;
+
+	pr_efi_err(sys_table, "Failed to update FDT and exit boot services\n");
+
+	efi_free(sys_table, initrd_size, initrd_addr);
+
+fail_free_dtb:
+	efi_free(sys_table, fdt_size, fdt_addr);
+
+fail_free_cmdline:
+	efi_free(sys_table, cmdline_size, (u64)cmdline_ptr);
+
+fail_free_image:
+	efi_free(sys_table, image_memsize, *image_addr);
+
+fail:
+	return EFI_ERROR;
+}
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 4b47dcb..c92fb4c 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -107,8 +107,18 @@
 	/*
 	 * DO NOT MODIFY. Image header expected by Linux boot-loaders.
 	 */
+#ifdef CONFIG_EFI_STUB
+	/*
+	 * Magic "MZ" signature for PE/COFF
+	 * Little Endian:  add x13, x18, #0x16
+	 */
+efi_head:
+	.long   0x91005a4d
+	b	stext
+#else
 	b	stext				// branch to kernel start, magic
 	.long	0				// reserved
+#endif
 	.quad	TEXT_OFFSET			// Image load offset from start of RAM
 	.quad	0				// reserved
 	.quad	0				// reserved
@@ -119,7 +129,109 @@
 	.byte	0x52
 	.byte	0x4d
 	.byte	0x64
+#ifdef CONFIG_EFI_STUB
+	.long	pe_header - efi_head		// Offset to the PE header.
+#else
 	.word	0				// reserved
+#endif
+
+#ifdef CONFIG_EFI_STUB
+	.align 3
+pe_header:
+	.ascii	"PE"
+	.short 	0
+coff_header:
+	.short	0xaa64				// AArch64
+	.short	2				// nr_sections
+	.long	0 				// TimeDateStamp
+	.long	0				// PointerToSymbolTable
+	.long	1				// NumberOfSymbols
+	.short	section_table - optional_header	// SizeOfOptionalHeader
+	.short	0x206				// Characteristics.
+						// IMAGE_FILE_DEBUG_STRIPPED |
+						// IMAGE_FILE_EXECUTABLE_IMAGE |
+						// IMAGE_FILE_LINE_NUMS_STRIPPED
+optional_header:
+	.short	0x20b				// PE32+ format
+	.byte	0x02				// MajorLinkerVersion
+	.byte	0x14				// MinorLinkerVersion
+	.long	_edata - stext			// SizeOfCode
+	.long	0				// SizeOfInitializedData
+	.long	0				// SizeOfUninitializedData
+	.long	efi_stub_entry - efi_head	// AddressOfEntryPoint
+	.long	stext - efi_head		// BaseOfCode
+
+extra_header_fields:
+	.quad	0				// ImageBase
+	.long	0x20				// SectionAlignment
+	.long	0x8				// FileAlignment
+	.short	0				// MajorOperatingSystemVersion
+	.short	0				// MinorOperatingSystemVersion
+	.short	0				// MajorImageVersion
+	.short	0				// MinorImageVersion
+	.short	0				// MajorSubsystemVersion
+	.short	0				// MinorSubsystemVersion
+	.long	0				// Win32VersionValue
+
+	.long	_edata - efi_head		// SizeOfImage
+
+	// Everything before the kernel image is considered part of the header
+	.long	stext - efi_head			// SizeOfHeaders
+	.long	0				// CheckSum
+	.short	0xa				// Subsystem (EFI application)
+	.short	0				// DllCharacteristics
+	.quad	0				// SizeOfStackReserve
+	.quad	0				// SizeOfStackCommit
+	.quad	0				// SizeOfHeapReserve
+	.quad	0				// SizeOfHeapCommit
+	.long	0				// LoaderFlags
+	.long	0x6				// NumberOfRvaAndSizes
+
+	.quad	0				// ExportTable
+	.quad	0				// ImportTable
+	.quad	0				// ResourceTable
+	.quad	0				// ExceptionTable
+	.quad	0				// CertificationTable
+	.quad	0				// BaseRelocationTable
+
+	// Section table
+section_table:
+
+	/*
+	 * The EFI application loader requires a relocation section
+	 * because EFI applications must be relocatable.  This is a
+	 * dummy section as far as we are concerned.
+	 */
+	.ascii	".reloc"
+	.byte	0
+	.byte	0			// end of 0 padding of section name
+	.long	0
+	.long	0
+	.long	0			// SizeOfRawData
+	.long	0			// PointerToRawData
+	.long	0			// PointerToRelocations
+	.long	0			// PointerToLineNumbers
+	.short	0			// NumberOfRelocations
+	.short	0			// NumberOfLineNumbers
+	.long	0x42100040		// Characteristics (section flags)
+
+
+	.ascii	".text"
+	.byte	0
+	.byte	0
+	.byte	0        		// end of 0 padding of section name
+	.long	_edata - stext		// VirtualSize
+	.long	stext - efi_head	// VirtualAddress
+	.long	_edata - stext		// SizeOfRawData
+	.long	stext - efi_head	// PointerToRawData
+
+	.long	0		// PointerToRelocations (0 for executables)
+	.long	0		// PointerToLineNumbers (0 for executables)
+	.short	0		// NumberOfRelocations  (0 for executables)
+	.short	0		// NumberOfLineNumbers  (0 for executables)
+	.long	0xe0500020	// Characteristics (section flags)
+	.align 5
+#endif
 
 ENTRY(stext)
 	mov	x21, x0				// x21=FDT
-- 
1.8.3.1
