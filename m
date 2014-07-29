From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: spin-table: handle unmapped cpu-release-addrs
Date: Tue, 29 Jul 2014 17:03:03 +0100
Message-ID: <20140729160303.GA32108@leverpostej>
References: <1406630950-32432-1-git-send-email-ard.biesheuvel@linaro.org>
 <1406630950-32432-2-git-send-email-ard.biesheuvel@linaro.org>
 <1406646945.753.5.camel@deneb.redhat.com>
 <2385684.COvj9k7y2z@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2385684.COvj9k7y2z@wuerfel>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 29, 2014 at 04:20:46PM +0100, Arnd Bergmann wrote:
> On Tuesday 29 July 2014 11:15:45 Mark Salter wrote:
> > > -
> > > -     __flush_dcache_area(release_addr, sizeof(release_addr[0]));
> > > +     writeq_relaxed(__pa(secondary_holding_pen), release_addr);
> > > +     __flush_dcache_area(release_addr, sizeof(*release_addr));
> > 
> >        __flush_dcache_area((__force void *)release_addr, ... 
> > 
> > to avoid sparse warning.

Presumably we'd get this for the write_relaxed too?

> > 
> 
> I think it would be cleaner to drop the __iomem annotation and use vmap()
> rather than ioremap(). That requires having a 'struct page' though, which
> I'm not sure you have.

As far as I am aware, we'd only have a struct page for memory falling in
the linear map, so for the cases this patch is actually required we
wouldn't have a struct page.

So it looks like I should just make release_addr a void __iomem *. Then
this line can just be:

__flush_dcache_area(release_addr, 8);

Where we could replace 8 with sizeof(u64), sizeof(__le64), etc if 8 is
too magic.

How does that sound?

Thanks,
Mark.
