From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] efi: use ucs2_as_utf8 in efivarfs instead of open coding a bad version (v3)
Date: Mon,  8 Feb 2016 14:48:12 -0500
Message-ID: <1454960895-3473-3-git-send-email-pjones@redhat.com>
References: <20160204234211.GI2586@codeblueprint.co.uk>
 <1454960895-3473-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454960895-3473-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Translate EFI's UCS-2 variable names to UTF-8 instead of just assuming
all variable names fit in ASCII.

v2: fix where I'd accidentally left some of the sizes off when
    converting the variable name strings.
v3: rework efivar_create_sysfs_entry not to have extra variables and not
    to call strlen() over and over on the same string.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>

An earlier version that's not hugely different was:
Tested-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/firmware/efi/efivars.c | 30 +++++++++++-------------------
 fs/efivarfs/super.c            |  7 +++----
 2 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 756eca8..f4ff8ab 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -540,38 +540,30 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 static int
 efivar_create_sysfs_entry(struct efivar_entry *new_var)
 {
-	int i, short_name_size;
+	int short_name_size;
 	char *short_name;
-	unsigned long variable_name_size;
-	efi_char16_t *variable_name;
+	unsigned long utf8_name_size;
+	efi_char16_t *variable_name = new_var->var.VariableName;
 	int ret;
 
-	variable_name = new_var->var.VariableName;
-	variable_name_size = ucs2_strlen(variable_name) * sizeof(efi_char16_t);
-
 	/*
-	 * Length of the variable bytes in ASCII, plus the '-' separator,
+	 * Length of the variable bytes in UTF8, plus the '-' separator,
 	 * plus the GUID, plus trailing NUL
 	 */
-	short_name_size = variable_name_size / sizeof(efi_char16_t)
-				+ 1 + EFI_VARIABLE_GUID_LEN + 1;
-
-	short_name = kzalloc(short_name_size, GFP_KERNEL);
+	utf8_name_size = ucs2_utf8size(variable_name);
+	short_name_size = utf8_name_size + 1 + EFI_VARIABLE_GUID_LEN + 1;
 
+	short_name = kmalloc(short_name_size, GFP_KERNEL);
 	if (!short_name)
 		return -ENOMEM;
 
-	/* Convert Unicode to normal chars (assume top bits are 0),
-	   ala UTF-8 */
-	for (i=0; i < (int)(variable_name_size / sizeof(efi_char16_t)); i++) {
-		short_name[i] = variable_name[i] & 0xFF;
-	}
+	ucs2_as_utf8(short_name, variable_name, short_name_size);
+
 	/* This is ugly, but necessary to separate one vendor's
 	   private variables from another's.         */
-
-	*(short_name + strlen(short_name)) = '-';
+	short_name[utf8_name_size] = '-';
 	efi_guid_to_str(&new_var->var.VendorGuid,
-			 short_name + strlen(short_name));
+			 short_name + utf8_name_size + 1);
 
 	new_var->kobj.kset = efivars_kset;
 
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index b8a564f..8651ac2 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -118,7 +118,7 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	struct dentry *dentry, *root = sb->s_root;
 	unsigned long size = 0;
 	char *name;
-	int len, i;
+	int len;
 	int err = -ENOMEM;
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
@@ -128,15 +128,14 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	memcpy(entry->var.VariableName, name16, name_size);
 	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(efi_guid_t));
 
-	len = ucs2_strlen(entry->var.VariableName);
+	len = ucs2_utf8size(entry->var.VariableName);
 
 	/* name, plus '-', plus GUID, plus NUL*/
 	name = kmalloc(len + 1 + EFI_VARIABLE_GUID_LEN + 1, GFP_KERNEL);
 	if (!name)
 		goto fail;
 
-	for (i = 0; i < len; i++)
-		name[i] = entry->var.VariableName[i] & 0xFF;
+	ucs2_as_utf8(name, entry->var.VariableName, len);
 
 	name[len] = '-';
 
-- 
2.5.0
