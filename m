From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Date: Wed, 29 Jan 2014 18:28:05 +0000
Message-ID: <20140129182805.GF11329@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
 <20140122112055.GF1621@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140122112055.GF1621-MRww78TxoiP5vMa5CHWGZ34zcgK1vI+I0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org" <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org" <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 22, 2014 at 11:20:55AM +0000, Will Deacon wrote:
> > +#ifdef CONFIG_CPU_CP15
> > +/* Macro for setting/clearing bits in sctlr */
> > +	.macro update_sctlr, set:req, clear:req, tmp:req, tmp2:req
> > +	mrc	p15, 0, \tmp, c1, c0, 0
> > +	ldr	\tmp2, =\set
> > +	orr	\tmp, \tmp, \tmp2
> > +	ldr	\tmp2, =\clear
> > +	mvn	\tmp2, \tmp2
> > +	and	\tmp, \tmp, \tmp2
> > +	mcr	p15, 0, \tmp, c1, c0, 0
> 
> I think this would be cleaner if you force the caller to put set and clear
> into registers beforehand, rather than have to do the literal load every
> time. Also, I don't think set and clear should be required (and then you can
> lose tmp2 as well).

I can't figure out how to make register-parameters non-required
(i.e. conditionalise on whether an optional parameter was provided),
so my attempt of refactoring actually ends up using an additional
register:

#ifdef CONFIG_CPU_CP15
/* Macro for setting/clearing bits in sctlr */
	.macro	update_sctlr, set:req, clear:req, tmp:req
	mrc	p15, 0, \tmp, c1, c0, 0
	orr	\tmp, \set
	mvn	\clear, \clear
	and	\tmp, \tmp, \clear
	mcr	p15, 0, \tmp, c1, c0, 0
	.endm
#endif

If you think that's an improvement I can do that, and I have (just)
enough registers to spare.
If I'm being daft with my macro issues, do point it out.

/
    Leif
