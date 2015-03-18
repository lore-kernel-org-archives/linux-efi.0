From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 05/19] x86, kaslr: Use output_run_size
Date: Wed, 18 Mar 2015 00:28:12 -0700
Message-ID: <1426663706-23979-6-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

Now we are using output_size as parameter, actually we are passing
max(output_len, run_size).

Change it to output_run_size to make it less confusing.

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/aslr.c | 10 +++++-----
 arch/x86/boot/compressed/misc.c |  6 ++++--
 arch/x86/boot/compressed/misc.h |  4 ++--
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index da01c78..5dc1a65 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -138,7 +138,7 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 }
 
 static void mem_avoid_init(unsigned long input, unsigned long input_size,
-			   unsigned long output, unsigned long output_size)
+			   unsigned long output, unsigned long output_run_size)
 {
 	u64 initrd_start, initrd_size;
 	u64 cmd_line, cmd_line_size;
@@ -149,7 +149,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 	 * Avoid the region that is unsafe to overlap during
 	 * decompression (see calculations at top of misc.c).
 	 */
-	unsafe_len = (output_size >> 12) + 32768 + 18;
+	unsafe_len = (output_run_size >> 12) + 32768 + 18;
 	unsafe = (unsigned long)input + input_size - unsafe_len;
 	mem_avoid[0].start = unsafe;
 	mem_avoid[0].size = unsafe_len;
@@ -321,7 +321,7 @@ static void add_kaslr_setup_data(__u8 enabled)
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
-				      unsigned long output_size)
+				      unsigned long output_run_size)
 {
 	unsigned long choice = (unsigned long)output;
 	unsigned long random;
@@ -343,10 +343,10 @@ unsigned char *choose_kernel_location(unsigned char *input,
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
-		       (unsigned long)output, output_size);
+		       (unsigned long)output, output_run_size);
 
 	/* Walk e820 and find a random address. */
-	random = find_random_addr(choice, output_size);
+	random = find_random_addr(choice, output_run_size);
 	if (!random) {
 		debug_putstr("KASLR could not find suitable E820 region...\n");
 		goto out;
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 1f290cc..7ef0eed 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -375,6 +375,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 {
 	unsigned long run_size = VO__end - VO__text;
 	unsigned char *output_orig = output;
+	unsigned long output_run_size;
 
 	real_mode = rmode;
 
@@ -397,14 +398,15 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
 
+	output_run_size = output_len > run_size ? output_len : run_size;
+
 	/*
 	 * The memory hole needed for the kernel is the larger of either
 	 * the entire decompressed kernel plus relocation table, or the
 	 * entire decompressed kernel plus .bss and .brk sections.
 	 */
 	output = choose_kernel_location(input_data, input_len, output,
-					output_len > run_size ? output_len
-							      : run_size);
+					output_run_size);
 
 	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 04477d6..dec1663 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -60,7 +60,7 @@ int cmdline_find_option_bool(const char *option);
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
-				      unsigned long output_size);
+				      unsigned long output_run_size);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 #else
@@ -68,7 +68,7 @@ static inline
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
-				      unsigned long output_size)
+				      unsigned long output_run_size)
 {
 	return output;
 }
-- 
1.8.4.5
