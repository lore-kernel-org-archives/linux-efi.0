From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] efi: libstub: Treat missing SecureBoot variable as S/B disabled
Date: Wed,  1 Mar 2017 19:04:35 +0000
Message-ID: <1488395076-29712-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1488395076-29712-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488395076-29712-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The newly refactored code that infers the firmware's Secure Boot state
prints the following error when the EFI variable 'SecureBoot' does not
exist:

  EFI stub: ERROR: Could not determine UEFI Secure Boot status.

However, this variable is only guaranteed to be defined on a system that
is Secure Boot capable to begin with, and so it is not an error if it is
missing. So report Secure Boot as being disabled in this case, without
printing any error messages.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/secureboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 6def402bf569..5da36e56b36a 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -45,6 +45,8 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 	size = sizeof(secboot);
 	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
 			     NULL, &size, &secboot);
+	if (status == EFI_NOT_FOUND)
+		return efi_secureboot_mode_disabled;
 	if (status != EFI_SUCCESS)
 		goto out_efi_err;
 
@@ -78,7 +80,5 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 
 out_efi_err:
 	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
-	if (status == EFI_NOT_FOUND)
-		return efi_secureboot_mode_disabled;
 	return efi_secureboot_mode_unknown;
 }
-- 
2.7.4
