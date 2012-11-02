From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 13:03:49 -0400
Message-ID: <20121102170349.GJ3300@redhat.com>
References: <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <20121101202701.GB20817@xo-6d-61-c0.localdomain>
 <5092E361.7080901@genband.com>
 <20121102154833.GG3300@redhat.com>
 <5093FADA.2040004@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5093FADA.2040004-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 02, 2012 at 10:54:50AM -0600, Chris Friesen wrote:
> On 11/02/2012 09:48 AM, Vivek Goyal wrote:
> >On Thu, Nov 01, 2012 at 03:02:25PM -0600, Chris Friesen wrote:
> 
> >>With secure boot enabled, then the kernel should refuse to let an
> >>unsigned kexec load new images, and kexec itself should refuse to
> >>load unsigned images.
> >
> >Yep, good in theory. Now that basically means reimplementing kexec-tools
> >in kernel.
> 
> Maybe I'm missing something, but couldn't the vendors provide a
> signed kexec?  Why does extra stuff need to be pushed into the
> kernel?

Bingo. Join us in following mail thread for all the gory details and
extra work required to make signing of user space processes work.

https://lkml.org/lkml/2012/10/24/451

In a nut-shell, there is no infrastructure currently for signing user
space processes and verifying it (like module signing). Then if you
just sign select user processes and not whole of the user space, then
it brings extra complications with linking shared objects and being
able to modify the code of process etc.

So yes, being able to sign /sbin/kexec will be great. Looks like that
itself will require lot of work and is not that straight forward.

Thanks
Vivek
