From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: efi: be more paranoid about available space when creating
 variables
Date: Mon, 01 Apr 2013 07:31:17 +0100
Message-ID: <1364797877.3557.81.camel@deadeye.wl.decadent.org.uk>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk>
	 <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk>
	 <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com>
	 <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net>
	 <514E31B0.4030305@intel.com> <20130326035600.GA6209@srcf.ucam.org>
	 <51517A59.30002@console-pimps.org> <20130326154359.GA20530@srcf.ucam.org>
	 <5152B75B.5080305@console-pimps.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-L0iVUypmo9eH982mU+wW"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5152B75B.5080305-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--=-L0iVUypmo9eH982mU+wW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-03-27 at 09:09 +0000, Matt Fleming wrote:
> On 26/03/13 15:43, Matthew Garrett wrote:
> > I'm not quite clear what you mean. We have a fairly solid idea as to=
=20
> > what the underlying problem here is, and I don't think this makes any=
=20
> > more assumptions than the existing code does.
>=20
> Right, it doesn't make more assumptions, but the assumptions that the
> existing code makes is causing problems, hence the need for your updated
> patch. I'm fully expecting that the updated patch will also cause us
> problems/require additional patches. I really don't want to keep
> patching/tweaking this all the way to -rc6 and beyond.
>=20
> Have you tested this patch against one of those machines that suffers
> from the original bricking problem? Ben, does this patch fix your issue?

It doesn't entirely fix it - that would require ignoring the max_size
and remaining_size values, and only considering available_size.

But it does mean that the system will only rarely get into a state where
efibootmgr can't write variables, and that it should take only a few
reboots to get out of that.

[...]
> Maybe we should leave the existing checks in place and create a
> whitelist for those machines that absolutely must be able to write to
> the variable store, e.g. to initiate garbage collection, or where
> QueryVariableInfo() is known to be inaccurate, or where we know we can
> have the full use of pstore without bricking the machine. Yes, we'll
> have to maintain the whitelist and we'll no doubt get bug reports for
> machines that need to be added to the list, but at least no one is going
> to brick their laptops, and the fix is simply adding an ID to the list,
> not reimplementing our workarounds with the risk of breaking X number of
> machines that were previously working just fine.

Let's also have a module parameter to set this behaviour, and some more
useful error logging in check_var_size_locked() that can help people to
determine the behaviour of their firmware.

Ben.

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-L0iVUypmo9eH982mU+wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVkptee/yOyVhhEJAQotrw//XNMjSTU1qZvgpEX0iFctAlncoFRzkHAl
Fwu5oAFE/OhaQJng2XCpJdMKvWRGe599hn/UB+x7i/eW+F6oHqrNjRA/8bQuVAHg
vtCXg2XUKj8mRxC3pewKEEKGdyWcWvKoux1mi3c6qgJ8KPjoJp5P8SVYDLaWVDT4
KQp60VCK4RI5qKlNoq+8YwzhS2Fy2h/ivk3rUTyPIUUfyL083fNK335qUTYXXOmg
jQpulpVjkhZT1WwQ7GdLsAH/4k0ySRkdAMIxBezz4iV/l+E4zOCNssLXdf94EwgS
3T+rOPRNM0Wg/mBYd74Fwk43NtdRZCcUOCphL0nhpAn1oj2uOrhOHomesqAVCQuE
nqIvOqJtQIzHQzwTbejnKfyIwNgjNJxuVBV3ifpvZah2mN4jE+KNmVbPs2u83Ff+
7MD7WP9oySRphkuF8B024YiTG7dcxvOWFgBFRZueZN/IZSid4dBgoqMVTEHl41Yc
dijJxzXQfNeDrhPTqMjMJCPLpJtogKQFLsbKARBjtOH4LNNQKin/iBOtXSisRGtE
1mnUGMgQ/t49lYt04q9nWoE/YHjaSGDvSWy1EDyNLHjQs7+wL/FQWDNgHTvyOmsj
UrjVVR5xpqnYZBt74naTUe//ZSEac7Y0UXUd3tLyZi61jhsCqui74CGOlFD++0NT
5wGLNWU4hlA=
=3jOO
-----END PGP SIGNATURE-----

--=-L0iVUypmo9eH982mU+wW--
