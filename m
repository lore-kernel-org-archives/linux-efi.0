From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 5/7] x86, kaslr: Consolidate mem_avoid array filling
Date: Sat,  7 Mar 2015 14:07:19 -0800
Message-ID: <1425766041-6551-6-git-send-email-yinghai@kernel.org>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425766041-6551-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now ZO sit end of the buffer, we can find out where is ZO text
and data/bss etc.

[input, input+input_size) is copied compressed kernel, not the whole ZO.
[output, output+init_size) is the buffer for VO.

[input+input_size, output+init_size) is [_text, _end) for ZO.
that could be first range in mem_avoid. We don't need to guess that anymore.

That area already include heap and stack for ZO running. So we don't need
to put them into mem_avoid array.

We need to put boot_params into the mem_avoid too. As with 64bit bootloader
could put it anywhere.

Also change output_size referring to init_size, as we pass init_size instead.

Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/x86/boot/compressed/aslr.c | 29 ++++++++++++++---------------
 arch/x86/boot/compressed/misc.h |  4 ++--
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 7083c16..a279514 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -116,7 +116,7 @@ struct mem_vector {
 	unsigned long size;
 };
 
-#define MEM_AVOID_MAX 5
+#define MEM_AVOID_MAX 4
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
 
 static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
@@ -142,7 +142,7 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 }
 
 static void mem_avoid_init(unsigned long input, unsigned long input_size,
-			   unsigned long output, unsigned long output_size)
+			   unsigned long output, unsigned long init_size)
 {
 	u64 initrd_start, initrd_size;
 	u64 cmd_line, cmd_line_size;
@@ -151,10 +151,13 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 
 	/*
 	 * Avoid the region that is unsafe to overlap during
-	 * decompression (see calculations at top of misc.c).
+	 * decompression.
+	 * As we already move ZO (arch/x86/boot/compressed/vmlinux)
+	 * to the end of buffer, [input+input_size, output+init_size)
+	 * has [_text, _end) for ZO.
 	 */
-	unsafe_len = (output_size >> 12) + 32768 + 18;
-	unsafe = (unsigned long)input + input_size - unsafe_len;
+	unsafe_len = output + init_size - (input + input_size);
+	unsafe = (unsigned long)input + input_size;
 	mem_avoid[0].start = unsafe;
 	mem_avoid[0].size = unsafe_len;
 
@@ -176,13 +179,9 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
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
@@ -327,7 +326,7 @@ unsigned char *choose_kernel_location(struct boot_params *params,
 				      unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
-				      unsigned long output_size)
+				      unsigned long init_size)
 {
 	unsigned long choice = (unsigned long)output;
 	unsigned long random;
@@ -349,10 +348,10 @@ unsigned char *choose_kernel_location(struct boot_params *params,
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
-		       (unsigned long)output, output_size);
+		       (unsigned long)output, init_size);
 
 	/* Walk e820 and find a random address. */
-	random = find_random_addr(choice, output_size);
+	random = find_random_addr(choice, init_size);
 	if (!random) {
 		debug_putstr("KASLR could not find suitable E820 region...\n");
 		goto out;
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index ee3576b..23156e7 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -61,7 +61,7 @@ unsigned char *choose_kernel_location(struct boot_params *params,
 				      unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
-				      unsigned long output_size);
+				      unsigned long init_size);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 #else
@@ -70,7 +70,7 @@ unsigned char *choose_kernel_location(struct boot_params *params,
 				      unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
-				      unsigned long output_size)
+				      unsigned long init_size)
 {
 	return output;
 }
-- 
1.8.4.5
