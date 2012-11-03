From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 01/20] efi: Add support for a UEFI variable
 filesystem
Date: Sat, 3 Nov 2012 00:22:49 +0000
Message-ID: <20121103002249.63eb4142@pyramind.ukuu.org.uk>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	<1351237923-10313-2-git-send-email-matt@console-pimps.org>
	<1351846416.14888.155.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351846416.14888.155.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Chun-Yi Lee <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
> +
> +	if (count < sizeof(attributes))
> +		return -EINVAL;
> +
> +	data = kmalloc(datasize, GFP_KERNEL);

This still attempts to allocate arbitary user provided values of memory.
This is still broken. Even in the extreme case of 'root only, right thing
to do' then this is broken as you don't pass __GFP_NOWARN. However if you
can have very large strings remember that big values handled this way are
actually effectively implemented as

	"maybe set the value or randomly return -ENOMEM possibly until a
	reboot"

so if your real upper limit is huge then this isn't good. If on the other
hand its things like 32K or so then you just want NOWARN.

Alan
