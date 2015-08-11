From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 04/16] x86/efi: Generating random number in EFI stub
Date: Tue, 11 Aug 2015 14:16:24 +0800
Message-ID: <1439273796-25359-5-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

This patch adds the codes for generating random number array as the
HMAC key that will used by later EFI stub codes.

The original codes in efi_random copied from aslr and add the codes
to accept input entropy and EFI debugging. In later patch will add
the codes to get random number by EFI protocol. The separate codes
can avoid impacting aslr function.

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/Makefile     |  1 +
 arch/x86/boot/compressed/efi_random.c | 80 +++++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.c       |  4 +-
 arch/x86/boot/compressed/misc.h       |  2 +-
 4 files changed, 84 insertions(+), 3 deletions(-)
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
index 0000000..a69352e
--- /dev/null
+++ b/arch/x86/boot/compressed/efi_random.c
@@ -0,0 +1,80 @@
+#include "misc.h"
+
+#include <linux/efi.h>
+#include <asm/archrandom.h>
+
+#define EDX_TSC		(1 << 4)
+#define ECX_RDRAND	(1 << 30)
+
+static unsigned int cpuid_0x1_ecx, cpuid_0x1_edx;
+
+static void cpuid_ecx_edx(void)
+{
+	unsigned int eax, ebx;
+
+	cpuid(0x1, &eax, &ebx, &cpuid_0x1_ecx, &cpuid_0x1_edx);
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
+	if (entropy)
+		random = entropy;
+	else
+		random = get_random_boot(boot_params);
+
+	if (cpuid_0x1_ecx & ECX_RDRAND) {
+		if (rdrand_long(&raw)) {
+			random ^= raw;
+			use_i8254 = false;
+		}
+	}
+
+	if (cpuid_0x1_edx & EDX_TSC) {
+		rdtscll(raw);
+
+		random ^= raw;
+		use_i8254 = false;
+	}
+
+	if (use_i8254)
+		random ^= read_i8254();
+
+	/* Circular multiply for better bit diffusion */
+	asm("mul %3"
+	    : "=a" (random), "=d" (raw)
+	    : "a" (random), "rm" (mix_const));
+	random += raw;
+
+	return random;
+}
+
+void efi_get_random_key(efi_system_table_t *sys_table,
+			struct boot_params *params, u8 key[], unsigned int size)
+{
+	unsigned long entropy = 0;
+	unsigned int bfill = size;
+
+	if (key == NULL || !size)
+		return;
+
+	cpuid_ecx_edx();
+
+	memset(key, 0, size);
+	while (bfill > 0) {
+		unsigned int copy_len = 0;
+		entropy = get_random_long(entropy, params, sys_table);
+		copy_len = (bfill < sizeof(entropy)) ? bfill : sizeof(entropy);
+		memcpy((void *)(key + size - bfill), &entropy, copy_len);
+		bfill -= copy_len;
+	}
+}
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 70acd7e..c8e2237 100644
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
index 60e4893..3508a6e 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -53,7 +53,7 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
 #endif
 
-#if CONFIG_RANDOMIZE_BASE
+#if CONFIG_HIBERNATE_VERIFICATION || CONFIG_RANDOMIZE_BASE
 extern u16 read_i8254(void);
 extern unsigned long get_random_boot(struct boot_params *boot_params);
 #endif
-- 
2.1.4
