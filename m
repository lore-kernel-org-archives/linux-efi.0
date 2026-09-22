Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7C7418A33;
	Tue, 22 Sep 2026 08:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065250; cv=none; b=V6pOI/3DkZ2TEucaj5GY/kxCYo5GQsVJF5DL93YVRYL7k7I18i0EHFhh1FB+Eke9dwSln3CkfqcpjARbkIRZMoyvX8zhwKbzQJsn9T21u8qVYlrZb7SkBkEI1Za6U2AYIyy/gnrhWfINYEKkCjnBMoyynW8dCKF5/zHgW3MJ1rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065250; c=relaxed/simple;
	bh=0IORuiq+y7bk4+ibcdt0oVfIzdyoZqyiyPnSEWbGyQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LS7ThRaYWpMUck7W6jNG/16HjnTRAkDNcqvIOYvMyuJrOA1mbRSCopHuceLwhD74wJcGrl4/zI4I8k9qDv5ASBD2QFoex6fm+nSZfZzLamyMBJVumYlIi9CVyRj9BWALRl9reB/tuLWT08ZZ1XtHhC4CkjbsaPRl88tu2T1mHoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYhnLHaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYhnLHaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0031F000FF;
	Tue, 22 Sep 2026 08:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790065248;
	bh=0IORuiq+y7bk4+ibcdt0oVfIzdyoZqyiyPnSEWbGyQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iYhnLHaZoo+UgLgpJ3WSIc07Kf408OFArco3q9ul+K9KDCpP8da4Zf3BjgvfmoCzX
	 P1pKGzazd/Xsm7mOkuD/BEaxBkzHN6Z2SsGZwk2P2Vliqp6mHUr/mSYAgvN3AvPyNi
	 azukjnjjKv2QaCei2fF3iRnW9bgkK7q4UZS5+1pAkiMsAhVKpsvwS0LZe8V0XUHqVs
	 BaYnC9YvVfP5VHBRsZntUEKc6XrIS2oOb3dcPUCuvY/LEnh4/VNisgfa5bfk/6/Z6X
	 UxAxHaCFxpL89oHqCm8t36uwsybKmFPA5tj3DlpwM286wv7wBBQC3trIMsij851wPt
	 BcoJLqyFxdGxA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id C2E741AC56A7; Tue, 22 Sep 2026 09:20:44 +0100 (BST)
Date: Tue, 22 Sep 2026 10:20:44 +0200
From: Mark Brown <broonie@kernel.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	platform-driver-x86@vger.kernel.org,
	David Rhodes <david.rhodes@cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	linux-sound@vger.kernel.org, Shenghao Ding <shenghao-ding@ti.com>,
	Kevin Lu <kevin-lu@ti.com>, Baojun Xu <baojun.xu@ti.com>,
	Sen Wang <sen@ti.com>, Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Andreas Noever <andreas.noever@gmail.com>,
	Mika Westerberg <westeri@kernel.org>,
	Yehezkel Bernat <YehezkelShB@gmail.com>
Subject: Re: [PATCH v1 16/17] ASoC: loongson: Switch to use
 acpi_bus_get_primary_device()
Message-ID: <arI6XGheDLqcM5h2@sirena.co.uk>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <2796562.BddDVKsqQX@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vZ4DAFp8EW84+teb"
Content-Disposition: inline
In-Reply-To: <2796562.BddDVKsqQX@rafael.j.wysocki>
X-Cookie: Too clever is dumb.


--vZ4DAFp8EW84+teb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 09:55:56PM +0200, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>=20
> Replace acpi_get_first_physical_node() that is slated for removal
> with acpi_bus_get_primary_device() that takes a reference to the
> device it is about to return.

Acked-by: Mark Brown <broonie@kerenl.org>

--vZ4DAFp8EW84+teb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqyOlsACgkQJNaLcl1U
h9BVVgf+NHmKV8A+2Q/nOEOuw2I3+zdga+JgwoRwtArRjRtR+bVOUgnM+X/kaToi
CsUmvFtABRvEvzsgqGvp4PTPNYf8n3gJGHJfEOM+3EsqZpBX/cvoantUcu48VFYe
IkWVDka+uVjmEIHEeeSNWHd0+ZCFDuHqcvKpaPYsnv88TamcFUzsTYrkVgvMUJGy
fW4sEBYc4XGr/FqvffKLTO5E2CAQ/qhiXn3cFFMvadcm6YY2bEicWLlz7sKlcOmG
vkD//KecfKS8WmW3l9OYlCpUxTDA17e/ntdmTrBa4BHSP5wMGsS4Mf9qzQ9u6fUb
BR+eawjJR4XvFkhhblvxCW80tj3pIQ==
=FR2A
-----END PGP SIGNATURE-----

--vZ4DAFp8EW84+teb--
