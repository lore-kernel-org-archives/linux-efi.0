From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: don't abort if base of DRAM is
 occupied
Date: Tue, 15 Jul 2014 12:05:55 +0100
Message-ID: <20140715110555.GX26465@leverpostej>
References: <1405351521-12010-1-git-send-email-ard.biesheuvel@linaro.org>
 <1405363248.25580.12.camel@deneb.redhat.com>
 <20140715100221.GU4179@bivouac.eciton.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140715100221.GU4179-t77nlHhSwNqAroYi2ySoxKxOck334EZe@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 15, 2014 at 11:02:22AM +0100, Leif Lindholm wrote:
> On Mon, Jul 14, 2014 at 02:40:48PM -0400, Mark Salter wrote:
> > On Mon, 2014-07-14 at 17:25 +0200, Ard Biesheuvel wrote:
> > > If we fail to relocate the kernel Image to its preferred offset of TEXT_OFFSET
> > > bytes above the base of DRAM, accept the lowest alternative mapping available
> > > instead of aborting. We may lose a bit of memory at the low end, but we can
> > > still proceed normally otherwise.
> > 
> > This breaks APM Mustang because the spin-table holding pen for secondary
> > CPUs is marked as reserved memory in the TEXT_OFFSET area and the kernel
> > placement using your patch makes it unreachable by kernel. Here is a
> > patch I've been working with to solve the same problem:
> 
> Hmm. The thing I don't like about the below approach is that it hard
> wires in the "memory below TEXT_OFFSET cannot be used" aspect, beyond
> the current prectical limitation.
> 
> Since we are likely to see platforms with UEFI memory in use around
> start of RAM, that is a limitation we should probably try to get rid of.

This isn't just an issue for UEFI. There are other reasons one might
want to load a kernel away from the start of RAM while still wanting to
address said RAM(e.g. kdump).

We should address that.

[...]

> > @@ -273,6 +282,10 @@ static void __init free_boot_services(void)
> >  			continue;
> >  		}
> >  
> > +		/* Don't free anything below kernel */
> > +		if (md->phys_addr < PHYS_OFFSET)
> > +			continue;
> > +
> 
> Is the spin table area really allocated as BOOT_SERVICES_*?

If that is the case, this platform is _broken_. The spin-table memory
(both the code and the mailboxes) needs to live around forever in case
you don't boot all of the secondaries.

Thanks,
Mark.
