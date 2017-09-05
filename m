From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] EFI changes for v4.14
Date: Tue, 5 Sep 2017 08:26:09 +0200
Message-ID: <20170905062609.3mfm37e64wtqypxi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: 6de47a5e371f75f80544986e6c9636211a2ae8af efi/bgrt: Use efi_mem_type()

The main changes in this cycle were:

 - Transparently fall back to other poweroff method(s) if EFI poweroff fails (and 
   returns)

 - Use separate PE/COFF section headers for the RX and RW parts of the ARM
   stub loader so that the firmware can use strict mapping permissions

 - Add support for requesting the firmware to wipe RAM at warm reboot

 - Increase the size of the random seed obtained from UEFI so CRNG
   fast init can complete earlier

 - Update the EFI framebuffer address if it points to a BAR that gets moved
   by the PCI resource allocation code

 - Enable "reset attack mitigation" of TPM environments: this is enabled if 
   the kernel is configured with CONFIG_RESET_ATTACK_MITIGATION=y.

 - Clang related fixes

 - Misc cleanups, constification, refactoring, etc.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (11):
      efi/arm: Don't mark ACPI reclaim memory as MEMBLOCK_NOMAP
      efi/libstub/arm64: Use hidden attribute for struct screen_info reference
      efi/libstub/arm64: Force 'hidden' visibility for section markers
      efi/libstub/arm64: Set -fpie when building the EFI stub
      efi/arm/arm64: Add missing assignment of efi.config_table
      drivers/fbdev/efifb: Allow BAR to be moved instead of claiming it
      arm/efi: Remove forbidden values from the PE/COFF header
      arm/efi: Remove pointless dummy .reloc section
      arm/efi: Replace open coded constants with symbolic ones
      arm/efi: Split zImage code and data into separate PE/COFF sections
      efi/random: Increase size of firmware supplied randomness

Arvind Yadav (3):
      firmware/dcdbas: Constify attribute_group structures
      firmware/efi: Constify attribute_group structures
      firmware/efi/esrt: Constify attribute_group structures

Colin Ian King (1):
      efi/reboot: Make function pointer orig_pm_power_off static

Hans de Goede (1):
      efi/reboot: Fall back to original power-off method if EFI_RESET_SHUTDOWN returns

Jan Beulich (2):
      efi: Move efi_mem_type() to common code
      efi/bgrt: Use efi_mem_type()

Matthew Garrett (1):
      efi/libstub: Enable reset attack mitigation


 arch/arm/boot/compressed/efi-header.S     | 160 +++++++++++++++---------------
 arch/arm/boot/compressed/vmlinux.lds.S    |  30 ++++--
 arch/arm64/include/asm/efi.h              |   3 +
 arch/x86/boot/compressed/eboot.c          |   3 +
 arch/x86/platform/efi/efi.c               |  19 ----
 drivers/firmware/dcdbas.c                 |   2 +-
 drivers/firmware/efi/Kconfig              |  10 ++
 drivers/firmware/efi/arm-init.c           |   8 ++
 drivers/firmware/efi/efi-bgrt.c           |  22 +---
 drivers/firmware/efi/efi.c                |  42 ++++++--
 drivers/firmware/efi/esrt.c               |   2 +-
 drivers/firmware/efi/libstub/Makefile     |   3 +-
 drivers/firmware/efi/libstub/arm-stub.c   |   3 +
 drivers/firmware/efi/libstub/arm64-stub.c |  10 +-
 drivers/firmware/efi/libstub/random.c     |  10 +-
 drivers/firmware/efi/libstub/tpm.c        |  58 +++++++++++
 drivers/firmware/efi/reboot.c             |  12 ++-
 drivers/video/fbdev/efifb.c               |  31 +++---
 include/linux/efi.h                       |   9 ++
 19 files changed, 280 insertions(+), 157 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/tpm.c

diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
index a17ca8d78656..c94a88ae834d 100644
--- a/arch/arm/boot/compressed/efi-header.S
+++ b/arch/arm/boot/compressed/efi-header.S
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2013-2015 Linaro Ltd
+ * Copyright (C) 2013-2017 Linaro Ltd
  * Authors: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
  *          Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
  *
@@ -8,6 +8,9 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/pe.h>
+#include <linux/sizes.h>
+
 		.macro	__nop
 #ifdef CONFIG_EFI_STUB
 		@ This is almost but not quite a NOP, since it does clobber the
@@ -15,7 +18,7 @@
 		@ PE/COFF expects the magic string "MZ" at offset 0, while the
 		@ ARM/Linux boot protocol expects an executable instruction
 		@ there.
-		.inst	'M' | ('Z' << 8) | (0x1310 << 16)   @ tstne r0, #0x4d000
+		.inst	MZ_MAGIC | (0x1310 << 16)	@ tstne r0, #0x4d000
 #else
  AR_CLASS(	mov	r0, r0		)
   M_CLASS(	nop.w			)
@@ -34,96 +37,97 @@
 		@ The only 2 fields of the MSDOS header that are used are this
 		@ PE/COFF offset, and the "MZ" bytes at offset 0x0.
 		@
-		.long	pe_header - start	@ Offset to the PE header.
+		.long	pe_header - start		@ Offset to the PE header.
 
 pe_header:
-		.ascii	"PE\0\0"
+		.long	PE_MAGIC
 
 coff_header:
-		.short	0x01c2			@ ARM or Thumb
-		.short	2			@ nr_sections
-		.long	0 			@ TimeDateStamp
-		.long	0			@ PointerToSymbolTable
-		.long	1			@ NumberOfSymbols
-		.short	section_table - optional_header
-						@ SizeOfOptionalHeader
-		.short	0x306			@ Characteristics.
-						@ IMAGE_FILE_32BIT_MACHINE |
-						@ IMAGE_FILE_DEBUG_STRIPPED |
-						@ IMAGE_FILE_EXECUTABLE_IMAGE |
-						@ IMAGE_FILE_LINE_NUMS_STRIPPED
+		.short	IMAGE_FILE_MACHINE_THUMB	@ Machine
+		.short	section_count			@ NumberOfSections
+		.long	0 				@ TimeDateStamp
+		.long	0				@ PointerToSymbolTable
+		.long	0				@ NumberOfSymbols
+		.short	section_table - optional_header	@ SizeOfOptionalHeader
+		.short	IMAGE_FILE_32BIT_MACHINE | \
+			IMAGE_FILE_DEBUG_STRIPPED | \
+			IMAGE_FILE_EXECUTABLE_IMAGE | \
+			IMAGE_FILE_LINE_NUMS_STRIPPED	@ Characteristics
+
+#define __pecoff_code_size (__pecoff_data_start - __efi_start)
 
 optional_header:
-		.short	0x10b			@ PE32 format
-		.byte	0x02			@ MajorLinkerVersion
-		.byte	0x14			@ MinorLinkerVersion
-		.long	_end - __efi_start	@ SizeOfCode
-		.long	0			@ SizeOfInitializedData
-		.long	0			@ SizeOfUninitializedData
-		.long	efi_stub_entry - start	@ AddressOfEntryPoint
-		.long	start_offset		@ BaseOfCode
-		.long	0			@ data
+		.short	PE_OPT_MAGIC_PE32		@ PE32 format
+		.byte	0x02				@ MajorLinkerVersion
+		.byte	0x14				@ MinorLinkerVersion
+		.long	__pecoff_code_size		@ SizeOfCode
+		.long	__pecoff_data_size		@ SizeOfInitializedData
+		.long	0				@ SizeOfUninitializedData
+		.long	efi_stub_entry - start		@ AddressOfEntryPoint
+		.long	start_offset			@ BaseOfCode
+		.long	__pecoff_data_start - start	@ BaseOfData
 
 extra_header_fields:
-		.long	0			@ ImageBase
-		.long	0x200			@ SectionAlignment
-		.long	0x200			@ FileAlignment
-		.short	0			@ MajorOperatingSystemVersion
-		.short	0			@ MinorOperatingSystemVersion
-		.short	0			@ MajorImageVersion
-		.short	0			@ MinorImageVersion
-		.short	0			@ MajorSubsystemVersion
-		.short	0			@ MinorSubsystemVersion
-		.long	0			@ Win32VersionValue
+		.long	0				@ ImageBase
+		.long	SZ_4K				@ SectionAlignment
+		.long	SZ_512				@ FileAlignment
+		.short	0				@ MajorOsVersion
+		.short	0				@ MinorOsVersion
+		.short	0				@ MajorImageVersion
+		.short	0				@ MinorImageVersion
+		.short	0				@ MajorSubsystemVersion
+		.short	0				@ MinorSubsystemVersion
+		.long	0				@ Win32VersionValue
 
-		.long	_end - start		@ SizeOfImage
-		.long	start_offset		@ SizeOfHeaders
-		.long	0			@ CheckSum
-		.short	0xa			@ Subsystem (EFI application)
-		.short	0			@ DllCharacteristics
-		.long	0			@ SizeOfStackReserve
-		.long	0			@ SizeOfStackCommit
-		.long	0			@ SizeOfHeapReserve
-		.long	0			@ SizeOfHeapCommit
-		.long	0			@ LoaderFlags
-		.long	0x6			@ NumberOfRvaAndSizes
+		.long	__pecoff_end - start		@ SizeOfImage
+		.long	start_offset			@ SizeOfHeaders
+		.long	0				@ CheckSum
+		.short	IMAGE_SUBSYSTEM_EFI_APPLICATION	@ Subsystem
+		.short	0				@ DllCharacteristics
+		.long	0				@ SizeOfStackReserve
+		.long	0				@ SizeOfStackCommit
+		.long	0				@ SizeOfHeapReserve
+		.long	0				@ SizeOfHeapCommit
+		.long	0				@ LoaderFlags
+		.long	(section_table - .) / 8		@ NumberOfRvaAndSizes
 
-		.quad	0			@ ExportTable
-		.quad	0			@ ImportTable
-		.quad	0			@ ResourceTable
-		.quad	0			@ ExceptionTable
-		.quad	0			@ CertificationTable
-		.quad	0			@ BaseRelocationTable
+		.quad	0				@ ExportTable
+		.quad	0				@ ImportTable
+		.quad	0				@ ResourceTable
+		.quad	0				@ ExceptionTable
+		.quad	0				@ CertificationTable
+		.quad	0				@ BaseRelocationTable
 
 section_table:
-		@
-		@ The EFI application loader requires a relocation section
-		@ because EFI applications must be relocatable. This is a
-		@ dummy section as far as we are concerned.
-		@
-		.ascii	".reloc\0\0"
-		.long	0			@ VirtualSize
-		.long	0			@ VirtualAddress
-		.long	0			@ SizeOfRawData
-		.long	0			@ PointerToRawData
-		.long	0			@ PointerToRelocations
-		.long	0			@ PointerToLineNumbers
-		.short	0			@ NumberOfRelocations
-		.short	0			@ NumberOfLineNumbers
-		.long	0x42100040		@ Characteristics
-
 		.ascii	".text\0\0\0"
-		.long	_end - __efi_start	@ VirtualSize
-		.long	__efi_start		@ VirtualAddress
-		.long	_edata - __efi_start	@ SizeOfRawData
-		.long	__efi_start		@ PointerToRawData
-		.long	0			@ PointerToRelocations
-		.long	0			@ PointerToLineNumbers
-		.short	0			@ NumberOfRelocations
-		.short	0			@ NumberOfLineNumbers
-		.long	0xe0500020		@ Characteristics
+		.long	__pecoff_code_size		@ VirtualSize
+		.long	__efi_start			@ VirtualAddress
+		.long	__pecoff_code_size		@ SizeOfRawData
+		.long	__efi_start			@ PointerToRawData
+		.long	0				@ PointerToRelocations
+		.long	0				@ PointerToLineNumbers
+		.short	0				@ NumberOfRelocations
+		.short	0				@ NumberOfLineNumbers
+		.long	IMAGE_SCN_CNT_CODE | \
+			IMAGE_SCN_MEM_READ | \
+			IMAGE_SCN_MEM_EXECUTE		@ Characteristics
+
+		.ascii	".data\0\0\0"
+		.long	__pecoff_data_size		@ VirtualSize
+		.long	__pecoff_data_start - start	@ VirtualAddress
+		.long	__pecoff_data_rawsize		@ SizeOfRawData
+		.long	__pecoff_data_start - start	@ PointerToRawData
+		.long	0				@ PointerToRelocations
+		.long	0				@ PointerToLineNumbers
+		.short	0				@ NumberOfRelocations
+		.short	0				@ NumberOfLineNumbers
+		.long	IMAGE_SCN_CNT_INITIALIZED_DATA | \
+			IMAGE_SCN_MEM_READ | \
+			IMAGE_SCN_MEM_WRITE		@ Characteristics
+
+		.set	section_count, (. - section_table) / 40
 
-		.align	9
+		.align	12
 __efi_start:
 #endif
 		.endm
diff --git a/arch/arm/boot/compressed/vmlinux.lds.S b/arch/arm/boot/compressed/vmlinux.lds.S
index 81c493156ce8..7a4c59154361 100644
--- a/arch/arm/boot/compressed/vmlinux.lds.S
+++ b/arch/arm/boot/compressed/vmlinux.lds.S
@@ -48,13 +48,6 @@ SECTIONS
     *(.rodata)
     *(.rodata.*)
   }
-  .data : {
-    /*
-     * The EFI stub always executes from RAM, and runs strictly before the
-     * decompressor, so we can make an exception for its r/w data, and keep it
-     */
-    *(.data.efistub)
-  }
   .piggydata : {
     *(.piggydata)
   }
@@ -70,6 +63,26 @@ SECTIONS
   /* ensure the zImage file size is always a multiple of 64 bits */
   /* (without a dummy byte, ld just ignores the empty section) */
   .pad			: { BYTE(0); . = ALIGN(8); }
+
+#ifdef CONFIG_EFI_STUB
+  .data : ALIGN(4096) {
+    __pecoff_data_start = .;
+    /*
+     * The EFI stub always executes from RAM, and runs strictly before the
+     * decompressor, so we can make an exception for its r/w data, and keep it
+     */
+    *(.data.efistub)
+    __pecoff_data_end = .;
+
+    /*
+     * PE/COFF mandates a file size which is a multiple of 512 bytes if the
+     * section size equals or exceeds 4 KB
+     */
+    . = ALIGN(512);
+  }
+  __pecoff_data_rawsize = . - ADDR(.data);
+#endif
+
   _edata = .;
 
   _magic_sig = ZIMAGE_MAGIC(0x016f2818);
@@ -84,6 +97,9 @@ SECTIONS
   . = ALIGN(8);		/* the stack must be 64-bit aligned */
   .stack		: { *(.stack) }
 
+  PROVIDE(__pecoff_data_size = ALIGN(512) - ADDR(.data));
+  PROVIDE(__pecoff_end = ALIGN(512));
+
   .stab 0		: { *(.stab) }
   .stabstr 0		: { *(.stabstr) }
   .stab.excl 0		: { *(.stab.excl) }
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8f3043aba873..464ac850c5e2 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -81,6 +81,9 @@ static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
 #define alloc_screen_info(x...)		&screen_info
 #define free_screen_info(x...)
 
+/* redeclare as 'hidden' so the compiler will generate relative references */
+extern struct screen_info screen_info __attribute__((__visibility__("hidden")));
+
 static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
 {
 }
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index c3e869eaef0c..a1686f3dc295 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -997,6 +997,9 @@ struct boot_params *efi_main(struct efi_config *c,
 	if (boot_params->secure_boot == efi_secureboot_mode_unset)
 		boot_params->secure_boot = efi_get_secureboot(sys_table);
 
+	/* Ask the firmware to clear memory on unclean shutdown */
+	efi_enable_reset_attack_mitigation(sys_table);
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 6217b23e85f6..928b6dceeca0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1032,25 +1032,6 @@ void __init efi_enter_virtual_mode(void)
 	efi_dump_pagetable();
 }
 
-/*
- * Convenience functions to obtain memory types and attributes
- */
-int efi_mem_type(unsigned long phys_addr)
-{
-	efi_memory_desc_t *md;
-
-	if (!efi_enabled(EFI_MEMMAP))
-		return -ENOTSUPP;
-
-	for_each_efi_memory_desc(md) {
-		if ((md->phys_addr <= phys_addr) &&
-		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
-			return md->type;
-	}
-	return -EINVAL;
-}
-
 static int __init arch_parse_efi_cmdline(char *str)
 {
 	if (!str) {
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 2fe1a130189f..c16600f30611 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -534,7 +534,7 @@ static struct attribute *dcdbas_dev_attrs[] = {
 	NULL
 };
 
-static struct attribute_group dcdbas_attr_group = {
+static const struct attribute_group dcdbas_attr_group = {
 	.attrs = dcdbas_dev_attrs,
 	.bin_attrs = dcdbas_bin_attrs,
 };
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 394db40ed374..2b4c39fdfa91 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -151,6 +151,16 @@ config APPLE_PROPERTIES
 
 	  If unsure, say Y if you have a Mac.  Otherwise N.
 
+config RESET_ATTACK_MITIGATION
+	bool "Reset memory attack mitigation"
+	depends on EFI_STUB
+	help
+	  Request that the firmware clear the contents of RAM after a reboot
+	  using the TCG Platform Reset Attack Mitigation specification. This
+	  protects against an attacker forcibly rebooting the system while it
+	  still contains secrets in RAM, booting another OS and extracting the
+	  secrets.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 1027d7b44358..80d1a885def5 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -145,6 +145,9 @@ static int __init uefi_init(void)
 					 sizeof(efi_config_table_t),
 					 arch_tables);
 
+	if (!retval)
+		efi.config_table = (unsigned long)efi.systab->tables;
+
 	early_memunmap(config_tables, table_size);
 out:
 	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
@@ -159,6 +162,7 @@ static __init int is_usable_memory(efi_memory_desc_t *md)
 	switch (md->type) {
 	case EFI_LOADER_CODE:
 	case EFI_LOADER_DATA:
+	case EFI_ACPI_RECLAIM_MEMORY:
 	case EFI_BOOT_SERVICES_CODE:
 	case EFI_BOOT_SERVICES_DATA:
 	case EFI_CONVENTIONAL_MEMORY:
@@ -211,6 +215,10 @@ static __init void reserve_regions(void)
 
 			if (!is_usable_memory(md))
 				memblock_mark_nomap(paddr, size);
+
+			/* keep ACPI reclaim memory intact for kexec etc. */
+			if (md->type == EFI_ACPI_RECLAIM_MEMORY)
+				memblock_reserve(paddr, size);
 		}
 	}
 }
diff --git a/drivers/firmware/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
index b58233e4ed71..50793fda7819 100644
--- a/drivers/firmware/efi/efi-bgrt.c
+++ b/drivers/firmware/efi/efi-bgrt.c
@@ -27,26 +27,6 @@ struct bmp_header {
 	u32 size;
 } __packed;
 
-static bool efi_bgrt_addr_valid(u64 addr)
-{
-	efi_memory_desc_t *md;
-
-	for_each_efi_memory_desc(md) {
-		u64 size;
-		u64 end;
-
-		if (md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-
-		size = md->num_pages << EFI_PAGE_SHIFT;
-		end = md->phys_addr + size;
-		if (addr >= md->phys_addr && addr < end)
-			return true;
-	}
-
-	return false;
-}
-
 void __init efi_bgrt_init(struct acpi_table_header *table)
 {
 	void *image;
@@ -85,7 +65,7 @@ void __init efi_bgrt_init(struct acpi_table_header *table)
 		goto out;
 	}
 
-	if (!efi_bgrt_addr_valid(bgrt->image_address)) {
+	if (efi_mem_type(bgrt->image_address) != EFI_BOOT_SERVICES_DATA) {
 		pr_notice("Ignoring BGRT: invalid image address\n");
 		goto out;
 	}
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 69d4d130e055..f70febf680c3 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -198,7 +198,7 @@ static umode_t efi_attr_is_visible(struct kobject *kobj,
 	return attr->mode;
 }
 
-static struct attribute_group efi_subsys_attr_group = {
+static const struct attribute_group efi_subsys_attr_group = {
 	.attrs = efi_subsys_attrs,
 	.is_visible = efi_attr_is_visible,
 };
@@ -541,6 +541,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 			if (seed != NULL) {
 				add_device_randomness(seed->bits, seed->size);
 				early_memunmap(seed, sizeof(*seed) + size);
+				pr_notice("seeding entropy pool\n");
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
 			}
@@ -810,19 +811,19 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
 }
 
 /*
+ * IA64 has a funky EFI memory map that doesn't work the same way as
+ * other architectures.
+ */
+#ifndef CONFIG_IA64
+/*
  * efi_mem_attributes - lookup memmap attributes for physical address
  * @phys_addr: the physical address to lookup
  *
  * Search in the EFI memory map for the region covering
  * @phys_addr. Returns the EFI memory attributes if the region
  * was found in the memory map, 0 otherwise.
- *
- * Despite being marked __weak, most architectures should *not*
- * override this function. It is __weak solely for the benefit
- * of ia64 which has a funky EFI memory map that doesn't work
- * the same way as other architectures.
  */
-u64 __weak efi_mem_attributes(unsigned long phys_addr)
+u64 efi_mem_attributes(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
 
@@ -838,6 +839,31 @@ u64 __weak efi_mem_attributes(unsigned long phys_addr)
 	return 0;
 }
 
+/*
+ * efi_mem_type - lookup memmap type for physical address
+ * @phys_addr: the physical address to lookup
+ *
+ * Search in the EFI memory map for the region covering @phys_addr.
+ * Returns the EFI memory type if the region was found in the memory
+ * map, EFI_RESERVED_TYPE (zero) otherwise.
+ */
+int efi_mem_type(unsigned long phys_addr)
+{
+	const efi_memory_desc_t *md;
+
+	if (!efi_enabled(EFI_MEMMAP))
+		return -ENOTSUPP;
+
+	for_each_efi_memory_desc(md) {
+		if ((md->phys_addr <= phys_addr) &&
+		    (phys_addr < (md->phys_addr +
+				  (md->num_pages << EFI_PAGE_SHIFT))))
+			return md->type;
+	}
+	return -EINVAL;
+}
+#endif
+
 int efi_status_to_err(efi_status_t status)
 {
 	int err;
@@ -900,7 +926,7 @@ static int update_efi_random_seed(struct notifier_block *nb,
 
 	seed = memremap(efi.rng_seed, sizeof(*seed), MEMREMAP_WB);
 	if (seed != NULL) {
-		size = min(seed->size, 32U);
+		size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 		memunmap(seed);
 	} else {
 		pr_err("Could not map UEFI random seed!\n");
diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 8554d7aec31c..bd7ed3c1148a 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -230,7 +230,7 @@ static umode_t esrt_attr_is_visible(struct kobject *kobj,
 	return attr->mode;
 }
 
-static struct attribute_group esrt_attr_group = {
+static const struct attribute_group esrt_attr_group = {
 	.attrs = esrt_attrs,
 	.is_visible = esrt_attr_is_visible,
 };
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 37e24f525162..dedf9bde44db 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -10,7 +10,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 \
 				   -fPIC -fno-strict-aliasing -mno-red-zone \
 				   -mno-mmx -mno-sse
 
-cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
+cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS)) -fpie
 cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic -mno-single-pic-base
 
@@ -30,6 +30,7 @@ OBJECT_FILES_NON_STANDARD	:= y
 KCOV_INSTRUMENT			:= n
 
 lib-y				:= efi-stub-helper.o gop.o secureboot.o
+lib-$(CONFIG_RESET_ATTACK_MITIGATION) += tpm.o
 
 # include the stub's generic dependencies from lib/ when building for ARM/arm64
 arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 8181ac179d14..1cb2d1c070c3 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -192,6 +192,9 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_cmdline;
 	}
 
+	/* Ask the firmware to clear memory on unclean shutdown */
+	efi_enable_reset_attack_mitigation(sys_table);
+
 	secure_boot = efi_get_secureboot(sys_table);
 
 	/*
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index b4c2589d7c91..f7a6970e9abc 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -9,9 +9,17 @@
  * published by the Free Software Foundation.
  *
  */
+
+/*
+ * To prevent the compiler from emitting GOT-indirected (and thus absolute)
+ * references to the section markers, override their visibility as 'hidden'
+ */
+#pragma GCC visibility push(hidden)
+#include <asm/sections.h>
+#pragma GCC visibility pop
+
 #include <linux/efi.h>
 #include <asm/efi.h>
-#include <asm/sections.h>
 #include <asm/sysreg.h>
 
 #include "efistub.h"
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 7e72954d5860..e0e603a89aa9 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -145,8 +145,6 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 	return status;
 }
 
-#define RANDOM_SEED_SIZE	32
-
 efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 {
 	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
@@ -162,25 +160,25 @@ efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 		return status;
 
 	status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
-				sizeof(*seed) + RANDOM_SEED_SIZE,
+				sizeof(*seed) + EFI_RANDOM_SEED_SIZE,
 				(void **)&seed);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = rng->get_rng(rng, &rng_algo_raw, RANDOM_SEED_SIZE,
+	status = rng->get_rng(rng, &rng_algo_raw, EFI_RANDOM_SEED_SIZE,
 			      seed->bits);
 	if (status == EFI_UNSUPPORTED)
 		/*
 		 * Use whatever algorithm we have available if the raw algorithm
 		 * is not implemented.
 		 */
-		status = rng->get_rng(rng, NULL, RANDOM_SEED_SIZE,
+		status = rng->get_rng(rng, NULL, EFI_RANDOM_SEED_SIZE,
 				      seed->bits);
 
 	if (status != EFI_SUCCESS)
 		goto err_freepool;
 
-	seed->size = RANDOM_SEED_SIZE;
+	seed->size = EFI_RANDOM_SEED_SIZE;
 	status = efi_call_early(install_configuration_table, &rng_table_guid,
 				seed);
 	if (status != EFI_SUCCESS)
diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
new file mode 100644
index 000000000000..6224cdbc9669
--- /dev/null
+++ b/drivers/firmware/efi/libstub/tpm.c
@@ -0,0 +1,58 @@
+/*
+ * TPM handling.
+ *
+ * Copyright (C) 2016 CoreOS, Inc
+ * Copyright (C) 2017 Google, Inc.
+ *     Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
+ *
+ * This file is part of the Linux kernel, and is made available under the
+ * terms of the GNU General Public License version 2.
+ */
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+#include "efistub.h"
+
+static const efi_char16_t efi_MemoryOverWriteRequest_name[] = {
+	'M', 'e', 'm', 'o', 'r', 'y', 'O', 'v', 'e', 'r', 'w', 'r', 'i', 't',
+	'e', 'R', 'e', 'q', 'u', 'e', 's', 't', 'C', 'o', 'n', 't', 'r', 'o',
+	'l', 0
+};
+
+#define MEMORY_ONLY_RESET_CONTROL_GUID \
+	EFI_GUID(0xe20939be, 0x32d4, 0x41be, 0xa1, 0x50, 0x89, 0x7f, 0x85, 0xd4, 0x98, 0x29)
+
+#define get_efi_var(name, vendor, ...) \
+	efi_call_runtime(get_variable, \
+			 (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
+			 __VA_ARGS__)
+
+#define set_efi_var(name, vendor, ...) \
+	efi_call_runtime(set_variable, \
+			 (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
+			 __VA_ARGS__)
+
+/*
+ * Enable reboot attack mitigation. This requests that the firmware clear the
+ * RAM on next reboot before proceeding with boot, ensuring that any secrets
+ * are cleared. If userland has ensured that all secrets have been removed
+ * from RAM before reboot it can simply reset this variable.
+ */
+void efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg)
+{
+	u8 val = 1;
+	efi_guid_t var_guid = MEMORY_ONLY_RESET_CONTROL_GUID;
+	efi_status_t status;
+	unsigned long datasize = 0;
+
+	status = get_efi_var(efi_MemoryOverWriteRequest_name, &var_guid,
+			     NULL, &datasize, NULL);
+
+	if (status == EFI_NOT_FOUND)
+		return;
+
+	set_efi_var(efi_MemoryOverWriteRequest_name, &var_guid,
+		    EFI_VARIABLE_NON_VOLATILE |
+		    EFI_VARIABLE_BOOTSERVICE_ACCESS |
+		    EFI_VARIABLE_RUNTIME_ACCESS, sizeof(val), &val);
+}
diff --git a/drivers/firmware/efi/reboot.c b/drivers/firmware/efi/reboot.c
index 62ead9b9d871..22874544d301 100644
--- a/drivers/firmware/efi/reboot.c
+++ b/drivers/firmware/efi/reboot.c
@@ -5,6 +5,8 @@
 #include <linux/efi.h>
 #include <linux/reboot.h>
 
+static void (*orig_pm_power_off)(void);
+
 int efi_reboot_quirk_mode = -1;
 
 void efi_reboot(enum reboot_mode reboot_mode, const char *__unused)
@@ -51,6 +53,12 @@ bool __weak efi_poweroff_required(void)
 static void efi_power_off(void)
 {
 	efi.reset_system(EFI_RESET_SHUTDOWN, EFI_SUCCESS, 0, NULL);
+	/*
+	 * The above call should not return, if it does fall back to
+	 * the original power off method (typically ACPI poweroff).
+	 */
+	if (orig_pm_power_off)
+		orig_pm_power_off();
 }
 
 static int __init efi_shutdown_init(void)
@@ -58,8 +66,10 @@ static int __init efi_shutdown_init(void)
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
 		return -ENODEV;
 
-	if (efi_poweroff_required())
+	if (efi_poweroff_required()) {
+		orig_pm_power_off = pm_power_off;
 		pm_power_off = efi_power_off;
+	}
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 1e784adb89b1..3a010641f630 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -149,6 +149,10 @@ ATTRIBUTE_GROUPS(efifb);
 
 static bool pci_dev_disabled;	/* FB base matches BAR of a disabled device */
 
+static struct pci_dev *efifb_pci_dev;	/* dev with BAR covering the efifb */
+static struct resource *bar_resource;
+static u64 bar_offset;
+
 static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
@@ -203,6 +207,13 @@ static int efifb_probe(struct platform_device *dev)
 		efifb_fix.smem_start |= ext_lfb_base;
 	}
 
+	if (bar_resource &&
+	    bar_resource->start + bar_offset != efifb_fix.smem_start) {
+		dev_info(&efifb_pci_dev->dev,
+			 "BAR has moved, updating efifb address\n");
+		efifb_fix.smem_start = bar_resource->start + bar_offset;
+	}
+
 	efifb_defined.bits_per_pixel = screen_info.lfb_depth;
 	efifb_defined.xres = screen_info.lfb_width;
 	efifb_defined.yres = screen_info.lfb_height;
@@ -370,15 +381,13 @@ static struct platform_driver efifb_driver = {
 
 builtin_platform_driver(efifb_driver);
 
-#if defined(CONFIG_PCI) && !defined(CONFIG_X86)
-
-static bool pci_bar_found;	/* did we find a BAR matching the efifb base? */
+#if defined(CONFIG_PCI)
 
-static void claim_efifb_bar(struct pci_dev *dev, int idx)
+static void record_efifb_bar_resource(struct pci_dev *dev, int idx, u64 offset)
 {
 	u16 word;
 
-	pci_bar_found = true;
+	efifb_pci_dev = dev;
 
 	pci_read_config_word(dev, PCI_COMMAND, &word);
 	if (!(word & PCI_COMMAND_MEMORY)) {
@@ -389,12 +398,8 @@ static void claim_efifb_bar(struct pci_dev *dev, int idx)
 		return;
 	}
 
-	if (pci_claim_resource(dev, idx)) {
-		pci_dev_disabled = true;
-		dev_err(&dev->dev,
-			"BAR %d: failed to claim resource for efifb!\n", idx);
-		return;
-	}
+	bar_resource = &dev->resource[idx];
+	bar_offset = offset;
 
 	dev_info(&dev->dev, "BAR %d: assigned to efifb\n", idx);
 }
@@ -405,7 +410,7 @@ static void efifb_fixup_resources(struct pci_dev *dev)
 	u64 size = screen_info.lfb_size;
 	int i;
 
-	if (pci_bar_found || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+	if (efifb_pci_dev || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
 		return;
 
 	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
@@ -421,7 +426,7 @@ static void efifb_fixup_resources(struct pci_dev *dev)
 			continue;
 
 		if (res->start <= base && res->end >= base + size - 1) {
-			claim_efifb_bar(dev, i);
+			record_efifb_bar_resource(dev, i, base - res->start);
 			break;
 		}
 	}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4e47f78430be..33d41df062bc 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1504,6 +1504,13 @@ enum efi_secureboot_mode {
 };
 enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table);
 
+#ifdef CONFIG_RESET_ATTACK_MITIGATION
+void efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg);
+#else
+static inline void
+efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg) { }
+#endif
+
 /*
  * Arch code can implement the following three template macros, avoiding
  * reptition for the void/non-void return cases of {__,}efi_call_virt():
@@ -1564,6 +1571,8 @@ efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
 				    void *priv,
 				    efi_exit_boot_map_processing priv_func);
 
+#define EFI_RANDOM_SEED_SIZE		64U
+
 struct linux_efi_random_seed {
 	u32	size;
 	u8	bits[];
