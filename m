From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 16/20] efivarfs: Return an error if we fail to read a variable
Date: Fri, 26 Oct 2012 08:51:59 +0100
Message-ID: <1351237923-10313-17-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Instead of always returning 0 in efivarfs_file_read(), even when we
fail to successfully read the variable, convert the EFI status to
something meaningful and return that to the caller. This way the user
will have some hint as to why the read failed.

Acked-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 58 +++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index c532854..3c31215 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -653,6 +653,36 @@ static int efivarfs_file_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int efi_status_to_err(efi_status_t status)
+{
+	int err;
+
+	switch (status) {
+	case EFI_INVALID_PARAMETER:
+		err = -EINVAL;
+		break;
+	case EFI_OUT_OF_RESOURCES:
+		err = -ENOSPC;
+		break;
+	case EFI_DEVICE_ERROR:
+		err = -EIO;
+		break;
+	case EFI_WRITE_PROTECTED:
+		err = -EROFS;
+		break;
+	case EFI_SECURITY_VIOLATION:
+		err = -EACCES;
+		break;
+	case EFI_NOT_FOUND:
+		err = -ENOENT;
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
 static ssize_t efivarfs_file_write(struct file *file,
 		const char __user *userbuf, size_t count, loff_t *ppos)
 {
@@ -711,29 +741,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 		spin_unlock(&efivars->lock);
 		kfree(data);
 
-		switch (status) {
-		case EFI_INVALID_PARAMETER:
-			count = -EINVAL;
-			break;
-		case EFI_OUT_OF_RESOURCES:
-			count = -ENOSPC;
-			break;
-		case EFI_DEVICE_ERROR:
-			count = -EIO;
-			break;
-		case EFI_WRITE_PROTECTED:
-			count = -EROFS;
-			break;
-		case EFI_SECURITY_VIOLATION:
-			count = -EACCES;
-			break;
-		case EFI_NOT_FOUND:
-			count = -ENOENT;
-			break;
-		default:
-			count = -EINVAL;
-		}
-		return count;
+		return efi_status_to_err(status);
 	}
 
 	/*
@@ -805,8 +813,10 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 					    (data + 4));
 	spin_unlock(&efivars->lock);
 
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		size = efi_status_to_err(status);
 		goto out_free;
+	}
 
 	memcpy(data, &attributes, 4);
 	size = simple_read_from_buffer(userbuf, count, ppos,
-- 
1.7.11.7
