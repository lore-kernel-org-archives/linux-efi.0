From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 09/20] efivarfs: efivarfs_file_read ensure we free data in error paths
Date: Fri, 26 Oct 2012 08:51:52 +0100
Message-ID: <1351237923-10313-10-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Signed-off-by: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Acked-by: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 4b12a8fd..ae50d2f 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -766,7 +766,7 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	unsigned long datasize = 0;
 	u32 attributes;
 	void *data;
-	ssize_t size;
+	ssize_t size = 0;
 
 	status = efivars->ops->get_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
@@ -784,13 +784,13 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 					    &var->var.VendorGuid,
 					    &attributes, &datasize,
 					    (data + 4));
-
 	if (status != EFI_SUCCESS)
-		return 0;
+		goto out_free;
 
 	memcpy(data, &attributes, 4);
 	size = simple_read_from_buffer(userbuf, count, ppos,
 					data, datasize + 4);
+out_free:
 	kfree(data);
 
 	return size;
-- 
1.7.11.7
