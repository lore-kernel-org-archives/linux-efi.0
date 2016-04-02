From: Mark Brown <broonie@kernel.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure
 notifications
Date: Sat, 2 Apr 2016 09:24:49 -0700
Message-ID: <20160402162449.GB2350@sirena.org.uk>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
 <1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
 <20160331172935.GL2350@sirena.org.uk>
 <CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
 <20160401140856.GW2350@sirena.org.uk>
 <CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rtWt6SZ6GqpxALBD"
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
Sender: linux-i2c-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org


--rtWt6SZ6GqpxALBD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 01, 2016 at 09:26:38PM +0200, Rafael J. Wysocki wrote:
> On Fri, Apr 1, 2016 at 4:08 PM, Mark Brown <broonie@kernel.org> wrote:

> > That's not the point.  The point is that since the handling is identical
> > why are we handling it through exactly the same code?

> I think that during the initial enumeration the controller driver's
> probe walks the children and creates device objects for them.  When a
> table is loaded later, the controller driver has been probed already
> and there needs to be a way to trigger a walk over the (new) children
> from it.

> Or a hook somewhere around acpi_platform_notify() is needed.

What I don't understand is why the flow on inital probe isn't simply to
register the controller which then triggers the walk of the children.
That way any bus that supports initial probe also supports hotplug
without needing to go and manually add a second code path.

--rtWt6SZ6GqpxALBD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJW//JQAAoJECTWi3JdVIfQFHwH/2J7wKNmy+CXSc+JOI24dd/l
BsStLIDa+Vh7k9Ml720D1EoA1NwZxKkMV2wmEMSrYBGwrIAVJr46l2L9sYo1nyzU
mTxlwWVPbbgr5ofF/RlaJrXFI3eIogBoXrrrPk54WrizG1W5LvNNn2xtzLJlHxGa
8olcz/UKlydNVA0n8y/8QR+Rg+uy6MULLqgpoTig0P5Hck6/E7gNG+gYZhwVA5yI
Ak4/HAe1BPdxaYUuf/rYqeRYLlXv4jPqZER5CTSPP/cU64XSns3S0AI8LXrgXFBV
DFCEvNpXoMKYpxCoXlzttIbPBgjP9mdiiVz2rL+JYkjTI0jwMHqRh4DvNDRoG8U=
=Kt7q
-----END PGP SIGNATURE-----

--rtWt6SZ6GqpxALBD--
