From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH RFC 1/1] x86: fix bad memory access in
 fb_is_primary_device()
Date: Tue, 16 Feb 2016 13:49:18 +0000
Message-ID: <20160216134918.GD2769@codeblueprint.co.uk>
References: <1455528649-26629-1-git-send-email-alpopov@ptsecurity.com>
 <20160216075521.GA27491@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160216075521.GA27491@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Popov <alpopov@ptsecurity.com>, Arnd Bergmann <arnd@arndb.de>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

[ Including Peter, the efifb maintainer. Original email is here,

    http://marc.info/?l=linux-kernel&m=145552936131335&w=2

  I've snipped some of the quoted text ]

On Tue, 16 Feb, at 08:55:22AM, Ingo Molnar wrote:
> 
> (I've Cc:-ed the EFI-FB and FB gents. Mail quoted below.)
> 
> * Alexander Popov <alpopov@ptsecurity.com> wrote:
> 
> > Currently the code in fb_is_primary_device() contains to_pci_dev() macro
> > which is applied to dev from struct fb_info. In some cases this causes
> > bad memory access when fb_is_primary_device() handles fb_info of efifb.
> > The reason is that fb dev of efifb is embedded into struct platform_device
> > but not into struct pci_dev.
> > 
> > We can fix this by checking fb dev bus name in fb_is_primary_device().
> > 
> > It seems that this bug reveals some bigger problem with to_pci_dev(),
> > to_platform_device() and others, which just do container_of() and
> > don't check whether struct device is a part of the appropriate structure.
> > Should we do something more about it?
> > 
> > KASan report:

[...]

> > 
> > Signed-off-by: Alexander Popov <alpopov@ptsecurity.com>
> > ---
> >  arch/x86/video/fbdev.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/video/fbdev.c b/arch/x86/video/fbdev.c
> > index d5644bb..4999f78 100644
> > --- a/arch/x86/video/fbdev.c
> > +++ b/arch/x86/video/fbdev.c
> > @@ -18,11 +18,12 @@ int fb_is_primary_device(struct fb_info *info)
> >  	struct pci_dev *default_device = vga_default_device();
> >  	struct resource *res = NULL;
> >  
> > -	if (device)
> > -		pci_dev = to_pci_dev(device);
> > -
> > -	if (!pci_dev)
> > +	if (!device || !device->bus ||
> > +		    !device->bus->name || strcmp(device->bus->name, "pci")) {
> >  		return 0;
> > +	}
> > +
> > +	pci_dev = to_pci_dev(device);
> >  
> >  	if (default_device) {
> >  		if (pci_dev == default_device)
> > -- 
> > 1.9.1
> > 

I wonder if this issue could explain some of the efifb issues we've
seen reported on bugzilla.kernel.org in the past where switching from
efifb to some other framebuffer device caused hangs during boot. I'm
struggling to find the relevant bugzilla entries now, though.
