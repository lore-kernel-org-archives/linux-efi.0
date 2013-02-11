From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 1/2] efivarfs: Validate filenames much more aggressively
Date: Mon, 11 Feb 2013 14:28:54 +0000
Message-ID: <1360592935-26026-2-git-send-email-matt@console-pimps.org>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360592935-26026-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The only thing that efivarfs does to enforce a valid filename is
ensure that the name isn't too short. We need to strongly sanitise any
filenames, not least because variable creation is delayed until
efivarfs_file_write(), which means we can't rely on the firmware to
inform us of an invalid name, because if the file is never written to
we'll never know it's invalid.

Perform a couple of steps before agreeing to create a new file,

  * hex_to_bin() returns a value indicating whether or not it was able
    to convert its arguments to a binary representation - we should
    check it.

  * Ensure that the GUID portion of the filename is the correct length
    and format.

  * The variable name portion of the filename needs to be at least one
    character in size.

Reported-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 55 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 371c441..a4fa409 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -900,6 +900,55 @@ static struct inode *efivarfs_get_inode(struct super_block *sb,
 	return inode;
 }
 
+/*
+ * Return 1 if 'str' is a valid efivarfs filename of the form,
+ *
+ *	VariableName-12345678-1234-1234-1234-1234567891bc
+ */
+static int efivarfs_valid_name(const char *str, int len)
+{
+	const char *s;
+	int i, j;
+	int ranges[2][5] = {
+		{ 0, 9, 14, 19, 24 },
+		{ 8, 13, 18, 23, 36 }
+	};
+
+	/*
+	 * We need a GUID, plus at least one letter for the variable name,
+	 * plus the '-' separator
+	 */
+	if (len < GUID_LEN + 2)
+		return 0;
+
+	s = strchr(str, '-');
+	if (!s)
+		return 0;
+
+	s++;			/* Skip '-' */
+
+	/* Ensure we have enough characters for a GUID */
+	if (len - (s - str) != GUID_LEN)
+		return 0;
+
+	/*
+	 * Validate that 's' is of the correct format, e.g.
+	 *
+	 *	12345678-1234-1234-1234-123456789abc
+	 */
+	for (i = 0; i < 5; i++) {
+		for (j = ranges[0][i]; j < ranges[1][i]; j++) {
+			if (hex_to_bin(s[j]) < 0)
+				return 0;
+		}
+
+		if (j < GUID_LEN && s[j] != '-')
+			return 0;
+	}
+
+	return 1;
+}
+
 static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
 {
 	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
@@ -928,11 +977,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 	struct efivar_entry *var;
 	int namelen, i = 0, err = 0;
 
-	/*
-	 * We need a GUID, plus at least one letter for the variable name,
-	 * plus the '-' separator
-	 */
-	if (dentry->d_name.len < GUID_LEN + 2)
+	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
 		return -EINVAL;
 
 	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
-- 
1.7.11.7
