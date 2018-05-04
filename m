From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 01/17] x86/xen/efi: Initialize UEFI secure boot state during dom0 boot
Date: Fri,  4 May 2018 07:59:47 +0200
Message-ID: <20180504060003.19618-2-ard.biesheuvel@linaro.org>
References: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Daniel Kiper <daniel.kiper@oracle.com>

Initialize UEFI secure boot state during dom0 boot. Otherwise the kernel
may not even know that it runs on secure boot enabled platform.

Note that part of drivers/firmware/efi/libstub/secureboot.c is duplicated
by this patch, only in this case, it runs in the context of the kernel
proper rather than UEFI boot context. The reason for the duplication is
that maintaining the original code to run correctly on ARM/arm64 as well
as on all the quirky x86 firmware we support is enough of a burden as it
is, and adding the x86/Xen execution context to that mix just so we can
reuse a single routine just isn't worth it.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
[ardb: explain rationale for code duplication]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/xen/efi.c                        | 57 +++++++++++++++++++++++
 drivers/firmware/efi/libstub/secureboot.c |  3 ++
 2 files changed, 60 insertions(+)

diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index a18703be9ead..1804b27f9632 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -115,6 +115,61 @@ static efi_system_table_t __init *xen_efi_probe(void)
 	return &efi_systab_xen;
 }
 
+/*
+ * Determine whether we're in secure boot mode.
+ *
+ * Please keep the logic in sync with
+ * drivers/firmware/efi/libstub/secureboot.c:efi_get_secureboot().
+ */
+static enum efi_secureboot_mode xen_efi_get_secureboot(void)
+{
+	static efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
+	static efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
+	efi_status_t status;
+	u8 moksbstate, secboot, setupmode;
+	unsigned long size;
+
+	size = sizeof(secboot);
+	status = efi.get_variable(L"SecureBoot", &efi_variable_guid,
+				  NULL, &size, &secboot);
+
+	if (status == EFI_NOT_FOUND)
+		return efi_secureboot_mode_disabled;
+
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	size = sizeof(setupmode);
+	status = efi.get_variable(L"SetupMode", &efi_variable_guid,
+				  NULL, &size, &setupmode);
+
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	if (secboot == 0 || setupmode == 1)
+		return efi_secureboot_mode_disabled;
+
+	/* See if a user has put the shim into insecure mode. */
+	size = sizeof(moksbstate);
+	status = efi.get_variable(L"MokSBStateRT", &shim_guid,
+				  NULL, &size, &moksbstate);
+
+	/* If it fails, we don't care why. Default to secure. */
+	if (status != EFI_SUCCESS)
+		goto secure_boot_enabled;
+
+	if (moksbstate == 1)
+		return efi_secureboot_mode_disabled;
+
+ secure_boot_enabled:
+	pr_info("UEFI Secure Boot is enabled.\n");
+	return efi_secureboot_mode_enabled;
+
+ out_efi_err:
+	pr_err("Could not determine UEFI Secure Boot status.\n");
+	return efi_secureboot_mode_unknown;
+}
+
 void __init xen_efi_init(void)
 {
 	efi_system_table_t *efi_systab_xen;
@@ -129,6 +184,8 @@ void __init xen_efi_init(void)
 	boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
 	boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
 
+	boot_params.secure_boot = xen_efi_get_secureboot();
+
 	set_bit(EFI_BOOT, &efi.flags);
 	set_bit(EFI_PARAVIRT, &efi.flags);
 	set_bit(EFI_64BIT, &efi.flags);
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 8f07eb414c00..72d9dfbebf08 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -30,6 +30,9 @@ static const efi_char16_t shim_MokSBState_name[] = L"MokSBState";
 
 /*
  * Determine whether we're in secure boot mode.
+ *
+ * Please keep the logic in sync with
+ * arch/x86/xen/efi.c:xen_efi_get_secureboot().
  */
 enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 {
-- 
2.17.0
