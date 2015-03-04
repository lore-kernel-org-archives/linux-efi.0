From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 07/15] x86, kaslr, 64bit: set new or extra ident_mapping
Date: Wed,  4 Mar 2015 00:00:40 -0800
Message-ID: <1425456048-16236-8-git-send-email-yinghai@kernel.org>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

aslr will support to put random VO above 4G, so we need to set ident
mapping for the range even we come from startup_32 path.

At the same time, when boot from 64bit bootloader, bootloader will
set ident mapping, and boot via ZO startup_64.
Then pages for pagetable need to be avoided when selecting new random VO base.
otherwise decompressor will overwrite the pgtable.

One solution: go through pagetable and find out every page is
used by pagetable for every mem_aovid checking.
but kexec could put those page anywhere, and we will need extra code.

Other solution: create new ident mapping instead, and pages for pagetable
will sit in _pagetable area of ZO, and they are in mem_avoid array already.

so the _pgtable will be shared 32bit and 64bit path to reduce init_size.

Need to increase buffer size. As we need to cover old VO, params, cmdline
and new VO, in extreme case we could have all cross 512G boundary, will need
1+(2+2)*4 pages with 2M mapping.

Cc: Kees Cook <keescook@chromium.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Borislav Petkov <bp@suse.de>
Cc: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/aslr.c     | 28 +++++++++++
 arch/x86/boot/compressed/head_64.S  |  4 +-
 arch/x86/boot/compressed/misc_pgt.c | 96 +++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/boot.h         | 13 +++++
 4 files changed, 139 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/boot/compressed/misc_pgt.c

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index e8486a5..10ed3c7 100644
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
+	fill_linux64_pagetable(output, init_size);
 
 	/* Avoid initrd. */
 	initrd_start  = (u64)real_mode->ext_ramdisk_image << 32;
@@ -168,6 +176,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	initrd_size |= real_mode->hdr.ramdisk_size;
 	mem_avoid[1].start = initrd_start;
 	mem_avoid[1].size = initrd_size;
+	/* don't need to set mapping for initrd */
 
 	/* Avoid kernel command line. */
 	cmd_line  = (u64)real_mode->ext_cmd_line_ptr << 32;
@@ -178,10 +187,25 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 		;
 	mem_avoid[2].start = cmd_line;
 	mem_avoid[2].size = cmd_line_size;
+	fill_linux64_pagetable(cmd_line, cmd_line_size);
 
 	/* Avoid params */
 	mem_avoid[3].start = (unsigned long)real_mode;
 	mem_avoid[3].size = sizeof(*real_mode);
+	fill_linux64_pagetable((unsigned long)real_mode, sizeof(*real_mode));
+}
+
+static void init_linux64_pagetable(void)
+{
+	struct setup_data *ptr;
+
+	ptr = (struct setup_data *)(unsigned long)real_mode->hdr.setup_data;
+	while (ptr) {
+		fill_linux64_pagetable((unsigned long)ptr,
+				       sizeof(*ptr) + ptr->len);
+
+		ptr = (struct setup_data *)(unsigned long)ptr->next;
+	}
 }
 
 /* Does this memory vector overlap a known avoided area? */
@@ -346,6 +370,7 @@ unsigned char *choose_kernel_location(struct boot_params *params,
 #endif
 	add_kaslr_setup_data(params, 1);
 
+	init_linux64_pagetable();
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
 		       (unsigned long)output, init_size);
@@ -362,6 +387,9 @@ unsigned char *choose_kernel_location(struct boot_params *params,
 		goto out;
 
 	choice = random;
+
+	fill_linux64_pagetable(choice, init_size);
+	switch_linux64_pagetable();
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
index 0000000..afc73bf
--- /dev/null
+++ b/arch/x86/boot/compressed/misc_pgt.c
@@ -0,0 +1,96 @@
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
+static void fill_linux64_pagetable(unsigned long start, unsigned long size)
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
+	if (start < end)
+		kernel_ident_mapping_init(&mapping_info, level4p, start, end);
+}
+
+static void switch_linux64_pagetable(void)
+{
+	write_cr3((unsigned long)level4p);
+}
+
+#else
+static void fill_linux64_pagetable(unsigned long start, unsigned long size)
+{
+}
+static void switch_linux64_pagetable(void)
+{
+}
+#endif
diff --git a/arch/x86/include/asm/boot.h b/arch/x86/include/asm/boot.h
index 4fa687a..3795a77 100644
--- a/arch/x86/include/asm/boot.h
+++ b/arch/x86/include/asm/boot.h
@@ -32,7 +32,20 @@
 #endif /* !CONFIG_KERNEL_BZIP2 */
 
 #ifdef CONFIG_X86_64
+
 #define BOOT_STACK_SIZE	0x4000
+
+#define BOOT_INIT_PGT_SIZE (6*4096)
+#ifdef CONFIG_RANDOMIZE_BASE
+/*
+ * 17 pages to cover for kernel, param, cmd_line, random kernel
+ * if all cross 512G boundary.
+ */
+#define BOOT_PGT_SIZE (BOOT_INIT_PGT_SIZE + (11*4096))
+#else
+#define BOOT_PGT_SIZE BOOT_INIT_PGT_SIZE
+#endif
+
 #else
 #define BOOT_STACK_SIZE	0x1000
 #endif
-- 
1.8.4.5
