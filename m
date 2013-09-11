From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
Date: Wed, 11 Sep 2013 17:32:52 +0800
Message-ID: <1378891972.6193.137.camel@linux-s257.site>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	 <19562.1378747124@turing-police.cc.vt.edu>
	 <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	 <1378767723.17982.27.camel@x230.lan>
	 <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
	 <1378774394.17982.36.camel@x230.lan>
	 <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
	 <1378781715.17982.42.camel@x230.lan>
	 <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
	 <1378785208.17982.54.camel@x230.lan>
	 <20130910172318.GB21530@khazad-dum.debian.net>
	 <1378837571.17615.0.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378837571.17615.0.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Henrique de Moraes Holschuh <hmh-N3TV7GIv+o9fyO9Q7EP/yw@public.gmane.org>, David Lang <david-gFPdbfVZQbY@public.gmane.org>, "Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org" <Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org" <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-09-10 =E6=96=BC 18:26 +0000=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> On Tue, 2013-09-10 at 14:23 -0300, Henrique de Moraes Holschuh wrote:
> > On Tue, 10 Sep 2013, Matthew Garrett wrote:
> > > That's why modern systems require signed firmware updates.
> >=20
> > Linux doesn't.  Is someone working on adding signature support to t=
he
> > runtime firmware loader?
>=20
> It'd be simple to do so, but so far the model appears to be that devi=
ces
> that expect signed firmware enforce that themselves.
>=20
> --=20
> Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
> NrybX=C7=A7v^)=DE=BA{.n+{y^nrz=1Ah&=1EGh=03(=E9=9A=8E=DD=A2j"=1A=1Bmz=
=DE=96fh~m

Takashi has a implementation of firmware check:

[PATCH RFC v2 0/4] Add firmware signature file check
https://lkml.org/lkml/2012/11/8/343


Thanks
Joey Lee
