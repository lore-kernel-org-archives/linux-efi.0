From: Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH v5 4/8] i2c: add support for ACPI reconfigure
 notifications
Date: Mon, 4 Jul 2016 09:34:15 +0900
Message-ID: <20160704003414.GB1381@tetsubishi>
References: <1467404352-27101-1-git-send-email-octavian.purdila@intel.com>
 <1467404352-27101-5-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467404352-27101-5-git-send-email-octavian.purdila@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com
List-Id: linux-efi@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 01, 2016 at 11:19:08PM +0300, Octavian Purdila wrote:
> This patch adds supports for I2C device enumeration and removal via
> ACPI reconfiguration notifications that are send as a result of an
> ACPI table load or unload operation.
>=20
> The code is very similar with the device tree reconfiguration code
> with only small differences in the way we test and set the enumerated
> state of the device:
>=20
>  * the equivalent of device tree's OF_POPULATED flag is the
>    flags.visited field in the ACPI device and the following
>    wrappers are used to manipulate it: acpi_device_enumerated(),
>    acpi_device_set_enumerated() and acpi_device_clear_enumerated()
>=20
>  * the device tree code checks of status of the OF_POPULATED flag to
>    avoid trying to create duplicate Linux devices in two places: once
>    when the controller is probed, and once when the reconfigure event
>    is received; in the ACPI code the check is performed only once when
>    the ACPI namespace is searched because this code path is invoked in
>    both of the two mentioned cases
>=20
> The rest of the enumeration handling is similar with device tree: when
> the Linux device is unregistered the ACPI device is marked as not
> enumerated; also, when a device remove notification is received we
> check that the device is in the enumerated state before continuing
> with the removal of the Linux device.
>=20
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

It has Mika's ack already, but to make sure:

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXea8FAAoJEBQN5MwUoCm2gsYP/ifulwtMHVRioaK+UNuc2jDz
S/swdbsc1HJYOy59m6SjOQOnG+qxJX1JSIfNFsKeUnNvyoeGki8sddKwZpuzv0qY
t0HZkgTNuNfv7oxmL3/GmTQHHZyfqEuIkn41DQXHDaShFzzWohAndHIWVUaLdfBC
BGHOwCJkeouke+/I13/Ro3DhyEKkx4NqKz5tbw0Va+o60ntR6mcDv0DNnNHa7qdA
gtG6M/rhGmDKEbF72LgAITonEycKtdJrjL/BxyBEDxlhxDDPWl2dkMNQgbwKDuBa
9ofYKT5Vze5TyYAHnEHwvAoyBDUvK8UyECH3f/Fd5sUAE5IIuSatXcUFJIcHoRJa
9Z7oRvrp3q/Fcm71n4+z5YJHH9yKuVpJ1QzpnwmpxKNOxh081ifAqn0WCtbnWj9d
Ds4P0SMdLU7MGr62T8tOkC8jJwsbpzzdZrJvk6+ppR+Iruq6/JjYBcFhmzeCqKt9
8cWpLBJUUYyTuMxZR6oSP4OFKoTVPsxK1K8aSDZHBI1lQGK4jNxRySFrUNCksKCk
dxyFFDgFXY/5MZrbp/54d1w15ncuvjUyyFkkVc/+1DcG/LAfe2thKl//RngIbvR7
wQIQzffZN+EX/epKzvb/4TH2G9PIPgqFow8sqoQnTqynNzaYWH4jBtQycBjqrCtU
oTIYNMfU88Lrhhz/AuMA
=WWwN
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
