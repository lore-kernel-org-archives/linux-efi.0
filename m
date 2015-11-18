From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH 1/2] Remove EFI memmap quirk for UV
Date: Wed, 18 Nov 2015 11:00:13 -0600
Message-ID: <20151118170013.GD161386@asylum.americas.sgi.com>
References: <1447696781-159611-1-git-send-email-athorlton@sgi.com> <20151117193258.GB9374@pd.tnic> <20151118015630.GC161386@asylum.americas.sgi.com> <20151118080047.GA22813@gmail.com> <20151118092315.GB4138@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151118092315.GB4138-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 18, 2015 at 10:23:16AM +0100, Borislav Petkov wrote:
> On Wed, Nov 18, 2015 at 09:00:47AM +0100, Ingo Molnar wrote:
> > We should at least check the BIOS version via a DMI quirk and panic in some nicely 
> > informative 'upgrade your BIOS!' way to ease the transition ...
> 
> Or since we're touching BIOS anyway, maybe stick a bit somewhere which
> says "EFI is fixed/quirk not needed anymore" when set and software can
> check that bit instead of checking BIOS versions...

After talking through this with Russ, we agree that we should fix this
up to play nice on UV1, without users needing to add the memmap quirk to
the command line.  I'll figure out which check we need to make and spin
another version.

Thanks for looking over this, guys!

- Alex
