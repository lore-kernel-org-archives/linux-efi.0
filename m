From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/10] arm64/efi: use UEFI memory map unconditionally if
 available
Date: Thu, 23 Oct 2014 12:19:58 -0400
Message-ID: <1414081198.6829.12.camel@deneb.redhat.com>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1413987713-30528-7-git-send-email-ard.biesheuvel@linaro.org>
	 <1413997616.2985.74.camel@deneb.redhat.com>
	 <20141023155428.GA977@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141023155428.GA977@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-10-23 at 16:54 +0100, Mark Rutland wrote:
> On Wed, Oct 22, 2014 at 06:06:56PM +0100, Mark Salter wrote:
> > On Wed, 2014-10-22 at 16:21 +0200, Ard Biesheuvel wrote:
> > > On systems that boot via UEFI, all memory nodes are deleted from the
> > > device tree, and instead, the size and location of system RAM is derived
> > > from the UEFI memory map. This is handled by reserve_regions, which not only
> > > reserves parts of memory that UEFI declares as reserved, but also installs
> > > the memblocks that cover the remaining usable memory.
> > > 
> > > Currently, reserve_regions() is only called if uefi_init() succeeds.
> > > However, it does not actually depend on anything that uefi_init() does,
> > > and not calling reserve_regions() results in a broken boot, so it is
> > > better to just call it unconditionally.
> > > 
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > ---
> > >  arch/arm64/kernel/efi.c | 11 ++++-------
> > >  1 file changed, 4 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > > index 51522ab0c6da..4cec21b1ecdd 100644
> > > --- a/arch/arm64/kernel/efi.c
> > > +++ b/arch/arm64/kernel/efi.c
> > > @@ -313,8 +313,7 @@ void __init efi_init(void)
> > >  	memmap.desc_size = params.desc_size;
> > >  	memmap.desc_version = params.desc_ver;
> > >  
> > > -	if (uefi_init() < 0)
> > > -		return;
> > > +	WARN_ON(uefi_init() < 0);
> > >  
> > >  	reserve_regions();
> > >  }
> > 
> > It also looks like EFI_BOOT flag will be set even if uefi_init fails.
> > If uefi_init fails, we only need reserve_regions() for the purpose
> > of adding memblocks. Otherwise, we end up wasting a lot of memory.
> 
> What memory are we wasting in that case? Surely the only items that we
> could choose to throw away if we failed uefi_init are
> EFI_ACPI_RECLAIM_MEMORY and EFI_MEMORY_RUNTIME?
> 
> We might want to keep those around so we can kexec into a kernel where
> we can make use of them. Surely they shouldn't take up a significant
> proportion of the available memory?

In addition, reserve_regions() also reserves BOOT_SERVICES (which gets
freed up later after set_virtual_address_map(). That won't happen if
uefi_init() fails. In any case, if uefi_init() fails, we won't be able
to find the ACPI tables kexec kernel won't be able to either. The
BOOT_SERVICES stuff is the big chunk. There was some discussion of
not reserving that but no one has gotten around to writing the patch
to clean out the code that does it.
