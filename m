From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Tue, 10 May 2016 12:35:11 -0500
Message-ID: <20160510173511.GI113599@stormcage.americas.sgi.com>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
 <20160428014128.GF113599@stormcage.americas.sgi.com>
 <20160428125711.GB9164@pd.tnic>
 <20160429154119.GI113599@stormcage.americas.sgi.com>
 <20160430221209.GO2839@codeblueprint.co.uk>
 <20160502213931.GT113599@stormcage.americas.sgi.com>
 <20160509215524.GQ2839@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160509215524.GQ2839-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 09, 2016 at 10:55:24PM +0100, Matt Fleming wrote:
> On Mon, 02 May, at 04:39:31PM, Alex Thorlton wrote:
> > 
> > If you think we're violating EFI rules by accessing these registers from
> > both sides of the fence, please let me know.  I'd like to make sure that
> > we get everything behaving the way it should be!
> 
> Oh no, I don't think this is violating the UEFI spec at all, but I do
> think it goes against the spirit of the way other implementations are
> designed; with maximum separation between firmware and kernel.

Understood.  Thanks!

> In a perfect world, I'd suggest mapping the MMR range in both the
> kernel and firmware, at different virtual address ranges, but have
> the firmware's version opaque to the kernel and only described by an
> EfiMemoryMappedIO region, or something. That is ignoring any region
> type conflicts that may arise.

The code I'm working on right now will do exactly this, so I think we're
on the right track there.  My solution is still a bit hacky, and we're
still working out some kinks with runtime EFI calls, but we're getting
closer.

I will send up an RFC patch with my findings as soon as we've worked out
our callback issues.  I'm working with our BIOS guys on this as we
speak.

Thanks again for the help, Matt!

- Alex
