From: Dave P Martin <Dave.Martin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 6/7] Add EFI stub for ARM
Date: Tue, 6 Aug 2013 11:31:08 +0100
Message-ID: <20130806103108.GD2791@e103592.cambridge.arm.com>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
 <1375478948-22562-7-git-send-email-roy.franz@linaro.org>
 <20130805141149.GB2755@localhost.localdomain>
 <20130805153318.GL18151@rocoto.smurfnet.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130805153318.GL18151-GZEopFhza0F985/tl1ce8aaDwS/vmuI7@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org" <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Aug 05, 2013 at 04:33:19PM +0100, Leif Lindholm wrote:
> On Mon, Aug 05, 2013 at 03:11:49PM +0100, Dave Martin wrote:
> > > diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> > > index 75189f1..4c70b9e 100644
> > > --- a/arch/arm/boot/compressed/head.S
> > > +++ b/arch/arm/boot/compressed/head.S
> > > @@ -122,19 +122,106 @@
> > >  		.arm				@ Always enter in ARM state
> > >  start:
> > >  		.type	start,#function
> > > -		.rept	7
> > > +#ifdef CONFIG_EFI_STUB
> > > +		@ Magic MSDOS signature for PE/COFF + ADD opcode
> > > +		.word	0x62805a4d
> > 
> > What about BE32?
>  
> The ARM bindings for UEFI specify that the processor must be in
> little-endian mode.
> 
> > In that case, the instruction is a coprocessor load, that loads from a
> > random address to a coprocessor that almost certainly doesn't exist.
> > This will probably fault.
> > 
> > Since BE32 is only for older platforms (<v6) and this is not easily
> > solvable, it might be sensible to make the EFI stub support depend on
> > !CPU_ENDIAN_BE32.
>  
> Well, it would make more sense to make EFI_STUB depend on EFI and
> EFI depend on !CPU_ENDIAN_BE32. Which is something I can add to
> my next set of general ARM UEFI patches. Thanks.

That sounds fair enough.

Cheers
---Dave
