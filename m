From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] efi: make our variable validation list include the guid (v3)
Date: Thu,  4 Feb 2016 10:34:33 -0500
Message-ID: <1454600074-14854-5-git-send-email-pjones@redhat.com>
References: <1454600074-14854-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454600074-14854-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

v2 correctly checks the guid for validation *as well as* attribute
whitelisting.
v3 moves the sorting of variable_validate here and adds a comment about
it.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/efivars.c |  5 ++--
 drivers/firmware/efi/vars.c    | 52 +++++++++++++++++++++++++++---------------
 include/linux/efi.h            |  3 ++-
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index cd53c4d..e0b1e37 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -221,7 +221,7 @@ sanity_check(struct efi_variable *var, efi_char16_t *name, efi_guid_t vendor,
 	}
 
 	if ((attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    efivar_validate(name, data, size) == false) {
+	    efivar_validate(vendor, name, data, size) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
@@ -447,7 +447,8 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	}
 
 	if ((attributes & ~EFI_VARIABLE_MASK) != 0 ||
-	    efivar_validate(name, data, size) == false) {
+	    efivar_validate(new_var->VendorGuid, name, data,
+			    size) == false) {
 		printk(KERN_ERR "efivars: Malformed variable content\n");
 		return -EINVAL;
 	}
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 36c5a6e..0fc9194 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -165,31 +165,42 @@ validate_ascii_string(efi_char16_t *var_name, int match, u8 *buffer,
 }
 
 struct variable_validate {
+	efi_guid_t vendor;
 	char *name;
 	bool (*validate)(efi_char16_t *var_name, int match, u8 *data,
 			 unsigned long len);
 };
 
+/*
+ * This is the list of variables we need to validate.
+ *
+ * If it has a validate() method that's not NULL, it'll go into the
+ * validation routine.  If not, it is assumed valid.
+ *
+ * Note that it's sorted by {vendor,name}, but globbed names must come after
+ * any other name with the same prefix.
+ */
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
+	{ EFI_GLOBAL_VARIABLE_GUID, "Boot*", validate_load_option },
+	{ EFI_GLOBAL_VARIABLE_GUID, "DriverOrder", validate_boot_order },
+	{ EFI_GLOBAL_VARIABLE_GUID, "Driver*", validate_load_option },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ConIn", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ConInDev", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ConOut", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ConOutDev", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOut", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "ErrOutDev", validate_device_path },
+	{ EFI_GLOBAL_VARIABLE_GUID, "Lang", validate_ascii_string },
+	{ EFI_GLOBAL_VARIABLE_GUID, "PlatformLang", validate_ascii_string },
+	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", validate_uint16 },
+	{ NULL_GUID, "", NULL },
 };
 
 bool
-efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
+efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
+		unsigned long len)
 {
 	int i;
 	unsigned long utf8_size;
@@ -202,9 +213,12 @@ efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
 
 	ucs2_as_utf8(utf8_name, var_name, len);
 
-	for (i = 0; variable_validate[i].validate != NULL; i++) {
+	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
 		const char *name = variable_validate[i].name;
-		int match;
+		int match = 0;
+
+		if (efi_guidcmp(vendor, variable_validate[i].vendor))
+			continue;
 
 		for (match = 0; ; match++) {
 			char c = name[match];
@@ -861,7 +875,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 
 	*set = false;
 
-	if (efivar_validate(name, data, *size) == false)
+	if (efivar_validate(*vendor, name, data, *size) == false)
 		return -EINVAL;
 
 	/*
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 569b5a8..52444fd 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1199,7 +1199,8 @@ int efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
 struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 				       struct list_head *head, bool remove);
 
-bool efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len);
+bool efivar_validate(efi_guid_t vendor, efi_char16_t *var_name, u8 *data,
+		     unsigned long len);
 
 extern struct work_struct efivar_work;
 void efivar_run_worker(void);
-- 
2.5.0
