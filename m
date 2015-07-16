From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [RFC PATCH 04/16] x86/efi: Generating random number in EFI stub
Date: Thu, 16 Jul 2015 22:25:18 +0800
Message-ID: <1437056730-15247-5-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

This patch adds the codes for generating random number array as the
HMAC key that will used by later EFI stub codes.

The original codes in efi_random copied from aslr and add the codes
to accept input entropy and EFI debugging. In later patch will add
the codes to get random number by EFI protocol. The separate codes
can avoid impacting aslr function.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/Makefile     |  1 +
 arch/x86/boot/compressed/efi_random.c | 88 +++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.c       |  4 +-
 arch/x86/boot/compressed/misc.h       |  2 +-
 4 files changed, 92 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/boot/compressed/efi_random.c

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0a291cd..377245b 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -49,6 +49,7 @@ vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/aslr.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
+vmlinux-objs-$(CONFIG_HIBERNATE_VERIFICATION) += $(obj)/efi_random.o
 vmlinux-objs-$(CONFIG_EFI_STUB) += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
 	$(objtree)/drivers/firmware/efi/libstub/lib.a
 vmlinux-objs-$(CONFIG_EFI_MIXED) += $(obj)/efi_thunk_$(BITS).o
diff --git a/arch/x86/boot/compressed/efi_random.c b/arch/x86/boot/compressed/efi_random.c
new file mode 100644
index 0000000..bdb2d46
--- /dev/null
+++ b/arch/x86/boot/compressed/efi_random.c
@@ -0,0 +1,88 @@
+#include "misc.h"
+
+#include <linux/efi.h>
+#include <asm/archrandom.h>
+
+#define X86_FEATURE_EDX_TSC	(1 << 4)
+#define X86_FEATURE_ECX_RDRAND	(1 << 30)
+
+static bool rdrand_feature(void)
+{
+	return (cpuid_ecx(0x1) & X86_FEATURE_ECX_RDRAND);
+}
+
+static bool rdtsc_feature(void)
+{
+	return (cpuid_edx(0x1) & X86_FEATURE_EDX_TSC);
+}
+
+static unsigned long get_random_long(unsigned long entropy,
+				     struct boot_params *boot_params,
+				     efi_system_table_t *sys_table)
+{
+#ifdef CONFIG_X86_64
+	const unsigned long mix_const = 0x5d6008cbf3848dd3UL;
+#else
+	const unsigned long mix_const = 0x3f39e593UL;
+#endif
+	unsigned long raw, random;
+	bool use_i8254 = true;
+
+	efi_printk(sys_table, " EFI random");
+
+	if (entropy)
+		random = entropy;
+	else
+		random = get_random_boot(boot_params);
+
+	if (rdrand_feature()) {
+		efi_printk(sys_table, " RDRAND");
+		if (rdrand_long(&raw)) {
+			random ^= raw;
+			use_i8254 = false;
+		}
+	}
+
+	if (rdtsc_feature()) {
+		efi_printk(sys_table, " RDTSC");
+		rdtscll(raw);
+
+		random ^= raw;
+		use_i8254 = false;
+	}
+
+	if (use_i8254) {
+		efi_printk(sys_table, " i8254");
+		random ^= i8254();
+	}
+
+	/* Circular multiply for better bit diffusion */
+	asm("mul %3"
+	    : "=a" (random), "=d" (raw)
+	    : "a" (random), "rm" (mix_const));
+	random += raw;
+
+	efi_printk(sys_table, "...\n");
+
+	return random;
+}
+
+void efi_get_random_key(efi_system_table_t *sys_table,
+			struct boot_params *params, u8 key[], int size)
+{
+	unsigned long entropy = 0;
+	int i, bfill = size;
+
+	if (key == NULL || !size)
+		return;
+
+	memset(key, 0, size);
+	while (bfill > 0) {
+		entropy = get_random_long(entropy, params, sys_table);
+		if (bfill >= sizeof(entropy))
+			memcpy((void *)(key + size - bfill), &entropy, sizeof(entropy));
+		else
+			memcpy((void *)(key + size - bfill), &entropy, bfill);
+		bfill -= sizeof(entropy);
+	}
+}
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index d929506..2c3c997 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -439,7 +439,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	return output;
 }
 
-#if CONFIG_RANDOMIZE_BASE
+#if CONFIG_HIBERNATE_VERIFICATION || CONFIG_RANDOMIZE_BASE
 #define I8254_PORT_CONTROL	0x43
 #define I8254_PORT_COUNTER0	0x40
 #define I8254_CMD_READBACK	0xC0
@@ -489,4 +489,4 @@ unsigned long get_random_boot(struct boot_params *boot_params)
 
 	return hash;
 }
-#endif /* CONFIG_RANDOMIZE_BASE */
+#endif /* CONFIG_HIBERNATE_VERIFICATION || CONFIG_RANDOMIZE_BASE */
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index e10908c..4be2780 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -53,7 +53,7 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
 #endif
 
-#if CONFIG_RANDOMIZE_BASE
+#if CONFIG_HIBERNATE_VERIFICATION || CONFIG_RANDOMIZE_BASE
 extern u16 i8254(void);
 extern unsigned long get_random_boot(struct boot_params *boot_params);
 #endif
-- 
1.8.4.5
