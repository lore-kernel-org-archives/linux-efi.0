From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 7/7] x86, kaslr, 64bit: Set new or extra ident_mapping
Date: Sat,  7 Mar 2015 14:07:21 -0800
Message-ID: <1425766041-6551-8-git-send-email-yinghai@kernel.org>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

First, aslr will support to put random VO above 4G, so we must set ident
mapping for the range even we come from startup_32 path.

Second, when boot from 64bit bootloader, bootloader set ident mapping,
and boot via ZO (arch/x86/boot/compressed/vmlinux) startup_64.
Those pages for pagetable need to be avoided when we select new random
VO (vmlinux) base. Otherwise decompressor would overwrite them during
decompressing.

One solution: go through pagetable and find out every page is used by
pagetable for every mem_aovid checking but we will need extra code.

Other solution: create new ident mapping instead, and pages for pagetable
will sit in _pagetable section of ZO, and they are in mem_avoid array already.
In this way, we can reuse the code for setting ident mapping.

The _pgtable will be shared 32bit and 64bit path to reduce init_size,
as now ZO _rodata to _end will contribute init_size.

Need to increase pgt buffer size.
When boot via startup_64, as we need to cover old VO, params, cmdline
and new VO, in extreme case we could have them all cross 512G boundary,
will need (2+2)*4 pages with 2M mapping. And need 2 for first 2M for vga ram.
Plus one for level4. Total will be 19 pages.
When boot via startup_32, aslr would move new VO above 4G, we need set extra
ident mapping for new VO, pgt buffer come from _pgtable offset 6 pages.
should only need (2+2) pages at most when it cross 512G boundary.
So 19 pages could make both pathes happy.


-v3: add mapping for first 2M with video ram when X86_VERBOSE_BOOTUP is set.
     Don't need to set mapping for setup_data, as it is already late
     in boot/ZO stage, will not access it until VO stage, and VO stage
     will use early_memmap or kernel address to access them.

Cc: Kees Cook <keescook@chromium.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/aslr.c     | 21 ++++++++
 arch/x86/boot/compressed/head_64.S  |  4 +-
 arch/x86/boot/compressed/misc_pgt.c | 98 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/boot.h         | 19 +++++++
 4 files changed, 140 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/boot/compressed/misc_pgt.c

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index a279514..34eb652 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -1,3 +1,8 @@
+#ifdef CONFIG_X86_64
+#define __pa(x)  ((unsigned long)(x))
+#define __va(x)  ((void *)((unsigned long)(x)))
+#endif
+
 #include "misc.h"
 
 #include <asm/msr.h>
@@ -21,6 +26,8 @@ struct kaslr_setup_data {
 	__u8 data[1];
 } kaslr_setup_data;
 
+#include "misc_pgt.c"
+
 #define I8254_PORT_CONTROL	0x43
 #define I8254_PORT_COUNTER0	0x40
 #define I8254_CMD_READBACK	0xC0
@@ -160,6 +167,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	unsafe = (unsigned long)input + input_size;
 	mem_avoid[0].start = unsafe;
 	mem_avoid[0].size = unsafe_len;
+	fill_pagetable(output, init_size);
 
 	/* Avoid initrd. */
 	initrd_start  = (u64)real_mode->ext_ramdisk_image << 32;
@@ -168,6 +176,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	initrd_size |= real_mode->hdr.ramdisk_size;
 	mem_avoid[1].start = initrd_start;
 	mem_avoid[1].size = initrd_size;
+	/* don't need to set mapping for initrd */
 
 	/* Avoid kernel command line. */
 	cmd_line  = (u64)real_mode->ext_cmd_line_ptr << 32;
@@ -178,10 +187,19 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
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
@@ -362,6 +380,9 @@ unsigned char *choose_kernel_location(struct boot_params *params,
 		goto out;
 
 	choice = random;
+
+	fill_pagetable(choice, init_size);
+	switch_pagetable();
 out:
 	return (unsigned char *)choice;
 }
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 69015b5..1b6e34a 100644
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
diff --git a/arch/x86/boot/compressed/misc_pgt.c b/arch/x86/boot/compressed/misc_pgt.c
new file mode 100644
index 0000000..b55982c
--- /dev/null
+++ b/arch/x86/boot/compressed/misc_pgt.c
@@ -0,0 +1,98 @@
+
+#ifdef CONFIG_X86_64
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
+extern unsigned char _pgtable[];
+static void fill_pagetable(unsigned long start, unsigned long size)
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
+static void switch_pagetable(void)
+{
+	write_cr3((unsigned long)level4p);
+}
+
+#else
+static void fill_pagetable(unsigned long start, unsigned long size)
+{
+}
+static void switch_pagetable(void)
+{
+}
+#endif
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
