From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 1/2 v2] efivarfs: Validate filenames much more aggressively
Date: Tue, 12 Feb 2013 12:36:13 +0000
Message-ID: <20130212123613.GB14790@console-pimps.org>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360592935-26026-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The only thing that efivarfs does to enforce a valid filename is
ensure that the name isn't too short. We need to strongly sanitise any
filenames, not least because variable creation is delayed until
efivarfs_file_write(), which means we can't rely on the firmware to
inform us of an invalid name, because if the file is never written to
we'll never know it's invalid.

Perform a couple of steps before agreeing to create a new file,

  * Ensure the GUID only contains hexadecimal digits and dashes.

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

v2: Use Al's much improve filename parsing code and make
    efivarfs_valid_name() return the more natural boolean type.

 drivers/firmware/efivars.c | 49 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 371c441..868cea5 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -79,6 +79,7 @@
 #include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/pstore.h>
+#include <linux/ctype.h>
 
 #include <linux/fs.h>
 #include <linux/ramfs.h>
@@ -900,6 +901,48 @@ static struct inode *efivarfs_get_inode(struct super_block *sb,
 	return inode;
 }
 
+/*
+ * Return true if 'str' is a valid efivarfs filename of the form,
+ *
+ *	VariableName-12345678-1234-1234-1234-1234567891bc
+ */
+static bool efivarfs_valid_name(const char *str, int len)
+{
+	static const char dashes[GUID_LEN] = {
+		[8] = 1, [13] = 1, [18] = 1, [23] = 1
+	};
+	const char *s = str + len - GUID_LEN;
+	int i;
+
+	/*
+	 * We need a GUID, plus at least one letter for the variable name,
+	 * plus the '-' separator
+	 */
+	if (len < GUID_LEN + 2)
+		return false;
+
+	/* GUID should be right after the first '-' */
+	if (s - 1 != strchr(str, '-'))
+		return false;
+
+	/*
+	 * Validate that 's' is of the correct format, e.g.
+	 *
+	 *	12345678-1234-1234-1234-123456789abc
+	 */
+	for (i = 0; i < GUID_LEN; i++) {
+		if (dashes[i]) {
+			if (*s++ != '-')
+				return false;
+		} else {
+			if (!isxdigit(*s++))
+				return false;
+		}
+	}
+
+	return true;
+}
+
 static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
 {
 	guid->b[0] = hex_to_bin(str[6]) << 4 | hex_to_bin(str[7]);
@@ -928,11 +971,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
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
