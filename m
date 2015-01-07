From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] arm64: don't make early_*map() calls post
 paging_init()
Date: Wed, 7 Jan 2015 13:31:09 +0000
Message-ID: <20150107133109.GM3827@bivouac.eciton.net>
References: <1420551673-31416-1-git-send-email-leif.lindholm@linaro.org>
 <1420551673-31416-2-git-send-email-leif.lindholm@linaro.org>
 <1420576522.16211.30.camel@t520.localdomain>
 <20150107105841.GE7485@arm.com>
 <CAKv+Gu9NRRFZG0S6oFJqPG1+1O2-SZah4wqoi0YPofL33X3nJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9NRRFZG0S6oFJqPG1+1O2-SZah4wqoi0YPofL33X3nJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 07, 2015 at 01:13:06PM +0000, Ard Biesheuvel wrote:
> >> > -void __init efi_idmap_init(void)
> >> > +void __init efi_memmap_init(void)
> >> >  {
> >> > +   u64 mapsize;
> >> > +
> >> >     if (!efi_enabled(EFI_BOOT))
> >> >             return;
> >> >
> >> > +   /* replace early memmap mapping with permanent mapping */
> >> > +   mapsize = memmap.map_end - memmap.map;
> >> > +   memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
> >> > +                                              mapsize);
> >>
> >> ioremap_cache() could potententially fail here if the phys_map address
> >> doesn't have a valid pfn (not in the kernel linear ram mapping) because
> >> some of the underlying vm support hasn't been initialized yet.
> >
> > Can you be more specific about the case you have in mind, please? pfn_valid
> > uses the memblocks on arm64, and that should all have been sorted out in
> > paging_init(). What's the issue that you're anticipating?
> 
> I think Mark's concern is that it is too early to call
> __get_free_page(), which is what happens if ioremap_cache() finds that
> the requested address is not covered by the existing linear mapping.
> Currently, UEFI reserved RAM regions are covered by the linear
> mapping, but that is something we intend to change in the future.

Which shouldn't be a problem, right? Since this function will be going
away with your "stable mappings" set, and the remap call bumped down
to an early initcall in arm64_enter_virtual_mode() (or potential
future name for that function).

/
    Leif
