From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] arm64/efi: do not enter virtual mode in case booting
 with efi=noruntime or noefi
Date: Mon, 18 Aug 2014 09:24:54 +0800
Message-ID: <20140818012454.GA3379@darkstar.nay.redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007731-15081-5-git-send-email-dyoung@redhat.com>
 <20140815150952.GY27466@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140815150952.GY27466-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/15/14 at 04:09pm, Will Deacon wrote:
> On Thu, Aug 14, 2014 at 10:15:30AM +0100, Dave Young wrote:
> > In case efi runtime disabled via noefi kernel cmdline arm64_enter_virtual_mode
> > should error out.
> > 
> > At the same time move early_memunmap(memmap.map, mapsize) to the beginning of
> > the function or it will leak early mem.
> > 
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/arm64/kernel/efi.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > index 6ed0362..309fab1 100644
> > --- a/arch/arm64/kernel/efi.c
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -392,11 +392,16 @@ static int __init arm64_enter_virtual_mode(void)
> >  		return -1;
> >  	}
> >  
> > +	mapsize = memmap.map_end - memmap.map;
> > +	if (efi_runtime_disabled()) {
> > +		early_memunmap(memmap.map, mapsize);
> 
> Should this early_memunmap really be conditional? With this change, we no
> longer unmap it before setting up the permanent mapping below.

Ooops, I tested the right version but sent a wrong version for this arm64 patch.

Thanks for catch.

> 
> Will
> 
> > +		pr_info("EFI runtime services will be disabled.\n");
> > +		return -1;
> > +	}
> > +
> >  	pr_info("Remapping and enabling EFI services.\n");
> >  
> >  	/* replace early memmap mapping with permanent mapping */
> > -	mapsize = memmap.map_end - memmap.map;
> > -	early_memunmap(memmap.map, mapsize);
> >  	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
> >  						   mapsize);
> >  	memmap.map_end = memmap.map + mapsize;
> > -- 
> > 1.8.3.1
> > 
> > 
