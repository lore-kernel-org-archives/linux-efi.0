From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [RFC PATCH 03/16] x86/boot: Public getting random boot function
Date: Thu, 16 Jul 2015 22:25:17 +0800
Message-ID: <1437056730-15247-4-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

This patch moves the getting random boot function from aslr to misc
for later used by EFI stub to generate the first entropy of hmac key
for signing hibernate snapshot image.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/aslr.c | 55 +----------------------------------------
 arch/x86/boot/compressed/misc.c | 55 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.h |  4 +++
 3 files changed, 60 insertions(+), 54 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index d7b1f65..bd6550a 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -6,59 +6,6 @@
 
 #include <generated/compile.h>
 #include <linux/module.h>
-#include <linux/uts.h>
-#include <linux/utsname.h>
-#include <generated/utsrelease.h>
-
-/* Simplified build-specific string for starting entropy. */
-static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
-
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
-/* Attempt to create a simple but unpredictable starting entropy. */
-static unsigned long get_random_boot(void)
-{
-	unsigned long hash = 0;
-
-	hash = rotate_xor(hash, build_str, sizeof(build_str));
-	hash = rotate_xor(hash, real_mode, sizeof(*real_mode));
-
-	return hash;
-}
 
 static unsigned long get_random_long(void)
 {
@@ -67,7 +14,7 @@ static unsigned long get_random_long(void)
 #else
 	const unsigned long mix_const = 0x3f39e593UL;
 #endif
-	unsigned long raw, random = get_random_boot();
+	unsigned long raw, random = get_random_boot(real_mode);
 	bool use_i8254 = true;
 
 	debug_putstr("KASLR using");
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index a107b93..d929506 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -12,6 +12,9 @@
 #include "misc.h"
 #include "../string.h"
 
+#include <generated/compile.h>
+#include <generated/utsrelease.h>
+
 /* WARNING!!
  * This code is compiled with -fPIC and it is relocated dynamically
  * at run time, but no relocation processing is performed.
@@ -435,3 +438,55 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }
+
+#if CONFIG_RANDOMIZE_BASE
+#define I8254_PORT_CONTROL	0x43
+#define I8254_PORT_COUNTER0	0x40
+#define I8254_CMD_READBACK	0xC0
+#define I8254_SELECT_COUNTER0	0x02
+#define I8254_STATUS_NOTREADY	0x40
+u16 i8254(void)
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
+static unsigned long rotate_xor(unsigned long hash, const void *area,
+				size_t size)
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
+
+/* Simplified build-specific string for starting entropy. */
+static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
+		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
+
+/* Attempt to create a simple but unpredictable starting entropy. */
+unsigned long get_random_boot(struct boot_params *boot_params)
+{
+	unsigned long hash = 0;
+
+	hash = rotate_xor(hash, build_str, sizeof(build_str));
+	hash = rotate_xor(hash, boot_params, sizeof(*boot_params));
+
+	return hash;
+}
+#endif /* CONFIG_RANDOMIZE_BASE */
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 805d25c..e10908c 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -53,6 +53,10 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
 #endif
 
+#if CONFIG_RANDOMIZE_BASE
+extern u16 i8254(void);
+extern unsigned long get_random_boot(struct boot_params *boot_params);
+#endif
 
 #if CONFIG_RANDOMIZE_BASE
 /* aslr.c */
-- 
1.8.4.5
