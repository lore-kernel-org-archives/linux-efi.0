From: Igor Gnatenko <i.gnatenko.brain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [REGRESSION] "UEFI: Don't pass boot services regions to
 SetVirtualAddressMap()" breaks macbook efi boot
Date: Sat, 13 Jul 2013 22:17:01 +0400
Message-ID: <1373739421.2002.2.camel@ThinkPad-X230.localdomain>
References: <51DD46AD.2010800@canonical.com>
	 <CAL01qptsrtZCGUh-w1R4a2C_ez+wX1-5xo0Bk6Nmzf-aLfBH7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL01qptsrtZCGUh-w1R4a2C_ez+wX1-5xo0Bk6Nmzf-aLfBH7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-07-10 at 12:39 +0100, Fleming, Matt wrote:
> On 10 July 2013 12:34, Maarten Lankhorst
> <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> > Hey,
> >
> > It seems that in the merge window my macbook pro stopped working at=
 some point. I looked for suspicious
> > efi related commits, and found that reverting commit 1acba98f810a14=
b1255e34bc620594f83de37e36 worked,
> > letting my macbook pro boot succesfully.
>=20
> Thanks for the report. I'm going to queue up a revert of this patch,
> Dave Young also reported a problem on his thinkpad.
>=20
> > Is there anything I can do to help diagnose this issue?
>=20
> Matthew?
Revert this commit fixes my problem on ThinkPad X230 too. Wait Linus
https://lkml.org/lkml/2013/7/13/65 .
--=20
Igor Gnatenko
=46edora release 19 (Schr=C3=B6dinger=E2=80=99s Cat)
Linux 3.9.9-302.fc19.x86_64
