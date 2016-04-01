From: Mark Brown <broonie@kernel.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure
 notifications
Date: Fri, 1 Apr 2016 07:08:56 -0700
Message-ID: <20160401140856.GW2350@sirena.org.uk>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
 <1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
 <20160331172935.GL2350@sirena.org.uk>
 <CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hjRTvux2945W8dyK"
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org


--hjRTvux2945W8dyK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 01, 2016 at 01:54:28PM +0300, Octavian Purdila wrote:

> I probably don't fully understand your question, but I don't see a way
> of how we can create a new SPI device from generic ACPI code. For
> example, in acpi_spi_add_device() we need the spi_master node so that
> we can allocate the spi device.

Right, but the same applies to initial enumeration so we also have to
manually instantiate ACPI devices on startup.  Why do we need to do
that?

> The handling is identical because we don't have yet have a way to
> identify what where the new nodes added when a new ACPI table /
> overlay has been loaded, so we have to rescan the ACPI namespace under
> each controller.

That's not the point.  The point is that since the handling is identical
why are we handling it through exactly the same code?

--hjRTvux2945W8dyK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJW/oD0AAoJECTWi3JdVIfQaRAH/jeQz8zKvAX6aepL5CfzNu3V
o6yItlKEvj0noTBht+Qpw2MRWvpjZHMEWGV5XEmLZC3S7ft8apurWTGDppJkRsf+
I1fSxifDFMoEhMA3tN39ruRBcSajBrF7zroElYR6WgTbtcbSPYtxCAJHbjHdJyEB
/XG6bSk4due7Vezl/jKE0ap/hOWXa3qBzfA7rXIWWw+TbvtyYXlHSJHdZZttRH07
gVNcsLhfRBwp8EqbSnUM3WxvVx6xMTsNtKLnu1q4e9YNL69ZbS0MpEIoNBOJJnl9
97WntPF+mgoufsRLvnUFkggxHZu1Q1a0oO4kWezuYmgqvXzoNc+XDvamSJ3LsX0=
=PJGW
-----END PGP SIGNATURE-----

--hjRTvux2945W8dyK--
