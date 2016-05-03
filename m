From: Mark Brown <broonie@kernel.org>
Subject: Re: [RFC PATCH v2 06/10] spi: add support for ACPI reconfigure
 notifications
Date: Tue, 3 May 2016 13:19:54 +0100
Message-ID: <20160503121954.GQ6292@sirena.org.uk>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
 <1461105548-20618-7-git-send-email-octavian.purdila@intel.com>
 <20160428174215.GS3217@sirena.org.uk>
 <CAE1zot+LuQJGrDrEDM2iVv-omz3Sg6k3bavX+5gde8jzrK0pog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="63aIh6YiuHX+oBFP"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE1zot+LuQJGrDrEDM2iVv-omz3Sg6k3bavX+5gde8jzrK0pog@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi <linux-spi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org


--63aIh6YiuHX+oBFP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 28, 2016 at 10:37:57PM +0300, Octavian Purdila wrote:
> On Thu, Apr 28, 2016 at 8:42 PM, Mark Brown <broonie@kernel.org> wrote:

> > There's more code here now than I remember but this all looks *really*
> > close to the DT code except for the OF_POPULATED flag that we set when
> > things are instantiated in DT.  The duplication seems bad but the fact
> > that we're missing the flag worries me...  do we have guarantees that
> > ACPI won't double register?

> We use the adev->flags.visited to check when a device has been already
> enumerated, and we skip registering a new SPI slave in that case.

OK, but the fact that I need to know that isn't exactly thrilling -
that's really the issue with the not quite duplication here.  It's not
just if the code works but also the maintainability.

--63aIh6YiuHX+oBFP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXKJdpAAoJECTWi3JdVIfQObEH/jbLM9WkPdnF2TwM8vv7uEYA
BF8GSfNudKnU9rmzDcbbDiwqulQ3lU6ZqUQMjTMBmzVVS/QuPXwgp/DOf4cvng1s
pkej8hSOVOMsg95OMCqWHNcZbXyHbKnQw6RKOUT84QyUVsSItzg9I670feYGQBnA
4/YIZ0Yl01YZgy8CTeuXUAIXm7vMNQ3vNvdqbXuqakAznwWuEwI9H3FyhtkS/Pe9
o8hQXo3G7r86FyaqhASl33lOaGOZvUnyKqovtfkHjYqJXRTGI18HSX2un4zy74h7
vHBUv0jpqKYcwQmsn8xDPZO60BoTwZttj9gh5eVaWX7fULahQfoK2+GuVKXHBHc=
=JZy9
-----END PGP SIGNATURE-----

--63aIh6YiuHX+oBFP--
