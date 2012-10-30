From: joeyli <jlee@suse.com>
Subject: Re: [PATCH V3 07/10] Secure boot: Add a dummy kernel parameter
 that will switch on Secure Boot mode
Date: Wed, 31 Oct 2012 03:27:42 +0800
Message-ID: <1351625262.21227.56.camel@linux-s257.site>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-8-git-send-email-mjg@redhat.com>
	 <20120920163237.GA11077@kroah.com>
	 <20120925130818.GE18546@hansolo.jdub.homelinux.org>
	 <1351501206.21227.47.camel@linux-s257.site>
	 <20121030174848.GD6627@hansolo.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121030174848.GD6627@hansolo.jdub.homelinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, Matthew Garrett <mjg@redhat.com>, tiwai@suse.de
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2012-10-30 =E6=96=BC 13:48 -0400=EF=BC=8CJo=
sh Boyer =E6=8F=90=E5=88=B0=EF=BC=9A
> On Mon, Oct 29, 2012 at 05:00:06PM +0800, joeyli wrote:
> > Hi Josh,=20
> > Tahashi has a good idea for use strtobool to allow
> > 'secureboot_enable=3Dyes' works. Please consider the following chan=
ge.
> >=20
> >=20
> > Thanks a lot!
> > Joey Lee
> >=20
> > >From f6841a476f3d332fe7b04cb716e0b518cccd5055 Mon Sep 17 00:00:00 =
2001
> > From: Lee, Chun-Yi <jlee@suse.com>
> > Date: Mon, 29 Oct 2012 16:36:57 +0800
> > Subject: [PATCH] efi: more user-friendly secureboot_enable paramete=
r
> >=20
> > From: Takashi Iwai <tiwai@suse.de>
> >=20
> > Use strtobool can allow 'secureboot_enable=3Dyes', it's more user-f=
riendly.
> >=20
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  kernel/cred.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/kernel/cred.c b/kernel/cred.c
> > index 3f5be65..70897a2 100644
> > --- a/kernel/cred.c
> > +++ b/kernel/cred.c
> > @@ -633,9 +633,10 @@ void __init secureboot_enable()
> >  /* Dummy Secure Boot enable option to fake out UEFI SB=3D1 */
> >  static int __init secureboot_enable_opt(char *str)
> >  {
> > -	int sb_enable =3D !!simple_strtol(str, NULL, 0);
> > -	if (sb_enable)
> > +	bool sb_enable;
> > +	if (!strtobool(str, &sb_enable) && sb_enable)
> >  		secureboot_enable();
> > +
> >  	return 1;
> >  }
> >  __setup("secureboot_enable=3D", secureboot_enable_opt);
>=20
> This seems like a good change to me.  If you don't mind, I'll rework =
the
> existing patch to do this since it hasn't been accepted upstream yet =
and
> give Takashi-san and you appropriate credit in the commit log.
>=20
> josh
>=20

Thanks for your review and feel free add to your reworked patch.

Joey Lee
