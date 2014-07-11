From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Subject: Re: [PATCH] efi: Include a .bss section within the PE/COFF headers
Date: Fri, 11 Jul 2014 19:22:14 +0200
Message-ID: <53C01D46.6040007@archlinux.org>
References: <1404942094-29447-1-git-send-email-mbrown@fensystems.co.uk> <20140710103431.GE15932@console-pimps.org> <20140710144815.GG15932@console-pimps.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="B1WXcjOqNFOTAPlno5wFmc5MA0jWunvmh"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140710144815.GG15932-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--B1WXcjOqNFOTAPlno5wFmc5MA0jWunvmh
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 10.07.2014 16:48, schrieb Matt Fleming:
> On Thu, 10 Jul, at 11:34:31AM, Matt Fleming wrote:
>>
>> Thomas, the patch in question is here this one,
>>
>>   http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/=
?h=3Durgent&id=3Ddb0f1ff0ee1750cc52ead0ba1ddf95c47b3bd133
>=20
> Correction, it's now this one,
>=20
>   http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?=
h=3Durgent&id=3Dc7fb93ec51d462ec3540a729ba446663c26a0505
>=20

Hello Matt, thanks for forwarding the patch. We applied it to our linux
3.15 package, and at least one user still reported failure. Due to the
random nature of the problem, we will need to wait for a few builds to
see if the problem occurs less often.

See here https://bugs.archlinux.org/task/33745#comment125251:

"Comment by Steven V (steabert) - Friday, 11 July 2014, 15:59 GMT+2
For me, 3.15.5-2 still doesn't work (Dell Latitude E4310)."



--B1WXcjOqNFOTAPlno5wFmc5MA0jWunvmh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTwB1IAAoJEChPw0yOSxolcPcQAI6c1zwKQOkRCa98tL0CEYi7
sMRy2owrLwpGQY6Z2vHxv2fhLDrbNMqOH1GF2130TbXBTsGlyacZQiRoH7JgNAek
3g6ckC4pYHfCGoyybdc6kXAxKoMZvljuMRwCz/QNj+f//zbbcv7v0p+6PMxCNf5y
QaDxXC5bzc5Ax5ie4wTeRpF+wVWNFOHryPGMnggirsFUa3gBsC8YWm8ewcFCl5Xt
ErloJs/MxsLdtw/nHcbJtuHLWaEZEBA8gSThakgspQOAzrCtuagc85TF0Gn+Qfjw
ImtuMs/gAbDV1S83axAuRe/NxlK7iSAK6B5C0sqTy2RqTlSsd6xJF2Z1qUjH3zcb
//liS+kdVgdzDRXjSHejn5fRPM2nY0OGqim6q+9311hV3q8u1PskV1Viw/WvU/Me
lT3pzqZddL5arzdVQQbNHFDKbL3Cd6Wko3MRwvOY5WPVlpv6IB3DAdA8cvvM6Mqa
ZDc2+8nSKakl1FUVOczxY91dMJVHy6iGckKiIPCcrB8jK36PAenh+Ql7vx0gP605
dfTmbwNpZYanZwtGMU9Uxyf8k64qXyItUFF8VJ33iqchK9KTQ8BTHmvUrwDsD6pb
CsDclYYggxCHqF/v82wAyf49B5MOVS2YqFlzx/Xwk4aHzEMNWznUbdZA2/DXddAR
91VveXH/aUGWaj1D5k70
=18Fe
-----END PGP SIGNATURE-----

--B1WXcjOqNFOTAPlno5wFmc5MA0jWunvmh--
