From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [RFC PATCH 14/16] PM / hibernate: Allow user trigger swsusp key re-generating
Date: Thu, 16 Jul 2015 22:25:28 +0800
Message-ID: <1437056730-15247-15-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

This patch provides a ioctl for triggering swsusp key re-generating
process. It's allow user call ioctl to raise the flag of key re-generating.
Kernel writes a flag to a efi runtime variable, the GUID is
S4SignKeyRegen-fe141863-c070-478e-b8a3-878a5dc9ef21, then EFI stub will
re-generates swsusp key when queried flag.

To aviod the swsusp key changes in hibernating cycle that causes hiberne
restoring failed, this flag is only available when system runs normal
reboot or shutdown. The hibernate code will clean the flag when it raised
in a hiberante cycle.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/eboot.c          | 20 +++++++++++---
 arch/x86/power/hibernate_keys.c           |  2 ++
 drivers/firmware/Makefile                 |  1 +
 drivers/firmware/efi/Kconfig              |  4 +++
 drivers/firmware/efi/Makefile             |  1 +
 drivers/firmware/efi/efi-hibernate_keys.c | 43 +++++++++++++++++++++++++++++++
 include/linux/suspend.h                   | 15 +++++++++++
 include/uapi/linux/suspend_ioctls.h       |  3 ++-
 kernel/power/Kconfig                      |  1 +
 kernel/power/hibernate.c                  |  2 ++
 kernel/power/user.c                       |  7 +++++
 kernel/reboot.c                           |  3 +++
 12 files changed, 97 insertions(+), 5 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-hibernate_keys.c

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 5e1476e..b959f83 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1394,9 +1394,10 @@ static void setup_swsusp_keys(struct boot_params *params)
 {
 	struct setup_data *setup_data, *swsusp_setup_data;
 	struct swsusp_keys *swsusp_keys;
+	bool regen_key = false;
 	int size = 0;
-	unsigned long key_size, attributes;
-	efi_status_t status;
+	unsigned long ignore, key_size, attributes;
+	efi_status_t status, reg_status;
 
 	/* Allocate setup_data to carry keys */
 	size = sizeof(struct setup_data) + sizeof(struct swsusp_keys);
@@ -1425,12 +1426,16 @@ static void setup_swsusp_keys(struct boot_params *params)
 		}
 	}
 
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to get existing swsusp key\n");
+	reg_status = efi_call_early(get_variable, SWSUSP_KEY_REGEN_FLAG,
+				&EFI_SWSUSP_GUID, NULL, &ignore, &regen_key);
+	if ((status != EFI_SUCCESS) ||
+	   (reg_status == EFI_SUCCESS && regen_key)) {
+		efi_printk(sys_table, "Regenerating swsusp key\n");
 
 		efi_get_random_key(sys_table, params, swsusp_keys->swsusp_key,
 				   SWSUSP_DIGEST_SIZE);
 
+		/* Set new swsusp key to bootservice non-volatile variable */
 		status = efi_call_early(set_variable, SWSUSP_KEY,
 					&EFI_SWSUSP_GUID,
 					SWSUSP_KEY_ATTRIBUTE,
@@ -1438,6 +1443,13 @@ static void setup_swsusp_keys(struct boot_params *params)
 					swsusp_keys->swsusp_key);
 		if (status != EFI_SUCCESS)
 			efi_printk(sys_table, "Failed to set swsusp key\n");
+
+		efi_call_early(get_variable, SWSUSP_KEY, &EFI_SWSUSP_GUID,
+				NULL, &key_size, swsusp_keys->swsusp_key);
+
+		/* Clean key regenerate flag */
+		efi_call_early(set_variable, SWSUSP_KEY_REGEN_FLAG,
+				&EFI_SWSUSP_GUID, 0, 0, NULL);
 	}
 
 clean_fail:
diff --git a/arch/x86/power/hibernate_keys.c b/arch/x86/power/hibernate_keys.c
index 9a0f3b3..76811d4 100644
--- a/arch/x86/power/hibernate_keys.c
+++ b/arch/x86/power/hibernate_keys.c
@@ -165,6 +165,8 @@ static int __init init_hibernate_keys(void)
 	memblock_free(keys_phys_addr, sizeof(struct swsusp_keys));
 	keys_phys_addr = 0;
 
+	set_swsusp_key_regen_flag = false;
+
 	return ret;
 }
 
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 4a4b897..51b0c38 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -19,3 +19,4 @@ obj-y				+= broadcom/
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
 obj-$(CONFIG_EFI)		+= efi/
 obj-$(CONFIG_UEFI_CPER)		+= efi/
+obj-$(CONFIG_EFI_SWSUSP_KEYS)	+= efi/
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 54071c1..de3df38 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -69,3 +69,7 @@ endmenu
 
 config UEFI_CPER
 	bool
+
+config EFI_SWSUSP_KEYS
+	bool
+	select EFI_VARS
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 6fd3da9..98d9fbc 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_ESRT)			+= esrt.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
+obj-$(CONFIG_EFI_SWSUSP_KEYS)		+= efi-hibernate_keys.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
diff --git a/drivers/firmware/efi/efi-hibernate_keys.c b/drivers/firmware/efi/efi-hibernate_keys.c
new file mode 100644
index 0000000..90ae912
--- /dev/null
+++ b/drivers/firmware/efi/efi-hibernate_keys.c
@@ -0,0 +1,43 @@
+/* EFI variable handler of swsusp key regen flag
+ *
+ * Copyright (C) 2015 SUSE Linux Products GmbH. All rights reserved.
+ * Written by Chun-Yi Lee (jlee@suse.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/efi.h>
+#include <linux/slab.h>
+#include <linux/suspend.h>
+
+/* Set this flag will creating SWSUSPKeyRegen EFI variable */
+bool set_swsusp_key_regen_flag;
+
+void create_swsusp_key_regen_flag(void)
+{
+	struct efivar_entry *entry = NULL;
+	int err = 0;
+
+	if (!set_swsusp_key_regen_flag)
+		return;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return;
+
+	memcpy(entry->var.VariableName,
+		SWSUSP_KEY_REGEN_FLAG, sizeof(SWSUSP_KEY_REGEN_FLAG));
+	memcpy(&(entry->var.VendorGuid),
+		&EFI_SWSUSP_GUID, sizeof(efi_guid_t));
+
+	err = efivar_entry_set(entry, SWSUSP_KEY_SEED_ATTRIBUTE,
+				sizeof(bool), &set_swsusp_key_regen_flag, NULL);
+	if (err)
+		pr_warn("PM: Set flag of regenerating swsusp key failed: %d\n", err);
+
+	kfree(entry);
+}
+EXPORT_SYMBOL_GPL(create_swsusp_key_regen_flag);
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index fc3dde0..db8958c 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -330,6 +330,11 @@ struct platform_hibernation_ops {
 
 #define EFI_SWSUSP_GUID \
 	EFI_GUID(0xfe141863, 0xc070, 0x478e, 0xb8, 0xa3, 0x87, 0x8a, 0x5d, 0xc9, 0xef, 0x21)
+#define SWSUSP_KEY_REGEN_FLAG \
+	((efi_char16_t [15]) { 'S', 'W', 'S', 'U', 'S', 'P', 'K', 'e', 'y', 'R', 'e', 'g', 'e', 'n', 0 })
+#define SWSUSP_KEY_SEED_ATTRIBUTE      (EFI_VARIABLE_NON_VOLATILE | \
+					EFI_VARIABLE_BOOTSERVICE_ACCESS | \
+					EFI_VARIABLE_RUNTIME_ACCESS)
 
 /* HMAC Algorithm of Hibernate Signature */
 #define SWSUSP_HMAC		"hmac(sha1)"
@@ -338,6 +343,16 @@ struct platform_hibernation_ops {
 /* kernel/power/hibernate.c */
 extern int sigenforce;
 
+/* drivers/firmware/efi/efi-hibernate_keys.c */
+extern bool set_swsusp_key_regen_flag;
+
+#ifdef CONFIG_HIBERNATE_VERIFICATION
+/* drivers/firmware/efi/efi-hibernate_keys.c */
+extern void create_swsusp_key_regen_flag(void);
+#else
+static inline void create_swsusp_key_regen_flag(void) {}
+#endif
+
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
 static inline void __init register_nosave_region(unsigned long b, unsigned long e)
diff --git a/include/uapi/linux/suspend_ioctls.h b/include/uapi/linux/suspend_ioctls.h
index 0b30382..0a08450 100644
--- a/include/uapi/linux/suspend_ioctls.h
+++ b/include/uapi/linux/suspend_ioctls.h
@@ -28,6 +28,7 @@ struct resume_swap_area {
 #define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
 #define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, __kernel_loff_t)
 #define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, __kernel_loff_t)
-#define SNAPSHOT_IOC_MAXNR	20
+#define SNAPSHOT_REGENERATE_KEY		_IO(SNAPSHOT_IOC_MAGIC, 21)
+#define SNAPSHOT_IOC_MAXNR	21
 
 #endif /* _LINUX_SUSPEND_IOCTLS_H */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index f2a7e21..7a64bda 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -71,6 +71,7 @@ config HIBERNATE_VERIFICATION
 	depends on HIBERNATION
 	depends on EFI_STUB
 	depends on X86
+	select EFI_SWSUSP_KEYS
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	help
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 2c2cc90..314f268 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -653,6 +653,8 @@ int hibernate(void)
 {
 	int error;
 
+	set_swsusp_key_regen_flag = false;
+
 	if (!hibernation_available()) {
 		pr_debug("PM: Hibernation not available.\n");
 		return -EPERM;
diff --git a/kernel/power/user.c b/kernel/power/user.c
index ffd327a..8bcb051 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -338,6 +338,8 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
+		/* clean flag to avoid swsusp key regenerated */
+		set_swsusp_key_regen_flag = false;
 		/*
 		 * Tasks are frozen and the notifiers have been called with
 		 * PM_HIBERNATION_PREPARE
@@ -351,6 +353,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_POWER_OFF:
+		set_swsusp_key_regen_flag = false;
 		if (data->platform_support)
 			error = hibernation_platform_enter();
 		break;
@@ -386,6 +389,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		}
 		break;
 
+	case SNAPSHOT_REGENERATE_KEY:
+		set_swsusp_key_regen_flag = !!arg;
+		break;
+
 	default:
 		error = -ENOTTY;
 
diff --git a/kernel/reboot.c b/kernel/reboot.c
index d20c85d..88e51e3 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -213,6 +213,7 @@ void migrate_to_reboot_cpu(void)
  */
 void kernel_restart(char *cmd)
 {
+	create_swsusp_key_regen_flag();
 	kernel_restart_prepare(cmd);
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
@@ -240,6 +241,7 @@ static void kernel_shutdown_prepare(enum system_states state)
  */
 void kernel_halt(void)
 {
+	create_swsusp_key_regen_flag();
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
@@ -256,6 +258,7 @@ EXPORT_SYMBOL_GPL(kernel_halt);
  */
 void kernel_power_off(void)
 {
+	create_swsusp_key_regen_flag();
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
-- 
1.8.4.5
