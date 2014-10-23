From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 06/10] arm64/efi: use UEFI memory map unconditionally if
 available
Date: Thu, 23 Oct 2014 16:54:28 +0100
Message-ID: <20141023155428.GA977@leverpostej>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
 <1413987713-30528-7-git-send-email-ard.biesheuvel@linaro.org>
 <1413997616.2985.74.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413997616.2985.74.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 22, 2014 at 06:06:56PM +0100, Mark Salter wrote:
> On Wed, 2014-10-22 at 16:21 +0200, Ard Biesheuvel wrote:
> > On systems that boot via UEFI, all memory nodes are deleted from the
> > device tree, and instead, the size and location of system RAM is derived
> > from the UEFI memory map. This is handled by reserve_regions, which not only
> > reserves parts of memory that UEFI declares as reserved, but also installs
> > the memblocks that cover the remaining usable memory.
> > 
> > Currently, reserve_regions() is only called if uefi_init() succeeds.
> > However, it does not actually depend on anything that uefi_init() does,
> > and not calling reserve_regions() results in a broken boot, so it is
> > better to just call it unconditionally.
> > 
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  arch/arm64/kernel/efi.c | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > index 51522ab0c6da..4cec21b1ecdd 100644
> > --- a/arch/arm64/kernel/efi.c
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -313,8 +313,7 @@ void __init efi_init(void)
> >  	memmap.desc_size = params.desc_size;
> >  	memmap.desc_version = params.desc_ver;
> >  
> > -	if (uefi_init() < 0)
> > -		return;
> > +	WARN_ON(uefi_init() < 0);
> >  
> >  	reserve_regions();
> >  }
> 
> It also looks like EFI_BOOT flag will be set even if uefi_init fails.
> If uefi_init fails, we only need reserve_regions() for the purpose
> of adding memblocks. Otherwise, we end up wasting a lot of memory.

What memory are we wasting in that case? Surely the only items that we
could choose to throw away if we failed uefi_init are
EFI_ACPI_RECLAIM_MEMORY and EFI_MEMORY_RUNTIME?

We might want to keep those around so we can kexec into a kernel where
we can make use of them. Surely they shouldn't take up a significant
proportion of the available memory?

Thanks,
Mark.
