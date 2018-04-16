From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: Re: [RFC] arm64: extra entries in /proc/iomem for kexec
Date: Mon, 16 Apr 2018 19:08:32 +0900
Message-ID: <20180416100831.GF13168@linaro.org>
References: <20180314082941.GM25863@linaro.org>
 <2d2e1be6-b925-1595-9b6e-76dd270d396d@redhat.com>
 <20180327101654.GB14737@linaro.org>
 <da2989ec-7fa5-b044-3237-4e75f2fe6d98@arm.com>
 <20180402015330.GA27603@linaro.org>
 <20180405024203.GD19607@linaro.org>
 <4c59b4c3-cff4-ac69-9576-6bcbf507ef1f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <4c59b4c3-cff4-ac69-9576-6bcbf507ef1f@arm.com>
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

On Thu, Apr 12, 2018 at 05:01:52PM +0100, James Morse wrote:
> Hi Akashi,
> 
> Sorry I've been sluggish on this issue,
> 
> On 05/04/18 03:42, AKASHI Takahiro wrote:
> > On Mon, Apr 02, 2018 at 10:53:32AM +0900, AKASHI Takahiro wrote:
> >> On Tue, Mar 27, 2018 at 02:32:49PM +0100, James Morse wrote:
> >>> On 27/03/18 11:16, AKASHI Takahiro wrote:
> >>>> On Tue, Mar 20, 2018 at 01:18:34AM +0530, Bhupesh Sharma wrote:
> >>>>> On 03/14/2018 01:59 PM, AKASHI Takahiro wrote:
> >>>>>> Currently, there is a inconsistent view between (A) and the mainline's:
> >>>>>> see (A-1) and (B-1). If this is really a matter, I can fix it.
> >>>>>> Kexec-tools can be easily modified to accept both formats, though.
> >>>
> >>> Ooer, what needs changing in kexec-tools? What happens if someone doesn't update
> >>> userspace at the same time?
> >>
> >> Basically, changes that I made on /proc/iomem in my new format D were:
> >> 1. to move NOMAP region entries, formerly named "reserved" and now named
> >>    "reserved (no map)", under System RAM
> >> 2. to add new entries for firmware-reserved regions as "reserved" also
> >>    under System RAM
> >>
> >> On the other hand, current kexec-tools, in particular kexec command,
> >> only scan top-level "System RAM" entries as well as "reserved" entries.
> 
> as well as?

I had few words here.
The current kexec-tools assumes that "reserved" entries appear only
at the top level. So,

> Does this mean kexec will pick up the reserved region if its written as:
> | 00001000-0009d7ff : System RAM
> |    00001000-00001fff  : reserved

if this is the case, the range "0x1000-0x1fff" is added to an internal
list of memory ranges but will later be *ignored* by locate_hole() function
due to its memory type.
That is, the range can potentially be overwritten by loaded kernel/initrd.

> 
> >> So if someone doesn't update kexec-tools, secondary kernel may potentially
> >> crash during boot time
> 
> Doesn't this make it a kernel bug? This didn't happen before v4.14 because nomap
> and kexec-don't-write-here were the same thing. Since f56ab9a5b73c they aren't,
> as ACPI_RECLAIM_MEMORY is_usable_memory(). The memblock_reserve() is enough to
> stop the kernel overwriting the region, but not to stop kexec placing the new
> kernel over the top.
> 
> (now I can't see how the efi memory map itself is reserved ... I thought that
> was nomap too, but it looks like its just 'not mapped' when efi_init() is called)

(I will check.)

> 
> >> either because
> >> a. new kernel (or initrd/dtb) may have been allocated on a NOMAP region
> >>    which are not suitable for usable memory, or
> >> b. new kernel (or initrd/dtb) may have been allocated on a reserved region
> >>    whose contents can be overwritten.
> >>
> >> While we see (b) even today, (a) is a backward compatibility issue.
> 
> (a) doesn't happen because request_standard_resources() checks
> memblock_is_nomap(), and reports those regions as 'reserved'.

I might have confused you. The assumption here was that we adopt format (D),
where all NOMAP regions are sub nodes of "System RAM", but still use
the current kexec-tools.
As I said above, this will end up an un-expected behavior.

> 
> [...]
> 
> >>>>> I think we should preserve all the memblock_reserve'd regions. So +1 on this
> >>>>> approach from my side. I believe it might help avoid issues we have seen in
> >>>>> the past with 'kexec-tools' _incorrectly_ determining which regions to pick
> >>>>> from the '/proc/iomem'.
> >>>>
> >>>> As I said in my reply to Ard's comment, I now know *overkill* is not a big
> >>>> issue and I will go for this approach.
> >>>
> >>> /sys/kernel/debug/memblock/reserved has all kinds of weird stuff in it,
> >>> including some smaller-than-a-page reservations that appear to come from the
> >>> percpu allocator.
> >>>
> >>> I agree it will make the implementation simpler, and reserving 'too much' isn't
> >>> an issue.
> >>
> >> Are you suggesting that we should use /sys/kernel/debug/memblock/reserved
> >> without modifying current /proc/iomem?
> >> (Note that, even in this approach, we need an user-space change.)
> 
> Sorry for the late response: no. My point was memblock_reserve() is used for all
> sorts of different things, most of which don't matter for kexec. Its
> reservations are not always page-aligned.

I understand.

> 
> >> Hmm, overall, this approach will be preferable to format B/E.
> > 
> > What is nice in this approach is that we don't have to make any change
> > on kernel side. Now that I have a patch for kexec-tools, you can try:
> > https://git.linaro.org/people/takahiro.akashi/kexec-tools.git resv_mem2
> 
> This requires user-space to mount debugfs too, which requires CONFIG_DEBUG_FS...

Yes.

> We can't expect user-space to upgrade to fix this issue.

I'm not sure what you mean here; we can't fix the issue anyway
without changing user-space/kexec-tools as kexec_load system call totally
relies on parameters passed by kexec-tools.
(The only difference is whether we need additional kernel changes or not.)

> 
> > # I don't know yet whether people are happy with this fix, and also have
> >   kernel patches for my other approaches. They are neither not much
> >   complicated.
> 
> I don't think we should fix this in userspace, exporting all the
> memblock_reserved() regions as 'reserved' in /proc/iomem looks like the right
> thing to do.

Again, if you modify /proc/iomem, you have to update kexec-tools, too.


> ah, you have patches, I've had a couple of attempts at this too...

That's fine and it looks better than mine :)

> 
> > On the other hand, kdump failure due to alignment fault at ACPI tables
> > won't be fixed by this patch anyway. I already submitted two different
> > approaches[1],[2].
> > 
> > [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-January/553098.html
> > [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-February/557248.html
> > 
> > There can be yet another approach; we would add a list of reserved regions
> > to a dtb property, "linux,usable-memory-range". But I don't like it.
> 
> (me neither)
> 
> > What do you think?
> 
> I prefer [2] above,

I don't have a strong opinion here, but I like [1] because
the kernel handles the memory in the same manner as prior kernels did. 

> wasn't there going to be another version, with the core EFI
> stuff split out?

? I don't remember well ...

Thanks,
-Takahiro AKASHI

> 
> Thanks,
> 
> James
