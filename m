From: Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 10:29:17 -0400
Message-ID: <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<2548314.3caaFsMVg6@linux-lqwf.site>
	<50919EED.3020601@genband.com>
	<36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351763954.2391.37.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 1, 2012 at 5:59 AM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:

> But that doesn't really help me: untrusted root is an oxymoron.

Imagine you run windows and you've never heard of Linux.  You like
that only windows kernels can boot on your box and not those mean
nasty hacked up malware kernels.  Now some attacker manages to take
over your box because you clicked on that executable for young models
in skimpy bathing suits.  That executable rewrote your bootloader to
launch a very small carefully crafted Linux environment.  This
environment does nothing but launch a perfectly valid signed Linux
kernel, which gets a Windows environment all ready to launch after
resume and goes to sleep.  Now you have to hit the power button twice
every time you turn on your computer, weird, but Windows comes up, and
secureboot is still on, so you must be safe!

In this case we have a completely 'untrusted' root inside Linux.  From
the user PoV root and Linux are both malware.  Notice the EXACT same
attack would work launching rootkit'd Linux from Linux.  So don't
pretend not to care about Windows.  It's just that launching malware
Linux seems like a reason to get your key revoked.  We don't want
signed code which can be used as an attack vector on ourselves or on
others.

That make sense?

-Eric
