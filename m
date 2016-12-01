From: Samuel Bernardo <samuelbernardo.mail@gmail.com>
Subject: linux kernel support for logitech g502 proteus
Date: Thu, 1 Dec 2016 15:57:52 +0000
Message-ID: <2916ca4f-c4cf-06c9-3189-e33635ca621f@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oiOHFVip8rC8c60iVWvXg9lCg8JwiEbpm"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org, linux-newbie@vger.kernel.org, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oiOHFVip8rC8c60iVWvXg9lCg8JwiEbpm
Content-Type: multipart/mixed; boundary="cLa1dKfbBRdqHo9g9icsWrtm4NtEuDpPE"
From: Samuel Bernardo <samuelbernardo.mail@gmail.com>
To: linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-newbie@vger.kernel.org, linux-efi@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Message-ID: <2916ca4f-c4cf-06c9-3189-e33635ca621f@gmail.com>
Subject: linux kernel support for logitech g502 proteus

--cLa1dKfbBRdqHo9g9icsWrtm4NtEuDpPE
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I'm sorry if I'm spamming some lists with this help request, but I don't
know exactly what's the right mailing list.

I would like to use Logitech G502 RGB gaming mouse with programmed
profiles from their software, but I realized that generic driver in
linux didn't support it. Logitech discards any support for Linux OS.
This is the only reason I need a dual boot with Windows for programming
the mouse or generate the xml template for the key bindings.

In Windows key mapping for mouse can be loaded from a xml file that
stores profiles or programmed directly into the mouse, but limited to
the keys available in keyboard or software.The following guides explains
the setup:

http://support.logitech.com/en_us/article/26855

http://support.logitech.com/en_us/article/26862?product=3Da0q31000009u2F9=
AAI

With xml template is also possible to configure additional keys like F13
that are usefull to map macros for example in an IDE software. The guide
explaining how to change xml file is below:

http://i.imgur.com/NbmjWCS.png

This mouse has many programmable keys that I would like to use in linux.

I suspect that xml configuration is loaded with the windows driver for
g502. Since with actual generic driver in linux 4.8 the profile could
not be loaded, I ask if I you could help giving additional support for
it in linux kernel?

Thanks,

Samuel





--cLa1dKfbBRdqHo9g9icsWrtm4NtEuDpPE--

--oiOHFVip8rC8c60iVWvXg9lCg8JwiEbpm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYQEiBAAoJEO2Nqc2/qzs5ad4P/2HV35dLocPYbz38qVnmy06A
KGNcvyUDJpJWEyB0mkmztWneqGZkWWP5gx2srLkokSrcUOjmM45xjjYVPlHAAYBR
FCYgmQWna34Rxs6NZiucD6mfQTyw/77eeLZxWda4K0ZxnjTL8taAzvmoMZyB/gwC
g+peSlEN2NzXgTyLNEujPbykKh19W8ZihSpkDxuJeEiu9NCp9aXfIW4cmM5UHNM+
sjVqDKPxNLuukQC3IHZCOIUXIT39PtzErc7On5YdD4BXIRSy9PE8IjCBvfvFnyVT
MY2AuoGoh/rDmiZnCfBPWaWP8r9lrAiy8aT3oqIbuCbKeIeGfHvV9gcJiO4fdybR
PHeFEF6o68sIVd+7Kkl5IVOZBHxNp9iCOOpXrgYDtrVMFOCG9aZKoer6nN5jTNcq
JnpTorAVWgJeJRorzy5guMHSPsiZE/0PUyid7P2jS0tav6e91I4wEVVN5jlI//xV
rRN5TIJD9nOfZltGYLzKsjdcV1uhF15H5Ov+iFEvzY9uxT/WaCpuhEEyHSQ7ATp/
OaF+9izIzQp9uBlDfvfe1jIvG2ELim8lZSI5q9jqQuKFSSb44BfJ2jCXk1wtevDC
AFTC2zNoxlSbyB8L/pQ8s1Pu1eavE1aMZy7rg58W0Mq2xG0QsB0DbQgPx/TSj9/K
IOYEVBVmJ5OmycR9jdcb
=IXxD
-----END PGP SIGNATURE-----

--oiOHFVip8rC8c60iVWvXg9lCg8JwiEbpm--
