From: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] arm64: extra entries in /proc/iomem for kexec
Date: Thu, 5 Apr 2018 11:42:05 +0900
Message-ID: <20180405024203.GD19607@linaro.org>
References: <20180314082941.GM25863@linaro.org>
 <2d2e1be6-b925-1595-9b6e-76dd270d396d@redhat.com>
 <20180327101654.GB14737@linaro.org>
 <da2989ec-7fa5-b044-3237-4e75f2fe6d98@arm.com>
 <20180402015330.GA27603@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180402015330.GA27603-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 02, 2018 at 10:53:32AM +0900, AKASHI Takahiro wrote:
> James,
> 
> My apologies for slow response. I had a long weekend.
> 
> On Tue, Mar 27, 2018 at 02:32:49PM +0100, James Morse wrote:
> > Hi Akashi,
> > 
> > On 27/03/18 11:16, AKASHI Takahiro wrote:
> > > On Tue, Mar 20, 2018 at 01:18:34AM +0530, Bhupesh Sharma wrote:
> > >> On 03/14/2018 01:59 PM, AKASHI Takahiro wrote:
> > >>> Currently, there is a inconsistent view between (A) and the mainline's:
> > >>> see (A-1) and (B-1). If this is really a matter, I can fix it.
> > >>> Kexec-tools can be easily modified to accept both formats, though.
> > 
> > Ooer, what needs changing in kexec-tools? What happens if someone doesn't update
> > userspace at the same time?
> 
> Basically, changes that I made on /proc/iomem in my new format D were:
> 1. to move NOMAP region entries, formerly named "reserved" and now named
>    "reserved (no map)", under System RAM
> 2. to add new entries for firmware-reserved regions as "reserved" also
>    under System RAM
> 
> On the other hand, current kexec-tools, in particular kexec command,
> only scan top-level "System RAM" entries as well as "reserved" entries.
> 
> So if someone doesn't update kexec-tools, secondary kernel may potentially
> crash during boot time either because
> a. new kernel (or initrd/dtb) may have been allocated on a NOMAP region
>    which are not suitable for usable memory, or
> b. new kernel (or initrd/dtb) may have been allocated on a reserved region
>    whose contents can be overwritten.
> 
> While we see (b) even today, (a) is a backward compatibility issue.
> 
> Note: we have a different story for kdump (alignment error), and I will
> take a different approach to fixing kdump case.
> 
> > Is there a format which doesn't require a user-space change, (and shouldn't we
> > pick that one?)
> 
> The only solution that I can imagine for now to prevent (a) and (b)
> at the same time without any user-space change is
> 2+. to add new entries for firmware-reserved regions as "reserved",
>     in addition to the current NOMAP regions, at top level
> 
> (format E)
> 40000000-5858ffff : System RAM
>   40080000-40f1ffff : Kernel code
>   41040000-411e9fff : Kernel data
>   54400000-583fffff : Crash kernel
> 58590000-585effff : reserved
> 484f0000-586fffff : System RAM 
> 58700000-5871ffff : reserved
> 58720000-58b5ffff : reserved (no map)
> 58b60000-58b0ffff : System RAM
> 58b61000-58b61fff : reserved
> 58620000-59a7b117 : System RAM
> 59a7b118-59a7b667 : reserved
> 59a7b668-5be3ffff : System RAM
> 5be40000-5becffff : reserved (no map)
> 5bed0000-5bedffff : System RAM
> 5bee0000-5bffffff : reserved (no map)
> 5ec00000-5edfffff : reserved
> 5ee00000-5fffffff ; System RAM
> 8000000000-ffffffffff : PCI Bus 0000:00
> 
> This does not only look quite noisy but also ignores the fact that
> reserved regions are part of System RAM (or memblock.memory). 
> 
> Or to maximize the compatibility, we may adopt format B:
> 
> (format B)
> 40000000-5871ffff : System RAM
>   40080000-40f1ffff : Kernel code
>   41040000-411e9fff : Kernel data
>   54400000-583fffff : Crash kernel
>   58590000-585effff : reserved
>   58700000-5871ffff : reserved
> 58720000-58b5ffff : reserved (no map)
> 58b60000-5be3ffff : System RAM
>   58b61000-58b61fff : reserved
>   59a7b118-59a7b667 : reserved
> 5be40000-5becffff : reserved (no map)
> 5bed0000-5bedffff : System RAM
> 5bee0000-5bffffff : reserved (no map)
> 5c000000-5fffffff : System RAM
>   5ec00000-5edfffff : reserved
> 8000000000-ffffffffff : PCI Bus 0000:00
> 
> but, in this case, we need some change on kexec-tools to fix (b).
> 
> > >>> 2. How should we determine which regions be exported in /proc/iomem?
> > >>>
> > >>>  a. Trust all the memblock_reserve'd regions as my previous patch [3] does.
> > >>>
> > >>>     As I said, it's a kind of "overkill." Some of regions, say fdt, are
> > >>>     not required to be preserved across kexec.
> > >>
> > >>
> > >> I think we should preserve all the memblock_reserve'd regions. So +1 on this
> > >> approach from my side. I believe it might help avoid issues we have seen in
> > >> the past with 'kexec-tools' _incorrectly_ determining which regions to pick
> > >> from the '/proc/iomem'.
> > > 
> > > As I said in my reply to Ard's comment, I now know *overkill* is not a big
> > > issue and I will go for this approach.
> > 
> > /sys/kernel/debug/memblock/reserved has all kinds of weird stuff in it,
> > including some smaller-than-a-page reservations that appear to come from the
> > percpu allocator.
> > 
> > I agree it will make the implementation simpler, and reserving 'too much' isn't
> > an issue.
> 
> Are you suggesting that we should use /sys/kernel/debug/memblock/reserved
> without modifying current /proc/iomem?
> (Note that, even in this approach, we need an user-space change.)
> 
> Hmm, overall, this approach will be preferable to format B/E.

What is nice in this approach is that we don't have to make any change
on kernel side. Now that I have a patch for kexec-tools, you can try:
https://git.linaro.org/people/takahiro.akashi/kexec-tools.git resv_mem2

# I don't know yet whether people are happy with this fix, and also have
  kernel patches for my other approaches. They are neither not much
  complicated.

On the other hand, kdump failure due to alignment fault at ACPI tables
won't be fixed by this patch anyway. I already submitted two different
approaches[1],[2].

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-January/553098.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-February/557248.html

There can be yet another approach; we would add a list of reserved regions
to a dtb property, "linux,usable-memory-range". But I don't like it.

What do you think?

Thanks,
-Takahiro AKASHI



> Thanks,
> -Takahiro AKASHI
> 
> > 
> > Thanks,
> > 
> > James
