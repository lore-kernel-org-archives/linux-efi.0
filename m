From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 1/3] arm64: spin-table: handle unmapped
 cpu-release-addrs
Date: Thu, 31 Jul 2014 11:39:01 +0100
Message-ID: <20140731103900.GA22994@leverpostej>
References: <1406717944-24725-1-git-send-email-ard.biesheuvel@linaro.org>
 <1406717944-24725-2-git-send-email-ard.biesheuvel@linaro.org>
 <20140730113013.GL12239@arm.com>
 <CAKv+Gu8ne8k2NV12SyWye5aYJKHG0wHKAO+=V=1L89_hvyGopw@mail.gmail.com>
 <20140731094515.GE26853@arm.com>
 <20140731095854.GC21850@leverpostej>
 <20140731100439.GI26853@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140731100439.GI26853-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 31, 2014 at 11:04:39AM +0100, Will Deacon wrote:
> On Thu, Jul 31, 2014 at 10:58:54AM +0100, Mark Rutland wrote:
> > On Thu, Jul 31, 2014 at 10:45:15AM +0100, Will Deacon wrote:
> > > On Wed, Jul 30, 2014 at 08:17:02PM +0100, Ard Biesheuvel wrote:
> > > > ]On 30 July 2014 13:30, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> > > > > On Wed, Jul 30, 2014 at 11:59:02AM +0100, Ard Biesheuvel wrote:
> > > > >> From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > > > >>
> > > > >> In certain cases the cpu-release-addr of a CPU may not fall in the
> > > > >> linear mapping (e.g. when the kernel is loaded above this address due to
> > > > >> the presence of other images in memory). This is problematic for the
> > > > >> spin-table code as it assumes that it can trivially convert a
> > > > >> cpu-release-addr to a valid VA in the linear map.
> > > > >>
> > > > >> This patch modifies the spin-table code to use a temporary cached
> > > > >> mapping to write to a given cpu-release-addr, enabling us to support
> > > > >> addresses regardless of whether they are covered by the linear mapping.
> > > > >>
> > > > >> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > > > >> Tested-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > > >> [ardb: added (__force void *) cast]
> > > > >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > > > >> ---
> > > > >>  arch/arm64/kernel/smp_spin_table.c | 22 +++++++++++++++++-----
> > > > >>  1 file changed, 17 insertions(+), 5 deletions(-)
> > > > >
> > > > > I'm nervous about this. What if the spin table sits in the same physical 64k
> > > > > frame as a read-sensitive device and we're running with 64k pages?
> > > > >
> > > > 
> > > > Actually, booting.txt requires cpu-release-addr to point to a
> > > > /memreserve/d part of memory, which implies DRAM (or you wouldn't have
> > > > to memreserve it)
> > > > That means it should always be covered by the linear mapping, unless
> > > > it is located before Image in DRAM, which is the case addressed by
> > > > this patch.
> > > 
> > > But if it's located before before the Image in DRAM and isn't covered by
> > > the linear mapping, then surely the /memreserve/ is pointless too? In which
> > > case, this looks like we're simply trying to cater for platforms that aren't
> > > following booting.txt (which may need updating if we need to handle this).
> > 
> > No. The DT is describing the memory which is present, and the subset
> > thereof which should not be used under normal circumstances. That's a
> > static property of the system.
> > 
> > Where the OS happens to get loaded and what it is able to address is a
> > dynamic property of the OS (and possibly the bootloader). The DT cannot
> > have knowledge of this.
> > 
> > It's always true that the OS should not blindly use memreserve'd memory.
> > The fact that it cannot address it in the linear mapping is orthogonal.
> 
> In which case, I think asserting that /memreserve/ implies DRAM is pretty
> fragile and not actually enforced anywhere. Sure, we can say `don't do
> that', but I'd prefer to have the kernel detect this dynamically.

I think the boot protocol needs an update to allow a cpu-release-addr
not covered by linear mapping. There are reasons that the kernel might
not be loaded at the start of RAM, and I think relying on the
cpu-release-addr addresses lying in the linear mapping is a limitation
we need to address. Given that I also think we should allow for
cpu-release-addrs outside of the range desribed by memory nodes (and
therefore not requiring any /mremreserve/).

I do not think we should rely on being able to address the
cpu-release-addr with a normal cacheable mapping. If the
cpu-release-addr falls outside of the memory described by the memory
node(s) then we have no idea where it lives. Currently this falls in
normal memory, but mandating that feels odd.

The sole purpose of /memreserve/ is to describe areas in physical memory
that memory should not be used for general allocation. I don't think it
makes any sense to derive any information from /memreserve/ other than
the fact said addresses shouldn't be poked arbitarily. If we allow
cpu-release-addrs outside of memory, then we won't have a /memreserve/
anyhow.

So the question becomes can or can't we always detect when we already
have a mapping that covers a cpu-release-addr?

> Does dtc check that the /memreserve/ region is actually a subset of the
> memory node?

I don't beleive it does. It's probably a sensible warning, but as far as
I am aware the only time the memory reservation table will be read in
any OS is to poke holes in its memory allocation pool(s).

Cheers,
Mark.
