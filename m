From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] efi: make our variable validation list include the guid
Date: Tue,  2 Feb 2016 17:33:05 -0500
Message-ID: <1454452386-27709-5-git-send-email-pjones@redhat.com>
References: <1454452386-27709-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454452386-27709-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We're not actually checking the guid in the validation code, but it
makes it easier to use the list for other things later.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 36c5a6e..e084d08 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -165,27 +165,28 @@ validate_ascii_string(efi_char16_t *var_name, int match, u8 *buffer,
 }
 
 struct variable_validate {
+	efi_guid_t guid;
 	char *name;
 	bool (*validate)(efi_char16_t *var_name, int match, u8 *data,
 			 unsigned long len);
 };
 
 static const struct variable_validate variable_validate[] = {
-	{ "BootNext", validate_uint16 },
-	{ "BootOrder", validate_boot_order },
-	{ "DriverOrder", validate_boot_order },
-	{ "Boot*", validate_load_option },
-	{ "Driver*", validate_load_option },
-	{ "ConIn", validate_device_path },
-	{ "ConInDev", validate_device_path },
-	{ "ConOut", validate_device_path },
-	{ "ConOutDev", validate_device_path },
-	{ "ErrOut", validate_device_path },
-	{ "ErrOutDev", validate_device_path },
-	{ "Timeout", validate_uint16 },
-	{ "Lang", validate_ascii_string },
-	{ "PlatformLang", validate_ascii_string },
-	{ "", NULL },
+	{ EFI_GLOBAL_VARIABLE_GUID, "BootNext", validate_uint16 },
+	{ EFI_GLOBAL_VARIABLE_GUID, "BootOrder", validate_boot_order },
+	{ EFI_GLOBAL_VARIABLE_GUID, "DriverOrder", validate_boot_order },
+	{ EFI_GLOBAL_VARIABLE_GUID, "Boot*", validate_load_option },
+	{ EFI_GLOBAL_VARIABLE_GUID, "Driver*", validate_load_option },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ConIn", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ConInDev", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ConOut", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ConOutDev", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOut", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOutDev", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", validate_uint16 },
+	{ EFI_GLOBAL_VARIABLE_GUID, "Lang", validate_ascii_string },
+	{ EFI_GLOBAL_VARIABLE_GUID, "PlatformLang", validate_ascii_string },
+	{ NULL_GUID, "", NULL },
 };
 
 bool
@@ -202,7 +203,7 @@ efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
 
 	ucs2_as_utf8(utf8_name, var_name, len);
 
-	for (i = 0; variable_validate[i].validate != NULL; i++) {
+	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
 		const char *name = variable_validate[i].name;
 		int match;
 
-- 
2.5.0
