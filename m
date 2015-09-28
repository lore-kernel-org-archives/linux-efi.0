From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: efi: Auto-load the efi-pstore module
Date: Mon, 28 Sep 2015 01:44:16 +0100
Message-ID: <1443401056.2517.27.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VTnsvcfJoqktViVIG9eW"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-VTnsvcfJoqktViVIG9eW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

efi-pstore should be auto-loaded on EFI systems, same as efivars.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
This was included in Debian 8 "jessie" with no complaints so far
(and without CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE set), so it seems
to be safe to do.

Ben.

--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -400,3 +400,4 @@ module_exit(efivars_pstore_exit);
=20
 MODULE_DESCRIPTION("EFI variable backend for pstore");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:efivars");
--=20
Ben Hutchings
All extremists should be taken out and shot.

--=-VTnsvcfJoqktViVIG9eW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVgiNYOe/yOyVhhEJAQq1EA/7BTWkL+WafvjVHJH56SixzOdCXyt8l8L1
kozEMdneoETgmBRaILZ5nzN8ioTVEV1G4W8krJHwYXzZRX1b+FEmr/OZfWFEfV3c
hj1NJdf1XawUE1CA6nJB9FleJmkr7XA5wX6oZC6uy7FATmv4zZJaW4eX0J46WSAd
mC5iO67G3+P5M00hq8VRM4fD2DMf3dx+GuePe1F8PMLI/IueRYlkqfIxaFnQELcU
EOvYVVDaj4oxPI4+FS6khahzzz4kZZi9UvzuU/HZ+ItNSbxSL5CrB1m43Z4BMRHD
OZ7xI2PxuNkVMu0PSxVZrYhVKfJDPdk0obeZK+qldmJ8GT3k+nQD3f8l5Udphz8u
D1tSGIB74FhVxTbBZOzoKNUjgZGt6Zqj43lad+Vp+OEz6jD3Gw/VGR7OXzULnwrL
uQcSshEgkXPA5T0Q3DCocGeQTGNOWB9I9WjbYmosde9DSy46NKiHSjKlJE4r/pMa
en0ucuMc7EPXonBbCoebSs9AyvYtLE8L2JQu3rsq/UpsgMMa/A7oczAJx/7r2JZ7
MCYAUsrgALT3d9LseHGGwy802Zh9eEKFUQ6QQ6YG9LDER1JzNqWfzGA3NXwqvr3F
Ak1SQrwPJBeKhf7Ru7QB9nEYHSHry33/36G9wlaQRSCigTXR19gj0MhSIBEUozVG
A/BWKDYQsKs=
=ZyE1
-----END PGP SIGNATURE-----

--=-VTnsvcfJoqktViVIG9eW--
