From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: don't abort if base of DRAM is
 occupied
Date: Tue, 22 Jul 2014 22:28:48 +0100
Message-ID: <20140722212848.GF4179@bivouac.eciton.net>
References: <20140715100221.GU4179@bivouac.eciton.net>
 <1405429860.25580.25.camel@deneb.redhat.com>
 <20140715135418.GV4179@bivouac.eciton.net>
 <1405434206.25580.31.camel@deneb.redhat.com>
 <20140715144944.GW4179@bivouac.eciton.net>
 <1405436677.25580.34.camel@deneb.redhat.com>
 <20140715152836.GX4179@bivouac.eciton.net>
 <1405516428.25580.58.camel@deneb.redhat.com>
 <20140722170818.GD4179@bivouac.eciton.net>
 <1406057330.12484.21.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1406057330.12484.21.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 22, 2014 at 03:28:50PM -0400, Mark Salter wrote:
> > > It doesn't filter them to keep them around, it filters them to avoid
> > > calling free_bootmem_late() with an invalid address. If there are UEFI
> > > regions below the kernel, we don't want to call memblock_reserve() or
> > > free_bootmem_late() for them.
> > 
> > Then why not just flip things around and do like the arm port and only
> > add the blocks we actually want to keep around to begin with?
> 
> I'd rather leave it as-is with everything which can be covered by the
> normal kernel mem mapping.
> 
> > > > > > (And I do agree with Mark R here - let's not work around bugs that
> > > > > > don't exist yet.)
> > > > > > 
> > > > > 
> > > > > I'm not sure if they still exist or not, but on Foundation, I saw a
> > > > > crash in SetVirtualAddressMap unless I kept BS regions around.
> > > > 
> > > > For the topic of keeping boot services code around:
> > > > I did also see issues with not keeping boot services regions on v7 -
> > > > ages ago. I have not seen it this year, and I _really_ want to see if
> > > > any such issues resurface. 
> > > 
> > > My view is that a problem has been seen in the past with tianocore for
> > > arm64. There is no harm in delaying the freeing of BS regions.
> > 
> > There is a huge harm.
> 
> huge? really?

Yes. It is setting a precedent that "we will try to second-guess how
you might code incorrectly and just deal with it - in those few places
where this is possible, and not in others".

> > > The
> > > memory becomes usable for general kernel use at early_initcall time.
> > > This issue has also been seen with x86 firmware and some of those same
> > > vendors will be providing arm64 firmware.
> > 
> > This issue has been seen with x86 firmware because in the early days
> > (last year) noone bothered validating anything other than CSM. They no
> > longer have that luxury.
> > 
> > The Linux kernel, currently being the most avid tester of existing
> > arm64 UEFI firmware, falling over itself to cater for hypothetical
> > broken implementations pretty much guarantees the situation will end
> > up just as bad as it ever was on x86 - without us even having CSM.
> 
> It is hardly falling over itself. And if the problem is hypothetical,
> why is this in the arm32 EFI patches:
> 
> +/*
> + * If you need to (temporarily) support buggy firmware, set to 0.
> + */
> +#define DISCARD_BOOT_SERVICES_REGIONS 1

Because in the early days we did indeed have such an issue.
Had we not had this enabled, we never would have spotted it.

Felt useful to have around _and_disabled_ in case we ever run into
anything like it again. Haven't happened for over a year.

> > > The problem isn't reproducible
> > > now, but I'm not sure if there was a bug fix for it or if it just went
> > > underground for some reason. Kernel boot may succeed by chance if some
> > > needed BS memory isn't reused by kernel. 
> > 
> > And it may succeed by chance anyway.
> > I'm not saying we won't see broken firmware - I'm saying that this is
> > the window we have to try to _help_ people (and ourselves) by letting
> > broken firmware fail - before it happens in the data centre.
> 
> In this particular case, we are removing a workaround to a problem
> which has been seen in the past. So we would open a door to allow
> this particular problem to reach the data center.

No, we are removing a workaround to a problem that has possibly been
seen in the past, not sure of the circumstances, not sure if it was a
model cache management bug.

A UEFI implementation that does not keep track of local and global
symbols is just as likely to not update a pointer between runtime
services regions as it is to not stop using boot services regions
after ExitBootServices(). Keeping boot services regions around does
not solve the problem - it slightly reduces the likelihood of it
manifesting.

> > > > So post-3.16 I would quite like to see the
> > > > call to free_boot_services() moved earlier to flush out any such
> > > > issues before we see large-scale deployments.
> > > 
> > > You can just get rid of it altogether:
> > 
> > Well, clearly, that would not be my preference :)
> 
> Why not? There's no point in keeping it if it isn't wanted/needed. Or at
> least make it optional with a #define as in arm32. Anyway, my opinion is
> known and I'm really not that attached to the code. So, if someone wants
> to submit a patch to take it out, I'm not going to make a fuss over it.

I'll try to get that together tomorrow.
I certainly don't mind keeping a #define around (and it might enable
more code sharing arm/arm64).

/
    Leif
