From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH 1/6] x86/KASLR: make getting random long number function public
Date: Sun,  5 Aug 2018 11:21:14 +0800
Message-ID: <20180805032119.20485-2-jlee@suse.com>
References: <20180805032119.20485-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180805032119.20485-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, keyrings@vger.kernel.org, linux-integrity@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Pavel Machek <pavel@ucw.cz>, Chen Yu <yu.c.chen@intel.com>, Oliver Neukum <oneukum@suse.com>, Ryan Chen <yu.chen.surf@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

Separating the functions for getting random long number from KASLR
to x86 library, then it can be used to generate random long for
EFI root key.

Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Chen Yu <yu.c.chen@intel.com>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Ryan Chen <yu.chen.surf@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 arch/x86/boot/compressed/kaslr.c | 21 -------------
 arch/x86/boot/compressed/misc.c  | 17 ++++++++++
 arch/x86/boot/compressed/misc.h  |  6 ++++
 arch/x86/lib/kaslr.c             | 61 ++---------------------------------
 arch/x86/lib/random.c            | 68 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 93 insertions(+), 80 deletions(-)
 create mode 100644 arch/x86/lib/random.c

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index b87a7582853d..0f40d2178ebc 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -33,13 +33,11 @@
 #include "error.h"
 #include "../string.h"
 
-#include <generated/compile.h>
 #include <linux/module.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/ctype.h>
 #include <linux/efi.h>
-#include <generated/utsrelease.h>
 #include <asm/efi.h>
 
 /* Macros used by the included decompressor code below. */
@@ -57,25 +55,6 @@ extern unsigned long get_cmd_line_ptr(void);
 /* Used by PAGE_KERN* macros: */
 pteval_t __default_kernel_pte_mask __read_mostly = ~0;
 
-/* Simplified build-specific string for starting entropy. */
-static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
-
-static unsigned long rotate_xor(unsigned long hash, const void *area,
-				size_t size)
-{
-	size_t i;
-	unsigned long *ptr = (unsigned long *)area;
-
-	for (i = 0; i < size / sizeof(hash); i++) {
-		/* Rotate by odd number of bits and XOR. */
-		hash = (hash << ((sizeof(hash) * 8) - 7)) | (hash >> 7);
-		hash ^= ptr[i];
-	}
-
-	return hash;
-}
-
 /* Attempt to create a simple but unpredictable starting entropy. */
 static unsigned long get_boot_seed(void)
 {
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8dd1d5ccae58..eb0ab9cad4e4 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -426,3 +426,20 @@ void fortify_panic(const char *name)
 {
 	error("detected buffer overflow");
 }
+
+#if CONFIG_RANDOMIZE_BASE
+unsigned long rotate_xor(unsigned long hash, const void *area,
+			size_t size)
+{
+	size_t i;
+	unsigned long *ptr = (unsigned long *)area;
+
+	for (i = 0; i < size / sizeof(hash); i++) {
+		/* Rotate by odd number of bits and XOR. */
+		hash = (hash << ((sizeof(hash) * 8) - 7)) | (hash >> 7);
+		hash ^= ptr[i];
+	}
+
+	return hash;
+}
+#endif
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index a423bdb42686..957f327ad83c 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -70,6 +70,8 @@ int cmdline_find_option_bool(const char *option);
 
 
 #if CONFIG_RANDOMIZE_BASE
+#include <generated/compile.h>
+#include <generated/utsrelease.h>
 /* kaslr.c */
 void choose_random_location(unsigned long input,
 			    unsigned long input_size,
@@ -78,6 +80,10 @@ void choose_random_location(unsigned long input,
 			    unsigned long *virt_addr);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
+/* Simplified build-specific string for starting entropy. */
+static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
+		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
+unsigned long rotate_xor(unsigned long hash, const void *area, size_t size);
 #else
 static inline void choose_random_location(unsigned long input,
 					  unsigned long input_size,
diff --git a/arch/x86/lib/kaslr.c b/arch/x86/lib/kaslr.c
index 79778ab200e4..29ed9bfde5a5 100644
--- a/arch/x86/lib/kaslr.c
+++ b/arch/x86/lib/kaslr.c
@@ -26,67 +26,10 @@
 #define get_boot_seed() kaslr_offset()
 #endif
 
-#define I8254_PORT_CONTROL	0x43
-#define I8254_PORT_COUNTER0	0x40
-#define I8254_CMD_READBACK	0xC0
-#define I8254_SELECT_COUNTER0	0x02
-#define I8254_STATUS_NOTREADY	0x40
-static inline u16 i8254(void)
-{
-	u16 status, timer;
-
-	do {
-		outb(I8254_PORT_CONTROL,
-		     I8254_CMD_READBACK | I8254_SELECT_COUNTER0);
-		status = inb(I8254_PORT_COUNTER0);
-		timer  = inb(I8254_PORT_COUNTER0);
-		timer |= inb(I8254_PORT_COUNTER0) << 8;
-	} while (status & I8254_STATUS_NOTREADY);
-
-	return timer;
-}
+#include "random.c"
 
 unsigned long kaslr_get_random_long(const char *purpose)
 {
-#ifdef CONFIG_X86_64
-	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
-#else
-	const unsigned long mix_const = 0x3f39e593UL;
-#endif
-	unsigned long raw, random = get_boot_seed();
-	bool use_i8254 = true;
-
-	debug_putstr(purpose);
 	debug_putstr(" KASLR using");
-
-	if (has_cpuflag(X86_FEATURE_RDRAND)) {
-		debug_putstr(" RDRAND");
-		if (rdrand_long(&raw)) {
-			random ^= raw;
-			use_i8254 = false;
-		}
-	}
-
-	if (has_cpuflag(X86_FEATURE_TSC)) {
-		debug_putstr(" RDTSC");
-		raw = rdtsc();
-
-		random ^= raw;
-		use_i8254 = false;
-	}
-
-	if (use_i8254) {
-		debug_putstr(" i8254");
-		random ^= i8254();
-	}
-
-	/* Circular multiply for better bit diffusion */
-	asm(_ASM_MUL "%3"
-	    : "=a" (random), "=d" (raw)
-	    : "a" (random), "rm" (mix_const));
-	random += raw;
-
-	debug_putstr("...\n");
-
-	return random;
+	return get_random_long(purpose);
 }
diff --git a/arch/x86/lib/random.c b/arch/x86/lib/random.c
new file mode 100644
index 000000000000..f2fe6a784c98
--- /dev/null
+++ b/arch/x86/lib/random.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <asm/io.h>
+#include <asm/archrandom.h>
+
+#define I8254_PORT_CONTROL	0x43
+#define I8254_PORT_COUNTER0	0x40
+#define I8254_CMD_READBACK	0xC0
+#define I8254_SELECT_COUNTER0	0x02
+#define I8254_STATUS_NOTREADY	0x40
+static inline u16 i8254(void)
+{
+	u16 status, timer;
+
+	do {
+		outb(I8254_PORT_CONTROL,
+		     I8254_CMD_READBACK | I8254_SELECT_COUNTER0);
+		status = inb(I8254_PORT_COUNTER0);
+		timer  = inb(I8254_PORT_COUNTER0);
+		timer |= inb(I8254_PORT_COUNTER0) << 8;
+	} while (status & I8254_STATUS_NOTREADY);
+
+	return timer;
+}
+
+static unsigned long get_random_long(const char *purpose)
+{
+#ifdef CONFIG_X86_64
+	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
+#else
+	const unsigned long mix_const = 0x3f39e593UL;
+#endif
+	unsigned long raw, random = get_boot_seed();
+	bool use_i8254 = true;
+
+	debug_putstr(purpose);
+
+	if (has_cpuflag(X86_FEATURE_RDRAND)) {
+		debug_putstr(" RDRAND");
+		if (rdrand_long(&raw)) {
+			random ^= raw;
+			use_i8254 = false;
+		}
+	}
+
+	if (has_cpuflag(X86_FEATURE_TSC)) {
+		debug_putstr(" RDTSC");
+		raw = rdtsc();
+
+		random ^= raw;
+		use_i8254 = false;
+	}
+
+	if (use_i8254) {
+		debug_putstr(" i8254");
+		random ^= i8254();
+	}
+
+	/* Circular multiply for better bit diffusion */
+	asm(_ASM_MUL "%3"
+	    : "=a" (random), "=d" (raw)
+	    : "a" (random), "rm" (mix_const));
+	random += raw;
+
+	debug_putstr("...\n");
+
+	return random;
+}
-- 
2.13.6
