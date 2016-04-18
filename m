From: jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org (Compostella, Jeremy)
Subject: Re: [PATCH] efibc: EFI Bootloader Control
Date: Mon, 18 Apr 2016 15:05:42 +0200
Message-ID: <87mvor83tl.fsf@jcompost-MOBL1.tl.intel.com>
References: <87bn5tlbkw.fsf@jcompost-MOBL1.tl.intel.com>
	<20160414160006.GR2829@codeblueprint.co.uk>
	<87r3e383v7.fsf@jcompost-MOBL1.tl.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87r3e383v7.fsf-e2kLcBBGnpIIbNWpFUBdLQzuBQEzu/OPQQ4Iyu8u01E@public.gmane.org> (Jeremy
	Compostella's message of "Mon, 18 Apr 2016 15:04:44 +0200")
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
"reboot", "shutdown".  The bootloader reads this reboot reason and
takes particular action according to its policy.

There are reboot implementations that do "reboot <reason>", such as
Android's reboot command and Upstart's reboot replacement, which pass
the reason as an argument to the reboot syscall.  There is no
platform-agnostic way how those could be modified to pass the reason
to the bootloader, regardless of platform or bootloader.

Signed-off-by: Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/Kconfig  |  15 +++++++
 drivers/firmware/efi/Makefile |   1 +
 drivers/firmware/efi/efibc.c  | 101 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |   4 ++
 4 files changed, 121 insertions(+)
 create mode 100644 drivers/firmware/efi/efibc.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index e1670d5..0b0b635 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -87,6 +87,21 @@ config EFI_RUNTIME_WRAPPERS
 config EFI_ARMSTUB
 	bool
 
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
+	  set with the reboot reason: "reboot" or "shutdown". The
+	  bootloader reads this reboot reason and takes particular
+	  action according to its policy.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 62e654f..c35e218 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
 obj-$(CONFIG_EFI_STUB)			+= libstub/
 obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
+obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
 
 arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
 obj-$(CONFIG_ARM)			+= $(arm-obj-y)
diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
new file mode 100644
index 0000000..9833ef5
--- /dev/null
+++ b/drivers/firmware/efi/efibc.c
@@ -0,0 +1,101 @@
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
+#define pr_fmt(fmt) "efibc: " fmt
+
+#include <linux/efi.h>
+#include <linux/module.h>
+#include <linux/reboot.h>
+
+static void efibc_str_to_str16(const char *str, efi_char16_t *str16)
+{
+	size_t i;
+
+	for (i = 0; i < strlen(str); i++)
+		str16[i] = str[i];
+
+	str16[i] = '\0';
+}
+
+static void efibc_set_variable(const char *name, const char *value)
+{
+	int ret;
+	efi_guid_t guid = EFI_LOADER_GUID;
+	struct efivar_entry entry;
+	size_t size = (strlen(value) + 1) * sizeof(efi_char16_t);
+
+	if (size > sizeof(entry.var.Data))
+		pr_err("value is too large");
+
+	efibc_str_to_str16(name, entry.var.VariableName);
+	efibc_str_to_str16(value, (efi_char16_t *)entry.var.Data);
+	memcpy(&entry.var.VendorGuid, &guid, sizeof(guid));
+
+	ret = efivar_entry_set(&entry,
+			       EFI_VARIABLE_NON_VOLATILE
+			       | EFI_VARIABLE_BOOTSERVICE_ACCESS
+			       | EFI_VARIABLE_RUNTIME_ACCESS,
+			       size, entry.var.Data, NULL);
+	if (ret)
+		pr_err("failed to set %s EFI variable: 0x%x\n",
+		       name, ret);
+}
+
+static int efibc_reboot_notifier_call(struct notifier_block *notifier,
+				      unsigned long event, void *data)
+{
+	char *reason = "shutdown";
+
+	if (event == SYS_RESTART)
+		reason = "reboot";
+
+	efibc_set_variable("LoaderEntryRebootReason", reason);
+
+	if (!data)
+		return NOTIFY_DONE;
+
+	efibc_set_variable("LoaderEntryOneShot", (char *)data);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block efibc_reboot_notifier = {
+	.notifier_call = efibc_reboot_notifier_call,
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
+	if (ret)
+		pr_err("unable to register reboot notifier\n");
+
+	return ret;
+}
+module_init(efibc_init);
+
+static void __exit efibc_exit(void)
+{
+	unregister_reboot_notifier(&efibc_reboot_notifier);
+}
+module_exit(efibc_exit);
+
+MODULE_AUTHOR("Jeremy Compostella <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>");
+MODULE_AUTHOR("Matt Gumbel <matthew.k.gumbel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org");
+MODULE_DESCRIPTION("EFI Bootloader Control");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1626474..8dbf034 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -623,6 +623,10 @@ void efi_native_runtime_setup(void);
 	EFI_GUID(0x3152bca5, 0xeade, 0x433d, \
 		 0x86, 0x2e, 0xc0, 0x1c, 0xdc, 0x29, 0x1f, 0x44)
 
+#define EFI_LOADER_GUID \
+	EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf, \
+		 0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
-- 
1.9.1
