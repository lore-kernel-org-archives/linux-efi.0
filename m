From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 3/3] x86/efi: Use efi_switch_mm() rather than manually
 twiddling with cr3
Date: Thu, 17 Aug 2017 11:35:15 +0100
Message-ID: <20170817103514.GC27872@arm.com>
References: <1502824706-30762-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1502824706-30762-4-git-send-email-sai.praneeth.prakhya@intel.com>
 <CALCETrUnT0YL_F3mXyJzi=NE5jvFUUQbwjdK5224zDKkTts-UQ@mail.gmail.com>
 <CAKv+Gu8AySQSXtRWfHA4y5DbH-DQ7jpqkp=tS+snSTar_sKBJw@mail.gmail.com>
 <20170816095338.GB17270@leverpostej>
 <20170816100709.GG12845@arm.com>
 <20170816110321.GC17270@leverpostej>
 <20170816125715.GB3384@codeblueprint.co.uk>
 <CALCETrVSHuz=hcAgGxYHBmpiNcP4ECrJh885cR4X17QsJVj8+w@mail.gmail.com>
 <20170815223541.GA25778@remoulade>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170815223541.GA25778@remoulade>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Peter Zijlstra <peterz@infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, joeyli <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, "Michael S. Tsirkin" <mst@redhat.com>, "Neri, Ricardo" <ricardo.neri@intel.com>, "Ravi V. Shankar" <ravi.v.shankar@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 15, 2017 at 11:35:41PM +0100, Mark Rutland wrote:
> On Wed, Aug 16, 2017 at 09:14:41AM -0700, Andy Lutomirski wrote:
> > On Wed, Aug 16, 2017 at 5:57 AM, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> > > On Wed, 16 Aug, at 12:03:22PM, Mark Rutland wrote:
> > >>
> > >> I'd expect we'd abort at a higher level, not taking any sample. i.e.
> > >> we'd have the core overflow handler check in_funny_mm(), and if so, skip
> > >> the sample, as with the skid case.
> > >
> > > FYI, this is my preferred solution for x86 too.
> > 
> > One option for the "funny mm" flag would be literally the condition
> > current->mm != current->active_mm.  I *think* this gets all the cases
> > right as long as efi_switch_mm is careful with its ordering and that
> > the arch switch_mm() code can handle the resulting ordering.  (x86's
> > can now, I think, or at least will be able to in 4.14 -- not sure
> > about other arches).
> 
> For arm64 we'd have to rework things a bit to get the ordering right
> (especially when we flip to/from the idmap), but otherwise this sounds sane to
> me.
> 
> > That being said, there's a totally different solution: run EFI
> > callbacks in a kernel thread.  This has other benefits: we could run
> > those callbacks in user mode some day, and doing *that* in a user
> > thread seems like a mistake.
> 
> I think that wouldn't work for CPU-bound perf events (which are not
> ctx-switched with the task).
> 
> It might be desireable to do that anyway, though.

I'm still concerned that we're treating perf specially here -- are we
absolutely sure that nobody else is going to attempt user accesses off the
back of an interrupt? If not, then I'd much prefer a solution that catches
anybody doing that with the EFI page table installed, rather than trying
to play whack-a-mole like this.

Will
