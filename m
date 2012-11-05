From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Sun, 04 Nov 2012 22:38:41 -0800
Message-ID: <87390ok0zy.fsf@xmission.com>
References: <50919EED.3020601@genband.com>
	<36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<20121101202701.GB20817@xo-6d-61-c0.localdomain>
	<5092E361.7080901@genband.com> <20121102154833.GG3300@redhat.com>
	<alpine.LNX.2.00.1211040008280.24253@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1211040008280.24253-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org> (Jiri
	Kosina's message of "Sun, 4 Nov 2012 00:09:55 +0100 (CET)")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org> writes:

> On Fri, 2 Nov 2012, Vivek Goyal wrote:
>
>> > With secure boot enabled, then the kernel should refuse to let an
>> > unsigned kexec load new images, and kexec itself should refuse to
>> > load unsigned images.
>> 
>> Yep, good in theory. Now that basically means reimplementing kexec-tools
>> in kernel. 
>
> Why is "when kernel has been securely booted, the in-kernel kexec 
> mechanism has to verify the signature of the supplied image before 
> kexecing it" not enough? (basically the same thing we are doing for signed 
> modules already).

For modules the only untrusted part of their environment are the command
line parameters, and several of those have already been noted for
needing to be ignored in a non-trusted root scenario.

For kexec there is a bunch of glue code and data that takes care of
transitioning from the environment provided by kexec and the environment
that the linux kernel or memtest86 or whatever we are booting is
expecting.

Figuring out what glue code and data we need and supplying that glue
code and data is what kexec-tools does.  The situation is a bit like
dealing with the modules before most of the work of insmod was moved
into the kernel.

For kexec-tools it is desirable to have glue layers outside of the
kernel because every boot system in existence has a different set of
parameter passing rules.

So signing in the kernel gets us into how do we sign the glue code and
how dow we verify the glue code will jump to our signed and verified
kernel image.

I will be happy to review patches for that don't through the baby out
with the bath water.

Eric
