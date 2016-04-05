From: Mark Brown <broonie@kernel.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure
 notifications
Date: Tue, 5 Apr 2016 11:32:55 -0700
Message-ID: <20160405183255.GH1924@sirena.org.uk>
References: <20160331172935.GL2350@sirena.org.uk>
 <CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
 <20160401140856.GW2350@sirena.org.uk>
 <CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
 <20160402162449.GB2350@sirena.org.uk>
 <CAE1zotKDZd2mYmzoQvCPgVrZ5vfOrPDtBRzTscdsqrZbT8Z+cg@mail.gmail.com>
 <20160404160327.GH2350@sirena.org.uk>
 <CAE1zot+ESGBEYeUbLTreKfkc-6B45uQq3PWhhRfBo1AWd-7Vxw@mail.gmail.com>
 <CAJZ5v0gV8N6zgVrwtRFaY98Wv1HsoKs+4=U-s_V29FSpCdFW3g@mail.gmail.com>
 <CAE1zot+wvU_he-6cFQi1np9X1=FcXWoF-mbxYDRYUkyOT+7nyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="X+8siUETKMkW99st"
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE1zot+wvU_he-6cFQi1np9X1=FcXWoF-mbxYDRYUkyOT+7nyQ@mail.gmail.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org


--X+8siUETKMkW99st
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 05, 2016 at 02:49:13PM +0300, Octavian Purdila wrote:

> If we really want to have a single path for ACPI enumeration we could
> do that by using an ACPI SPI bridge driver or scan handlers after
> extending the matching mechanisms. But we would still need to modify
> the SPI subsystem and I don't think its worth it just to save a call
> to acpi_register_spi_devices() from spi_register_master().

It's not specifically for SPI, it's the fact that you're asking every
single bus type which might be described in ACPI to handle both hotplug
and coldplug paths separately.  Given that the code that's being added
just seems like trivial boilerplate it seems like we're doing this
wrong, we should be factoring this out so there's nothing bus types can
get wrong.

> Now for parent notification complexity: in the case of SPI we can
> easily to this because current ACPI SPI enumeration supports only
> direct children as slaves. However, on I2C we can have an unrelated
> node as a slave - that is why the I2C scanning searches the whole
> namespaces for references to a particular i2c_adapter. So, we would
> need to retrieve the parent node from the namespace node information
> which means that we will do SPI specific stuff in ACPI generic code. I
> don't think it is a big issue, because we already treat SPI / I2C
> special, right?

Or perhaps the issue is that we can't make our mind up if the bus
specific code should go in the bus or in the ACPI core?

--X+8siUETKMkW99st
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXBATWAAoJECTWi3JdVIfQXl4H/0BzWIDQKWOqLzpt7x5yOPOl
QkkiK0BMXoGfMwzvb6ykmztzT0zkkfFGCCPS3EpGC7TZWQOIaniKavxDyVl0tYo2
0/em4gdafI11N3uns6MCsnP/JU2frcJqoNHdPc0PlrOcFy3aQbwm9Uw/Ya2uFNZJ
hhKRX5lym6Pp+3kwFnZSAp+GCvn8cw2wv+AnnrPZY5K4efDY9jUS34NedT9NvywR
fZAH72ZuoLwK+dpx1fkPrJg3o71h+nlGm5lEKG+VKfQUcnEBcoTxXJm5CE66emVp
cpPs921uqQJPGCwNxuG6L7pPu048F8FdJc29DOVZ8sX3CX0nuSsr8TfTQXtHIAg=
=MLeI
-----END PGP SIGNATURE-----

--X+8siUETKMkW99st--
