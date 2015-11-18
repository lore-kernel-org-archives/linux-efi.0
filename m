From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH 1/2] Remove EFI memmap quirk for UV
Date: Tue, 17 Nov 2015 19:56:30 -0600
Message-ID: <20151118015630.GC161386@asylum.americas.sgi.com>
References: <1447696781-159611-1-git-send-email-athorlton@sgi.com> <20151117193258.GB9374@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151117193258.GB9374-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 17, 2015 at 08:32:59PM +0100, Borislav Petkov wrote:
> On Mon, Nov 16, 2015 at 11:59:40AM -0600, Alex Thorlton wrote:
> > Commit a5d90c923bcf ("x86/efi: Quirk out SGI UV") added a quirk to
> > efi_apply_memmap_quirks to force SGI UV systems to fall back to the old
> > EFI memmap mechanism.  We have a BIOS fix for this issue now, so we no
> > longer need this quirk in the kernel.
> 
> So does that mean that all UV systems out there will get the BIOS update
> or at least will have a BIOS update available so that we won't need the
> quirk at all?

Essentially, yes.  The BIOS fix isn't available on UV1, but that's older
hardware at this point, and the distro kernels that run on it will
still have the quirk.  This change is mainly so that we can get the
un-quirked code pulled in for the next major distro release.

We won't be checking this down into the stable branches.  Mainly just
planning ahead here for future UV and distro releases.

- Alex
