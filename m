From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/1] x86: fix bad memory access in
 fb_is_primary_device()
Date: Tue, 16 Feb 2016 10:18:59 -0500
Message-ID: <20160216151859.GB11373@redhat.com>
References: <1455528649-26629-1-git-send-email-alpopov@ptsecurity.com>
 <20160216075521.GA27491@gmail.com>
 <20160216134918.GD2769@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160216134918.GD2769-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Popov <alpopov-rHsQqRFQpp1OSnsfY10OVw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 16, 2016 at 01:49:18PM +0000, Matt Fleming wrote:
> [ Including Peter, the efifb maintainer. Original email is here,
> 
>     http://marc.info/?l=linux-kernel&m=145552936131335&w=2
> 
>   I've snipped some of the quoted text ]
> 
> On Tue, 16 Feb, at 08:55:22AM, Ingo Molnar wrote:
> > 
> > (I've Cc:-ed the EFI-FB and FB gents. Mail quoted below.)
> > 
> > * Alexander Popov <alpopov-rHsQqRFQpp1OSnsfY10OVw@public.gmane.org> wrote:
> > 
> > > Currently the code in fb_is_primary_device() contains to_pci_dev() macro
> > > which is applied to dev from struct fb_info. In some cases this causes
> > > bad memory access when fb_is_primary_device() handles fb_info of efifb.
> > > The reason is that fb dev of efifb is embedded into struct platform_device
> > > but not into struct pci_dev.
> > > 
> > > We can fix this by checking fb dev bus name in fb_is_primary_device().
> > > 
> > > It seems that this bug reveals some bigger problem with to_pci_dev(),
> > > to_platform_device() and others, which just do container_of() and
> > > don't check whether struct device is a part of the appropriate structure.
> > > Should we do something more about it?
> > > 
> > > KASan report:
> 
> [...]
> 
> > > 
> > > Signed-off-by: Alexander Popov <alpopov-rHsQqRFQpp1OSnsfY10OVw@public.gmane.org>
> > > ---
> > >  arch/x86/video/fbdev.c | 9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/video/fbdev.c b/arch/x86/video/fbdev.c
> > > index d5644bb..4999f78 100644
> > > --- a/arch/x86/video/fbdev.c
> > > +++ b/arch/x86/video/fbdev.c
> > > @@ -18,11 +18,12 @@ int fb_is_primary_device(struct fb_info *info)
> > >  	struct pci_dev *default_device = vga_default_device();
> > >  	struct resource *res = NULL;
> > >  
> > > -	if (device)
> > > -		pci_dev = to_pci_dev(device);
> > > -
> > > -	if (!pci_dev)
> > > +	if (!device || !device->bus ||
> > > +		    !device->bus->name || strcmp(device->bus->name, "pci")) {
> > >  		return 0;
> > > +	}
> > > +
> > > +	pci_dev = to_pci_dev(device);
> > >  
> > >  	if (default_device) {
> > >  		if (pci_dev == default_device)
> > > -- 
> > > 1.9.1
> > > 
> 
> I wonder if this issue could explain some of the efifb issues we've
> seen reported on bugzilla.kernel.org in the past where switching from
> efifb to some other framebuffer device caused hangs during boot. I'm
> struggling to find the relevant bugzilla entries now, though.

It's possible it could, but I don't have them handy either.  I've also
wondered if some of them were due to bad data from the firmware - at
plugfests we've seen some cases where the actual video mode as measured
with a ruler is clearly not what the firmware claims it to be, so it's
entirely possible we're occasionally told a memory region that is not
what's actually mapped, or that's mapped but is only partially backed
by the actual frame buffer memory.

But aside from that diversion, I think Alexander has a legitimate
question about use of to_pci_dev().  If I ask the question: can we fix
this in efifb by making it live on a pci_dev, I have a couple of
fundamental problems:

1) technically it doesn't have to be a pci_dev at all (but, practically,
   so far it always is on PCI...)
2) From EFI, we can't necessarily pin it down to a single PCI device
   even if it is PCI.  Before we do EFI's ExitBootServices() call, we
   can try to find the PCI_IO handle our GOP instance is connected to,
   but not all firmware GOP drivers use that, so it doesn't always work.
   And even if it did, there can be more than one instance pointing to
   the same memory with different PCI devices - lots of laptops have
   this sort of thing.
3) Ignoring the EFI side and just focusing on PCI, if there's two
   devices configured that could do scanout, it can be mapped to one
   device's BAR but the other device be the actual device using it.  In
   this case either choice is probably wrong for something, and the
   things that have the information to resolve which one don't include
   efifb - they're the drivers we'll likely hand off to later.

So it's most likely right for efifb to be embedded in a platform_device
instead of a pci_dev.  Which leads back to Alexander's question - if it
isn't in a pci_dev, that means fb_is_primary_device() needs to not
assume it is.  So the patch appears correct, but so is the question -
should to_pci_dev() be checking this and returning NULL here?

-- 
        Peter
