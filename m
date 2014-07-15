From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: don't abort if base of DRAM is
 occupied
Date: Tue, 15 Jul 2014 10:23:26 -0400
Message-ID: <1405434206.25580.31.camel@deneb.redhat.com>
References: <1405351521-12010-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1405363248.25580.12.camel@deneb.redhat.com>
	 <20140715100221.GU4179@bivouac.eciton.net>
	 <1405429860.25580.25.camel@deneb.redhat.com>
	 <20140715135418.GV4179@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715135418.GV4179-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2014-07-15 at 14:54 +0100, Leif Lindholm wrote:
> On Tue, Jul 15, 2014 at 09:11:00AM -0400, Mark Salter wrote:
> > On Tue, 2014-07-15 at 11:02 +0100, Leif Lindholm wrote:
> > > > @@ -273,6 +282,10 @@ static void __init free_boot_services(void)
> > > >                       continue;
> > > >               }
> > > >  
> > > > +             /* Don't free anything below kernel */
> > > > +             if (md->phys_addr < PHYS_OFFSET)
> > > > +                     continue;
> > > > +
> > > 
> > > Is the spin table area really allocated as BOOT_SERVICES_*?
> > 
> > No. It is EFI_RESERVED_TYPE. But if UEFI is allowed below the kernel,
> > then there could be BS code/data memory which we'd want to ignore.
> 
> Well, if it is boot service code/data - then there is no need for us
> to keep it around after ExitBootServices().
> 
> /
>     Leif

One would think, but EFI has proven to be less than strictly compliant
in that regard in the past. I'm inclined to keep the boot services
around until after SetVirtualAddressMap just in case.
