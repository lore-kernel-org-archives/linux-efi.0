From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Thu, 8 Nov 2012 11:19:28 +0000
Message-ID: <20121108111928.27911a63@pyramind.ukuu.org.uk>
References: <87fw4nv1vj.fsf@xmission.com>
	<20121106035352.GA24698@srcf.ucam.org>
	<87hap3s3yl.fsf@xmission.com>
	<878vafqi5q.fsf@mid.deneb.enyo.de>
	<50992946.4060101@genband.com>
	<87625iwgao.fsf@mid.deneb.enyo.de>
	<7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com>
	<20121106224920.3b9d4a86@pyramind.ukuu.org.uk>
	<a35e035b-de9d-4253-9e7d-ae1f1c2e2f88@email.android.com>
	<CAMFK0gt7oAr4ArD8FmD8QE+i4g4rSTmQjbbLcjs02xwQeXGx-A@mail.gmail.com>
	<20121107145518.GB30662@srcf.ucam.org>
	<CAAMvbhFF=kb8TJ4oE+40Zrx7HD1OkD0NOYj7QEZegZKGtqDm_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAMvbhFF=kb8TJ4oE+40Zrx7HD1OkD0NOYj7QEZegZKGtqDm_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Courtier-Dutton <james.dutton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Olivier Galibert <galibert-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

> You have a fair chance of protecting via physical means (Locked rooms,
> Background checks on users etc.) of preventing a user with malicious intent
> to access the local machine.

So called "secure boot" doesn't deal with any kind of physical access,
which also means its useless if a device is lost and returned and you
don't know if it was in the hands of a third party.

> The first thing a computer does when switched on is run its first code
> instructions. Commonly referred to as the BIOS.

A good deal more complicated than that. However the signing in hardware
and early boot up on a lot of devices already goes as far as the BIOS if
the system has BIOS or EFI if it doesn't. You also have all the devices
to deal with.

> Normally digital signatures would examine the binary, ensure the signature
> matches, and then run the code contained in it.

No - it's a good deal more complicated than that too.
