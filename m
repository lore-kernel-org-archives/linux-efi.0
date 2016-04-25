From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 25/40] efibc: EFI Bootloader Control
Date: Mon, 25 Apr 2016 21:06:57 +0100
Message-ID: <1461614832-17633-26-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Stefan Stanacar <stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Compostella, Jeremy" <jeremy.compostella-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

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
Cc: Stefan Stanacar <stefan.stanacar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/Kconfig  |  15 +++++++
 drivers/firmware/efi/Makefile |   1 +
 drivers/firmware/efi/efibc.c  | 101 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |   4 ++
 4 files changed, 121 insertions(+)
 create mode 100644 drivers/firmware/efi/efibc.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index e1670d533f97..0b0b635aa101 100644
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
index d5be62399130..b0808080e744 100644
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
index 000000000000..2e0c7ccd9d9e
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
+	efi_guid_t guid = LINUX_EFI_LOADER_ENTRY_GUID;
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
+	const char *reason = "shutdown";
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
index e53458842245..4db7052b2699 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -642,6 +642,10 @@ void efi_native_runtime_setup(void);
 	EFI_GUID(0xe03fc20a, 0x85dc, 0x406e, \
 		 0xb9, 0xe, 0x4a, 0xb5, 0x02, 0x37, 0x1d, 0x95)
 
+#define LINUX_EFI_LOADER_ENTRY_GUID \
+	EFI_GUID(0x4a67b082, 0x0a4c, 0x41cf, \
+		 0xb6, 0xc7, 0x44, 0x0b, 0x29, 0xbb, 0x8c, 0x4f)
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
-- 
2.7.3
