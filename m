From: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] efi: Introduce EFI bootloader control driver
Date: Fri, 18 Mar 2016 11:59:47 +0200
Message-ID: <1458295187-1750-1-git-send-email-daniel.baluta@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mohamed.abbas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, constantin.musca-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Matt Gumbel <matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This driver intercepts system reboot requests and populates the
LoaderEntryOneShot EFI variable with the user-supplied reboot
argument. EFI bootloaders such as Gummiboot will consume this
variable and use it to control which OS is booted next.

We use this with Android where reboot() tells the kernel that
we want to boot into recovery or other non-default OS environment.

It is the bootloader's job to guard against this variable being
uninitialzed or containing invalid data, and just boot normally
if that is the case.

Signed-off-by: Matt Gumbel <matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mohamed Abbas <mohamed.abbas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Constantin Musca <constantin.musca-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/Kconfig  |  11 ++
 drivers/firmware/efi/Makefile |   1 +
 drivers/firmware/efi/efi-bc.c | 251 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+)
 create mode 100644 drivers/firmware/efi/efi-bc.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index e1670d5..0f21af4 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -18,6 +18,17 @@ config EFI_VARS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://github.com/vathpela/efibootmgr>
 
+config EFI_BOOTLOADER_CONTROL
+	tristate "EFI Bootloader Control module"
+	depends on EFI_VARS
+	default n
+	help
+	  This driver installs a reboot hook, such that if reboot() is
+	  invoked with a string argument NNN, "bootonce-NNN" is copied to
+	  the EFI variable, to be read by the bootloader. If the string
+	  matches one of the boot labels defined in its configuration,
+	  the bootloader will boot once to that label.
+
 config EFI_ESRT
 	bool
 	depends on EFI && !IA64
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 62e654f..db096a4 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -10,6 +10,7 @@
 KASAN_SANITIZE_runtime-wrappers.o	:= n
 
 obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
+obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_ESRT)			+= esrt.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
diff --git a/drivers/firmware/efi/efi-bc.c b/drivers/firmware/efi/efi-bc.c
new file mode 100644
index 0000000..7550fee
--- /dev/null
+++ b/drivers/firmware/efi/efi-bc.c
@@ -0,0 +1,251 @@
+/*
+ * efi-bc.c - EFI bootloader control
+ *
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/efi.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/reboot.h>
+#include <linux/kexec.h>
+#include <linux/slab.h>
+
+#define LOADER_ENTRY_ONE_SHOT	"LoaderEntryOneShot"
+#define LOADER_ENTRY_REBOOT	"LoaderEntryRebootReason"
+#define LOADER_GUID EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf, 0xb6, 0xc7, \
+				0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
+
+#define REBOOT_REASON_CRASH	"kernel_panic"
+#define REBOOT_REASON_NORMAL	"reboot"
+#define REBOOT_REASON_SHUTDOWN	"shutdown"
+#define REBOOT_REASON_HALT	"halt"
+#define REBOOT_REASON_WATCHDOG	"watchdog"
+
+#define WATCHDOG_KERNEL_H	"Watchdog"
+#define WATCHDOG_KERNEL_S	"softlockup"
+#define WATCHDOG_KERNEL_D	"Software Watchdog"
+
+/*
+ * Convert char string to efi_char16_t string. NULL byte at end is always
+ * preserved.
+ */
+static unsigned long
+efichar_from_char(efi_char16_t *dest, const char *src, size_t dest_len)
+{
+	int i;
+
+	for (i = 0; src[i] && i < (dest_len / sizeof(*dest)) - 1; i++)
+		dest[i] = src[i];
+	dest[i] = 0; /* Gummiboot does need null-terminated strings */
+	return i;
+}
+
+/*
+ *  Returns required size of utf16 buffer for given char string. Space for
+ *  trailing nul is included. str must not be NULL.
+ */
+static size_t efi_char16_bufsz(char *str)
+{
+	return (1 + strlen(str)) * sizeof(efi_char16_t);
+}
+
+/*
+ * Set EFI variable to specify next boot target for EFI bootloader. Meant to be
+ * called as a reboot notifier. DO NOT call this function without guaranteeing
+ * efi_enabled == true; it will crash.
+ */
+static int
+efibc_reboot_notifier_call(struct notifier_block *notifier, unsigned long what,
+			   void *data)
+{
+	int ret = NOTIFY_DONE;
+	char *cmd = data;
+	efi_status_t status;
+	efi_char16_t *name_efichar = NULL, *cmd_efichar = NULL;
+	size_t name_efichar_blen, cmd_efichar_blen;
+
+	if (what != SYS_RESTART || !cmd)
+		goto out;
+
+	name_efichar_blen = efi_char16_bufsz(LOADER_ENTRY_ONE_SHOT);
+	cmd_efichar_blen = efi_char16_bufsz(cmd);
+
+	name_efichar = kzalloc(name_efichar_blen, GFP_KERNEL);
+	if (!name_efichar)
+		goto out;
+
+	cmd_efichar = kzalloc(cmd_efichar_blen, GFP_KERNEL);
+	if (!cmd_efichar)
+		goto out;
+
+	if (efichar_from_char(
+			name_efichar, LOADER_ENTRY_ONE_SHOT, name_efichar_blen)
+			!= strlen(LOADER_ENTRY_ONE_SHOT)) {
+		pr_err(
+			"efibc: %s: Failed to convert char to efi_char16_t. length=%lu",
+			__func__, name_efichar_blen);
+		goto out;
+	}
+
+	if (efichar_from_char(cmd_efichar, cmd, cmd_efichar_blen)
+			!= strlen(cmd)) {
+		pr_err(
+			"efibc: %s: Failed to convert char to efi_char16_t. length=%lu",
+			__func__, cmd_efichar_blen);
+		goto out;
+	}
+
+	status = efi.set_variable(name_efichar, &LOADER_GUID,
+				  EFI_VARIABLE_NON_VOLATILE |
+				  EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				  EFI_VARIABLE_RUNTIME_ACCESS,
+				  cmd_efichar_blen, cmd_efichar);
+	if (status != EFI_SUCCESS) {
+		pr_err("efibc: set_variable() failed. status=%lx\n", status);
+		goto out;
+	}
+
+	ret = NOTIFY_OK;
+out:
+	kfree(cmd_efichar);
+	kfree(name_efichar);
+	return ret;
+}
+
+static int efibc_reboot_reason(unsigned long what, char *cmd)
+{
+	int ret = NOTIFY_DONE;
+	efi_status_t status;
+	efi_char16_t name_efichar[40];
+	efi_char16_t cmd_efichar[20];
+	size_t name_efichar_blen, cmd_efichar_blen;
+
+	name_efichar_blen = efi_char16_bufsz(LOADER_ENTRY_REBOOT);
+	cmd_efichar_blen = efi_char16_bufsz(cmd);
+
+	if (efichar_from_char(
+			name_efichar, LOADER_ENTRY_REBOOT,
+			name_efichar_blen) != strlen(LOADER_ENTRY_REBOOT)) {
+		pr_err("efibc: %s: Failed to convert char to u16.", __func__);
+		goto out;
+	}
+
+	if (efichar_from_char(cmd_efichar, cmd, cmd_efichar_blen)
+			!= strlen(cmd)) {
+		pr_err("efibc: %s: Failed to convert char to u16", __func__);
+		goto out;
+	}
+
+	status = efi.set_variable(name_efichar, &LOADER_GUID,
+				  EFI_VARIABLE_NON_VOLATILE |
+				  EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				  EFI_VARIABLE_RUNTIME_ACCESS,
+				  cmd_efichar_blen,
+				  cmd_efichar);
+	if (status != EFI_SUCCESS) {
+		pr_err("efibc: set_variable() failed. status=%lx\n", status);
+		goto out;
+	}
+
+	ret = NOTIFY_OK;
+out:
+	return ret;
+}
+
+static int
+efibc_reboot_reason_notifier_call(struct notifier_block *notifier,
+				  unsigned long what, void *data)
+{
+	int ret;
+
+	switch (what) {
+	case SYS_RESTART:
+		ret = efibc_reboot_reason(what, REBOOT_REASON_NORMAL);
+		break;
+	case SYS_HALT:
+		ret = efibc_reboot_reason(what, REBOOT_REASON_HALT);
+		break;
+	default:
+		ret = efibc_reboot_reason(what, REBOOT_REASON_SHUTDOWN);
+		break;
+	}
+
+	return ret;
+}
+
+static int
+efibc_panic_notifier_call(struct notifier_block *notifier, unsigned long what,
+			  void *data)
+{
+	int ret;
+	char *str = data;
+
+	if (str &&
+	    (!strncmp(str, WATCHDOG_KERNEL_H, strlen(WATCHDOG_KERNEL_H)) ||
+	    !strncmp(str, WATCHDOG_KERNEL_S, strlen(WATCHDOG_KERNEL_S)) ||
+	    !strncmp(str, WATCHDOG_KERNEL_D, strlen(WATCHDOG_KERNEL_D))))
+		ret = efibc_reboot_reason(what, REBOOT_REASON_WATCHDOG);
+	else
+		ret = efibc_reboot_reason(what, REBOOT_REASON_CRASH);
+
+	return ret;
+}
+
+static struct notifier_block efibc_reboot_notifier = {
+	.notifier_call = efibc_reboot_notifier_call,
+};
+
+static struct notifier_block efibc_reboot_reason_notifier = {
+	.notifier_call = efibc_reboot_reason_notifier_call,
+};
+
+static struct notifier_block paniced = {
+	.notifier_call  = efibc_panic_notifier_call,
+};
+
+static int __init efibc_init(void)
+{
+	int ret;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return 0;
+
+	ret = register_reboot_notifier(&efibc_reboot_notifier);
+	if (ret) {
+		pr_err("efibc: unable to register reboot notifier\n");
+		return ret;
+	}
+
+	ret = register_reboot_notifier(&efibc_reboot_reason_notifier);
+	if (ret) {
+		pr_err("efibc: unable to register reboot notifier\n");
+		unregister_reboot_notifier(&efibc_reboot_notifier);
+		return ret;
+	}
+
+	 atomic_notifier_chain_register(&panic_notifier_list, &paniced);
+
+	return 0;
+}
+module_init(efibc_init);
+
+static void __exit efibc_exit(void)
+{
+	unregister_reboot_notifier(&efibc_reboot_notifier);
+	unregister_reboot_notifier(&efibc_reboot_reason_notifier);
+	atomic_notifier_chain_unregister(&panic_notifier_list, &paniced);
+}
+module_exit(efibc_exit);
+
+MODULE_AUTHOR("Matt Gumbel <matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org");
+MODULE_DESCRIPTION("EFI bootloader communication module");
+MODULE_LICENSE("GPL v2");
-- 
2.5.0
