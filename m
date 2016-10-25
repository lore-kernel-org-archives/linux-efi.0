From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] efi: Add device path parser
Date: Tue, 25 Oct 2016 10:18:20 -0400
Message-ID: <20161025141819.2z244yr2ubscrm2r@redhat.com>
References: <cover.1476698603.git.lukas@wunner.de>
 <ece9b12b1d0b86c83e8369e4123fc7bc60db1fdc.1476698603.git.lukas@wunner.de>
 <20161019111728.GC31476@codeblueprint.co.uk>
 <20161021163435.y2zlysz7dhw5ymho@redhat.com>
 <20161022101608.GA4447@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161022101608.GA4447-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Oct 22, 2016 at 12:16:08PM +0200, Lukas Wunner wrote:
> On Fri, Oct 21, 2016 at 12:34:36PM -0400, Peter Jones wrote:
> > On Wed, Oct 19, 2016 at 12:17:28PM +0100, Matt Fleming wrote:
> > > (Cc'ing Peter since he's played with device path parsing before)
> > 
> > So the only two thoughts I have:
> > 
> > 1) I think we should probably be a bit more aggressive about bounds
> >    checking.  Every once in a while there are implementations that build
> >    device paths from templates and occasionally leave
> >    efi_dev_path.length as 0 or 0xffff,
> 
> The patch already handles this:  The length of each node is fixed
> for each type in the spec (e.g. 6 bytes for PCI nodes) and there's
> strict checking of this in the patch.  A node with length 0 or 0xffff
> would result in -EINVAL.

But that's only true if we only handle device types with well defined
sizes, which means no VendorMessage() or VendhorHardware() devices at
all.  Apple might not be using those for what you're using this for so
far, but lots of other vendors are, for lots of things.  Which
effectively means we can't handle multiple-instance device paths.

> >    or forget to put an End Entire
> >    Device Path node at the end (or put an End Device Path Instance in
> >    instead.)  So checking for ->length < PAGE_SIZE
> 
> This is also already handled by the patch:  get_device_by_efi_path()
> is called with a maximum length parameter.  In the case of Apple device
> properties, I know the size of the payload which contains a device's
> properties, so I pass that as the maximum length.  If in your use case
> you don't have such an upper bound and feel that device paths should
> never exceed PAGE_SIZE, then just pass that as the maximum length
> argument to get_device_by_efi_path().

Fair enough.

> >    and that when a dp
> >    node crosses a page boundary, the new page is actually in the same map
> >    as the previous one wouldn't be a terrible idea.
> 
> In the case of Apple device properties, that isn't needed as they're
> all contained in one payload that gets mapped into virtual memory.
> I think checking page mapping should only be done if really needed,
> i.e. if you expect to get such a bogus device path, you should probably
> perform such checks in your code, but it shouldn't be done in
> get_device_by_efi_path(), i.e. for *every* device path.

Yeah, okay, I can buy that.

> > 2) I think we should decide how multiple-instance device path are going
> >    to work sooner rather than later, mostly because I have a use for them
> >    and it seems harder to graft them in later.  My first idea here is to
> >    make get_device_by_efi_path() return 0 for "stop iterating" and 1 for
> >    "there's more device paths later"
> 
> I'm fine with that approach.
> 
> 
> >    and then make it merely set *dev =
> >    NULL when we just don't /support/ the device path we found, rather than
> >    returning error.  Either case would still set *node to the (possibly
> >    inexistent) next node.
> 
> That however I'm very sceptical about.
> 
> If the device path is malformed (-EINVAL), e.g. because it contains a
> bogus length, all bets are off and I have to stop parsing.  It's just
> not safe to try to find any following instances.  If on the other hand
> the device path contains an unsupported node type (-ENOTSUPP), well,
> we should simply add support for it.  Which node types do you expect
> to parse that aren't currently supported by the patch?  (The patch
> supports ACPI and PCI device paths.)

By definition we cannot add any meaningful support for any of the vendor
defined device paths.  In the spec, these are defined in sections 9.3.2.4,
9.3.5.17, 9.3.6.3.  All we can do is say they are present and skip over
them.

So FWIW where I want to use this is matching up devices with the
ConInDev/ConOutDev/ErrOutDev variables, so we can add sysfs attributes
to devices to say the hardware supports using them as console.  These
variables are multi-instance device paths, with one instance per
hardware device.  A typical value is something like:

PciRoot(0x0)/Pci(0x14,0x0)/VenMsg(...)/EndInstance/PciRoot(0x0)/Pci(0x14,0x0)/USB(1,0)/USB(0,0)/EndInstance/PciRoot(0x0)/Pci(0x2,0x0)/AcpiAdr(0x1)/EndEntire


Without parsing the arbitrarily-sized vendor paths, we never get to the
parts we can actually do something with.

> If I would pass over unsupported node types, I couldn't apply strict
> length checking, so I would indeed have to apply some heuristic,
> such as < PAGE_SIZE, which seems kludgy at best.

Right, it's kludgy, it just might be the best thing we have given the
arbitrary nature of the data.  We could apply any such heuristic to only
the vendor paths, though.

> Also, it is intentional that get_device_by_efi_path() stops parsing
> if it hits upon an unsupported node type because while ACPI and PCI
> nodes are currently the only ones used by Apple, it's possible that
> they'll add others in the future and in that case I want to get an
> error back and I want to know the position of the unsupported node
> type.  The caller unmarshal_devices() in patch [2/3] of this series
> prints a hex dump of the device path and the properties and an error
> message showing the position of the offending node, so that it's
> easy to identify what went wrong and which node type needs to be
> added.

Right - I know it's intentional, I just don't think that'll hold if we
start using this for other purposes than yours.

> >    If we did that, we could easily rename it
> >    get_devices_by_path() and make get_device_by_path() a special case
> >    with exactly the semantics we have now.
> 
> I don't quite follow.  With the approach to support multiple instances
> that you've outlined above, you'd simply do:
> 
> 	while ((ret = get_device_by_efi_path(node, len, &dev)) >= 0) {
> 		/* do something */
> 		if (ret == 0)
> 			break;
> 	}
> 
> What would you need a get_devices_by_path() function for?

I was just suggesting it as a convenience function; no reason to get
hung up on it.
-- 
  Peter
