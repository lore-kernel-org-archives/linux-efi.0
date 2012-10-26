From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 14/20] efivarfs: Implement exclusive access for {get,set}_variable
Date: Fri, 26 Oct 2012 08:51:57 +0100
Message-ID: <1351237923-10313-15-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Currently, efivarfs does not enforce exclusion over the get_variable and
set_variable operations. Section 7.1 of UEFI requires us to only allow a
single processor to enter {get,set}_variable services at once.

This change acquires the efivars->lock over calls to these operations
from the efivarfs paths.

Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 68 +++++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 25 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 2d67781..03e0df2 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -690,35 +690,45 @@ static ssize_t efivarfs_file_write(struct file *file,
 		goto out;
 	}
 
+	/*
+	 * The lock here protects the get_variable call, the conditional
+	 * set_variable call, and removal of the variable from the efivars
+	 * list (in the case of an authenticated delete).
+	 */
+	spin_lock(&efivars->lock);
+
 	status = efivars->ops->set_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    attributes, datasize,
 					    data);
 
-	switch (status) {
-	case EFI_SUCCESS:
-		break;
-	case EFI_INVALID_PARAMETER:
-		count = -EINVAL;
-		goto out;
-	case EFI_OUT_OF_RESOURCES:
-		count = -ENOSPC;
-		goto out;
-	case EFI_DEVICE_ERROR:
-		count = -EIO;
-		goto out;
-	case EFI_WRITE_PROTECTED:
-		count = -EROFS;
-		goto out;
-	case EFI_SECURITY_VIOLATION:
-		count = -EACCES;
-		goto out;
-	case EFI_NOT_FOUND:
-		count = -ENOENT;
-		goto out;
-	default:
-		count = -EINVAL;
-		goto out;
+	if (status != EFI_SUCCESS) {
+		spin_unlock(&efivars->lock);
+		kfree(data);
+
+		switch (status) {
+		case EFI_INVALID_PARAMETER:
+			count = -EINVAL;
+			break;
+		case EFI_OUT_OF_RESOURCES:
+			count = -ENOSPC;
+			break;
+		case EFI_DEVICE_ERROR:
+			count = -EIO;
+			break;
+		case EFI_WRITE_PROTECTED:
+			count = -EROFS;
+			break;
+		case EFI_SECURITY_VIOLATION:
+			count = -EACCES;
+			break;
+		case EFI_NOT_FOUND:
+			count = -ENOENT;
+			break;
+		default:
+			count = -EINVAL;
+		}
+		return count;
 	}
 
 	/*
@@ -734,12 +744,12 @@ static ssize_t efivarfs_file_write(struct file *file,
 					    NULL);
 
 	if (status == EFI_BUFFER_TOO_SMALL) {
+		spin_unlock(&efivars->lock);
 		mutex_lock(&inode->i_mutex);
 		i_size_write(inode, newdatasize + sizeof(attributes));
 		mutex_unlock(&inode->i_mutex);
 
 	} else if (status == EFI_NOT_FOUND) {
-		spin_lock(&efivars->lock);
 		list_del(&var->list);
 		spin_unlock(&efivars->lock);
 		efivar_unregister(var);
@@ -747,6 +757,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 		dput(file->f_dentry);
 
 	} else {
+		spin_unlock(&efivars->lock);
 		pr_warn("efivarfs: inconsistent EFI variable implementation? "
 				"status = %lx\n", status);
 	}
@@ -768,9 +779,11 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	void *data;
 	ssize_t size = 0;
 
+	spin_lock(&efivars->lock);
 	status = efivars->ops->get_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    &attributes, &datasize, NULL);
+	spin_unlock(&efivars->lock);
 
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return 0;
@@ -780,10 +793,13 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	if (!data)
 		return 0;
 
+	spin_lock(&efivars->lock);
 	status = efivars->ops->get_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    &attributes, &datasize,
 					    (data + 4));
+	spin_unlock(&efivars->lock);
+
 	if (status != EFI_SUCCESS)
 		goto out_free;
 
@@ -1004,11 +1020,13 @@ int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 		/* copied by the above to local storage in the dentry. */
 		kfree(name);
 
+		spin_lock(&efivars->lock);
 		efivars->ops->get_variable(entry->var.VariableName,
 					   &entry->var.VendorGuid,
 					   &entry->var.Attributes,
 					   &size,
 					   NULL);
+		spin_unlock(&efivars->lock);
 
 		mutex_lock(&inode->i_mutex);
 		inode->i_private = entry;
-- 
1.7.11.7
