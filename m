From: Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Fri, 2 Nov 2012 15:18:06 -0400
Message-ID: <CACLa4psWr4xW0xrJq11q9zQM5V=8-HhQxGf6kzRRkpeEM0iS3A@mail.gmail.com>
References: <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<20121101202701.GB20817@xo-6d-61-c0.localdomain>
	<5092E361.7080901@genband.com>
	<20121102163302.GA6080@elf.ucw.cz>
	<1351875164.2439.42.camel@dabdike.int.hansenpartnership.com>
	<20121102165456.GB9997@srcf.ucam.org>
	<1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
	<20121102175416.GA11816@srcf.ucam.org>
	<1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
	<20121102180458.GA12052@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121102180458.GA12052-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

I know I started it, but Windows really isn't necessary to see value,
even if it is what pushed the timing.

A user installs a package as root.  Absent any flaws in the Linux
kernel (cough) that should be all it can do in a Secure Boot world.
But if you can drop a small trusted Linux system in there and use that
to boot a compromised Linux kernel, it can make itself persistent.

And like I said, I know there are cloud providers out there who want
EXACTLY this type of system.  One in which root in the guest is
untrusted and they want to keep them out of ring 0.
