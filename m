From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 1/7] x86, kaslr: Use init_size instead of run_size
Date: Sat,  7 Mar 2015 14:07:15 -0800
Message-ID: <1425766041-6551-2-git-send-email-yinghai@kernel.org>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>
List-Id: linux-efi@vger.kernel.org

commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
introduced one run_size for kaslr.
We should use real runtime size (include copy/decompress) aka init_size.

run_size is VO (vmlinux) init size include bss and brk.
init_size is the size needed for decompress and it is bigger than run_size
when decompress need more buff.

According to arch/x86/boot/header.S:
| #define ZO_INIT_SIZE    (ZO__end - ZO_startup_32 + ZO_z_extract_offset)
| #define VO_INIT_SIZE    (VO__end - VO__text)
| #if ZO_INIT_SIZE > VO_INIT_SIZE
| #define INIT_SIZE ZO_INIT_SIZE
| #else
| #define INIT_SIZE VO_INIT_SIZE
| #endif
| init_size:              .long INIT_SIZE         # kernel initialization size

Bootloader allocate buffer according to init_size in hdr, and load the
ZO (arch/x86/boot/compressed/vmlinux) from start of that buffer.
init_size first come from VO (vmlinux) init size. That VO init size
is from VO _end to VO _end and include VO bss and brk area.

During running of ZO, ZO move itself to the middle of buffer at
z_extract_offset to make sure that decompressor would not have output
overwrite input data before input data get consumed.
But z_extract_offset calculating is based on size of VO (vmlinux) and size
of compressed VO only at first.
So need to make sure [z_extra_offset, init_size) will fit ZO, that means
init_size need to be adjusted according to ZO size.
That make init_size is always >= run_size.

During aslr buffer searching, we need to make sure the new buffer is big
enough for decompress at first. So use init_size instead, and kill not
needed run_size related code.

Fixes: e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Junjie Mao <eternal.n08@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/Makefile  |  4 +---
 arch/x86/boot/compressed/head_32.S |  5 ++---
 arch/x86/boot/compressed/head_64.S |  5 +----
 arch/x86/boot/compressed/misc.c    | 15 +++++++-------
 arch/x86/boot/compressed/mkpiggy.c |  9 ++------
 arch/x86/tools/calc_run_size.sh    | 42 --------------------------------------
 6 files changed, 13 insertions(+), 67 deletions(-)
 delete mode 100644 arch/x86/tools/calc_run_size.sh

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0a291cd..70cc92c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -92,10 +92,8 @@ suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
-RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
-	     $(CONFIG_SHELL) $(srctree)/arch/x86/tools/calc_run_size.sh)
 quiet_cmd_mkpiggy = MKPIGGY $@
-      cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
+      cmd_mkpiggy = $(obj)/mkpiggy $< > $@ || ( rm -f $@ ; false )
 
 targets += piggy.S
 $(obj)/piggy.S: $(obj)/vmlinux.bin.$(suffix-y) $(obj)/mkpiggy FORCE
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 1d7fbbc..cbed140 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -207,8 +207,7 @@ relocated:
  * Do the decompression, and jump to the new kernel..
  */
 				/* push arguments for decompress_kernel: */
-	pushl	$z_run_size	/* size of kernel with .bss and .brk */
-	pushl	$z_output_len	/* decompressed length, end of relocs */
+	pushl	$z_output_len	/* decompressed length */
 	leal	z_extract_offset_negative(%ebx), %ebp
 	pushl	%ebp		/* output address */
 	pushl	$z_input_len	/* input_len */
@@ -218,7 +217,7 @@ relocated:
 	pushl	%eax		/* heap area */
 	pushl	%esi		/* real mode pointer */
 	call	decompress_kernel /* returns kernel location in %eax */
-	addl	$28, %esp
+	addl	$24, %esp
 
 /*
  * Jump to the decompressed kernel.
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 6b1766c..2884e0c 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -402,16 +402,13 @@ relocated:
  * Do the decompression, and jump to the new kernel..
  */
 	pushq	%rsi			/* Save the real mode argument */
-	movq	$z_run_size, %r9	/* size of kernel with .bss and .brk */
-	pushq	%r9
 	movq	%rsi, %rdi		/* real mode address */
 	leaq	boot_heap(%rip), %rsi	/* malloc area for uncompression */
 	leaq	input_data(%rip), %rdx  /* input_data */
 	movl	$z_input_len, %ecx	/* input_len */
 	movq	%rbp, %r8		/* output target address */
-	movq	$z_output_len, %r9	/* decompressed length, end of relocs */
+	movq	$z_output_len, %r9	/* decompressed length */
 	call	decompress_kernel	/* returns kernel location in %rax */
-	popq	%r9
 	popq	%rsi
 
 /*
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 5903089..51e9e54 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -370,10 +370,10 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output,
-				  unsigned long output_len,
-				  unsigned long run_size)
+				  unsigned long output_len)
 {
 	unsigned char *output_orig = output;
+	unsigned long init_size;
 
 	real_mode = rmode;
 
@@ -396,15 +396,14 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
+	init_size = real_mode->hdr.init_size;
+
 	/*
-	 * The memory hole needed for the kernel is the larger of either
-	 * the entire decompressed kernel plus relocation table, or the
-	 * entire decompressed kernel plus .bss and .brk sections.
+	 * The memory hole needed for the kernel is init_size for running
+	 * and init_size is bigger than output_len always.
 	 */
 	output = choose_kernel_location(real_mode, input_data, input_len,
-					output,
-					output_len > run_size ? output_len
-							      : run_size);
+					output, init_size);
 
 	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index d8222f2..b669ab6 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -36,13 +36,11 @@ int main(int argc, char *argv[])
 	uint32_t olen;
 	long ilen;
 	unsigned long offs;
-	unsigned long run_size;
 	FILE *f = NULL;
 	int retval = 1;
 
-	if (argc < 3) {
-		fprintf(stderr, "Usage: %s compressed_file run_size\n",
-				argv[0]);
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
 		goto bail;
 	}
 
@@ -76,7 +74,6 @@ int main(int argc, char *argv[])
 	offs += olen >> 12;	/* Add 8 bytes for each 32K block */
 	offs += 64*1024 + 128;	/* Add 64K + 128 bytes slack */
 	offs = (offs+4095) & ~4095; /* Round to a 4K boundary */
-	run_size = atoi(argv[2]);
 
 	printf(".section \".rodata..compressed\",\"a\",@progbits\n");
 	printf(".globl z_input_len\n");
@@ -88,8 +85,6 @@ int main(int argc, char *argv[])
 	/* z_extract_offset_negative allows simplification of head_32.S */
 	printf(".globl z_extract_offset_negative\n");
 	printf("z_extract_offset_negative = -0x%lx\n", offs);
-	printf(".globl z_run_size\n");
-	printf("z_run_size = %lu\n", run_size);
 
 	printf(".globl input_data, input_data_end\n");
 	printf("input_data:\n");
diff --git a/arch/x86/tools/calc_run_size.sh b/arch/x86/tools/calc_run_size.sh
deleted file mode 100644
index 1a4c17b..0000000
--- a/arch/x86/tools/calc_run_size.sh
+++ /dev/null
@@ -1,42 +0,0 @@
-#!/bin/sh
-#
-# Calculate the amount of space needed to run the kernel, including room for
-# the .bss and .brk sections.
-#
-# Usage:
-# objdump -h a.out | sh calc_run_size.sh
-
-NUM='\([0-9a-fA-F]*[ \t]*\)'
-OUT=$(sed -n 's/^[ \t0-9]*.b[sr][sk][ \t]*'"$NUM$NUM$NUM$NUM"'.*/\1\4/p')
-if [ -z "$OUT" ] ; then
-	echo "Never found .bss or .brk file offset" >&2
-	exit 1
-fi
-
-OUT=$(echo ${OUT# })
-sizeA=$(printf "%d" 0x${OUT%% *})
-OUT=${OUT#* }
-offsetA=$(printf "%d" 0x${OUT%% *})
-OUT=${OUT#* }
-sizeB=$(printf "%d" 0x${OUT%% *})
-OUT=${OUT#* }
-offsetB=$(printf "%d" 0x${OUT%% *})
-
-run_size=$(( $offsetA + $sizeA + $sizeB ))
-
-# BFD linker shows the same file offset in ELF.
-if [ "$offsetA" -ne "$offsetB" ] ; then
-	# Gold linker shows them as consecutive.
-	endB=$(( $offsetB + $sizeB ))
-	if [ "$endB" != "$run_size" ] ; then
-		printf "sizeA: 0x%x\n" $sizeA >&2
-		printf "offsetA: 0x%x\n" $offsetA >&2
-		printf "sizeB: 0x%x\n" $sizeB >&2
-		printf "offsetB: 0x%x\n" $offsetB >&2
-		echo ".bss and .brk are non-contiguous" >&2
-		exit 1
-	fi
-fi
-
-printf "%d\n" $run_size
-exit 0
-- 
1.8.4.5
