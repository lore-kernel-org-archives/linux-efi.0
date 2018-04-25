From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [RFC] arm64: extra entries in /proc/iomem for kexec
Date: Wed, 25 Apr 2018 18:20:13 +0900
Message-ID: <20180425092011.GC21197@linaro.org>
References: <20180314082941.GM25863@linaro.org>
 <2d2e1be6-b925-1595-9b6e-76dd270d396d@redhat.com>
 <20180327101654.GB14737@linaro.org>
 <da2989ec-7fa5-b044-3237-4e75f2fe6d98@arm.com>
 <20180402015330.GA27603@linaro.org>
 <20180405024203.GD19607@linaro.org>
 <4c59b4c3-cff4-ac69-9576-6bcbf507ef1f@arm.com>
 <20180416100831.GF13168@linaro.org>
 <954d8b58-579a-c688-36f3-dc8d4b13cef8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <954d8b58-579a-c688-36f3-dc8d4b13cef8@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org, jhugo@codeaurora.org, Bhupesh Sharma <bhsharma@redhat.com>, tbaicar@codeaurora.org, kexec@lists.infradead.org, Bhupesh SHARMA <bhupesh.linux@gmail.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 24, 2018 at 05:08:57PM +0100, James Morse wrote:
> Hi Akashi,
> 
> On 16/04/18 11:08, AKASHI Takahiro wrote:
> > On Thu, Apr 12, 2018 at 05:01:52PM +0100, James Morse wrote:
> >> On 05/04/18 03:42, AKASHI Takahiro wrote:
> >>> On Mon, Apr 02, 2018 at 10:53:32AM +0900, AKASHI Takahiro wrote:
> >>>> Basically, changes that I made on /proc/iomem in my new format D were:
> >>>> 1. to move NOMAP region entries, formerly named "reserved" and now named
> >>>>    "reserved (no map)", under System RAM
> >>>> 2. to add new entries for firmware-reserved regions as "reserved" also
> >>>>    under System RAM
> >>>>
> >>>> On the other hand, current kexec-tools, in particular kexec command,
> >>>> only scan top-level "System RAM" entries as well as "reserved" entries.
> >>
> >> as well as?
> > 
> > I had few words here.
> > The current kexec-tools assumes that "reserved" entries appear only
> > at the top level. So,
> > 
> >> Does this mean kexec will pick up the reserved region if its written as:
> >> | 00001000-0009d7ff : System RAM
> >> |    00001000-00001fff  : reserved
> > 
> > if this is the case, the range "0x1000-0x1fff" is added to an internal
> > list of memory ranges 
> 
> I found this in get_memory_ranges_iomem_cb()...
> 
> 
> > but will later be *ignored* by locate_hole() function
> > due to its memory type.
> 
> Ugh. Great.
> 
> 
> > That is, the range can potentially be overwritten by loaded kernel/initrd.
> 
> So two kernel bugs, one user-space bug, all conspiring.
> 
> 
> >>>> either because
> >>>> a. new kernel (or initrd/dtb) may have been allocated on a NOMAP region
> >>>>    which are not suitable for usable memory, or
> >>>> b. new kernel (or initrd/dtb) may have been allocated on a reserved region
> >>>>    whose contents can be overwritten.
> >>>>
> >>>> While we see (b) even today, (a) is a backward compatibility issue.
> >>
> >> (a) doesn't happen because request_standard_resources() checks
> >> memblock_is_nomap(), and reports those regions as 'reserved'.
> > 
> > I might have confused you. The assumption here was that we adopt format (D),
> > where all NOMAP regions are sub nodes of "System RAM", but still use
> > the current kexec-tools.
> > As I said above, this will end up an un-expected behavior.
> 
> I'd like to fix this without having to fix user-space at the same time. It looks
> like no-one else has second level reserved regions,

This was my assumption when I sent out a patch to kexec-tools.

> so we can't blame
> kexec-tools for looking straight at them, then ignoring them.
> 
> 
> >> We can't expect user-space to upgrade to fix this issue.
> > 
> > I'm not sure what you mean here; we can't fix the issue anyway
> > without changing user-space/kexec-tools as kexec_load system call totally
> > relies on parameters passed by kexec-tools.
> > (The only difference is whether we need additional kernel changes or not.)
> 
> It looks like this was always broken because the efi memory map isn't listed as
> 'reserved' in /proc/iomem. The fallout for the new stuff is secondary.
> 
> 
> >>> # I don't know yet whether people are happy with this fix, and also have
> >>>   kernel patches for my other approaches. They are neither not much
> >>>   complicated.
> >>
> >> I don't think we should fix this in userspace, exporting all the
> >> memblock_reserved() regions as 'reserved' in /proc/iomem looks like the right
> >> thing to do.
> > 
> > Again, if you modify /proc/iomem, you have to update kexec-tools, too.
> 
> If we squash the memblock_reserved() stuff down so it appears as a top level
> 'reserved' region too, I don't think we do.

If I correctly understand, you're talking about my format (E).
As I said, it will fix the issue without modifying user-space, but

|| This does not only look quite noisy but also ignores the fact that
|| reserved regions are part of System RAM (or memblock.memory).

> This prevents the efi-memory-map
> being overwritten on kernels since kexec was merged.
>
> Its horribly fiddly to do this. The kernel code/data are special reserved
> regions that we already describe as a subset of system-ram, even though they are
> both also fragments of a bigger memblock_reserved() block.

Actually, we don't have to avoid kernel code/data regions as copying
loaded data to the final destinations will be done at the very end of kexec.

> While we can walk memblock for regions that aren't reserved, allocating memory
> in the loop changes what is reserved. That one O(N) walk ends up being four...

At most O(n^2)?

Thanks,
-Takhairo AKASHI

> I'm almost done tearing my hair out, I should have a working patch soon...
> 
> 
> >> wasn't there going to be another version, with the core EFI
> >> stuff split out?
> > 
> > ? I don't remember well ...
> 
> https://lkml.org/lkml/2018/2/1/496
> 
> 
> Thanks,
> 
> James
> 
