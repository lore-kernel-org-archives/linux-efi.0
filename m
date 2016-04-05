From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure
 notifications
Date: Tue, 5 Apr 2016 11:24:54 -0700
Message-ID: <20160405182454.GG1924@sirena.org.uk>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
 <1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
 <20160331172935.GL2350@sirena.org.uk>
 <CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
 <20160401140856.GW2350@sirena.org.uk>
 <CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
 <20160402162449.GB2350@sirena.org.uk>
 <CAE1zotKDZd2mYmzoQvCPgVrZ5vfOrPDtBRzTscdsqrZbT8Z+cg@mail.gmail.com>
 <20160404160327.GH2350@sirena.org.uk>
 <CAE1zot+ESGBEYeUbLTreKfkc-6B45uQq3PWhhRfBo1AWd-7Vxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1giRMj6yz/+FOIRq"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAE1zot+ESGBEYeUbLTreKfkc-6B45uQq3PWhhRfBo1AWd-7Vxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--1giRMj6yz/+FOIRq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 04, 2016 at 10:34:56PM +0300, Octavian Purdila wrote:
> On Mon, Apr 4, 2016 at 7:03 PM, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> > Why is probe different to hotplug?  We don't need to do that in the
> > normal driver model.

> There might be some confusion with the term, I am referring to slave
> hotplug, not controller hotplug.

That's what I was talking about too.

> The way I see it, there are two logical operations: probe of a
> controller and the associated enumeration of the SPI slaves for that
> bus and "hotplug" of new SPI slaves and the enumeration of those
> particular slaves.

I don't see a distinction here.  The firmware finds some new slaves to
tell the framework about.  Quite why it decided to go looking shouldn't
matter.

> When a slave hotplug happens for device tree we get a device node
> notification and we can instantiate the SPI slave based on that info.
> In case of ACPI, (at this point) we get a global callback and in that
> callback we need to iterate through *all* controllers.

That's not really helping me understand why you need every bus to open
code enumeration twice?

--1giRMj6yz/+FOIRq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXBAL0AAoJECTWi3JdVIfQirEIAIYk7r6B53dH3hythb8IZc0I
anQDvflPcYiwiQj139n4m+5oA8L8264jlFcf26CjqSpSfCR4ctgK28mImwGHnuNs
sfTR7Jy91JnkhWchPYJfhYud9KiehXthilONbYcUWYCkDFBgqG7yU9NE78CQfpnN
E6Dt3xapZigPEK1vhjghOYUr9Y5iG13rEGOWKVfnG/heOdMLhJRBpYrUoYRjM/CS
6NDDzCwt1zdqHm8eXUYjKFJS0jDusvYglveGKA8zup6FZgxbW/1Zr/0/A/f7Micg
lMaEAoeVv4vMlUSvgqz8uHWk2gxh66mulC4fEwCwL+8T6052Ic3bl4YW6UUrE6A=
=2nCu
-----END PGP SIGNATURE-----

--1giRMj6yz/+FOIRq--
