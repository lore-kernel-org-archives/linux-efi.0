From: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] efi: Clarify GUID length calculations
Date: Fri, 19 Oct 2012 15:16:45 +0800
Message-ID: <1350631005.801791.917065840255.1.gpush@pecola>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

At present, the handling of GUIDs in efivar file names isn't consistent.
We use GUID_LEN in some places, and 38 in others (GUID_LEN plus
separator), and implicitly use the presence of the trailing NUL.

This change removes the trailing NUL from GUID_LEN, so that we're
explicitly adding it when required. We also replace magic numbers
with GUID_LEN, and clarify the comments where appropriate.

We also fix the allocation size in efivar_create_sysfs_entry, where
we're allocating one byte too much, due to counting the trailing NUL
twice - once when calculating short_name_size, and once in the kzalloc.

Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

---
 drivers/firmware/efivars.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index a86eb55..ce0d6fa 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -95,7 +95,12 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION(EFIVARS_VERSION);
 
 #define DUMP_NAME_LEN 52
-#define GUID_LEN 37
+
+/*
+ * Length of a GUID string (strlen("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"))
+ * not including trailing NUL
+ */
+#define GUID_LEN 36
 
 /*
  * The maximum size of VariableName + Data = 1024
@@ -876,7 +881,9 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
 
-	if (dentry->d_name.len < 38)
+	/* We need a GUID, plus at least one letter for the variable name,
+	 * plus the '-' separator */
+	if (dentry->d_name.len < GUID_LEN + 2)
 		return -EINVAL;
 
 	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
@@ -889,7 +896,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 		goto out;
 	}
 
-	namelen = dentry->d_name.len - GUID_LEN;
+	/* length of the variable name itself: remove GUID and separator */
+	namelen = dentry->d_name.len - GUID_LEN - 1;
 
 	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
 			&var->var.VendorGuid);
@@ -983,8 +991,8 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 		len = utf16_strlen(entry->var.VariableName);
 
-		/* GUID plus trailing NULL */
-		name = kmalloc(len + 38, GFP_ATOMIC);
+		/* name, plus '-', plus GUID, plus NUL*/
+		name = kmalloc(len + 1 + GUID_LEN + 1, GFP_ATOMIC);
 		if (!name)
 			goto fail;
 
@@ -995,7 +1003,7 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 		efi_guid_unparse(&entry->var.VendorGuid, name + len + 1);
 
-		name[len+GUID_LEN] = '\0';
+		name[len+GUID_LEN+1] = '\0';
 
 		inode = efivarfs_get_inode(efivarfs_sb, root->d_inode,
 					  S_IFREG | 0644, 0);
@@ -1424,11 +1432,16 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 			  efi_char16_t *variable_name,
 			  efi_guid_t *vendor_guid)
 {
-	int i, short_name_size = variable_name_size / sizeof(efi_char16_t) + 38;
+	int i, short_name_size;
 	char *short_name;
 	struct efivar_entry *new_efivar;
 
-	short_name = kzalloc(short_name_size + 1, GFP_KERNEL);
+	/* Length of the variable bytes in ASCII, plus the '-' separator,
+	 * plus the GUID, plus trailing NUL */
+	short_name_size = variable_name_size / sizeof(efi_char_16_t)
+				+ 1 + GUID_LEN + 1;
+
+	short_name = kzalloc(short_name_size, GFP_KERNEL);
 	new_efivar = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
 
 	if (!short_name || !new_efivar)  {
--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
