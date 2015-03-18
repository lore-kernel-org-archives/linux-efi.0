From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 06/19] x86, kaslr: Consolidate mem_avoid array filling
Date: Wed, 18 Mar 2015 00:28:13 -0700
Message-ID: <1426663706-23979-7-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

We are going to support kaslr with 64bit above 4G, and new random output
buffer could be anywhere.

mem_avoid array is used for kaslr to search new output buffer.
Current code only track range that is after output+output_run_size.

We need to track all range not just after output+output_run_size.

Current code has first entry is extra bytes after input+input_size, and it
is according to output_run_size. Other entries are for initrd, cmdline,
and heap/stack for ZO running.

At first, check the first entry that should be in the mem_avoid array.

Now ZO sit end of the buffer always, we can find out where is ZO text
and data/bss etc.
                                                output+run_size
                                                      |
0   output               input      input+input_size  |     output+init_size
|     |                    |               |          |          |
|-----|-----------------|--|---------------|------|---|----------|
                        |                         |
               output+init_size-ZO_SIZE   output+output_size

[output, output+init_size) is the buffer for decompress.

[output, output+run_size) is for VO run size.
[output, output+output_size) is (VO (vmlinux after objcopy) plus relocs)

[output+init_size-ZO_SIZE, output+init_size) is copied ZO.
[input, input+input_size) is copied compressed (VO (vmlinux after objcopy)
plus relocs), not the ZO.

[input+input_size, output+init_size) is [_text, _end) for ZO. that could be
first range in mem_avoid.

That new first entry already include heap and stack for ZO running.  So we
don't need to put them separatedly into mem_avoid array.

Also we need to put [input, input+input_size) in mem_avoid array, ant it
is connected to first one, so merge them.

At last we need to put boot_params into the mem_avoid too. As with 64bit bootloader
could put it anywhere.

After those changes, we have all range needed to be avoided in mem_avoid array.

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/aslr.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 5dc1a65..9dab0d6 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -112,7 +112,7 @@ struct mem_vector {
 	unsigned long size;
 };
 
-#define MEM_AVOID_MAX 5
+#define MEM_AVOID_MAX 4
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
 
 static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
@@ -138,21 +138,22 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 }
 
 static void mem_avoid_init(unsigned long input, unsigned long input_size,
-			   unsigned long output, unsigned long output_run_size)
+			   unsigned long output)
 {
+	unsigned long init_size = real_mode->hdr.init_size;
 	u64 initrd_start, initrd_size;
 	u64 cmd_line, cmd_line_size;
-	unsigned long unsafe, unsafe_len;
 	char *ptr;
 
 	/*
 	 * Avoid the region that is unsafe to overlap during
-	 * decompression (see calculations at top of misc.c).
+	 * decompression.
+	 * As we already move ZO (arch/x86/boot/compressed/vmlinux)
+	 * to the end of buffer, [input+input_size, output+init_size)
+	 * has [_text, _end) for ZO.
 	 */
-	unsafe_len = (output_run_size >> 12) + 32768 + 18;
-	unsafe = (unsigned long)input + input_size - unsafe_len;
-	mem_avoid[0].start = unsafe;
-	mem_avoid[0].size = unsafe_len;
+	mem_avoid[0].start = input;
+	mem_avoid[0].size = (output + init_size) - input;
 
 	/* Avoid initrd. */
 	initrd_start  = (u64)real_mode->ext_ramdisk_image << 32;
@@ -172,13 +173,9 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	mem_avoid[2].start = cmd_line;
 	mem_avoid[2].size = cmd_line_size;
 
-	/* Avoid heap memory. */
-	mem_avoid[3].start = (unsigned long)free_mem_ptr;
-	mem_avoid[3].size = BOOT_HEAP_SIZE;
-
-	/* Avoid stack memory. */
-	mem_avoid[4].start = (unsigned long)free_mem_end_ptr;
-	mem_avoid[4].size = BOOT_STACK_SIZE;
+	/* Avoid params */
+	mem_avoid[3].start = (unsigned long)real_mode;
+	mem_avoid[3].size = sizeof(*real_mode);
 }
 
 /* Does this memory vector overlap a known avoided area? */
@@ -343,7 +340,7 @@ unsigned char *choose_kernel_location(unsigned char *input,
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
-		       (unsigned long)output, output_run_size);
+		       (unsigned long)output);
 
 	/* Walk e820 and find a random address. */
 	random = find_random_addr(choice, output_run_size);
-- 
1.8.4.5
