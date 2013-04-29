From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86, efi: initial the local variable of DataSize to
 zero
Date: Mon, 29 Apr 2013 18:34:28 +0800
Message-ID: <1367231668.22858.56.camel@linux-s257.site>
References: <1366996767-8234-1-git-send-email-jlee@suse.com>
	 <1367231111.22858.55.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367231111.22858.55.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=80=EF=BC=8C2013-04-29 =E6=96=BC 18:25 +0800=EF=BC=8Cjo=
eyli =E6=8F=90=E5=88=B0=EF=BC=9A
> =E6=96=BC =E5=85=AD=EF=BC=8C2013-04-27 =E6=96=BC 01:19 +0800=EF=BC=8C=
Lee, Chun-Yi =E6=8F=90=E5=88=B0=EF=BC=9A
> > That will be better initial the value of DataSize to zero for the i=
nput of
> > GetVariable(), otherwise we will feed a random value. The debug log=
 of input
> > DataSize like this:
> >=20
> > ...
> > [  195.915612] EFI Variables Facility v0.08 2004-May-17
> > [  195.915819] efi: size: 18446744071581821342
> > [  195.915969] efi:  size': 18446744071581821342
> > [  195.916324] efi: size: 18446612150714306560
> > [  195.916632] efi:  size': 18446612150714306560
> > [  195.917159] efi: size: 18446612150714306560
> > [  195.917453] efi:  size': 18446612150714306560
> > ...
>=20
> After applied patch, the log of size like this:
>=20
> [   82.442042] EFI Variables Facility v0.08 2004-May-17
> [   82.442202] efi: size: 0
> [   82.442360] efi:  size': 1039
> [   82.443828] efi: size: 0
> [   82.444127] efi:  size': 2616
> [   82.447057] efi: size: 0
> [   82.447356] efi:  size': 5832
> [   82.452669] efi: size: 0
> [   82.453128] efi:  size': 1
> [   82.454339] efi: size: 0
> [   82.454843] efi:  size': 1
> [   82.456173] efi: size: 0
> [   82.456764] efi:  size': 8
> [   82.458194] efi: size: 0
> [   82.458905] efi:  size': 4
>=20
> The size' is the return value of Acer BIOS, it return right size valu=
e
> then we feed zero DataSize.
^^^^^^^^^ when=20

Sorry for typo!
Joey Lee

>=20
>=20
> Thanks a lot!
> Joey Lee
>=20
> >=20
> > Found on Acer Aspire V3 BIOS, it will not return the size of data i=
f we input a
> > non-zero DataSize.
> >=20
> > Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/efi.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/ef=
i.c
> > index e4a86a6..cb59732 100644
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -204,7 +204,7 @@ static efi_status_t virt_efi_get_next_variable(=
unsigned long *name_size,
> >  	}
> > =20
> >  	if (boot_used_size && !finished) {
> > -		unsigned long size;
> > +		unsigned long size =3D 0;
> >  		u32 attr;
> >  		efi_status_t s;
> >  		void *tmp;
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
