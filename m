From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 06/16] x86/efi: Generating random HMAC key for siging hibernate image
Date: Tue, 11 Aug 2015 14:16:26 +0800
Message-ID: <1439273796-25359-7-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

This patch adds codes in EFI stub for generating and storing the
HMAC key in EFI boot service variable for signing hibernate image.

Per rcf2104, the length of HMAC-SHA1 hash result is 20 bytes, and
it recommended the length of key the same with hash rsult, means
also 20 bytes. Using longer key would not significantly increase
the function strength. Due to the nvram space is limited in some
UEFI machines, so using the minimal recommended length 20 bytes
key that will stored in boot service variable.

The HMAC key stored in EFI boot service variable, GUID is
HIBERNATIONKey-fe141863-c070-478e-b8a3-878a5dc9ef21.

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/eboot.c | 60 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/suspend.h   |  9 ++++++
 include/linux/suspend.h          |  3 ++
 3 files changed, 72 insertions(+)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 0ffb6db..463aa9b 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -12,6 +12,7 @@
 #include <asm/efi.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
+#include <asm/suspend.h>
 
 #include "../string.h"
 #include "eboot.h"
@@ -1383,6 +1384,63 @@ free_mem_map:
 	return status;
 }
 
+#ifdef CONFIG_HIBERNATE_VERIFICATION
+#define HIBERNATION_KEY \
+	((efi_char16_t [15]) { 'H', 'I', 'B', 'E', 'R', 'N', 'A', 'T', 'I', 'O', 'N', 'K', 'e', 'y', 0 })
+#define HIBERNATION_KEY_ATTRIBUTE	(EFI_VARIABLE_NON_VOLATILE | \
+					EFI_VARIABLE_BOOTSERVICE_ACCESS)
+
+static void setup_hibernation_keys(struct boot_params *params)
+{
+	unsigned long key_size;
+	unsigned long attributes;
+	struct hibernation_keys *keys;
+	efi_status_t status;
+
+	/* Allocate setup_data to carry keys */
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				sizeof(struct hibernation_keys), &keys);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to alloc mem for hibernation keys\n");
+		return;
+	}
+
+	memset(keys, 0, sizeof(struct hibernation_keys));
+
+	status = efi_call_early(get_variable, HIBERNATION_KEY,
+				&EFI_HIBERNATION_GUID, &attributes,
+				&key_size, keys->hibernation_key);
+	if (status == EFI_SUCCESS && attributes != HIBERNATION_KEY_ATTRIBUTE) {
+		efi_printk(sys_table, "A hibernation key is not boot service variable\n");
+		memset(keys->hibernation_key, 0, HIBERNATION_DIGEST_SIZE);
+		status = efi_call_early(set_variable, HIBERNATION_KEY,
+					&EFI_HIBERNATION_GUID, attributes, 0,
+					NULL);
+		if (status == EFI_SUCCESS) {
+			efi_printk(sys_table, "Cleaned existing hibernation key\n");
+			status = EFI_NOT_FOUND;
+		}
+	}
+
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to get existing hibernation key\n");
+
+		efi_get_random_key(sys_table, params, keys->hibernation_key,
+				   HIBERNATION_DIGEST_SIZE);
+
+		status = efi_call_early(set_variable, HIBERNATION_KEY,
+					&EFI_HIBERNATION_GUID,
+					HIBERNATION_KEY_ATTRIBUTE,
+					HIBERNATION_DIGEST_SIZE,
+					keys->hibernation_key);
+		if (status != EFI_SUCCESS)
+			efi_printk(sys_table, "Failed to set hibernation key\n");
+	}
+}
+#else
+static void setup_hibernation_keys(struct boot_params *params) {}
+#endif
+
 /*
  * On success we return a pointer to a boot_params structure, and NULL
  * on failure.
@@ -1420,6 +1478,8 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	setup_efi_pci(boot_params);
 
+	setup_hibernation_keys(boot_params);
+
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				sizeof(*gdt), (void **)&gdt);
 	if (status != EFI_SUCCESS) {
diff --git a/arch/x86/include/asm/suspend.h b/arch/x86/include/asm/suspend.h
index 2fab6c2..ab463c4 100644
--- a/arch/x86/include/asm/suspend.h
+++ b/arch/x86/include/asm/suspend.h
@@ -3,3 +3,12 @@
 #else
 # include <asm/suspend_64.h>
 #endif
+
+#ifdef CONFIG_HIBERNATE_VERIFICATION
+#include <linux/suspend.h>
+
+struct hibernation_keys {
+	unsigned long hkey_status;
+	u8 hibernation_key[HIBERNATION_DIGEST_SIZE];
+};
+#endif
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 56c6de9..aa88b3b 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -328,6 +328,9 @@ struct platform_hibernation_ops {
 
 #ifdef CONFIG_HIBERNATION
 
+#define EFI_HIBERNATION_GUID \
+	EFI_GUID(0xfe141863, 0xc070, 0x478e, 0xb8, 0xa3, 0x87, 0x8a, 0x5d, 0xc9, 0xef, 0x21)
+
 /* HMAC Algorithm of Hibernate Signature */
 #define HIBERNATION_HMAC	"hmac(sha1)"
 #define HIBERNATION_DIGEST_SIZE	20
-- 
2.1.4
