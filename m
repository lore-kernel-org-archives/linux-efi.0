From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 17:33:02 +0100
Message-ID: <20121102163302.GA6080@elf.ucw.cz>
References: <50919EED.3020601@genband.com>
 <36538307.gzWq1oO7Kg@linux-lqwf.site>
 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <20121101202701.GB20817@xo-6d-61-c0.localdomain>
 <5092E361.7080901@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5092E361.7080901-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>
Cc: Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu 2012-11-01 15:02:25, Chris Friesen wrote:
> On 11/01/2012 02:27 PM, Pavel Machek wrote:
> 
> >Could someone write down exact requirements for Linux kernel to be signed by Microsoft?
> >Because thats apparently what you want, and I don't think crippling kexec/suspend is
> >enough.
> 
> As I understand it, the kernel won't be signed by Microsoft.

> Rather, the bootloader will be signed by Microsoft and the vendors
> will be the ones that refuse to sign a kernel unless it is
> reasonably assured that it won't be used as an attack vector.

Yes. So can someone write down what "used as an attack vector" means?

Because, AFAICT, Linux kernel is _designed_ to work as an attact
vector. We intentionally support wine, and want to keep that support.

> With secure boot enabled, then the kernel should refuse to let an
> unsigned kexec load new images, and kexec itself should refuse to
> load unsigned images.  Also the kernel would need to sign its
> "suspend-to-disk" images and refuse to resume unsigned images.

I believe that attacking Windows using wine is easier than using
suspend-to-disk.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
