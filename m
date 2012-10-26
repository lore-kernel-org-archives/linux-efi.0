From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 02/20] efi: Handle deletions and size changes in efivarfs_write_file
Date: Fri, 26 Oct 2012 08:51:45 +0100
Message-ID: <1351237923-10313-3-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

A write to an efivarfs file will not always result in a variable of
'count' size after the EFI SetVariable() call. We may have appended to
the existing data (ie, with the EFI_VARIABLE_APPEND_WRITE attribute), or
even have deleted the variable (with an authenticated variable update,
with a zero datasize).

This change re-reads the updated variable from firmware, to check for
size changes and deletions. In the latter case, we need to drop the
dentry.

Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 49 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index a1d6940..6d43bbd 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -658,6 +658,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	u32 attributes;
 	struct inode *inode = file->f_mapping->host;
 	int datasize = count - sizeof(attributes);
+	unsigned long newdatasize;
 
 	if (count < sizeof(attributes))
 		return -EINVAL;
@@ -696,32 +697,60 @@ static ssize_t efivarfs_file_write(struct file *file,
 
 	switch (status) {
 	case EFI_SUCCESS:
-		mutex_lock(&inode->i_mutex);
-		i_size_write(inode, count);
-		mutex_unlock(&inode->i_mutex);
 		break;
 	case EFI_INVALID_PARAMETER:
 		count = -EINVAL;
-		break;
+		goto out;
 	case EFI_OUT_OF_RESOURCES:
 		count = -ENOSPC;
-		break;
+		goto out;
 	case EFI_DEVICE_ERROR:
 		count = -EIO;
-		break;
+		goto out;
 	case EFI_WRITE_PROTECTED:
 		count = -EROFS;
-		break;
+		goto out;
 	case EFI_SECURITY_VIOLATION:
 		count = -EACCES;
-		break;
+		goto out;
 	case EFI_NOT_FOUND:
 		count = -ENOENT;
-		break;
+		goto out;
 	default:
 		count = -EINVAL;
-		break;
+		goto out;
 	}
+
+	/*
+	 * Writing to the variable may have caused a change in size (which
+	 * could either be an append or an overwrite), or the variable to be
+	 * deleted. Perform a GetVariable() so we can tell what actually
+	 * happened.
+	 */
+	newdatasize = 0;
+	status = efivars->ops->get_variable(var->var.VariableName,
+					    &var->var.VendorGuid,
+					    NULL, &newdatasize,
+					    NULL);
+
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		mutex_lock(&inode->i_mutex);
+		i_size_write(inode, newdatasize + sizeof(attributes));
+		mutex_unlock(&inode->i_mutex);
+
+	} else if (status == EFI_NOT_FOUND) {
+		spin_lock(&efivars->lock);
+		list_del(&var->list);
+		spin_unlock(&efivars->lock);
+		efivar_unregister(var);
+		drop_nlink(inode);
+		dput(file->f_dentry);
+
+	} else {
+		pr_warn("efivarfs: inconsistent EFI variable implementation? "
+				"status = %lx\n", status);
+	}
+
 out:
 	kfree(data);
 
-- 
1.7.11.7
