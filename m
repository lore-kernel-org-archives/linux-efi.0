From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 01/19] x86, boot: Make data from decompress_kernel stage live longer
Date: Wed, 18 Mar 2015 00:28:08 -0700
Message-ID: <1426663706-23979-2-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Ying Huang <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

Ying Huang found commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address
calculation") causes warning from ioremap.

[    0.499891] ------------[ cut here ]------------
[    0.500021] WARNING: CPU: 0 PID: 1 at arch/x86/mm/ioremap.c:63 __ioremap_check_ram+0x445/0x4a0()
[    0.501015] ioremap on RAM pfn 0x3416
[    0.502013] Modules linked in:
[    0.503017] CPU: 0 PID: 1 Comm: swapper Not tainted 3.19.0-04793-g2c303f7 #3
[    0.504013] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.505014]  0000000000000009 ffff880012d8bb88 ffffffff81cedc16 ffff880012d8bbc8
[    0.507424]  ffffffff810dd1a0 0000000000000000 0000000000000001 0000000000000001
[    0.509420]  0000000000003416 0000000000000001 0000000000000001 ffff880012d8bc28
[    0.511415] Call Trace:
[    0.512028]  [<ffffffff81cedc16>] dump_stack+0x2e/0x3e
[    0.513023]  [<ffffffff810dd1a0>] warn_slowpath_common+0xe0/0x160
[    0.514021]  [<ffffffff810dd316>] warn_slowpath_fmt+0x56/0x60
[    0.515022]  [<ffffffff8107f4a5>] __ioremap_check_ram+0x445/0x4a0
[    0.516022]  [<ffffffff8107f060>] ? trace_do_page_fault+0x9b0/0x9b0
[    0.517020]  [<ffffffff810ec948>] walk_system_ram_range+0x128/0x140
[    0.518022]  [<ffffffff82d9081f>] ? create_setup_data_nodes+0xd1/0x488
[    0.519019]  [<ffffffff82d9081f>] ? create_setup_data_nodes+0xd1/0x488
[    0.520021]  [<ffffffff8107f882>] __ioremap_caller+0x172/0x850
[    0.521021]  [<ffffffff81080064>] ioremap_cache+0x24/0x30
[    0.522019]  [<ffffffff82d9081f>] create_setup_data_nodes+0xd1/0x488
[    0.523023]  [<ffffffff81493c9c>] ? internal_create_group+0x4ac/0x830
[    0.524020]  [<ffffffff82d90c76>] boot_params_ksysfs_init+0xa0/0xf9
[    0.525020]  [<ffffffff810005f1>] do_one_initcall+0x371/0x4c0
[    0.526019]  [<ffffffff82d90bd6>] ? create_setup_data_nodes+0x488/0x488
[    0.527024]  [<ffffffff82d8afd5>] kernel_init_freeable+0x368/0x4ba
[    0.528022]  [<ffffffff81ce15d0>] ? rest_init+0x260/0x260
[    0.529020]  [<ffffffff81ce15e6>] kernel_init+0x16/0x240
[    0.530023]  [<ffffffff81d0253a>] ret_from_fork+0x7a/0xb0
[    0.531021]  [<ffffffff81ce15d0>] ? rest_init+0x260/0x260
[    0.532033] ---[ end trace b6a2b7ddc92922e5 ]---

Boris later found setup_data for kaslr from boot stage become all 0's in
kernel stage.

Current there is overlapping between data section for decompress code and final
kernel running code bss/brk area.  We need to avoid overlapping to make data
live longer till kernel access them.

Current code is using extract_offset to control copied kernel position, it
will put the copied kernel in the middle of buffer when kernel run size is
bigger than decompressed needed buffer size. That cause the overlapping.

Detail flow in current code:
Bootloader allocate buffer according to init_size in hdr, and load the
ZO (arch/x86/boot/compressed/vmlinux) from start of that buffer.
During running of ZO, ZO move itself to the middle of buffer at
z_extract_offset to make sure that decompressor would not have output
overwrite input data before input data get consumed.
After decompressor is done, VO use most part buffer from start.
and ZO code and data section will overlap with VO bss section.
And later VO/clear_bss() clear them before code in arch/x86/kernel/setup.c
try to access them.

Current layout:
when init_size is the same as kernel run_size:
                                        run_size
0              extract_offset          init_size
|------------------|------------------------|
   VO text/data                   VO bss/brk
                   input ZO text ZO data

This patch try to:
At first, move ZO to the end of buffer instead of middle of the buffer.
When init_size is bigger than kernel run size, will have

0                            run_size    init_size
|--------------------------------|----------|
   VO text/data        VO bss/brk
                       input ZO text ZO data

We already have init_size the buffer size, we can find the end easily
when copying ZO before decompressing.

Secondly, add extra size (ZO data size) to init_size. That is for
even old init_size is same as kernel run size, we will have

                                         run_size
0                                   old init_size init_size
|------------------------------------------|--------|
   VO text/data                  VO bss/brk
                               input ZO text ZO data

Here the size changes when old init_size is same as kernel run_size.
# size arch/x86/boot/compressed/vmlinux
   text	   data	    bss	    dec	    hex	filename
13247288    264	  49248	13296800 cae4a0	arch/x86/boot/compressed/vmlinux
# bootloader reported init_size
kernel: [13cc00000, 13ff8efff]

After patch:
#size arch/x86/boot/compressed/vmlinux
   text	   data	    bss	    dec	    hex	filename
13247289    264	  49248	13296801 cae4a1	arch/x86/boot/compressed/vmlinux
# bootloader reported init_size
kernel: [13cc00000, 13ffa2fff]

so init_size increase 20 pages 80k.

Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
Link: http://marc.info/?l=linux-kernel&m=142492905425130&w=2
Reported-by: Ying Huang <ying.huang@intel.com>
Cc: Ying Huang <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/Makefile                 |  2 +-
 arch/x86/boot/compressed/head_32.S     | 11 +++++++++--
 arch/x86/boot/compressed/head_64.S     |  8 ++++++--
 arch/x86/boot/compressed/mkpiggy.c     |  7 ++-----
 arch/x86/boot/compressed/vmlinux.lds.S |  2 ++
 arch/x86/boot/header.S                 | 14 ++++++++++++--
 arch/x86/kernel/asm-offsets.c          |  1 +
 arch/x86/kernel/vmlinux.lds.S          |  1 +
 8 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 57bbf2f..863ef25 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -86,7 +86,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) [ABCDGRSTVW] \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|_rodata\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1d7fbbc..1410c42 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -147,7 +147,9 @@ preferred_addr:
 1:
 
 	/* Target address to relocate to for decompression */
-	addl	$z_extract_offset, %ebx
+	movl    BP_init_size(%esi), %eax
+	subl    $_end, %eax
+	addl    %eax, %ebx
 
 	/* Set up the stack */
 	leal	boot_stack_end(%ebx), %esp
@@ -209,8 +211,13 @@ relocated:
 				/* push arguments for decompress_kernel: */
 	pushl	$z_run_size	/* size of kernel with .bss and .brk */
 	pushl	$z_output_len	/* decompressed length, end of relocs */
-	leal	z_extract_offset_negative(%ebx), %ebp
+
+	movl    BP_init_size(%esi), %eax
+	subl    $_end, %eax
+	movl    %ebx, %ebp
+	subl    %eax, %ebp
 	pushl	%ebp		/* output address */
+
 	pushl	$z_input_len	/* input_len */
 	leal	input_data(%ebx), %eax
 	pushl	%eax		/* input_data */
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 6b1766c..4e30ee3 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -101,7 +101,9 @@ ENTRY(startup_32)
 1:
 
 	/* Target address to relocate to for decompression */
-	addl	$z_extract_offset, %ebx
+	movl	BP_init_size(%esi), %eax
+	subl	$_end, %eax
+	addl	%eax, %ebx
 
 /*
  * Prepare for entering 64 bit mode
@@ -329,7 +331,9 @@ preferred_addr:
 1:
 
 	/* Target address to relocate to for decompression */
-	leaq	z_extract_offset(%rbp), %rbx
+	movl	BP_init_size(%rsi), %ebx
+	subl	$_end, %ebx
+	addq	%rbp, %rbx
 
 	/* Set up the stack */
 	leaq	boot_stack_end(%rbx), %rsp
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index d8222f2..5faad09 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -83,11 +83,8 @@ int main(int argc, char *argv[])
 	printf("z_input_len = %lu\n", ilen);
 	printf(".globl z_output_len\n");
 	printf("z_output_len = %lu\n", (unsigned long)olen);
-	printf(".globl z_extract_offset\n");
-	printf("z_extract_offset = 0x%lx\n", offs);
-	/* z_extract_offset_negative allows simplification of head_32.S */
-	printf(".globl z_extract_offset_negative\n");
-	printf("z_extract_offset_negative = -0x%lx\n", offs);
+	printf(".globl z_min_extract_offset\n");
+	printf("z_min_extract_offset = 0x%lx\n", offs);
 	printf(".globl z_run_size\n");
 	printf("z_run_size = %lu\n", run_size);
 
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index 34d047c..6d6158e 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -35,6 +35,7 @@ SECTIONS
 		*(.text.*)
 		_etext = . ;
 	}
+        . = ALIGN(PAGE_SIZE); /* keep ADDON_ZO_SIZE page aligned */
 	.rodata : {
 		_rodata = . ;
 		*(.rodata)	 /* read-only data */
@@ -70,5 +71,6 @@ SECTIONS
 		_epgtable = . ;
 	}
 #endif
+	. = ALIGN(PAGE_SIZE);	/* keep ZO size page aligned */
 	_end = .;
 }
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 16ef025..226d166 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -440,12 +440,22 @@ setup_data:		.quad 0			# 64-bit physical pointer to
 
 pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 
-#define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_extract_offset)
+# don't overlap data area of ZO with VO bss
+#define ADDON_ZO_SIZE (ZO__end - ZO__rodata)
+
+#define ZO_INIT_SIZE	(ZO__end - ZO_startup_32 + ZO_z_min_extract_offset)
 #define VO_INIT_SIZE	(VO__end - VO__text)
 #if ZO_INIT_SIZE > VO_INIT_SIZE
+
+/* only add the difference to cover ADDON_ZO */
+#if (ZO_INIT_SIZE - VO_INIT_SIZE) < ADDON_ZO_SIZE
+#define INIT_SIZE (ZO_INIT_SIZE + (ADDON_ZO_SIZE-(ZO_INIT_SIZE - VO_INIT_SIZE)))
+#else
 #define INIT_SIZE ZO_INIT_SIZE
+#endif
+
 #else
-#define INIT_SIZE VO_INIT_SIZE
+#define INIT_SIZE (VO_INIT_SIZE + ADDON_ZO_SIZE)
 #endif
 init_size:		.long INIT_SIZE		# kernel initialization size
 handover_offset:	.long 0			# Filled in by build.c
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 9f6b934..0e8e4f7 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -66,6 +66,7 @@ void common(void) {
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
 	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
+	OFFSET(BP_init_size, boot_params, hdr.init_size);
 	OFFSET(BP_pref_address, boot_params, hdr.pref_address);
 	OFFSET(BP_code32_start, boot_params, hdr.code32_start);
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 00bf300..5816920 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -325,6 +325,7 @@ SECTIONS
 		__brk_limit = .;
 	}
 
+	. = ALIGN(PAGE_SIZE);		/* keep VO_INIT_SIZE page aligned */
 	_end = .;
 
         STABS_DEBUG
-- 
1.8.4.5
