From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [GIT PULL] EFI changes for v3.20
Date: Thu, 29 Jan 2015 19:21:32 +0100
Message-ID: <20150129182132.GA24418@gmail.com>
References: <20150121140250.GE12079@codeblueprint.co.uk>
 <20150126223220.GF3320@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150126223220.GF3320@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt@codeblueprint.co.uk> wrote:

> On Wed, 21 Jan, at 02:02:50PM, Matt Fleming wrote:
> > Folks, please consider pulling the following changes for v3.20. There's
> > nothing super scary, mainly cleanups, and a merge from Ricardo who
> > kindly picked up some patches from the linux-efi mailing list while I
> > was out on annual leave in December.
> > 
> > Perhaps the biggest risk is the get_memory_map() change from Ard, which
> > changes the way that both the arm64 and x86 EFI boot stub build the
> > early memory map. It would be good to have it bake in linux-next for a
> > while.
> > 
> > One other thing to note is that I've picked up an rtc-efi patch from Ard
> > because the rtc maintainer hasn't been responsive for a while now.
> > 
> > The following changes since commit 8266e31ed0fedb7ee16ebc86e80468f7cc1bbb4e:
> > 
> >   x86, ptdump: Add section for EFI runtime services (2014-11-11 22:28:57 +0000)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next
> > 
> > for you to fetch changes up to 11629305043c513454c4ccb4fc384a1bfe610647:
> > 
> >   efi: Don't look for chosen@0 node on DT platforms (2015-01-20 22:41:56 +0000)

Pulled into tip:x86/efi, thanks a lot Matt!

	Ingo
