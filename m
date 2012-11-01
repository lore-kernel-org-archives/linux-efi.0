From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 14:49:12 +0000
Message-ID: <20121101144912.GA10269@srcf.ucam.org>
References: <2548314.3caaFsMVg6@linux-lqwf.site>
 <50919EED.3020601@genband.com>
 <36538307.gzWq1oO7Kg@linux-lqwf.site>
 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1351780935.2391.58.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 01, 2012 at 02:42:15PM +0000, James Bottomley wrote:
> On Thu, 2012-11-01 at 10:29 -0400, Eric Paris wrote:
> > Imagine you run windows and you've never heard of Linux.  You like
> > that only windows kernels can boot on your box and not those mean
> > nasty hacked up malware kernels.  Now some attacker manages to take
> > over your box because you clicked on that executable for young models
> > in skimpy bathing suits.  That executable rewrote your bootloader to
> > launch a very small carefully crafted Linux environment.  This
> > environment does nothing but launch a perfectly valid signed Linux
> > kernel, which gets a Windows environment all ready to launch after
> > resume and goes to sleep.  Now you have to hit the power button twice
> > every time you turn on your computer, weird, but Windows comes up, and
> > secureboot is still on, so you must be safe!
> 
> So you're going back to the root exploit problem?  I thought that was
> debunked a few emails ago in the thread?

The entire point of this feature is that it's no longer possible to turn 
a privileged user exploit into a full system exploit. Gaining admin 
access on Windows 8 doesn't permit you to install a persistent backdoor, 
unless there's some way to circumvent that. Which there is, if you can 
drop a small Linux distribution onto the ESP and use a signed, trusted 
bootloader to boot a signed, trusted kernel that then resumes from an 
unsigned, untrusted hibernate image. So we have to ensure that that's 
impossible.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
