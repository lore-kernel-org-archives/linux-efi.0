From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] Revert "x86/mm/ASLR: Propagate base load address calculation"
Date: Mon, 16 Mar 2015 11:06:28 +0100
Message-ID: <20150316100628.GD22995@pd.tnic>
References: <1425766041-6551-1-git-send-email-yinghai@kernel.org>
 <1425766041-6551-2-git-send-email-yinghai@kernel.org>
 <20150313122756.GA28855@gmail.com>
 <CAE9FiQXaRmJFdEUhyn2q0v=9ymdbqZWEo1pzo6iyaNupWEp5Xg@mail.gmail.com>
 <20150314075357.GA8319@gmail.com>
 <20150314095923.GA3114@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150314095923.GA3114-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Junjie Mao <eternal.n08-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Mar 14, 2015 at 10:59:23AM +0100, Borislav Petkov wrote:
> In addition to what you've said, I have only one proposal: we revert
> the whole crap and do it again, this time nice and clean in tip. It'll
> stay there as long as it has to. No half-arsed commit messages, no
> misunderstood crap, no lala code f*ckery. Whatever it takes, as long as
> it takes.

And here it is:

---
From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Date: Mon, 16 Mar 2015 10:57:56 +0100
Subject: [PATCH] Revert "x86/mm/ASLR: Propagate base load address calculation"

This reverts commit f47233c2d34f243ecdaac179c3408a39ff9216a7.

The main reason for the revert is that in order to make this work, we
need non-trivial changes to the x86 boot code which we didn't manage to
get done in time for merging.

And even if we did, they would've been too risky so instead of rushing
things and break booting 4.1 on boxes left and right, we will be very
strict and conservative and will take our time with this to fix and test
it properly.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 arch/x86/boot/compressed/aslr.c       | 34 +---------------------------------
 arch/x86/boot/compressed/misc.c       |  3 +--
 arch/x86/boot/compressed/misc.h       |  6 ++----
 arch/x86/include/asm/page_types.h     |  2 --
 arch/x86/include/uapi/asm/bootparam.h |  1 -
 arch/x86/kernel/module.c              | 10 +++++++++-
 arch/x86/kernel/setup.c               | 22 ++++------------------
 7 files changed, 17 insertions(+), 61 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 7083c16cccba..bb1376381985 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -14,13 +14,6 @@
 static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
 
-struct kaslr_setup_data {
-	__u64 next;
-	__u32 type;
-	__u32 len;
-	__u8 data[1];
-} kaslr_setup_data;
-
 #define I8254_PORT_CONTROL	0x43
 #define I8254_PORT_COUNTER0	0x40
 #define I8254_CMD_READBACK	0xC0
@@ -302,29 +295,7 @@ static unsigned long find_random_addr(unsigned long minimum,
 	return slots_fetch_random();
 }
 
-static void add_kaslr_setup_data(struct boot_params *params, __u8 enabled)
-{
-	struct setup_data *data;
-
-	kaslr_setup_data.type = SETUP_KASLR;
-	kaslr_setup_data.len = 1;
-	kaslr_setup_data.next = 0;
-	kaslr_setup_data.data[0] = enabled;
-
-	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
-
-	while (data && data->next)
-		data = (struct setup_data *)(unsigned long)data->next;
-
-	if (data)
-		data->next = (unsigned long)&kaslr_setup_data;
-	else
-		params->hdr.setup_data = (unsigned long)&kaslr_setup_data;
-
-}
-
-unsigned char *choose_kernel_location(struct boot_params *params,
-				      unsigned char *input,
+unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
 				      unsigned long output_size)
@@ -335,17 +306,14 @@ unsigned char *choose_kernel_location(struct boot_params *params,
 #ifdef CONFIG_HIBERNATION
 	if (!cmdline_find_option_bool("kaslr")) {
 		debug_putstr("KASLR disabled by default...\n");
-		add_kaslr_setup_data(params, 0);
 		goto out;
 	}
 #else
 	if (cmdline_find_option_bool("nokaslr")) {
 		debug_putstr("KASLR disabled by cmdline...\n");
-		add_kaslr_setup_data(params, 0);
 		goto out;
 	}
 #endif
-	add_kaslr_setup_data(params, 1);
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 5903089c818f..a950864a64da 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -401,8 +401,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	 * the entire decompressed kernel plus relocation table, or the
 	 * entire decompressed kernel plus .bss and .brk sections.
 	 */
-	output = choose_kernel_location(real_mode, input_data, input_len,
-					output,
+	output = choose_kernel_location(input_data, input_len, output,
 					output_len > run_size ? output_len
 							      : run_size);
 
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index ee3576b2666b..04477d68403f 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -57,8 +57,7 @@ int cmdline_find_option_bool(const char *option);
 
 #if CONFIG_RANDOMIZE_BASE
 /* aslr.c */
-unsigned char *choose_kernel_location(struct boot_params *params,
-				      unsigned char *input,
+unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
 				      unsigned long output_size);
@@ -66,8 +65,7 @@ unsigned char *choose_kernel_location(struct boot_params *params,
 bool has_cpuflag(int flag);
 #else
 static inline
-unsigned char *choose_kernel_location(struct boot_params *params,
-				      unsigned char *input,
+unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
 				      unsigned long output_size)
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 95e11f79f123..f97fbe3abb67 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -51,8 +51,6 @@ extern int devmem_is_allowed(unsigned long pagenr);
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
-extern bool kaslr_enabled;
-
 static inline phys_addr_t get_max_mapped(void)
 {
 	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 44e6dd7e36a2..225b0988043a 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -7,7 +7,6 @@
 #define SETUP_DTB			2
 #define SETUP_PCI			3
 #define SETUP_EFI			4
-#define SETUP_KASLR			5
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 9bbb9b35c144..d1ac80b72c72 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -47,13 +47,21 @@ do {							\
 
 #ifdef CONFIG_RANDOMIZE_BASE
 static unsigned long module_load_offset;
+static int randomize_modules = 1;
 
 /* Mutex protects the module_load_offset. */
 static DEFINE_MUTEX(module_kaslr_mutex);
 
+static int __init parse_nokaslr(char *p)
+{
+	randomize_modules = 0;
+	return 0;
+}
+early_param("nokaslr", parse_nokaslr);
+
 static unsigned long int get_module_load_offset(void)
 {
-	if (kaslr_enabled) {
+	if (randomize_modules) {
 		mutex_lock(&module_kaslr_mutex);
 		/*
 		 * Calculate the module_load_offset the first time this
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 98dc9317286e..0a2421cca01f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -122,8 +122,6 @@
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
-bool __read_mostly kaslr_enabled = false;
-
 #ifdef CONFIG_DMI
 RESERVE_BRK(dmi_alloc, 65536);
 #endif
@@ -427,11 +425,6 @@ static void __init reserve_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
-{
-	kaslr_enabled = (bool)(pa_data + sizeof(struct setup_data));
-}
-
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
@@ -457,9 +450,6 @@ static void __init parse_setup_data(void)
 		case SETUP_EFI:
 			parse_efi_setup(pa_data, data_len);
 			break;
-		case SETUP_KASLR:
-			parse_kaslr_setup(pa_data, data_len);
-			break;
 		default:
 			break;
 		}
@@ -842,14 +832,10 @@ static void __init trim_low_memory_range(void)
 static int
 dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
 {
-	if (kaslr_enabled)
-		pr_emerg("Kernel Offset: 0x%lx from 0x%lx (relocation range: 0x%lx-0x%lx)\n",
-			 (unsigned long)&_text - __START_KERNEL,
-			 __START_KERNEL,
-			 __START_KERNEL_map,
-			 MODULES_VADDR-1);
-	else
-		pr_emerg("Kernel Offset: disabled\n");
+	pr_emerg("Kernel Offset: 0x%lx from 0x%lx "
+		 "(relocation range: 0x%lx-0x%lx)\n",
+		 (unsigned long)&_text - __START_KERNEL, __START_KERNEL,
+		 __START_KERNEL_map, MODULES_VADDR-1);
 
 	return 0;
 }
-- 
2.3.3


-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
