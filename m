From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
Date: Wed, 06 Mar 2013 11:19:10 +0000
Message-ID: <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362555258.23932.573.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2013-03-06 at 15:34 +0800, joeyli wrote:
> Hi Matt,=20
>=20
> =E6=96=BC =E5=85=AD=EF=BC=8C2013-03-02 =E6=96=BC 07:41 +0800=EF=BC=8C=
joeyli =E6=8F=90=E5=88=B0=EF=BC=9A
> > =E6=96=BC =E4=BA=94=EF=BC=8C2013-03-01 =E6=96=BC 16:31 +0000=EF=BC=8C=
Matt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> > > On Fri, 2013-03-01 at 15:17 +0000, Matt Fleming wrote:
> > > > On Fri, 2013-03-01 at 11:20 +0800, Lee, Chun-Yi wrote:
> > > > > From: Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>
> > > > >=20
> > > > > On HP z220 system (firmware version 1.54), some EFI variables=
 are incorrectly
> > > > > named :
> > > > >=20
> > > > > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be return=
s
> > > > > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0=
d-00e098032b8c
> > > > > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0=
d-00e098032b8c
> > > > > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0=
d-00e098032b8c
> > > > > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d=
2-aa0d-00e098032b8c
> > > > >=20
> > > > > That causes by the following statement in efivar_create_sysfs=
_entry function:
> > > > >=20
> > > > >  *(short_name + strlen(short_name)) =3D '-';
> > > > > efi_guid_unparse(vendor_guid, short_name + strlen(short_name)=
);
> > > > >=20
> > > > > The trailing \0 is overwritten with '-', but the next char do=
esn't seem to be a \0
> > > > > as well for HP. So, the second strlen return the point of nex=
t '\0', causes there
> > > > > have garbage string attached before GUID.
> > > > >=20
> > > > > Tested on On HP z220.
> > > >=20
> > > > What's more likely happening here is that GetNextVariable() is =
broken on
> > > > this HP firmware and variable_name_size is too big for the give=
n
> > > > variable in variable_name. We've seen other reports of similar =
bugs,
> > > >=20
> > > > 	https://bugzilla.kernel.org/show_bug.cgi?id=3D47631
> > > >=20
> > > >=20
> > > > Could someone try this patch against Linus' tree?
> > >=20
> > > Urgh, and here's a version that isn't utterly, utterly broken...
> >=20
> > Thanks for Matt's patch, we will try it!
> >=20
> > Joey Lee
>=20
> Frederic confirmed your patch works to him for fix issue on HP machin=
e.
>=20
> Tested-by: Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
>=20
> But, I suggest we just use the length with NULL in variable_name but =
not
> VariableNameSize that was returned by GetNextVariableName.
>=20
> My thinking is following...
>=20
> >=20
> > >=20
> > > ---
> > >=20
> > > >From 4b2ef72bca72039717efe4570ec858a86d565b34 Mon Sep 17 00:00:0=
0 2001
> > > From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Date: Fri, 1 Mar 2013 14:49:12 +0000
> > > Subject: [PATCH] efivars: Sanitise string length returned by
> > >  GetNextVariableName()
> > >=20
> > > Some buggy firmware implementations return a string length from
> > > GetNextVariableName() that is actually larger than the string in
> > > 'variable_name', as Michael Schroeder writes,
> > >=20
> > >   > On HP z220 system (firmware version 1.54), some EFI variables=
 are
> > >   > incorrectly named :
> > >   >
> > >   > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be return=
s
> > >   > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0=
d-00e098032b8c
> > >   > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0=
d-00e098032b8c
> > >   > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0=
d-00e098032b8c
> > >   > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d=
2-aa0d-00e098032b8c
> > >=20
> > > Since 'variable_name' is a string, we can validate its size by
> > > searching for the terminating NULL character.
> > >=20
> > > Reported-by: Frederic Crozat <fcrozat-IBi9RG/b67k@public.gmane.org>
> > > Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> > > Cc: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Cc: Michael Schroeder <mls-IBi9RG/b67k@public.gmane.org>
> > > Cc: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > > Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/firmware/efivars.c | 30 ++++++++++++++++++++++++++++++
> > >  1 file changed, 30 insertions(+)
> > >=20
> > > diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivar=
s.c
> > > index 7320bf8..ab477b8 100644
> > > --- a/drivers/firmware/efivars.c
> > > +++ b/drivers/firmware/efivars.c
> > > @@ -1895,6 +1895,33 @@ void unregister_efivars(struct efivars *ef=
ivars)
> > >  }
> > >  EXPORT_SYMBOL_GPL(unregister_efivars);
> > > =20
> > > +/*
> > > + * Sanity check size of a variable name.
> > > + */
> > > +static unsigned long sanity_check_size(efi_char16_t *variable_na=
me,
> > > +				       unsigned long variable_name_size)
> > > +{
> > > +	unsigned long len;
> > > +	efi_char16_t c;
> > > +
> > > +	/*
> > > +	 * The variable name is, by definition, a NULL-terminated
> > > +	 * string, so make absolutely sure that variable_name_size is
> > > +	 * the value we expect it to be. If not, return the real size.
> > > +	 */
> > > +	for (len =3D 2; len <=3D variable_name_size; len +=3D sizeof(c)=
) {
> > > +		c =3D variable_name[(len / sizeof(c)) - 1];
> > > +		if (!c)
> > > +			break;
> > > +	}
> > > +
>=20
> We just direct return the len here but don't need compare with
> variable_name_size.
>=20
> 	return len;
>=20
> > > +
> > > +	if (len !=3D variable_name_size)
> > > +		printk(KERN_WARNING "efivars: bogus variable_name_size: %lu %l=
u\n", len, variable_name_size);
> > > +
> > > +	return min(len, variable_name_size);
> > > +}
> > > +
>=20
> In UEFI 2.3.1 spec:
>=20
> VariableNameSize		The size of the VariableName buffer
>=20
> Note that if EFI_BUFFER_TOO_SMALL is returned, the VariableName buffe=
r
> was too small for the next variable. When such an error occurs, the
> VariableNameSize is updated to reflect the size of buffer needed. In =
all
> cases when calling GetNextVariableName() the VariableNameSize must no=
t
> exceed the actual buffer size that was allocated for VariableName.
>=20
>=20
> Per spec, VariableNameSize will updated to 'the size of buffer needed=
'
> when EFI_BUFFER_TOO_SMALL, but spec doesn't mention VariableNameSize
> will also updated when EFI_SUCCESS. That means 'VariableNameSize =3D =
1024'
> when EFI_SUCCESS is not a bogus value.
>=20
> > >  int register_efivars(struct efivars *efivars,
> > >  		     const struct efivar_operations *ops,
> > >  		     struct kobject *parent_kobj)
> > > @@ -1941,8 +1968,11 @@ int register_efivars(struct efivars *efiva=
rs,
> > >  		status =3D ops->get_next_variable(&variable_name_size,
> > >  						variable_name,
> > >  						&vendor_guid);
> > > +
> > >  		switch (status) {
> > >  		case EFI_SUCCESS:
> > > +			variable_name_size =3D sanity_check_size(variable_name,
> > > +							       variable_name_size);
> > >  			efivar_create_sysfs_entry(efivars,
> > >  						  variable_name_size,
> > >  						  variable_name,
> >=20
>=20
> Due to variable_name_size could be 1024, so I suggest direct feed the
> length of variable_name to efivar_create_sysfs_entry since we are nee=
d
> to count the length.
>=20
> This is a simply diff for my think:
>=20
>=20
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 7320bf8..99a4f9f 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -1895,6 +1895,21 @@ void unregister_efivars(struct efivars *efivar=
s)
>  }
>  EXPORT_SYMBOL_GPL(unregister_efivars);
> =20
> +static unsigned long variable_name_length(efi_char16_t *variable_nam=
e)
> +{
> +	unsigned long len;
> +	efi_char16_t c;
> +
> +	len =3D 2;
> +	do {
> +		c =3D variable_name[len / sizeof(c) - 1];
> +		if (c)
> +			len +=3D sizeof(c);
> +	} while (c);
> +
> +	return len;
> +}
> +
>  int register_efivars(struct efivars *efivars,
>  		     const struct efivar_operations *ops,
>  		     struct kobject *parent_kobj)
> @@ -1944,7 +1959,7 @@ int register_efivars(struct efivars *efivars,
>  		switch (status) {
>  		case EFI_SUCCESS:
>  			efivar_create_sysfs_entry(efivars,
> -						  variable_name_size,
> +						  variable_name_length(variable_name),
>  						  variable_name,
>  						  &vendor_guid);
>  			break;
>=20

Hmm.. the reason I didn't implement the patch this way is because I do
think it's important to make sure we don't go out of bounds looking for
the terminating NULL, i.e. you need a 'len < variable_name_size' check
somewhere.

Care to update and resend your patch, ensuring we don't inspect more
than variable_name_size characters?

Also, which machine did you see this behaviour on?

--=20
Matt Fleming, Intel Open Source Technology Center
