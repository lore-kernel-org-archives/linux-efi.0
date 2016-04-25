From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCHv2 0/6] efi: detect erroneous firmware IRQ manipulation
Date: Mon, 25 Apr 2016 12:19:23 +0100
Message-ID: <20160425111923.GS2829@codeblueprint.co.uk>
References: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
 <CAKv+Gu8FGpZK4yDito2jKTbjuyE2jojj5tZhCa2qUwKdWL9+ng@mail.gmail.com>
 <20160424212241.GO2829@codeblueprint.co.uk>
 <20160425101527.GP2829@codeblueprint.co.uk>
 <CAKv+Gu8OfqdJp-VhC3o-tie4mRZXsF5ESKkZbsjnBHDY4xbXvQ@mail.gmail.com>
 <20160425102821.GQ2829@codeblueprint.co.uk>
 <20160425104009.GD25087@leverpostej>
 <20160425105153.GR2829@codeblueprint.co.uk>
 <20160425110455.GF25087@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160425110455.GF25087@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 25 Apr, at 12:04:55PM, Mark Rutland wrote:
> On Mon, Apr 25, 2016 at 11:51:53AM +0100, Matt Fleming wrote:
> > On Mon, 25 Apr, at 11:40:09AM, Mark Rutland wrote:
> > > 
> > > It looks like irqs_disabled_flags() will do what you expect, and ignore
> > > everything but the interrupt flag.
> > > 
> > > However, for ARM that will ignore the other exceptions we've seen FW
> > > erroneously unmask (e.g. FIQ), which is unfortunate, as fiddling with
> > > those is just as disastrous.
> >  
> > Bah, right.
> > 
> > > Would you be happy with an arch_efi_call_check_flags(before, after),
> > > instead? That way we can make the flags we check arch-specific.
> > 
> > Could we just make the flag mask arch-specific instead of the call
> > since the rest of efi_call_virt_check_flags() is good?
> 
> Yup, I meant that arch_efi_call_check_flags would only do the flag
> comparison, only replacing the bit currently in the WARN_ON_ONCE().
> 
> > Something like this (uncompiled, untested, half-baked),
> > 
> > ---
> > 
> > diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> > index c38b1cfc26e2..057d00bee7d6 100644
> > --- a/drivers/firmware/efi/runtime-wrappers.c
> > +++ b/drivers/firmware/efi/runtime-wrappers.c
> > @@ -25,9 +25,12 @@
> >  static void efi_call_virt_check_flags(unsigned long flags, const char *call)
> >  {
> >  	unsigned long cur_flags;
> > +	bool mismatch;
> >  
> >  	local_save_flags(cur_flags);
> > -	if (!WARN_ON_ONCE(cur_flags != flags))
> > +
> > +	mismatch = (cur_flags ^ flags) & ARCH_EFI_IRQ_FLAGS_MASK;
> > +	if (!WARN_ON_ONCE(mismatch))
> >  		return;
> 
> This style also works for me.
 
Cool. One thing that occurred to me after I sent it is that
technically we should either,

  1) make 'mismatch' an int or
  2) do mismatch = !!((cur_flags ^ flags) & ARCH_EFI_IRQ_FLAGS_MASK)

Either is fine with me, I just don't want to leave the implicit
conversion to C's type system.

> Should I respin patch 6 as a series doing the above?
> 
> I assume that the first 5 patches are fine as-is.

Yep, they're fine. Sure, go ahead and respin patch 6.
