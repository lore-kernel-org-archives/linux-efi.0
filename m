From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2 1/3] efi: Add device path parser
Date: Thu, 27 Oct 2016 14:31:32 +0200
Message-ID: <20161027123132.GA7178@wunner.de>
References: <cover.1476698603.git.lukas@wunner.de>
 <ece9b12b1d0b86c83e8369e4123fc7bc60db1fdc.1476698603.git.lukas@wunner.de>
 <20161019111728.GC31476@codeblueprint.co.uk>
 <20161021163435.y2zlysz7dhw5ymho@redhat.com>
 <20161022101608.GA4447@wunner.de>
 <20161025141819.2z244yr2ubscrm2r@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161025141819.2z244yr2ubscrm2r-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 25, 2016 at 10:18:20AM -0400, Peter Jones wrote:
> On Sat, Oct 22, 2016 at 12:16:08PM +0200, Lukas Wunner wrote:
> > On Fri, Oct 21, 2016 at 12:34:36PM -0400, Peter Jones wrote:
> > I don't quite follow.  With the approach to support multiple instances
> > that you've outlined above, you'd simply do:
> > 
> > 	while ((ret = get_device_by_efi_path(node, len, &dev)) >= 0) {
> > 		/* do something */
> > 		if (ret == 0)
> > 			break;
> > 	}

Okay I've extended the patch to support multiple instance device paths,
but I've done it differently than shown above to hopefully make it
simpler and more intuitive.

I changed the function's signature to this:

	struct device *efi_get_device_by_path(struct efi_dev_path **node,
					      size_t *len);

It no longer returns an int, but a struct device. Once the end of entire
path has been reached, it returns NULL. On error it returns an ERR_PTR.
The maximum length is passed in by reference and decremented by the number
of bytes consumed by an instance. After the last instance, it's set to 0.

This allows the following idiom to iterate over all instances in a path:

	while (!IS_ERR_OR_NULL(dev = efi_get_device_by_path(&node, &len))) {
		// do something with dev
		put_device(dev);
	}
	if (IS_ERR(dev))
		// report error

For your use case, you'll want to omit the put_device() in the while loop
and release the reference when later on removing the sysfs entry.

I took inspiration from the corresponding PCI functions to iterate over
devices of a certain class or id, e.g.:

        struct pci_dev *pdev = NULL;

	while ((pdev = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev))) {
		// do something with dev
	}

You can browse the updated patch here:
https://github.com/l1k/linux/commit/a3a29e8a58ff

If you want to fetch the branch and hack on it:
https://github.com/l1k/linux.git apple_properties_v3

Does this approach suit your needs?


> > If I would pass over unsupported node types, I couldn't apply strict
> > length checking, so I would indeed have to apply some heuristic,
> > such as < PAGE_SIZE, which seems kludgy at best.
> 
> Right, it's kludgy, it just might be the best thing we have given the
> arbitrary nature of the data.  We could apply any such heuristic to only
> the vendor paths, though.

Yes I think that's the way to go: Add a parser for Vendor-Defined Messaging
Device Path and check that its length is >= 20 and <= MAX_NODE_LEN, then
define MAX_NODE_LEN as e.g. PAGE_SIZE.


> > >    and then make it merely set *dev =
> > >    NULL when we just don't /support/ the device path we found, rather than
> > >    returning error.  Either case would still set *node to the (possibly
> > >    inexistent) next node.
> > 
> > That however I'm very sceptical about.
> > 
> > If the device path is malformed (-EINVAL), e.g. because it contains a
> > bogus length, all bets are off and I have to stop parsing.  It's just
> > not safe to try to find any following instances.  If on the other hand
> > the device path contains an unsupported node type (-ENOTSUPP), well,
> > we should simply add support for it.  Which node types do you expect
> > to parse that aren't currently supported by the patch?  (The patch
> > supports ACPI and PCI device paths.)
> 
> By definition we cannot add any meaningful support for any of the vendor
> defined device paths.  In the spec, these are defined in sections 9.3.2.4,
> 9.3.5.17, 9.3.6.3.  All we can do is say they are present and skip over
> them.
> 
> So FWIW where I want to use this is matching up devices with the
> ConInDev/ConOutDev/ErrOutDev variables, so we can add sysfs attributes
> to devices to say the hardware supports using them as console.  These
> variables are multi-instance device paths, with one instance per
> hardware device.  A typical value is something like:
> 
> PciRoot(0x0)/Pci(0x14,0x0)/VenMsg(...)/EndInstance/PciRoot(0x0)/Pci(0x14,0x0)/USB(1,0)/USB(0,0)/EndInstance/PciRoot(0x0)/Pci(0x2,0x0)/AcpiAdr(0x1)/EndEntire
> 
> 
> Without parsing the arbitrarily-sized vendor paths, we never get to the
> parts we can actually do something with.

I'd suggest to add a parser for Vendor-Defined Messaging Device Path which
just skips over it (by setting *child = get_device(parent), like
parse_end_path() does). The spec says this encodes VT-100 parameters and
such, I don't see how we could translate this to a device.

As for ACPI _ADR, this seems to encode the connector. The DRM subsystem
represents those as devices of class drm_class below the PCI device,
but they're only present if a DRM driver is loaded. Do you need to identify
the connector device at all for your use case? If not, it might be best to
again just skip over it.

And the only other one you'll need to parse the above-quoted path are USB
devices. You can probably just derive that from the PCI and ACPI parsers.


Are you only going to invoke efi_get_device_by_path() from an initcall?
Because right now I've declared everything __init. How do you identify
devices when removing the sysfs attributes, e.g. on shutdown? I'd recommend
to store the devices in a list somewhere, instead of parsing the path
once more.

Best regards,

Lukas
