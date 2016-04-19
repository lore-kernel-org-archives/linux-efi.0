From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi: ARM: avoid warning about phys_addr_t cast
Date: Tue, 19 Apr 2016 14:46:17 +0100
Message-ID: <20160419134616.GD21110@arm.com>
References: <1460968481-169298-1-git-send-email-arnd@arndb.de>
 <20160418211233.GZ2829@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418211233.GZ2829-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 18, 2016 at 10:12:33PM +0100, Matt Fleming wrote:
> On Mon, 18 Apr, at 10:34:19AM, Arnd Bergmann wrote:
> > memblock_remove() takes a phys_addr_t, which may be narrower than 64 bits,
> > causing a harmless warning:
> > 
> > drivers/firmware/efi/arm-init.c: In function 'reserve_regions':
> > include/linux/kernel.h:29:20: error: large integer implicitly truncated to unsigned type [-Werror=overflow]
> >  #define ULLONG_MAX (~0ULL)
> >                     ^
> > drivers/firmware/efi/arm-init.c:152:21: note: in expansion of macro 'ULLONG_MAX'
> >   memblock_remove(0, ULLONG_MAX);
> > 
> > This adds an explicit typecast to avoid the warning
> > 
> > Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> > Fixes: 500899c2cc3e ("efi: ARM/arm64: ignore DT memory nodes instead of removing them")
> > ---
> >  drivers/firmware/efi/arm-init.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Will, this one is for you.
> 
> Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

Thanks, I'll throw it on the pile.

Will
