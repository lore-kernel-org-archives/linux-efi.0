From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 16/19] x86, kaslr: Randomize physical and virtual address of kernel separately
Date: Wed, 18 Mar 2015 00:28:23 -0700
Message-ID: <1426663706-23979-17-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On x86_64, in old kaslr implementaion only physical address of kernel
loading is randomized. Then calculate the delta of physical address
where vmlinux was linked to load and where it is finally loaded. If
delta is not equal to 0, namely there's a new physical address where
kernel is actually decompressed, relocation handling need be done. Then
delta is added to offset of kernel symbol relocation, this makes the
address of kernel text mapping move delta long.

Here the behavior is changed. Randomize both the physical address
where kernel is decompressed and the virtual address where kernel text
is mapped. And relocation handling only depends on virtual address
randomization. Means if and only if virtual address is randomized to
a different value, we add the delta to the offset of kernel relocs.

Note that up to now both virtual offset and physical addr randomization
cann't exceed CONFIG_RANDOMIZE_BASE_MAX_OFFSET, namely 1G.

Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/boot/compressed/aslr.c | 46 +++++++++++++++++++++--------------------
 arch/x86/boot/compressed/misc.c | 39 ++++++++++++++++++++--------------
 arch/x86/boot/compressed/misc.h | 19 +++++++++--------
 3 files changed, 58 insertions(+), 46 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 5114142..ae0aed9 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -352,7 +352,7 @@ static void process_e820_entry(struct e820entry *entry,
 	}
 }
 
-static unsigned long find_random_addr(unsigned long minimum,
+static unsigned long find_random_phy_addr(unsigned long minimum,
 				      unsigned long size)
 {
 	int i;
@@ -410,48 +410,50 @@ static void add_kaslr_setup_data(__u8 enabled)
 		real_mode->hdr.setup_data = (unsigned long)&kaslr_setup_data;
 }
 
-unsigned char *choose_kernel_location(unsigned char *input,
-				      unsigned long input_size,
-				      unsigned char *output,
-				      unsigned long output_run_size)
+void choose_kernel_location(unsigned char *input,
+				unsigned long input_size,
+				unsigned char **output,
+				unsigned long output_run_size,
+				unsigned char **virt_offset)
 {
-	unsigned long choice = (unsigned long)output;
 	unsigned long random;
+	*virt_offset = (unsigned char *)LOAD_PHYSICAL_ADDR;
 
 #ifdef CONFIG_HIBERNATION
 	if (!cmdline_find_option_bool("kaslr")) {
 		debug_putstr("KASLR disabled by default...\n");
 		add_kaslr_setup_data(0);
-		goto out;
+		return;
 	}
 #else
 	if (cmdline_find_option_bool("nokaslr")) {
 		debug_putstr("KASLR disabled by cmdline...\n");
 		add_kaslr_setup_data(0);
-		goto out;
+		return;
 	}
 #endif
 	add_kaslr_setup_data(1);
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
-		       (unsigned long)output);
+		       (unsigned long)*output);
 
 	/* Walk e820 and find a random address. */
-	random = find_random_addr(choice, output_run_size);
-	if (!random) {
+	random = find_random_phy_addr((unsigned long)*output, output_run_size);
+	if (!random)
 		debug_putstr("KASLR could not find suitable E820 region...\n");
-		goto out;
+	else {
+		if ((unsigned long)*output != random) {
+			fill_pagetable(random, output_run_size);
+			switch_pagetable();
+			*output = (unsigned char *)random;
+		}
 	}
 
-	/* Always enforce the minimum. */
-	if (random < choice)
-		goto out;
-
-	choice = random;
-
-	fill_pagetable(choice, output_run_size);
-	switch_pagetable();
-out:
-	return (unsigned char *)choice;
+	/*
+	 * Get a random address between LOAD_PHYSICAL_ADDR and
+	 * CONFIG_RANDOMIZE_BASE_MAX_OFFSET
+	 */
+	random = find_random_virt_offset(LOAD_PHYSICAL_ADDR, output_run_size);
+	*virt_offset = (unsigned char *)random;
 }
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index d6b4d91..03fa414 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -226,7 +226,8 @@ void error(char *x)
 }
 
 #if CONFIG_X86_NEED_RELOCS
-static void handle_relocations(void *output, unsigned long output_len)
+static void handle_relocations(void *output, unsigned long output_len,
+			       void *virt_offset)
 {
 	int *reloc;
 	unsigned long delta, map, ptr;
@@ -238,11 +239,6 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 * and where it was actually loaded.
 	 */
 	delta = min_addr - LOAD_PHYSICAL_ADDR;
-	if (!delta) {
-		debug_putstr("No relocation needed... ");
-		return;
-	}
-	debug_putstr("Performing relocations... ");
 
 	/*
 	 * The kernel contains a table of relocation addresses. Those
@@ -253,6 +249,22 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 */
 	map = delta - __START_KERNEL_map;
 
+
+
+	/*
+	 * 32-bit always performs relocations. 64-bit relocations are only
+	 * needed if kASLR has chosen a different starting address offset
+	 * from __START_KERNEL_map.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64))
+		delta = (unsigned long)virt_offset - LOAD_PHYSICAL_ADDR;
+
+	if (!delta) {
+		debug_putstr("No relocation needed... ");
+		return;
+	}
+	debug_putstr("Performing relocations... ");
+
 	/*
 	 * Process relocations: 32 bit relocations first then 64 bit after.
 	 * Three sets of binary relocations are added to the end of the kernel
@@ -306,7 +318,8 @@ static void handle_relocations(void *output, unsigned long output_len)
 #endif
 }
 #else
-static inline void handle_relocations(void *output, unsigned long output_len)
+static inline void handle_relocations(void *output, unsigned long output_len,
+				      void *virt_offset)
 { }
 #endif
 
@@ -373,6 +386,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	unsigned long run_size = VO__end - VO__text;
 	unsigned char *output_orig = output;
 	unsigned long output_run_size;
+	unsigned char *virt_offset;
 
 	real_mode = rmode;
 
@@ -402,8 +416,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	 * the entire decompressed kernel plus relocation table, or the
 	 * entire decompressed kernel plus .bss and .brk sections.
 	 */
-	output = choose_kernel_location(input_data, input_len, output,
-					output_run_size);
+	choose_kernel_location(input_data, input_len, &output,
+			       output_run_size, &virt_offset);
 
 	/* Validate memory location choices. */
 	if ((unsigned long)output & (MIN_KERNEL_ALIGN - 1))
@@ -423,12 +437,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	/*
-	 * 32-bit always performs relocations. 64-bit relocations are only
-	 * needed if kASLR has chosen a different load address.
-	 */
-	if (!IS_ENABLED(CONFIG_X86_64) || output != output_orig)
-		handle_relocations(output, output_len);
+	handle_relocations(output, output_len, virt_offset);
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index a7f3826..461f20b 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -59,20 +59,21 @@ int cmdline_find_option_bool(const char *option);
 
 #if CONFIG_RANDOMIZE_BASE
 /* aslr.c */
-unsigned char *choose_kernel_location(unsigned char *input,
-				      unsigned long input_size,
-				      unsigned char *output,
-				      unsigned long output_run_size);
+void choose_kernel_location(unsigned char *input,
+				unsigned long input_size,
+				unsigned char **output,
+				unsigned long output_run_size,
+				unsigned char **virt_offset);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 #else
 static inline
-unsigned char *choose_kernel_location(unsigned char *input,
-				      unsigned long input_size,
-				      unsigned char *output,
-				      unsigned long output_run_size)
+void choose_kernel_location(unsigned char *input,
+				unsigned long input_size,
+				unsigned char **output,
+				unsigned long output_run_size,
+				unsigned char **virt_offset)
 {
-	return output;
 }
 #endif
 
-- 
1.8.4.5
