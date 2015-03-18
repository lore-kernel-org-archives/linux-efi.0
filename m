From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 04/19] x86, kaslr: Kill not used run_size related code.
Date: Wed, 18 Mar 2015 00:28:11 -0700
Message-ID: <1426663706-23979-5-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Junjie Mao <eternal.n08@gmail.com>
List-Id: linux-efi@vger.kernel.org

We use simple version to get run_size now, remove old run_size related code.

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
 arch/x86/boot/compressed/head_32.S |  3 +--
 arch/x86/boot/compressed/head_64.S |  3 ---
 arch/x86/boot/compressed/misc.c    |  6 ++----
 arch/x86/boot/compressed/mkpiggy.c |  9 ++------
 arch/x86/tools/calc_run_size.sh    | 42 --------------------------------------
 6 files changed, 6 insertions(+), 61 deletions(-)
 delete mode 100644 arch/x86/tools/calc_run_size.sh

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index d9fee82..50daea7 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -104,10 +104,8 @@ suffix-$(CONFIG_KERNEL_XZ)	:= xz
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
index 1410c42..673bfcf 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -209,7 +209,6 @@ relocated:
  * Do the decompression, and jump to the new kernel..
  */
 				/* push arguments for decompress_kernel: */
-	pushl	$z_run_size	/* size of kernel with .bss and .brk */
 	pushl	$z_output_len	/* decompressed length, end of relocs */
 
 	movl    BP_init_size(%esi), %eax
@@ -225,7 +224,7 @@ relocated:
 	pushl	%eax		/* heap area */
 	pushl	%esi		/* real mode pointer */
 	call	decompress_kernel /* returns kernel location in %eax */
-	addl	$28, %esp
+	addl	$24, %esp
 
 /*
  * Jump to the decompressed kernel.
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 4e30ee3..2678f03 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -406,8 +406,6 @@ relocated:
  * Do the decompression, and jump to the new kernel..
  */
 	pushq	%rsi			/* Save the real mode argument */
-	movq	$z_run_size, %r9	/* size of kernel with .bss and .brk */
-	pushq	%r9
 	movq	%rsi, %rdi		/* real mode address */
 	leaq	boot_heap(%rip), %rsi	/* malloc area for uncompression */
 	leaq	input_data(%rip), %rdx  /* input_data */
@@ -415,7 +413,6 @@ relocated:
 	movq	%rbp, %r8		/* output target address */
 	movq	$z_output_len, %r9	/* decompressed length, end of relocs */
 	call	decompress_kernel	/* returns kernel location in %rax */
-	popq	%r9
 	popq	%rsi
 
 /*
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 4785c23..1f290cc 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -371,9 +371,9 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *input_data,
 				  unsigned long input_len,
 				  unsigned char *output,
-				  unsigned long output_len,
-				  unsigned long run_size)
+				  unsigned long output_len)
 {
+	unsigned long run_size = VO__end - VO__text;
 	unsigned char *output_orig = output;
 
 	real_mode = rmode;
@@ -391,8 +391,6 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	lines = real_mode->screen_info.orig_video_lines;
 	cols = real_mode->screen_info.orig_video_cols;
 
-	run_size = VO__end - VO__text;
-
 	console_init();
 	debug_putstr("early console in decompress_kernel\n");
 
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 5faad09..c03b009 100644
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
@@ -85,8 +82,6 @@ int main(int argc, char *argv[])
 	printf("z_output_len = %lu\n", (unsigned long)olen);
 	printf(".globl z_min_extract_offset\n");
 	printf("z_min_extract_offset = 0x%lx\n", offs);
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
