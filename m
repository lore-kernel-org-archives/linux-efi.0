From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Date: Mon, 27 May 2013 12:32:50 +0800
Message-ID: <1369629170.19026.23.camel@linux-s257.site>
References: <20130522162747.GA20816@sgi.com>
	 <20130523115801.GJ14575@console-pimps.org> <20130523203234.GD20913@sgi.com>
	 <20130524074331.GL14575@console-pimps.org> <20130524161111.GE3672@sgi.com>
	 <20130524170214.GA30179@sgi.com>  <20130524210534.GA15466@redhat.com>
	 <1369628832.19026.22.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369628832.19026.22.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Robin Holt <holt-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=80=EF=BC=8C2013-05-27 =E6=96=BC 12:27 +0800=EF=BC=8Cjo=
eyli =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi Dave,=20
>=20
> =E6=96=BC =E4=BA=94=EF=BC=8C2013-05-24 =E6=96=BC 17:05 -0400=EF=BC=8C=
Dave Jones =E6=8F=90=E5=88=B0=EF=BC=9A
> > On Fri, May 24, 2013 at 12:02:15PM -0500, Russ Anderson wrote:
> >  > On Fri, May 24, 2013 at 11:11:11AM -0500, Robin Holt wrote:
> >  > > Russ,
> >  > >=20
> >  > > Can we open a bug for the BIOS folks and see if we can get thi=
s addressed?
> >  >=20
> >  > I already talked with them.  It is not in an area that we
> >  > normally change, so if there is a bug may be in the Intel
> >  > reference code.  More investigation is needed to track down
> >  > the actual problem, and that could take help from Intel.
> >  >=20
> >  > Regardless of that, it is a kernel patch that triggers the
> >  > problem.  This isn't the first time a kernel change does
> >  > the "right thing" but trips across questionable bios/EFI/bootloa=
der
> >  > implementation.  That still makes it a kernel bug.
> >  >=20
> >  > I'm still digging to better understand the root problem.
> > =20
> > When we rebased the Fedora 18 kernel to 3.9 we had a bunch of repor=
ts
> > from people who can no longer boot with what looks like similar sym=
ptoms.
> >=20
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D964335
> >=20
> > 	Dave
> >=20
>=20
> The oops on the above bug is similar to my problem on Acer machine,
> could you please ask the reporter try the eccaf52f patch in urgent
> branch on Matt's efi git tree:
>=20
> https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/=
?h=3Durgent&id=3Deccaf52fee8305d5207ff110950a82c100e459bc
>=20
>=20
> Thanks!
> Joey Lee

Looks there have a couple of different machines on this bug. The oops
similar to my machine is reported by josephhenryblack.


Thanks
Joey Lee
