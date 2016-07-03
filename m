From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 5/8] spi: add support for ACPI reconfigure
 notifications
Date: Sun, 3 Jul 2016 14:10:49 +0200
Message-ID: <20160703121049.GM6247@sirena.org.uk>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
 <1467404352-27101-6-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="N/EvDld9rH7KvG42"
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467404352-27101-6-git-send-email-octavian.purdila@intel.com>
Sender: linux-i2c-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com
List-Id: linux-efi@vger.kernel.org


--N/EvDld9rH7KvG42
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 01, 2016 at 11:19:09PM +0300, Octavian Purdila wrote:
> This patch adds supports for SPI device enumeration and removal via
> ACPI reconfiguration notifications that are send as a result of an
> ACPI table load or unload operation.

Acked-by: Mark Brown <broonie@kernel.org>

--N/EvDld9rH7KvG42
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXeQDCAAoJECTWi3JdVIfQCogH/iI53CIKhH7n1rZmVFEhPqXL
1I1PeKA1D9kcDMCgQKE3TJ1xw2+PxwQAtrb1HrBual7vkKFcq+idl5dh3T+mZnFT
qPFdiPiZYBwaVQ+7mBD5pG/DcutRs2bFA89bvqBRtSjrTgQfZO/GI4LpVLFsAukg
KSLdl4OnS9RbZHiaaoeAe/pSmTKz8V3vv+SrQbsXz9ZPMusLkQ/RhqS6+CBJYdlt
TvQPTXjjzqhgVMxcJxAbO9Vj4jjLkEeF3/ShtNdl6nWJm5+bmOfafIIBxm99WAC1
V/UVA3Ul2lHrR0rQjrxCaTq+6cTxpOzjtJI42IDD6GM+CZ5AcN9AZ1GgHChEwYY=
=mWKT
-----END PGP SIGNATURE-----

--N/EvDld9rH7KvG42--
