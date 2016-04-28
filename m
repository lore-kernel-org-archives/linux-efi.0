From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH v2 06/10] spi: add support for ACPI reconfigure
 notifications
Date: Thu, 28 Apr 2016 18:42:15 +0100
Message-ID: <20160428174215.GS3217@sirena.org.uk>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
 <1461105548-20618-7-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Fbmjlltyndrrs22i"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1461105548-20618-7-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--Fbmjlltyndrrs22i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 20, 2016 at 01:39:04AM +0300, Octavian Purdila wrote:

> +	switch (value) {
> +	case ACPI_RECONFIG_DEVICE_ADD:
> +		master = acpi_spi_find_master_by_adev(adev->parent);
> +		if (!master)
> +			break;
> +
> +		acpi_register_spi_device(master, adev);
> +		put_device(&master->dev);
> +		break;
> +	case ACPI_RECONFIG_DEVICE_REMOVE:
> +		spi = acpi_spi_find_device_by_adev(adev);
> +		if (!spi)
> +			break;

There's more code here now than I remember but this all looks *really*
close to the DT code except for the OF_POPULATED flag that we set when
things are instantiated in DT.  The duplication seems bad but the fact
that we're missing the flag worries me...  do we have guarantees that
ACPI won't double register?

--Fbmjlltyndrrs22i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXIkt2AAoJECTWi3JdVIfQpzsH/1n7hl+pE1kFRXGcgoE4Nfpc
owPTtbAhGra2SXpf0bg9kFHrkidpshYpNMp2I5bBma1pr97xWvWVkksUNCb+zD/X
97x+eOBfVXAogdmrcorGbBWgF5Q/2o55oED9jPlHAufF7yXJhvxCrtD7hE2qWaEj
xlvLE9w5BGmVQpg03emG/PIYVCV5LcFzmuA3UbYCe1uEp/xUb2IJbFm+6y2urIAw
TN0/+aG5eRl+E90omFsswtCbSBtGVa8+HCPt135FxBCYuLz/FnaORmSKV2tjPMWF
YcsnscsJODp550pbAtCGoOAjj6oZAnMZwx6gn7chT0r1unSBzp9ukUhSCLsmlDc=
=oKzG
-----END PGP SIGNATURE-----

--Fbmjlltyndrrs22i--
