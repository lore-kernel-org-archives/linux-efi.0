From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 11:48:33 -0400
Message-ID: <20121102154833.GG3300@redhat.com>
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
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 01, 2012 at 03:02:25PM -0600, Chris Friesen wrote:
> On 11/01/2012 02:27 PM, Pavel Machek wrote:
> 
> >Could someone write down exact requirements for Linux kernel to be signed by Microsoft?
> >Because thats apparently what you want, and I don't think crippling kexec/suspend is
> >enough.
> 
> As I understand it, the kernel won't be signed by Microsoft.
> 
> Rather, the bootloader will be signed by Microsoft and the vendors
> will be the ones that refuse to sign a kernel unless it is
> reasonably assured that it won't be used as an attack vector.
> 
> If you want fully-open behaviour it's still possible, you just need
> to turn off secure boot.
> 
> With secure boot enabled, then the kernel should refuse to let an
> unsigned kexec load new images, and kexec itself should refuse to
> load unsigned images.

Yep, good in theory. Now that basically means reimplementing kexec-tools
in kernel. That also means creating a new system call. It also
also means cutting down on future flexibility (assuming new system
call interface will be able to support existing features provided by
kernel). And it is lot of code in user space which needs to be
reimplemented in kernel and bloat kernel.

Keeping most of the logic in kexec-tools provided flexibility and keeps
kernel small. So now re-architect kexec and reverse a good design completely
for secureboot. It is a huge pain.

Thanks
Vivek
