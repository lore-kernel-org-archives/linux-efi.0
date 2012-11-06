From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Tue, 06 Nov 2012 22:51:59 +0100
Message-ID: <87625iwgao.fsf@mid.deneb.enyo.de>
References: <20121104135251.GA17894@srcf.ucam.org>
	<87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com>
	<87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org>
	<87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org>
	<87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org>
	<87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org>
	<87hap3s3yl.fsf@xmission.com> <878vafqi5q.fsf@mid.deneb.enyo.de>
	<50992946.4060101@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50992946.4060101-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org> (Chris Friesen's message of "Tue,
	06 Nov 2012 09:14:14 -0600")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

* Chris Friesen:

> On 11/06/2012 01:56 AM, Florian Weimer wrote:
>
>> Personally, I think the only way out of this mess is to teach users
>> how to disable Secure Boot.
>
> If you're going to go that far, why not just get them to install a
> RedHat (or SuSE, or Ubuntu, or whoever) key and use that instead?

Behind that key, considerable infrastructure is needed, and the
challenges are not purely technical.  I don't expect many such keys as
a result.

> Secure boot does arguably solve a class of problems, so it seems a bit
> odd to recommend just throwing it out entirely.

I have never seen a Linux system with a compromised boot path.  Surely
they exist out there, but they are rare.  It's also relatively simple
to detect such a compromise on disk, from the outside.  Secure Boot
doesn't even allow you to safely boot from PXE because Fedora's shim
will automatically load an initrd which wipes all your disks.  (Safe
booting from network would be a compelling feature, but it's not in
the focus of Secure Boot; that's client-only technology at the
moment.)

Some side effects, such as the end of proprietary kernel modules, may
be desirable.  But others are not, like missing hibernate support (or
perhaps even X).
