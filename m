From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 02/19] x86, kaslr: Propagate base load address calculation v2
Date: Wed, 18 Mar 2015 00:28:09 -0700
Message-ID: <1426663706-23979-3-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jiri Kosina <jkosina@suse.cz>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit f47233c2d34f ("x86/mm/ASLR: Propagate base load address calculation")
got reverted for v4.0, This is second try after patch (x86, boot: Make
data from decompress_kernel stage live longer) that save the data
for later accessing. Following changelog is from v1 commit.

Commit:

      e2b32e678513 ("x86, kaslr: randomize module base load address")

makes the base address for module to be unconditionally randomized in
case when CONFIG_RANDOMIZE_BASE is defined and "nokaslr" option isn't
present on the commandline.

This is not consistent with how choose_kernel_location() decides whether
it will randomize kernel load base.

Namely, CONFIG_HIBERNATION disables kASLR (unless "kaslr" option is
explicitly specified on kernel commandline), which makes the state space
larger than what module loader is looking at. IOW CONFIG_HIBERNATION &&
CONFIG_RANDOMIZE_BASE is a valid config option, kASLR wouldn't be applied
by default in that case, but module loader is not aware of that.

Instead of fixing the logic in module.c, this patch takes more generic
aproach. It introduces a new bootparam setup data_type SETUP_KASLR and
uses that to pass the information whether kaslr has been applied during
kernel decompression, and sets a global 'kaslr_enabled' variable
accordingly, so that any kernel code (module loading, livepatching, ...)
can make decisions based on its value.

x86 module loader is converted to make use of this flag.

[ Always dump correct kaslr status when panicking from Boris]

-v2: fold in fix for using physical address as value  -- Yinghai
     split struct kaslr_setup_data definition to another file -- Yinghai
     use real_mode directly instead of passing it around -- Yinghai

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/boot/compressed/aslr.c       | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/aslr.h           | 10 ++++++++++
 arch/x86/include/asm/page_types.h     |  2 ++
 arch/x86/include/uapi/asm/bootparam.h |  1 +
 arch/x86/kernel/module.c              | 10 +---------
 arch/x86/kernel/setup.c               | 27 +++++++++++++++++++++++----
 6 files changed, 63 insertions(+), 13 deletions(-)
 create mode 100644 arch/x86/include/asm/aslr.h

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index bb13763..da01c78 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -3,6 +3,7 @@
 #include <asm/msr.h>
 #include <asm/archrandom.h>
 #include <asm/e820.h>
+#include <asm/aslr.h>
 
 #include <generated/compile.h>
 #include <linux/module.h>
@@ -14,6 +15,8 @@
 static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
 
+static struct kaslr_setup_data kaslr_setup_data;
+
 #define I8254_PORT_CONTROL	0x43
 #define I8254_PORT_COUNTER0	0x40
 #define I8254_CMD_READBACK	0xC0
@@ -295,6 +298,26 @@ static unsigned long find_random_addr(unsigned long minimum,
 	return slots_fetch_random();
 }
 
+static void add_kaslr_setup_data(__u8 enabled)
+{
+	struct setup_data *data;
+
+	kaslr_setup_data.type = SETUP_KASLR;
+	kaslr_setup_data.len = 1;
+	kaslr_setup_data.next = 0;
+	kaslr_setup_data.data[0] = enabled;
+
+	data = (struct setup_data *)(unsigned long)real_mode->hdr.setup_data;
+
+	while (data && data->next)
+		data = (struct setup_data *)(unsigned long)data->next;
+
+	if (data)
+		data->next = (unsigned long)&kaslr_setup_data;
+	else
+		real_mode->hdr.setup_data = (unsigned long)&kaslr_setup_data;
+}
+
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
@@ -306,14 +329,17 @@ unsigned char *choose_kernel_location(unsigned char *input,
 #ifdef CONFIG_HIBERNATION
 	if (!cmdline_find_option_bool("kaslr")) {
 		debug_putstr("KASLR disabled by default...\n");
+		add_kaslr_setup_data(0);
 		goto out;
 	}
 #else
 	if (cmdline_find_option_bool("nokaslr")) {
 		debug_putstr("KASLR disabled by cmdline...\n");
+		add_kaslr_setup_data(0);
 		goto out;
 	}
 #endif
+	add_kaslr_setup_data(1);
 
 	/* Record the various known unsafe memory ranges. */
 	mem_avoid_init((unsigned long)input, input_size,
diff --git a/arch/x86/include/asm/aslr.h b/arch/x86/include/asm/aslr.h
new file mode 100644
index 0000000..461a819
--- /dev/null
+++ b/arch/x86/include/asm/aslr.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_X86_ASLR_H
+
+struct kaslr_setup_data {
+	__u64 next;
+	__u32 type;
+	__u32 len;
+	__u8 data[1];
+};
+
+#endif
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index f97fbe3..95e11f7 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -51,6 +51,8 @@ extern int devmem_is_allowed(unsigned long pagenr);
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+extern bool kaslr_enabled;
+
 static inline phys_addr_t get_max_mapped(void)
 {
 	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 225b098..44e6dd7 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -7,6 +7,7 @@
 #define SETUP_DTB			2
 #define SETUP_PCI			3
 #define SETUP_EFI			4
+#define SETUP_KASLR			5
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index d1ac80b..9bbb9b3 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -47,21 +47,13 @@ do {							\
 
 #ifdef CONFIG_RANDOMIZE_BASE
 static unsigned long module_load_offset;
-static int randomize_modules = 1;
 
 /* Mutex protects the module_load_offset. */
 static DEFINE_MUTEX(module_kaslr_mutex);
 
-static int __init parse_nokaslr(char *p)
-{
-	randomize_modules = 0;
-	return 0;
-}
-early_param("nokaslr", parse_nokaslr);
-
 static unsigned long int get_module_load_offset(void)
 {
-	if (randomize_modules) {
+	if (kaslr_enabled) {
 		mutex_lock(&module_kaslr_mutex);
 		/*
 		 * Calculate the module_load_offset the first time this
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0a2421c..3b3f54c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -78,6 +78,7 @@
 #include <asm/e820.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
+#include <asm/aslr.h>
 #include <asm/efi.h>
 #include <asm/timer.h>
 #include <asm/i8259.h>
@@ -122,6 +123,8 @@
 unsigned long max_low_pfn_mapped;
 unsigned long max_pfn_mapped;
 
+bool __read_mostly kaslr_enabled = false;
+
 #ifdef CONFIG_DMI
 RESERVE_BRK(dmi_alloc, 65536);
 #endif
@@ -425,6 +428,15 @@ static void __init reserve_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+static void __init parse_kaslr_setup(u64 pa_data, u32 data_len)
+{
+	struct kaslr_setup_data *data;
+
+	data = early_memremap(pa_data, sizeof(*data));
+	kaslr_enabled = data->data[0];
+	early_memunmap(data, sizeof(*data));
+}
+
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
@@ -450,6 +462,9 @@ static void __init parse_setup_data(void)
 		case SETUP_EFI:
 			parse_efi_setup(pa_data, data_len);
 			break;
+		case SETUP_KASLR:
+			parse_kaslr_setup(pa_data, data_len);
+			break;
 		default:
 			break;
 		}
@@ -832,10 +847,14 @@ static void __init trim_low_memory_range(void)
 static int
 dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
 {
-	pr_emerg("Kernel Offset: 0x%lx from 0x%lx "
-		 "(relocation range: 0x%lx-0x%lx)\n",
-		 (unsigned long)&_text - __START_KERNEL, __START_KERNEL,
-		 __START_KERNEL_map, MODULES_VADDR-1);
+	if (kaslr_enabled)
+		pr_emerg("Kernel Offset: 0x%lx from 0x%lx (relocation range: 0x%lx-0x%lx)\n",
+			 (unsigned long)&_text - __START_KERNEL,
+			 __START_KERNEL,
+			 __START_KERNEL_map,
+			 MODULES_VADDR-1);
+	else
+		pr_emerg("Kernel Offset: disabled\n");
 
 	return 0;
 }
-- 
1.8.4.5
