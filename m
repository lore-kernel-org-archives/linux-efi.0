From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH V2] efi: fix 32bit kernel boot failed problem using efi
Date: Mon, 03 Aug 2015 23:15:33 +0100
Message-ID: <1438640133.3225.112.camel@decadent.org.uk>
References: <1438567369-23332-1-git-send-email-fupan.li@windriver.com>
	 <20150803161509.GA18377@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fOfev0svnuteN8vhAFNc"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150803161509.GA18377-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fupanli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-fOfev0svnuteN8vhAFNc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-08-03 at 09:15 -0700, Greg KH wrote:
> On Mon, Aug 03, 2015 at 10:02:49AM +0800, fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wrot
> e:
> > From: fli <fupan.li-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
>=20
> This needs to match the signed-off-by line, otherwise I can't take it=20
> :(
>=20
> Please fix up and resend.
>=20
> And what -stable tree is this for?

The bug was introduced in 35d5134b7d5a on the 3.10 branch, but the same
bug in the backport seems to have been introduced on the 3.14 branch
and two others you don't maintain:

v3.10.39: 35d5134b7d5a x86/efi: Correct EFI boot stub use of code32_start
v3.12.20: 065487a10a22 x86/efi: Correct EFI boot stub use of code32_start
v3.14.3: 45ada9fae6d8 x86/efi: Correct EFI boot stub use of code32_start
v3.11.10.11: f32e88d764e3 x86/efi: Correct EFI boot stub use of code32_star=
t

Ben.

--=20
Ben Hutchings
Unix is many things to many people,
but it's never been everything to anybody.


--=-fOfev0svnuteN8vhAFNc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVb/oBee/yOyVhhEJAQoQmw/5ASgGcKnT0Sf5Mrw1G3L3GfeUgWv1iOLt
AdEcrQ+eXZltlla9GHy2rzzIJkdXAKiMEu5AUUZpt1m5nk2qgOJ4inzCz53iIgGt
GTenMWg67MumGMWhlYqDhYXT87hmczmTcRsA0k0HRy2U39I1o5IXJpCqr8Loc8ZI
UjeXJnz7Z4bUahQx+wLR2Pjma9GASC/wBaGqRZPGosjPs+Ojiet1TaahDc30KQfp
1NvlB+49o/7DExVkO8vAdZe4F8M6FkqGasP8Vu8gtXDfRiLWWI0Q5+7e357iGRv9
5Eyseg+jTLrqQJSt2xGe6pc49DnTFA0TVMStdS7jFOFXLOFgmBwDOT2k8WzacbEE
r/4WmkKJG1pga5g8wcMHtnWvVJb6Dqgvyi60P2etuNyne+nWnfmvBoS+85p4pfWk
xT7FbhtHFamsZKyZx9ZPVDAhMsLM6I4ETUiH68LBpL4GOT4s8pdxCHll0JCYF9NG
P/wGwMtF2UkY9HF4+rBdGypvbhPzlh/9ADHSstmP5405/zCMHYF0at0v/PsnUHue
Diz1+jBug+JyAahwbGJ3vs8buKU5+0uhUQSvIQtoGbB9SUp4SJ2WLcGe2xmSEYgd
9P9TDP0e+prsvlsxOFryBndGbj1OIShvfMrgLQ7tmrJ4F27gYtyKsOXDZ2AKmGQl
VMD/msdvAHE=
=Zlb6
-----END PGP SIGNATURE-----

--=-fOfev0svnuteN8vhAFNc--
