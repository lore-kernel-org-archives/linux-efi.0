From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 14/16] PM / hibernate: Allow user trigger hibernation key re-generating
Date: Tue, 11 Aug 2015 14:16:34 +0800
Message-ID: <1439273796-25359-15-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

This patch provides a ioctl for triggering hibernation key re-generating
process. It's allow user call ioctl to raise the flag of key re-generating.
Kernel writes a flag to a efi runtime variable, the GUID is
S4SignKeyRegen-fe141863-c070-478e-b8a3-878a5dc9ef21, then EFI stub will
re-generates hibernation key when queried flag.

To aviod the hibernation key changes in hibernating cycle that causes hiberne
restoring failed, this flag is only available when system runs normal
reboot or shutdown. The hibernate code will clean the flag when it raised
in a hiberante cycle.

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/boot/compressed/eboot.c          | 19 ++++++++++++---
 arch/x86/power/hibernate_keys.c           |  2 ++
 drivers/firmware/Makefile                 |  1 +
 drivers/firmware/efi/Kconfig              |  4 ++++
 drivers/firmware/efi/Makefile             |  1 +
 drivers/firmware/efi/efi-hibernate_keys.c | 39 +++++++++++++++++++++++++++++++
 include/linux/suspend.h                   | 16 +++++++++++++
 include/uapi/linux/suspend_ioctls.h       |  3 ++-
 kernel/power/Kconfig                      |  1 +
 kernel/power/hibernate.c                  |  2 ++
 kernel/power/user.c                       | 10 ++++++++
 kernel/reboot.c                           |  3 +++
 12 files changed, 97 insertions(+), 4 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-hibernate_keys.c

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index c838d09..3228820 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1394,10 +1394,12 @@ static void setup_hibernation_keys(struct boot_params *params)
 {
 	unsigned long key_size;
 	unsigned long attributes;
+	unsigned long ignore;
 	struct setup_data *setup_data, *hibernation_setup_data;
 	struct hibernation_keys *keys;
+	bool regen_key = false;
 	unsigned long size = 0;
-	efi_status_t status;
+	efi_status_t status, reg_status;
 
 	/* Allocate setup_data to carry keys */
 	size = sizeof(struct setup_data) + sizeof(struct hibernation_keys);
@@ -1427,12 +1429,16 @@ static void setup_hibernation_keys(struct boot_params *params)
 			goto clean_fail;
 	}
 
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to get existing hibernation key\n");
+	reg_status = efi_call_early(get_variable, HIBERNATION_KEY_REGEN_FLAG,
+				&EFI_HIBERNATION_GUID, NULL, &ignore, &regen_key);
+	if ((status != EFI_SUCCESS) ||
+	   (reg_status == EFI_SUCCESS && regen_key)) {
+		efi_printk(sys_table, "Regenerating hibernation key\n");
 
 		efi_get_random_key(sys_table, params, keys->hibernation_key,
 				   HIBERNATION_DIGEST_SIZE);
 
+		/* Set new hibernation key to bootservice non-volatile variable */
 		status = efi_call_early(set_variable, HIBERNATION_KEY,
 					&EFI_HIBERNATION_GUID,
 					HIBERNATION_KEY_ATTRIBUTE,
@@ -1440,6 +1446,13 @@ static void setup_hibernation_keys(struct boot_params *params)
 					keys->hibernation_key);
 		if (status != EFI_SUCCESS)
 			efi_printk(sys_table, "Failed to set hibernation key\n");
+
+		efi_call_early(get_variable, HIBERNATION_KEY, &EFI_HIBERNATION_GUID,
+				NULL, &key_size, keys->hibernation_key);
+
+		/* Clean key regenerate flag */
+		efi_call_early(set_variable, HIBERNATION_KEY_REGEN_FLAG,
+				&EFI_HIBERNATION_GUID, 0, 0, NULL);
 	}
 
 clean_fail:
diff --git a/arch/x86/power/hibernate_keys.c b/arch/x86/power/hibernate_keys.c
index 51e808a..4fac9ab 100644
--- a/arch/x86/power/hibernate_keys.c
+++ b/arch/x86/power/hibernate_keys.c
@@ -165,6 +165,8 @@ static int __init init_hibernation_keys(void)
 	memblock_free(keys_phys_addr, sizeof(struct hibernation_keys));
 	keys_phys_addr = 0;
 
+	set_hibernation_key_regen_flag = false;
+
 	return ret;
 }
 
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 4a4b897..4474437 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -19,3 +19,4 @@ obj-y				+= broadcom/
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
 obj-$(CONFIG_EFI)		+= efi/
 obj-$(CONFIG_UEFI_CPER)		+= efi/
+obj-$(CONFIG_EFI_HIBERNATION_KEYS)	+= efi/
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 54071c1..bef29da 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -69,3 +69,7 @@ endmenu
 
 config UEFI_CPER
 	bool
+
+config EFI_HIBERNATION_KEYS
+	bool
+	select EFI_VARS
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 6fd3da9..d472c02 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_ESRT)			+= esrt.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
+obj-$(CONFIG_EFI_HIBERNATION_KEYS)	+= efi-hibernate_keys.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
diff --git a/drivers/firmware/efi/efi-hibernate_keys.c b/drivers/firmware/efi/efi-hibernate_keys.c
new file mode 100644
index 0000000..8a50bf1
--- /dev/null
+++ b/drivers/firmware/efi/efi-hibernate_keys.c
@@ -0,0 +1,39 @@
+/* EFI variable handler of hibernation key regen flag
+ *
+ * Copyright (C) 2015 Lee, Chun-Yi <jlee@suse.com>
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
+void create_hibernation_key_regen_flag(void)
+{
+	struct efivar_entry *entry = NULL;
+	int err = 0;
+
+	if (!set_hibernation_key_regen_flag)
+		return;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return;
+
+	memcpy(entry->var.VariableName,
+		HIBERNATION_KEY_REGEN_FLAG, sizeof(HIBERNATION_KEY_REGEN_FLAG));
+	memcpy(&(entry->var.VendorGuid),
+		&EFI_HIBERNATION_GUID, sizeof(efi_guid_t));
+
+	err = efivar_entry_set(entry, HIBERNATION_KEY_SEED_ATTRIBUTE,
+				sizeof(bool), &set_hibernation_key_regen_flag, NULL);
+	if (err)
+		pr_warn("PM: Set flag of regenerating hibernation key failed: %d\n", err);
+
+	kfree(entry);
+}
+EXPORT_SYMBOL_GPL(create_hibernation_key_regen_flag);
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index d318b72..dcca7ae 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -330,6 +330,11 @@ struct platform_hibernation_ops {
 
 #define EFI_HIBERNATION_GUID \
 	EFI_GUID(0xfe141863, 0xc070, 0x478e, 0xb8, 0xa3, 0x87, 0x8a, 0x5d, 0xc9, 0xef, 0x21)
+#define HIBERNATION_KEY_REGEN_FLAG \
+	((efi_char16_t [20]) { 'H', 'I', 'B', 'E', 'R', 'N', 'A', 'T', 'I', 'O', 'N', 'K', 'e', 'y', 'R', 'e', 'g', 'e', 'n', 0 })
+#define HIBERNATION_KEY_SEED_ATTRIBUTE	(EFI_VARIABLE_NON_VOLATILE | \
+					EFI_VARIABLE_BOOTSERVICE_ACCESS | \
+					EFI_VARIABLE_RUNTIME_ACCESS)
 
 /* HMAC Algorithm of Hibernate Signature */
 #define HIBERNATION_HMAC	"hmac(sha1)"
@@ -338,6 +343,16 @@ struct platform_hibernation_ops {
 /* kernel/power/hibernate.c */
 extern int sigenforce;
 
+/* kernel/power/user.c */
+extern bool set_hibernation_key_regen_flag;
+
+#ifdef CONFIG_HIBERNATE_VERIFICATION
+/* drivers/firmware/efi/efi-hibernate_keys.c */
+extern void create_hibernation_key_regen_flag(void);
+#else
+static inline void create_hibernation_key_regen_flag(void) {}
+#endif
+
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
 static inline void __init register_nosave_region(unsigned long b, unsigned long e)
@@ -370,6 +385,7 @@ static inline void hibernation_set_ops(const struct platform_hibernation_ops *op
 static inline int hibernate(void) { return -ENOSYS; }
 static inline bool system_entering_hibernation(void) { return false; }
 static inline bool hibernation_available(void) { return false; }
+static inline void create_hibernation_key_regen_flag(void) {}
 #endif /* CONFIG_HIBERNATION */
 
 /* Hibernation and suspend events */
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
index f2a7e21..1a03777 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -71,6 +71,7 @@ config HIBERNATE_VERIFICATION
 	depends on HIBERNATION
 	depends on EFI_STUB
 	depends on X86
+	select EFI_HIBERNATION_KEYS
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	help
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 2c2cc90..8bdb4bb 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -653,6 +653,8 @@ int hibernate(void)
 {
 	int error;
 
+	set_hibernation_key_regen_flag = false;
+
 	if (!hibernation_available()) {
 		pr_debug("PM: Hibernation not available.\n");
 		return -EPERM;
diff --git a/kernel/power/user.c b/kernel/power/user.c
index ffd327a..a183abd 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -32,6 +32,9 @@
 
 #define SNAPSHOT_MINOR	231
 
+/* Handler will create HIBERNATIONKeyRegen EFI variable when flag raised */
+bool set_hibernation_key_regen_flag;
+
 static struct snapshot_data {
 	struct snapshot_handle handle;
 	int swap;
@@ -338,6 +341,8 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
+		/* clean flag to avoid hibernation key regenerated */
+		set_hibernation_key_regen_flag = false;
 		/*
 		 * Tasks are frozen and the notifiers have been called with
 		 * PM_HIBERNATION_PREPARE
@@ -351,6 +356,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case SNAPSHOT_POWER_OFF:
+		set_hibernation_key_regen_flag = false;
 		if (data->platform_support)
 			error = hibernation_platform_enter();
 		break;
@@ -386,6 +392,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		}
 		break;
 
+	case SNAPSHOT_REGENERATE_KEY:
+		set_hibernation_key_regen_flag = !!arg;
+		break;
+
 	default:
 		error = -ENOTTY;
 
diff --git a/kernel/reboot.c b/kernel/reboot.c
index d20c85d..f83b88a 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -213,6 +213,7 @@ void migrate_to_reboot_cpu(void)
  */
 void kernel_restart(char *cmd)
 {
+	create_hibernation_key_regen_flag();
 	kernel_restart_prepare(cmd);
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
@@ -240,6 +241,7 @@ static void kernel_shutdown_prepare(enum system_states state)
  */
 void kernel_halt(void)
 {
+	create_hibernation_key_regen_flag();
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
@@ -256,6 +258,7 @@ EXPORT_SYMBOL_GPL(kernel_halt);
  */
 void kernel_power_off(void)
 {
+	create_hibernation_key_regen_flag();
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
-- 
2.1.4
