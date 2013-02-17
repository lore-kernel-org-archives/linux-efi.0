From: Yves-Alexis Perez <corsac-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/15] Secure boot policy support
Date: Sun, 17 Feb 2013 20:19:35 +0100
Message-ID: <1361128775.20542.6.camel@scapa>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-B0wckL0qdO0tV3XIZVXr"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-B0wckL0qdO0tV3XIZVXr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On lun., 2013-01-28 at 11:42 -0500, Matthew Garrett wrote:
> Secure boot makes it possible to ensure that the on-disk representation o=
f
> the kernel hasn't been modified. This can be sidestepped if the in-memory
> representation can be trivially altered. We currently have a large number
> of interfaces that permit root to perform effectively arbitrary
> modifications to the kernel, so this patchset introduces a new capability
> ("CAP_COMPROMISE_KERNEL") that controls whether or not these features are
> available. The aim is for this to be useful in any other situations where
> kernel integrity can be assured by some other mechanism rather than speci=
al
> casing UEFI.
>=20
Wouldn't it make sense to prevent writing to MSRs too? Something like
c903f0456bc69176912dee6dd25c6a66ee1aed00 with CAP_COMPROMISE_KERNEL?

Regards,
--=20
Yves-Alexis

--=-B0wckL0qdO0tV3XIZVXr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABCAAGBQJRIS1HAAoJEG3bU/KmdcCl53YH/3VkZsNDo6we+2sGDRLsgJsG
PuoxwbXIAcs7d0nH1exVo2E/WT9lHLgQdtYOEv6Who4tT6D9IG+y8kcOADb4eCWP
0yVv7f9t7d90QJhyU/A0ThJlPN6av+942GW9biW7TaQFEle5ADaUkiL0WsGFCdzP
wka0LGMYQLCkF336ftdQ+BR9Ye49MUsAUBECFEBCmRlX/Lzzryl9Ly0wZENbHqC6
C+rM0FMTVa7E6DKB5DGz41Gsm1uI3tZnz8PWblChatv+rFf3F0KTjs/gacsJrGlJ
Iszs4Gjfmrp3OTnLu5JkAKJmUgoTdj9mc+0qZ6wMKOnFh7Tb1aVwyEfRj5xDH5w=
=LCji
-----END PGP SIGNATURE-----

--=-B0wckL0qdO0tV3XIZVXr--
