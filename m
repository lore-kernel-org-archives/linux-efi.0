From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 02/15] x86, boot: move ZO to end of buffer
Date: Wed,  4 Mar 2015 00:00:35 -0800
Message-ID: <1425456048-16236-3-git-send-email-yinghai@kernel.org>
References: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1425456048-16236-1-git-send-email-yinghai@kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-efi@vger.kernel.org

bp found data from boot stage can not be used kernel stage.

Actually those data area is overlapped with VO kernel bss stage, and clear_bss()
clear them before code in arch/x86/kernel/setup.c access them.

To make the data survive that later, we should avoid the overlapping.

At first move compressed kernel close the end of buffer instead of middle
of the buffer.

Fixes: f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/head_32.S | 11 +++++++++--
 arch/x86/boot/compressed/head_64.S |  8 ++++++--
 arch/x86/boot/compressed/mkpiggy.c |  3 ---
 arch/x86/kernel/asm-offsets.c      |  1 +
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index cbed140..a9b56f1 100644
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
@@ -208,8 +210,13 @@ relocated:
  */
 				/* push arguments for decompress_kernel: */
 	pushl	$z_output_len	/* decompressed length */
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
index 2884e0c..69015b5 100644
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
index b669ab6..652879b 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -82,9 +82,6 @@ int main(int argc, char *argv[])
 	printf("z_output_len = %lu\n", (unsigned long)olen);
 	printf(".globl z_extract_offset\n");
 	printf("z_extract_offset = 0x%lx\n", offs);
-	/* z_extract_offset_negative allows simplification of head_32.S */
-	printf(".globl z_extract_offset_negative\n");
-	printf("z_extract_offset_negative = -0x%lx\n", offs);
 
 	printf(".globl input_data, input_data_end\n");
 	printf("input_data:\n");
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
 
-- 
1.8.4.5
