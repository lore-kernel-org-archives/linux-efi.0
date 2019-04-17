From: Ingo Molnar <mingo@kernel.org>
Subject: Re: EFI reboot vs. ACPI reboot (was: Re: [tip:x86/urgent]
 x86/reboot, efi: Use EFI reboot for Acer TravelMate X514-51T)
Date: Wed, 17 Apr 2019 21:17:02 +0200
Message-ID: <20190417191702.GA29062@gmail.com>
References: <tip-0082517fa4bce073e7cf542633439f26538a14cc@git.kernel.org>
 <20190416082042.GA69717@gmail.com>
 <CAD8Lp44pQRYdw4cbfMt3uOSO23dzy_mWTt5T-Zjft08WWu_yUA@mail.gmail.com>
 <20190417061650.GA31060@gmail.com>
 <CAD8Lp45BLaoXF=RNcncqcTtNvaGHP72+a1CxcjoeBXDiw9TKbA@mail.gmail.com>
 <17516564-37AC-4F77-9C0D-0DD71F8045EA@zytor.com>
 <CAKv+Gu_jqoKiqq4ozcPwSxLmpuaWsFKy_xyYGhECLz+KLHOjOw@mail.gmail.com>
 <FFF73D592F13FD46B8700F0A279B802F48AFEFF2@ORSMSX114.amr.corp.intel.com>
 <20190417182341.GA5140@gmail.com>
 <CAKv+Gu9NJH02obRtgtNf7O7Bd8Z0SdKjsBLppGd60f6ryq6OoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9NJH02obRtgtNf7O7Bd8Z0SdKjsBLppGd60f6ryq6OoA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Daniel Drake <drake@endlessm.com>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jian-Hong Pan <jian-hong@endlessm.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi <linux-efi@vger.kernel.org>, "Brown, Len" <len.brown@intel.com>, "linux-tip-commits@vger.kernel.org" <linux-tip-commits@vger.kernel.org>, Endless Linux Upstreaming Team <linux@endlessm.com>
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On Wed, 17 Apr 2019 at 11:23, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > * Prakhya, Sai Praneeth <sai.praneeth.prakhya@intel.com> wrote:
> >
> > > I will ask around internally to check if it is a good idea to make EFI
> > > reboot the default method when the machine is booted in EFI mode.
> >
> > Or whether there's some robust signature that indicates "modern EFI
> > system where EFI reboot is the primary method"?
> >
> > Major EFI version or ACPI version or such?
> >
> 
> I am actually at Microsoft right now, and I managed to get
> clarification on how Windows deals with this: Windows will attempt to
> use ACPI reboot first, and will only attempt to use anything else if
> that fails. EFI reset is actually its least preferred option, and so
> it is highly likely that it is untested on most of the shipping x86
> hardware if any of the other methods work.
> 
> So let's not touch this.

Agreed and that's really useful information, thanks!

	Ingo
