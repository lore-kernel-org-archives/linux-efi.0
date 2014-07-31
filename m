From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] arm64: spin-table: handle unmapped cpu-release-addrs
Date: Thu, 31 Jul 2014 12:16:59 +0200
Message-ID: <CAKv+Gu_SSjTB=PWz22iom72deq6qhoSNmPCWh1NaxoLJxhMBeQ@mail.gmail.com>
References: <1406717944-24725-1-git-send-email-ard.biesheuvel@linaro.org>
	<1406717944-24725-2-git-send-email-ard.biesheuvel@linaro.org>
	<20140730113013.GL12239@arm.com>
	<CAKv+Gu8ne8k2NV12SyWye5aYJKHG0wHKAO+=V=1L89_hvyGopw@mail.gmail.com>
	<20140731094515.GE26853@arm.com>
	<20140731095854.GC21850@leverpostej>
	<20140731100439.GI26853@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140731100439.GI26853-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 31 July 2014 12:04, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> On Thu, Jul 31, 2014 at 10:58:54AM +0100, Mark Rutland wrote:
>> On Thu, Jul 31, 2014 at 10:45:15AM +0100, Will Deacon wrote:
>> > On Wed, Jul 30, 2014 at 08:17:02PM +0100, Ard Biesheuvel wrote:
>> > > ]On 30 July 2014 13:30, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
>> > > > On Wed, Jul 30, 2014 at 11:59:02AM +0100, Ard Biesheuvel wrote:
>> > > >> From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>> > > >>
>> > > >> In certain cases the cpu-release-addr of a CPU may not fall in the
>> > > >> linear mapping (e.g. when the kernel is loaded above this address due to
>> > > >> the presence of other images in memory). This is problematic for the
>> > > >> spin-table code as it assumes that it can trivially convert a
>> > > >> cpu-release-addr to a valid VA in the linear map.
>> > > >>
>> > > >> This patch modifies the spin-table code to use a temporary cached
>> > > >> mapping to write to a given cpu-release-addr, enabling us to support
>> > > >> addresses regardless of whether they are covered by the linear mapping.
>> > > >>
>> > > >> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>> > > >> Tested-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > > >> [ardb: added (__force void *) cast]
>> > > >> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > > >> ---
>> > > >>  arch/arm64/kernel/smp_spin_table.c | 22 +++++++++++++++++-----
>> > > >>  1 file changed, 17 insertions(+), 5 deletions(-)
>> > > >
>> > > > I'm nervous about this. What if the spin table sits in the same physical 64k
>> > > > frame as a read-sensitive device and we're running with 64k pages?
>> > > >
>> > >
>> > > Actually, booting.txt requires cpu-release-addr to point to a
>> > > /memreserve/d part of memory, which implies DRAM (or you wouldn't have
>> > > to memreserve it)
>> > > That means it should always be covered by the linear mapping, unless
>> > > it is located before Image in DRAM, which is the case addressed by
>> > > this patch.
>> >
>> > But if it's located before before the Image in DRAM and isn't covered by
>> > the linear mapping, then surely the /memreserve/ is pointless too? In which
>> > case, this looks like we're simply trying to cater for platforms that aren't
>> > following booting.txt (which may need updating if we need to handle this).
>>
>> No. The DT is describing the memory which is present, and the subset
>> thereof which should not be used under normal circumstances. That's a
>> static property of the system.
>>
>> Where the OS happens to get loaded and what it is able to address is a
>> dynamic property of the OS (and possibly the bootloader). The DT cannot
>> have knowledge of this.
>>
>> It's always true that the OS should not blindly use memreserve'd memory.
>> The fact that it cannot address it in the linear mapping is orthogonal.
>
> In which case, I think asserting that /memreserve/ implies DRAM is pretty
> fragile and not actually enforced anywhere. Sure, we can say `don't do
> that', but I'd prefer to have the kernel detect this dynamically.
>

The point is whether we can assume that cpu-release-addr always
resides in DRAM, not whether /memreserve/ implies DRAM. The former
should be the case for all current implementations, because we only
ever access it through the linear mapping.

This means that rather than worrying about all the corner cases where
cpu-release-addr may share its 64k physical frame with device
registers etc, couldn't we just update booting.txt to state that
cpu-release-addr should be chosen such that it can be mapped with a
64k granule MT_NORMAL mapping?

-- 
Ard.



> Does dtc check that the /memreserve/ region is actually a subset of the
> memory node?
>
> Will
