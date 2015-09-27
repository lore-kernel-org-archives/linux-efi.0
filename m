From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Sun, 27 Sep 2015 08:50:45 +0200
Message-ID: <20150927065044.GA26125@gmail.com>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
 <20150926055643.GA25877@gmail.com>
 <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUeGAedCKcSCvedyooamr6-tyfb3-b3uYDZG+k3Q_v9rw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "Lee, Chun-Yi" <jlee@suse.com>, Borislav Petkov <bp@suse.de>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, James Bottomley <JBottomley@odin.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Dave Young <dyoung@redhat.com>, stable <stable@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Brian Gerst <brgerst@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> On Fri, Sep 25, 2015 at 10:56 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > So this commit worries me.
> >
> > This bug is a good find, and the fix is obviously needed and urgent, but I'm not
> > sure about the implementation at all. (I've Cc:-ed a few more x86 low level
> > gents.)
> >
> > * Matt Fleming <matt@codeblueprint.co.uk> wrote:
> >> +             /*
> >> +              * Starting in UEFI v2.5 the EFI_PROPERTIES_TABLE
> >> +              * config table feature requires us to map all entries
> >> +              * in the same order as they appear in the EFI memory
> >> +              * map. That is to say, entry N must have a lower
> >> +              * virtual address than entry N+1. This is because the
> >> +              * firmware toolchain leaves relative references in
> >> +              * the code/data sections, which are split and become
> >> +              * separate EFI memory regions. Mapping things
> >> +              * out-of-order leads to the firmware accessing
> >> +              * unmapped addresses.
> >> +              *
> 
> I'm clearly missing something.  What is EFI doing that it doesn't care how big 
> the gap between sections is but it still requires them to be in order?  It's not 
> as though x86_64 has an addressing mode that allows only non-negative offsets.

It appears the problem is that what we think to be 'different sections' are in 
reality smaller parts of the same section.

Any relative address calculation will be broken if we don't preserve the relative 
positions of these sections/sub-sections. Any CPU that supports addition is 
affected, it doesn't need any special addressing modes.

Thanks,

	Ingo
