From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: Patch "efi: Build EFI stub with EFI-appropriate options" has
 been added to the 3.6-stable tree
Date: Sat, 30 Mar 2013 03:28:41 +0000
Message-ID: <1364614121.3557.11.camel@deadeye.wl.decadent.org.uk>
References: <13511021101759@kroah.org>
	 <CAA7rmPF4oZjvwQ5LU1pJAydWhbwmCmzgUudUvQ5_YPpS_Rnjvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-lmADW6Nx5cRqcmfZgkG9"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA7rmPF4oZjvwQ5LU1pJAydWhbwmCmzgUudUvQ5_YPpS_Rnjvg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Vacek <neelx.g-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-lmADW6Nx5cRqcmfZgkG9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-24 at 22:13 +0200, Daniel Vacek wrote:
[...]
> Sorry, but the patch seems totally garbled. I've sent right fix a week ag=
o:
>=20
> https://lkml.org/lkml/2012/10/18/510
>=20
> From 53864fe932aa87be62f1c70944c386cff9bb9130 Mon Sep 17 00:00:00 2001
> From: Daniel Vacek <neelx.g-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Thu, 18 Oct 2012 22:06:26 +0200
> Subject: [PATCH] efi: fix typo in Makefile
>=20
> ---
>  arch/x86/boot/compressed/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/boot/compressed/Makefile
> b/arch/x86/boot/compressed/Makefile
> index 8a84501..059a17f 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -29,7 +29,7 @@ VMLINUX_OBJS =3D $(obj)/vmlinux.lds
> $(obj)/head_$(BITS).o $(obj)/misc.o \
>  	$(obj)/piggy.o
>=20
>  $(obj)/eboot.o: KBUILD_CFLAGS +=3D -fshort-wchar -mno-red-zone
> -$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS +=3D -fshort-wchar -mno-red-zon=
e
> +$(obj)/efi_stub_$(BITS).o: KBUILD_CFLAGS +=3D -fshort-wchar -mno-red-zon=
e
>=20
>  ifeq ($(CONFIG_EFI_STUB), y)
>  	VMLINUX_OBJS +=3D $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o

Daniel, this is an obvious fix but I noticed it still hasn't been
applied.  Please can you re-send with the proper Signed-off-by line?

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-lmADW6Nx5cRqcmfZgkG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVZb6ee/yOyVhhEJAQoL9A/9GldgWONHS8R1rGeomXiVGR+wM9KEMOwJ
zrxrNibliPIeC75FIOf4xJ0ZQO7YKFAYxo1nN2rggiwtKfnVLUEs56Z8DELlKAJm
BigZEghRmzljJsqALIvPMcrVfyld0Z06mwlUJXgkrLl1TURERlzJOCkS5MP6RJ0b
rTGNMLyMzYmaEJHNuT243D2BfWBlhb1QSO5g3Y4vRFoR0dAAwzQhugA1i0MdEzRm
euMSgKGxjl6DobpHUMQHeduvA6+W+ivDAzWt4LPmIbK8OcqPCL1jdLcNGLGZJ2n7
Iz3YPK/t3CdCFhZ8sfAuy8wl/31IDasQBtaEHi+wpTiiXJxAZzOuUfSUtUN12kEu
o7kSlDS3gPM2v5Iyxb4aBgymToCOLaYfCCCEXjZfajCL421TRjAljuQH+O8jT2eS
4ALb34bYTgEV3LcRplwY8nvTij0oQhNWJNEo70SLbP0mX3nKv1BUpLgVu/KbCgPo
gqUTuaqIZ88YUeZxblz4ynvVTRoz6jljlowR5B86ERIttqQd0bDNix6AuMsbj00G
/jP6vDIoXfWrahIkOdOlHAkvwOutarEEi4i03zgsYxDtJkwoXudh4Al6iVBsWtT8
gjAjWekyXPRTSCMWq+KwFzv4IEXO5a5VSGPv0yK4KlzTFIZlee8ViSfRYXk1EKv7
vc6usRFNjxs=
=DRmh
-----END PGP SIGNATURE-----

--=-lmADW6Nx5cRqcmfZgkG9--
