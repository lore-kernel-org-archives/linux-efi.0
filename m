From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: spin-table: handle unmapped cpu-release-addrs
Date: Tue, 29 Jul 2014 18:13:07 +0200
Message-ID: <11934363.ljlrQOGpcO@wuerfel>
References: <1406630950-32432-1-git-send-email-ard.biesheuvel@linaro.org> <2385684.COvj9k7y2z@wuerfel> <20140729160303.GA32108@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140729160303.GA32108@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tuesday 29 July 2014 17:03:03 Mark Rutland wrote:
> On Tue, Jul 29, 2014 at 04:20:46PM +0100, Arnd Bergmann wrote:
> > On Tuesday 29 July 2014 11:15:45 Mark Salter wrote:
> > > > -
> > > > -     __flush_dcache_area(release_addr, sizeof(release_addr[0]));
> > > > +     writeq_relaxed(__pa(secondary_holding_pen), release_addr);
> > > > +     __flush_dcache_area(release_addr, sizeof(*release_addr));
> > > 
> > >        __flush_dcache_area((__force void *)release_addr, ... 
> > > 
> > > to avoid sparse warning.
> 
> Presumably we'd get this for the write_relaxed too?

writeq_relaxed() actually expects an __iomem  pointer

> > 
> > I think it would be cleaner to drop the __iomem annotation and use vmap()
> > rather than ioremap(). That requires having a 'struct page' though, which
> > I'm not sure you have.
> 
> As far as I am aware, we'd only have a struct page for memory falling in
> the linear map, so for the cases this patch is actually required we
> wouldn't have a struct page.
> 
> So it looks like I should just make release_addr a void __iomem *. Then
> this line can just be:

You mean make it a 'void *' instead of 'void __iomem *', right?

> __flush_dcache_area(release_addr, 8);
> 
> Where we could replace 8 with sizeof(u64), sizeof(__le64), etc if 8 is
> too magic.
> 
> How does that sound?

Not sure where you're getting at. Using a regular pointer sounds fine,
but then you have to cast the result of ioremap and do a manual
cpu_to_le64 conversion on the assignment.

Keeping the iomem annotation will also work,a nd then we only need
the cast in the __flush_dcache_area call.

	Arnd
