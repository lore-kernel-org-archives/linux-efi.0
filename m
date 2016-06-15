From: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH v3 4/8] i2c: add support for ACPI reconfigure
 notifications
Date: Wed, 15 Jun 2016 08:27:24 +0200
Message-ID: <20160615062724.GB1344@tetsubishi>
References: <1465917446-14043-1-git-send-email-octavian.purdila@intel.com>
 <1465917446-14043-5-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465917446-14043-5-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com
List-Id: linux-efi@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 14, 2016 at 06:17:22PM +0300, Octavian Purdila wrote:
> This patch adds supports for I2C device enumeration and removal via
> ACPI reconfiguration notifications that are send as a result of an
> ACPI table load or unload operation.
>=20
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>

What happened to Mika's reviewed-by?


--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXYPVLAAoJEBQN5MwUoCm2H+YP/icKyBrRnXDb3VCEr7M94uUe
1YoXPA6NWoXZnngjrtz2n6+KzvBk/nRDxpChWfpXMYyiHm0jGc9kiS+9DkPlLilO
M48h5bBMf0bE2vyc0eysUZJt++brFQHy6ADvvVTyItSDw2cg0Cuyza2IqgENFu5q
KMkMRXYF5r2ZodeUQrRJ/IUPnmkYyCThYyMq+rEFkTBm8M9PFqdInwSGpyJiBq2m
ZZADJtwxy/6OVYVoJsPuNwGS8FIuKz1t8PyFmg4LCDGA+UOO8o6uFP6oAzMGi1ll
q6CjafFfAwE0oHbCopGEzj3mt+d258SEfQ1SZdUNo4tOFx5bkT1bTONZOyxxXt6b
27BI86nWz8sTjqmwM8KR5ExXd+Fr7sQS5L7X4vLNcJn6aLinp3lyt6g2eKmcmqfX
38YNhmfF+tFCrc5lB21NDn6JU/IfhKg8XginM1LTYzf9TEg0mYrVdPmisnaPKD7y
Hg0L4HWAE7Ox1/c5AOkg6w2w4q7jiZn9Ijizv/s5QjKvj/BQUxxu/4g3nxcvIDsi
gJFi7BQsPCaiLFjJuLrWAqNznugNuoMbcotx5Eoj1K03Od9/XRaoNX64MhZCFY5j
TY2hZS4dkUVwhFaIjoRfLXLSilxEtsUd2ZVLWMJ9wEJOZ6OkI1ApMcklceEUHOi+
NBfzjjHv9Ag5RhaIfv0+
=1jmD
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
