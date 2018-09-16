From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] x86: boot: Fix EFI stub alignment
Date: Sun, 16 Sep 2018 16:22:47 +0100
Message-ID: <20180916152246.GG4765@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+1TulI7fc0PCHNy3"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


--+1TulI7fc0PCHNy3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

We currently align the end of the compressed image to a multiple of
16.  However the PE-COFF header included in the EFI stub says that the
file alignment is 32 bytes, and when adding an EFI signature to the
file it must first be padded to this alignment.

sbsigntool commands warn about this:

    warning: file-aligned section .text extends beyond end of file
    warning: checksum areas are greater than image size. Invalid section ta=
ble?

Worse, pesign-at least when creating a detached signature=E2=80=94uses the
hash of the unpadded file, resulting in an invalid signature if
padding is required.

Avoid both these problems by increasing alignment to 32 bytes when
CONFIG_EFI_STUB is enabled.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -391,6 +391,13 @@ int main(int argc, char ** argv)
 		die("Unable to mmap '%s': %m", argv[2]);
 	/* Number of 16-byte paragraphs, including space for a 4-byte CRC */
 	sys_size =3D (sz + 15 + 4) / 16;
+#ifdef CONFIG_EFI_STUB
+	/*
+	 * COFF requires minimum 32-byte alignment of sections, and
+	 * adding a signature is problematic without that alignment.
+	 */
+	sys_size =3D (sys_size + 1) & ~1;
+#endif
=20
 	/* Patch the setup code with the appropriate size parameters */
 	buf[0x1f1] =3D setup_sectors-1;

--+1TulI7fc0PCHNy3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBW551Rue/yOyVhhEJAQqNABAAwFuo/teSbneCGf4Vt8zY8T2h9LUEfH+j
vAQwgSUhIgYX1DXB0SlwoHwCEaP+0K4IDpZ56Msaqv/H6zoHQrqjZknG3NIeBEiX
Z5eXdPNHUkwbNNL0F+SGa7R/XTU0Dc7uMysFIToKRlTnl5WtJPO5Rq/yGlJ/U7Jg
pOPf35pkPuf7yBaU32I//M29kGuyBxEjbiaGr+7zl6bdPYiBo1UyUCciw3F8Xq2W
0nEcBsfON39wTs4fDrAZiV1axeLdNhTXUdPyHpwtWA7NzDoBqv2HRICkQo+ADad/
zEZDsWkiOK3xs3+55M9Ovh4zSZa5/ROhwNzc6+mhXApOpNys3nKW/tcwjrd1PCMi
qu5QnRfrj4zs3mOvdtasouwLLicLiJ4rSbseP3ghHEjbV50zMbyimOkErNhQUtY+
HOWJWHhDyjq/ltTiAMfaYhmN8UgqrC8a9oVaJ48eMEQZqeVBryJcXDnD+fnq+aOa
TaHCwERxtkOpZ94gSmKdpW6oouTqChkOcR8Mm2CC75uq2n21/i/AM2kouVvlG/5n
QBrAs/hwBLIuleMg4CiKvoeAddJi+NKPF2M3HpIOO4OD8RGI2cZqW8RcoOKsKXcV
D4H8FSNFVCB2gQJGFSLW4W8qi+y8uEG2T8CJVpKWQ6C/HthvG9mz7/L9HptXVJz3
mN8lvesv3oI=
=CuZ8
-----END PGP SIGNATURE-----

--+1TulI7fc0PCHNy3--
