From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: General protection fault in efivarfs
Date: Fri, 11 Jan 2013 13:22:39 +0000
Message-ID: <1357910559.8203.313.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1351237923-10313-1-git-send-email-matt@console-pimps.org>
	 <1351237923-10313-2-git-send-email-matt@console-pimps.org>
	 <50D44279.7010008@redhat.com> <1356346840.6113.45.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356346840.6113.45.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, glin-IBi9RG/b67k@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2012-12-24 at 19:00 +0800, joeyli wrote:
> =E6=96=BC =E4=BA=94=EF=BC=8C2012-12-21 =E6=96=BC 19:05 +0800=EF=BC=8C=
Lingzhu Xiang =E6=8F=90=E5=88=B0=EF=BC=9A
> > The following reproducer triggers certain bugs in efivarfs_file_wri=
te.
> >=20
> > #!/bin/bash
> > p=3D/sys/firmware/efi/efivars
> > mount -t efivarfs - $p
> > cat $p/Lang-* >$p/test-12341234-1234-1234-1234-123412341234
> > umount $p
> > mount -t efivarfs - $p
> > echo -en "\0\0\0\0" >$p/test-12341234-1234-1234-1234-123412341234=20

Thanks for the report!

> The problem is check EFI_VARIABLE_MASK in efivars.c that is not enoug=
h
> for deny use 0x00000000 attributes.

Not quite, see below.

> Per UEFI spec, runtime variable at least need has attributes
> EFI_VARIABLE_BOOTSERVICE_ACCESS and EFI_VARIABLE_RUNTIME_ACCESS.
> Otherwise UEFI BIOS will occur unexpected error.
>=20
> Please try the following patch.
>=20
>=20
> Thanks a lot!
> Joey Lee
>=20
>=20
> >From cb0775a36f4d80f9fe2f9afee40c8b7310cbac8a Mon Sep 17 00:00:00 20=
01
> From: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> Date: Mon, 24 Dec 2012 18:33:52 +0800
> Subject: [PATCH] efivars: Check attributes of variable whan writing a=
t least need to define bootservice and runtime access
>=20
> The EFI variable filesystem used when system in runtime. The variable
> that wes wrote by user space application at least need to define
> EFI_VARIABLE_BOOTSERVICE_ACCESS and EFI_VARIABLE_RUNTIME_ACCESS in
> attributes.
>=20
> Cc: Gary Lin <glin-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  drivers/firmware/efivars.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 7b1c374..7aeb4a5 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -706,6 +706,10 @@ static ssize_t efivarfs_file_write(struct file *=
file,
>  	if (attributes & ~(EFI_VARIABLE_MASK))
>  		return -EINVAL;
> =20
> +	if (!((attributes & EFI_VARIABLE_BOOTSERVICE_ACCESS) &&
> +		(attributes & EFI_VARIABLE_RUNTIME_ACCESS)))
> +		return -EINVAL;
> +
>  	efivars =3D var->efivars;
> =20
>  	/*

This breaks the case where we want to create a variable that only has
boot time access. It's not inconceivable that someone may want to do
this from Linux. What you should be enforcing is that if
EFI_VARIABLE_RUNTIME_ACCESS is set, then EFI_VARIABLE_BOOTSERVICE_ACCES=
S
must be also. Can you re-work your patch to handle this case? Preferabl=
y
with a comment above the check as for why we have this check, i.e. it's
in the spec.

Regarding zero attributes: if user tools want to delete a variable by
using the zero attribute method, that's fine - we should handle that.
The real problem here is that if we try to delete a non-existent
variable or even if *creating* a variable fails, we don't delete the
file in the file system.

Thanks for the report guys, I'll cook up a patch.

--=20
Matt Fleming, Intel Open Source Technology Center
