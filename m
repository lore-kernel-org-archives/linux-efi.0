From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 03/20] efi: add efivars kobject to efi sysfs folder
Date: Mon, 29 Oct 2012 14:55:54 +0800
Message-ID: <1351493754.21227.17.camel@linux-s257.site>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-4-git-send-email-matt@console-pimps.org>
	 <20121026111347.209c11c5@pyramind.ukuu.org.uk>
	 <1351250024.5303.68.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351250024.5303.68.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=94=EF=BC=8C2012-10-26 =E6=96=BC 12:13 +0100=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On Fri, 2012-10-26 at 11:13 +0100, Alan Cox wrote:
> > On Fri, 26 Oct 2012 08:51:46 +0100
> > Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> >=20
> > > From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >=20
> > > UEFI variable filesystem need a new mount point, so this patch ad=
d
> > > efivars kobject to efi_kobj for create a /sys/firmware/efi/efivar=
s
> > > folder.
> > >=20
> > > Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> > > Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > > Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/firmware/efivars.c | 11 +++++++++++
> > >  include/linux/efi.h        |  1 +
> > >  2 files changed, 12 insertions(+)
> > >=20
> > > diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivar=
s.c
> > > index 6d43bbd..4b12a8fd 100644
> > > --- a/drivers/firmware/efivars.c
> > > +++ b/drivers/firmware/efivars.c
> > > @@ -1527,6 +1527,7 @@ void unregister_efivars(struct efivars *efi=
vars)
> > >  		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
> > >  	kfree(efivars->new_var);
> > >  	kfree(efivars->del_var);
> > > +	kobject_put(efivars->kobject);
> >=20
> > This makes no sense - you already always unregister the kset in
> > register_efivars ?
>=20
> Crap. Yes, you're completely right. Thanks Alan.
>=20
> Joey, this chunk of your patch is incorrect,
>=20
> @@ -1558,6 +1559,13 @@ int register_efivars(struct efivars *efivars,
>  		goto out;
>  	}
> =20
> +	efivars->kobject =3D kobject_create_and_add("efivars", parent_kobj)=
;
> +	if (!efivars->kobject) {
> +		pr_err("efivars: Subsystem registration failed.\n");
> +		error =3D -ENOMEM;
> +		goto err_unreg_vars;
> +	}
> +
>  	/*
>  	 * Per EFI spec, the maximum storage allocated for both
>  	 * the variable name and variable data is 1024 bytes.
> @@ -1602,6 +1610,9 @@ int register_efivars(struct efivars *efivars,
> =20
>  	register_filesystem(&efivarfs_type);
> =20
> +err_unreg_vars:
> +	kset_unregister(efivars->kset);
> +
>  out:
>  	kfree(variable_name);
> =20
>=20
> because err_unreg_vars is in the *success* path, not the error path. =
So
> even if we successfully register efivarfs, we still call
> kset_unregister().
>=20
> Could you please fix this and resubmit?
>=20

Sorry for my mistake and thanks for Alan's review.

I just sent the following patch to fix the problem.


Thanks
Joey Lee


>From 49f036dd4e5e702a344f115177a58952c8aa5b0d Mon Sep 17 00:00:00 2001
=46rom: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Date: Mon, 29 Oct 2012 13:42:33 +0800
Subject: [PATCH] efi: fix always unregister kset of efivars in register=
_efivars

The cc9c97b76aa7235d5a1de0f74f990097f77008b4 patch introduced a
issue that always unregister kset of efivars in register_efivars.

This patch moved the kset_unregister function call to the kobject creat=
e check
block for fix issue.

Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/firmware/efivars.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 03e0df2..8870907 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1595,7 +1595,8 @@ int register_efivars(struct efivars *efivars,
 	if (!efivars->kobject) {
 		pr_err("efivars: Subsystem registration failed.\n");
 		error =3D -ENOMEM;
-		goto err_unreg_vars;
+		kset_unregister(efivars->kset);
+		goto out;
 	}
=20
 	/*
@@ -1642,9 +1643,6 @@ int register_efivars(struct efivars *efivars,
=20
 	register_filesystem(&efivarfs_type);
=20
-err_unreg_vars:
-	kset_unregister(efivars->kset);
-
 out:
 	kfree(variable_name);
=20
--=20
1.6.0.2
