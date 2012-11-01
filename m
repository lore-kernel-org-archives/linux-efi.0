From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 14:46:35 +0000
Message-ID: <20121101144635.55687287@pyramind.ukuu.org.uk>
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

> Imagine you run windows and you've never heard of Linux.

To those people I think you mean "never heard of Ubuntu" ;-)

> In this case we have a completely 'untrusted' root inside Linux.  From
> the user PoV root and Linux are both malware.  Notice the EXACT same
> attack would work launching rootkit'd Linux from Linux.  So don't
> pretend not to care about Windows.  It's just that launching malware
> Linux seems like a reason to get your key revoked.  We don't want
> signed code which can be used as an attack vector on ourselves or on
> others.
> 
> That make sense?

Not really but it keeps some of the Red Hat security people happy and out
of harms way. With all the current posted RH patches I can still take over
the box as root trivially enough and you seem to have so far abolished
suspend to disk, kexec and a pile of other useful stuff. To actually lock
it down you'll have to do a ton more of this. I suspect folks who know
windows innards well are probably thinking the same about Windows 8 8)

Almost anyone attacking a secure boot box will do it via windows or more
likely via EFI. EFI because its large, new and doesn't a great history,
windows because its the larger target. Actually from what I've seen on
the security front there seems to a distinct view that secure boot is
irrelevant because Windows 8 is so suspend/resume focussed that you might
as well just trojan the box until the next reboot as its likely to be a
couple of weeks a way.

Alan
