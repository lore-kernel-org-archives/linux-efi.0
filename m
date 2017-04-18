From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH 15/24] asus-wmi: Restrict debugfs interface when the
 kernel is locked down
Date: Tue, 18 Apr 2017 18:39:18 +0100
Message-ID: <1492537158.2409.147.camel@decadent.org.uk>
References: <1492526075.2409.140.camel@decadent.org.uk>
         <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
         <149142340198.5101.8171352010918423590.stgit@warthog.procyon.org.uk>
         <CAHp75VfpsnCHVqnFnwwh3JHB0ccY66Gj88sMGhrA9W7rDxiY_Q@mail.gmail.com>
         <31421.1491569449@warthog.procyon.org.uk>
         <CAHp75VfvWmv7SxgwCgR-ZBYPbeQW=+qesDoBNC5JFPtvzsN5gg@mail.gmail.com>
         <13615.1491830208@warthog.procyon.org.uk>
         <CAHp75Vd+-_CmW2MPpK3b6bER8bFmECusnx0BZMwYAizWZys4YA@mail.gmail.com>
         <16503.1492529434@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-PjgoJAt2XrmYnGr0bCTk"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <16503.1492529434-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, acpi4asus-user <acpi4asus-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Platform Driver <platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-PjgoJAt2XrmYnGr0bCTk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-04-18 at 16:30 +0100, David Howells wrote:
> Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org> wrote:
>=20
> > So it's generally not going to be OK to turn off debugfs.=C2=A0=C2=A0Th=
ere will
> > probably need to be a distinction between believed-safe and unsafe
> > directories/files.
>=20
> Any suggestion on how to mark this distinction?

I don't know.

> I'd prefer not to modify every read/write op associated with a
> debugfs file.

I think debugfs should be assumed unsafe by default.  So only the
believed-safe parts would need to be changed.

> Modify
> DEFINE_DEBUGFS_ATTRIBUTE() maybe?=C2=A0=C2=A0And provide lockable variant=
s of
> debugfs_create_u8() and co.?

That could help.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.


--=-PjgoJAt2XrmYnGr0bCTk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlj2T0YACgkQ57/I7JWG
EQlfzA//VHvVydwqOJlDEXlQSYXVftsuPkvgvNHB2VO5N27m8i/8hawuSi+RAeZV
rOPwwircNhAuVxj9GuieaxF2iv7F3N5qLRWqahcJhghnBlNN5vzRRFk1n8+xj0FY
VOkP+SpuHDnxFoFzowinEBu1JgoxOOAScWNOEmhK5cfjZYBLYZb0qaURcv+DuWzw
cTu/NeVm9rcyn9AGNo0U0YNxnBN+lW65ta6y+hch6d3qTdpQh17UBX0/mtybu2Qu
jnDHWwWX9asZDSOWzj6JdDeZFC7MQrjFjl/AUfvoxPEbrQGWakGf40OMx09TMi+N
yKxiyeT/++xSbfxcMl0Xlezm6xiX3wRPn5/kQ5n6YMM8F6dtlddkBQztMatYau78
5lAQi7XyVtT/j7AnhtTebVpgDA1K0cHOuRZdUi56K2Nf8b3jfNWsun+eZL/AXRcm
nPYlaaMhTdoibpG3Cqctl/0veayIa7S1mjQp0yg6LIK8hNYOnL7ZqFRqGi2i/A1p
JyNI9YFY9HHTMpfw3aXHYmFH60IZlwRP8m3f+Z7bPlztk8n9gPKl1lc9DD/tSb5H
b9vVDE+jn8QjQCCXzAhF6jCtwNEZJgPoM+HSjYb04yvxlmsewHoZFfJRMi+sVGv+
GJrEQheIoth2wCe+JQWelkXg3IokOaHtAywNDIwj1tVMPWO7n1Y=
=ZIc7
-----END PGP SIGNATURE-----

--=-PjgoJAt2XrmYnGr0bCTk--
