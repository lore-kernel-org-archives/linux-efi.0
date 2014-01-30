From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Date: Thu, 30 Jan 2014 13:12:47 +0000
Message-ID: <20140130131247.GG11329@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
 <20140122112055.GF1621@mudshark.cambridge.arm.com>
 <20140129182805.GF11329@bivouac.eciton.net>
 <1391029124.2488.50.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1391029124.2488.50.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org" <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org" <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jan 29, 2014 at 03:58:44PM -0500, Mark Salter wrote:
> > (i.e. conditionalise on whether an optional parameter was provided),
> > so my attempt of refactoring actually ends up using an additional
> > register:
> > 
> 
> Register parameters are just strings, so how about this:
> 
> 	.macro foo bar=, baz=
> 	.ifnc \bar,
> 	mov \bar,#0
> 	.endif
> 	.ifnc \baz,
> 	mov \baz,#1
> 	.endif
> 	.endm
> 
> 	foo x0
> 	foo
> 	foo x1, x2
> 	foo ,x3
> 
> Results in:
> 
> 0000000000000000 <.text>:
>    0:	d2800000 	mov	x0, #0x0                   	// #0
>    4:	d2800001 	mov	x1, #0x0                   	// #0
>    8:	d2800022 	mov	x2, #0x1                   	// #1
>    c:	d2800023 	mov	x3, #0x1                   	// #1

Oh, that's neat - thanks!

Well, given that, I can think of two less horrible options:
1)
	.macro  update_sctlr, tmp:req, set=, clear=
        mrc	p15, 0, \tmp, c1, c0, 0
	.ifnc	\set,
        orr	\tmp, \set
	.endif
	.ifnc	\clear,
	mvn	\clear, \clear
	and	\tmp, \tmp, \clear
	.endif
        mcr	p15, 0, \tmp, c1, c0, 0
	.endm

With the two call sites in uefi_phys.S as:

	ldr	r5, =(CR_M)
	update_sctlr	r12, , r5
and
	ldr	r4, =(CR_I | CR_C | CR_M)
	update_sctlr	r12, r4

Which disassembles as:

  2c:   e3a05001        mov     r5, #1
  30:   ee11cf10        mrc     15, 0, ip, cr1, cr0, {0}
  34:   e1e05005        mvn     r5, r5
  38:   e00cc005        and     ip, ip, r5
  3c:   ee01cf10        mcr     15, 0, ip, cr1, cr0, {0}
and
  48:   e59f4034        ldr     r4, [pc, #52]   ; 84 <tmpstack+0x4>
  4c:   ee11cf10        mrc     15, 0, ip, cr1, cr0, {0}
  50:   e18cc004        orr     ip, ip, r4
  54:   ee01cf10        mcr     15, 0, ip, cr1, cr0, {0}


2)
	.macro update_sctlr, tmp:req, tmp2:req, set=, clear=
	mrc	p15, 0, \tmp, c1, c0, 0
	.ifnc	\set,
	ldr	\tmp2, =\set
	orr	\tmp, \tmp, \tmp2
	.endif
	.ifnc	\clear,
	ldr	\tmp2, =\clear
	mvn	\tmp2, \tmp2
	and	\tmp, \tmp, \tmp2
	.endif
	mcr	p15, 0, \tmp, c1, c0, 0
	.endm

With the two call sites in uefi_phys.S as: 

	update_sctlr	r4, r5, , (CR_M)
and
	update_sctlr	r4, r5, (CR_I | CR_C | CR_M)

Which disassembles as:

  2c:   ee114f10        mrc     15, 0, r4, cr1, cr0, {0}
  30:   e3a05001        mov     r5, #1
  34:   e1e05005        mvn     r5, r5
  38:   e0044005        and     r4, r4, r5
  3c:   ee014f10        mcr     15, 0, r4, cr1, cr0, {0}
and
  48:   ee114f10        mrc     15, 0, r4, cr1, cr0, {0}
  4c:   e59f5030        ldr     r5, [pc, #48]   ; 84 <tmpstack+0x4>
  50:   e1844005        orr     r4, r4, r5
  54:   ee014f10        mcr     15, 0, r4, cr1, cr0, {0}


The benefit of 2) is a cleaner call site, and one fewer register
used if setting and clearing simultaneously.

The benefit of 1) is that the macro could then easily be used with
the crval mask in mm/proc*.S

So, Will, which one do you want?

/
    Leif
