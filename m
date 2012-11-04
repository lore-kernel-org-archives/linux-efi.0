From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 01/20] efi: Add support for a UEFI variable filesystem
Date: Sun, 04 Nov 2012 20:27:58 +0000
Message-ID: <1352060878.14888.193.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
	 <1351846416.14888.155.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20121103002249.63eb4142@pyramind.ukuu.org.uk>
	 <20121103002132.GB18691@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121103002132.GB18691-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 2012-11-03 at 00:21 +0000, Matthew Garrett wrote:
> Yeah. It's fair that this should be limited to whatever 
> QueryVariableInfo() returns on systems that have that, and say 64K on 
> older systems.

Folks how about something like this (compile-tested only)?

---

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 9ac9340..b75fdf2 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -694,28 +694,54 @@ static ssize_t efivarfs_file_write(struct file *file,
 	struct inode *inode = file->f_mapping->host;
 	unsigned long datasize = count - sizeof(attributes);
 	unsigned long newdatasize;
+	u64 storage_size, remaining_size, max_size;
 	ssize_t bytes = 0;
 
 	if (count < sizeof(attributes))
 		return -EINVAL;
 
-	data = kmalloc(datasize, GFP_KERNEL);
+	if (copy_from_user(&attributes, userbuf, sizeof(attributes)))
+		return -EFAULT;
 
-	if (!data)
-		return -ENOMEM;
+	if (attributes & ~(EFI_VARIABLE_MASK))
+		return -EINVAL;
 
 	efivars = var->efivars;
 
-	if (copy_from_user(&attributes, userbuf, sizeof(attributes))) {
-		bytes = -EFAULT;
-		goto out;
+	/*
+	 * Ensure that the user can't allocate arbitrarily large
+	 * amounts of memory. Pick a default size of 64K if
+	 * QueryVariableInfo() isn't supported by the firmware.
+	 */
+	spin_lock(&efivars->lock);
+
+	if (!efivars->ops->query_variable_info)
+		status = EFI_UNSUPPORTED;
+	else {
+		const struct efivar_operations *fops = efivars->ops;
+		status = fops->query_variable_info(attributes, &storage_size,
+						   &remaining_size, &max_size);
 	}
 
-	if (attributes & ~(EFI_VARIABLE_MASK)) {
-		bytes = -EINVAL;
-		goto out;
+	spin_unlock(&efivars->lock);
+
+	if (status != EFI_SUCCESS) {
+		if (status != EFI_UNSUPPORTED)
+			return efi_status_to_err(status);
+
+		remaining_size = 65536;
+	}
+
+	if (datasize > remaining_size) {
+		printk(KERN_ERR "efivars: Variable size too big\n");
+		return -ENOSPC;
 	}
 
+	data = kmalloc(datasize, GFP_KERNEL);
+
+	if (!data)
+		return -ENOMEM;
+
 	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
 		bytes = -EFAULT;
 		goto out;
@@ -1709,6 +1735,9 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
+#ifdef CONFIG_X86
+	ops.query_variable_info = efi.query_variable_info;
+#endif
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5e2308d..f80079c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -646,6 +646,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_query_variable_info_t *query_variable_info;
 };
 
 struct efivars {


-- 
Matt Fleming, Intel Open Source Technology Center
