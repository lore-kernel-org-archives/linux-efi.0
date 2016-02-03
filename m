From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] efi: use ucs2_as_utf8 in efivarfs instead of open coding a bad version
Date: Wed,  3 Feb 2016 08:02:44 -0500
Message-ID: <1454504567-2826-2-git-send-email-pjones@redhat.com>
References: <1454504567-2826-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454504567-2826-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Translate EFI's UCS-2 variable names to UTF-8 instead of just assuming
all variable names fit in ASCII.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/efivars.c | 13 ++++---------
 fs/efivarfs/super.c            |  7 +++----
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 756eca8..eef6331 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -540,7 +540,7 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 static int
 efivar_create_sysfs_entry(struct efivar_entry *new_var)
 {
-	int i, short_name_size;
+	int short_name_size;
 	char *short_name;
 	unsigned long variable_name_size;
 	efi_char16_t *variable_name;
@@ -553,22 +553,17 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 	 * Length of the variable bytes in ASCII, plus the '-' separator,
 	 * plus the GUID, plus trailing NUL
 	 */
-	short_name_size = variable_name_size / sizeof(efi_char16_t)
-				+ 1 + EFI_VARIABLE_GUID_LEN + 1;
+	short_name_size = ucs2_utf8size(new_var->var.VariableName) + 1;
 
 	short_name = kzalloc(short_name_size, GFP_KERNEL);
 
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
 	*(short_name + strlen(short_name)) = '-';
 	efi_guid_to_str(&new_var->var.VendorGuid,
 			 short_name + strlen(short_name));
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
