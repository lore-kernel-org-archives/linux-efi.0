From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] Remove EFI memmap quirk for UV
Date: Wed, 18 Nov 2015 09:00:47 +0100
Message-ID: <20151118080047.GA22813@gmail.com>
References: <1447696781-159611-1-git-send-email-athorlton@sgi.com>
 <20151117193258.GB9374@pd.tnic>
 <20151118015630.GC161386@asylum.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151118015630.GC161386@asylum.americas.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Thorlton <athorlton@sgi.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Hedi Berriche <hedi@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Alex Thorlton <athorlton@sgi.com> wrote:

> On Tue, Nov 17, 2015 at 08:32:59PM +0100, Borislav Petkov wrote:
> > On Mon, Nov 16, 2015 at 11:59:40AM -0600, Alex Thorlton wrote:
> > > Commit a5d90c923bcf ("x86/efi: Quirk out SGI UV") added a quirk to
> > > efi_apply_memmap_quirks to force SGI UV systems to fall back to the old
> > > EFI memmap mechanism.  We have a BIOS fix for this issue now, so we no
> > > longer need this quirk in the kernel.
> > 
> > So does that mean that all UV systems out there will get the BIOS update
> > or at least will have a BIOS update available so that we won't need the
> > quirk at all?
> 
> Essentially, yes.  The BIOS fix isn't available on UV1, but that's older
> hardware at this point, and the distro kernels that run on it will
> still have the quirk.  This change is mainly so that we can get the
> un-quirked code pulled in for the next major distro release.

So how about older UV systems that don't want to upgrade the BIOS for whatever 
reason but wants to upgrade to a new distro will have a non-booting kernel?

Also, what about UV systems that compile their own kernels for whatever reason?

> We won't be checking this down into the stable branches.  Mainly just planning 
> ahead here for future UV and distro releases.

But eventually the new kernel will become the stable kernel, and we'll be breaking 
old systems with old BIOSen, which is not good.

We should at least check the BIOS version via a DMI quirk and panic in some nicely 
informative 'upgrade your BIOS!' way to ease the transition ...

Thanks,

	Ingo
