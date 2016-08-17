From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Wed, 17 Aug 2016 11:00:31 -0500
Message-ID: <20160817160031.GV214806@stormcage.americas.sgi.com>
References: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
 <20160815124258.GF30909@codeblueprint.co.uk>
 <20160815150709.GA6085@nazgul.tnic>
 <20160815184731.GS214806@stormcage.americas.sgi.com>
 <20160817070151.GC5498@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160817070151.GC5498-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 17, 2016 at 03:01:51PM +0800, Dave Young wrote:
> > > Why do you guys need the physical mapping all of a sudden?
> > 
> > It's not that we need it all of the sudden, necessarily, it's just that
> > we've had to make other changes to make things work with the new,
> > (almost) completely isolated, EFI page tables.  We ended up choosing the
> > lesser of two evils, and have decided to temporarily rely on the
> > physical address of our runtime code, instead of continuing to rely on
> > EFI_OLD_MEMMAP.
> 
> In efi_map_region, there is already mapped md->phys_addr for broken
> firmware. SGI still need EFI_OLD_MEMMAP? I means in 1st kernel instead
> of kexec kernel.

We're actually in the middle of trying to move *away* from
EFI_OLD_MEMMAP, which is why we're just starting to uncover some of
these things.  efi_map_region covers us on the primary kernel, because
it maps in the physical address of each md (as you note here), but that
little piece is missing in the kexec'd kernel.  So, our primary kernel
works without efi=old_map, but the second kernel won't, without this
change (supplying "noefi" on the kexec command line also works, but then
we don't have any of our runtime stuff available).

As noted in a previous message, we're aware that our code needs a little
more work to be "perfect," but this small change buys us most of (all
of?) the stuff we'd get by implementing the other changes that we're
aware we need to make, i.e. update our runtime function pointer to its
efi_va during SetVirtualAddressMap, at least from a kexec perspective.

- Alex
