From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [systemd-devel] [PATCH] Add syste-firmware-efi-efivars.mount
 for support automount EFI variable filesystem
Date: Wed, 24 Oct 2012 19:34:27 +0800
Message-ID: <1351078467.30067.32.camel@linux-s257.site>
References: <1351075322-3824-1-git-send-email-jlee@suse.com>
	 <CAPWNY8VVtW6C6gmXBcJBbKeQ+YVTUvFx2xynP0mknr68uJO_SQ@mail.gmail.com>
	 <1351078348.30067.31.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351078348.30067.31.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mantas Mikul <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2012-10-24 =E6=96=BC 19:32 +0800=EF=BC=8Cjo=
eyli =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi Mantas,=20
>=20
> =E6=96=BC =E4=B8=89=EF=BC=8C2012-10-24 =E6=96=BC 14:07 +0300=EF=BC=8C=
Mantas Mikul=C4=97nas =E6=8F=90=E5=88=B0=EF=BC=9A
> > On Wed, Oct 24, 2012 at 1:42 PM, Lee, Chun-Yi <joeyli.kernel@gmail.=
com> wrote:
> > > Add units/sys-firmware-efi-efivars.mount rule for support automou=
nt EFI variable filesystem
> > > [...]
> > > +
> > > +[Mount]
> > > +What=3Defivarfs
> > > +Where=3D/sys/firmware/efi/efivars
> > > +Type=3Defivarfs
> >=20
> > Out of curiosity: Which kernels actually use a separate filesystem
> > type for this? I'm using 3.6 (Arch) here, and it doesn't even
> > recognize "efivarfs" -- it exports the variables directly via sysfs=
 at
> > /sys/firmware/efi/vars...
> >=20
>=20
> Sorry for I didn't mention to EFI variable filesystem
> (/sys/firmware/efi/vars) will show up in v3.7 or v3.8 kernel.
>=20
> Those patches already merged in EFI git branch:
> http://git.kernel.org/?p=3Dlinux/kernel/git/mfleming/efi.git;a=3Dsumm=
ary
>=20

The exact patch is here:
http://git.kernel.org/?p=3Dlinux/kernel/git/mfleming/efi.git;a=3Dcommit=
;h=3Db003aaf799c991295b8b73e8f940d20bda2c1bbb


Thanks a lot!
Joey Lee
