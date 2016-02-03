From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] efi: make our variable validation list include the
 guid (v2)
Date: Wed, 3 Feb 2016 12:55:32 -0500
Message-ID: <20160203175532.GA19297@redhat.com>
References: <1454517834-13736-1-git-send-email-pjones@redhat.com>
 <1454517834-13736-4-git-send-email-pjones@redhat.com>
 <20160203175128.GP26698@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203175128.GP26698-empE8CJ7fzk2xCFIczX1Fw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 04, 2016 at 01:51:28AM +0800, joeyli wrote:
> Hi Peter,=20
>=20
> On Wed, Feb 03, 2016 at 11:43:53AM -0500, Peter Jones wrote:
> > v2 correctly checks the guid for validation *as well as* attribute
> > whitelisting.
> >=20
> > Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/firmware/efi/efivars.c |  5 +++--
> >  drivers/firmware/efi/vars.c    | 43 +++++++++++++++++++++++-------=
------------
> >  include/linux/efi.h            |  3 ++-
> >  3 files changed, 29 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/=
efivars.c
> > index eef6331..707b0fd 100644
> > --- a/drivers/firmware/efi/efivars.c
> > +++ b/drivers/firmware/efi/efivars.c
> > @@ -221,7 +221,7 @@ sanity_check(struct efi_variable *var, efi_char=
16_t *name, efi_guid_t vendor,
> >  	}
> > =20
> >  	if ((attributes & ~EFI_VARIABLE_MASK) !=3D 0 ||
> > -	    efivar_validate(name, data, size) =3D=3D false) {
> > +	    efivar_validate(vendor, name, data, size) =3D=3D false) {
> >  		printk(KERN_ERR "efivars: Malformed variable content\n");
> >  		return -EINVAL;
> >  	}
> > @@ -447,7 +447,8 @@ static ssize_t efivar_create(struct file *filp,=
 struct kobject *kobj,
> >  	}
> > =20
> >  	if ((attributes & ~EFI_VARIABLE_MASK) !=3D 0 ||
> > -	    efivar_validate(name, data, size) =3D=3D false) {
> > +	    efivar_validate(new_var->var.VendorGuid, name, data,
> > +			    size) =3D=3D false) {
>=20
> I just built fail here:
>=20
>   CC      drivers/firmware/efi/efivars.o
> drivers/firmware/efi/efivars.c: In function =E2=80=98efivar_create=E2=
=80=99:
> drivers/firmware/efi/efivars.c:450:29: error: =E2=80=98struct efi_var=
iable=E2=80=99 has no member named =E2=80=98var=E2=80=99
>   efivar_validate(new_var->var.VendorGuid, name, data,
>                          ^
> scripts/Makefile.build:258: recipe for target 'drivers/firmware/efi/e=
fivars.o' failed

Thanks for this - I've got a couple more fixes mfleming wanted and then
I'll send out a new version once I've built and tested the whole
patchset again.

--=20
        Peter
