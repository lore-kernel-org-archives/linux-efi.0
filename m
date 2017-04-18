From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 15/24] asus-wmi: Restrict debugfs interface when the
 kernel is locked down
Date: Tue, 18 Apr 2017 15:34:35 +0100
Message-ID: <1492526075.2409.140.camel@decadent.org.uk>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
         <149142340198.5101.8171352010918423590.stgit@warthog.procyon.org.uk>
         <CAHp75VfpsnCHVqnFnwwh3JHB0ccY66Gj88sMGhrA9W7rDxiY_Q@mail.gmail.com>
         <31421.1491569449@warthog.procyon.org.uk>
         <CAHp75VfvWmv7SxgwCgR-ZBYPbeQW=+qesDoBNC5JFPtvzsN5gg@mail.gmail.com>
         <13615.1491830208@warthog.procyon.org.uk>
         <CAHp75Vd+-_CmW2MPpK3b6bER8bFmECusnx0BZMwYAizWZys4YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-oh3Vr70YVFjl3JS4w0c9"
Return-path: <platform-driver-x86-owner@vger.kernel.org>
In-Reply-To: <CAHp75Vd+-_CmW2MPpK3b6bER8bFmECusnx0BZMwYAizWZys4YA@mail.gmail.com>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>, David Howells <dhowells@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, matthew.garrett@nebula.com, linux-efi@vger.kernel.org, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, acpi4asus-user <acpi4asus-user@lists.sourceforge.net>, Platform Driver <platform-driver-x86@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


--=-oh3Vr70YVFjl3JS4w0c9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-04-18 at 09:06 +0300, Andy Shevchenko wrote:
> > On Mon, Apr 10, 2017 at 4:16 PM, David Howells <dhowells@redhat.com> wr=
ote:
> > > > Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> >=20
> > > > > It looks a bit fragile when responsility of whatever reasons kern=
el
> > > > > can't serve become a driver burden.
> > > > > Can we fix this in debugfs framework instead?
> > > >=20
> > > > Fix it with debugfs how?=C2=A0=C2=A0We can't offload the decision t=
o userspace.
> > >=20
> > > I mean to do at least similar like you have done for module
> > > parameters. So, instead of putting above code to each attribute in
> > > question make a special (marked) attribute instead and debugfs
> > > framework will know how to deal with that.
> >=20
> > Hmmm...=C2=A0=C2=A0It's tricky in that debugfs doesn't have any of its =
own structures,
> > but is entirely built on standard VFS ones, so finding somewhere to sto=
re the
> > information is going to be awkward.
>=20
> I see.
>=20
> > =C2=A0One obvious solution is to entirely lock
> > down debugfs in secure boot more, but that might be a bit drastic.
>=20
> But this sounds sane! debugFS for debugging, not for production. If
> someone is using secure kernel it means pure production use (otherwise
> one may do temporary hacks in kernel).
[...]

Production systems need instrumentation to understand performance
issues and any bugs that=C2=A0for whatever reason didn't show up in earlier
testing.  A number of interfaces for that have been added under
debugfs:

- tracing (now tracefs, but it's expected to appear under debugfs)
- dynamic_debug
- various ad-hoc statistics

So it's generally not going to be OK to turn off debugfs.  There will
probably need to be a distinction between believed-safe and unsafe
directories/files.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.


--=-oh3Vr70YVFjl3JS4w0c9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlj2I/sACgkQ57/I7JWG
EQnt0Q/9H1V+Meq+gOJY9Pk9UUFAjXx4L9OPBttLCWvNE0t3mZUqyKW3myZku3o/
iP9VWNlYGEycsDBGMQZTCU/uJoSFpiionPT+Sb+kC7Qr0j9ORb3idyJILOsB1M4/
PUxsDUhmASwSLjn0bQwYQxthQYW0jKKc7trXqTNGlxLYwWf/tGy99xHUgX9dRb9q
y+CTfZCSNfrgXBesjGJPOUngs03BCPDWJWlANkcwNmCll+fdhB1mLPqU3J2A5pYP
4zOTng4APv2ELqdQJ7rRUxPJmVZ8CVWB8FSYGSzXh8t+iMkkO4GLR1f1yOimXeWF
iDXUZVuf5+qm56WWS/tPxuuu59le981NIOIf1IgVdyEGuTayZyeYYTjk/HMyT4a7
GQml72pkJrfLrlMm9NtCtBhMYRs9bunaSAZnwjd5aqGYo6abTyFJBYP3F5/yVrRS
OOkVMWSDm5slp+IXIH7dx6VcUaG5DXHET2COCAo/SsTIGavHPClKy7d96ydfzu7x
1se27l0lODBxw7qWesRSOUB5bFGdpehuBnAJvTjLwdd16kkQzFyZ56a+VZKNxmL+
GKQuwYAeUA4G9hbNww5zD1x4cmIDj9lkSWJYvwlKPFi2tM+rcXJHNEzJ1FYfQBgj
lkwngsnszeE+jhnN5b3aKXCain/IfmGwdgTm9oy1F7BnPkOXNak=
=3L3D
-----END PGP SIGNATURE-----

--=-oh3Vr70YVFjl3JS4w0c9--
