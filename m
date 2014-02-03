From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Date: Mon, 3 Feb 2014 15:55:42 +0000
Message-ID: <20140203155542.GI11329@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
 <20140122112055.GF1621@mudshark.cambridge.arm.com>
 <20140129182805.GF11329@bivouac.eciton.net>
 <1391029124.2488.50.camel@deneb.redhat.com>
 <20140130131247.GG11329@bivouac.eciton.net>
 <20140203103415.GA12187@mudshark.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140203103415.GA12187-MRww78TxoiP5vMa5CHWGZ34zcgK1vI+I0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org" <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org" <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 03, 2014 at 10:34:15AM +0000, Will Deacon wrote:
> On Thu, Jan 30, 2014 at 01:12:47PM +0000, Leif Lindholm wrote:
> > Oh, that's neat - thanks!
> > 
> > Well, given that, I can think of two less horrible options:
> > 1)
> > 	.macro  update_sctlr, tmp:req, set=, clear=
> >         mrc	p15, 0, \tmp, c1, c0, 0
> > 	.ifnc	\set,
> >         orr	\tmp, \set
> > 	.endif
> > 	.ifnc	\clear,
> > 	mvn	\clear, \clear
> > 	and	\tmp, \tmp, \clear
> 
> Can't you use bic here?

Yeah.

> > 	.endif
> >         mcr	p15, 0, \tmp, c1, c0, 0
> > 	.endm
> > 
> > With the two call sites in uefi_phys.S as:
> > 
> > 	ldr	r5, =(CR_M)
> > 	update_sctlr	r12, , r5
> > and
> > 	ldr	r4, =(CR_I | CR_C | CR_M)
> > 	update_sctlr	r12, r4
> 
> These ldr= could be movs, right?

The first one could.
The second one could be movw on armv7+.

> If so, I definitely prefer this to putting an ldr = into the macro itself
> (option 2).

And your preference between 1) and 2) is?

/
    Leif
