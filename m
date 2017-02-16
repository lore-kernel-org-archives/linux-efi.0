From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] efi: libstub: treat missing SecureBoot variable as S/B disabled
Date: Thu, 16 Feb 2017 18:08:23 +0000
Message-ID: <1487268503-21570-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The newly refactored code that infers the firmware's Secure Boot state
prints the following error when the variables 'SecureBoot' is missing.

  EFI stub: ERROR: Could not determine UEFI Secure Boot status.

However, this variable is only guaranteed to be defined on a system that
is Secure Boot capable to begin with, and so it is not an error if it is
missing. So report Secure Boot as being disabled in this case, without
printing any error messages.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
v2: treat SecureBoot present but SetupMode missing as 'unknown' not 'disabled'

 drivers/firmware/efi/libstub/secureboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 766ac06dac84..8fa8af4b3ca8 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -47,6 +47,8 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 	size = sizeof(secboot);
 	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
 			     NULL, &size, &secboot);
+	if (status == EFI_NOT_FOUND)
+		return efi_secureboot_mode_disabled;
 	if (status != EFI_SUCCESS)
 		goto out_efi_err;
 
@@ -80,7 +82,5 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 
 out_efi_err:
 	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
-	if (status == EFI_NOT_FOUND)
-		return efi_secureboot_mode_disabled;
 	return efi_secureboot_mode_unknown;
 }
-- 
2.7.4
