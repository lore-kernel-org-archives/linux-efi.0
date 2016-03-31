From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure
 notifications
Date: Thu, 31 Mar 2016 10:29:35 -0700
Message-ID: <20160331172935.GL2350@sirena.org.uk>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
 <1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vYlOGI1a8wP+YbIl"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1459417026-6697-7-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--vYlOGI1a8wP+YbIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 31, 2016 at 12:37:02PM +0300, Octavian Purdila wrote:

> +#if IS_ENABLED(CONFIG_ACPI)
> +static int acpi_spi_table_load(struct device *dev, const void *data)
> +{
> +	struct spi_master *master = container_of(dev, struct spi_master, dev);
> +
> +	acpi_register_spi_devices(master);
> +	return 0;
> +}

Why do we have a separate code path for this coompared to the initial
startup?  The handling appears to be identical so it seems we should
drive this from the ACPI code so we don't have to add this to every
single bus with ACPI bindings.

--vYlOGI1a8wP+YbIl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJW/V50AAoJECTWi3JdVIfQaYwH/1w1D1N5NRZxoG8yE8B48DU6
dPRkmhxGlcoz5A0COfqjPMbEdccEcSod1bNjAzoBdIElblKWkpqakv55oLU81Gbc
mkVkVVusnB7QGrc9dsw9PY2ydDlP4CM9UWcxPUa3SHGnS0L2fUy82Vq5rkc5Fss4
8vW8W6GSVRGfATDsZlLegCP4GiKCEO68EbqZXm2gXQEQuphn4dRGHc+Wk+1hfMiF
VGt1hVL/edlU8EDRGeLYN548OYrkbRPQjkq1YI2+JmYj3mRO8/vDj60hvajQ04hd
3mQcwrkNAXn+6vmgl8ZP+FiFAHcUpxHB3Py5djkRqPfuN9HdSzstJleGX4VtvuA=
=57Lr
-----END PGP SIGNATURE-----

--vYlOGI1a8wP+YbIl--
