Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215FD418A33;
	Tue, 22 Sep 2026 08:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065193; cv=none; b=GQk+8Nw2lK/uaP/CbeUsgaKBCKBZfuvDaoL+3U6YlLAzvJH+ahMaGGBG5dZ8bCLrwXu05XnSJWLDz0XV9VOXXXKefxSRti5Zuy7xzX7/H8ha1y1Zm3Wuy/x3qoeYMIKuarEDUN/hq1naBOe5ONg4Czq2/XeaekEhzAwQNhcifrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065193; c=relaxed/simple;
	bh=NxxW+MwnQxUOfAp3KfVr2VuOhebu99ePea2AwZmEnyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSlo5CltK3jBGgstgIqf+29N+ZXDtpBkjrkKkunE9L2tGWf3Hr7zOu79ebS49dCx/QtWmCQrKliquUqzmbj77vRHVP7VnOcvxurEyyDvgNw26w+p8iGKgEhq16+YOf5mPG1BEfRGvaKKV54M7oTKstd/FGn/eRb+S4mZXWJGyK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oj6dB1Bm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oj6dB1Bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC191F000FF;
	Tue, 22 Sep 2026 08:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790065192;
	bh=NxxW+MwnQxUOfAp3KfVr2VuOhebu99ePea2AwZmEnyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oj6dB1BmKHYgg7PizPzvu9WcKFtaX74zYU6aeDvM/h7b6sdAHmxkMM1YF8zw9/ydh
	 kAIo2SRJeBMoE/+xcRObhIolkxJCJ+5oqPQG9pe9GRBCMIaYQYhlNrkUgomFRJJKFM
	 4zWTjPHXbMKGVdm7II2dLWPOsomxoG3kQFY911pg82xyXJGjrrMDWohvW9m5lPYelU
	 BzT9ADYHWqeybQrKzJb4PL2g7u8hzjX2bsDlHP54+V/cLNalP1ydjLuvT4zrg37Pwt
	 XXT1Doi0+dC8KDhvGSnr4AZRXezjQmzYyAfjGhXvd+kQk2CWxFCl16dQSUxZBHTcKS
	 4bIF+c5CO0iLg==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 060C81AC56A7; Tue, 22 Sep 2026 09:19:48 +0100 (BST)
Date: Tue, 22 Sep 2026 10:19:47 +0200
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
Subject: Re: [PATCH v1 14/17] ASoC: amd: acp3x-es83xx: Switch to use
 acpi_bus_get_primary_device()
Message-ID: <arI6I_BxOtpGOwia@sirena.co.uk>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <2310746.NgBsaNRSFp@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wHQlndWyXpKXz6+B"
Content-Disposition: inline
In-Reply-To: <2310746.NgBsaNRSFp@rafael.j.wysocki>
X-Cookie: Too clever is dumb.


--wHQlndWyXpKXz6+B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 09:54:29PM +0200, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>=20
> Replace acpi_get_first_physical_node() that is slated for removal
> with acpi_bus_get_primary_device() that takes a reference to the
> device it is about to return.

Acked-by: Mark Brown <broonie@kernel.org>

--wHQlndWyXpKXz6+B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqyOiMACgkQJNaLcl1U
h9CBPQf+OX4ZAxsyOFVoLqfS85Wr2AMB3h2WUbbxm4pL+tda7ODHcsiozFiliKvi
HHqVGJzrKF2nwXn5f7fSwL4N/9c/EYmYGdyjEWuv2KUXCd86pGCLwxM2wu7l2wbB
L5v4Hd4hgwQz8DgGGPb/DVlGsiFmOxE+ecb6hfgapJiq7UvMXSDSY7Zsuujzran1
HFazFt4MUr1ZmbeJJXcPBHGJHz7+pVngbiDEiDmugrMwWfiGG6cnPI3UBmd+wFPy
9ss5nBTiAAdXUiWN+E/S2Sf4wlMUiYSDnsV+pXJntMBbBu3NLljdLdrZ8ZLNdsjt
yLyrIm/PLgzKxV9EMoLP5LNqSu5bCw==
=SX0f
-----END PGP SIGNATURE-----

--wHQlndWyXpKXz6+B--
