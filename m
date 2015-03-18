From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 10/19] x86, 64bit: Set ident_mapping for kaslr
Date: Wed, 18 Mar 2015 00:28:17 -0700
Message-ID: <1426663706-23979-11-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

Current aslr only support random in near range, and new range still use
old mapping. Also it does not support new range above 4G.

We need to have ident set for the new range before we can do decompress
to the new ouput, and later run them.

In this patch, we add ident mapping for all needed range.

At first, to aslr support to put random VO above 4G, we must set ident
mapping for the new range when it come via startup_32 path.

Secondly, when boot from 64bit bootloader, bootloader set ident mapping,
and boot via ZO (arch/x86/boot/compressed/vmlinux) startup_64.
Those pages for pagetable need to be avoided when we select new random
VO (vmlinux) base. Otherwise decompressor would overwrite them during
decompressing.
First way would be: go through pagetable and find out every page is used by
pagetable for every mem_aovid checking but we will need extra code, and may
need to increase mem_avoid array size to hold them.
Other way would be: We can create new ident mapping instead, and pages for
pagetable will come from _pagetable section of ZO, and they are in mem_avoid
array already. In this way, we can reuse the code for setting ident mapping.

The _pgtable will be shared 32bit and 64bit path to reduce init_size,
as now ZO _rodata to _end will contribute init_size.

We need to increase pgt buffer size.
When boot via startup_64, as we need to cover old VO, params, cmdline
and new VO, in extreme case we could have them all cross 512G boundary,
will need (2+2)*4 pages with 2M mapping. And need 2 for first 2M for vga ram.
Plus one for level4. Total will be 19 pages.
When boot via startup_32, aslr would move new VO above 4G, we need set extra
ident mapping for new VO, pgt buffer come from _pgtable offset 6 pages.
should only need (2+2) pages at most when it cross 512G boundary.
So 19 pages could make both paths happy.

Cc: Kees Cook <keescook@chromium.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/Makefile   |  3 ++
 arch/x86/boot/compressed/aslr.c     | 14 ++++++
 arch/x86/boot/compressed/head_64.S  |  4 +-
 arch/x86/boot/compressed/misc.h     | 11 +++++
 arch/x86/boot/compressed/misc_pgt.c | 91 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/boot.h         | 19 ++++++++
 6 files changed, 140 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/boot/compressed/misc_pgt.c

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index e12a93c..66461b4 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -58,6 +58,9 @@ vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 
 vmlinux-objs-$(CONFIG_EARLY_PRINTK) += $(obj)/early_serial_console.o
 vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/aslr.o
+ifdef CONFIG_X86_64
+	vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/misc_pgt.o
+endif
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 9dab0d6..f8d095d 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -154,6 +154,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	 */
 	mem_avoid[0].start = input;
 	mem_avoid[0].size = (output + init_size) - input;
+	fill_pagetable(input, (output + init_size) - input);
 
 	/* Avoid initrd. */
 	initrd_start  = (u64)real_mode->ext_ramdisk_image << 32;
@@ -162,6 +163,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	initrd_size |= real_mode->hdr.ramdisk_size;
 	mem_avoid[1].start = initrd_start;
 	mem_avoid[1].size = initrd_size;
+	/* don't need to set mapping for initrd */
 
 	/* Avoid kernel command line. */
 	cmd_line  = (u64)real_mode->ext_cmd_line_ptr << 32;
@@ -172,10 +174,19 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 		;
 	mem_avoid[2].start = cmd_line;
 	mem_avoid[2].size = cmd_line_size;
+	fill_pagetable(cmd_line, cmd_line_size);
 
 	/* Avoid params */
 	mem_avoid[3].start = (unsigned long)real_mode;
 	mem_avoid[3].size = sizeof(*real_mode);
+	fill_pagetable((unsigned long)real_mode, sizeof(*real_mode));
+
+	/* don't need to set mapping for setup_data */
+
+#ifdef CONFIG_X86_VERBOSE_BOOTUP
+	/* for video ram */
+	fill_pagetable(0, PMD_SIZE);
+#endif
 }
 
 /* Does this memory vector overlap a known avoided area? */
@@ -354,6 +365,9 @@ unsigned char *choose_kernel_location(unsigned char *input,
 		goto out;
 
 	choice = random;
+
+	fill_pagetable(choice, output_run_size);
+	switch_pagetable();
 out:
 	return (unsigned char *)choice;
 }
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2678f03..11b1fbe 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -125,7 +125,7 @@ ENTRY(startup_32)
 	/* Initialize Page tables to 0 */
 	leal	pgtable(%ebx), %edi
 	xorl	%eax, %eax
-	movl	$((4096*6)/4), %ecx
+	movl	$(BOOT_INIT_PGT_SIZE/4), %ecx
 	rep	stosl
 
 	/* Build Level 4 */
@@ -477,4 +477,4 @@ boot_stack_end:
 	.section ".pgtable","a",@nobits
 	.balign 4096
 pgtable:
-	.fill 6*4096, 1, 0
+	.fill BOOT_PGT_SIZE, 1, 0
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index dec1663..98914a0 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -74,6 +74,17 @@ unsigned char *choose_kernel_location(unsigned char *input,
 }
 #endif
 
+#ifdef CONFIG_X86_64
+void fill_pagetable(unsigned long start, unsigned long size);
+void switch_pagetable(void);
+extern unsigned char _pgtable[];
+#else
+static inline void fill_pagetable(unsigned long start, unsigned long size)
+{ }
+static inline void switch_pagetable(void)
+{ }
+#endif
+
 #ifdef CONFIG_EARLY_PRINTK
 /* early_serial_console.c */
 extern int early_serial_base;
diff --git a/arch/x86/boot/compressed/misc_pgt.c b/arch/x86/boot/compressed/misc_pgt.c
new file mode 100644
index 0000000..4b81fb7
--- /dev/null
+++ b/arch/x86/boot/compressed/misc_pgt.c
@@ -0,0 +1,91 @@
+#define __pa(x)  ((unsigned long)(x))
+#define __va(x)  ((void *)((unsigned long)(x)))
+
+#include "misc.h"
+
+#include <asm/init.h>
+#include <asm/pgtable.h>
+
+#include "../../mm/ident_map.c"
+
+struct alloc_pgt_data {
+	unsigned char *pgt_buf;
+	unsigned long pgt_buf_size;
+	unsigned long pgt_buf_offset;
+};
+
+static void *alloc_pgt_page(void *context)
+{
+	struct alloc_pgt_data *d = (struct alloc_pgt_data *)context;
+	unsigned char *p = (unsigned char *)d->pgt_buf;
+
+	if (d->pgt_buf_offset >= d->pgt_buf_size) {
+		debug_putstr("out of pgt_buf in misc.c\n");
+		return NULL;
+	}
+
+	p += d->pgt_buf_offset;
+	d->pgt_buf_offset += PAGE_SIZE;
+
+	return p;
+}
+
+/*
+ * Use a normal definition of memset() from string.c. There are already
+ * included header files which expect a definition of memset() and by
+ * the time we define memset macro, it is too late.
+ */
+#undef memset
+#define memzero(s, n)   memset((s), 0, (n))
+
+unsigned long __force_order;
+static struct alloc_pgt_data pgt_data;
+static struct x86_mapping_info mapping_info;
+static pgd_t *level4p;
+
+void fill_pagetable(unsigned long start, unsigned long size)
+{
+	unsigned long end = start + size;
+
+	if (!level4p) {
+		pgt_data.pgt_buf_offset = 0;
+		mapping_info.alloc_pgt_page = alloc_pgt_page;
+		mapping_info.context = &pgt_data;
+		mapping_info.pmd_flag = __PAGE_KERNEL_LARGE_EXEC;
+
+		/*
+		 * come from startup_32 ?
+		 * then cr3 is _pgtable, we can reuse it.
+		 */
+		level4p = (pgd_t *)read_cr3();
+		if ((unsigned long)level4p == (unsigned long)_pgtable) {
+			pgt_data.pgt_buf = (unsigned char *)_pgtable +
+						 BOOT_INIT_PGT_SIZE;
+			pgt_data.pgt_buf_size = BOOT_PGT_SIZE -
+						 BOOT_INIT_PGT_SIZE;
+
+			debug_putstr("boot via startup_32\n");
+		} else {
+			pgt_data.pgt_buf = (unsigned char *)_pgtable;
+			pgt_data.pgt_buf_size = BOOT_PGT_SIZE;
+
+			debug_putstr("boot via startup_64\n");
+			level4p = (pgd_t *)alloc_pgt_page(&pgt_data);
+		}
+		memset((unsigned char *)pgt_data.pgt_buf, 0,
+			 pgt_data.pgt_buf_size);
+	}
+
+	/* align boundary to 2M */
+	start = round_down(start, PMD_SIZE);
+	end = round_up(end, PMD_SIZE);
+	if (start >= end)
+		return;
+
+	kernel_ident_mapping_init(&mapping_info, level4p, start, end);
+}
+
+void switch_pagetable(void)
+{
+	write_cr3((unsigned long)level4p);
+}
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 4fa687a..7b23908 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -32,7 +32,26 @@
 #endif /* !CONFIG_KERNEL_BZIP2 */
 
 #ifdef CONFIG_X86_64
+
 #define BOOT_STACK_SIZE	0x4000
+
+#define BOOT_INIT_PGT_SIZE (6*4096)
+#ifdef CONFIG_RANDOMIZE_BASE
+/*
+ * 1 page for level4, 2 pages for first 2M.
+ * (2+2)*4 pages for kernel, param, cmd_line, random kernel
+ * if all cross 512G boundary.
+ * So total will be 19 pages.
+ */
+#ifdef CONFIG_X86_VERBOSE_BOOTUP
+#define BOOT_PGT_SIZE (19*4096)
+#else
+#define BOOT_PGT_SIZE (17*4096)
+#endif
+#else
+#define BOOT_PGT_SIZE BOOT_INIT_PGT_SIZE
+#endif
+
 #else
 #define BOOT_STACK_SIZE	0x1000
 #endif
-- 
1.8.4.5
