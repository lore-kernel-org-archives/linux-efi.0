From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 17/20] efivarfs: Replace magic number with sizeof(attributes)
Date: Fri, 26 Oct 2012 08:52:00 +0100
Message-ID: <1351237923-10313-18-git-send-email-matt@console-pimps.org>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Seeing "+ 4" littered throughout the functions gets a bit
confusing. Use "sizeof(attributes)" which clearly explains what
quantity we're adding.

Acked-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 3c31215..a6cec2f 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -801,7 +801,7 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return 0;
 
-	data = kmalloc(datasize + 4, GFP_KERNEL);
+	data = kmalloc(datasize + sizeof(attributes), GFP_KERNEL);
 
 	if (!data)
 		return 0;
@@ -810,7 +810,7 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 	status = efivars->ops->get_variable(var->var.VariableName,
 					    &var->var.VendorGuid,
 					    &attributes, &datasize,
-					    (data + 4));
+					    (data + sizeof(attributes)));
 	spin_unlock(&efivars->lock);
 
 	if (status != EFI_SUCCESS) {
@@ -818,9 +818,9 @@ static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
 		goto out_free;
 	}
 
-	memcpy(data, &attributes, 4);
+	memcpy(data, &attributes, sizeof(attributes));
 	size = simple_read_from_buffer(userbuf, count, ppos,
-					data, datasize + 4);
+				       data, datasize + sizeof(attributes));
 out_free:
 	kfree(data);
 
-- 
1.7.11.7
