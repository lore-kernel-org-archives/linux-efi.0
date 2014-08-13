From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: ignore DT memreserve entries when booting in UEFI
 mode
Date: Wed, 13 Aug 2014 13:22:39 +0100
Message-ID: <20140813122239.GA15356@bivouac.eciton.net>
References: <1406570583-22848-1-git-send-email-leif.lindholm@linaro.org>
 <20140728181449.GF2576@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140728181449.GF2576@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rob.herring-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Jul 28, 2014 at 07:14:49PM +0100, Mark Rutland wrote:
> On Mon, Jul 28, 2014 at 07:03:03PM +0100, Leif Lindholm wrote:
> > UEFI provides its own method for marking regions to reserve, via the
> > memory map which is also used to initialise memblock. So when using the
> > UEFI memory map, ignore any memreserve entries present in the DT.
> 
> It's worth noting that no-one is relying on this at present, and were
> they it would imply that their UEFI implementation is broken (providing
> a dodgy memory map).
> 
> So before people start doing dodgy things, let's, close that hole. If we
> need a way of modifying the memory map we should come up with a more
> general plan.

Catalin - any comments?
As it is a bugfix, can it go into 3.17?

/
    Leif
 
> > Reported-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  arch/arm64/kernel/efi.c |    2 ++
> >  arch/arm64/mm/init.c    |    4 +++-
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > index 14db1f6..7ad17b2 100644
> > --- a/arch/arm64/kernel/efi.c
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -188,6 +188,8 @@ static __init void reserve_regions(void)
> >  		if (uefi_debug)
> >  			pr_cont("\n");
> >  	}
> > +
> > +	set_bit(EFI_MEMMAP, &efi.flags);
> 
> Nothing outside of arch/x86 seems to hang off this, so using it here
> looks fine.
> 
> >  }
> >  
> >  
> > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > index e90c542..58dbf2e 100644
> > --- a/arch/arm64/mm/init.c
> > +++ b/arch/arm64/mm/init.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/of_fdt.h>
> >  #include <linux/dma-mapping.h>
> >  #include <linux/dma-contiguous.h>
> > +#include <linux/efi.h>
> >  
> >  #include <asm/sections.h>
> >  #include <asm/setup.h>
> > @@ -151,7 +152,8 @@ void __init arm64_memblock_init(void)
> >  	memblock_reserve(__pa(swapper_pg_dir), SWAPPER_DIR_SIZE);
> >  	memblock_reserve(__pa(idmap_pg_dir), IDMAP_DIR_SIZE);
> >  
> > -	early_init_fdt_scan_reserved_mem();
> > +	if (!efi_enabled(EFI_MEMMAP))
> > +		early_init_fdt_scan_reserved_mem();
> 
> And this is a false stub for !EFI, so that looks fine.
> 
> FWIW:
> 
> Reviewed-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> 
> I wonder if we have any other flat tree uses we need to be careful of
> when booting via EFI.
