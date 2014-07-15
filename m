From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: don't abort if base of DRAM is
 occupied
Date: Tue, 15 Jul 2014 16:28:36 +0100
Message-ID: <20140715152836.GX4179@bivouac.eciton.net>
References: <1405351521-12010-1-git-send-email-ard.biesheuvel@linaro.org>
 <1405363248.25580.12.camel@deneb.redhat.com>
 <20140715100221.GU4179@bivouac.eciton.net>
 <1405429860.25580.25.camel@deneb.redhat.com>
 <20140715135418.GV4179@bivouac.eciton.net>
 <1405434206.25580.31.camel@deneb.redhat.com>
 <20140715144944.GW4179@bivouac.eciton.net>
 <1405436677.25580.34.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405436677.25580.34.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 15, 2014 at 11:04:37AM -0400, Mark Salter wrote:
> On Tue, 2014-07-15 at 15:49 +0100, Leif Lindholm wrote:
> > On Tue, Jul 15, 2014 at 10:23:26AM -0400, Mark Salter wrote:
> > > On Tue, 2014-07-15 at 14:54 +0100, Leif Lindholm wrote:
> > > > On Tue, Jul 15, 2014 at 09:11:00AM -0400, Mark Salter wrote:
> > > > > On Tue, 2014-07-15 at 11:02 +0100, Leif Lindholm wrote:
> > > > > > > @@ -273,6 +282,10 @@ static void __init free_boot_services(void)
> > > > > > >                       continue;
> > > > > > >               }
> > > > > > >  
> > > > > > > +             /* Don't free anything below kernel */
> > > > > > > +             if (md->phys_addr < PHYS_OFFSET)
> > > > > > > +                     continue;
> > > > > > > +
> > > > > > 
> > > > > > Is the spin table area really allocated as BOOT_SERVICES_*?
> > > > > 
> > > > > No. It is EFI_RESERVED_TYPE. But if UEFI is allowed below the kernel,
> > > > > then there could be BS code/data memory which we'd want to ignore.
> > > > 
> > > > Well, if it is boot service code/data - then there is no need for us
> > > > to keep it around after ExitBootServices().
> > > 
> > > One would think, but EFI has proven to be less than strictly compliant
> > > in that regard in the past. I'm inclined to keep the boot services
> > > around until after SetVirtualAddressMap just in case.
> > 
> > But the function you add this clause to will still throw away all boot
> > services code/data regions - just with this modification it skips
> > those that happen to lie lower in the address space than the kernel.

Returning to the actual code we are discussing here:
The hunk above has no bearing on whether boot services regions are
generally unmapped or not. It only filters explicitly those boot
services regions that happen to be lower in memory than the kernel,
and keep them around for the duration of the system.

> > 
> > (And I do agree with Mark R here - let's not work around bugs that
> > don't exist yet.)
> > 
> 
> I'm not sure if they still exist or not, but on Foundation, I saw a
> crash in SetVirtualAddressMap unless I kept BS regions around.

For the topic of keeping boot services code around:
I did also see issues with not keeping boot services regions on v7 -
ages ago. I have not seen it this year, and I _really_ want to see if
any such issues resurface. So post-3.16 I would quite like to see the
call to free_boot_services() moved earlier to flush out any such
issues before we see large-scale deployments.

The foundation model is a development tool, not a production system,
so any issue reproducable only there is a pure bonus - since that
firmware can _always_ be updated.

/
    Leif
