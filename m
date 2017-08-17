From: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Thu, 17 Aug 2017 08:52:38 -0700
Message-ID: <CALCETrVhLmntPArQiuOcQeNf9Y2kDxa+mUY=v1P8rVOkeCZn4Q@mail.gmail.com>
References: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1502824706-30762-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com>
 <CAKv+Gu8AySQSXtRWfHA4y5DbH-DQ7jpqkp=tS+snSTar_sKBJw@mail.gmail.com>
 <20170816095338.GB17270@leverpostej> <20170816100709.GG12845@arm.com>
 <20170816110321.GC17270@leverpostej> <20170816125715.GB3384@codeblueprint.co.uk>
 <CALCETrVSHuz=hcAgGxYHBmpiNcP4ECrJh885cR4X17QsJVj8+w@mail.gmail.com>
 <20170815223541.GA25778@remoulade> <20170817103514.GC27872@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817103514.GC27872-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Neri, Ricardo" <ricardo.neri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ravi V. Shankar" <ravi.v.shankar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Aug 17, 2017 at 3:35 AM, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> On Tue, Aug 15, 2017 at 11:35:41PM +0100, Mark Rutland wrote:
>> On Wed, Aug 16, 2017 at 09:14:41AM -0700, Andy Lutomirski wrote:
>> > On Wed, Aug 16, 2017 at 5:57 AM, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>> > > On Wed, 16 Aug, at 12:03:22PM, Mark Rutland wrote:
>> > >>
>> > >> I'd expect we'd abort at a higher level, not taking any sample. i.e.
>> > >> we'd have the core overflow handler check in_funny_mm(), and if so, skip
>> > >> the sample, as with the skid case.
>> > >
>> > > FYI, this is my preferred solution for x86 too.
>> >
>> > One option for the "funny mm" flag would be literally the condition
>> > current->mm != current->active_mm.  I *think* this gets all the cases
>> > right as long as efi_switch_mm is careful with its ordering and that
>> > the arch switch_mm() code can handle the resulting ordering.  (x86's
>> > can now, I think, or at least will be able to in 4.14 -- not sure
>> > about other arches).
>>
>> For arm64 we'd have to rework things a bit to get the ordering right
>> (especially when we flip to/from the idmap), but otherwise this sounds sane to
>> me.
>>
>> > That being said, there's a totally different solution: run EFI
>> > callbacks in a kernel thread.  This has other benefits: we could run
>> > those callbacks in user mode some day, and doing *that* in a user
>> > thread seems like a mistake.
>>
>> I think that wouldn't work for CPU-bound perf events (which are not
>> ctx-switched with the task).
>>
>> It might be desireable to do that anyway, though.
>
> I'm still concerned that we're treating perf specially here -- are we
> absolutely sure that nobody else is going to attempt user accesses off the
> back of an interrupt?

Reasonably sure?  If nothing else, an interrupt taken while mmap_sem()
is held for write that tries to access user memory is asking for
serious trouble.  There are still a few callers of pagefault_disable()
and copy...inatomic(), though.

> If not, then I'd much prefer a solution that catches
> anybody doing that with the EFI page table installed, rather than trying
> to play whack-a-mole like this.

Using a kernel thread solves the problem for real.  Anything that
blindly accesses user memory in kernel thread context is terminally
broken no matter what.

>
> Will
