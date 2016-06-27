From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 5/8] spi: add support for ACPI reconfigure
 notifications
Date: Mon, 27 Jun 2016 15:17:13 +0100
Message-ID: <20160627141713.GW28202@sirena.org.uk>
References: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
 <1466164336-9508-6-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="XGH+X5Sk6wksXc5a"
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466164336-9508-6-git-send-email-octavian.purdila@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com
List-Id: linux-efi@vger.kernel.org


--XGH+X5Sk6wksXc5a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 17, 2016 at 02:52:13PM +0300, Octavian Purdila wrote:

> This patch adds supports for SPI device enumeration and removal via
> ACPI reconfiguration notifications that are send as a result of an
> ACPI table load or unload operation.

I still have the same concern I've had all the way through here: this is
very similar to the equivalent DT code but not quite, especially in
regard to the OF_POPULATED flag which has no ACPI equivalent.  This
gives us ACPI code which just looks like it's missing something.  I'd
like to see the comparison at least covered in the changelog so people
have something to refer to in future when trying to understand why
things are done this way.

--XGH+X5Sk6wksXc5a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXcTVoAAoJECTWi3JdVIfQ1NkIAICLFrq20hSWhgkKNPVK2Fxu
ZlIUEeByk4Ko38eN/9XzEXP3JrQC5iIOe7or4AneoEpS2urUPg91Ozx0ylZUBzwV
8SLbS3mvDTJ/skvMbC/zbBsLgMiJ8MjFGQbYvE622sgFup+bQ+v070l9fmCmB/MX
NqeJO+LKISe68MA6fugIl6cgj2TR9ngvBbrc/tUFl2FXwzyd0yp14MM3uEHpMBSX
A097r6EHZTzYQXe3C7V646BHlW2tm8EIi/j1xa5i6ssI+g1SB3Q0TbwOELN7jJ1W
49rA7hTrS5HsUhlYTqE2xyXXg9sMuP94Nf77qNFsFrYdJBkBw/sffitdCvOY28Q=
=ikos
-----END PGP SIGNATURE-----

--XGH+X5Sk6wksXc5a--
