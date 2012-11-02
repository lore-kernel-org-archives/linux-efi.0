From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 21/20] efivarfs: Fix return value of efivarfs_file_write()
Date: Fri, 02 Nov 2012 08:54:03 +0000
Message-ID: <1351846443.14888.158.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

We're stuffing a variable of type size_t (unsigned) into a ssize_t
(signed) which, even though both types should be the same number of
bits, it's just asking for sign issues to be introduced.

Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Reported-by: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 58cec62..9ac9340 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -694,6 +694,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	struct inode *inode = file->f_mapping->host;
 	unsigned long datasize = count - sizeof(attributes);
 	unsigned long newdatasize;
+	ssize_t bytes = 0;
 
 	if (count < sizeof(attributes))
 		return -EINVAL;
@@ -706,22 +707,22 @@ static ssize_t efivarfs_file_write(struct file *file,
 	efivars = var->efivars;
 
 	if (copy_from_user(&attributes, userbuf, sizeof(attributes))) {
-		count = -EFAULT;
+		bytes = -EFAULT;
 		goto out;
 	}
 
 	if (attributes & ~(EFI_VARIABLE_MASK)) {
-		count = -EINVAL;
+		bytes = -EINVAL;
 		goto out;
 	}
 
 	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
-		count = -EFAULT;
+		bytes = -EFAULT;
 		goto out;
 	}
 
 	if (validate_var(&var->var, data, datasize) == false) {
-		count = -EINVAL;
+		bytes = -EINVAL;
 		goto out;
 	}
 
@@ -744,6 +745,8 @@ static ssize_t efivarfs_file_write(struct file *file,
 		return efi_status_to_err(status);
 	}
 
+	bytes = count;
+
 	/*
 	 * Writing to the variable may have caused a change in size (which
 	 * could either be an append or an overwrite), or the variable to be
@@ -778,7 +781,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 out:
 	kfree(data);
 
-	return count;
+	return bytes;
 }
 
 static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
-- 
1.7.11.7
