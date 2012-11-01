From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 21:27:01 +0100
Message-ID: <20121101202701.GB20817@xo-6d-61-c0.localdomain>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <2548314.3caaFsMVg6@linux-lqwf.site>
 <50919EED.3020601@genband.com>
 <36538307.gzWq1oO7Kg@linux-lqwf.site>
 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Paris <eparis@parisplace.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi!

> > But that doesn't really help me: untrusted root is an oxymoron.
> 
> Imagine you run windows and you've never heard of Linux.  You like
> that only windows kernels can boot on your box and not those mean
> nasty hacked up malware kernels.  Now some attacker manages to take
> over your box because you clicked on that executable for young models
> in skimpy bathing suits.  That executable rewrote your bootloader to
> launch a very small carefully crafted Linux environment.  This
> environment does nothing but launch a perfectly valid signed Linux
> kernel, which gets a Windows environment all ready to launch after
> resume and goes to sleep.  Now you have to hit the power button twice
> every time you turn on your computer, weird, but Windows comes up, and
> secureboot is still on, so you must be safe!

Ok, so you cripple kexec / suspend to disallow this, and then...


...attacker launches carefuly crafter Linux environment, that just launches
X and fullscreen wine.

Sure, timing may be slightly different, but Windows came up and secureboot is still
on.. so user happily enters his bank account details.

Could someone write down exact requirements for Linux kernel to be signed by Microsoft?
Because thats apparently what you want, and I don't think crippling kexec/suspend is
enough.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
