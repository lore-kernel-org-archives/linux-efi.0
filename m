From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure
 notifications
Date: Tue, 5 Apr 2016 14:20:54 -0700
Message-ID: <20160405212054.GK1924@sirena.org.uk>
References: <20160401140856.GW2350@sirena.org.uk>
 <CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
 <20160402162449.GB2350@sirena.org.uk>
 <CAE1zotKDZd2mYmzoQvCPgVrZ5vfOrPDtBRzTscdsqrZbT8Z+cg@mail.gmail.com>
 <20160404160327.GH2350@sirena.org.uk>
 <CAE1zot+ESGBEYeUbLTreKfkc-6B45uQq3PWhhRfBo1AWd-7Vxw@mail.gmail.com>
 <CAJZ5v0gV8N6zgVrwtRFaY98Wv1HsoKs+4=U-s_V29FSpCdFW3g@mail.gmail.com>
 <CAE1zot+wvU_he-6cFQi1np9X1=FcXWoF-mbxYDRYUkyOT+7nyQ@mail.gmail.com>
 <20160405183255.GH1924@sirena.org.uk>
 <CAE1zotL7X+di4rHecRW_G-45wUPbbNb9jvn3C_zjD4XttZ4v3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rnP2AJ7yb1j09OW/"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE1zotL7X+di4rHecRW_G-45wUPbbNb9jvn3C_zjD4XttZ4v3w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--rnP2AJ7yb1j09OW/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 05, 2016 at 10:16:16PM +0300, Octavian Purdila wrote:
> On Tue, Apr 5, 2016 at 9:32 PM, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> > It's not specifically for SPI, it's the fact that you're asking every
> > single bus type which might be described in ACPI to handle both hotplug
> > and coldplug paths separately.  Given that the code that's being added
> > just seems like trivial boilerplate it seems like we're doing this
> > wrong, we should be factoring this out so there's nothing bus types can
> > get wrong.

> AFAICS this is exactly the same case for DT: one code path for
> coldplug and one for hotplug.

In the DT case the DT code understands a bit more of what's going on
with the firmware parsing which makes things better (the code in the two
paths is not identical, unlike ACPI) but yes, that's another aspect of
why I'm not thrilled with this - if it's not the hotplug and coldplug
that should be sharing code then perhaps it's along the firmware
interface axis that we need to be sharing things.

> Which makes me think that it is not possible to have a single path for
> both, or maybe its not worth it. Do I miss something obvious?

I think at a very high level what I'm looking at here is that we're
having to write too much boilerplate per firmware interface.  Perhaps
the hotplug vs coldplug path isn't it, it looked like it from your
patch, but there must be something here we're spending too much time on.

--rnP2AJ7yb1j09OW/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXBCwoAAoJECTWi3JdVIfQsHkH/j7eyKHnPB34Mj3uvd2cG5/P
xHVEpoy7uAfZ9kV6st7j1OzO/T8rvuPNQN4H8nqPeKAPEzSGP8mWlg8NWLNIbx7o
WQmoJFj2QBOHS0Bctj5M729SqlhG+CxyuAjb1E0lqG9cJXWu7SI8JO5gFzkV0lDH
oeMlp1KOuim2nkan6o7oxqgixHlH1pp5g8soeRHjzOlMghGBmQNAVO42zieP9GVy
JYFxy/8MdcINnS7Vi4TcxngdtHSeLzs6pbzvna6q2ZfsjrMGl7Qai1Brt12rjt7R
SElNKtsSMzgOz7t7RbqEyxbc0h4pJJDBn9YiyEzdH8DTwHxL2ehy6VuS+nxmm6Y=
=EMam
-----END PGP SIGNATURE-----

--rnP2AJ7yb1j09OW/--
