From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH 3/6] efi: generate efi root key in EFI boot stub
Date: Sun,  5 Aug 2018 11:21:16 +0800
Message-ID: <20180805032119.20485-4-jlee@suse.com>
References: <20180805032119.20485-1-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180805032119.20485-1-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, keyrings@vger.kernel.org, linux-integrity@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Pavel Machek <pavel@ucw.cz>, Chen Yu <yu.c.chen@intel.com>, Oliver Neukum <oneukum@suse.com>, Ryan Chen <yu.chen.surf@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
List-Id: linux-efi@vger.kernel.org

When secure boot is enabled, only signed EFI binary can access
EFI boot service variable before ExitBootService. Which means that
the EFI boot service variable is secure.

This patch adds functions to EFI boot stub to generate a 512-bit
random number that it can be used as a root key for encryption and
authentication. This root key will be kept in EFI boot service
variable. EFI boot stub reads and transfers ERK (efi root key) to
runtime kernel by setup data.

At runtime, the ERK can be used to encrypted/authentication
other random number to generate EFI secure key. The EFI secure key
can be a new master key type for encrypted key. It's useful for
EVM or hibernation.

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
 arch/x86/boot/compressed/Makefile       |   1 +
 arch/x86/boot/compressed/cpuflags.c     |   2 +-
 arch/x86/boot/compressed/eboot.c        |   2 +
 arch/x86/boot/compressed/efi_root_key.c | 212 ++++++++++++++++++++++++++++++++
 arch/x86/boot/compressed/misc.c         |   2 +-
 arch/x86/boot/compressed/misc.h         |  18 +--
 arch/x86/include/asm/efi.h              |  13 ++
 arch/x86/include/uapi/asm/bootparam.h   |   1 +
 arch/x86/kernel/setup.c                 |   3 +
 drivers/firmware/efi/Kconfig            |  23 ++++
 drivers/firmware/efi/Makefile           |   1 +
 drivers/firmware/efi/efi-secure-key.c   |  66 ++++++++++
 include/linux/efi.h                     |  14 +++
 13 files changed, 348 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/boot/compressed/efi_root_key.c
 create mode 100644 drivers/firmware/efi/efi-secure-key.c

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 169c2feda14a..923ea490cfe7 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -85,6 +85,7 @@ endif
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
+vmlinux-objs-$(CONFIG_EFI_SECURE_KEY) += $(obj)/efi_root_key.o
 vmlinux-objs-$(CONFIG_EFI_STUB) += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
 	$(objtree)/drivers/firmware/efi/libstub/lib.a
 vmlinux-objs-$(CONFIG_EFI_MIXED) += $(obj)/efi_thunk_$(BITS).o
diff --git a/arch/x86/boot/compressed/cpuflags.c b/arch/x86/boot/compressed/cpuflags.c
index 6448a8196d32..4df8f6d634c3 100644
--- a/arch/x86/boot/compressed/cpuflags.c
+++ b/arch/x86/boot/compressed/cpuflags.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-#ifdef CONFIG_RANDOMIZE_BASE
+#if defined(CONFIG_RANDOMIZE_BASE) || defined(CONFIG_EFI_SECURE_KEY)
 
 #include "../cpuflags.c"
 
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index e98522ea6f09..fe252b45b17b 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -952,6 +952,8 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	setup_efi_pci(boot_params);
 
+	efi_setup_root_key(sys_table, boot_params);
+
 	setup_quirks(boot_params);
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
diff --git a/arch/x86/boot/compressed/efi_root_key.c b/arch/x86/boot/compressed/efi_root_key.c
new file mode 100644
index 000000000000..291aef8b583e
--- /dev/null
+++ b/arch/x86/boot/compressed/efi_root_key.c
@@ -0,0 +1,212 @@
+/* EFI root key generator
+ *
+ * Copyright (C) 2018 Lee, Chun-Yi <jlee@suse.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+#include "misc.h"
+
+static efi_system_table_t *s_table;
+static struct boot_params *b_params;
+
+#ifdef DEBUG
+#define debug_putstr(__x)  efi_printk(s_table, (char *)__x)
+#else
+#define debug_putstr(__x)
+#endif
+
+static void efi_printk_status(char *reason, efi_status_t status)
+{
+	efi_printk(s_table, reason);
+	efi_printk(s_table, efi_status_to_str(status));
+	efi_printk(s_table, "\n");
+}
+
+static unsigned long get_boot_seed(void)
+{
+	unsigned long hash = 0;
+
+	hash = rotate_xor(hash, build_str, sizeof(build_str));
+	hash = rotate_xor(hash, b_params, sizeof(*b_params));
+
+	return hash;
+}
+
+#include "../../lib/random.c"
+
+static void generate_root_key(u8 key[], unsigned int size)
+{
+	unsigned int bfill = size;
+
+	if (key == NULL || !size)
+		return;
+
+	memset(key, 0, size);
+	while (bfill > 0) {
+		unsigned long entropy = 0;
+		unsigned int copy_len = 0;
+		entropy = get_random_long("EFI root key");
+		copy_len = (bfill < sizeof(entropy)) ? bfill : sizeof(entropy);
+		memcpy((void *)(key + size - bfill), &entropy, copy_len);
+		bfill -= copy_len;
+	}
+}
+
+#define get_efi_var(name, vendor, ...) \
+	efi_call_runtime(get_variable, \
+			(efi_char16_t *)(name), (efi_guid_t *)(vendor), \
+			__VA_ARGS__);
+#define set_efi_var(name, vendor, ...) \
+	efi_call_runtime(set_variable, \
+			(efi_char16_t *)(name), (efi_guid_t *)(vendor), \
+			__VA_ARGS__);
+
+static efi_char16_t const root_key_name[] = {
+	'R', 'o', 'o', 't', 'K', 'e', 'y', 0
+};
+#define ROOT_KEY_ATTRIBUTE	(EFI_VARIABLE_NON_VOLATILE | \
+				EFI_VARIABLE_BOOTSERVICE_ACCESS)
+
+static efi_status_t get_root_key(unsigned long *attributes,
+			unsigned long *key_size,
+			struct efi_rkey_setup_data *rkey_setup)
+{
+	void *key_data;
+	efi_status_t status;
+
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				*key_size, &key_data);
+	if (status != EFI_SUCCESS) {
+		efi_printk_status("Failed to allocate mem: \n", status);
+		return status;
+	}
+	memset(key_data, 0, *key_size);
+	status = get_efi_var(root_key_name, &EFI_SECURE_GUID,
+			     attributes, key_size, key_data);
+	if (status != EFI_SUCCESS) {
+		efi_printk_status("Failed to get root key: ", status);
+		goto err;
+	}
+
+	memset(rkey_setup->root_key, 0, ROOT_KEY_SIZE);
+	memcpy(rkey_setup->root_key, key_data,
+	       (*key_size >= ROOT_KEY_SIZE) ? ROOT_KEY_SIZE : *key_size);
+err:
+	efi_call_early(free_pool, key_data);
+	return status;
+}
+
+static efi_status_t remove_root_key(unsigned long attributes)
+{
+	efi_status_t status;
+
+	status = set_efi_var(root_key_name,
+			     &EFI_SECURE_GUID, attributes, 0, NULL);
+	if (status == EFI_SUCCESS)
+		efi_printk(s_table, "Removed root key\n");
+	else
+		efi_printk_status("Failed to remove root key: ", status);
+
+	return status;
+}
+
+static efi_status_t create_root_key(struct efi_rkey_setup_data *rkey_setup)
+{
+	efi_status_t status;
+
+	efi_printk(s_table, "Create new root key\n");
+	generate_root_key(rkey_setup->root_key, ROOT_KEY_SIZE);
+	status = set_efi_var(root_key_name, &EFI_SECURE_GUID,
+			     ROOT_KEY_ATTRIBUTE, ROOT_KEY_SIZE,
+			     rkey_setup->root_key);
+	if (status != EFI_SUCCESS)
+		efi_printk_status("Failed to write root key: ", status);
+
+	return status;
+}
+
+static efi_status_t regen_root_key(struct efi_rkey_setup_data *rkey_setup)
+{
+	unsigned long attributes = 0;
+	unsigned long key_size = ROOT_KEY_SIZE;
+	efi_status_t status;
+
+	status = remove_root_key(attributes);
+	if (status == EFI_SUCCESS)
+		status = create_root_key(rkey_setup);
+	if (status == EFI_SUCCESS)
+		status = get_root_key(&attributes, &key_size, rkey_setup);
+}
+
+void efi_setup_root_key(efi_system_table_t *sys_table, struct boot_params *params)
+{
+	struct setup_data *setup_data, *rkey_setup_data;
+	unsigned long setup_size = 0;
+	unsigned long attributes = 0;
+	unsigned long key_size = 0;
+	struct efi_rkey_setup_data *rkey_setup;
+	efi_status_t status;
+
+	s_table = sys_table;
+	b_params = params;
+
+	setup_size = sizeof(struct setup_data) + sizeof(struct efi_rkey_setup_data);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				setup_size, &rkey_setup_data);
+	if (status != EFI_SUCCESS) {
+		efi_printk(s_table, "Failed to allocate mem for root key\n");
+		return;
+	}
+	memset(rkey_setup_data, 0, setup_size);
+	rkey_setup = (struct efi_rkey_setup_data *) rkey_setup_data->data;
+
+	/* detect the size of root key variable */
+	status = get_efi_var(root_key_name, &EFI_SECURE_GUID,
+			     &attributes, &key_size, NULL);
+	rkey_setup->detect_status = status;
+	switch (status) {
+	case EFI_BUFFER_TOO_SMALL:
+		status = get_root_key(&attributes, &key_size, rkey_setup);
+		if (status != EFI_SUCCESS)
+			break;
+		if (attributes != ROOT_KEY_ATTRIBUTE) {
+			efi_printk(sys_table, "Found a unqualified root key\n");
+			status = regen_root_key(rkey_setup);
+		}
+		break;
+
+	case EFI_NOT_FOUND:
+		status = create_root_key(rkey_setup);
+		if (status == EFI_SUCCESS) {
+			key_size = ROOT_KEY_SIZE;
+			status = get_root_key(&attributes, &key_size, rkey_setup);
+		}
+		break;
+
+	default:
+		efi_printk_status("Failed to detect root key's size: ", status);
+	}
+
+	rkey_setup->is_secure =
+		efi_get_secureboot(sys_table) == efi_secureboot_mode_enabled;
+	rkey_setup->key_size = key_size;
+	rkey_setup->final_status = status;
+
+	rkey_setup_data->type = SETUP_EFI_ROOT_KEY;
+	rkey_setup_data->len = sizeof(struct efi_rkey_setup_data);
+	rkey_setup_data->next = 0;
+	setup_data = (struct setup_data *)params->hdr.setup_data;
+	while (setup_data && setup_data->next)
+		setup_data = (struct setup_data *)setup_data->next;
+	if (setup_data)
+		setup_data->next = (unsigned long)rkey_setup_data;
+	else
+		params->hdr.setup_data = (unsigned long)rkey_setup_data;
+}
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index eb0ab9cad4e4..e01cf1bd2e92 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -427,7 +427,7 @@ void fortify_panic(const char *name)
 	error("detected buffer overflow");
 }
 
-#if CONFIG_RANDOMIZE_BASE
+#if defined(CONFIG_RANDOMIZE_BASE) || defined(CONFIG_EFI_SECURE_KEY)
 unsigned long rotate_xor(unsigned long hash, const void *area,
 			size_t size)
 {
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 957f327ad83c..c3950c4ffcd3 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -68,22 +68,24 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
 #endif
 
-
-#if CONFIG_RANDOMIZE_BASE
+#if defined(CONFIG_RANDOMIZE_BASE) || defined(CONFIG_EFI_SECURE_KEY)
 #include <generated/compile.h>
 #include <generated/utsrelease.h>
-/* kaslr.c */
-void choose_random_location(unsigned long input,
-			    unsigned long input_size,
-			    unsigned long *output,
-			    unsigned long output_size,
-			    unsigned long *virt_addr);
 /* cpuflags.c */
 bool has_cpuflag(int flag);
 /* Simplified build-specific string for starting entropy. */
 static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
 unsigned long rotate_xor(unsigned long hash, const void *area, size_t size);
+#endif
+
+#if CONFIG_RANDOMIZE_BASE
+/* kaslr.c */
+void choose_random_location(unsigned long input,
+			    unsigned long input_size,
+			    unsigned long *output,
+			    unsigned long output_size,
+			    unsigned long *virt_addr);
 #else
 static inline void choose_random_location(unsigned long input,
 					  unsigned long input_size,
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index cec5fae23eb3..a25a6da25467 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -172,6 +172,16 @@ static inline bool efi_runtime_supported(void)
 extern struct console early_efi_console;
 extern void parse_efi_setup(u64 phys_addr, u32 data_len);
 
+#ifdef CONFIG_EFI_SECURE_KEY
+extern void efi_setup_root_key(efi_system_table_t *table,
+				struct boot_params *params);
+extern void parse_efi_root_key_setup(u64 phys_addr, u32 data_len);
+#else
+static inline void efi_setup_root_key(efi_system_table_t *table,
+					struct boot_params *params) {}
+static inline void parse_efi_root_key_setup(u64 phys_addr, u32 data_len) {}
+#endif /* CONFIG_EFI_SECURE_KEY */
+
 extern void efifb_setup_from_dmi(struct screen_info *si, const char *opt);
 
 #ifdef CONFIG_EFI_MIXED
@@ -245,6 +255,9 @@ extern bool efi_reboot_required(void);
 
 #else
 static inline void parse_efi_setup(u64 phys_addr, u32 data_len) {}
+static inline void parse_efi_root_key_setup(u64 phys_addr, u32 data_len) {}
+static inline void efi_setup_root_key(efi_system_table_t *table,
+					struct boot_params *params) {}
 static inline bool efi_reboot_required(void)
 {
 	return false;
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index a06cbf019744..586d824daefe 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -10,6 +10,7 @@
 #define SETUP_EFI			4
 #define SETUP_APPLE_PROPERTIES		5
 #define SETUP_JAILHOUSE			6
+#define SETUP_EFI_ROOT_KEY		7
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2f86d883dd95..0559abdc7648 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -420,6 +420,9 @@ static void __init parse_setup_data(void)
 		case SETUP_EFI:
 			parse_efi_setup(pa_data, data_len);
 			break;
+		case SETUP_EFI_ROOT_KEY:
+			parse_efi_root_key_setup(pa_data, data_len);
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 781a4a337557..048cf91ae8e8 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -164,6 +164,29 @@ config RESET_ATTACK_MITIGATION
 	  have been evicted, since otherwise it will trigger even on clean
 	  reboots.
 
+config EFI_SECURE_KEY
+	bool "EFI secure key"
+	default n
+	depends on KEYS && EFI_STUB && X86
+        select CRYPTO
+        select CRYPTO_HMAC
+        select CRYPTO_AES
+        select CRYPTO_CBC
+        select CRYPTO_SHA256
+        select CRYPTO_RNG
+	help
+	  This option enables the EFI secure key functions. EFI boot stub
+	  will generate a 512-bit random number that it can be used as
+	  a root key for encryption and authentication. The secure key will
+	  be kept in EFI boot service variable which is secure when secure
+	  boot is enabled.
+	  At runtime, the ERK (efi root key) can be used to encrypt and
+	  authenticate other random number for creating EFI secure key. The
+	  EFI secure key can be a master key type for encrypted key. It
+	  can be used by EVM and hibernation.
+
+	  If unsure, say N.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 5f9f5039de50..d47149464f82 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -32,3 +32,4 @@ obj-$(CONFIG_ARM64)			+= $(arm-obj-y)
 obj-$(CONFIG_EFI_CAPSULE_LOADER)	+= capsule-loader.o
 obj-$(CONFIG_UEFI_CPER_ARM)		+= cper-arm.o
 obj-$(CONFIG_UEFI_CPER_X86)		+= cper-x86.o
+obj-$(CONFIG_EFI_SECURE_KEY)		+= efi-secure-key.o
diff --git a/drivers/firmware/efi/efi-secure-key.c b/drivers/firmware/efi/efi-secure-key.c
new file mode 100644
index 000000000000..e56d7d176e03
--- /dev/null
+++ b/drivers/firmware/efi/efi-secure-key.c
@@ -0,0 +1,66 @@
+/* EFI secure key
+ *
+ * Copyright (C) 2018 Lee, Chun-Yi <jlee@suse.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/efi.h>
+#include <linux/memblock.h>
+#include <linux/security.h>
+
+static u8 root_key[ROOT_KEY_SIZE];
+static unsigned long rkey_size;
+static bool is_loaded;
+static bool is_secure;
+
+static void __init
+print_efi_rkey_setup_data(struct efi_rkey_setup_data *rkey_setup)
+{
+	pr_debug("EFI root key detection status: %s 0x%lx\n",
+		efi_status_to_str(rkey_setup->detect_status),
+		rkey_setup->detect_status);
+	pr_debug("EFI root key getting status: %s 0x%lx\n",
+		efi_status_to_str(rkey_setup->final_status),
+		rkey_setup->final_status);
+	pr_debug("EFI root key size: %ld\n", rkey_setup->key_size);
+
+	if (rkey_setup->final_status != EFI_SUCCESS) {
+		pr_warn("EFI root key getting failed: %s 0x%lx\n",
+			efi_status_to_str(rkey_setup->final_status),
+			rkey_setup->final_status);
+	} else if (rkey_setup->key_size < ROOT_KEY_SIZE) {
+		pr_warn(KERN_CONT "EFI root key size %ld is less than %d.\n",
+			rkey_setup->key_size, ROOT_KEY_SIZE);
+	}
+}
+
+void __init parse_efi_root_key_setup(u64 phys_addr, u32 data_len)
+{
+	struct efi_rkey_setup_data *rkey_setup;
+	void *setup_data;
+
+	setup_data = early_memremap(phys_addr, data_len);
+	rkey_setup = setup_data + sizeof(struct setup_data);
+	print_efi_rkey_setup_data(rkey_setup);
+
+	/* keep efi root key */
+	if (rkey_setup->final_status == EFI_SUCCESS) {
+		memcpy(root_key, rkey_setup->root_key, rkey_setup->key_size);
+		rkey_size = rkey_setup->key_size;
+		is_loaded = true;
+		is_secure = rkey_setup->is_secure;
+		pr_info("EFI root key is loaded.\n");
+		if (!is_secure) {
+			pr_warn("EFI root key is insecure when no secure boot.\n");
+		}
+	}
+
+	/* erase setup data */
+	memzero_explicit(setup_data,
+		sizeof(struct setup_data) + sizeof(struct efi_rkey_setup_data));
+	early_iounmap(setup_data, data_len);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 744cf92fe18e..f9fd273ef544 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1677,4 +1677,18 @@ efi_status_to_str(efi_status_t status)
 	return "";
 }
 
+#ifdef CONFIG_EFI_SECURE_KEY
+#define EFI_SECURE_GUID \
+	EFI_GUID(0x8c136d32, 0x039a, 0x4016, 0x8b, 0xb4, 0x9e, 0x98, 0x5e, 0x62, 0x78, 0x6f)
+#define ROOT_KEY_SIZE        64
+struct efi_rkey_setup_data {
+	bool is_secure;
+	unsigned long detect_status;
+	unsigned long final_status;
+	unsigned long key_size;
+	u8 root_key[ROOT_KEY_SIZE];
+};
+#else
+#define ROOT_KEY_SIZE        0
+#endif /* CONFIG_EFI_SECURE_KEY */
 #endif /* _LINUX_EFI_H */
-- 
2.13.6
