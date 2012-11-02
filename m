From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH v2 16/20] efivarfs: Return an error if we fail to read a
 variable
Date: Fri, 02 Nov 2012 08:53:54 +0000
Message-ID: <1351846434.14888.157.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-17-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-17-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Instead of always returning 0 in efivarfs_file_read(), even when we
fail to successfully read the variable, convert the EFI status to
something meaningful and return that to the caller. This way the user
will have some hint as to why the read failed.

Acked-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

v2: Alan Cox noted that I missed a place to use efi_status_to_err() in
    the first version of this patch.

 drivers/firmware/efivars.c | 62 +++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index a93e401..277e426 100644
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
@@ -791,12 +799,12 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	spin_unlock(&efivars->lock);
 
 	if (status != EFI_BUFFER_TOO_SMALL)
-		return 0;
+		return efi_status_to_err(status);
 
 	data = kmalloc(datasize + 4, GFP_KERNEL);
 
 	if (!data)
-		return 0;
+		return -ENOMEM;
 
 	spin_lock(&efivars->lock);
 	status = efivars->ops->get_variable(var->var.VariableName,
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
