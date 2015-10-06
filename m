From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 3/3] arm64/efi: isolate EFI stub from the kernel proper
Date: Tue,  6 Oct 2015 12:03:44 +0100
Message-ID: <1444129424-8284-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1444129424-8284-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444129424-8284-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Since arm64 does not use a builtin decompressor, the EFI stub is built
into the kernel proper. So far, this has been working fine, but actually,
since the stub is in fact a PE/COFF relocatable binary that is executed
at an unknown offset in the 1:1 mapping provided by the UEFI firmware, we
should not be seamlessly sharing code with the kernel proper, which is a
position dependent executable linked at a high virtual offset.

So instead, separate the contents of libstub and its dependencies, by
putting them into their own namespace by prefixing all of its symbols
with __efistub. This way, we have tight control over what parts of the
kernel proper are referenced by the stub.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/Makefile            | 12 ++++-
 arch/arm64/kernel/efi-entry.S         | 10 ++--
 arch/arm64/kernel/head.S              | 14 ++---
 arch/arm64/kernel/image.h             | 26 +++++++++
 drivers/firmware/efi/libstub/Makefile | 39 +++++++++++---
 drivers/firmware/efi/libstub/string.c | 57 ++++++++++++++++++++
 6 files changed, 138 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 22dc9bc781be..7b17f6245f1e 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -20,6 +20,14 @@ arm64-obj-y		:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
 			   smp.o smp_spin_table.o topology.o
 
+stub-obj				:= efi-stub.o efi-entry.o
+extra-y					:= $(stub-obj)
+stub-obj				:= $(patsubst %.o,%.stub.o,$(stub-obj))
+
+OBJCOPYFLAGS := --prefix-symbols=__efistub_
+$(obj)/%.stub.o: $(obj)/%.o FORCE
+	$(call if_changed,objcopy)
+
 arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o entry32.o		\
 					   ../../arm/kernel/opcodes.o
@@ -32,7 +40,7 @@ arm64-obj-$(CONFIG_CPU_PM)		+= sleep.o suspend.o
 arm64-obj-$(CONFIG_CPU_IDLE)		+= cpuidle.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
-arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
+arm64-obj-$(CONFIG_EFI)			+= efi.o $(stub-obj)
 arm64-obj-$(CONFIG_PCI)			+= pci.o
 arm64-obj-$(CONFIG_ARMV8_DEPRECATED)	+= armv8_deprecated.o
 arm64-obj-$(CONFIG_ACPI)		+= acpi.o
@@ -40,7 +48,7 @@ arm64-obj-$(CONFIG_ACPI)		+= acpi.o
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
 head-y					:= head.o
-extra-y					:= $(head-y) vmlinux.lds
+extra-y					+= $(head-y) vmlinux.lds
 
 # vDSO - this must be built first to generate the symbol offsets
 $(call objectify,$(arm64-obj-y)): $(obj)/vdso/vdso-offsets.h
diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index 8ce9b0577442..a773db92908b 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -29,7 +29,7 @@
 	 * we want to be. The kernel image wants to be placed at TEXT_OFFSET
 	 * from start of RAM.
 	 */
-ENTRY(efi_stub_entry)
+ENTRY(entry)
 	/*
 	 * Create a stack frame to save FP/LR with extra space
 	 * for image_addr variable passed to efi_entry().
@@ -86,8 +86,8 @@ ENTRY(efi_stub_entry)
 	 * entries for the VA range of the current image, so no maintenance is
 	 * necessary.
 	 */
-	adr	x0, efi_stub_entry
-	adr	x1, efi_stub_entry_end
+	adr	x0, entry
+	adr	x1, entry_end
 	sub	x1, x1, x0
 	bl	__flush_dcache_area
 
@@ -120,5 +120,5 @@ efi_load_fail:
 	ldp	x29, x30, [sp], #32
 	ret
 
-efi_stub_entry_end:
-ENDPROC(efi_stub_entry)
+entry_end:
+ENDPROC(entry)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 90d09eddd5b2..28a81e948df9 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -120,8 +120,8 @@ efi_head:
 #endif
 
 #ifdef CONFIG_EFI
-	.globl	stext_offset
-	.set	stext_offset, stext - efi_head
+	.globl	__efistub_stext_offset
+	.set	__efistub_stext_offset, stext - efi_head
 	.align 3
 pe_header:
 	.ascii	"PE"
@@ -144,8 +144,8 @@ optional_header:
 	.long	_end - stext			// SizeOfCode
 	.long	0				// SizeOfInitializedData
 	.long	0				// SizeOfUninitializedData
-	.long	efi_stub_entry - efi_head	// AddressOfEntryPoint
-	.long	stext_offset			// BaseOfCode
+	.long	__efistub_entry - efi_head	// AddressOfEntryPoint
+	.long	__efistub_stext_offset		// BaseOfCode
 
 extra_header_fields:
 	.quad	0				// ImageBase
@@ -162,7 +162,7 @@ extra_header_fields:
 	.long	_end - efi_head			// SizeOfImage
 
 	// Everything before the kernel image is considered part of the header
-	.long	stext_offset			// SizeOfHeaders
+	.long	__efistub_stext_offset		// SizeOfHeaders
 	.long	0				// CheckSum
 	.short	0xa				// Subsystem (EFI application)
 	.short	0				// DllCharacteristics
@@ -207,9 +207,9 @@ section_table:
 	.byte	0
 	.byte	0        		// end of 0 padding of section name
 	.long	_end - stext		// VirtualSize
-	.long	stext_offset		// VirtualAddress
+	.long	__efistub_stext_offset	// VirtualAddress
 	.long	_edata - stext		// SizeOfRawData
-	.long	stext_offset		// PointerToRawData
+	.long	__efistub_stext_offset	// PointerToRawData
 
 	.long	0		// PointerToRelocations (0 for executables)
 	.long	0		// PointerToLineNumbers (0 for executables)
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index 8fae0756e175..2b756b2851e5 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -59,4 +59,30 @@
 	_kernel_offset_le	= DATA_LE64(TEXT_OFFSET);	\
 	_kernel_flags_le	= DATA_LE64(__HEAD_FLAGS);
 
+#ifdef CONFIG_EFI
+
+/*
+ * The EFI stub has its own symbol namespace prefixed by __efistub_, to
+ * isolate it from the kernel proper. The following symbols are legally
+ * accessed by the stub, so provide some aliases to make them accessible.
+ * Only include data symbols here, or text symbols of functions that are
+ * guaranteed to be safe when executed at another offset than they were
+ * linked at. The routines below are all implemented in assembler in a
+ * position independent manner
+ */
+__efistub_memcmp		= __pi_memcmp;
+__efistub_memchr		= __pi_memchr;
+__efistub_memcpy		= __pi_memcpy;
+__efistub_memmove		= __pi_memmove;
+__efistub_memset		= __pi_memset;
+__efistub_strlen		= __pi_strlen;
+__efistub_strncmp		= __pi_strncmp;
+__efistub___flush_dcache_area	= __pi___flush_dcache_area;
+
+__efistub__text			= _text;
+__efistub__end			= _end;
+__efistub__edata		= _edata;
+
+#endif
+
 #endif /* __ASM_IMAGE_H */
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 816dbe9f4b82..bca9a76cbd33 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -14,6 +14,8 @@ cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
 cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic -mno-single-pic-base
 
+cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
+
 KBUILD_CFLAGS			:= $(cflags-y) \
 				   $(call cc-option,-ffreestanding) \
 				   $(call cc-option,-fno-stack-protector)
@@ -22,7 +24,15 @@ GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
 
 lib-y				:= efi-stub-helper.o
-lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o
+
+# include the stub's generic dependencies from lib/ when building for ARM/arm64
+arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
+
+$(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
+	$(call if_changed_rule,cc_o_c)
+
+lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o string.o \
+				   $(patsubst %.c,lib-%.o,$(arm-deps))
 
 #
 # arm64 puts the stub in the kernel proper, which will unnecessarily retain all
@@ -30,10 +40,27 @@ lib-$(CONFIG_EFI_ARMSTUB)	+= arm-stub.o fdt.o
 # So let's apply the __init annotations at the section level, by prefixing
 # the section names directly. This will ensure that even all the inline string
 # literals are covered.
+# The fact that the stub and the kernel proper are essentially the same binary
+# also means that we need to be extra careful to make sure that the stub does
+# not rely on any absolute symbol references, considering that the virtual
+# kernel mapping that the linker uses is not active yet when the stub is
+# executing. So build all C dependencies of the EFI stub into libstub, and do
+# a verification pass to see if any absolute relocations exist in any of the
+# object files.
 #
-extra-$(CONFIG_ARM64)		:= $(lib-y)
-lib-$(CONFIG_ARM64)		:= $(patsubst %.o,%.init.o,$(lib-y))
+extra-$(CONFIG_EFI_ARMSTUB)	:= $(lib-y)
+lib-$(CONFIG_EFI_ARMSTUB)	:= $(patsubst %.o,%.stub.o,$(lib-y))
+
+STUBCOPY_FLAGS-y		:= -R .debug* -R *ksymtab*
+STUBCOPY_FLAGS-$(CONFIG_ARM64)	+= --prefix-alloc-sections=.init \
+				   --prefix-symbols=__efistub_
+STUBCOPY_RELOC-$(CONFIG_ARM64)	:= R_AARCH64_ABS
+
+$(obj)/%.stub.o: $(obj)/%.o FORCE
+	$(call if_changed,stubcopy)
 
-OBJCOPYFLAGS := --prefix-alloc-sections=.init
-$(obj)/%.init.o: $(obj)/%.o FORCE
-	$(call if_changed,objcopy)
+quiet_cmd_stubcopy = STUBCPY $@
+      cmd_stubcopy = if $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; then	\
+		     $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y)	\
+		     && (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
+			 rm -f $@; /bin/false); else /bin/false; fi
diff --git a/drivers/firmware/efi/libstub/string.c b/drivers/firmware/efi/libstub/string.c
new file mode 100644
index 000000000000..09d5a0894343
--- /dev/null
+++ b/drivers/firmware/efi/libstub/string.c
@@ -0,0 +1,57 @@
+/*
+ * Taken from:
+ *  linux/lib/string.c
+ *
+ *  Copyright (C) 1991, 1992  Linus Torvalds
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+
+#ifndef __HAVE_ARCH_STRSTR
+/**
+ * strstr - Find the first substring in a %NUL terminated string
+ * @s1: The string to be searched
+ * @s2: The string to search for
+ */
+char *strstr(const char *s1, const char *s2)
+{
+	size_t l1, l2;
+
+	l2 = strlen(s2);
+	if (!l2)
+		return (char *)s1;
+	l1 = strlen(s1);
+	while (l1 >= l2) {
+		l1--;
+		if (!memcmp(s1, s2, l2))
+			return (char *)s1;
+		s1++;
+	}
+	return NULL;
+}
+#endif
+
+#ifndef __HAVE_ARCH_STRNCMP
+/**
+ * strncmp - Compare two length-limited strings
+ * @cs: One string
+ * @ct: Another string
+ * @count: The maximum number of bytes to compare
+ */
+int strncmp(const char *cs, const char *ct, size_t count)
+{
+	unsigned char c1, c2;
+
+	while (count) {
+		c1 = *cs++;
+		c2 = *ct++;
+		if (c1 != c2)
+			return c1 < c2 ? -1 : 1;
+		if (!c1)
+			break;
+		count--;
+	}
+	return 0;
+}
+#endif
-- 
1.9.1
