Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F7841A4EE;
	Tue, 22 Sep 2026 08:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065221; cv=none; b=H3gg381ZnIg2zCrdO8DA8Wly2aUXGPh6o/+uckIEIR1lfBNr8KfLrNqxCH5831/JxspeIocEwcprNvw2Tc2K6qo9fwcCa9pVEpyk3gEScvftxmbpuSNoLemigp2HiVAUDxfH9V1CvoeGJuaiPW0y0v/JmG1oaP+wDLb5kr/t6lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065221; c=relaxed/simple;
	bh=MjXcqMOa9aaX+GA+SOvHHXfb0ZNPyUilydrg52FvFzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wg4tL5GsjWuwCExZSpH3boFaBHSue187xnOaVwCCAP/j1ukYcgqo/Yed05qA+4rHYggX/7PieESdX2Fewafc3AKKEeI5PM5HD7gonZa9geyWkFE27XlTFgdK8Lrw/+tWk8Lszw8FNjvpt2uN46JAmjwwe3RQ8CAT+LXU0KCcUK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BHq0Ufby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BHq0Ufby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14B81F000FF;
	Tue, 22 Sep 2026 08:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790065220;
	bh=MjXcqMOa9aaX+GA+SOvHHXfb0ZNPyUilydrg52FvFzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BHq0UfbyfXC3CsFAWicoq8LHwkSmHcsYAHHGrfrWMUyluipj6vz6ijaTKolEMEM1J
	 Nw8k+knsmJKNBRA0PAh/aY26f2NBhp5/aYkikclayWzHwHIKNNDcK/2EkY4trtOhBT
	 zoNVU4xcJ973Tkh3rx1h2rz0/771pIacFf/zqW3Bq9+jeM8Nw0JK7LljbNJFNK4a89
	 clh1tMUeIjQoeS+//Z73TU2t1RIYck6Ikwa62GNdjCklIlnBTsJuKZB9HX2mNY9qzj
	 DeAwnCjRTpAyMZqU3sUXq4XjlK6DCkJGm4iAhJeAf97OpVmO74+NjYahdp9yWQj67s
	 ielpV/G+29gtQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 765281AC56A7; Tue, 22 Sep 2026 09:20:16 +0100 (BST)
Date: Tue, 22 Sep 2026 10:20:16 +0200
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
Subject: Re: [PATCH v1 15/17] ASoC: intel: boards: Switch to use
 acpi_bus_get_primary_device()
Message-ID: <arI6QPLCu5zU0N3j@sirena.co.uk>
References: <7995179.EvYhyI6sBW@rafael.j.wysocki>
 <15844908.tv2OnDr8pf@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="F5HyqqGHFH+LIPBo"
Content-Disposition: inline
In-Reply-To: <15844908.tv2OnDr8pf@rafael.j.wysocki>
X-Cookie: Too clever is dumb.


--F5HyqqGHFH+LIPBo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 09:55:15PM +0200, Rafael J. Wysocki wrote:
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>=20
> Replace acpi_get_first_physical_node() that is slated for removal
> with acpi_bus_get_primary_device() that takes a reference to the
> device it is about to return.

Acked-by: Mark Brown <broonie@kernel.org>

--F5HyqqGHFH+LIPBo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqyOj8ACgkQJNaLcl1U
h9Bx+Qf/XQKqT8zAAypC4QDplX84kvvsAuOBYTwqfb7dF3Dw7ytXEeNRU3I4BLOm
WtgQ9XPLDynBgy2oYWyeQrAXf+LILRzJzH5IOT4uSkKBpqhZPlKLiN5IOaI533yf
CXEY+C5CQJc8f7RGWm5TZvjJ0yFdUsaHKwiW4NY+znI0ff4cytSD5pbOIg0e4apq
sYDmAXVgOBOff0Brn55XAi9P3Do1BuMdCfESVLVGIUrJtVJ4ivqwCU9TYBEE3moe
6zNf5I9zG/zB+mrTrIMccaCakwoEuBlSTod32q6bobVfYweKmudduwme+sjVtS3t
1uijSSXPHA4q8BFE/4fF7SM1yeWNnQ==
=4Q3T
-----END PGP SIGNATURE-----

--F5HyqqGHFH+LIPBo--
