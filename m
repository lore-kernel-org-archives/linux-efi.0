From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 04/13] efi: split off remapping code from
 efi_config_init()
Date: Tue, 25 Nov 2014 17:48:24 +0000
Message-ID: <20141125174824.GJ8541@arm.com>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
 <1416315432-8534-5-git-send-email-ard.biesheuvel@linaro.org>
 <20141125172419.GD3331@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141125172419.GD3331-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 25, 2014 at 05:24:19PM +0000, Matt Fleming wrote:
> On Tue, 18 Nov, at 01:57:03PM, Ard Biesheuvel wrote:
> > Split of the remapping code from efi_config_init() so that the caller
> > can perform its own remapping. This is necessary to correctly handle
> > virtually remapped UEFI memory regions under kexec, as efi.systab will
> > have been updated to a virtual address.
> > 
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/firmware/efi/efi.c | 49 +++++++++++++++++++++++++++++-----------------
> >  include/linux/efi.h        |  2 ++
> >  2 files changed, 33 insertions(+), 18 deletions(-)
> 
> Looks straight forward.
> 
> What tree are these going through?

I think a bunch of the series is still under review, so we can probably
decide on that nearer 3.20 based on any dependencies that crop up.

Will
