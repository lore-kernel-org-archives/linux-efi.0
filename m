From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [GIT PULL] hash addresses printed with %p
Date: Thu, 30 Nov 2017 17:10:36 +0000
Message-ID: <20171130171036.GB31817@kroah.com>
References: <20171129045927.GA6217@eros>
 <CA+55aFzVy-SE9w1puPjgE1BxGje8oR3Ks9BDU7GXmvBYJfkCxw@mail.gmail.com>
 <20171129210848.GF6217@eros>
 <CA+55aFwjhjGZC9U68mo4hnnJXLWYxG3UYoz-=SwNfO-3N-Untg@mail.gmail.com>
 <CA+55aFwPXV0sXb+edcQc4epz0pWustZgJsoq95=a3OEDxynq7g@mail.gmail.com>
 <20171130163235.GA27849@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171130163235.GA27849-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Tobin C. Harding" <me-xzjC0nNlxno@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 30, 2017 at 04:32:35PM +0000, Greg Kroah-Hartman wrote:
> On Wed, Nov 29, 2017 at 01:36:25PM -0800, Linus Torvalds wrote:
> > On Wed, Nov 29, 2017 at 1:14 PM, Linus Torvalds
> > <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > >
> > > Not because %pK itself changed, but because the semantics of %p did.
> > > The baseline moved, and the "safe" version did not.
> > 
> > Btw, that baseline for me is now that I can do
> > 
> >   ./scripts/leaking_addresses.pl | wc -l
> >   18
> > 
> > and of those 18 hits, six are false positives (looks like bitmaps in
> > the uevent keys).
> > 
> > The remaining 12 are from the EFI runtime map files
> > (/sys/firmware/efi/runtime-map/*). They should presumably not be
> > world-readable, but sadly the kset_create_and_add() helper seems to do
> > that by default.
> > 
> > I think the sysfs code makes it insanely too easy to make things
> > world-readable. You try to be careful, and mark things read-only etc,
> > but __ATTR_RO() jkust means S_IRUGO, which means world-readable.
> > 
> > There seems to be no convenient model for kobjects having better
> > permissions. Greg?
> 
> They can just use __ATTR() which lets you set the exact mode settings
> that are wanted.
> 
> Something like the patch below, which breaks the build as the
> map_attributes are "odd", but you get the idea.  The EFI developers can
> fix this up properly :)
> 
> Note, this only accounts for 5 attributes, what is the whole list?

Ah, it's the virt_addr file 12 times, I just ran it on my laptop:

/sys/firmware/efi/runtime-map/7/virt_addr: 0xfffffffeea6ea000
/sys/firmware/efi/runtime-map/5/virt_addr: 0xfffffffeee88b000
/sys/firmware/efi/runtime-map/3/virt_addr: 0xfffffffefea00000
/sys/firmware/efi/runtime-map/11/virt_addr: 0xfffffffed9c00000
/sys/firmware/efi/runtime-map/1/virt_addr: 0xfffffffefee00000
/sys/firmware/efi/runtime-map/8/virt_addr: 0xfffffffedba4e000
/sys/firmware/efi/runtime-map/6/virt_addr: 0xfffffffeee2de000
/sys/firmware/efi/runtime-map/4/virt_addr: 0xfffffffeeea00000
/sys/firmware/efi/runtime-map/2/virt_addr: 0xfffffffefec00000
/sys/firmware/efi/runtime-map/10/virt_addr: 0xfffffffed9c60000
/sys/firmware/efi/runtime-map/0/virt_addr: 0xfffffffeff000000
/sys/firmware/efi/runtime-map/9/virt_addr: 0xfffffffedb9c9000

So changing it to use __ATTR() should fix this remaning leakage up.
That is if we even really need to export these values at all.  What does
userspace do with them?  Shouldn't they just be in debugfs instead?

thanks,

greg k-h
