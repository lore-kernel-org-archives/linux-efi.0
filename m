From: jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org (Compostella, Jeremy)
Subject: [PATCH] efibc: EFI Bootloader Control
Date: Fri, 01 Apr 2016 15:09:51 +0200
Message-ID: <87bn5tlbkw.fsf@jcompost-MOBL1.tl.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Stanacar, Stefan" <stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This module installs a reboot hook, such that if reboot() is invoked
with a string argument NNN, "NNN" is copied to the
"LoaderEntryOneShot" EFI variable, to be read by the bootloader. If
the string matches one of the boot labels defined in its
configuration, the bootloader will boot once to that label.  The
"LoaderEntryRebootReason" EFI variable is set with the reboot reason:
"reboot", "shutdown", "kernel_panic" or "watchdog".  The bootloader
reads this reboot reason and takes particular action according to its
policy.

Signed-off-by: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/Kconfig               |  16 ++++
 arch/x86/platform/efi/Makefile |   1 +
 arch/x86/platform/efi/efibc.c  | 164 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+)
 create mode 100644 arch/x86/platform/efi/efibc.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2dc18605..cd4b6e4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -432,6 +432,22 @@ config X86_EXTENDED_PLATFORM
 	  generic distribution kernel, say Y here - otherwise say N.
 endif
 
+config EFI_BOOTLOADER_CONTROL
+	tristate "EFI Bootloader Control"
+	depends on EFI_VARS
+	default n
+	---help---
+	  This module installs a reboot hook, such that if reboot() is
+	  invoked with a string argument NNN, "NNN" is copied to the
+	  "LoaderEntryOneShot" EFI variable, to be read by the
+	  bootloader. If the string matches one of the boot labels
+	  defined in its configuration, the bootloader will boot once
+	  to that label. The "LoaderEntryRebootReason" EFI variable is
+	  set with the reboot reason: "reboot", "shutdown",
+	  "kernel_panic" or "watchdog". The bootloader reads this
+	  reboot reason and takes particular action according to its
+	  policy.
+
 if X86_64
 config X86_EXTENDED_PLATFORM
 	bool "Support for extended (non-PC) x86 platforms"
diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index 066619b..05cf769 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
 obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
 obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
+obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
diff --git a/arch/x86/platform/efi/efibc.c b/arch/x86/platform/efi/efibc.c
new file mode 100644
index 0000000..8ca8b43
--- /dev/null
+++ b/arch/x86/platform/efi/efibc.c
@@ -0,0 +1,164 @@
+/*
+ * efibc: control EFI bootloaders which obey LoaderEntryOneShot var
+ * Copyright (c) 2013-2016, Intel Corporation.
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
+
+#include <linux/efi.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/reboot.h>
+#include <linux/kexec.h>
+#include <linux/slab.h>
+#include <linux/nls.h>
+
+#define MODULE_NAME "efibc"
+
+static const efi_guid_t LOADER_GUID =
+	EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf,
+		 0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f);
+
+static const char REBOOT_TARGET[] = "LoaderEntryOneShot";
+static const char REBOOT_REASON[] = "LoaderEntryRebootReason";
+
+static const char * const WDT_SOURCE_PREFIX[] = {
+	"Kernel Watchdog", "Watchdog", "softlockup", "Software Watchdog"
+};
+
+static void efibc_str_to_str16(const char *str, wchar_t *str16)
+{
+	size_t size = strlen(str) + 1;
+
+	utf8s_to_utf16s(str, size, UTF16_LITTLE_ENDIAN, str16,
+			size * sizeof(*str16) / sizeof(*str));
+	str16[size - 1] = '\0';
+}
+
+static struct efivar_entry *efibc_get_var_entry(const char *name)
+{
+	wchar_t name16[strlen(name) + 1];
+	struct efivar_entry *entry;
+
+	efibc_str_to_str16(name, name16);
+
+	efivar_entry_iter_begin();
+	entry = efivar_entry_find(name16, LOADER_GUID,
+				  &efivar_sysfs_list, false);
+	efivar_entry_iter_end();
+
+	return entry;
+}
+
+static void efibc_set_variable(const char *name, const char *value)
+{
+	u32 attributes = EFI_VARIABLE_NON_VOLATILE
+		| EFI_VARIABLE_BOOTSERVICE_ACCESS
+		| EFI_VARIABLE_RUNTIME_ACCESS;
+	wchar_t name16[strlen(name) + 1];
+	wchar_t value16[strlen(value) + 1];
+	int ret;
+
+	efibc_str_to_str16(name, name16);
+	efibc_str_to_str16(value, value16);
+
+	ret = efivar_entry_set_safe(name16, LOADER_GUID, attributes, true,
+				    sizeof(value16), value16);
+	if (ret)
+		pr_err(MODULE_NAME ": failed to set %s EFI variable: 0x%x\n",
+		       name, ret);
+}
+
+static int efibc_reboot_notifier_call(struct notifier_block *notifier,
+				      unsigned long what, void *data)
+{
+	char *reason = what == SYS_RESTART ? "reboot" : "shutdown";
+
+	efibc_set_variable(REBOOT_REASON, reason);
+
+	if (!data)
+		return NOTIFY_DONE;
+
+	efibc_set_variable(REBOOT_TARGET, (char *)data);
+
+	return NOTIFY_DONE;
+}
+
+static bool is_watchdog_source(const char *str)
+{
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(WDT_SOURCE_PREFIX); i++)
+		if (!strncmp(str, WDT_SOURCE_PREFIX[i],
+			     strlen(WDT_SOURCE_PREFIX[i])))
+			return true;
+
+	return false;
+}
+
+static int efibc_panic_notifier_call(struct notifier_block *notifier,
+				     unsigned long what, void *data)
+{
+	char *reason;
+
+	/* If the reboot reason has already been supplied, keep it. */
+	if (efibc_get_var_entry(REBOOT_REASON))
+		return NOTIFY_DONE;
+
+	if (data && is_watchdog_source((char *)data))
+		reason = "watchdog";
+	else
+		reason = "kernel_panic";
+
+	efibc_set_variable(REBOOT_REASON, reason);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block efibc_reboot_notifier = {
+	.notifier_call = efibc_reboot_notifier_call,
+};
+
+static struct notifier_block efibc_panic_notifier = {
+	.notifier_call  = efibc_panic_notifier_call,
+};
+
+static int __init efibc_init(void)
+{
+	int ret;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
+	ret = register_reboot_notifier(&efibc_reboot_notifier);
+	if (ret) {
+		pr_err(MODULE_NAME ": unable to register reboot notifier\n");
+		return ret;
+	}
+
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &efibc_panic_notifier);
+
+	return 0;
+}
+module_init(efibc_init);
+
+static void __exit efibc_exit(void)
+{
+	unregister_reboot_notifier(&efibc_reboot_notifier);
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &efibc_panic_notifier);
+}
+module_exit(efibc_exit);
+
+MODULE_AUTHOR("Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>");
+MODULE_AUTHOR("Matt Gumbel <matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org");
+MODULE_DESCRIPTION("EFI Bootloader Control");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1
