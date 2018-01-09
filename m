From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 1/4] efi/stub: Extract efi_get_secureboot() to separate file
Date: Tue,  9 Jan 2018 15:22:22 +0100
Message-ID: <1515507745-17391-2-git-send-email-daniel.kiper@oracle.com>
References: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515507745-17391-1-git-send-email-daniel.kiper@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org
Cc: ard.biesheuvel@linaro.org, boris.ostrovsky@oracle.com, hpa@zytor.com, jgross@suse.com, konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de
List-Id: linux-efi@vger.kernel.org

We have to call efi_get_secureboot() from early Xen dom0 boot code to properly
initialize boot_params.secure_boot. Sadly it lives in the EFI stub. Hence, it is
not readily reachable from the kernel proper. So, move efi_get_secureboot() to
separate file which can be included from the core kernel code. Subsequent patch
will add efi_get_secureboot() call from Xen dom0 boot code.

There is no functional change.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 drivers/firmware/efi/libstub/secureboot-core.c |   77 ++++++++++++++++++++++++
 drivers/firmware/efi/libstub/secureboot.c      |   66 +-------------------
 2 files changed, 78 insertions(+), 65 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/secureboot-core.c

diff --git a/drivers/firmware/efi/libstub/secureboot-core.c b/drivers/firmware/efi/libstub/secureboot-core.c
new file mode 100644
index 0000000..11a4feb
--- /dev/null
+++ b/drivers/firmware/efi/libstub/secureboot-core.c
@@ -0,0 +1,77 @@
+/*
+ * Secure boot handling.
+ *
+ * Copyright (C) 2013,2014 Linaro Limited
+ *     Roy Franz <roy.franz@linaro.org>
+ * Copyright (C) 2013 Red Hat, Inc.
+ *     Mark Salter <msalter@redhat.com>
+ *
+ * This file is part of the Linux kernel, and is made available under the
+ * terms of the GNU General Public License version 2.
+ */
+
+/* BIOS variables */
+static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
+static const efi_char16_t efi_SecureBoot_name[] = {
+	'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0
+};
+static const efi_char16_t efi_SetupMode_name[] = {
+	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
+};
+
+/* SHIM variables */
+static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
+static const efi_char16_t shim_MokSBState_name[] = {
+	'M', 'o', 'k', 'S', 'B', 'S', 't', 'a', 't', 'e', 0
+};
+
+/*
+ * Determine whether we're in secure boot mode.
+ */
+enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
+{
+	u32 attr;
+	u8 secboot, setupmode, moksbstate;
+	unsigned long size;
+	efi_status_t status;
+
+	size = sizeof(secboot);
+	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
+			     NULL, &size, &secboot);
+	if (status == EFI_NOT_FOUND)
+		return efi_secureboot_mode_disabled;
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	size = sizeof(setupmode);
+	status = get_efi_var(efi_SetupMode_name, &efi_variable_guid,
+			     NULL, &size, &setupmode);
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	if (secboot == 0 || setupmode == 1)
+		return efi_secureboot_mode_disabled;
+
+	/*
+	 * See if a user has put the shim into insecure mode. If so, and if the
+	 * variable doesn't have the runtime attribute set, we might as well
+	 * honor that.
+	 */
+	size = sizeof(moksbstate);
+	status = get_efi_var(shim_MokSBState_name, &shim_guid,
+			     &attr, &size, &moksbstate);
+
+	/* If it fails, we don't care why. Default to secure */
+	if (status != EFI_SUCCESS)
+		goto secure_boot_enabled;
+	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
+		return efi_secureboot_mode_disabled;
+
+secure_boot_enabled:
+	pr_efi(sys_table_arg, "UEFI Secure Boot is enabled.\n");
+	return efi_secureboot_mode_enabled;
+
+out_efi_err:
+	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
+	return efi_secureboot_mode_unknown;
+}
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 959777e..4a6159f 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -14,73 +14,9 @@
 
 #include "efistub.h"
 
-/* BIOS variables */
-static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
-static const efi_char16_t efi_SecureBoot_name[] = {
-	'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0
-};
-static const efi_char16_t efi_SetupMode_name[] = {
-	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
-};
-
-/* SHIM variables */
-static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
-static efi_char16_t const shim_MokSBState_name[] = {
-	'M', 'o', 'k', 'S', 'B', 'S', 't', 'a', 't', 'e', 0
-};
-
 #define get_efi_var(name, vendor, ...) \
 	efi_call_runtime(get_variable, \
 			 (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
 			 __VA_ARGS__);
 
-/*
- * Determine whether we're in secure boot mode.
- */
-enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
-{
-	u32 attr;
-	u8 secboot, setupmode, moksbstate;
-	unsigned long size;
-	efi_status_t status;
-
-	size = sizeof(secboot);
-	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
-			     NULL, &size, &secboot);
-	if (status == EFI_NOT_FOUND)
-		return efi_secureboot_mode_disabled;
-	if (status != EFI_SUCCESS)
-		goto out_efi_err;
-
-	size = sizeof(setupmode);
-	status = get_efi_var(efi_SetupMode_name, &efi_variable_guid,
-			     NULL, &size, &setupmode);
-	if (status != EFI_SUCCESS)
-		goto out_efi_err;
-
-	if (secboot == 0 || setupmode == 1)
-		return efi_secureboot_mode_disabled;
-
-	/*
-	 * See if a user has put the shim into insecure mode. If so, and if the
-	 * variable doesn't have the runtime attribute set, we might as well
-	 * honor that.
-	 */
-	size = sizeof(moksbstate);
-	status = get_efi_var(shim_MokSBState_name, &shim_guid,
-			     &attr, &size, &moksbstate);
-
-	/* If it fails, we don't care why. Default to secure */
-	if (status != EFI_SUCCESS)
-		goto secure_boot_enabled;
-	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
-		return efi_secureboot_mode_disabled;
-
-secure_boot_enabled:
-	pr_efi(sys_table_arg, "UEFI Secure Boot is enabled.\n");
-	return efi_secureboot_mode_enabled;
-
-out_efi_err:
-	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
-	return efi_secureboot_mode_unknown;
-}
+#include "secureboot-core.c"
-- 
1.7.10.4
