From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2 1/3] efi: Add device path parser
Date: Wed, 19 Oct 2016 13:51:19 +0200
Message-ID: <20161019115119.GA2973@wunner.de>
References: <cover.1476698603.git.lukas@wunner.de>
 <ece9b12b1d0b86c83e8369e4123fc7bc60db1fdc.1476698603.git.lukas@wunner.de>
 <20161019111728.GC31476@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161019111728.GC31476-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 19, 2016 at 12:17:28PM +0100, Matt Fleming wrote:
> On Mon, 17 Oct, at 12:57:23PM, Lukas Wunner wrote:
> > +/**
> > + * get_device_by_efi_path - find device by EFI Device Path
> > + * @node: EFI Device Path
> > + * @len: maximum length of EFI Device Path in bytes
> > + * @dev: device found
> > + *
> > + * Parse a series of EFI Device Path nodes at @node and find the corresponding
> > + * device. If the device was found, its reference count is incremented and a
> > + * pointer to it is returned in @dev. The caller needs to drop the reference
> > + * with put_device() after use. The @node pointer is updated to point to the
> > + * location immediately after the "End Entire Device Path" node.
> > + *
> > + * If a Device Path node is malformed or its corresponding device is not found,
> > + * @node is updated to point to this offending node and @dev will be %NULL.
> > + *
> > + * Most buses instantiate devices in "subsys" initcall level, hence the
> > + * earliest initcall level in which this function should be called is "fs".
> > + *
> > + * Returns 0 on success,
> > + *	   %-ENODEV if no device was found,
> > + *	   %-EINVAL if a node is malformed or exceeds @len,
> > + *	   %-ENOTSUPP if support for a node type is not yet implemented.
> > + */
> > +int __init get_device_by_efi_path(struct efi_dev_path **node, size_t len,
> > +				  struct device **dev)
> > +{
> > +	struct device *parent = NULL, *child;
> > +	int ret = 0;
> > +
> > +	*dev = NULL;
> > +
> > +	while (ret != 1) {
> > +		if (len < 4 || len < (*node)->length)
> > +			ret = -EINVAL;
> > +		else if ((*node)->type     == EFI_DEV_ACPI &&
> > +			 (*node)->sub_type == EFI_DEV_BASIC_ACPI)
> > +			ret = get_device_by_acpi_path(*node, parent, &child);
> > +		else if ((*node)->type     == EFI_DEV_HW &&
> > +			 (*node)->sub_type == EFI_DEV_PCI)
> > +			ret = get_device_by_pci_path(*node, parent, &child);
> > +		else if (((*node)->type    == EFI_DEV_END_PATH ||
> > +			  (*node)->type    == EFI_DEV_END_PATH2) &&
> > +			 (*node)->sub_type == EFI_DEV_END_ENTIRE)
> > +			ret = get_device_by_end_path(*node, parent, &child);
> > +		else
> > +			ret = -ENOTSUPP;
> > +
> > +		put_device(parent);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		parent = child;
> > +		*node  = (void *)*node + (*node)->length;
> > +		len   -= (*node)->length;
> > +	}
> > +
> > +	*dev = child;
> > +	return 0;
> > +}
> 
> Where in your patch series is this function called? Am I missing
> something?

This is called by unmarshal_devices() in patch [2/3] of this series.


> Also, unless there's some existing namespace with "get_device_by_*"
> I'd prefer for this function name to have "efi_" as the prefix.

There's get_device() defined in include/linux/device.h which returns a
reference to a device, this function here is basically named after it
because it likewise returns a reference.

How about efi_get_device_by_path()?

Thanks,

Lukas
