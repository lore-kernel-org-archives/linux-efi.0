From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Tue, 16 Aug 2016 10:25:14 -0500
Message-ID: <20160816152513.GT214806@stormcage.americas.sgi.com>
References: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
 <20160815124258.GF30909@codeblueprint.co.uk>
 <20160815150709.GA6085@nazgul.tnic>
 <20160815184731.GS214806@stormcage.americas.sgi.com>
 <20160816055010.GB7911@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160816055010.GB7911-K5JNixvcfoxupOikMc4+xw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 16, 2016 at 07:50:10AM +0200, Borislav Petkov wrote:
> On Mon, Aug 15, 2016 at 01:47:31PM -0500, Alex Thorlton wrote:
> > The only thing we're adding here is the physical mappings, to match
> > what is availble in the primary kernel.
> 
> I can see what it does - I just am questioning the reasoning for as we
> did all that effort so that kexec can have stable virtual mappings.
> 
> I guess we still need a way to pass the virtual mappings to kexec
> as they're immutable as some "smartass" decided to allow to call
> SetVirtualAddressMap only once.
> 
> > This is sort of a hand-wavey answer - I will investigate the his further...
> 
> Yeah, it'll be interesting to know whether that is an issue because if
> we do the 1:1 mappings in the kexec kernel too and there's an address
> conflict, then we better know upfront.

I did some investigation/testing here and found, as Matt stated, that
this shouldn't cause any serious problems.  The crashkernel memory
reservation happens a little later than I originally thought, so we sort
of hit a hybrid of the two problems I described.  i.e, the memory isn't
mapped yet, but the kernel does know not to map anything over it.

I purposely set the crashkernel to land right on top of some of our
MMRs:

#define UV2_GLOBAL_MMR32_BASE           0xfc000000UL

This is 4227858432 in base10, or 4128768K in crashkernel parameter
terms, so I used this on the command line:

crashkernel=256M@4128768K

And, not too surprisingly, I hit this while trying to reserve the
crashkernel memory:

[    0.000000] crashkernel reservation failed - memory is in use.

At a glance, I believe that this is because the memory range for these
MMRs is E820_RESERVED:

[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fdffffff] reserved

So, it gets skipped over during memblock_x86_fill, which only picks up
E820_RAM, and E820_RESERVED_KERN memory.  At least in this case, the
memory range where our MMRs fall is seen as completely unavailable (or,
more accurately, not seen at all) when we do the memblock_find_in_range
during reserve_crashkernel.

Note that I chose to map over some MMR space instead of EFI runtime
code.  This was an arbitrary choice - they both show up as
E820_RESERVED, so the behavior will be the same.

This is certainly not news to some, but I wasn't positive about how this
worked, and wanted to make sure that I addressed the concern that you
expressed.

Thanks again for your input!

- Alex
