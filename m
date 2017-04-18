From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 15/24] asus-wmi: Restrict debugfs interface when the
 kernel is locked down
Date: Tue, 18 Apr 2017 16:19:59 +0100
Message-ID: <1492528799.2409.145.camel@decadent.org.uk>
References: <1492526075.2409.140.camel@decadent.org.uk>
         <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
         <149142340198.5101.8171352010918423590.stgit@warthog.procyon.org.uk>
         <CAHp75VfpsnCHVqnFnwwh3JHB0ccY66Gj88sMGhrA9W7rDxiY_Q@mail.gmail.com>
         <31421.1491569449@warthog.procyon.org.uk>
         <CAHp75VfvWmv7SxgwCgR-ZBYPbeQW=+qesDoBNC5JFPtvzsN5gg@mail.gmail.com>
         <13615.1491830208@warthog.procyon.org.uk>
         <CAHp75Vd+-_CmW2MPpK3b6bER8bFmECusnx0BZMwYAizWZys4YA@mail.gmail.com>
         <14918.1492527352@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-XeUQgI2ZpsvLSQFxSCyf"
Return-path: <platform-driver-x86-owner@vger.kernel.org>
In-Reply-To: <14918.1492527352@warthog.procyon.org.uk>
Sender: platform-driver-x86-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, matthew.garrett@nebula.com, linux-efi@vger.kernel.org, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, acpi4asus-user <acpi4asus-user@lists.sourceforge.net>, Platform Driver <platform-driver-x86@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


--=-XeUQgI2ZpsvLSQFxSCyf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-04-18 at 15:55 +0100, David Howells wrote:
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > - tracing (now tracefs, but it's expected to appear under debugfs)
>=20
> Shouldn't this now appear under /sys/kernel/tracing/ ?

True, but old tracing scripts didn't go away.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.


--=-XeUQgI2ZpsvLSQFxSCyf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlj2LqAACgkQ57/I7JWG
EQlB1RAAy79Qtt3T19+lo+s4LKTZOIfXBnfMs0jxxp77W6wlQEvKY/RAGRCNeAtX
dHKlhRONYauqqYda44T2t29gF00X/984Wv/6JN39+t3znPiUHBwobye49OQs0OFB
UsRUQJvOoxDT8vn1wjmbdlFv9GSFFLoeixBw0BIytFN2Nu3VEGws1AFJ7c6nsp9k
uN6GsAGz+tp3CY26pRNV+sWeZ/zrm8y23XxTUuVnGl19RmV/8qOalVVkG56Jmlba
VAtZg7V9VGQxPSAibeip5b4wjCJDIl8trzhfDBjKTLzKuCywUJWg6xplCp/CTelI
RNHY5wHmdFCsSekU244/Gr5Z2r/lukpCKwS1rycNZH+4vIlxvB0xUlqS8xYpQ9ps
TmUdvRq/aUwGEUw1WiwlEQYqF5NdpAI4IvEeKizksSskQ82iKwAEegQpceE1Mr7/
bK+NXfjWMb/qs7n2Rn9pUMZflJDVNEQHRKuGYK2dAscnfnaoNz42DMl+jz0Uj2gr
A81Jf9T+SarP/lu9g63qin/P6qWF/6c+0waa0E8jyhFN6C+yl+lj7BPoEFBKAgM1
PSm15HaN6omxPvAwTKcGeSFuyxE9Kd0J+rz0hDb1AQ4WMolVK+rdsVADC4UjuXR2
HyVdHnPSekk3/nJcmieJ9YMOkvH1Ipwu//viWO6vK5TuNF4WHgY=
=4F3y
-----END PGP SIGNATURE-----

--=-XeUQgI2ZpsvLSQFxSCyf--
