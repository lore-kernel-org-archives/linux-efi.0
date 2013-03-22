From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH] efivars: Fix check for
 CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
Date: Fri, 22 Mar 2013 20:18:36 +0000
Message-ID: <1363983516.3728.41.camel@deadeye.wl.decadent.org.uk>
References: <1363982211.3728.38.camel@deadeye.wl.decadent.org.uk>
	 <1363983063.1390.186.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ff1+ZET/b5CYGs2M+mC3"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363983063.1390.186.camel-uMdlDhfIn7prKue/0VVhAg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-Ff1+ZET/b5CYGs2M+mC3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-03-22 at 21:11 +0100, Paul Bolle wrote:
> On Fri, 2013-03-22 at 19:56 +0000, Ben Hutchings wrote:
> > The 'CONFIG_' prefix is not implicit in IS_ENABLED().
>=20
>     $ git grep -n "\bIS_ENABLED(" | grep -v "(CONFIG_"
>     arch/arm/mach-clps711x/board-autcpu12.c:161:	if (IS_ENABLED(MTD_NAND_=
GPIO) && IS_ENABLED(GPIO_GENERIC_PLATFORM)) {
>     arch/arm64/mm/mmu.c:264:	bool page64k =3D IS_ENABLED(ARM64_64K_PAGES)=
;
>     [...]
>=20
> Did you check these other three (potential) problems too?

I found those too, but this one was slightly more urgent for me!

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-Ff1+ZET/b5CYGs2M+mC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUy8nOe/yOyVhhEJAQq29xAAzuTcE9jm6S99NT2Yc0H/7AWIpg3gWAQc
fVzJHu+XuxNRJR4OTb1IDcc4omstCESS3oNBVTAolHoPgyOU+QEk4Q39BYbqo45m
tLsHYcSHLzF/hbf8+FSERdxmpTU8SiM3QxJ+yujrVuRJaD05ZkeHhuRjPPCC7mHi
UBxE5TM48FXB/LUmHOBS4nDKZt+b2pfFeJUjRnKI0AL0JDhuIksAJdw+iaZq2IDA
BqEnBfMVP4PBYrWTrFBQwb2eyQVwNsSw2wRxWt8MHepMYFYbbOagVjQ42gjJlp3J
q5SWO5vxGrn7dHv1svtQniZAFv1m5C1FHd5npSgbgfh1bPK+x0giKmldX5n12wt4
3YYFA49Iab5DZczmHUdOfZMMmEcGeS6oCXsNj1i2y8ytNiM7XPW6CImCGpHWiPct
zK4arcECmFy2y/4JEXTo+Nimv4MGwuZxQ3YDgIm9BQF+5lrfkk+Yvz9zS/irvbC1
g3hiLlJXBZW9OjC/CFEH7N9JRaPCZ/ChIJuErxLxSMqJBNZQj9/vN6ATk0OXP6gk
wlgmMsNRp8VEFnWNyFtYob+shBQjevnro3xeCARqMugcmRT3dgqgx1j3ndxcYzYm
htredn1ztoIPUoQS/2R4M3jNZGVTSTu2SIOdibc7ZBkpWRiL2EYUyipprLCQK07N
qcjeTmgSk84=
=l/uD
-----END PGP SIGNATURE-----

--=-Ff1+ZET/b5CYGs2M+mC3--
