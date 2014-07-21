From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 07/10] arm64/efi: efistub: add support for booting a BE kernel
Date: Mon, 21 Jul 2014 17:16:22 +0200
Message-ID: <1405955785-13477-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405955785-13477-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This adds support to boot a big endian kernel from UEFI firmware, which is
always little endian. The EFI stub itself is built as little endian, and
embedded into a big endian kernel image.

To enable this, we need to build all the stub's dependencies as little endian,
including FDT parsing code and string functions. This is accomplished by
building little endian versions of those support files and link them into
a static library which is used by the inner stub build.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/Makefile                  |  7 +++-
 arch/arm64/kernel/efi-entry.S               | 42 +++++++++++++++++------
 arch/arm64/kernel/efistub-le/Makefile       | 52 +++++++++++++++++++++++++++++
 arch/arm64/kernel/efistub-le/efi-le-entry.S | 13 ++++++++
 arch/arm64/kernel/efistub-le/efistub-le.lds | 35 +++++++++++++++++++
 arch/arm64/kernel/efistub-le/le.h           | 12 +++++++
 arch/arm64/kernel/efistub-le/strstr.c       | 20 +++++++++++
 drivers/firmware/efi/libstub/fdt.c          |  4 +++
 8 files changed, 173 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm64/kernel/efistub-le/Makefile
 create mode 100644 arch/arm64/kernel/efistub-le/efi-le-entry.S
 create mode 100644 arch/arm64/kernel/efistub-le/efistub-le.lds
 create mode 100644 arch/arm64/kernel/efistub-le/le.h
 create mode 100644 arch/arm64/kernel/efistub-le/strstr.c

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index afaeb734295a..942cd042e93e 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -27,7 +27,12 @@ arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
 arm64-obj-$(CONFIG_ARM64_CPU_SUSPEND)	+= sleep.o suspend.o
 arm64-obj-$(CONFIG_JUMP_LABEL)		+= jump_label.o
 arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
-arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
+
+arm64-efi-obj-y				:= efi.o
+arm64-efi-obj-$(CONFIG_EFI_STUB)	+= efi-stub.o efi-entry.o
+arm64-efi-obj-$(CONFIG_EFI_LE_STUB)	+= efistub-le/
+arm64-efi-obj-$(CONFIG_CPU_BIG_ENDIAN)	+= efi-be-runtime.o efi-be-call.o
+arm64-obj-$(CONFIG_EFI)			+= $(arm64-efi-obj-y)
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
index a0016d3a17da..89f34bb86cfd 100644
--- a/arch/arm64/kernel/efi-entry.S
+++ b/arch/arm64/kernel/efi-entry.S
@@ -34,8 +34,34 @@ ENTRY(efi_stub_entry)
 	 * Create a stack frame to save FP/LR with extra space
 	 * for image_addr variable passed to efi_entry().
 	 */
-	stp	x29, x30, [sp, #-32]!
+	stp	x29, x30, [sp, #-48]!
+	stp	x22, x23, [sp, #32]
 
+#ifdef CONFIG_EFI_LE_STUB
+	adr	x4, efi_stub_entry
+	ldp	w8, w9, [x4, #-32]
+STUB_BE(rev	w8, w8		)
+STUB_BE(rev	w9, w9		)
+	add	x8, x4, w8, sxtw		// x8: base of Image
+	add	x9, x4, w9, sxtw		// x9: offset of linux_banner
+
+	ldp	x22, x23, [x4, #-24]		// x22: size of Image
+STUB_BE(rev	x23, x23	)		// x23: stext offset
+
+	/*
+	 * Get a pointer to linux_banner in the outer image and store it
+	 * in this image.
+	 */
+	adrp	x4, le_linux_banner
+	str	x9, [x4, #:lo12:le_linux_banner]
+#else
+	adrp	x8, _text
+	add	x8, x8, #:lo12:_text		// x8: base of Image
+	adrp	x9, _edata
+	add	x9, x9, #:lo12:_edata
+	sub	x22, x9, x8			// x22: size of Image
+	ldr	x23, =stext_offset		// x23: stext offset
+#endif
 	/*
 	 * Call efi_entry to do the real work.
 	 * x0 and x1 are already set up by firmware. Current runtime
@@ -45,8 +71,6 @@ ENTRY(efi_stub_entry)
 	 *                         efi_system_table_t *sys_table,
 	 *                         unsigned long *image_addr) ;
 	 */
-	adrp	x8, _text
-	add	x8, x8, #:lo12:_text
 	add	x2, sp, 16
 	str	x8, [x2]
 	bl	efi_entry
@@ -61,18 +85,13 @@ ENTRY(efi_stub_entry)
 	 */
 	mov	x20, x0		// DTB address
 	ldr	x0, [sp, #16]	// relocated _text address
-	ldr	x21, =stext_offset
-	add	x21, x0, x21
+	add	x21, x0, x23
 
 	/*
 	 * Flush dcache covering current runtime addresses
 	 * of kernel text/data. Then flush all of icache.
 	 */
-	adrp	x1, _text
-	add	x1, x1, #:lo12:_text
-	adrp	x2, _edata
-	add	x2, x2, #:lo12:_edata
-	sub	x1, x2, x1
+	mov	x1, x22
 
 	bl	__flush_dcache_area
 	ic	ialluis
@@ -103,7 +122,8 @@ ENTRY(efi_stub_entry)
 
 efi_load_fail:
 	mov	x0, #EFI_LOAD_ERROR
-	ldp	x29, x30, [sp], #32
+	ldp	x22, x23, [sp, #32]
+	ldp	x29, x30, [sp], #48
 	ret
 
 ENDPROC(efi_stub_entry)
diff --git a/arch/arm64/kernel/efistub-le/Makefile b/arch/arm64/kernel/efistub-le/Makefile
new file mode 100644
index 000000000000..38347b0633c8
--- /dev/null
+++ b/arch/arm64/kernel/efistub-le/Makefile
@@ -0,0 +1,52 @@
+
+#
+# Build a little endian EFI stub and wrap it into a single .o
+#
+
+# the LE objects making up the LE efi stub
+le-objs := efi-entry.o efi-stub.o strstr.o cache.o			\
+	   lib-memchr.o lib-memcmp.o lib-memcpy.o lib-memmove.o		\
+		lib-memset.o lib-strchr.o lib-strlen.o lib-strncmp.o	\
+	   fdt-fdt.o fdt-fdt_ro.o fdt-fdt_rw.o fdt-fdt_sw.o 		\
+		fdt-fdt_wip.o fdt-fdt_empty_tree.o 			\
+	   libstub-fdt.o libstub-arm-stub.o libstub-efi-stub-helper.o
+
+extra-y := efi-le-stub.bin efi-le-stub.elf $(le-objs)
+
+KBUILD_CFLAGS := $(subst -pg,,$(KBUILD_CFLAGS)) -fno-stack-protector	\
+		 -mlittle-endian -I$(srctree)/scripts/dtc/libfdt
+
+le-targets := $(addprefix $(obj)/, $(le-objs))
+$(le-targets): KBUILD_AFLAGS += -mlittle-endian -include $(srctree)/$(src)/le.h
+
+$(obj)/efi-entry.o: $(obj)/../efi-entry.S FORCE
+	$(call if_changed_dep,as_o_S)
+
+CFLAGS_efi-stub.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
+$(obj)/efi-stub.o: $(obj)/../efi-stub.c FORCE
+	$(call if_changed_dep,cc_o_c)
+
+$(obj)/cache.o: $(src)/../../mm/cache.S FORCE
+	$(call if_changed_dep,as_o_S)
+
+$(obj)/lib-%.o: $(src)/../../lib/%.S FORCE
+	$(call if_changed_dep,as_o_S)
+
+$(obj)/fdt-%.o: $(srctree)/lib/%.c FORCE
+	$(call if_changed_dep,cc_o_c)
+
+$(obj)/libstub-%.o: $(srctree)/drivers/firmware/efi/libstub/%.c FORCE
+	$(call if_changed_dep,cc_o_c)
+
+$(obj)/efi-le-stub.elf: LDFLAGS=-EL -Map $@.map -T
+$(obj)/efi-le-stub.elf: $(src)/efistub-le.lds $(le-targets) FORCE
+	$(call if_changed,ld)
+
+$(obj)/efi-le-stub.bin: OBJCOPYFLAGS=-O binary
+$(obj)/efi-le-stub.bin: $(obj)/efi-le-stub.elf FORCE
+	$(call if_changed,objcopy)
+
+# the BE object containing the entire LE stub
+obj-y := efi-le-entry.o
+
+$(obj)/efi-le-entry.o: $(obj)/efi-le-stub.bin
diff --git a/arch/arm64/kernel/efistub-le/efi-le-entry.S b/arch/arm64/kernel/efistub-le/efi-le-entry.S
new file mode 100644
index 000000000000..f615430209e5
--- /dev/null
+++ b/arch/arm64/kernel/efistub-le/efi-le-entry.S
@@ -0,0 +1,13 @@
+
+#include <linux/linkage.h>
+
+	.text
+	.align		12
+	.long		_text - efi_stub_entry
+	.long		linux_banner - efi_stub_entry
+	.quad		_kernel_size_le
+	.quad		stext_offset
+	.quad		0
+ENTRY(efi_stub_entry)
+	.incbin		"arch/arm64/kernel/efistub-le/efi-le-stub.bin"
+ENDPROC(efi_stub_entry)
diff --git a/arch/arm64/kernel/efistub-le/efistub-le.lds b/arch/arm64/kernel/efistub-le/efistub-le.lds
new file mode 100644
index 000000000000..20361c43aa2e
--- /dev/null
+++ b/arch/arm64/kernel/efistub-le/efistub-le.lds
@@ -0,0 +1,35 @@
+
+ENTRY(efi_stub_entry)
+
+SECTIONS {
+	/*
+	 * The inner and outer alignment of this chunk of code need to be the
+	 * same so that PC relative references using adrp/add or adrp/ldr pairs
+	 * will work correctly.
+	 * Skip 32 bytes here, so we can put the binary blob at an offset of
+	 * 4k + 0x20 in the outer image, and use the gap to share constants
+	 * emitted by the outer linker but required in the stub.
+	 */
+	.text 0x20 : {
+		arch/arm64/kernel/efistub-le/efi-entry.o(.init.text)
+		*(.init.text)
+		*(.text)
+		*(.text*)
+	}
+	.rodata : {
+		. = ALIGN(16);
+		*(.rodata)
+		*(.rodata*)
+		*(.init.rodata)
+	}
+	.data : {
+		. = ALIGN(16);
+		*(.data)
+		*(.data*)
+		le_linux_banner = .;
+		. += 8;
+	}
+	/DISCARD/ : {
+		*(__ex_table)
+	}
+}
diff --git a/arch/arm64/kernel/efistub-le/le.h b/arch/arm64/kernel/efistub-le/le.h
new file mode 100644
index 000000000000..f4a28a5f6815
--- /dev/null
+++ b/arch/arm64/kernel/efistub-le/le.h
@@ -0,0 +1,12 @@
+
+/*
+ * This is a bit of a hack, but it is necessary to correctly compile .S files
+ * that contain CPU_LE()/CPU_BE() statements, as these are defined to depend on
+ * CONFIG_ symbols and not on the endianness of the compiler.
+ */
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define STUB_BE(code...)	code
+#else
+#define STUB_BE(code...)
+#endif
+#undef CONFIG_CPU_BIG_ENDIAN
diff --git a/arch/arm64/kernel/efistub-le/strstr.c b/arch/arm64/kernel/efistub-le/strstr.c
new file mode 100644
index 000000000000..daed0bbcc0c6
--- /dev/null
+++ b/arch/arm64/kernel/efistub-le/strstr.c
@@ -0,0 +1,20 @@
+
+#include <linux/types.h>
+#include <linux/string.h>
+
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
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a56bb3528755..651c639a8a18 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -22,6 +22,10 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 			unsigned long map_size, unsigned long desc_size,
 			u32 desc_ver)
 {
+#ifdef CONFIG_EFI_LE_STUB
+	extern char const *le_linux_banner;
+	char const *linux_banner = le_linux_banner;
+#endif
 	int node, prev;
 	int status;
 	u32 fdt_val32;
-- 
1.8.3.2
