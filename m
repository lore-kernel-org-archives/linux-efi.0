From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/3] x86/sysfb_efi: Fix valid BAR address range check
Date: Wed, 4 May 2016 11:29:05 +0100
Message-ID: <20160504102905.GF2839@codeblueprint.co.uk>
References: <1462303781-8686-1-git-send-email-matt@codeblueprint.co.uk>
 <1462303781-8686-3-git-send-email-matt@codeblueprint.co.uk>
 <20160504063524.GB12846@gmail.com>
 <20160504092510.GD2839@codeblueprint.co.uk>
 <20160504102340.GA4470@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504102340.GA4470-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Wang YanQing <udknight-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 04 May, at 12:23:40PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
> > On Wed, 04 May, at 08:35:24AM, Ingo Molnar wrote:
> > > 
> > > * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > > 
> > > > From: Wang YanQing <udknight-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > > 
> > > > We can't just break out when meet start is equal to zero,
> > > 
> > > Hm, wot?
> > 
> > The existing code treats address 0x0 as invalid for a PCI BAR range
> > start address, but 0x0 is actually possible and legitimate, so we
> > shouldn't be breaking out of the loop.
> 
> Yeah, so I just don't understand the 'when meet start is equal to zero' part - 
> what does it mean?

I suspect it means "when start is equal to zero" or "when we encounter
the scenario where start is equal to zero".

Wang?
