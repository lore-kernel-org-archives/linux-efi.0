From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 4.4 103/105] Revert "x86/mm/pat: Ensure cpa->pfn only
 contains page frame numbers"
Date: Fri, 24 Aug 2018 15:54:31 +0100
Message-ID: <20180824145431.GC4253@codeblueprint.co.uk>
References: <20171215092305.994559179@linuxfoundation.org>
 <20171215092311.347628971@linuxfoundation.org>
 <CAL1RGDVgShymmT+TJ3mAHEL7n+qoisk6mQ=Tji_T=0d_QA=VKw@mail.gmail.com>
 <20180823061253.GA8803@kroah.com>
 <CAL1RGDUxkWm+tSdLmptSZZ55mdWCR6i1GevMUx_K-a2BX74xdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDUxkWm+tSdLmptSZZ55mdWCR6i1GevMUx_K-a2BX74xdQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ben.hutchings@codethink.co.uk, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, bp@suse.de, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, luto@kernel.org, ard.biesheuvel@linaro.org, bp@alien8.de, brgerst@gmail.com, davej@codemonkey.org.uk, dvlasenk@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, sai.praneeth.prakhya@intel.com, sds@tycho.nsa.gov, Thomas Gleixner <tglx@linutronix.de>, toshi.kani@hp.com, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Yazen.Ghannam@amd.com
List-Id: linux-efi@vger.kernel.org

On Thu, 23 Aug, at 09:37:28AM, Roland Dreier wrote:
> > > This is bad enough that 4.4.148 and all newer 4.4.y crash early in
> > > boot on some EFI systems that I have.
> >
> > Ugh, not good.
> >
> > > For now I am re-applying the "ensure cpa->pfn only contains page frame
> > > numbers" patch, ported on top of 4.4.151.
> >
> > I can try to add it back and see what blows up, want me to attempt that?
> 
> Not sure what to say... the current state is obviously broken.  If you
> look at what 02ff2769edbc is doing, it's clear that we're now shifting
> cpa->pfn by PAGE_SHIFT where we weren't before, so we're putting bogus
> values in the page table.  And this is enough that my server system
> booting with EFI crashes early in boot efi_enter_virtual_mode() with
> the symptom that NX is improperly set on some pages (booting with
> "noexec=off" fixes things, although obviously I don't want to run that
> way).  FWIW I can confirm that reverting the single patch 02ff2769edbc
> fixes things, as does the cpa->pfn fix I mentioned above.
> 
> It's hard for me to make a call on applying "ensure cpa->pfn only
> contains page frame numbers" without knowing the problems it caused
> before.  The patch looks fine to me and I definitely need it, but
> maybe it exposes some other bug elsewhere?  Maybe Ben or Matt remember
> more above why this was reverted in 4.4.106?  Otherwise I'd say yeah,
> we should re-apply it, since I don't think we want to revert
> 02ff2769edbc.

For the record, I wasn't even aware it had been reverted.
