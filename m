From: Mark Brown <broonie@kernel.org>
Subject: Re: [RFC PATCH 06/10] spi: add support for ACPI reconfigure
 notifications
Date: Mon, 4 Apr 2016 09:03:27 -0700
Message-ID: <20160404160327.GH2350@sirena.org.uk>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
 <1459417026-6697-7-git-send-email-octavian.purdila@intel.com>
 <20160331172935.GL2350@sirena.org.uk>
 <CAE1zotJbUGBOUF-4-XAx0DUkj55egOMXVn9FzjV3Fdj4MYxD0Q@mail.gmail.com>
 <20160401140856.GW2350@sirena.org.uk>
 <CAJZ5v0itmFDdPi6vJmsheEHADEwmeTNgCQ5iVroJfV=o6Wof3A@mail.gmail.com>
 <20160402162449.GB2350@sirena.org.uk>
 <CAE1zotKDZd2mYmzoQvCPgVrZ5vfOrPDtBRzTscdsqrZbT8Z+cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GH2w3bbsGmSMo31z"
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAE1zotKDZd2mYmzoQvCPgVrZ5vfOrPDtBRzTscdsqrZbT8Z+cg@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Wolfram Sang <wsa@the-dreams.de>, Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, linux-efi@vger.kernel.org, linux-i2c <linux-i2c@vger.kernel.org>, linux-spi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Irina Tirdea <irina.tirdea@intel.com>
List-Id: linux-efi@vger.kernel.org


--GH2w3bbsGmSMo31z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 04, 2016 at 01:25:56PM +0300, Octavian Purdila wrote:
> On Sat, Apr 2, 2016 at 7:24 PM, Mark Brown <broonie@kernel.org> wrote:

> > What I don't understand is why the flow on inital probe isn't simply to
> > register the controller which then triggers the walk of the children.
> > That way any bus that supports initial probe also supports hotplug
> > without needing to go and manually add a second code path.

> Do you mean register the notifier per controller instead of per
> subsystem? Either way we need changes at the subsystem level and I
> choose to follow the device tree implementation for consistency.

No!  I mean use the exact same callback you've got now for everything.

> The other reason is that (pending other ACPICA changes) we can add
> other notification events in the future such as node added or removed
> (just like device tree), and in that case the probe and hotplug
> handling would be different (and a bit more efficient).

Why is probe different to hotplug?  We don't need to do that in the
normal driver model.

--GH2w3bbsGmSMo31z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXApBKAAoJECTWi3JdVIfQi4UH/0n5ctuTiNy19NukG3EILHSB
mD92PAk3ysfpgYqCY3v+x0V3UiEhbhDIflrSpi0IiKIaMu8M+7K3gJKjeVo1Jd6b
JSKVE0lsLzXkM9cQs7nE/eg0zXcpSx/uHE5ilfxZsZpPcaWG0demluZmHDtAczKb
saOInORaXf5JtzjVlwHWa001SFRSRuDciSCRZS9lm5XHjgFgzlXLrMbA3tbsHh1W
pKVnoddslbAL8DDxZU59NtizJhc9HTA74JIG50ZqNRgsb1aa8cD+ez3drA5pnLMD
AVLhHy5IwWjCKVf3CphJAEYXKdWiLYekFZpnFVDVelzQ7qt4IyKYG+x80S/rIJU=
=fMiN
-----END PGP SIGNATURE-----

--GH2w3bbsGmSMo31z--
