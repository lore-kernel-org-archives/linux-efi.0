From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 1 Nov 2012 16:29:01 +0000
Message-ID: <20121101162901.GE13132@srcf.ucam.org>
References: <36538307.gzWq1oO7Kg@linux-lqwf.site>
 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <1351780935.2391.58.camel@dabdike.int.hansenpartnership.com>
 <20121101144912.GA10269@srcf.ucam.org>
 <20121101150654.19efe0b5@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121101150654.19efe0b5-38n7/U1jhRXW96NNrWNlrekiAK3p4hvP@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 01, 2012 at 03:06:54PM +0000, Alan Cox wrote:
> > The entire point of this feature is that it's no longer possible to turn 
> > a privileged user exploit into a full system exploit. Gaining admin 
> > access on Windows 8 doesn't permit you to install a persistent backdoor, 
> 
> Really, that would be a first. Do you have a detailed knowledge of
> windows 8 actual security ?

http://msdn.microsoft.com/en-us/library/windows/desktop/hh848061%28v=vs.85%29.aspx

> > unless there's some way to circumvent that. Which there is, if you can 
> > drop a small Linux distribution onto the ESP and use a signed, trusted 
> > bootloader to boot a signed, trusted kernel that then resumes from an 
> > unsigned, untrusted hibernate image. So we have to ensure that that's 
> > impossible.
> 
> Well if you want to make Linux entirely robust Red Hat could start
> helping with some of the 6000 odd coverity matches some of which will
> most certainly turn out to be real flaws.

Sure, bugs should be fixed.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
