From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH 01/20] efi: Add support for a UEFI variable filesystem
Date: Fri, 26 Oct 2012 11:10:39 +0100
Message-ID: <20121026111039.4802a3c2@pyramind.ukuu.org.uk>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	<1351237923-10313-2-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351237923-10313-2-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> +static ssize_t efivarfs_file_write(struct file *file,
> +		const char __user *userbuf, size_t count, loff_t *ppos)
> +{
> +	struct efivar_entry *var = file->private_data;
> +	struct efivars *efivars;
> +	efi_status_t status;
> +	void *data;
> +	u32 attributes;
> +	struct inode *inode = file->f_mapping->host;
> +	int datasize = count - sizeof(attributes);

long ?

> +
> +	if (count < sizeof(attributes))
> +		return -EINVAL;
> +
> +	data = kmalloc(datasize, GFP_KERNEL);

This allows anyone who can open the file to allocate enormous amounts of
memory ... there should probably be a sanity check size here ?

> +	if (!data)
> +		return -ENOMEM;
> +
> +	efivars = var->efivars;
> +
> +	if (copy_from_user(&attributes, userbuf, sizeof(attributes))) {
> +		count = -EFAULT;

Nope.. size_t is not necessarily signed. ssize_t is. This probably
happens to do the right thing but it's not really right.

> +	switch (status) {
> +	case EFI_SUCCESS:

Would it make sense for EFI to have a generic 'efi_to_errno' ?

> +static ssize_t efivarfs_file_read(struct file *file, char __user *userbuf,
> +		size_t count, loff_t *ppos)
> +{
> +	struct efivar_entry *var = file->private_data;
> +	struct efivars *efivars = var->efivars;
> +	efi_status_t status;
> +	unsigned long datasize = 0;
> +	u32 attributes;
> +	void *data;
> +	ssize_t size;
> +
> +	status = efivars->ops->get_variable(var->var.VariableName,
> +					    &var->var.VendorGuid,
> +					    &attributes, &datasize, NULL);
> +
> +	if (status != EFI_BUFFER_TOO_SMALL)
> +		return 0;

This seems odd - the writer translates error codes this doesnt.
> +
> +	data = kmalloc(datasize + 4, GFP_KERNEL);

Are you sure the firmware will never hand back insane datasize values ?

> +static const struct file_operations efivarfs_file_operations = {
> +	.open	= efivarfs_file_open,
> +	.read	= efivarfs_file_read,
> +	.write	= efivarfs_file_write,
> +	.llseek	= default_llseek,

But you don't implement llseek in your read/write methods ?

> +		/* GUID plus trailing NULL */
> +		name = kmalloc(len + 38, GFP_ATOMIC);
> +
> +		for (i = 0; i < len; i++)
> +			name[i] = entry->var.VariableName[i] & 0xFF;

Unchecked kmalloc - and an atomic one at that.

> +		dentry = d_alloc_name(root, name);

...
