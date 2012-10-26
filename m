From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 15/20] efi: Clarify GUID length calculations
Date: Fri, 26 Oct 2012 08:51:58 +0100
Message-ID: <1351237923-10313-16-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

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
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 03e0df2..c532854 100644
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
@@ -887,7 +892,11 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
 
-	if (dentry->d_name.len < 38)
+	/*
+	 * We need a GUID, plus at least one letter for the variable name,
+	 * plus the '-' separator
+	 */
+	if (dentry->d_name.len < GUID_LEN + 2)
 		return -EINVAL;
 
 	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
@@ -900,7 +909,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 		goto out;
 	}
 
-	namelen = dentry->d_name.len - GUID_LEN;
+	/* length of the variable name itself: remove GUID and separator */
+	namelen = dentry->d_name.len - GUID_LEN - 1;
 
 	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
 			&var->var.VendorGuid);
@@ -994,8 +1004,8 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 		len = utf16_strlen(entry->var.VariableName);
 
-		/* GUID plus trailing NULL */
-		name = kmalloc(len + 38, GFP_ATOMIC);
+		/* name, plus '-', plus GUID, plus NUL*/
+		name = kmalloc(len + 1 + GUID_LEN + 1, GFP_ATOMIC);
 		if (!name)
 			goto fail;
 
@@ -1006,7 +1016,7 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 		efi_guid_unparse(&entry->var.VendorGuid, name + len + 1);
 
-		name[len+GUID_LEN] = '\0';
+		name[len+GUID_LEN+1] = '\0';
 
 		inode = efivarfs_get_inode(efivarfs_sb, root->d_inode,
 					  S_IFREG | 0644, 0);
@@ -1435,11 +1445,18 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 			  efi_char16_t *variable_name,
 			  efi_guid_t *vendor_guid)
 {
-	int i, short_name_size = variable_name_size / sizeof(efi_char16_t) + 38;
+	int i, short_name_size;
 	char *short_name;
 	struct efivar_entry *new_efivar;
 
-	short_name = kzalloc(short_name_size + 1, GFP_KERNEL);
+	/*
+	 * Length of the variable bytes in ASCII, plus the '-' separator,
+	 * plus the GUID, plus trailing NUL
+	 */
+	short_name_size = variable_name_size / sizeof(efi_char16_t)
+				+ 1 + GUID_LEN + 1;
+
+	short_name = kzalloc(short_name_size, GFP_KERNEL);
 	new_efivar = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
 
 	if (!short_name || !new_efivar)  {
-- 
1.7.11.7
