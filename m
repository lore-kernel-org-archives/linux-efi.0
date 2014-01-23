From: Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 0/5] EFI memmap and other fixes, v3
Date: Thu, 23 Jan 2014 09:30:19 -0700
Message-ID: <1390494619.1792.482.camel@misato.fc.hp.com>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
	 <20140123090654.GA17297@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140123090654.GA17297@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-01-23 at 09:06 +0000, Matt Fleming wrote:
> On Sat, 18 Jan, at 12:48:13PM, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > Hi all,
> > 
> > this is the latest incarnation which should hopefully work just fine. It
> > tpasses esting at least on all our boxes so we have *some* coverage.
> > 
> > It took us a long time to debug the unmapping path and realize how
> > exactly we're doing the PGD sharing between the kernel and the EFI page
> > table. I've commented on this verbosely in 4/5 for future reference
> > because this stuff is not trivial.
> > 
> > We definitely should have this in mind when we do more changes on how we
> > handle the EFI page table and what we do with it, maybe even decouple it
> > completely from the kernel one. I dunno - it is all future stuff to pay
> > attention to.
> > 
> > Anyway, if anyone with an EFI box wants to give it a run, feel free to
> > do so.
> > 
> > As always, all comments and suggestions are appreciated.
> 
> Thanks Borislav. I picked these up and applied them to my 'next' branch.
> 
> You'll notice that I haven't stuck them in my 'urgent' branch, so these
> won't be sent to Linus before v3.15 despite the fact that they're bug
> fixes. I think Toshi's box is special enough that most people shouldn't
> hit this issue, and since these patches involve rewriting the way we do
> SetVirtualAddressMap() I'm happy for people to hammer on the stuff that
> did make it into the merge window without this added complication.
> 
> Having said that, if people think it's worth the effort I don't mind
> setting up a new branch containing this series that can be sent to Linus
> much sooner.

Since this issue is quite serious on our systems (3.14 kernels won't
boot up), I'd really appreciate if the fixes can be made into some
3.14-rc.  It can hit on any EFI systems with large memory.

Thanks,
-Toshi
