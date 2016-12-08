From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/8] efi: Disable secure boot if shim is in insecure mode
 [ver #6]
Date: Thu, 08 Dec 2016 12:30:53 +0000
Message-ID: <148120025337.5854.14162686732874030327.stgit@warthog.procyon.org.uk>
References: <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <148120020832.5854.5448601415491330495.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>

A user can manually tell the shim boot loader to disable validation of
images it loads.  When a user does this, it creates a UEFI variable called
MokSBState that does not have the runtime attribute set.  Given that the
user explicitly disabled validation, we can honor that and not enable
secure boot mode if that variable is set.

Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 drivers/firmware/efi/libstub/secureboot.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 62d6904da800..39c91e091f6a 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -23,6 +23,12 @@ static const efi_char16_t const efi_SetupMode_name[] = {
 	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
 };
 
+/* SHIM variables */
+static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
+static efi_char16_t const shim_MokSBState_name[] = {
+	'M', 'o', 'k', 'S', 'B', 'S', 't', 'a', 't', 'e', 0
+};
+
 #define get_efi_var(name, vendor, ...) \
 	efi_call_runtime(get_variable, \
 			 (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
@@ -33,7 +39,8 @@ static const efi_char16_t const efi_SetupMode_name[] = {
  */
 enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 {
-	u8 secboot, setupmode;
+	u32 attr;
+	u8 secboot, setupmode, moksbstate;
 	unsigned long size;
 	efi_status_t status;
 
@@ -52,6 +59,21 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 	if (secboot == 0 || setupmode == 1)
 		return efi_secureboot_mode_disabled;
 
+	/* See if a user has put shim into insecure mode.  If so, and if the
+	 * variable doesn't have the runtime attribute set, we might as well
+	 * honor that.
+	 */
+	size = sizeof(moksbstate);
+	status = get_efi_var(shim_MokSBState_name, &shim_guid,
+			     &attr, &size, &moksbstate);
+
+	/* If it fails, we don't care why.  Default to secure */
+	if (status != EFI_SUCCESS)
+		goto secure_boot_enabled;
+	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
+		return efi_secureboot_mode_disabled;
+
+secure_boot_enabled:
 	pr_efi(sys_table_arg, "UEFI Secure Boot is enabled.\n");
 	return efi_secureboot_mode_enabled;
 
